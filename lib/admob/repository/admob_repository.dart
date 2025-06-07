// 📁 파일 위치: lib/admob/repository/admob_repository.dart
// 📡 실제 Google AdMob API와 소통하는 저장소
// 시뮬레이터와 실제 기기를 정확하게 구분해서 최적화된 광고 요청을 해요
// repository 폴더는 데이터를 가져오고 저장하는 기능들을 모아둔 곳이에요
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/admob_platform_checker.dart';
import '../core/constants/admob_constants.dart';
import 'admob_ad_helper.dart';

class AdMobRepository {
  // 현재 로딩된 배너 광고
  BannerAd? _bannerAd;

  // 현재 로딩된 전면 광고
  InterstitialAd? _interstitialAd;

  // 배너 광고 재시도 타이머
  Timer? _retryTimer;

  // 🎯 최적화된 광고 요청 생성 (실기기/시뮬레이터별)
  Future<AdRequest> get _optimizedAdRequest async {
    final isSimulatorDevice = await AdMobPlatformChecker.isSimulator;

    if (isSimulatorDevice) {
      if (kDebugMode) {
        print('🔧 시뮬레이터용 최적화된 광고 요청 생성');
      }
      return AdRequest(
        keywords: const [
          'test',
          'demo',
          'sample',
          'debug',
          'development',
          'simulator',
          'emulator',
          'flutter',
          'mobile',
          'app'
        ], // 광범위한 테스트 키워드
        contentUrl: 'https://flutter.dev',
        nonPersonalizedAds: true, // 테스트에 더 적합
        extras: const {
          'environment': 'test',
          'platform': 'flutter',
          'ad_format': 'test_mode',
        }, // 추가 테스트 정보
      );
    } else {
      if (kDebugMode) {
        print('🔧 실제 기기용 광고 요청 생성');
      }
      return const AdRequest(
        // 실제 기기에서는 기본 요청 사용
        nonPersonalizedAds: false,
      );
    }
  }

