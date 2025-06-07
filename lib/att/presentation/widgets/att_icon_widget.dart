// 📁 파일 위치: lib/att/presentation/widgets/att_icon_widget.dart
// 🔒 ATT 화면에서 보여줄 아이콘 위젯
// 개인정보보호를 상징하는 방패나 자물쇠 아이콘을 예쁘게 보여줘요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';

import '../../core/constants/att_colors.dart';
import '../../core/constants/att_icons.dart';

class ATTIconWidget extends StatelessWidget {
  const ATTIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 동그란 배경 만들기
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: ATTColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: Icon(ATTIcons.shield, size: 40, color: ATTColors.primary),
    );
  }
}
