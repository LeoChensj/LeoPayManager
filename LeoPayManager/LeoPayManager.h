//
//  LeoPayManager.h
//  Leo.Chen
//
//  Created by 陈仕军 on 16/12/19.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
#import "WechatAuthSDK.h"

#import <AlipaySDK/AlipaySDK.h>

#import "UPPaymentControl.h"



/*
 respCode:
 0    -    支付成功
 -1   -    支付失败
 -2   -    支付取消
 -3   -    未安装App（适用于微信）
 -99  -    未知错误
 */
typedef void (^LeoPayManagerRespBlock)(NSInteger respCode, NSString *respMsg);


@interface LeoPayManager : NSObject <WXApiDelegate>

+ (LeoPayManager *)getInstance;


//***************微信*****************//

/*
 微信支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock wechatRespBlock;

/*
 检查是否安装微信
 */
+ (BOOL)isWXAppInstalled;

/*
 注册微信appId
 */
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId description:(NSString *)description;

/*
 处理微信通过URL启动App时传递回来的数据
 */
+ (BOOL)wechatHandleOpenURL:(NSURL *)url;

/*
 发起微信支付
 */
- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign;

/*
 添加微信支付结果回调
 */
- (void)addWechatPayRespBlock:(LeoPayManagerRespBlock)block;





//***************支付宝*****************//

/*
 支付宝支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock alipayRespBlock;

/*
 处理支付宝通过URL启动App时传递回来的数据
 */
+ (BOOL)alipayHandleOpenURL:(NSURL *)url;

/*
  发起支付宝支付
 */
- (void)payOrder:(NSString *)order scheme:(NSString *)scheme;

/*
 添加支付宝支付结果回调
 */
- (void)addAliPayRespBlock:(LeoPayManagerRespBlock)block;



//***************银联*****************//

/*
 银联支付结果回调
 */
@property (nonatomic, strong)LeoPayManagerRespBlock unionRespBlock;

/*
 处理银联通过URL启动App时传递回来的数据
 */
+ (BOOL)unionHandleOpenURL:(NSURL*)url;

/*
 发起银联支付
 */
- (void)unionPayWithSerialNo:(NSString *)serialNo viewController:(id)viewController;

/*
 添加银联支付结果回调
 */
- (void)addUnionPayRespBlock:(LeoPayManagerRespBlock)block;


@end
