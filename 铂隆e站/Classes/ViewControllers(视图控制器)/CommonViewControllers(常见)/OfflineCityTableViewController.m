//
//  OfflineCityTableViewController.m
//  铂隆e站
//
//  Created by 铂隆资产1号 on 16/1/18.
//  Copyright © 2016年 铂隆资产. All rights reserved.
//

#import "OfflineCityTableViewController.h"
#import "MAHeaderView.h"

#define kSectionHeaderHeight    22.f
#define kSectionHeaderMargin    15.f
#define kTableCellHeight        42.f

#define kButtonSize 30.f
#define kButtonCount 3

#define kTagDownloadButton 1000000
#define kTagPauseButton 1000001
#define kTagDeleteButton 1000002

NSString const *DownloadStageInfoKey2      = @"DownloadStageInfoKey";
NSString const *DownloadStageStatusKey2    = @"DownloadStageStatusKey";
NSString const *DownloadStageIsRunningKey2 = @"DownloadStageIsRunningKey";

@interface OfflineCityTableViewController () <UITableViewDataSource, UITableViewDelegate, MAHeaderViewDelegate>
{
    char *_expandedSections;                                 // 扩展部分
}
@property (nonatomic, strong) NSArray *sectionTitles;        // 全国、直辖市、省份
@property (nonatomic, strong) NSArray *cities;               // 普通城市和直辖市
@property (nonatomic, strong) NSArray *provinces;            // 省份
@property (nonatomic, strong) NSArray *municipalities;       // 直辖市

@property (nonatomic, strong) NSMutableSet *downloadingItems;// 可变集合
@property (nonatomic, strong) NSMutableDictionary *downloadStages;

@property (nonatomic, assign) BOOL needReloadWhenDisappear;  // 需要重新加载时消失

@end

@implementation OfflineCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"城市列表";
    [self setupCities];
    [self checkNewestVersionAction];
}

#pragma mark - 检查最新版本操作
- (void)checkNewestVersionAction
{
    [[MAOfflineMap sharedOfflineMap] checkNewestVersion:^(BOOL hasNewestVersion) {
        if (!hasNewestVersion) {
            return ;
        }
        
        /* Manipulations to your application's user interface must occur on the main thread. */
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setupCities];
            
            [self.tableView reloadData];
        });
        
    }];
}

#pragma mark - 设置城市
- (void)setupCities
{
    self.sectionTitles = @[@"全国", @"直辖市", @"省份"];
    self.cities = [MAOfflineMap sharedOfflineMap].cities;
    self.provinces = [MAOfflineMap sharedOfflineMap].provinces;
    self.municipalities = [MAOfflineMap sharedOfflineMap].municipalities;
    
    self.downloadStages = [NSMutableDictionary dictionary];
    self.downloadingItems = [NSMutableSet set];
    
    // 判断字符是否为空
    if (_expandedSections != NULL) { // 不为空则释放空间， 指向NULL
        free(_expandedSections);
        _expandedSections = NULL;
    }
    
    // 初始化字符串
    _expandedSections = (char *)malloc((self.sectionTitles.count + self.provinces.count) * sizeof(char));
    // 将字符串内容设置全部设置为 0
    memset(_expandedSections, 0, (self.sectionTitles.count + self.provinces.count) * sizeof(char));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger number = self.sectionTitles.count + self.provinces.count;
    NSLog(@"sectionsIndex ====  %ld", (long)number);
    return number;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger number = 0;
    
    switch (section) {
            
        case 0: {
            number = 1;
            break;
        }
            
        case 1: {
            number = self.municipalities.count;
            break;
        }
            
        default: {
            if (_expandedSections[section]) {
                
                NSLog(@"number ====== %lu - %lu = %lu", section, self.sectionTitles.count, section - self.sectionTitles.count);
                MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
                number = pro.cities.count + 1;   // 加1用以下载整个省份的数据
            }
            break;
        }
    }
    return number;
}


