// 📁 파일 위치: lib/att/core/constants/att_texts.dart
// 📝 ATT 화면에서 보여줄 모든 글자들을 모아둔 곳
// 여기서 글자를 바꾸면 모든 화면에서 한번에 바뀌어요
// constants 폴더는 변하지 않는 값들을 저장하는 곳이에요
class ATTTexts {
  // 화면 맨 위에 보여줄 제목
  static const String title = '개인정보 보호';

  // 사용자에게 설명하는 글 (여러 줄로 나누어져 있어요)
  static const String description = '더 나은 서비스를 위해\n앱 추적 권한이 필요합니다.\n이 권한은 언제든지 설정에서 바꿀 수 있어요.';

  // 권한을 허용하는 버튼에 들어갈 글자
  static const String allowButton = '허용';

  // 권한이 허용된 후 계속 진행하는 버튼에 들어갈 글자
  static const String continueButton = '계속';

  // 권한을 나중에 정하는 버튼에 들어갈 글자
  static const String skipButton = '나중에';

  // 권한 상태에 따라 보여줄 메시지들
  static const String authorized = '권한이 허용되었습니다';
  static const String denied = '권한이 거부되었습니다';
  static const String unknown = '권한 상태를 확인 중입니다';
}
