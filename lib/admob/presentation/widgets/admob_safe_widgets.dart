// 📁 파일 위치: lib/admob/presentation/widgets/admob_safe_widgets.dart
// 🛡️ AdMob 관련 안전한 위젯들
// 에러가 발생해도 앱이 멈추지 않도록 보호하는 위젯들이에요

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/admob_test_screen.dart';

// 🛡️ 안전한 AdMob 테스트 화면 래퍼
class AdMobTestScreenSafe extends ConsumerWidget {
  const AdMobTestScreenSafe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      print('🛡️ 안전한 AdMob 테스트 화면 로딩 중');
      return const AdMobTestScreen();
    } catch (e, stackTrace) {
      print('❌ AdMob 테스트 화면 로딩 실패: $e');
      print('스택 트레이스: $stackTrace');
      return const AdMobErrorScreen();
    }
  }
}

// ❌ AdMob 에러 화면
class AdMobErrorScreen extends StatelessWidget {
  const AdMobErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AdMob 오류'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red,
              ),
              const SizedBox(height: 24),

              const Text(
                'AdMob 테스트 화면을 불러올 수 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                '다음을 확인해보세요:\n\n'
                '• 인터넷 연결 상태\n'
                '• AdMob 계정 설정\n'
                '• 앱 권한 설정\n'
                '• 실제 기기에서 테스트',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // 다시 시도 버튼
              ElevatedButton(
                onPressed: () {
                  try {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const AdMobTestScreenSafe(),
                      ),
                    );
                  } catch (e) {
                    print('❌ 다시 시도 버튼 오류: $e');
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('다시 시도'),
              ),
              const SizedBox(height: 16),

              // 돌아가기 버튼
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
