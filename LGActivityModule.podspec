
Pod::Spec.new do |s|
  s.name             = 'LGActivityModule'
  s.version          = '0.1.0'
  s.summary          = '活动组件.'
  s.description      = <<-DESC
    运营活动组件
                       DESC

  s.homepage         = 'https://github.com/applekwork/LGActivityModule.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LG' => 'applekwork@163.com' }
  s.source           = { :git => 'https://github.com/applekwork/LGActivityModule.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.source_files = 'LGActivityModule/Classes/**/*'
  
  s.resource_bundles = {
     'LGActivityModule' => ['LGActivityModule/Assets/*.png']
   }

  s.public_header_files = 'LGActivityModule/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.framework = 'CoreTelephony','CoreMotion'
   s.dependency 'AFNetworking', '= 3.2.1'
   s.dependency 'MJExtension', '= 3.0.15.1'
   s.dependency 'SDWebImage', '=4.2.2'
   s.dependency 'Masonry', '= 1.1.0'
   s.dependency 'YYModel', '= 1.0.4'
end


