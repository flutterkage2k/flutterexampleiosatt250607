// 📁 파일 위치: lib/att/presentation/providers/att_ui_provider.dart
// 🎨 ATT 화면의 UI 상태를 관리하는 Provider
// 메시지 보여주기, 애니메이션 등 화면과 관련된 상태들을 처리해요
// providers 폴더는 앱의 상태를 관리하는 도구들을 모아둔 곳이에요
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/att_message_model.dart';

// ATT UI 상태를 관리하는 Provider
final attUIProvider = StateNotifierProvider<ATTUINotifier, ATTUIState>((ref) {
  return ATTUINotifier();
});

// ATT UI의 상태 정보
class ATTUIState {
  // 현재 보여줄 메시지 (없으면 null)
  final ATTMessageModel? message;

  // 화면이 로딩 중인가?
  final bool isLoading;

  ATTUIState({this.message, this.isLoading = false});

  // 상태 복사해서 일부만 바꾸기
  ATTUIState copyWith({ATTMessageModel? message, bool? isLoading}) {
    return ATTUIState(message: message ?? this.message, isLoading: isLoading ?? this.isLoading);
  }
}

// ATT UI 상태를 관리하는 클래스
class ATTUINotifier extends StateNotifier<ATTUIState> {
  // 처음에는 비어있는 상태로 시작
  ATTUINotifier() : super(ATTUIState());

  // 메시지 보여주기
  void showMessage(String message, ATTMessageType type) {
    state = state.copyWith(
      message: ATTMessageModel(message: message, type: type),
    );
  }

  // 메시지 숨기기
  void hideMessage() {
    state = state.copyWith(message: null);
  }

  // 로딩 시작
  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  // 로딩 끝
  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }
}
