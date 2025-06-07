// 📁 파일 위치: lib/main.dart
// 🚀 앱이 시작되는 진입점
// iOS에서는 ATT 화면을, 안드로이드에서는 바로 메인 페이지를 보여줘요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'att/core/att_platform_checker.dart';
import 'att/presentation/screens/att_screen.dart';
import 'root_page.dart';

void main() {
  runApp(
    // Riverpod을 사용하기 위해 ProviderScope로 감싸기
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATT 테스트 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // 플랫폼에 따라 첫 화면 결정
      home: const PlatformAwareHomePage(),
      // 화면 이동을 위한 라우트 설정
      routes: {
        '/root': (context) => const RootPage(),
        '/att': (context) => const ATTScreen(),
      },
    );
  }
}

// 플랫폼을 확인해서 적절한 첫 화면을 보여주는 위젯
class PlatformAwareHomePage extends StatelessWidget {
  const PlatformAwareHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // iOS인가요?
    if (ATTPlatformChecker.isIOS) {
      // iOS면 ATT 권한 요청 화면부터 시작
      return const ATTScreen();
    } else {
      // 안드로이드나 다른 기기면 바로 메인 페이지로 이동
      return const RootPage();
    }
  }
}

// 테스트용 홈페이지 (개발 중에만 사용)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATT 테스트'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 현재 플랫폼 표시
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue),
              ),
              child: Column(
                children: [
                  Text(
                    '현재 플랫폼: ${ATTPlatformChecker.isIOS ? 'iOS' : 'Android'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ATTPlatformChecker.isIOS ? 'ATT 권한 요청이 필요합니다' : 'ATT 권한 요청을 건너뛸 수 있습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ATT 권한 요청 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ATTScreen(),
                  ),
                );
              },
              child: const Text('ATT 권한 요청하기'),
            ),
            const SizedBox(height: 16),

            // 메인 페이지로 바로 이동 (테스트용)
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/root');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('메인 페이지로 바로 이동'),
            ),
          ],
        ),
      ),
    );
  }
}