- (MAOfflineItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath == nil)
    {
        return nil;
    }
    
    MAOfflineItem *item = nil;
    
    switch (indexPath.section)
    {
        case 0:
        {
            item = [MAOfflineMap sharedOfflineMap].nationWide;
            break;
        }
        case 1:
        {
            item = self.municipalities[indexPath.row];
            break;
        }
        case 2:
        {
            item = nil;
            break;
        }
        default:
        {
            
            MAOfflineProvince *pro = self.provinces[indexPath.section - self.sectionTitles.count];
            
            if (indexPath.row == 0)
            {
                item = pro; // 添加整个省
            }
            else
            {
                item = pro.cities[indexPath.row - 1]; // 添加市
            }
            
            break;
        }
    }
    
    return item;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cityCellIdentifier = @"cityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cityCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = [self accessoryView]; // 添加自定义附属视图
    }
    
    // 获取每项cell 将要展示的内容
    MAOfflineItem *item = [self itemFoIndexPath:indexPath];
    // 将消息显示到cell 上
    [self updateCell:cell forItem:item];
    
    return cell;
}

#pragma mark - cell内容
- (MAOfflineItem *)itemFoIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) {
        return nil;
    }
    
    MAOfflineItem *item = nil;
    
    switch (indexPath.section) {
        case 0: {
            item = [MAOfflineMap sharedOfflineMap].nationWide;
            break;
        }
        case 1: {
            item = self.municipalities[indexPath.row];
            break;
        }
        case 2: {
            item = nil;
            break;
        }
            
        default: {
            
            MAOfflineProvince *pro = self.provinces[indexPath.section - self.sectionTitles.count];
            if (indexPath.row == 0) {
                item = pro; // 添加整个省
            } else {
                item = pro.cities[indexPath.row - 1]; // 添加市
            }
            
            break;
        }
    }
    
    return item;
}

#pragma mrak - 将消息添加到cell上
- (void)updateCell:(UITableViewCell *)cell forItem:(MAOfflineItem *)item
{
    [self updateAccessoryViewForCell:cell item:item];              // 更新附属视图button
    cell.textLabel.text = [self cellLabelTextForItem:item];        // 设置labelText
    cell.detailTextLabel.text = [self cellDetailTextForItem:item]; // 设置SubLabel
    
}

#pragma mark - 更新附属视图button
- (void)updateAccessoryViewForCell:(UITableViewCell *)cell item:(MAOfflineItem *)item
{
    UIButton *download = nil;
    UIButton *pause = nil;
    UIButton *delete = nil;
    
    // 遍历附属视图上所有按钮
    for (UIButton *but in cell.accessoryView.subviews) {
        
        switch (but.tag) {
            case kTagDownloadButton: {
                download = but;
                break;
            }
            case kTagPauseButton: {
                pause = but;
                break;
            }
            case kTagDeleteButton: {
                delete = but;
                break;
            }
                
            default:
                break;
        }
    }
    
    // 更新每个按钮的位置
    CGPoint right = CGPointMake(kButtonSize * (kButtonCount - 0.5), kButtonSize * 0.5);
    CGFloat leftMove = -kButtonSize;
    CGPoint center = right;
    
    // 判断项目的状态显示对象的附属按钮
    if (item.itemStatus == MAOfflineItemStatusInstalled || item.itemStatus == MAOfflineItemStatusCached) { // 已安装、缓存状态
        delete.hidden = NO; // 删除按钮可见
        delete.center = center;
        center.x += leftMove;
    } else {
        delete.hidden = YES;
        delete.center = right;
    }
    
    if ([[MAOfflineMap sharedOfflineMap] isDownloadingForItem:item]) {// 检测是否正在下载
        pause.hidden = NO; // 暂停按钮可见
        pause.center = center;
        center.x += leftMove;
        
        download.hidden = YES; // 下载按钮不可见
        download.center = right;
    } else {
        pause.hidden = YES; // 暂停按钮不可见
        pause.center = right;
        
        if (item.itemStatus != MAOfflineItemStatusInstalled) { // 判断项目是否以安装
            download.hidden = NO; // 下载按钮可见
            download.center = center;
        } else {
            download.hidden = YES; // 下载按钮不可见
            download.center = right;
        }
    }
}

