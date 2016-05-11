//
//  LS_Other_recycling_ViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/5/9.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_Other_recycling_ViewController.h"
#import "LS_Other_recycling_View.h"
#import "LS_button.h"

@interface LS_Other_recycling_ViewController () <LS_buttonDelegate>

@property (strong, nonatomic) LS_Other_recycling_View *LS_view;

// 记录选择收购那一项
@property (assign, nonatomic) NSInteger index;

@end

@implementation LS_Other_recycling_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"回收";
    self.tabBarController.tabBar.translucent = NO;
    
    [self createrSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建视图
- (void)createrSubView
{
    LS_Other_recycling_View *view = [[LS_Other_recycling_View alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    _LS_view = view;
    self.view = _LS_view;
    
    _LS_view.button.delegate = self;
    _LS_view.button.label.text = @"易拉罐 0.05/个";
    [_LS_view.buyBut addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _index = 2; // 默认收购2
}
#pragma mark - 监听上门收购按钮事件
- (void)buyAction:(UIButton *)sender
{
    NSLog(@"上门收购 %ld", (long)_index);
}

#pragma mark - button_delegate
- (void)selectButtonAction:(LS_button *)sender selectIndex:(NSInteger)index
{
    
    switch (index) {
        case 0: {
            _LS_view.button.label.text = @"书纸 0.3/斤";
            _index = index;
            break;
        }
        case 1: {
            _LS_view.button.label.text = @"纸箱 0.3/斤";
            _index = index;
            break;
        }
        case 2: {
            _LS_view.button.label.text = @"易拉罐 0.05/个";
            _index = index;
            break;
        }
        case 3: {
            _LS_view.button.label.text = @"塑料瓶 0.05/斤";
            _index = index;
            break;
        }
        case 4: {
            _LS_view.button.label.text = @"铁 0.8/斤";
            _index = index;
            break;
        }
        case 5: {
            _LS_view.button.label.text = @"家电详谈";
            _index = index;
            break;
        }
            
        default:
            break;
    }

}

@end
