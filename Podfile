# Uncomment the next line to define a global platform for your project
 platform :ios, '12.1'

source 'https://github.com/trusttechnologies/TrustDeviceInfoPodSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'appNotifications' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'MaterialComponents/Buttons'
  pod 'MaterialComponents/Buttons+ButtonThemer'
  # Pods for appNotifications
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'TrustDeviceInfo'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = ‘4.2’
      end
    end
    
    installer.pods_project.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
  
end
