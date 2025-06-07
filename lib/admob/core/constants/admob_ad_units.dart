// 📁 파일 위치: lib/admob/core/constants/admob_ad_units.dart
// 🆔 AdMob 광고 단위 ID들을 플랫폼별로 관리하는 곳
// 테스트용과 실제용 광고 ID를 구분해서 저장해요
// constants 폴더는 변하지 않는 값들을 저장하는 곳이에요

class AdMobAdUnits {
  // 📱 Android 배너 광고 ID
  static const String androidTestBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String androidRealBanner = '';

  // 📱 Android 전면 광고 ID
  static const String androidTestInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String androidRealInterstitial = '';

  // 🍏 iOS 배너 광고 ID
  static const String iosTestBanner = 'ca-app-pub-3940256099942544/2934735716';
  static const String iosRealBanner = '';

  // 🍏 iOS 전면 광고 ID
  static const String iosTestInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String iosRealInterstitial = '';
}
