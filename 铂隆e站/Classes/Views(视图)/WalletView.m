//
//  WalletView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/28.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "WalletView.h"

@implementation WalletView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createAllSubViews];
    }
    return self;
}

// 初始化子控件
- (void)createAllSubViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 背景
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.19)];
        backgroundImageView.image = [UIImage imageNamed:@"lan-3.png"];
    backgroundImageView.userInteractionEnabled = YES;
    [self addSubview:backgroundImageView];
    
    // 零花钱按钮
    self.pocketMoneyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _pocketMoneyBut.frame = CGRectMake(60, 15, 30, 30);
    [self.pocketMoneyBut setImage:[UIImage imageNamed:@"qianbao-1.png"] forState:UIControlStateNormal];
    [backgroundImageView addSubview:_pocketMoneyBut];
    
    // 零花钱提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_pocketMoneyBut.frame) - 15, CGRectGetMaxY(_pocketMoneyBut.frame), 60, 20)];
    label.text = @"零花钱";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [backgroundImageView addSubview:label];
    
    // 剩余零花钱
    self.pocketMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame), 60, 20)];
    _pocketMoneyLabel.font = [UIFont systemFontOfSize:14.0f];
    _pocketMoneyLabel.textColor = [UIColor whiteColor];
    _pocketMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundImageView addSubview:_pocketMoneyLabel];
    
    /*
    // 银行卡按钮
    self.bankCardBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _bankCardBut.frame = CGRectMake(SCREEN_WIDTH - 80, 15, 30, 30);
    [_bankCardBut setImage:[UIImage imageNamed:@"yinhangka.png"] forState:UIControlStateNormal];
    [_bankCardBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backgroundImageView addSubview:_bankCardBut];
    
    // 银行卡提示
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.bankCardBut.frame) - 15, CGRectGetMaxY(_bankCardBut.frame), 60, 20)];
    label2.text = @"银行卡";
    label2.textColor = [UIColor whiteColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14.0f];
    [backgroundImageView addSubview:label2];
    
    // 几张银行卡
    self.bankCardLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMinX(label2.frame), CGRectGetMaxY(label2.frame), 60, 20)];
    _bankCardLabel.textAlignment = NSTextAlignmentCenter;
    _bankCardLabel.textColor = [UIColor whiteColor];
    _bankCardLabel.font = [UIFont systemFontOfSize:14.0f];
    [backgroundImageView addSubview:_bankCardLabel];
    */
     
#pragma mark 建议标签
    UIImageView *jianyiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backgroundImageView.frame) + 10, SCREEN_WIDTH, 25)];
    jianyiImageView.image = [UIImage imageNamed:@"lan.png"];
    [self addSubview:jianyiImageView];
    
    // 建议
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 15)];
    label3.text = @"建议";
    label3.textColor = [UIColor whiteColor];
    label3.font = [UIFont systemFontOfSize:14.0f];
    [jianyiImageView addSubview:label3];
    
    CGFloat width = SCREEN_WIDTH / 6.0;
    // 手机充值
    self.phoneBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _phoneBut.frame = CGRectMake(width * 0.75, CGRectGetMaxY(jianyiImageView.frame) + 15, width, width);
    [_phoneBut setImage:[UIImage imageNamed:@"shoujichongzhi.png"] forState:UIControlStateNormal];
    [self addSubview:_phoneBut];
    
    // 手机充值提示
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneBut.frame), CGRectGetMaxY(_phoneBut.frame), width, 15)];
    label4.text = @"手机充值";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label4];
    
    // 物业缴费
    self.propertyBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _propertyBut.frame = CGRectMake(CGRectGetMaxX(_phoneBut.frame) + width * 0.75, CGRectGetMinY(_phoneBut.frame), width, width);
    [_propertyBut setImage:[UIImage imageNamed:@"wuye.png"] forState:UIControlStateNormal];
    [self addSubview:_propertyBut];
    
    // 物业缴费提示
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_propertyBut.frame), CGRectGetMaxY(_propertyBut.frame), width, 15)];
    label5.text = @"物业缴费";
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label5];
    
    // 水电缴费
    self.waterAndElectricityBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _waterAndElectricityBut.frame = CGRectMake(CGRectGetMaxX(_propertyBut.frame) + width * 0.75, CGRectGetMinY(_phoneBut.frame), width, width);
    [_waterAndElectricityBut setImage:[UIImage imageNamed:@"shuidian.png"] forState:UIControlStateNormal];
    [self addSubview:_waterAndElectricityBut];
    
    // 水电缴费提示
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_waterAndElectricityBut.frame), CGRectGetMaxY(_waterAndElectricityBut.frame), width, 15)];
    label6.text = @"水电缴费";
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label6];
    
    
    // 购物车
    self.shoppingCartBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoppingCartBut.frame = CGRectMake(width * 0.75, CGRectGetMaxY(label4.frame) + 15, width, width);
    [_shoppingCartBut setImage:[UIImage imageNamed:@"gouwuche.png"] forState:UIControlStateNormal];
    [self addSubview:_shoppingCartBut];
    
    // 购物车提示
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMinX(_shoppingCartBut.frame), CGRectGetMaxY(_shoppingCartBut.frame), width, 15)];
    label7.text = @"购物车";
    label7.textAlignment = NSTextAlignmentCenter;
    label7.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label7];
    
