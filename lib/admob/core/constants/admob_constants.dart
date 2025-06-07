// 📁 파일 위치: lib/admob/core/constants/admob_constants.dart
// 🔧 AdMob에서 사용하는 모든 상수값들을 모아둔 곳
// 광고 개수, 시간 등 변하지 않는 값들이 있어요
// constants 폴더는 변하지 않는 값들을 저장하는 곳이에요

class AdMobConstants {
  // Study 몇 번 하면 전면광고를 보여줄까요?
  static const int studyInterstitialCount = 3;

  // Review 몇 번 하면 전면광고를 보여줄까요?
  static const int reviewInterstitialCount = 5;

  // 배너 광고 로딩에 실패하면 몇 초 후에 다시 시도할까요?
  static const int bannerRetrySeconds = 10;

  // 🔧 네트워크 에러 해결을 위해 test로 변경!
  // 광고 환경 설정 (test 또는 real)
  static const String environment = 'test'; // 일단 테스트로 변경해서 확인

  // 🔍 디버깅용 정보
  static const bool enableDebugLogs = true;
}
