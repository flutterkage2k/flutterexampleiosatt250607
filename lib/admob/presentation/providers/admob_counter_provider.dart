// 📁 파일 위치: lib/admob/presentation/providers/admob_counter_provider.dart
// 🔢 AdMob 카운터와 전면광고 표시를 관리하는 Provider
// Study 3번, Review 5번마다 전면광고를 보여주는 핵심 기능이에요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/admob_constants.dart';
import '../../model/admob_context_model.dart';
import 'admob_controller_provider.dart';
import 'admob_state_provider.dart';

// 카운터 관리 Provider
final adMobCounterProvider = Provider<AdMobCounterActions>((ref) {
  return AdMobCounterActions(ref);
});

// 카운터 동작들을 담당하는 클래스
class AdMobCounterActions {
  final Ref _ref;

  AdMobCounterActions(this._ref);

  // 필요한 경우 전면광고 보여주기 (핵심 기능!)
  void showInterstitialIfNeeded(
    AdMobContextType type, {
    String? from,
  }) {
    final state = _ref.read(adMobStateProvider);
    final controller = _ref.read(adMobControllerProvider.notifier);
    final location = from ?? 'Unknown';

    // 타입에 따라 카운터 증가 및 전면광고 체크
    switch (type) {
      case AdMobContextType.study:
        _ref.read(adMobStateProvider.notifier).incrementStudyCount();
        final newCount = state.studyCount + 1;
        print('📍 [$location] Study 카운트: $newCount');

        // 3번마다 전면광고 표시
        if (newCount % AdMobConstants.studyInterstitialCount == 0) {
          print('📢 [$location] Study 전면광고 표시! (${AdMobConstants.studyInterstitialCount}회 달성)');
          _showInterstitial(controller);
        }
        break;

      case AdMobContextType.review:
        _ref.read(adMobStateProvider.notifier).incrementReviewCount();
        final newCount = state.reviewCount + 1;
        print('📍 [$location] Review 카운트: $newCount');

        // 5번마다 전면광고 표시
        if (newCount % AdMobConstants.reviewInterstitialCount == 0) {
          print('📢 [$location] Review 전면광고 표시! (${AdMobConstants.reviewInterstitialCount}회 달성)');
          _showInterstitial(controller);
        }
        break;
    }
  }

  // 실제 전면광고 보여주기
  void _showInterstitial(AdMobController controller) {
    final state = _ref.read(adMobStateProvider);

    if (state.isInterstitialReady) {
      print('🚨 전면광고 표시 시도 중...');
      controller.showInterstitial();
    } else {
      print('⚠️ 전면광고가 준비되지 않음');
    }
  }

  // 카운터 리셋
  void resetCounters() {
    _ref.read(adMobStateProvider.notifier).resetCounters();
    print('🔄 모든 카운터 리셋됨');
  }
}
