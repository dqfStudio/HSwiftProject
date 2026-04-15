# Uncomment the next line to define a global platform for your project'
platform :ios, '13.0'

target 'HSwiftProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HSwiftProject

  # pod 'SwiftyLoad'
  # pod 'SwizzleSwift'
  pod 'Alamofire', '5.6.1'
  pod 'Kingfisher', '~> 5.9.0'
  pod 'MJRefresh', '~> 3.3.1'
  pod 'SDWebImage', '~>5.19.0'
  pod 'GRDB.swift', '6.23.0'
  # 骨架屏
  pod 'TABAnimated', '2.6.3'

  # lottie动画
  pod 'lottie-ios', '3.5.0'

  # 布局
  pod 'SnapKit', '5.0.1'
  pod 'FlexLayout'
  pod 'PinLayout'

  # Rx
  pod 'RxSwift', '6.1.0'
  pod 'RxCocoa', '6.1.0'
  pod 'SnapKitExtend'

  pod 'ReactiveCocoa'
  pod 'OpenIMSDK'
  pod 'CombineCocoa'

  # 代码规范
  # pod 'SwiftLint', '0.43.1', configurations: ['Debug']

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
  end
end

