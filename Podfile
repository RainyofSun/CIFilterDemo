platform :ios, '13.0'

target 'GPUImage3Demo' do
  pod 'Vivid', '0.9'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGN_IDENTITY'] = ''
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
  end
end
