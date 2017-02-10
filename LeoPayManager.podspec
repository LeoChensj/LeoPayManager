
Pod::Spec.new do |s|

  s.name         = "LeoPayManager"
  s.version      = "1.0.1"
  s.summary      = "集成主流支付方式"
  s.description  = <<-DESC
                   集成主流支付方式，包括Apple Pay、微信、支付宝、银联
                   DESC

  s.homepage     = "https://github.com/LeoChensj/LeoPayManager"
  s.license      = "MIT"
  s.author             = { "LeoChen" => "LeoChensj@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LeoChensj/LeoPayManager.git", :tag => "#{s.version}" }
  s.source_files  = "LeoPayManager/*.{h,m}"
  s.public_header_files = "LeoPayManager/LeoPayManager.h"
  s.requires_arc = true
  s.dependency "ApplePay_SDK"
  s.dependency "WeChat_SDK_iOS"
  s.dependency "Alipay_SDK_iOS"
  s.dependency "UnionPay_SDK_iOS"

end