  // 배너 광고 로딩하기 (정확한 기기 판단)
  Future<BannerAd?> loadBannerAd({
    required void Function(Ad) onLoaded,
    required void Function(Ad, LoadAdError) onFailed,
  }) async {
    final isSimulatorDevice = await AdMobPlatformChecker.isSimulator;

    // 🔧 기기별 테스트 설정 적용
    if (isSimulatorDevice) {
      await _configureForSimulatorTesting();
    } else {
      await _configureForRealDeviceTesting();
    }

    // 기존 배너가 있으면 제거
    _bannerAd?.dispose();

    final adUnitId = AdMobAdHelper.bannerAdUnitId;
    final deviceType = isSimulatorDevice ? '시뮬레이터' : '실제 기기';

    if (kDebugMode) {
      print('🎯 배너 광고 로딩 시작 ($deviceType)');
      print('   - 광고 ID: $adUnitId');
      print('   - 환경: ${AdMobConstants.environment}');
    }

    final adRequest = await _optimizedAdRequest;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: adRequest,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print('✅ 배너 광고 로딩 성공! ($deviceType)');
          }
          onLoaded(ad);
        },
        onAdFailedToLoad: (ad, error) {
          if (kDebugMode) {
            print('❌ 배너 광고 로딩 실패:');
            print('   - 에러 코드: ${error.code}');
            print('   - 메시지: ${error.message}');
            print('   - 기기 타입: $deviceType');

            if (error.code == 2) {
              print('💡 네트워크 에러 감지');
              if (isSimulatorDevice) {
                print('💡 시뮬레이터에서는 광고가 제한적일 수 있습니다');
              } else {
                print('💡 인터넷 연결 상태나 AdMob 계정 설정을 확인하세요');
              }
            }
          }
          onFailed(ad, error);
        },
        onAdOpened: (ad) {
          if (kDebugMode) print('📱 배너 광고 열림');
        },
        onAdClosed: (ad) {
          if (kDebugMode) print('📱 배너 광고 닫힘');
        },
      ),
    );

    await _bannerAd!.load();
    return _bannerAd;
  }

  // 전면 광고 로딩하기 (정확한 기기 판단)
  Future<InterstitialAd?> loadInterstitialAd({
    required void Function(InterstitialAd) onLoaded,
    required void Function(LoadAdError) onFailed,
  }) async {
    final isSimulatorDevice = await AdMobPlatformChecker.isSimulator;

    // 🔧 기기별 테스트 설정 적용
    if (isSimulatorDevice) {
      await _configureForSimulatorTesting();
    } else {
      await _configureForRealDeviceTesting();
    }

    final adUnitId = AdMobAdHelper.interstitialAdUnitId;
    final deviceType = isSimulatorDevice ? '시뮬레이터' : '실제 기기';

    if (kDebugMode) {
      print('🎯 전면 광고 로딩 시작 ($deviceType)');
      print('   - 광고 ID: $adUnitId');
      print('   - 환경: ${AdMobConstants.environment}');
    }

    final adRequest = await _optimizedAdRequest;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (kDebugMode) {
            print('✅ 전면 광고 로딩 성공! ($deviceType)');
          }
          _interstitialAd = ad;
          onLoaded(ad);
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            print('❌ 전면 광고 로딩 실패:');
            print('   - 에러 코드: ${error.code}');
            print('   - 메시지: ${error.message}');
            print('   - 기기 타입: $deviceType');

            if (error.code == 2) {
              print('💡 네트워크 에러 감지');
              if (isSimulatorDevice) {
                print('💡 시뮬레이터에서는 광고가 제한적일 수 있습니다');
              } else {
                print('💡 인터넷 연결 상태나 AdMob 계정 설정을 확인하세요');
              }
            }
          }
          onFailed(error);
        },
      ),
    );
    return _interstitialAd;
  }

  // 🔧 시뮬레이터용 테스트 설정
  Future<void> _configureForSimulatorTesting() async {
    try {
      if (kDebugMode) {
        print('🔧 시뮬레이터용 테스트 설정 적용 중...');
      }

      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: const [
            'simulator',
            'emulator',
            'test-device',
            'debug-device',
          ],
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          maxAdContentRating: MaxAdContentRating.g,
        ),
      );

      // 시뮬레이터 안정화 대기
      await Future.delayed(const Duration(milliseconds: 1000));

      if (kDebugMode) {
        print('✅ 시뮬레이터용 테스트 설정 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ 시뮬레이터 테스트 설정 실패: $e');
      }
    }
  }

  // 🆕 실제 기기용 설정
  Future<void> _configureForRealDeviceTesting() async {
    try {
      if (kDebugMode) {
        print('🔧 실제 기기용 설정 적용 중...');
      }

      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: const [], // 실제 기기에서는 빈 배열
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.unspecified,
          maxAdContentRating: MaxAdContentRating.g,
        ),
      );

      // 실제 기기 안정화 대기 (짧게)
      await Future.delayed(const Duration(milliseconds: 500));

      if (kDebugMode) {
        print('✅ 실제 기기용 설정 완료');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ 실제 기기 설정 실패: $e');
      }
    }
  }

  // 현재 배너 광고 가져오기
  BannerAd? get currentBannerAd => _bannerAd;

  // 현재 전면 광고 가져오기
  InterstitialAd? get currentInterstitialAd => _interstitialAd;

  // 현재 실행 환경 정보 (비동기)
  Future<String> get deviceInfo async {
    final isSimulatorDevice = await AdMobPlatformChecker.isSimulator;
    return isSimulatorDevice ? '🤖 시뮬레이터' : '📱 실제 기기';
  }

  // 모든 광고 정리하기
  Future<void> dispose() async {
    final deviceType = await deviceInfo;
    if (kDebugMode) {
      print('🗑️ AdMob Repository 리소스 정리 ($deviceType)');
    }
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _retryTimer?.cancel();
    _bannerAd = null;
    _interstitialAd = null;
  }
}
