//
//  ViewController.m
//  LeoPayManagerDemo
//
//  Created by 陈仕军 on 16/12/19.
//  Copyright © 2016年 Leo.Chen. All rights reserved.
//

#import "ViewController.h"
#import "LeoPayManager.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"Apple Pay" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(ApplePayFunc) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 setTitle:@"微信支付" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(wechatPayFunc) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 150, 50)];
    btn3.backgroundColor = [UIColor blueColor];
    [btn3 setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(aliPayFunc) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 150, 50)];
    btn4.backgroundColor = [UIColor blueColor];
    [btn4 setTitle:@"银联支付" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn4];
    [btn4 addTarget:self action:@selector(unionPayFunc) forControlEvents:UIControlEventTouchUpInside];
}





#pragma mark - Button Func
- (void)ApplePayFunc
{
    //先获取支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager applePayWithTraderInfo:nil viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)wechatPayFunc
{
    //先获取支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager wechatPayWithAppId:@"" partnerId:@"" prepayId:@"" package:@"" nonceStr:@"" timeStamp:@"" sign:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)aliPayFunc
{
    //先获取支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager aliPayOrder:@"" scheme:@"" respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}

- (void)unionPayFunc
{
    //先获取支付参数
    //...
    
    LeoPayManager *manager = [LeoPayManager getInstance];
    [manager unionPayWithSerialNo:@"" viewController:self respBlock:^(NSInteger respCode, NSString *respMsg) {
        
        //处理支付结果
        
    }];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
