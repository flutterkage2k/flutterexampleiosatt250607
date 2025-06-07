// 📁 파일 위치: lib/att/presentation/widgets/att_description_widget.dart
// 📄 ATT 권한이 왜 필요한지 설명하는 위젯
// 사용자가 이해하기 쉽도록 친근한 말투로 설명해요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';

import '../../core/constants/att_colors.dart';
import '../../core/constants/att_texts.dart';

class ATTDescriptionWidget extends StatelessWidget {
  const ATTDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Text(
        ATTTexts.description,
        style: const TextStyle(
          fontSize: 16,
          color: ATTColors.gray,
          height: 1.5, // 줄 간격 넓히기
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
