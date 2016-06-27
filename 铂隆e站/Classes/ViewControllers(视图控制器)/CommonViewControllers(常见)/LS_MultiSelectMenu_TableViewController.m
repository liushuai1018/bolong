//
//  LS_MultiSelectMenu_TableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/6/21.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "LS_MultiSelectMenu_TableViewController.h"
#import "WuYeDetails.h"
#import "HousingAddress.h"
#import "LS_MultiSelectMenu_TableViewCell.h"

#define cellStr @"Cell"
@interface LS_MultiSelectMenu_TableViewController ()
{
    UIImage *_select1;
    UIImage *_select2;
}

@property (strong, nonatomic) NSMutableArray *dataAr; // 记录选择

@end

@implementation LS_MultiSelectMenu_TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择房屋";
    
    [self createrBarItem];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LS_MultiSelectMenu_TableViewCell" bundle:nil] forCellReuseIdentifier:cellStr];
    self.tableView.tableFooterView = [UIImageView new];
    
    _select1 = [UIImage imageNamed:@"LS_Selects"];
    _select2 = [UIImage imageNamed:@"LS_Select"];
    _dataAr = [NSMutableArray array];
}

- (void)createrBarItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(barButtinItemAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 完成
- (void)barButtinItemAction:(UIBarButtonItem *)sender {
    if (self.block) {
        self.block(_dataAr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_housingInform.addressList.count != 0) {
        return _housingInform.addressList.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LS_MultiSelectMenu_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr forIndexPath:indexPath];
    
    HousingAddress *model = [_housingInform.addressList objectAtIndex:indexPath.row];
    
    cell.address.text = [NSString stringWithFormat:@"地址:%@", model.address];
    cell.price.text = [NSString stringWithFormat:@"总价:%.2f", model.price];
    cell.area.text = [NSString stringWithFormat:@"平米:%.2f", model.area];
    [cell.select setImage:_select1 forState:UIControlStateNormal];
    [cell.select addTarget:self action:@selector(didClickAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)didClickAction:(UIButton *)sender event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    HousingAddress *model = [_housingInform.addressList objectAtIndex:indexPath.row];
    
    if ([sender.imageView.image isEqual:_select1]) {
        [sender setImage:_select2 forState:UIControlStateNormal];
        
        if (![_dataAr containsObject:model]) {
            [_dataAr addObject:model];
        }
        
    } else {
        [sender setImage:_select1 forState:UIControlStateNormal];
        
        if ([_dataAr containsObject:model]) {
            [_dataAr removeObject:model];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
