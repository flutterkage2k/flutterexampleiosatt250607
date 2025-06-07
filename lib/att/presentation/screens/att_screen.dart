// 📁 파일 위치: lib/att/presentation/screens/att_screen.dart
// 📱 ATT 권한 요청 메인 화면
// 모든 위젯들을 조합해서 완성된 ATT 화면을 만들어요
// 권한이 허용되면 실제 앱의 메인 페이지로 이동해요
// screens 폴더는 완성된 화면들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  // 권한이 허용된 후 실제 앱의 메인 페이지로 이동하는 함수
  void _navigateToRootPage() {
    Navigator.of(context).pushReplacementNamed('/root');
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
              ATTRequestButtonWidget(onContinue: _navigateToRootPage),
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