#pragma mark - 自定义cell附属视图
- (UIView *)accessoryView
{
    UIView *accessory = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonCount *kButtonSize, kButtonSize)];
    
    UIButton *downloadButton = [self buttonWithImage:[UIImage imageNamed:@"download"] tag:kTagDownloadButton];
    UIButton *pauseButton = [self buttonWithImage:[UIImage imageNamed:@"pause"] tag:kTagPauseButton];
    UIButton *deleteButton = [self buttonWithImage:[UIImage imageNamed:@"delete"] tag:kTagDeleteButton];
    
    [accessory addSubview:downloadButton];
    [accessory addSubview:pauseButton];
    [accessory addSubview:deleteButton];
    
    return accessory;
}

// 创建附属视图按钮
- (UIButton *)buttonWithImage:(UIImage *)image tag:(NSUInteger)tag
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
    [button setImage:image forState:UIControlStateNormal];
    button.tag = tag;
    button.center = CGPointMake((kButtonCount + 1000000 - tag) * kButtonSize, kButtonSize * 0.5);
    [button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

// 附属视图按钮事件
- (void)checkButtonTapped:(id)sender event:(id)event
{
    NSIndexPath *indexPath = [self indexPathForSender:sender event:event]; // 根据点击的附属视图按钮获取点击的位置 indexPath
    MAOfflineItem *item = [self itemForIndexPath:indexPath]; // 获取点击的是那个 item
    
    if (item == nil) {
        return;
    }
    
    UIButton *button = sender;
    switch (button.tag) {
        case kTagDownloadButton: {
            [self download:item atIndexPath:indexPath]; // 下载
            break;
        }
        case kTagPauseButton: {
            [self pause:item]; // 暂停
            break;
        }
        case kTagDeleteButton: {
            [self deleteItem:item]; // 删除
            [self updateUIForItem:item atIndexPath:indexPath];
            break;
        }
            
        default:
            break;
    }
    
}

// 根据点击的按钮获取他的 indexPath
- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton *)sender; // 当前点击的按钮
    UITouch *touch = [[event allTouches] anyObject]; // 获取设置在按钮上的所有touch
    
    // 判断点击的是不是附图上的按钮，如果不是 根据 ！ 直接返回 nil;
    if (![button pointInside:[touch locationInView:button] withEvent:event]) {
        /**
         *  pointInside:withEvent 根据点击的位置、点击的方式。判断是否点击了制定的位置
         *  locationInView        获取View 上点击的位置
         */
        return nil;
    }
    
    // 根据点击动作获取 获取点击tableView 上的位置
    CGPoint touchPosition = [touch locationInView:self.tableView];
    // 根据点击位置获取所点击的区、行。
    return [self.tableView indexPathForRowAtPoint:touchPosition];
    
}

