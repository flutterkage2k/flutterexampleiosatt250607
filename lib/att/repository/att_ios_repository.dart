// 📁 파일 위치: lib/att/repository/att_ios_repository.dart
// 📱 아이폰에서 실제 ATT 권한을 처리하는 곳
// 아이폰의 ATT API와 직접 소통하는 역할을 해요
// repository 폴더는 데이터를 가져오고 저장하는 기능들을 모아둔 곳이에요
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import '../model/att_status_model.dart';

class ATTiOSRepository {
  // 현재 ATT 권한 상태를 확인하기
  static Future<ATTStatusModel> getTrackingStatus() async {
    try {
      // 아이폰에서 현재 권한 상태 가져오기
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;

      // 아이폰 상태를 우리 앱 상태로 바꾸기
      ATTStatus attStatus;
      switch (status) {
        case TrackingStatus.authorized:
          attStatus = ATTStatus.authorized;
          break;
        case TrackingStatus.denied:
        case TrackingStatus.restricted:
          attStatus = ATTStatus.denied;
          break;
        default:
          attStatus = ATTStatus.unknown;
      }

      // 현재 시간과 함께 상태 정보 만들어서 돌려주기
      return ATTStatusModel(status: attStatus, timestamp: DateTime.now());
    } catch (e) {
      // 오류가 생기면 알 수 없는 상태로 처리
      return ATTStatusModel(status: ATTStatus.unknown, timestamp: DateTime.now());
    }
  }

  // 사용자에게 ATT 권한 요청하기
  static Future<ATTStatusModel> requestTrackingAuthorization() async {
    try {
      // 아이폰에 권한 요청 팝업 띄우기
      final status = await AppTrackingTransparency.requestTrackingAuthorization();

      // 사용자의 선택을 우리 앱 상태로 바꾸기
      ATTStatus attStatus;
      switch (status) {
        case TrackingStatus.authorized:
          attStatus = ATTStatus.authorized;
          break;
        case TrackingStatus.denied:
        case TrackingStatus.restricted:
          attStatus = ATTStatus.denied;
          break;
        default:
          attStatus = ATTStatus.unknown;
      }

      // 현재 시간과 함께 결과 돌려주기
      return ATTStatusModel(status: attStatus, timestamp: DateTime.now());
    } catch (e) {
      // 오류가 생기면 알 수 없는 상태로 처리
      return ATTStatusModel(status: ATTStatus.unknown, timestamp: DateTime.now());
    }
  }
}
