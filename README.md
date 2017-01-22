# LeoPayManager

集成主流支付方式
1.目前支持Apple Pay、微信、支付宝、银联。
2.需要开发者自己去相应开放平台注册商户号，并且创建应用，等到appId等参数。
3.需要开发者自己配置info.plist文件，ATS以及微信、支付宝、银联白名单以及URL Types。
4.本框架不提供支付参数签名，处于安全考虑，统一把支付参数签名至于后端，所以在实际开发中需要后端提供获取支付参数接口。


已加入cocoapods豪华午餐
pod 'LeoPayManager'


联系方式：LeoChensj@163.com