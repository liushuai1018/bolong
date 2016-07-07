//
//  LS_LeaseDetails_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/30.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_LeaseDetails_ViewController.h"
#import "LS_LeaseOrSell_Model.h"

@interface LS_LeaseDetails_ViewController ()
// 详细信息
@property (strong, nonatomic) LS_LeaseOrSell_Model *model;

// 菊花
@property (strong, nonatomic) UIView *activityView;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

//-------------视图-----------
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@property (weak, nonatomic) IBOutlet UILabel *house_geju;
@property (weak, nonatomic) IBOutlet UILabel *house_xuqiu;
@property (weak, nonatomic) IBOutlet UILabel *house_jieshao;
@property (weak, nonatomic) IBOutlet UILabel *house_phone;


// -------------约束------------
// 背景图片的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundImage_height;
// 第一张图片距离上的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1_top;
// 背景View的高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundView_height;

// 介绍的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jieshao_height;

@end

@implementation LS_LeaseDetails_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 启动菊花
    [self activityControl];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _scroll.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    
}

#pragma mark - initData
- (void)initData {
    __weak LS_LeaseDetails_ViewController *weak_conntrol = self;
    [[NetWorkRequestManage sharInstance] other_LeaseOrSellDetailsListID:_listID returns:^(LS_LeaseOrSell_Model *model) {
        weak_conntrol.model = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weak_conntrol setSubView];
        });
    }];
}

#pragma mark - setView
- (void)setSubView {
    _scroll.bounces = NO;
    
    
    _house_geju.text = _model.house_style;
    if ([_model.state isEqualToString:@"1"]) {
        _house_xuqiu.text = @"押一付三,半年起租.";
        
    } else {
        _house_xuqiu.text = @"首付 20%, 可以商量.";
    }
    _house_jieshao.text = _model.house_info;
    
    /*
    */
    NSString *title = _model.house_info;
    CGSize titleSize = _house_jieshao.frame.size;
    NSDictionary *attributesDict = @{NSFontAttributeName : _house_jieshao.font};
    CGRect rect = [title boundingRectWithSize:titleSize
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine
                                   attributes:attributesDict
                                      context:nil];
    _jieshao_height.constant = CGRectGetHeight(rect);
    
    _house_phone.text = [NSString stringWithFormat:@"电话: %@", _model.phone];
    
    __weak LS_LeaseDetails_ViewController *weak_control = self;
    // 第一张图片
    [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:0] returns:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weak_control.headImage.image = image;
        });
    }];
    
    NSInteger index = _model.house_image.count;
    switch (index) {
        case 1:{
            _backgroundImage_height.constant = 240.0;
            _image2.hidden = YES;
            _image3.hidden = YES;
            _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_backgroundImage.frame));
            // 第一张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:0] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image1.image = image;
                });
            }];
            break;
        }
        case 2:{
            _backgroundImage_height.constant = 430.0;
            _image3.hidden = YES;
            _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_backgroundImage.frame) + 190);
            // 第一张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:0] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image1.image = image;
                });
            }];
            // 第二张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:1] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image2.image = image;
                });
            }];
            break;
        }
        case 3:{
            _backgroundImage_height.constant = 640.0;
            _image1_top.constant = 40;
            _scroll.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(_backgroundImage.frame) + 400);
            // 第一张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:0] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image1.image = image;
                });
            }];
            // 第二张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:1] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image2.image = image;
                });
            }];
            // 第三张图片
            [[NetWorkRequestManage sharInstance] downloadImageURL:[_model.house_image objectAtIndex:2] returns:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weak_control.image3.image = image;
                });
            }];
            break;
        }
            
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [weak_control stopActivityIndicator];
    });
}

#pragma mark - 菊花
- (void)activityControl {
    
    _activityView = [[UIView alloc] initWithFrame:self.view.bounds];
    _activityView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_activityView];
    /**
     *  蒙版
     */
    
    /*
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect maskLayerRect = CGRectMake(_activityView.center.x - 40, _activityView.center.y - 140, 80, 60);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, maskLayerRect);
    [maskLayer setPath:path];
    _activityView.layer.mask = maskLayer;
    */
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect rect = CGRectMake(_activityView.center.x - 50, _activityView.center.y - 140, 100, 80);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    [maskLayer setPath:maskPath.CGPath];
    _activityView.layer.mask = maskLayer;
    
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = CGPointMake(_activityView.center.x, _activityView.center.y - 110);
    _activity = activity;
    [_activityView addSubview:_activity];
    [_activity startAnimating];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 10)];
    title.center = CGPointMake(_activity.center.x, _activity.center.y + 30);
    title.text = @"正在加载...";
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:10.0f];
    [_activityView addSubview:title];
}

- (void)stopActivityIndicator {
    if ([_activity isAnimating]) {        
        [_activity stopAnimating];
        [_activityView removeFromSuperview];
    }
}

@end
