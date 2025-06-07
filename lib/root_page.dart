// 📁 파일 위치: lib/root_page.dart
// 🏠 실제 앱의 메인 페이지
// ATT 권한 허용 후 사용자가 이동하는 실제 앱 화면이에요
// 플랫폼별로 다른 정보를 보여주고, AdMob 테스트 버튼도 추가했어요
// 안전한 네비게이션 처리가 강화되었어요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admob/presentation/widgets/admob_safe_widgets.dart';
import 'att/core/att_platform_checker.dart';
import 'att/presentation/providers/att_status_provider.dart';

class RootPage extends ConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isATTAuthorized = ref.watch(isATTAuthorizedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('메인 페이지'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 환영 메시지
            const Text(
              '🎉 앱에 오신 것을 환영합니다!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 플랫폼 정보 표시
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ATTPlatformChecker.isIOS ? Icons.phone_iphone : Icons.android,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '플랫폼: ${ATTPlatformChecker.isIOS ? 'iOS' : 'Android'}',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ATT 권한 상태 표시 (플랫폼별로 다른 메시지)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: _getStatusColor(isATTAuthorized).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getStatusColor(isATTAuthorized),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getStatusIcon(isATTAuthorized),
                    color: _getStatusColor(isATTAuthorized),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _getStatusMessage(isATTAuthorized),
                      style: TextStyle(
                        color: _getStatusColor(isATTAuthorized),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 🆕 AdMob 테스트 버튼 추가! (안전장치 강화)
            ElevatedButton(
              onPressed: () async {
                try {
                  print('🎮 AdMob 테스트 버튼 클릭됨');

                  // 현재 컨텍스트가 유효한지 확인
                  if (!context.mounted) {
                    print('⚠️ 컨텍스트가 마운트되지 않음');
                    return;
                  }

                  // 안전한 네비게이션 시도
                  try {
                    print('🚀 AdMob 테스트 화면으로 이동 시도');

                    // 방법 1: Named route 시도
                    await Navigator.pushNamed(context, '/admob').catchError((error) {
                      print('❌ Named route 실패: $error');
                      throw error;
                    });

                    print('✅ AdMob 테스트 화면 이동 성공 (Named route)');
                  } catch (e) {
                    print('⚠️ Named route 실패, 대체 방법 시도: $e');

                    // 방법 2: MaterialPageRoute 직접 사용
                    try {
                      // 동적 import를 위한 지연 로딩
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            try {
                              // AdMob 화면을 안전하게 로드
                              return const AdMobTestScreenSafe();
                            } catch (e) {
                              print('❌ AdMob 화면 로드 실패: $e');
                              return const AdMobErrorScreen();
                            }
                          },
                        ),
                      );
                      print('✅ AdMob 테스트 화면 이동 성공 (MaterialPageRoute)');
                    } catch (e) {
                      print('❌ MaterialPageRoute도 실패: $e');

                      // 방법 3: 에러 메시지만 표시
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('AdMob 테스트 화면을 열 수 없습니다'),
                            backgroundColor: Colors.orange,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  }
                } catch (e, stackTrace) {
                  print('❌ AdMob 버튼 전체 동작 중 오류: $e');
                  print('스택 트레이스: $stackTrace');

                  // 최종 안전장치
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('버튼 동작 중 오류가 발생했습니다'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.ads_click),
                  SizedBox(width: 8),
                  Text(
                    'AdMob 테스트하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 여기에 실제 앱의 주요 기능들을 추가할 수 있어요
            const Text(
              '여기에 앱의 주요 기능들을\n구현하시면 됩니다!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ATT 상태에 따른 색상 결정
  Color _getStatusColor(bool isAuthorized) {
    if (ATTPlatformChecker.isIOS) {
      return isAuthorized ? Colors.green : Colors.orange;
    } else {
      return Colors.blue; // 안드로이드는 파란색
    }
  }

  // ATT 상태에 따른 아이콘 결정
  IconData _getStatusIcon(bool isAuthorized) {
    if (ATTPlatformChecker.isIOS) {
      return isAuthorized ? Icons.check_circle : Icons.info;
    } else {
      return Icons.check_circle; // 안드로이드는 항상 체크
    }
  }

  // ATT 상태에 따른 메시지 결정
  String _getStatusMessage(bool isAuthorized) {
    if (ATTPlatformChecker.isIOS) {
      return isAuthorized ? 'ATT 권한: 허용됨' : 'ATT 권한: 미설정';
    } else {
      return 'ATT 권한: 불필요 (Android)';
    }
  }
}
