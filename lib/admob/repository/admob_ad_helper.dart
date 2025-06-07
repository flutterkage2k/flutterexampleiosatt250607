// 📁 파일 위치: lib/admob/repository/admob_ad_helper.dart
// 🆔 플랫폼과 환경에 맞는 광고 ID를 가져오는 도우미
// iOS/Android와 테스트/실제 환경을 구분해서 올바른 ID를 돌려줘요
// repository 폴더는 데이터를 가져오고 저장하는 기능들을 모아둔 곳이에요
import 'package:flutter/foundation.dart';

import '../core/constants/admob_ad_units.dart';
import '../core/constants/admob_constants.dart';

class AdMobAdHelper {
  // 현재 환경에 맞는 배너 광고 ID 가져오기
  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS 배너 광고 ID
      return AdMobConstants.environment == 'test' ? AdMobAdUnits.iosTestBanner : AdMobAdUnits.iosRealBanner;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 배너 광고 ID
      return AdMobConstants.environment == 'test' ? AdMobAdUnits.androidTestBanner : AdMobAdUnits.androidRealBanner;
    } else {
      // 지원하지 않는 플랫폼
      throw UnsupportedError("지원하지 않는 플랫폼입니다");
    }
  }

  // 현재 환경에 맞는 전면 광고 ID 가져오기
  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS 전면 광고 ID
      return AdMobConstants.environment == 'test' ? AdMobAdUnits.iosTestInterstitial : AdMobAdUnits.iosRealInterstitial;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Android 전면 광고 ID
      return AdMobConstants.environment == 'test'
          ? AdMobAdUnits.androidTestInterstitial
          : AdMobAdUnits.androidRealInterstitial;
    } else {
      // 지원하지 않는 플랫폼
      throw UnsupportedError("지원하지 않는 플랫폼입니다");
    }
  }

  // 현재 환경 정보 확인 (디버깅용)
  static Map<String, String> get environmentInfo => {
        'environment': AdMobConstants.environment,
        'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android',
        'bannerAdId': bannerAdUnitId,
        'interstitialAdId': interstitialAdUnitId,
      };
}
