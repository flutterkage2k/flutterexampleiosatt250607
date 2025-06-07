// 📁 파일 위치: lib/att/presentation/widgets/att_skip_button_widget.dart
// ⚪ ATT 권한을 나중에 설정하는 회색 버튼 위젯
// 사용자가 지금 권한을 주고 싶지 않을 때 누르는 버튼이에요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';

import '../../core/constants/att_colors.dart';
import '../../core/constants/att_texts.dart';

class ATTSkipButtonWidget extends StatelessWidget {
  // 버튼을 눌렀을 때 할 일을 받아오기
  final VoidCallback? onPressed;

  const ATTSkipButtonWidget({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: double.infinity, // 버튼을 화면 전체 너비로 만들기
        height: 50,
        child: TextButton(
          onPressed:
              onPressed ??
              () {
                // 기본 동작: 이전 화면으로 돌아가기
                Navigator.of(context).pop();
              },
          style: TextButton.styleFrom(
            foregroundColor: ATTColors.gray,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text(ATTTexts.skipButton, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
