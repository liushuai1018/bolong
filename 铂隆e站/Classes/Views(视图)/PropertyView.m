//
//  PropertyView.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PropertyView.h"

@implementation PropertyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建所有子视图
        [self createAllSubView];
    }
    return self;
}

#pragma mark 创建所有子视图
- (void)createAllSubView
{
    self.backgroundColor = [UIColor whiteColor];
    // 提示1
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 20)];
    label.text = @" 所在小区";
    label.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label];
    
    // 所在小区
    self.communltyPMV = [[PulldownMenusView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame), SCREEN_WIDTH - 30, 40)];
    _communltyPMV.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_communltyPMV];
    
    // 提示2
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(_communltyPMV.frame) + 5, SCREEN_WIDTH * 0.35, 20)];
    label2.text = @" 单元";
    label2.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label2];
    
    // 单元
    self.unitPMV = [[PulldownMenusView alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label2.frame), CGRectGetWidth(label2.frame), 40)];
    _unitPMV.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:_unitPMV];
    
    // 提示3
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame) + 20, CGRectGetMinY(label2.frame), SCREEN_WIDTH - CGRectGetMaxX(label2.frame) - 35, 20)];
    label3.text = @"楼层";
    label3.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label3];
    
    // 楼层
    self.storeyTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label3.frame), CGRectGetMaxY(label3.frame), CGRectGetWidth(label3.frame), 40)];
    _storeyTF.borderStyle = UITextBorderStyleRoundedRect;
    _storeyTF.delegate = self;
    [self addSubview:_storeyTF];
    
    // 提示4
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(_unitPMV.frame) +5, CGRectGetWidth(label2.frame), 20)];
    label4.text = @"姓名";
    label4.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label4];
    
    // 姓名
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label4.frame), CGRectGetWidth(_unitPMV.frame), 40)];
    _nameTF.borderStyle = UITextBorderStyleRoundedRect;
    _nameTF.delegate = self;
    [self addSubview:_nameTF];
    
    // 提示5
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label3.frame), CGRectGetMinY(label4.frame), CGRectGetWidth(label3.frame), 20)];
    label5.text = @"电话";
    label5.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label5];
    
    // 电话
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label3.frame), CGRectGetMaxY(label5.frame), CGRectGetWidth(label3.frame), 40)];
    _phoneTF.borderStyle = UITextBorderStyleRoundedRect;
    _phoneTF.delegate = self;
    [self addSubview:_phoneTF];
    
    // 提示6
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(_nameTF.frame) + 15, 200, 20)];
    label6.text = @"缴费金额";
    label6.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:label6];
    
    // 缴费金额
    self.payTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label6.frame), SCREEN_WIDTH - 30, 40)];
    _payTF.borderStyle = UITextBorderStyleRoundedRect;
    _payTF.delegate = self;
    [self addSubview:_payTF];
    
    // 提示7
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(_payTF.frame), 200, 20)];
    label7.font = [UIFont systemFontOfSize:12.0f];
    label7.text = @"物业费包括:";
    label7.textColor = [UIColor orangeColor];
    [self addSubview:label7];
    
    // 提示8
    UILabel *label8 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label7.frame), SCREEN_WIDTH - 30, 100)];
    label8.font = [UIFont systemFontOfSize:11.0f];
    label8.numberOfLines = 7;
    NSString *str = @"    1.物业共用部位共用设施设备的日常运行维护费用(含租区内正常工作时间的空调费，公共区域水费、排污费、电费、热水费、空调费等公共事业费用); 2.物业管理区域(公共区域)清洁卫生费用; 3.物业管理区域(公共区域)绿化养护费用; 4.物业管理区域秩序维护费用，办公费用; 5.物业管理企业固定资产折旧; 6.物业共用部位、共用设施设备及公众责任保险费用。";
    label8.text = str;
    
    CGFloat heigth = [self autoHeightWithString:str Width:SCREEN_WIDTH - 30 Font:label8.font];
    
    label8.frame = CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label7.frame), SCREEN_WIDTH - 30, heigth);
    [self addSubview:label8];
    
    // 缴费按钮
    self.payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _payButton.frame = CGRectMake(SCREEN_WIDTH * 0.28, CGRectGetMaxY(label8.frame) + 20, SCREEN_WIDTH * 0.44, 40);
    [_payButton setTitle:@"缴  费" forState:UIControlStateNormal];
    _payButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_payButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_payButton setBackgroundImage:[UIImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
    [self addSubview:_payButton];
    
}

#pragma mark TextField代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [_communltyPMV clickOnTheOther];
    [_unitPMV clickOnTheOther];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_communltyPMV clickOnTheOther];
    [_unitPMV clickOnTheOther];
    [_storeyTF resignFirstResponder];
    [_nameTF resignFirstResponder];
    [_phoneTF resignFirstResponder];
}



#pragma mark----计算文本大小
- (CGFloat)autoHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font {
    
    //大小
    CGSize boundRectSize = CGSizeMake(width, MAXFLOAT);
    //绘制属性（字典）
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:1.6
     ];
    NSDictionary *fontDict = @{ NSFontAttributeName: font ,NSParagraphStyleAttributeName:paragraphStyle };
    //调用方法,得到高度
    CGFloat newFloat = ceilf([string boundingRectWithSize:boundRectSize
                                                  options: NSStringDrawingUsesLineFragmentOrigin
                              | NSStringDrawingUsesFontLeading
                                               attributes:fontDict context:nil].size.height);
    return newFloat;
}










@end
