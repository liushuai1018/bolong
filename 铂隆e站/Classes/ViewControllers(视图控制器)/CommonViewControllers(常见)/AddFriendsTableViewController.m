//
//  AddFriendsTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/2/22.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "AddFriendsTableViewController.h"
#import <AddressBook/AddressBook.h>
#import "AddressBook.h"
#import "AddFriendsTableViewCell.h"

#import "ApplyForViewController.h" // 申请添加好友

@interface AddFriendsTableViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *addressBookArr;  // 存储所有联系人数组

@property (nonatomic, strong) NSMutableArray *searchResult;    // 搜索的数据


@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) ApplyForViewController *applyFor;

@end

@implementation AddFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self acquisitionRessBook];
    
    [self accessToTheAddressBook];
    
    [self setTheTabelView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddFriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - 申请访问通讯录权限
- (void)acquisitionRessBook
{
    // 记录访问通讯录授权是否成功
    int __block tip = 0;
    
    // 声明一个通讯录的引用
    ABAddressBookRef addBook = nil;
    
    // 因为在iOS 6.0 之前和之后的申请方式有所差别，这里做一个判断
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        // 创建通讯录的引用
        addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        
        // 创建一个初始信号为0的信号
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool granted, CFErrorRef error) {
            
            // granted为YES是表示用户允许，否则为不允许
            if (!granted) {
                tip = 1;
            }
            
            // 发送一次信号
            dispatch_semaphore_signal(sema);
            
        });
        
        // 等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        
        // iOS 6.0之前
        addBook = ABAddressBookCreate();
        
    }
    
    if (tip) {
        // 做一个提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    if (addBook != nil) {
        
        // 释放引用
        CFRelease(addBook);
    }
}

#pragma mark - 获取通讯录联系人
- (void)accessToTheAddressBook
{
    self.addressBookArr = [[NSMutableArray alloc] init];
    
    // 创建通讯录的引用
    ABAddressBookRef addBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    
    // 获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    
    // 进行遍历
    for (NSInteger i = 0; i < number; i++) {
        
        // 创建联系人对象
        AddressBook *addressBook = [[AddressBook alloc] init];
        
        // 获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        
        // 获取当前联系人名字
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        // 获取当前联系人姓氏
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        NSString *name = @"";
        
        if (lastName != nil) {
            
            name = [NSString stringWithFormat:@"%@", lastName];
        }
        if (firstName != nil) {
            
            name =  name ? [name stringByAppendingString:firstName] : firstName;
        }
        
        addressBook.name = name;
        
        // 获取当前联系人姓氏拼音
        NSString *lastNamePhoneic = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNamePhoneticProperty));
        
        addressBook.lastName = lastNamePhoneic;
        
        // 获取当前联系人的电话 (数组)
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
        // 遍历转存 phoneArray
        for (NSInteger j = 0; j < ABMultiValueGetCount(phones); j++) {
            
            NSString *str = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            
            if (![str isEqualToString:@""]) {
                
                [phoneArray addObject:str];
            }
            
        }
        
        addressBook.phoneNumber = [phoneArray firstObject];
        
        // 获取当前联系人头像图片
        NSData *userImage = (__bridge NSData *)(ABPersonCopyImageData(people));
        
        addressBook.headImage = [UIImage imageWithData:userImage];
        
        [_addressBookArr addObject:addressBook];
    }
    
    if (addBook != nil) {
        
        // 释放引用
        CFRelease(addBook);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置tableView
- (void)setTheTabelView
{
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // 不隐藏发暗背景
    self.searchController.hidesNavigationBarDuringPresentation = NO; // 不隐藏导航栏
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    self.tableView.tableFooterView = [UIImageView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) { // 判断当前tableView 是不是搜索状态
        return 1;
    } else {
        
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchController.active) { // 判断当前tableView 是不是搜索状态
        return _searchResult.count;
    } else {
        
        return _addressBookArr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) { // 判断当前tableView 是不是搜索状态
        
        static NSString *cellString = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString];
        }
        
        cell.textLabel.text = @"1231231";
        cell.backgroundColor = [UIColor redColor];
        return cell;
        
    } else {
        
        AddFriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        AddressBook *addressBook = [self.addressBookArr objectAtIndex:indexPath.row];
        
        if (addressBook.headImage != nil) {
            cell.headImage.image = addressBook.headImage;
        }
        
        cell.name.text = addressBook.name;
        
        [cell.add addTarget:self action:@selector(addFriends:event:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) { // 判断当前tableView 是不是搜索状态
        return 45;
    } else {
        
        return SCREEN_HEIGHT * 0.12;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) { // 判断当前tableView 是不是搜索状态
        
    } else {
        
        
        
    }
}
#pragma mark - 添加好友事件
- (void)addFriends:(UIButton *)sender event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    
    // 根据点击动作获取 获取点击tableView 上的位置
    CGPoint touchPosition = [touch locationInView:self.tableView];
    // 根据点击位置获取所点击的区、行。
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:touchPosition];
    NSLog(@"indexPath : %@", indexPath);
    
    AddressBook *addressBook = _addressBookArr[indexPath.row];
    NSLog(@"addressBook = %@", addressBook.name);
    
    _applyFor = [[ApplyForViewController alloc] init];
    [self.navigationController pushViewController:_applyFor animated:YES];
    
    
}


#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
    });
    
    NSLog(@"这个方法真晕了");
}

@end
