# App Tracking Transparency 권한 표현 강화 모듈 앱

## 머리말 

본 앱은 보다 쉽게 google admob 을 적용하는 앱에 대해서 ios ATT관련 리젝을 피하기 위해서 만들어진 모듈입니다. 
part 처럼 사용자의 앱에 한부분에 넣어서 몇개의 수정으로 쉽게 연결 사용할 수 있습니다. 

| ![Image](https://github.com/user-attachments/assets/16108d2c-b961-4a3d-bc5c-8b331a768d6f) | ![Image](https://github.com/user-attachments/assets/ace8eee2-e8bd-451b-9c80-a1d0ededfb59)|
| --- | --- |
| ![Image](https://github.com/user-attachments/assets/f32955d1-b574-4e27-9852-8ec6f16368e0) | ![Image](https://github.com/user-attachments/assets/56d50f1b-cb26-41a0-a8ac-d3a562cedf08)|


!!! success "보다 자세한 내용은 아래의 링크"



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