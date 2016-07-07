//
//  LS_Lease_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/27.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Lease_ViewController.h"
#import "LS_Lease_LeaseList_TableViewController.h"
#import "LS_Lease_Sell_TableViewController.h"
#import "LS_Lease_Inform_ViewController.h"
#import "LS_EquipmentModel.h"

#define yellowColor [UIColor colorWithRed:0.99 green:0.9 blue:0.28 alpha:1.0]
@interface LS_Lease_ViewController ()
// 导航栏View
@property (weak, nonatomic) IBOutlet UIView *showView;

// 选中标识 1
@property (weak, nonatomic) IBOutlet UIView *mark1;
// 选中标识 2
@property (weak, nonatomic) IBOutlet UIView *mark2;
// 选中标识 3
@property (weak, nonatomic) IBOutlet UIView *mark3;

@property (strong, nonatomic) LS_Lease_LeaseList_TableViewController *leaseList;  // 出租信息
@property (strong, nonatomic) LS_Lease_Sell_TableViewController *sellList;        // 出售信息
@property (strong, nonatomic) LS_Lease_Inform_ViewController *housingInform; // 房屋信息

// 菊花
@property (strong, nonatomic) UIView *activityView;
@property (strong, nonatomic) UIActivityIndicatorView *activity;

// 租赁Data
@property (strong, nonatomic) NSArray *leaseDataAr;
// 出售
@property (strong, nonatomic) NSArray *sellDataAr;

// ----------约束---------
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menu_height;


@end

@implementation LS_Lease_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self activityControl];
    [self initViewControl];
    [self initPanGestureRecognizer];
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initData
- (void)initData {
    __weak LS_Lease_ViewController *weak_control = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 2;
    
    NSBlockOperation *block1 = [NSBlockOperation blockOperationWithBlock:^{
        [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"1" returns:^(NSArray *dataAr) {
            weak_control.leaseList.dataAr = dataAr;
        }];
    }];
    
    NSBlockOperation *block2 = [NSBlockOperation blockOperationWithBlock:^{
        [[NetWorkRequestManage sharInstance] other_LeaseOrSellLiseInfostate:@"2" returns:^(NSArray *dataAr) {
            weak_control.sellList.dataAr = dataAr;
        }];
    }];
    
    [block2 addDependency:block1];
    [queue addOperation:block1];
    [queue addOperation:block2];
}

#pragma mark - initVC
- (void)initViewControl {
    _leaseList = [[LS_Lease_LeaseList_TableViewController alloc] init];
    _sellList = [[LS_Lease_Sell_TableViewController alloc] init];
    _housingInform = [[LS_Lease_Inform_ViewController alloc] init];
    
    [self addChildViewController:_leaseList];
    [self addChildViewController:_sellList];
    [self addChildViewController:_housingInform];
    
    _leaseList.tableView.frame = _showView.bounds;
    [_showView addSubview:_leaseList.view];
    
}

#pragma mark - initGestureRecognizer
- (void)initPanGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerAction:)];
    [self.view addGestureRecognizer:pan];
}

- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self.view];
    if (translation.x < -120) { // 向右
        
        if (_leaseList.tableView.superview != nil) {
            [self housingSell:nil];
            // 将每一次获取的偏移量清零（如果不清零每次获取的偏移量累加）
            [pan setTranslation:CGPointZero inView:self.view];
            return;
        }
        if (_sellList.tableView.superview != nil) {
            [self InformRelease:nil];
            [pan setTranslation:CGPointZero inView:self.view];
            return;
        }
    }
    if (translation.x > 120) { // 向左
        if (_sellList.tableView.superview != nil) {
            [self housingLease:nil];
            [pan setTranslation:CGPointZero inView:self.view];
            return;
        }
        if (_housingInform.view.superview != nil) {
            [self housingSell:nil];
            [pan setTranslation:CGPointZero inView:self.view];
            return;
        }
    }
}

#pragma mark - 租赁
- (IBAction)housingLease:(UIButton *)sender {
    _mark2.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = [UIColor whiteColor];
    _mark1.backgroundColor = yellowColor;
    
    [_housingInform.view removeFromSuperview];
    [_sellList.view removeFromSuperview];
    _leaseList.tableView.frame = _showView.bounds;
    [_showView addSubview:_leaseList.view];
}

#pragma mark - 出售
- (IBAction)housingSell:(UIButton *)sender {
    _mark1.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = [UIColor whiteColor];
    _mark2.backgroundColor = yellowColor;
    
    [_leaseList.view removeFromSuperview];
    [_housingInform.view removeFromSuperview];
    _sellList.tableView.frame = _showView.bounds;
    [_showView addSubview:_sellList.view];
}

#pragma mark - 发布
- (IBAction)InformRelease:(UIButton *)sender {
    _mark1.backgroundColor = [UIColor whiteColor];
    _mark2.backgroundColor = [UIColor whiteColor];
    _mark3.backgroundColor = yellowColor;
    
    [_leaseList.view removeFromSuperview];
    [_sellList.view removeFromSuperview];
    _housingInform.bounds = _showView.bounds;
    [_showView addSubview:_housingInform.view];
}

#pragma mark - 菊花
- (void)activityControl {
    
    _activityView = [[UIView alloc] initWithFrame:self.view.bounds];
    _activityView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_activityView];
    /**
     *  蒙版
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopActivityIndicator)
                                                 name:@"Lease_tableView_loadData"
                                               object:nil];
    
    
    
    NSString *equipmentModel = [[LS_EquipmentModel sharedEquipmentModel] accessModel];
    if ([equipmentModel isEqualToString:@"3.5_inch"]) {
        _menu_height.constant = 10;
        return;
    }
    if ([equipmentModel isEqualToString:@"4_inch"]) {
        return;
    }
    if ([equipmentModel isEqualToString:@"4.7_inch"]) {
        return;
    }
    if ([equipmentModel isEqualToString:@"5.5_inch"]) {
        
        return;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"Lease_tableView_loadData"
                                                  object:nil];
}

@end
