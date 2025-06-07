// 📁 파일 위치: lib/admob/presentation/widgets/admob_counter_widget.dart
// 🔢 현재 광고 카운터를 보여주는 디버그용 위젯
// Study와 Review 카운터, 다음 광고까지 남은 횟수를 표시해요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/admob_constants.dart';
import '../providers/admob_state_provider.dart';

class AdMobCounterWidget extends ConsumerWidget {
  // 수직으로 표시할지 가로로 표시할지
  final bool isVertical;

  const AdMobCounterWidget({
    super.key,
    this.isVertical = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adMobStateProvider);

    // Study 다음 광고까지 남은 횟수
    final studyRemaining =
        AdMobConstants.studyInterstitialCount - (state.studyCount % AdMobConstants.studyInterstitialCount);

    // Review 다음 광고까지 남은 횟수
    final reviewRemaining =
        AdMobConstants.reviewInterstitialCount - (state.reviewCount % AdMobConstants.reviewInterstitialCount);

    final children = [
      // Study 카운터
      Text(
        'Study: ${state.studyCount}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      Text(
        '남은 횟수: $studyRemaining',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),

      // 구분선 또는 공간
      if (isVertical) const SizedBox(height: 8) else const SizedBox(width: 16),

      // Review 카운터
      Text(
        'Review: ${state.reviewCount}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      Text(
        '남은 횟수: $reviewRemaining',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: isVertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}
