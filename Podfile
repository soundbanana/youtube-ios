platform :ios, '14.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!
target 'BananaTube' do
    pod 'SwiftLint', '~> 0.46.2'   
    pod 'Kingfisher', '~> 7.0'
    pod 'youtube-ios-player-helper'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
                config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
                config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
            end
        end
    end
end