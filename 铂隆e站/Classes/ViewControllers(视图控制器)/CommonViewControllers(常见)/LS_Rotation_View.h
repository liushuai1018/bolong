//
//  LS_Rotation_View.h
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^kBlock)(NSInteger index);

@interface LS_Rotation_View : UIView

// 返回那个view与指定点重合
@property (copy, nonatomic) kBlock block;

@end
