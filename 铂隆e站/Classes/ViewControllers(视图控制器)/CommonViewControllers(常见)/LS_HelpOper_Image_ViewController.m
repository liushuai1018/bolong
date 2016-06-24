//
//  LS_HelpOper_Image_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/24.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_HelpOper_Image_ViewController.h"

@interface LS_HelpOper_Image_ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViews;

@end

@implementation LS_HelpOper_Image_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.imageViews.image = _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