#pragma mark - 下载
- (void)download:(MAOfflineItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    // 判断项目为nil 或者 状态已经下载的话，直接返回;
    if (item == nil || item.itemStatus == MAOfflineItemStatusInstalled) {
        return;
    }
    
    NSLog(@"download : %@", item.name);
    
    // 启动下载
    [[MAOfflineMap sharedOfflineMap] downloadItem:item shouldContinueWhenAppEntersBackground:YES downloadBlock:^(MAOfflineItem *downloadItem, MAOfflineMapDownloadStatus downloadStatus, id info) {
        
        if (![self.downloadingItems containsObject:downloadItem]) { // 判断集合里有当前 item 嘛
            [self.downloadingItems addObject:downloadItem]; // 如果没有添加到集合里
            [self.downloadStages setObject:[NSMutableDictionary dictionary] forKey:downloadItem.adcode]; // 下砸的item 添加到字典中
        }
        
        /*操作应用程序的用户界面必须在主线程上发生*/
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *stage = [self.downloadStages objectForKey:downloadItem.adcode];
            
            /* 以插入队列，等待中. */
            if (downloadStatus == MAOfflineMapDownloadStatusWaiting) {
                [stage setObject:[NSNumber numberWithBool:YES] forKey:DownloadStageIsRunningKey2]; 
            }
            else if (downloadStatus == MAOfflineMapDownloadStatusProgress) { /* 下载过程中. */
                [stage setObject:info forKey:DownloadStageInfoKey2];
            }
            else if (downloadStatus == MAOfflineMapDownloadStatusCancelled
                     || downloadStatus == MAOfflineMapDownloadStatusError
                     || downloadStatus == MAOfflineMapDownloadStatusFinished /* 取消.发生错误.全部顺利完成. */
                     )
            {
                [stage setObject:[NSNumber numberWithBool:NO] forKey:DownloadStageIsRunningKey2];
                
                // clear
                [self.downloadingItems removeObject:downloadItem];
                [self.downloadStages removeObjectForKey:downloadItem.adcode];
            }
            
            [stage setObject:[NSNumber numberWithInt:downloadStatus] forKey:DownloadStageStatusKey2];
            
            /* Update UI. */
            //更新触发下载操作的item涉及到的UI
            [self updateUIForItem:item atIndexPath:indexPath];
            
            if (downloadStatus == MAOfflineMapDownloadStatusFinished) {
                self.needReloadWhenDisappear = YES;
            }
            
        });
        
    }];
    
}

- (void)updateUIForItem:(MAOfflineItem *)item atIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell != nil) {
        [self updateCell:cell forItem:item];
    }
    
    // 判断如果包含 普通城市
    if ([item isKindOfClass:[MAOfflineItemCommonCity class]]) {
        UITableViewCell *provinceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
        if (provinceCell != nil) {
            [self updateCell:provinceCell forItem:((MAOfflineItemCommonCity *)item).province];
        }
        return;
    }
    
    // 包含所有城市数组类
    if ([item isKindOfClass:[MAOfflineProvince class]]) {
        MAOfflineProvince *province = (MAOfflineProvince *)item;
        
        [province.cities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UITableViewCell *cityCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx + 1 inSection:indexPath.section]];
            
            [self updateCell:cityCell forItem:obj];
            
        }];
        return;
    }
    
}

#pragma mark - 暂停
- (void)pause:(MAOfflineItem *)item
{
    NSLog(@"puase : %@", item.name);
    [[MAOfflineMap sharedOfflineMap] pauseItem:item];
}

#pragma mark - 删除
- (void)deleteItem:(MAOfflineItem *)item
{
    NSLog(@"delete :%@", item.name);
    [[MAOfflineMap sharedOfflineMap] deleteItem:item];
}

