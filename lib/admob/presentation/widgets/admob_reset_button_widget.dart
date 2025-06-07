// 📁 파일 위치: lib/admob/presentation/widgets/admob_reset_button_widget.dart
// 🔄 광고 카운터를 리셋하는 버튼 위젯
// 개발이나 테스트할 때 카운터를 0으로 초기화하는 용도예요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/admob_counter_provider.dart';

class AdMobResetButtonWidget extends ConsumerWidget {
  // 버튼 텍스트 (기본값: "카운터 리셋")
  final String? text;

  // 버튼 스타일
  final ButtonStyle? style;

  const AdMobResetButtonWidget({
    super.key,
    this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterActions = ref.read(adMobCounterProvider);

    return TextButton(
      onPressed: () {
        // 카운터 리셋 실행
        counterActions.resetCounters();

        // 사용자에게 알림 (선택적)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔄 광고 카운터가 리셋되었습니다'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      style: style ??
          TextButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
      child: Text(text ?? '카운터 리셋'),
    );
  }
}
