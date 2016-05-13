//
//  LS_Mall_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/10.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Mall_ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LS_Mall_ViewController ()

// 背景滑动视图
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// 头部按钮
@property (weak, nonatomic) IBOutlet UIButton *headButton;

// 猜你喜欢image
@property (weak, nonatomic) IBOutlet UIImageView *xihuan_image;

// 购物车
@property (weak, nonatomic) IBOutlet UIButton *shoppingCart;

// 喜欢数组
@property (strong, nonatomic) NSMutableArray *xihuan_Ar;

@end

@implementation LS_Mall_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商城";
    
    [self addBarButton];
    [self initData];
    [self initSet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AddBarButton
- (void)addBarButton
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(clickBarButton)];
    self.navigationItem.leftBarButtonItem = left;
}

- (void)clickBarButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化数据
- (void)initData
{
    _xihuan_Ar = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"11_11.jpg"], [UIImage imageNamed:@"LS_Mall_xihuanImage"], [UIImage imageNamed:@"12_12.jpg"], nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_shoppingCart.frame), CGRectGetMaxY(_shoppingCart.frame));
}

#pragma mark - 初始化设置
- (void)initSet
{
    _xihuan_image.image = [_xihuan_Ar objectAtIndex:1];
}

#pragma mark - 头部轮播图按钮
- (IBAction)headBut:(UIButton *)sender {
    NSLog(@"点击头部轮播图");
}

#pragma mark - 零食,饮品,粮油,酒类
- (IBAction)classifyAction:(UIButton *)sender {
    /**
     *  用tag值区分点击的分类
     */
    switch (sender.tag) {
        case 100000:{
            NSLog(@"点击零食");
            break;
        }
        case 100001:{
            NSLog(@"点击饮品");
            break;
        }
        case 100002:{
            NSLog(@"点击粮油");
            break;
        }
        case 100003:{
            NSLog(@"点击酒类");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 每日折扣
- (IBAction)discountAction:(UIButton *)sender {
    /**
     *  用tag值区分点击的分类
     */
    switch (sender.tag) {
        case 100005:{
            NSLog(@"打折第一个");
            break;
        }
        case 100006:{
            NSLog(@"打折第二个");
            break;
        }
        case 100007:{
            NSLog(@"打折第三个");
            break;
        }
        case 100008:{
            NSLog(@"打折第四个");
            break;
        }
        default:
            break;
    }
}

#pragma mark - 猜你喜欢
// 左边
- (IBAction)leftAction:(UIButton *)sender {
    
    NSLog(@"上一个");
    // 创建动画
    CATransition *transaction = [CATransition animation];
    // 响应时间
    transaction.duration = 0.5;
    // 动画开始时间
    transaction.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    // 效果
    transaction.type = @"cube";
    // 方向
    transaction.subtype = kCATransitionFromLeft;
    transaction.delegate = self;
    // 添加动画cx
    [_xihuan_image.layer addAnimation:transaction forKey:nil];
    
    /**
     *  获取当前显示的图片下标计算前一个图片下标并放到imagView上
     */
    NSInteger index = [_xihuan_Ar indexOfObject:_xihuan_image.image];
    NSInteger subscript = index == 0 ? _xihuan_Ar.count - 1 : index - 1;
    
    _xihuan_image.image = [_xihuan_Ar objectAtIndex:subscript];
    
}
// 右边
- (IBAction)rigthAction:(UIButton *)sender {
    NSLog(@"下一个");
    CATransition *transaction = [CATransition animation];
    transaction.duration = 0.5;
    transaction.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transaction.type = @"cube";
    transaction.subtype = kCATransitionFromRight;
    transaction.delegate = self;
    [_xihuan_image.layer addAnimation:transaction forKey:nil];
    
    /**
     *  获取当前显示的图片下标计算后一个图片下标并放到imagView上
     */
    NSInteger index = [_xihuan_Ar indexOfObject:_xihuan_image.image];
    NSInteger subscript = index == _xihuan_Ar.count - 1 ? 0 : index + 1;
    
    _xihuan_image.image = [_xihuan_Ar objectAtIndex:subscript];
}

// 按钮w
- (IBAction)xihuan_action:(UIButton *)sender {
    
    NSInteger index = [_xihuan_Ar indexOfObject:_xihuan_image.image];
    
    NSLog(@"点击了喜欢的第%ld项", index);
    
}

#pragma mark - 购物车
- (IBAction)shoppingCart:(UIButton *)sender {
    NSLog(@"购物车");
    
}


@end
