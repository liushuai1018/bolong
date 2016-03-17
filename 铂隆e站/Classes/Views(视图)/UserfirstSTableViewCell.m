//
//  UserfirstSTableViewCell.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/12/2.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "UserfirstSTableViewCell.h"
@implementation UserfirstSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子控件
        [self createAllSubViews];
    }
    return self;
}

// 初始化子控件
- (void)createAllSubViews
{
    // 钱包
    _walletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _walletBtn.frame = CGRectMake(8, 0, 110, SCREEN_HEIGHT * 0.17);
    [_walletBtn setImage:[UIImage imageNamed:@"qianbao.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:_walletBtn];
    
    //中间图
    _tempImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_walletBtn.frame) - 10, 0, SCREEN_WIDTH - 220, SCREEN_HEIGHT * 0.17)];
    _tempImage.image = [UIImage imageNamed:@"qianbao-2.png"];
    [self.contentView addSubview:_tempImage];
    
    
    // 设置动画
    _sttingImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tempImage.frame), 0, 111, SCREEN_HEIGHT * 0.17)];
    _sttingImage.image = [UIImage imageNamed:@"shezhi-2.png"];
    _sttingImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_sttingImage];
    
    // 设置
    _settingBtu = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBtu.frame = _sttingImage.bounds;
    [_sttingImage addSubview:_settingBtu];
    
    
}

- (void)setAimageArray:(NSArray *)aimageArray
{
    _aimageArray = aimageArray;
    _sttingImage.animationImages = _aimageArray;
    _sttingImage.animationDuration = 0.8;
    _sttingImage.animationRepeatCount = 10;
    [_sttingImage startAnimating];
}

// 开始动画
- (void)startAnimation
{
    [_sttingImage startAnimating];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
