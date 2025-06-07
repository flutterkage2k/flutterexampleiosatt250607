# App Tracking Transparency 권한 표현 강화 모듈 앱

## 머리말 

본 앱은 보다 쉽게 google admob 을 적용하는 앱에 대해서 ios ATT관련 리젝을 피하기 위해서 만들어진 모듈입니다. 
part 처럼 사용자의 앱에 한부분에 넣어서 몇개의 수정으로 쉽게 연결 사용할 수 있습니다. 

| ![Image](https://github.com/user-attachments/assets/16108d2c-b961-4a3d-bc5c-8b331a768d6f) | ![Image](https://github.com/user-attachments/assets/ace8eee2-e8bd-451b-9c80-a1d0ededfb59)|
| --- | --- |
| ![Image](https://github.com/user-attachments/assets/f32955d1-b574-4e27-9852-8ec6f16368e0) | ![Image](https://github.com/user-attachments/assets/56d50f1b-cb26-41a0-a8ac-d3a562cedf08)|


> ** "보다 자세한 내용은 아래의 링크" **
> https://is.gd/aqto5W




### ios cocoapod를 설정하기에 아래의 몇개 부분은 수정되었습니다. 

ios/Flutter/Debug.xcconfig
```
#include "Generated.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.debug.xcconfig"
```

ios/Flutter/Release.xcconfig
```
#include "Generated.xcconfig"
#include "Pods/Target Support Files/Pods-Runner/Pods-Runner.release.xcconfig"
```

ios/Podfile
```
# iOS 최소 버전 설정
platform :ios, '15.0'

# CocoaPods 통계 비활성화 (빌드 속도 향상)
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

# 프로젝트 빌드 구성
project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!
  
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    
    target.build_configurations.each do |config|
      # 기본 설정
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      
      # 시뮬레이터 ARM64 제외 (Intel Mac 호환성)
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
      
      # ATT관련 광고 추적 권한 설정 (Google Mobile Ads용)
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_APP_TRACKING_TRANSPARENCY=1',
      ]

      
    end
  end
end
```


info.plist
```
<!--생략 -->

    <!-- 🔐 추적 관련 권한 설명 -->
    <key>NSUserTrackingUsageDescription</key>
    <string>사용자에게 맞춤형 광고를 제공하기 위해 광고 활동 정보를 수집합니다.</string>

<!--생략 -->

```

# Admob 추가

> lib/admob/core/constants/admob_ad_units.dart
배너 / 전면 실제 ID 추가해야함.


> 환경 설정 (admob_constants.dart) - 현재 설정 test

```
static const String environment = 'test'; // 🔧 여기서 변경!
// 'test' → 테스트 광고 (수익 없음, 안전)
// 'real' → 실제 광고 (수익 발생, 승인된 앱만)
```


### android / ios 필수 추가 사항

> android/app/src/main/AndroidManifest.xml

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- 필수 권한 -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> 
     <!--20.4.0 이하는 admob 사용시 선언 필수-->
    <uses-permission android:name="com.google.android.gms.permission.AD_ID" />

생략

        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
    </application>
```

> ios/Runner/Info.plist

```
    <!-- 📈 Google AdMob 설정 -->
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-5673747993774414~2343851447</string>
    <key>NSAdvertisingAttributionReportEndpoint</key>
    <string>https://adservice.google.com</string>

    <!-- 🎯 SKAdNetwork 식별자 -->
    <key>SKAdNetworkItems</key>
    <array>
        <dict>
            <key>SKAdNetworkIdentifier</key>
            <string>cstr6suwn9.skadnetwork</string>
        </dict>
    </array>
```

### Debug console sample

> 광고는 시뮬레이터에서는 작동을 안합니다(경우에따라 되지만), 실제 디바이스에서 테스트 하세요.

```
flutter: 🚀 Root 페이지로 이동 시도
flutter: ✅ Root 페이지 이동 명령 완료
flutter: 🎮 AdMob 테스트 버튼 클릭됨
flutter: 🚀 AdMob 테스트 화면으로 이동 시도
flutter: 🛡️ 안전한 AdMob 테스트 화면 로딩 중
flutter: 🔧 AdMob 초기화 확인 중...
flutter: 📱 AdMob 초기화 상태 확인 중...
2
flutter: 🔍 실기기/시뮬레이터 정확한 체크 시작...
flutter: 🍎 iOS 기기 정보:
flutter: - 모델: iPhone
flutter: - 기기명: iPhone
flutter: - 시스템명: iOS
flutter: - 시스템 버전: 18.5
flutter: - 실기기 여부: true
flutter: - 결과: iOS 실제 기기
flutter: 🔧 실제 기기용 설정 적용 중...
flutter: 🍎 iOS 기기 정보:
flutter: - 모델: iPhone
flutter: - 기기명: iPhone
flutter: - 시스템명: iOS
flutter: - 시스템 버전: 18.5
flutter: - 실기기 여부: true
flutter: - 결과: iOS 실제 기기
flutter: 🔧 실제 기기용 설정 적용 중...
flutter: ✅ AdMob 초기화 완료
flutter: ✅ 실제 기기용 설정 완료
flutter: 🎯 배너 광고 로딩 시작 (실제 기기)
flutter:    - 광고 ID: ca-app-pub-3940256099942544/2934735716
flutter:    - 환경: test
flutter: ✅ 실제 기기용 설정 완료
flutter: 🎯 전면 광고 로딩 시작 (실제 기기)
flutter:    - 광고 ID: ca-app-pub-3940256099942544/4411468910
flutter:    - 환경: test
2
flutter: 🔧 실제 기기용 광고 요청 생성
flutter: ✅ 배너 광고 로딩 성공! (실제 기기)
flutter: ✅ 배너 광고 로딩 성공
flutter: ✅ 전면 광고 로딩 성공! (실제 기기)
flutter: ✅ 전면 광고 로딩 성공
```