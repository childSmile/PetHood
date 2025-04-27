# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# 忽略引入库的所有警告
inhibit_all_warnings!

#flutter_application_path = '../pethood_flutter'
#load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

# 源
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/aliyun/aliyun-specs.git'


$flutter_debug = false

target 'PetHood' do
  #use_frameworks!
#  install_all_flutter_pods(flutter_application_path)
  
  pod 'AFNetworking'
  pod 'Masonry'
  pod 'MBProgressHUD'
#  pod 'ReactiveCocoa',:git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
  pod 'SnapKit'
  pod 'SnapKitExtend', '~> 1.1.0' # https://github.com/spicyShrimp/SnapKitExtend
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Toast-Swift'
  pod 'Starscream'
  pod 'Moya/RxSwift'
  pod 'ObjectMapper'
  pod 'HandyJSON'
  pod 'DGCharts'
#pod 'Charts'
  pod 'YBAttributeTextTapAction'
#  pod 'CocoaLumberjack/Swift'
#  pod 'SVGKit'
#  pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '2.x'
  


  
  #3D地图 SDK
#  pod 'AMap3DMap-NO-IDFA' # AMap3DMap
  #导航SDK
  pod 'AMapNavi-NO-IDFA'  #AMapNavi
  #定位SDK
  pod 'AMapLocation-NO-IDFA' #AMapLocation
  #搜索功能
  pod 'AMapSearch-NO-IDFA' #AMapSearch
  
end



#处理警告⚠️,勿删
post_install do |installer|
  
#  flutter_post_install(installer) if defined?(flutter_post_install)
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
  
  
end


