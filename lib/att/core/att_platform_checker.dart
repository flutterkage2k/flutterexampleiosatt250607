// 📁 파일 위치: lib/att/core/att_platform_checker.dart
// 📱 스마트폰이 아이폰인지 안드로이드인지 알아보는 도구
// ATT는 아이폰에서만 작동하기 때문에 꼭 필요해요
// 이 파일은 ATT 모듈의 핵심 기능들을 모아둔 core 폴더에 있어요
import 'dart:io';

class ATTPlatformChecker {
  // 지금 사용하는 스마트폰이 아이폰인가요?
  // true = 아이폰, false = 다른 폰
  static bool get isIOS => Platform.isIOS;

  // 지금 사용하는 스마트폰이 안드로이드인가요?
  // true = 안드로이드, false = 다른 폰
  static bool get isAndroid => Platform.isAndroid;
}
