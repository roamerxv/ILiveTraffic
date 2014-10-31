source 'https://github.com/CocoaPods/Specs.git'

platform :ios ,  '8.1'
#pod 'MMProgressHUD', :git => 'https://github.com/mutualmobile/MMProgressHUD.git'
pod  'MMProgressHUD',  :inhibit_warnings => true
pod 'Shimmer'
pod 'CorePlot', :inhibit_warnings => true
pod 'PPRevealSideViewController', '~> 1.1.0', :inhibit_warnings => true
#pod 'RHManagedObject'
pod 'UIDeviceAddition'
pod 'SBJson'
pod 'TCBlobDownload'
#pod 'JJTopMenu', '~> 1.0.1'
pod 'ArcGIS-Runtime-SDK-iOS', '=10.2.3'
pod 'TCBlobDownload', '=1.5.0'
pod 'UAProgressView'   #圆形进度条
pod 'GPUImage' , :inhibit_warnings => true
pod 'AMSmoothAlert'  # 弹出式提示窗
pod 'STAlertView'  #带输入的弹出提示窗

#pod "CNPGridMenu" #弹出式的菜单

pod 'KLCPopup' #弹出式菜单


# Remove 64-bit build architecture from Pods targets
post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |configuration|
            target.build_settings(configuration.name)['ARCHS'] = '$(ARCHS_STANDARD_32_BIT)'
        end
    end
end