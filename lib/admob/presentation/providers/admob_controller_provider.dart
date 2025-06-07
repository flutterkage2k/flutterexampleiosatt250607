// 📁 파일 위치: lib/admob/presentation/providers/admob_controller_provider.dart
// 🎮 AdMob 광고를 제어하는 Controller Provider
// 광고 로딩, 보여주기, 카운터 관리 등 모든 동작을 담당해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/admob_constants.dart';
import '../../repository/admob_repository.dart';
import 'admob_state_provider.dart';

// AdMob Controller Provider
final adMobControllerProvider = StateNotifierProvider<AdMobController, void>((ref) {
  return AdMobController(ref);
});

// AdMob을 제어하는 클래스
class AdMobController extends StateNotifier<void> {
  final Ref _ref;
  final AdMobRepository _repository = AdMobRepository();
  Timer? _retryTimer;

  AdMobController(this._ref) : super(null) {
    // AdMob 초기화 확인 후 광고 로딩
    _checkAndInitializeAds();
  }

  // AdMob 초기화 확인 후 광고 로딩
  Future<void> _checkAndInitializeAds() async {
    try {
      // AdMob 초기화 상태 확인 (간단한 방법)
      print('📱 AdMob 초기화 상태 확인 중...');

      // 광고 로딩 시작
      _initializeAds();
    } catch (e) {
      print('❌ AdMob 초기화 확인 중 오류: $e');
      // 오류가 있어도 광고 로딩 시도
      _initializeAds();
    }
  }

  // 광고들 초기화
  void _initializeAds() {
    _loadBannerAd();
    _loadInterstitialAd();
  }

  // 배너 광고 로딩
  Future<void> _loadBannerAd() async {
    await _repository.loadBannerAd(
      onLoaded: (ad) {
        print('✅ 배너 광고 로딩 성공');
        _ref.read(adMobStateProvider.notifier).setBannerLoaded(true);
        _retryTimer?.cancel();
      },
      onFailed: (ad, error) {
        print('❌ 배너 광고 로딩 실패: $error');
        ad.dispose();
        _ref.read(adMobStateProvider.notifier).setBannerLoaded(false);

        // 재시도 타이머 설정
        _retryTimer = Timer(
          Duration(seconds: AdMobConstants.bannerRetrySeconds),
          () => _loadBannerAd(),
        );
      },
    );
  }

  // 전면 광고 로딩
  Future<void> _loadInterstitialAd() async {
    await _repository.loadInterstitialAd(
      onLoaded: (ad) {
        print('✅ 전면 광고 로딩 성공');
        _ref.read(adMobStateProvider.notifier).setInterstitialReady(true);

        // 전면 광고 이벤트 설정
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            print('⬅️ 전면 광고 닫힘');
            ad.dispose();
            _ref.read(adMobStateProvider.notifier).setInterstitialReady(false);
            _loadInterstitialAd(); // 다음 광고 미리 로딩
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            print('❌ 전면 광고 표시 실패: $error');
            ad.dispose();
            _ref.read(adMobStateProvider.notifier).setInterstitialReady(false);
            _loadInterstitialAd();
          },
        );
      },
      onFailed: (error) {
        print('❌ 전면 광고 로딩 실패: $error');
        _ref.read(adMobStateProvider.notifier).setInterstitialReady(false);
      },
    );
  }

  // 전면 광고 표시하기 (안전장치 추가)
  void showInterstitial() {
    try {
      print('🎯 전면 광고 표시 요청됨');
      final interstitialAd = _repository.currentInterstitialAd;

      if (interstitialAd != null) {
        print('🚨 전면 광고 표시 중...');
        interstitialAd.show();
        print('✅ 전면 광고 표시 명령 완료');
      } else {
        print('⚠️ 표시할 전면 광고가 없음');
        print('💡 광고 로딩 중이거나 시뮬레이터 제한일 수 있습니다');
      }
    } catch (e, stackTrace) {
      print('❌ 전면 광고 표시 중 오류 발생: $e');
      print('스택 트레이스: $stackTrace');
      print('💡 시뮬레이터에서는 광고 기능이 제한될 수 있습니다');
      // 오류가 발생해도 앱이 멈추지 않도록 안전하게 처리
    }
  }

  // 현재 배너 광고 가져오기
  BannerAd? get currentBannerAd => _repository.currentBannerAd;

  // 리소스 정리
  @override
  void dispose() {
    _repository.dispose();
    _retryTimer?.cancel();
    super.dispose();
  }
}
