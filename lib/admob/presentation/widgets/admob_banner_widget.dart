// 📁 파일 위치: lib/admob/presentation/widgets/admob_banner_widget.dart
// 📺 안전한 배너 광고를 보여주는 위젯
// 광고가 로딩될 때까지 "로딩 중" 메시지를 보여주고, 로딩되면 실제 광고를 표시해요
// widgets 폴더는 화면에 표시되는 작은 조각들을 모아둔 곳이에요
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../providers/admob_controller_provider.dart';
import '../providers/admob_state_provider.dart';

class AdMobBannerWidget extends ConsumerWidget {
  // 배너 높이 (기본값: 50)
  final double? height;

  // 배너 주변 여백
  final EdgeInsetsGeometry? margin;

  const AdMobBannerWidget({
    super.key,
    this.height,
    this.margin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adMobStateProvider);
    final controller = ref.read(adMobControllerProvider.notifier);

    // 배너가 로딩되지 않았으면 로딩 메시지 표시
    if (!state.isBannerLoaded) {
      return Container(
        height: height ?? 50,
        margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: const Text(
          '광고 로딩 중...',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    // 실제 배너 광고 가져오기
    final bannerAd = controller.currentBannerAd;

    if (bannerAd == null) {
      return Container(
        height: height ?? 50,
        margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        child: const Text(
          '광고를 불러올 수 없습니다',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }

    // 실제 Google 배너 광고 표시
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      width: bannerAd.size.width.toDouble(),
      height: bannerAd.size.height.toDouble(),
      child: AdWidget(
        key: ValueKey('banner_${bannerAd.hashCode}'),
        ad: bannerAd,
      ),
    );
  }
}
