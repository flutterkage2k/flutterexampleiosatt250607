// 📁 파일 위치: lib/root_page.dart
// 🏠 실제 앱의 메인 페이지
// ATT 권한 허용 후 사용자가 이동하는 실제 앱 화면이에요
// 플랫폼별로 다른 정보를 보여줘요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
