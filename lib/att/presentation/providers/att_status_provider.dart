// 📁 파일 위치: lib/att/presentation/providers/att_status_provider.dart
// 🔄 ATT 권한 상태를 관리하는 Provider
// 현재 권한이 허용됐는지 거부됐는지를 추적해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/att_status_model.dart';
import '../../repository/att_platform_repository.dart';

// ATT 상태를 관리하는 Provider
final attStatusProvider = StateNotifierProvider<ATTStatusNotifier, ATTStatusModel?>((ref) {
  return ATTStatusNotifier();
});

// ATT 상태를 관리하는 클래스
class ATTStatusNotifier extends StateNotifier<ATTStatusModel?> {
  // 처음에는 상태를 모르는 상태로 시작
  ATTStatusNotifier() : super(null);

  // 현재 ATT 권한 상태 확인하기
  Future<void> checkStatus() async {
    final status = await ATTPlatformRepository.getTrackingStatus();
    state = status;
  }

  // ATT 상태 업데이트하기
  void updateStatus(ATTStatusModel newStatus) {
    state = newStatus;
  }
}

// 권한이 허용되었는지만 간단히 확인하는 Provider
final isATTAuthorizedProvider = Provider<bool>((ref) {
  final status = ref.watch(attStatusProvider);
  return status?.isAuthorized ?? false;
});
