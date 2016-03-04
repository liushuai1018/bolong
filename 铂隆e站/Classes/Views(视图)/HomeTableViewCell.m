//
//  HomeTableViewCell.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/27.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 点赞事件
- (IBAction)clickAction:(UIButton *)sender {
    NSLog(@"你点击了赞, tag = %ld", (long)sender.tag);
    [sender setImage:[UIImage imageNamed:@"zan-2.png"] forState:UIControlStateNormal];
    
    
#warning mark -  在这请求已经赞的次数显示。
    
    
    _zanTime.text = @"1010";
    
    // 获取当前时间
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MMM-dd HH-SS"];
    NSString *string = [dateFormatter stringFromDate:date];
    NSLog(@"时间 = %@", string);
}



@end
