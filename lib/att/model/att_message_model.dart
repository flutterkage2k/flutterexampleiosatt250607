// 📁 파일 위치: lib/att/model/att_message_model.dart
// 💬 사용자에게 보여줄 메시지를 담는 데이터 모델
// 권한 상태에 따라 다른 메시지를 보여주기 위해 사용해요
// model 폴더는 앱에서 사용하는 데이터의 형태를 정의하는 곳이에요

class ATTMessageModel {
  // 보여줄 메시지 내용
  final String message;

  // 메시지 종류 (성공, 에러, 정보 등)
  final ATTMessageType type;

  // 새로운 메시지 만들기
  ATTMessageModel({required this.message, required this.type});
}

// 메시지의 종류
enum ATTMessageType {
  // 성공 메시지 (초록색으로 표시)
  success,

  // 에러 메시지 (빨간색으로 표시)
  error,

  // 일반 정보 메시지 (파란색으로 표시)
  info,
}
