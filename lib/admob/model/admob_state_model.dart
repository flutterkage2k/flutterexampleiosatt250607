// 📁 파일 위치: lib/admob/model/admob_state_model.dart
// 📊 AdMob 광고의 현재 상태를 나타내는 데이터 모델
// 배너가 로딩됐는지, 전면광고가 준비됐는지 등을 관리해요
// model 폴더는 앱에서 사용하는 데이터의 형태를 정의하는 곳이에요

class AdMobStateModel {
  // 배너 광고가 로딩되었나요?
  final bool isBannerLoaded;

  // 전면 광고가 준비되었나요?
  final bool isInterstitialReady;

  // 현재 Study 횟수
  final int studyCount;

  // 현재 Review 횟수
  final int reviewCount;

  // 광고가 로딩 중인가요?
  final bool isLoading;

  // 새로운 AdMob 상태 만들기
  AdMobStateModel({
    this.isBannerLoaded = false,
    this.isInterstitialReady = false,
    this.studyCount = 0,
    this.reviewCount = 0,
    this.isLoading = false,
  });

  // 상태 복사해서 일부만 바꾸기
  AdMobStateModel copyWith({
    bool? isBannerLoaded,
    bool? isInterstitialReady,
    int? studyCount,
    int? reviewCount,
    bool? isLoading,
  }) {
    return AdMobStateModel(
      isBannerLoaded: isBannerLoaded ?? this.isBannerLoaded,
      isInterstitialReady: isInterstitialReady ?? this.isInterstitialReady,
      studyCount: studyCount ?? this.studyCount,
      reviewCount: reviewCount ?? this.reviewCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
