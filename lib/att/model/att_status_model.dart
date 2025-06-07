// 📁 파일 위치: lib/att/model/att_status_model.dart
// 📊 ATT 권한의 상태를 나타내는 데이터 모델
// 권한이 허용됐는지, 거부됐는지, 아직 모르는지를 구분해요
// model 폴더는 앱에서 사용하는 데이터의 형태를 정의하는 곳이에요

// ATT 권한의 3가지 상태
enum ATTStatus {
  // 아직 권한을 요청하지 않았거나 상태를 모름
  unknown,

  // 사용자가 권한을 허용함
  authorized,

  // 사용자가 권한을 거부함
  denied,
}

// ATT 상태 정보를 담는 클래스
class ATTStatusModel {
  // 현재 ATT 권한 상태
  final ATTStatus status;

  // 언제 이 상태가 만들어졌는지
  final DateTime timestamp;

  // 새로운 ATT 상태 정보 만들기
  ATTStatusModel({required this.status, required this.timestamp});

  // 권한이 허용되었나요?
  bool get isAuthorized => status == ATTStatus.authorized;

  // 권한이 거부되었나요?
  bool get isDenied => status == ATTStatus.denied;

  // 권한 상태를 아직 모르나요?
  bool get isUnknown => status == ATTStatus.unknown;
}
