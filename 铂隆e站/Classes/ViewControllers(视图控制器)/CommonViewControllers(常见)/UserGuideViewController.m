//
//  UserGuideViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 15/11/26.
//  Copyright © 2015年 铂隆资产. All rights reserved.
//

#import "UserGuideViewController.h"
@interface UserGuideViewController ()

@end

@implementation UserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGuide]; // 加载引导页面
}

// 创建引导界面
- (void)initGuide
{
    // 创建可滑动视图
    UIScrollView *scroView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [scroView setContentSize:CGSizeMake(SCREEN_WIDTH * 4, 0)];
    scroView.showsHorizontalScrollIndicator = NO; // 隐藏滚动条
    [scroView setBounces:NO]; // 不可跳动
    [scroView setPagingEnabled:YES];
    
    // 循环添加引导图片
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]]];
        imageView.userInteractionEnabled = YES; // 打开用户交互
        [scroView addSubview:imageView];
        
        // 在最后一个imageView上添加一个透明button
        if (3 == i) {
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            [button setTitle:nil forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
//            [imageView addSubview:button];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstpressed)];
            [imageView addGestureRecognizer:tapGesture];
            
        }
        
    }
    
    [self.view addSubview:scroView];
}


// button跳转跟视图
- (void)firstpressed
{
    self.block();
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
