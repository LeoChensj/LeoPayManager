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



//Apple Pay
+ (LeoApplePaySupportStatus)isCanApplePay;
{
    LLAPPaySupportStatus status = [LLAPPaySDK canDeviceSupportApplePayPayments];
    
    if(status==kLLAPPayDeviceSupport)
    {
        return kLeoApplePaySupport;
    }
    else if(status==kLLAPPayDeviceNotSupport || status==kLLAPPayDeviceVersionTooLow)
    {
        return kLeoApplePayDeviceOrVersionNotSupport;
    }
    else if(status==kLLAPPayDeviceNotBindChinaUnionPayCard)
    {
        return kLeoApplePaySupportNotBindCard;
    }
    
    return kLeoApplePayUnknown;
}

+ (void)showWalletToBindCard
{
    [LLAPPaySDK showWalletToBindCard];
}

- (void)applePayWithTraderInfo:(NSDictionary *)traderInfo
           viewController:(UIViewController *)viewController
                respBlock:(LeoPayManagerRespBlock)block
{
    self.applePayRespBlock = block;
    
    if([LeoPayManager isCanApplePay]==kLeoApplePaySupport)
    {
        LLAPPaySDK *llAPPaySDK = [LLAPPaySDK sharedSdk];
        llAPPaySDK.sdkDelegate = self;
        
        [llAPPaySDK payWithTraderInfo:traderInfo inViewController:viewController];
    }
    else
    {
        if(self.applePayRespBlock)
        {
            self.applePayRespBlock(-4, @"设备或系统不支持，或者用户未绑卡");
        }
    }
}

#pragma mark - LLPaySdkDelegate
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic
{
    NSString *msg;
    
    switch (resultCode)
    {
        case kLLPayResultSuccess:
        {
            msg = @"支付成功";
            
            NSString* result_pay = dic[@"result_pay"];
            if ([result_pay isEqualToString:@"SUCCESS"])
            {
                if(self.applePayRespBlock)
                {
                    self.applePayRespBlock(0, @"支付成功");
                }
            }
            else
            {
                if(self.applePayRespBlock)
                {
                    self.applePayRespBlock(-1, @"支付失败");
                }
            }
        }
            break;
        case kLLPayResultFail:
        {
            if(self.applePayRespBlock)
            {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        case kLLPayResultCancel:
        {
            if(self.applePayRespBlock)
            {
                self.applePayRespBlock(-2, @"支付取消");
            }
        }
            break;
        case kLLPayResultInitError:
        {
            if(self.applePayRespBlock)
            {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        case kLLPayResultInitParamError:
        {
            if(self.applePayRespBlock)
            {
                self.applePayRespBlock(-1, @"支付失败");
            }
        }
            break;
        default:
        {
            if(self.applePayRespBlock)
            {
                self.applePayRespBlock(-99, @"未知错误");
            }
        }
            break;
    }
}
//Apple Pay


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
- (void)wechatPayWithAppId:(NSString *)appId partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(NSString *)timeStamp sign:(NSString *)sign respBlock:(LeoPayManagerRespBlock)block
{
    self.wechatRespBlock = block;
    
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
        if(self.wechatRespBlock)
        {
            self.wechatRespBlock(-3, @"未安装微信");
        }
    }
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
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(0, @"支付成功");
                }
                
                NSLog(@"支付成功");
                break;
            }
            case -1:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-1, @"支付失败");
                }
                
                NSLog(@"支付失败");
                break;
            }
            case -2:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-2, @"支付取消");
                }
                
                NSLog(@"支付取消");
                break;
            }
                
            default:
            {
                if(self.wechatRespBlock)
                {
                    self.wechatRespBlock(-99, @"未知错误");
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
        else if(code.integerValue==4000 || code.integerValue==6002)
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
- (void)aliPayOrder:(NSString *)order scheme:(NSString *)scheme respBlock:(LeoPayManagerRespBlock)block
{
    self.alipayRespBlock = block;
    
    __weak __typeof(&*self)ws = self;
    [[AlipaySDK defaultService] payOrder:order fromScheme:scheme callback:^(NSDictionary *resultDic) {
        
        NSNumber *code = resultDic[@"resultStatus"];
        
        if(code.integerValue==9000)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(0, @"支付成功");
            }
        }
        else if(code.integerValue==4000 || code.integerValue==6002)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-1, @"支付失败");
            }
        }
        else if(code.integerValue==6001)
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-2, @"支付取消");
            }
        }
        else
        {
            if(ws.alipayRespBlock)
            {
                ws.alipayRespBlock(-99, @"未知错误");
            }
        }
        
    }];
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
- (void)unionPayWithSerialNo:(NSString *)serialNo viewController:(id)viewController respBlock:(LeoPayManagerRespBlock)block
{
    _unionRespBlock = block;
    
    [[UPPaymentControl defaultControl] startPay:serialNo fromScheme:@"UnionPay" mode:@"00" viewController:viewController];
}
//银联








@end
