// 📁 파일 위치: lib/att/presentation/screens/att_screen.dart
// 📱 ATT 권한 요청 메인 화면
// 모든 위젯들을 조합해서 완성된 ATT 화면을 만들어요
// 권한이 허용되면 실제 앱의 메인 페이지로 이동해요
// 안전한 네비게이션 처리가 추가되었어요
// screens 폴더는 완성된 화면들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../root_page.dart'; // Root 페이지 import 추가
import '../../core/constants/att_colors.dart';
import '../../model/att_status_model.dart';
import '../providers/att_status_provider.dart';
import '../widgets/att_description_widget.dart';
import '../widgets/att_icon_widget.dart';
import '../widgets/att_request_button_widget.dart';
import '../widgets/att_skip_button_widget.dart';
import '../widgets/att_status_message_widget.dart';
import '../widgets/att_title_widget.dart';

class ATTScreen extends ConsumerStatefulWidget {
  const ATTScreen({super.key});

  @override
  ConsumerState<ATTScreen> createState() => _ATTScreenState();
}

class _ATTScreenState extends ConsumerState<ATTScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 열릴 때 현재 권한 상태 확인하기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(attStatusProvider.notifier).checkStatus();
    });
  }

  // 권한이 허용된 후 실제 앱의 메인 페이지로 이동하는 함수 (안전장치 추가)
  void _navigateToRootPage() {
    try {
      print('🚀 Root 페이지로 이동 시도');

      // 현재 컨텍스트가 유효한지 확인
      if (!mounted) {
        print('⚠️ 위젯이 마운트되지 않음, 이동 취소');
        return;
      }

      // 안전한 네비게이션
      Navigator.of(context).pushReplacementNamed('/root').catchError((error) {
        print('❌ Root 페이지 이동 중 오류: $error');

        // 대체 방법: 직접 페이지 교체
        try {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RootPage()),
          );
          print('✅ 대체 방법으로 Root 페이지 이동 성공');
        } catch (e) {
          print('❌ 대체 방법도 실패: $e');

          // 최후 수단: 단순 push
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RootPage()),
          );
        }
      });

      print('✅ Root 페이지 이동 명령 완료');
    } catch (e, stackTrace) {
      print('❌ _navigateToRootPage 전체 오류: $e');
      print('스택 트레이스: $stackTrace');

      // 최종 안전장치: 간단한 알림만 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('페이지 이동 중 오류가 발생했습니다'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final attStatus = ref.watch(attStatusProvider);
    final isAuthorized = attStatus?.status == ATTStatus.authorized;

    return Scaffold(
      backgroundColor: ATTColors.white,
      appBar: AppBar(
        backgroundColor: ATTColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ATTColors.gray),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 위쪽 공간 만들기
              const Spacer(),

              // 방패 아이콘
              const ATTIconWidget(),
              const SizedBox(height: 32),

              // '개인정보 보호' 제목
              const ATTTitleWidget(),
              const SizedBox(height: 16),

              // 권한이 왜 필요한지 설명
              const ATTDescriptionWidget(),
              const SizedBox(height: 24),

              // 현재 권한 상태 메시지
              const ATTStatusMessageWidget(),
              const SizedBox(height: 32),

              // 아래쪽 공간 만들기
              const Spacer(),

              // '허용' 또는 '계속' 버튼
              ATTRequestButtonWidget(
                onContinue: _navigateToRootPage,
              ),
              const SizedBox(height: 12),

              // 권한이 허용되지 않았을 때만 '나중에' 버튼 보여주기
              if (!isAuthorized) ...[
                const ATTSkipButtonWidget(),
                const SizedBox(height: 32),
              ] else ...[
                // 권한이 허용되었으면 여백만 추가
                const SizedBox(height: 44),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
