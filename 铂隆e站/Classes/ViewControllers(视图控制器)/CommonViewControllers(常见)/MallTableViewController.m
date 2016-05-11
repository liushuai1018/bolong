//
//  MallTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/8.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "MallTableViewController.h"
#import "MallHeaderView.h"
@interface MallTableViewController ()
{
    MallHeaderView *_mallHeaderV; // 区头
    NSArray *_allMallIconArray; // 区头按钮图
    NSArray *_allMallTitleArray; // 区头按钮标题
}
@end

@implementation MallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商城";
    self.navigationController.navigationBar.translucent = NO;
    _allMallIconArray = @[@"shuishulei.png",
                          @"liangyou.png",
                          @"roupin.png",
                          @"yulei.png",
                          @"qiche.png",
                          @"lingshi.png",
                          @"chongwu.png",
                          @"riyong.png"];
    _allMallTitleArray = @[@"水疏类",
                           @"粮油类",
                           @"肉品类",
                           @"鱼类",
                           @"汽车类",
                           @"零食类",
                           @"宠物类",
                           @"日用百货"];
    
    [self addBarButton]; // 添加 barButton
    [self addHeader]; // 添加区头
}

#pragma mark addHeader
- (void)addHeader
{
    
    _mallHeaderV = [[MallHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.4)];
    self.tableView.tableHeaderView = _mallHeaderV;
    _mallHeaderV.imageVeiw.image = [UIImage imageNamed:@"shangchengTitle.png"];
    
    for (int i = 0; i < 8; i++) {
        long indexs = i + 12400;
        long indexss = i + 12410;
        UIButton *button = [self.tableView.tableHeaderView viewWithTag:indexs];
        [button setImage:[UIImage imageNamed:_allMallIconArray[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickMallButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [self.tableView.tableHeaderView viewWithTag:indexss];
        label.text = _allMallTitleArray[i];
    }
    
}

- (void)clickMallButton:(UIButton *)sender
{
    switch (sender.tag) {
        case 12400:
            NSLog(@"12400");
            break;
            
        default:
            break;
    }
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}


@end
