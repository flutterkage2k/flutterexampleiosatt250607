// 📁 파일 위치: lib/admob/model/admob_context_model.dart
// 📊 광고가 어디서 호출되었는지 구분하는 데이터 모델
// Study인지 Review인지에 따라 다른 횟수로 전면광고를 보여줘요
// model 폴더는 앱에서 사용하는 데이터의 형태를 정의하는 곳이에요

// 광고가 호출되는 상황의 종류
enum AdMobContextType {
  // 학습할 때 (3번마다 전면광고)
  study,

  // 복습할 때 (5번마다 전면광고)
  review,
}

// 광고 컨텍스트 정보를 담는 클래스
class AdMobContextModel {
  // 어떤 상황에서 광고가 호출되었나요?
  final AdMobContextType type;

  // 어디서 광고가 호출되었나요? (디버깅용)
  final String? location;

  // 언제 이 컨텍스트가 만들어졌나요?
  final DateTime timestamp;

  // 새로운 광고 컨텍스트 만들기
  AdMobContextModel({
    required this.type,
    this.location,
    required this.timestamp,
  });

  // 학습 상황인가요?
  bool get isStudy => type == AdMobContextType.study;

  // 복습 상황인가요?
  bool get isReview => type == AdMobContextType.review;
}
