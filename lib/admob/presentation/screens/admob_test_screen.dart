// 📁 파일 위치: lib/admob/presentation/screens/admob_test_screen.dart
// 🧪 AdMob 기능을 테스트할 수 있는 화면
// Study와 Review 버튼을 눌러서 카운터와 전면광고를 테스트해요
// screens 폴더는 완성된 화면들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterexampleiosatt260607/admob/presentation/providers/admob_state_provider.dart';

import '../../core/admob_platform_checker.dart';
import '../../core/constants/admob_constants.dart';
import '../../model/admob_context_model.dart';
import '../providers/admob_initialization_provider.dart';
import '../widgets/admob_action_button_widget.dart';
import '../widgets/admob_banner_widget.dart';
import '../widgets/admob_counter_widget.dart';
import '../widgets/admob_reset_button_widget.dart';

class AdMobTestScreen extends ConsumerWidget {
  const AdMobTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initStatus = ref.watch(adMobInitializationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob 테스트'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // 간단한 카운터 표시 (오버플로우 방지)
          Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(adMobStateProvider);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: Text(
                    'S:${state.studyCount} R:${state.reviewCount}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // 🔧 mainAxisSize를 min으로 변경 - 내용물 크기에 맞춤
          mainAxisSize: MainAxisSize.min,
          children: [
            // AdMob 초기화 상태 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: initStatus.when(
                data: (isInit) => isInit ? Colors.green.shade50 : Colors.red.shade50,
                loading: () => Colors.orange.shade50,
                error: (_, __) => Colors.red.shade50,
              ),
              child: Column(
                children: [
                  Text(
                    initStatus.when(
                      data: (isInit) => isInit ? '✅ AdMob 초기화 완료' : '❌ AdMob 초기화 실패',
                      loading: () => '🔄 AdMob 초기화 중...',
                      error: (_, __) => '❌ AdMob 초기화 오류',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: initStatus.when(
                        data: (isInit) => isInit ? Colors.green.shade700 : Colors.red.shade700,
                        loading: () => Colors.orange.shade700,
                        error: (_, __) => Colors.red.shade700,
                      ),
                    ),
                  ),
                  if (initStatus.hasError || (initStatus.hasValue && !initStatus.value!))
                    Text(
                      'main.dart에서 MobileAds.instance.initialize() 필요',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                      ),
                    ),
                ],
              ),
            ),
            // 플랫폼 정보 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.blue.shade50,
              child: Column(
                children: [
                  Text(
                    '현재 플랫폼: ${AdMobPlatformChecker.isIOS ? 'iOS' : 'Android'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    AdMobPlatformChecker.isSupported ? 'AdMob 지원됨' : 'AdMob 지원 안됨',
                    style: TextStyle(
                      color: AdMobPlatformChecker.isSupported ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 환경 정보 추가 표시
                  Text(
                    '환경: ${AdMobConstants.environment.toUpperCase()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AdMobConstants.environment == 'test' ? Colors.orange : Colors.green,
                    ),
                  ),
                  Text(
                    AdMobConstants.environment == 'test' ? '⚠️ 테스트 광고 사용 중' : '✅ 실제 광고 사용 중',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            // 배너 광고 영역
            AdMobBannerWidget(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '📚 AdMob 카운터 테스트',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 📊 상세한 카운터 정보 표시
                  AdMobCounterWidget(isVertical: false),
                  const SizedBox(height: 16),

                  // 🆕 시뮬레이터 안내 추가
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '📱 시뮬레이터 vs 실제 기기',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '• 시뮬레이터: 광고가 안 나올 수 있음\n• 실제 기기: 광고가 정상 표시됨\n• 테스트 권장: iPhone/Android 실기기',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🆕 네트워크 에러 해결 가이드
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: const Column(
                      children: [
                        Text(
                          '⚠️ 네트워크 에러 해결 방법',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '1. 인터넷 연결 확인\n2. 실제 기기에서 테스트\n3. AdMob 계정 설정 확인\n4. 테스트 광고 ID 사용',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Study 버튼 (3번마다 전면광고)
                  AdMobActionButtonWidget(
                    text: 'Study 완료 (3번마다 광고)',
                    contextType: AdMobContextType.study,
                    location: 'TestScreen_Study',
                    onPressed: () {
                      print('🎯 Study 버튼 클릭됨');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Review 버튼 (5번마다 전면광고)
                  AdMobActionButtonWidget(
                    text: 'Review 완료 (5번마다 광고)',
                    contextType: AdMobContextType.review,
                    location: 'TestScreen_Review',
                    onPressed: () {
                      print('🎯 Review 버튼 클릭됨');
                    },
                  ),
                  const SizedBox(height: 32),

                  // 카운터 리셋 버튼
                  AdMobResetButtonWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
