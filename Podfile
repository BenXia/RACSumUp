platform :ios, '13.0'

# Uncomment the next line if you're using Swift or would like to use dynamic frameworks
use_frameworks!

inhibit_all_warnings!

target "TestTemplateProject" do
    pod 'SDWebImage'
    pod 'Masonry'
    pod 'IQKeyboardManager'
    pod 'SnapKit'
    pod 'ReactiveObjC'
    pod 'ReactiveSwift'
    pod 'ReactiveCocoa'
    pod 'ReactiveObjCBridge'
end

post_install do |installer|
    project = installer.pods_project
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_STRICT_PROTOTYPES'] = 'NO'
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
