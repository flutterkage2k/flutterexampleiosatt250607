// 📁 파일 위치: lib/att/presentation/widgets/att_title_widget.dart
// 📝 ATT 화면의 제목을 보여주는 위젯
// 큰 글씨로 '개인정보 보호' 제목을 예쁘게 표시해요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';

import '../../core/constants/att_texts.dart';

class ATTTitleWidget extends StatelessWidget {
  const ATTTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      ATTTexts.title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}
