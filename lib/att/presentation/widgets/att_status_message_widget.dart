// 📁 파일 위치: lib/att/presentation/widgets/att_status_message_widget.dart
// 💬 ATT 권한 상태에 따른 메시지를 보여주는 위젯
// 허용됨, 거부됨, 확인중 등의 상태를 색깔과 함께 표시해요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/att_texts.dart';
import '../../model/att_status_model.dart';
import '../providers/att_status_provider.dart';

class ATTStatusMessageWidget extends ConsumerWidget {
  const ATTStatusMessageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(attStatusProvider);

    // 상태가 없으면 아무것도 보여주지 않기
    if (status == null) return const SizedBox.shrink();

    // 상태에 따라 메시지와 색깔 정하기
    String message;
    Color color;

    switch (status.status) {
      case ATTStatus.authorized:
        message = ATTTexts.authorized;
        color = Colors.green;
        break;
      case ATTStatus.denied:
        message = ATTTexts.denied;
        color = Colors.red;
        break;
      case ATTStatus.unknown:
        message = ATTTexts.unknown;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        message,
        style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
