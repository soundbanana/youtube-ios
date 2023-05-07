platform :ios, '14.0'
use_frameworks!
# ignore all warnings from all pods
inhibit_all_warnings!
target 'BananaTube' do
    pod 'SwiftLint', '~> 0.46.2'   
    pod 'Kingfisher', '~> 7.0'
    pod 'youtube-ios-player-helper'
    pod 'GoogleSignIn'
    pod 'GoogleAPIClientForREST/YouTube'
    pod 'Firebase/Auth'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
            end
        end
    end
end