#pragma mark - cell显示文字
// 标题
- (NSString *)cellLabelTextForItem:(MAOfflineItem *)item
{
    NSString *labelText = nil;
    // 判读项目当前状态
    if (item.itemStatus == MAOfflineItemStatusInstalled) {
        labelText = [item.name stringByAppendingString:@"(已安装)"];
    }
    else if (item.itemStatus == MAOfflineItemStatusExpired) {
        labelText = [item.name stringByAppendingString:@"(有更新)"];
    }
    else if (item.itemStatus == MAOfflineItemStatusCached) {
        labelText = [item.name stringByAppendingString:@"(缓存)"];
    }
    else {
        labelText = item.name;
    }
    return labelText;
}
// 大小
- (NSString *)cellDetailTextForItem:(MAOfflineItem *)item
{
    // 判断是否包含 Province 类
    if ([item isKindOfClass:[MAOfflineProvince class]]) {
        return [NSString stringWithFormat:@"大小:  %.2fM", item.size / 1048576.0];
    }
    
    NSString *detailText = nil;
    
    if (![self.downloadingItems containsObject:item]) //判断这个集合中是否存在传入的对象，返回Bool值。
    {
        if (item.itemStatus == MAOfflineItemStatusCached) // 判断 item 状态，正在下载则返回大小和下载的情况
        {
            detailText = [NSString stringWithFormat:@" %.2fM/ %.2fM", item.downloadedSize / 1048576.0, item.size / 1048576.0
                          
                          ];
        }
        else
        {
            detailText = [NSString stringWithFormat:@"大小:  %.2fm", item.size / 1048576.0]; // 下载完成返回大小
        }
    }
    else
    {   // 判断这个item 没有下载过
        
        NSMutableDictionary *stage  = [self.downloadStages objectForKey:item.adcode];
        
        MAOfflineMapDownloadStatus status = [[stage objectForKey:DownloadStageStatusKey2] intValue];
        
        switch (status)
        {
            case MAOfflineMapDownloadStatusWaiting:
            {
                detailText = @"等待";
                
                break;
            }
            case MAOfflineMapDownloadStatusStart:
            {
                detailText = @"开始";
                
                break;
            }
            case MAOfflineMapDownloadStatusProgress:
            {
                NSDictionary *progressDict = [stage objectForKey:DownloadStageInfoKey2];
                
                long long recieved = [[progressDict objectForKey:MAOfflineMapDownloadReceivedSizeKey] longLongValue];
                long long expected = [[progressDict objectForKey:MAOfflineMapDownloadExpectedSizeKey] longLongValue];
                
                detailText = [NSString stringWithFormat:@" %.2fM/ %.2fM (%.1f%%)", recieved / 1048576.0, expected / 1048576.0, recieved/(float)expected*100];
                break;
            }
            case MAOfflineMapDownloadStatusCompleted:
            {
                detailText = @"下载完成";
                break;
            }
            case MAOfflineMapDownloadStatusCancelled:
            {
                detailText = @"取消";
                break;
            }
            case MAOfflineMapDownloadStatusUnzip:
            {
                detailText = @"解压中";
                break;
            }
            case MAOfflineMapDownloadStatusFinished:
            {
                detailText = @"结束";
                
                break;
            }
            default:
            {
                detailText = @"错误";
                
                break;
            }
        } // end switch
        
    }
    
    return detailText;
}

#pragma mark - 设置区头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *theTitle = nil;
    // 前三个设置为 全国、直辖市、省份
    if (section < self.sectionTitles.count) {
        theTitle = self.sectionTitles[section];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSectionHeaderHeight)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(kSectionHeaderMargin, 0, CGRectGetWidth(headerView.bounds), kSectionHeaderHeight)];
        lb.backgroundColor = [UIColor lightGrayColor];
        lb.text = theTitle;
        lb.textColor = [UIColor whiteColor];
        [headerView addSubview:lb];
        return headerView;
    } else {
        MAOfflineProvince *pro = self.provinces[section - self.sectionTitles.count];
        theTitle = pro.name;
        
        MAHeaderView *headerView = [[MAHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), kTableCellHeight) expanded:_expandedSections[section]];
        
        headerView.section = section;
        headerView.text = theTitle;
        headerView.delegate = self;
        
        return headerView;
    }
}

// 设置区头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section < self.sectionTitles.count ? kSectionHeaderHeight : kTableCellHeight;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.needReloadWhenDisappear)
    {
        // 将离线地图解压到 Documents/3dvmap/ 目录下后，调用此函数使离线数据生效
        [self.mapView reloadMap];
        
        self.needReloadWhenDisappear = NO;
    }
}

#pragma mark - MAHeaderViewDelegate
- (void)headerView:(MAHeaderView *)headerView section:(NSInteger)section expanded:(BOOL)expanded
{
    _expandedSections[section] = expanded;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}



@end
