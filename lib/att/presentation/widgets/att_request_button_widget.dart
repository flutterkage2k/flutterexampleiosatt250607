// 📁 파일 위치: lib/att/presentation/widgets/att_request_button_widget.dart
// 🔵 ATT 권한을 요청하거나 다음 단계로 진행하는 파란색 버튼 위젯
// 권한이 없으면 '허용' 버튼, 권한이 있으면 '계속' 버튼으로 바뀌어요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/att_colors.dart';
import '../../core/constants/att_texts.dart';
import '../../model/att_status_model.dart';
import '../providers/att_request_provider.dart';
import '../providers/att_status_provider.dart';

class ATTRequestButtonWidget extends ConsumerWidget {
  // 권한이 허용된 후 다음 페이지로 이동할 때 실행할 함수
  final VoidCallback? onContinue;

  const ATTRequestButtonWidget({super.key, this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRequesting = ref.watch(attRequestProvider);
    final attStatus = ref.watch(attStatusProvider);

    // 권한이 허용되었는지 확인
    final isAuthorized = attStatus?.status == ATTStatus.authorized;

    // 버튼 텍스트 결정: 허용됨 → "계속", 아니면 → "허용"
    final buttonText = isAuthorized ? ATTTexts.continueButton : ATTTexts.allowButton;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity, // 버튼을 화면 전체 너비로 만들기
        height: 50,
        child: ElevatedButton(
          onPressed: isRequesting
              ? null
              : () {
                  if (isAuthorized) {
                    // 권한이 허용된 상태면 다음 페이지로 이동
                    onContinue?.call();
                  } else {
                    // 권한이 없으면 권한 요청하기
                    ref.read(attRequestProvider.notifier).requestPermission();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: ATTColors.primary,
            foregroundColor: ATTColors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: isRequesting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(ATTColors.white),
                  ),
                )
              : Text(buttonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
