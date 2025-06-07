// 📁 파일 위치: lib/att/presentation/providers/att_request_provider.dart
// 🙋‍♀️ ATT 권한 요청을 처리하는 Provider
// 사용자가 버튼을 눌렀을 때 권한을 요청하고 결과를 처리해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../repository/att_platform_repository.dart';
import 'att_status_provider.dart';

// ATT 권한 요청을 관리하는 Provider
final attRequestProvider = StateNotifierProvider<ATTRequestNotifier, bool>((ref) {
  return ATTRequestNotifier(ref);
});

// ATT 권한 요청을 관리하는 클래스
class ATTRequestNotifier extends StateNotifier<bool> {
  final Ref _ref;

  // 처음에는 요청 중이 아닌 상태로 시작
  ATTRequestNotifier(this._ref) : super(false);

  // ATT 권한 요청하기
  Future<void> requestPermission() async {
    // 요청 시작 - 버튼 비활성화
    state = true;

    try {
      // 실제 권한 요청하기
      final result = await ATTPlatformRepository.requestTrackingAuthorization();

      // 결과를 상태 Provider에 업데이트
      _ref.read(attStatusProvider.notifier).updateStatus(result);
    } catch (e) {
      // 오류가 생겨도 일단 상태 확인
      await _ref.read(attStatusProvider.notifier).checkStatus();
    } finally {
      // 요청 완료 - 버튼 다시 활성화
      state = false;
    }
  }

  // 권한 요청 중인지 확인
  bool get isRequesting => state;
}
