platform :ios, '14.0'
use_frameworks!
target 'BananaTube' do
    pod 'SwiftLint', '~> 0.46.2'   
    pod 'Kingfisher', '~> 7.0'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
                config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            end
        end
    end
end