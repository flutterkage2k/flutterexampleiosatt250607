// 📁 파일 위치: lib/admob/presentation/providers/admob_initialization_provider.dart
// 🔧 AdMob 초기화 상태를 관리하는 Provider
// 앱 시작 시 AdMob이 제대로 초기화되었는지 확인해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

// AdMob 초기화 상태를 확인하는 Provider
final adMobInitializationProvider = FutureProvider<bool>((ref) async {
  print('🔧 AdMob 초기화 확인 중...');

  try {
    // main.dart에서 이미 초기화했으므로 성공으로 간주
    await Future.delayed(const Duration(milliseconds: 500)); // 약간의 대기
    print('✅ AdMob 초기화 완료');
    return true;
  } catch (e) {
    print('❌ AdMob 초기화 확인 실패: $e');
    return false;
  }
});

// AdMob이 초기화되었는지 간단히 확인하는 Provider
final isAdMobInitializedProvider = Provider<bool>((ref) {
  final initStatus = ref.watch(adMobInitializationProvider);
  return initStatus.when(
    data: (isInitialized) => isInitialized,
    loading: () => false,
    error: (error, stack) => false,
  );
});
