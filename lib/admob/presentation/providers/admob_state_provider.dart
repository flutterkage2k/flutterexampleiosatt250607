// 📁 파일 위치: lib/admob/presentation/providers/admob_state_provider.dart
// 🔄 AdMob의 전체 상태를 관리하는 Provider
// 배너 로딩, 전면광고 준비, 카운터 등 모든 상태를 추적해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/admob_state_model.dart';

// AdMob 상태를 관리하는 Provider
final adMobStateProvider = StateNotifierProvider<AdMobStateNotifier, AdMobStateModel>((ref) {
  return AdMobStateNotifier();
});

// AdMob 상태를 관리하는 클래스
class AdMobStateNotifier extends StateNotifier<AdMobStateModel> {
  // 처음에는 비어있는 상태로 시작
  AdMobStateNotifier() : super(AdMobStateModel());

  // 배너 광고 로딩 완료
  void setBannerLoaded(bool isLoaded) {
    state = state.copyWith(isBannerLoaded: isLoaded);
  }

  // 전면 광고 준비 완료
  void setInterstitialReady(bool isReady) {
    state = state.copyWith(isInterstitialReady: isReady);
  }

  // Study 카운터 증가
  void incrementStudyCount() {
    state = state.copyWith(studyCount: state.studyCount + 1);
  }

  // Review 카운터 증가
  void incrementReviewCount() {
    state = state.copyWith(reviewCount: state.reviewCount + 1);
  }

  // 모든 카운터 리셋
  void resetCounters() {
    state = state.copyWith(studyCount: 0, reviewCount: 0);
  }

  // 로딩 상태 변경
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}
