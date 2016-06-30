//
//  LS_LeaseDetails_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/30.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_LeaseDetails_ViewController.h"

@interface LS_LeaseDetails_ViewController ()

// 滑动背景
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// 头
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
// 房屋格局
@property (weak, nonatomic) IBOutlet UILabel *geju;
// 要求
@property (weak, nonatomic) IBOutlet UILabel *yaoqiu;
// 介绍
@property (weak, nonatomic) IBOutlet UILabel *jieshao;
// 电话
@property (weak, nonatomic) IBOutlet UILabel *phone;

// 边框
@property (weak, nonatomic) IBOutlet UIImageView *biankuang;
// image1
@property (weak, nonatomic) IBOutlet UIImageView *image1;
// image2
@property (weak, nonatomic) IBOutlet UIImageView *image2;
// image3
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end

@implementation LS_LeaseDetails_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initSetting];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initSetting
- (void)initSetting {
    
}

@end
