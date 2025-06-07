// 📁 파일 위치: lib/att/repository/att_platform_repository.dart
// 🔀 아이폰과 안드로이드를 구분해서 처리하는 곳
// 아이폰에서는 실제 ATT 기능을, 안드로이드에서는 자동 허용을 해요
// repository 폴더는 데이터를 가져오고 저장하는 기능들을 모아둔 곳이에요
import '../core/att_platform_checker.dart';
import '../model/att_status_model.dart';
import 'att_ios_repository.dart';

class ATTPlatformRepository {
  // 현재 ATT 권한 상태 확인하기 (아이폰/안드로이드 구분)
  static Future<ATTStatusModel> getTrackingStatus() async {
    // 아이폰인가요?
    if (ATTPlatformChecker.isIOS) {
      // 아이폰이면 실제 ATT 상태 확인
      return await ATTiOSRepository.getTrackingStatus();
    } else {
      // 안드로이드나 다른 기기면 자동으로 허용 상태로 처리
      return ATTStatusModel(status: ATTStatus.authorized, timestamp: DateTime.now());
    }
  }

  // ATT 권한 요청하기 (아이폰/안드로이드 구분)
  static Future<ATTStatusModel> requestTrackingAuthorization() async {
    // 아이폰인가요?
    if (ATTPlatformChecker.isIOS) {
      // 아이폰이면 실제 권한 요청 팝업 띄우기
      return await ATTiOSRepository.requestTrackingAuthorization();
    } else {
      // 안드로이드나 다른 기기면 바로 허용 상태로 처리
      return ATTStatusModel(status: ATTStatus.authorized, timestamp: DateTime.now());
    }
  }
}
