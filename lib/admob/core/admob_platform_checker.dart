// 📁 파일 위치: lib/admob/core/admob_platform_checker.dart
// 🔍 플랫폼을 체크하는 도구
// iOS/Android 구분하고 시뮬레이터/실기기도 정확하게 구분해요
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class AdMobPlatformChecker {
  static DeviceInfoPlugin? _deviceInfo;
  static bool? _cachedIsSimulator;

  // 🤖 Android인지 확인
  static bool get isAndroid => Platform.isAndroid;

  // 🍎 iOS인지 확인
  static bool get isIOS => Platform.isIOS;

  // 📱 AdMob을 지원하는 플랫폼인지 확인
  static bool get isSupported => isAndroid || isIOS;

  // 🔧 시뮬레이터인지 확인 (정확한 방법)
  static Future<bool> get isSimulator async {
    // 캐시된 값이 있으면 바로 반환
    if (_cachedIsSimulator != null) {
      return _cachedIsSimulator!;
    }

    if (kDebugMode) {
      print('🔍 실기기/시뮬레이터 정확한 체크 시작...');
    }

    // 1️⃣ 웹이면 시뮬레이터 아님
    if (kIsWeb) {
      _cachedIsSimulator = false;
      if (kDebugMode) {
        print('✅ 웹 환경 - 실기기로 처리');
      }
      return false;
    }

    _deviceInfo ??= DeviceInfoPlugin();

    try {
      // 2️⃣ Android 체크
      if (isAndroid) {
        final androidInfo = await _deviceInfo!.androidInfo;
        final isEmulator = !androidInfo.isPhysicalDevice;

        _cachedIsSimulator = isEmulator;

        if (kDebugMode) {
          print('🤖 Android 기기 정보:');
          print('- 모델: ${androidInfo.model}');
          print('- 제조사: ${androidInfo.manufacturer}');
          print('- 실기기 여부: ${androidInfo.isPhysicalDevice}');
          print('- 결과: ${isEmulator ? '에뮬레이터' : '실제 기기'}');
        }

        return isEmulator;
      }

      // 3️⃣ iOS 체크
      if (isIOS) {
        final iosInfo = await _deviceInfo!.iosInfo;
        final isSimulator = !iosInfo.isPhysicalDevice;

        _cachedIsSimulator = isSimulator;

        if (kDebugMode) {
          print('🍎 iOS 기기 정보:');
          print('- 모델: ${iosInfo.model}');
          print('- 기기명: ${iosInfo.name}');
          print('- 시스템명: ${iosInfo.systemName}');
          print('- 시스템 버전: ${iosInfo.systemVersion}');
          print('- 실기기 여부: ${iosInfo.isPhysicalDevice}');
          print('- 결과: ${isSimulator ? 'iOS 시뮬레이터' : 'iOS 실제 기기'}');
        }

        return isSimulator;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ 기기 정보 획득 실패: $e');
        print('🔄 환경변수 방식으로 폴백...');
      }

      // 폴백: 환경변수로 체크
      _cachedIsSimulator = _checkSimulatorByEnvironment();
      return _cachedIsSimulator!;
    }

    // 4️⃣ 기타 플랫폼은 실기기로 처리
    _cachedIsSimulator = false;
    if (kDebugMode) {
      print('❓ 알 수 없는 플랫폼 - 실기기로 처리');
    }
    return false;
  }

  // 🔄 환경변수로 시뮬레이터 체크 (폴백 방법)
  static bool _checkSimulatorByEnvironment() {
    if (isAndroid) {
      final model = Platform.environment['ANDROID_EMULATOR'] ?? '';
      final product = Platform.environment['ANDROID_PRODUCT'] ?? '';
      final device = Platform.environment['ANDROID_DEVICE'] ?? '';

      return model.contains('emulator') ||
          product.contains('sdk') ||
          device.contains('generic') ||
          device.contains('emulator');
    }

    if (isIOS) {
      final simulatorName = Platform.environment['SIMULATOR_DEVICE_NAME'];
      final simulatorModel = Platform.environment['SIMULATOR_MODEL_IDENTIFIER'];

      return simulatorName != null || simulatorModel != null;
    }

    return false;
  }

  // 🎯 현재 환경 정보를 로그로 출력 (비동기)
  static Future<void> printEnvironmentInfo() async {
    if (kDebugMode) {
      final isSimulatorResult = await isSimulator;

      print('🔍=== AdMob 플랫폼 환경 정보 ===');
      print('- 플랫폼: ${isIOS ? 'iOS' : isAndroid ? 'Android' : '기타'}');
      print('- 환경: ${isSimulatorResult ? '시뮬레이터/에뮬레이터' : '실제 기기'}');
      print('- AdMob 지원: ${isSupported ? '지원됨' : '지원 안됨'}');
      print('- kDebugMode: $kDebugMode');
      print('- kReleaseMode: $kReleaseMode');
      print('================================');
    }
  }

  // 🎯 광고 최적화를 위한 환경 타입 반환 (비동기)
  static Future<String> get environmentType async {
    final isSimulatorResult = await isSimulator;
    return isSimulatorResult ? 'simulator' : 'device';
  }

  // 🔧 광고 요청 시 추가할 테스트 설정이 필요한지 확인 (비동기)
  static Future<bool> get needsTestOptimization async {
    final isSimulatorResult = await isSimulator;
    // 시뮬레이터나 디버그 모드에서는 테스트 최적화 적용
    return isSimulatorResult || kDebugMode;
  }

  // 🚀 캐시 초기화 (필요 시 사용)
  static void clearCache() {
    _cachedIsSimulator = null;
    if (kDebugMode) {
      print('🔄 AdMobPlatformChecker 캐시 초기화됨');
    }
  }
}
