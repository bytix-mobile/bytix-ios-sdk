Pod::Spec.new do |spec|
  spec.name                    = "Bytix"
  spec.version                 = "1.0.0"
  spec.platform                = :ios, '12.0'
  spec.ios.deployment_target   = '12.0'
  spec.summary                 = "Bytix iOS SDK"
  spec.description             = "SDK for control beacons with CoreBluetooth"
  spec.homepage                = "https://github.com/bytix-mobile/bytix-ios-sdk"
  spec.documentation_url       = "https://github.com/bytix-mobile/bytix-ios-sdk/blob/main/README.md"
  spec.license                 = { :type => 'MIT', :text => 'LICENSE' }
  spec.author                  = { "Bytix-Mobile" => "..." }
  spec.swift_version           = "5.0"
  spec.source                  = { :http => 'https://github.com/bytix-mobile/bytix-ios-sdk/releases/download/1.0.0/Bytix.xcframework.zip' }
  spec.ios.vendored_frameworks = 'Bytix.xcframework'
  spec.dependency 'SwiftProtobuf', '~> 1.0'
end