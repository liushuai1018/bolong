//
//  PresenceTags.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/4/13.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PresenceTags.h"

@implementation PresenceTags

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createrAllSubView];
    }
    return self;
}

#pragma mark - 创建所有子视图
- (void)createrAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.frame);
    
    // 提示
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width * 0.1, 0, width, 40)];
    label.text = @"停入车位我们将会自动计费 \n走时会结算时间和金额，自动扣费。";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1.0];
    [self addSubview:label];
    
    // 背景
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(label.frame))];
    image.image = [UIImage imageNamed:@"dianzibiaoqian_bg"];
    image.userInteractionEnabled = YES;
    [self addSubview:image];
    
    // 标签
    _tagsBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _tagsBut.frame = CGRectMake(CGRectGetMinX(label.frame), 10, width / 4.0, 40);
    [_tagsBut setTitle:@"注册电子标签" forState:UIControlStateNormal];
    [_tagsBut setTitleColor:[UIColor colorWithRed:0.99 green:0.65 blue:0.67 alpha:1.0] forState:UIControlStateNormal];
    _tagsBut.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    _tagsBut.titleLabel.textAlignment = NSTextAlignmentLeft;
    [image addSubview:_tagsBut];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tagsBut.frame), CGRectGetMaxY(_tagsBut.frame) + 5, width * 0.8, 12)];
    _name.text = @": 姓    名";
    _name.textAlignment = NSTextAlignmentRight;
    _name.textColor = [UIColor whiteColor];
    _name.font = [UIFont systemFontOfSize:14.0f];
    [image addSubview:_name];
    
    _phoneNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tagsBut.frame), CGRectGetMaxY(_name.frame) + 15, width * 0.8, 12)];
    _phoneNumber.text = @": 手机号";
    _phoneNumber.textAlignment = NSTextAlignmentRight;
    _phoneNumber.textColor = [UIColor whiteColor];
    _phoneNumber.font = [UIFont systemFontOfSize:14.0f];
    [image addSubview:_phoneNumber];
    
    _tagsNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tagsBut.frame), CGRectGetMaxY(_phoneNumber.frame) + 15, width * 0.8, 12)];
    _tagsNumber.text = @": 标签号";
    _tagsNumber.textAlignment = NSTextAlignmentRight;
    _tagsNumber.textColor = [UIColor whiteColor];
    _tagsNumber.font = [UIFont systemFontOfSize:14.0f];
    [image addSubview:_tagsNumber];
    
    _licensePlateNumber = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_tagsBut.frame), CGRectGetMaxY(_tagsNumber.frame) + 15, width * 0.8, 12)];
    _licensePlateNumber.text = @": 标签号";
    _licensePlateNumber.textAlignment = NSTextAlignmentRight;
    _licensePlateNumber.textColor = [UIColor whiteColor];
    _licensePlateNumber.font = [UIFont systemFontOfSize:14.0f];
    [image addSubview:_licensePlateNumber];
    
    _dateBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _dateBut.frame = CGRectMake(width * 0.2, CGRectGetMaxY(_licensePlateNumber.frame) + 30, width * 0.6, 40);
    [_dateBut setTitle:@"剩余时间300小时" forState:UIControlStateNormal];
    [_dateBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_dateBut setBackgroundColor:[UIColor whiteColor]];
    _dateBut.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _dateBut.layer.masksToBounds = YES;
    _dateBut.layer.cornerRadius = 5.0;
    [image addSubview:_dateBut];
    
    // 提示
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateBut.frame), width, 15)];
    label1.text = @"标签金额不足时自动跳到泊车号停车";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont systemFontOfSize:12.0f];
    [image addSubview:label1];
    
    _top_upBut = [UIButton buttonWithType:UIButtonTypeSystem];
    _top_upBut.frame = CGRectMake(CGRectGetMinX(_dateBut.frame), CGRectGetMaxY(label1.frame) + 15, CGRectGetWidth(_dateBut.frame), CGRectGetHeight(_dateBut.frame));
    [_top_upBut setTitle:@"充值" forState:UIControlStateNormal];
    [_top_upBut setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_top_upBut setBackgroundColor:[UIColor whiteColor]];
    _top_upBut.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _top_upBut.layer.masksToBounds = YES;
    _top_upBut.layer.cornerRadius = 5.0;
    [image addSubview:_top_upBut];
    
}

@end
