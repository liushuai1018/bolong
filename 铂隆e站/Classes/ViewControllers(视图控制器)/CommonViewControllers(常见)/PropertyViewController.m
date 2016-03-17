//
//  PropertyViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/11.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "PropertyViewController.h"
#import "PropertyView.h"

@interface PropertyViewController () <UITableViewDataSource, UITableViewDelegate>

// 物业缴费视图
@property (nonatomic, strong) PropertyView *propertyV;

@property (nonatomic, strong) UITableView *aTableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation PropertyViewController

/*
- (void)loadView
{
    self.propertyV = [[PropertyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = _propertyV;
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物业缴费";
    self.navigationController.navigationBar.translucent = NO;
    
    self.aTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.aTableView.delegate = self;
    self.aTableView.dataSource = self;
    self.view = _aTableView;
    
    
    _dataArray = @[@"家庭", @"缴费单位", @"缴费小区",
                   @"户主姓名", @"证件尾号"];
//    _propertyV.communltyPMV.tableArray = @[@"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区", @"XXX小区"];
//    _propertyV.unitPMV.tableArray = @[@"一单元", @"二单元", @"三单元", @"四单元"];
//    
//    [self cilckButton]; // 添加按钮事件
}

#pragma makr - addAction
- (void)cilckButton
{
    [_propertyV.payButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickAction:(UIButton *)sender
{
    NSLog(@"缴纳物业费用");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"cellStr";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_HEIGHT * 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.25)];
    view.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:view.bounds];
    label.text = @"物业费包括： \n        脸色恢复了凯撒恢复了快速的哈佛路口和萨拉地方和拉萨和风沙大发了哈萨克老地方很顺利的开发；看上的凤凰卡很舒服的客户开始的疯狂和电费卡健身房里看见啥地方尽快哈撒大家快发来哈萨克垃圾啊东方航空；拉萨和地方；哈市；佛爱；爱护 回复大是大非拉到过好了卡号是电饭锅里看书多喝水来U盾后发生地方了空间哈斯覅偶我喝了科技部来衡量以葫芦丝阿杜发货拉斯禿";
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12.0f];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SCREEN_HEIGHT * 0.25;
}

@end