#pragma mark 附近标签
    UIImageView *fujinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label7.frame) + 15, SCREEN_WIDTH, 25)];
    fujinImageView.image = [UIImage imageNamed:@"lan-2.png"];
    [self addSubview:fujinImageView];
    
    // 附近提示
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 15)];
    label8.text = @"附近";
    label8.textColor = [UIColor whiteColor];
    label8.font = [UIFont systemFontOfSize:14.0f];
    [fujinImageView addSubview:label8];
    
    // 加油站
    self.gasStationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _gasStationBut.frame = CGRectMake(width * 0.75, CGRectGetMaxY(fujinImageView.frame) + 15, width, width);
    [_gasStationBut setImage:[UIImage imageNamed:@"jiayoyzhan.png"] forState:UIControlStateNormal];
    [self addSubview:_gasStationBut];
    
    // 加油站提示
    UILabel *label9 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_gasStationBut.frame), CGRectGetMaxY(_gasStationBut.frame), width, 15)];
    label9.text = @"加油站";
    label9.textAlignment = NSTextAlignmentCenter;
    label9.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label9];
    
    // 便利店
    self.convenienceStoresBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _convenienceStoresBut.frame = CGRectMake(CGRectGetMaxX(_gasStationBut.frame) + width * 0.75, CGRectGetMinY(_gasStationBut.frame), width, width);
    [_convenienceStoresBut setImage:[UIImage imageNamed:@"bianlidian.png"] forState:UIControlStateNormal];
    [self addSubview:_convenienceStoresBut];
    
    // 便利店提示
    UILabel *label10 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_convenienceStoresBut.frame), CGRectGetMaxY(_convenienceStoresBut.frame), width, 15)];
    label10.text = @"便利店";
    label10.textAlignment = NSTextAlignmentCenter;
    label10.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label10];
    
    // 美食
    self.foodBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _foodBut.frame = CGRectMake(CGRectGetMaxX(_convenienceStoresBut.frame) + width * 0.75, CGRectGetMinY(_gasStationBut.frame), width, width);
    [_foodBut setImage:[UIImage imageNamed:@"meishi.png"] forState:UIControlStateNormal];
    [self addSubview:_foodBut];
    
    // 美食提示
    UILabel *label11 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_foodBut.frame), CGRectGetMaxY(_foodBut.frame), width, 15)];
    label11.text = @"美食";
    label11.textAlignment = NSTextAlignmentCenter;
    label11.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:label11];
    
    
#pragma mark 添加tag 值
    self.pocketMoneyBut.tag = 11000;
    self.bankCardBut.tag = 11001;
    self.phoneBut.tag = 11002;
    self.propertyBut.tag = 11003;
    self.waterAndElectricityBut.tag = 11004;
    self.shoppingCartBut.tag = 11005;
    self.gasStationBut.tag = 11006;
    self.convenienceStoresBut.tag = 11007;
    self.foodBut.tag = 11008;
    
    
}


@end
