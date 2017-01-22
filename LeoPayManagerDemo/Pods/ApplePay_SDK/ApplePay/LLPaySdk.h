//
//  PaySdkColor.h
//  PaySdkColor
//
//  Created by xuyf on 14-4-23.
//  Copyright (c) 2014年 llyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum LLPayResult {
    kLLPayResultSuccess = 0,    // 支付成功
    kLLPayResultFail = 1,       // 支付失败
    kLLPayResultCancel = 2,     // 支付取消，用户行为
    kLLPayResultInitError,      // 支付初始化错误，订单信息有误，签名失败等
    kLLPayResultInitParamError, // 支付订单参数有误，无法进行初始化，未传必要信息等
    kLLPayResultUnknow,         // 其他
    kLLPayResultRequestingCancel,//授权支付后取消(支付请求已发送)
}LLPayResult;

extern const NSString* const kLLPaySDKBuildVersion;
extern const NSString* const kLLPaySDKVersion;

@protocol LLPaySdkDelegate <NSObject>

@required
/* 可能返回的参数含义
 
 参数名                     含义
 result_pay                  支付结果
 oid_partner                 商户编号
 dt_order                    商户订单时间
 no_order                    商户唯一订单号
 ￼oid_paybill                 连连支付支付单号
 money_order                 交易金额
 ￼￼settle_date                 清算日期
 ￼￼info_order                  订单描述
 pay_type                    支付类型
 bank_code                   银行编号
 bank_name                   银行名称
 memo                        支付备注
 */

/**
 *  调用sdk以后的结果回调
 *
 *  @param resultCode 支付结果
 *  @param dic        回调的字典，参数中，ret_msg会有具体错误显示
 */
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary*)dic;

@optional
/**
 *  支付成功后返回的用户信息
 *
 *  @param shippingMessages 用户信息的字典，key值就是LLShippingMessageName等
 */
- (void)paymentSucceededWithShippingMessages: (NSDictionary *)shippingMessages;

@end


/*
 ========== Apple Pay =================
 */
#pragma mark - Apple Pay SDK

/** 送货信息的key */
extern NSString * const LLAPPayNeedShipping;

/** 需要sdk返回的用户信息，也是代理方法中shippingMessages的key值 */
extern NSString * const LLShippingMessageName;
extern NSString * const LLShippingMessageAddress;
extern NSString * const LLShippingMessagePhone;
extern NSString * const LLShippingMessageEmail;
extern NSString * const LLShippingMessagePostalCode;
extern NSString * const LLShippingMessageShippingMethod;

/** 送货信息，快递名称和详情 */
extern NSString * const LLShippingMethodName;
extern NSString * const LLShippingMethodDetail;

/** 商品详情，详情名称和价格 */
extern NSString * const LLSummaryItemName;
extern NSString * const LLSummaryItemPrice;

typedef enum : NSUInteger {
    kLLAPPayDeviceSupport,                  // 完全支持
    kLLAPPayDeviceNotSupport,               // 设备无法支持，无法绑卡，原因是机型不支持，或者系统版本太低
    kLLAPPayDeviceVersionTooLow,            // 设备无法支持银联卡支付，需要iOS9.2以上
    kLLAPPayDeviceNotBindChinaUnionPayCard, // 设备支持，用户未绑卡
} LLAPPaySupportStatus;


@interface LLAPPaySDK : NSObject

/**
 *  单例
 *
 *  @return 返回APSdk的单例对象
 */
+ (LLAPPaySDK*)sharedSdk;

/** LLAPPaySDK代理 */
@property (nonatomic, assign) NSObject<LLPaySdkDelegate> *sdkDelegate;

/**
 *  消费
 *
 *  @param traderInfo     交易信息
 *  @param viewController 推出ApplePay界面的VC
 */
- (void)payWithTraderInfo:(NSDictionary *)traderInfo
         inViewController:(UIViewController *)viewController;


/**
 *  预授权支付，供酒店商旅等行业，进行预授权支付使用
 *
 *  @param traderInfo     交易信息
 *  @param viewController 推出ApplePay界面的VC
 */
- (void)preauthWithTraderInfo:(NSDictionary *)traderInfo
             inViewController:(UIViewController *)viewController;



/**
 *  判断是否能使用 Apple Pay
 *
 *  @return 返回支持与否的枚举值LLAPPaySupportStatus
 */
+ (LLAPPaySupportStatus)canDeviceSupportApplePayPayments;

/** 跳转wallet系统app进行绑卡 */
+ (void)showWalletToBindCard;

/**
 *  组织送货信息LLAPPayNeedShipping的value值
 *
 *  @param shippingMessages 需要的用户信息
 *  @param shippingMethods  送货方式
 *  @param summaryItems     详情信息
 *  @param postalPrice      邮费
 *
 *  @return 返回LLAPPayNeedShipping的value值
 */
+ (NSString *)valueWithShippingMessages: (NSArray *)shippingMessages
                        shippingMethods: (NSArray *)shippingMethods
                           summaryItems: (NSArray *)summaryItems
                            postalPrice: (NSString *)postalPrice;
@end

