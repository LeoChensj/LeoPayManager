//
//  LeoPayManager.m
//  Leo.Chen
//
//  Created by 陈仕军 on 16/12/19.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "LeoPayManager.h"

@implementation LeoPayManager

+ (LeoPayManager *)getInstance
{
    static LeoPayManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[LeoPayManager alloc] init];
        
    });
    
    return instance;
}



//微信
+ (BOOL)isWXAppInstalled
{
    return [WXApi isWXAppInstalled];
}
+ (BOOL)wechatRegisterAppWithAppId:(NSString *)appId description:(NSString *)description;
{
    return [WXApi registerApp:appId withDescription:description];
}
+ (BOOL)wechatHandleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[LeoPayManager getInstance]];
}
- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign
{
    if([WXApi isWXAppInstalled])
    {
        PayReq *req = [[PayReq alloc] init];
        req.openID = appId;
        req.partnerId = partnerId;
        req.prepayId = prepayId;
        req.package = package;
        req.nonceStr = nonceStr;
        req.timeStamp = (UInt32)timeStamp.integerValue;
        req.sign = sign;
        [WXApi sendReq:req];
    }
    else
    {
        if(_wechatRespBlock)
        {
            _wechatRespBlock(-3, @"未安装微信");
        }
    }
}
- (void)addWechatPayRespBlock:(LeoPayManagerRespBlock)block
{
    _wechatRespBlock = block;
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[PayResp class]])
    {
        switch (resp.errCode)
        {
            case 0:
            {
                if(_wechatRespBlock)
                {
                    _wechatRespBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(_wechatRespBlock)
                {
                    _wechatRespBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(_wechatRespBlock)
                {
                    _wechatRespBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(_wechatRespBlock)
                {
                    _wechatRespBlock(-99, @"未知错误");
                }
            }
                break;
        }
    }
}
//微信






//支付宝
+ (BOOL)alipayHandleOpenURL:(NSURL *)url
{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        LeoPayManager *manager = [LeoPayManager getInstance];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==8000)
        {
            //正在处理中
        }
        else if(code.integerValue==4000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-2, @"支付取消");
            }
        }
        else if(code.integerValue==6002)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    return YES;
}
- (void)payOrder:(NSString *)order scheme:(NSString *)scheme
{
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        LeoPayManager *manager = [LeoPayManager getInstance];
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==8000)
        {
            //正在处理中
        }
        else if(code.integerValue==4000)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-2, @"支付取消");
            }
        }
        else if(code.integerValue==6002)
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-1, @"支付失败");
            }
        }
        else
        {
            if(manager.alipayRespBlock)
            {
                manager.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
}
- (void)addAliPayRespBlock:(LeoPayManagerRespBlock)block
{
    _alipayRespBlock = block;
}
//支付宝








//银联
+ (BOOL)unionHandleOpenURL:(NSURL*)url
{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        
        LeoPayManager *payManager = [LeoPayManager getInstance];
        
        if([code isEqualToString:@"success"])
        {
            if(payManager.unionRespBlock)
            {
                payManager.unionRespBlock(0, @"支付成功");
            }
                
        }
        else if([code isEqualToString:@"fail"])
        {
            if(payManager.unionRespBlock)
            {
                payManager.unionRespBlock(-1, @"支付失败");
            }
        }
        else if([code isEqualToString:@"cancel"])
        {
            if(payManager.unionRespBlock)
            {
                payManager.unionRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(payManager.unionRespBlock)
            {
                payManager.unionRespBlock(-99, @"未知错误");
            }
        }
        
    }];
    
    return YES;
}
- (void)unionPayWithSerialNo:(NSString *)serialNo viewController:(id)viewController
{
    NSString *mode = @"00";
    
    [[UPPaymentControl defaultControl] startPay:serialNo fromScheme:@"UnionPay" mode:mode viewController:viewController];
}
- (void)addUnionPayRespBlock:(LeoPayManagerRespBlock)block;
{
    _unionRespBlock = block;
}
//银联








@end
