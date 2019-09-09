//
//  DeleteVC.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/6.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "DeleteVC.h"
#import "Common.h"
#import "OIABRecordData.h"
#import "YYNTableViewIndexView.h"
#import "Hanzi.h"
#import "MBProgressHUD.h"
#import "commonUtil.h"
#import <AddressBook/AddressBook.h>
@interface DeleteVC ()<UITableViewDelegate,UITableViewDataSource,YYNTableViewIndexViewDataSource,YYNSectionIndexViewDelegate>
{
    __block NSMutableDictionary *personDict;
    __block NSMutableArray *indexArray;
    MBProgressHUD *HUD;
}
@property(nonatomic,strong)UITableView *theTableView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)YYNTableViewIndexView *indexView;
@property(nonatomic,strong)NSMutableDictionary *personDict;
@property(nonatomic,strong)NSMutableArray *indexArray;
@property(nonatomic,strong)MBProgressHUD *HUD;
@property(nonatomic,assign)BOOL isSelectAll;
@end

@implementation DeleteVC
@synthesize personDict;
@synthesize indexArray;
@synthesize HUD;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    personDict = [NSMutableDictionary dictionary];
    indexArray = [NSMutableArray array];

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];

        //        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
#endif
    CGFloat topMarign = 20;
    if (kIPhoneXTopHeight>0) {
        topMarign = kIPhoneXTopHeight;
    }
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, topMarign + 68)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];

    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, topMarign+(68-32)/2, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:@"tabbar_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame)+18, topMarign, topView.bounds.size.width-(CGRectGetMaxX(backBtn.frame)+18), 68)];
    [titleLabel setText:@"批量删除"];
    [titleLabel setFont:kFont(@"PingFangSC-Medium", 24)];
    [titleLabel setTextColor:OIRGBA(88, 98, 143, 1)];
    [topView addSubview:titleLabel];

    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-(80+kIPhoneXBottomHeight), self.view.bounds.size.width, 80+kIPhoneXBottomHeight)];
    [self.bottomView setBackgroundColor:[UIColor clearColor]];
    [self.bottomView setUserInteractionEnabled:YES];

    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bottomView.bounds.size.width, 60)];
    [bg1 setBackgroundColor:[UIColor whiteColor]];
    bg1.layer.shadowColor = [UIColor colorWithWhite:224/255.0 alpha:1].CGColor;
    bg1.layer.shadowRadius = 30;
    bg1.layer.shadowOpacity = 0.7;
    bg1.layer.shadowOffset = CGSizeMake(0, 0);
    [bg1.layer setCornerRadius:30];
    [self.bottomView addSubview:bg1];

    UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.bottomView.bounds.size.width, self.bottomView.bounds.size.height-30)];
    [bg2 setBackgroundColor:[UIColor whiteColor]];
    [self.bottomView addSubview:bg2];

    UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
    [selectImage setTag:10000];
    [selectImage setImage:[UIImage imageNamed:@"check_unselected"]];
    [selectImage setHighlightedImage:[UIImage imageNamed:@"check_selected"]];
    [self.bottomView addSubview:selectImage];

    UILabel *selectLabel = [[UILabel alloc]init];
    [selectLabel setText:@"全选"];
    [selectLabel setFont:kFont(@"PingFangSC-Medium", 16)];
    [selectLabel setTextColor:OIRGBA(88, 98, 143, 1)];
    [selectLabel sizeToFit];
    [selectLabel setFrame:CGRectMake(CGRectGetMaxX(selectImage.frame)+20, 30, selectLabel.bounds.size.width, 20)];
    [self.bottomView addSubview:selectLabel];

    UIButton *allBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, 30, 20+20+30, 20)];
    [allBtn addTarget:self action:@selector(onAllTap) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:allBtn];

    UIButton *exportBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.bottomView.bounds.size.width-100-30, 20, 100, 40)];
    [exportBtn setBackgroundColor:OIRGBA(234, 238, 254, 1)];
    [exportBtn setTitle:@"导出" forState:UIControlStateNormal];
    [exportBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", 16)];
    [exportBtn.layer setCornerRadius:10];
    [exportBtn.layer setMasksToBounds:YES];
    [exportBtn setTitleColor:OIRGBA(88, 98, 143, 1) forState:UIControlStateNormal];
    [exportBtn addTarget:self action:@selector(onExportClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:exportBtn];

    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(exportBtn.frame.origin.x-10-100, 20, 100, 40)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", 16)];
    [delBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [delBtn.titleLabel setMinimumScaleFactor:0.5];
    [delBtn setBackgroundColor:OIRGBA(70, 95, 253, 1)];
    [delBtn.layer setCornerRadius:10];
    [delBtn.layer setMasksToBounds:YES];
    [self.bottomView addSubview:delBtn];
    [delBtn addTarget:self action:@selector(onDelClick) forControlEvents:UIControlEventTouchUpInside];
    [delBtn setTag:10001];

    self.theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(topView.frame)-self.bottomView.bounds.size.height) style:UITableViewStylePlain];
    self.theTableView.estimatedRowHeight = 0;
    self.theTableView.estimatedSectionFooterHeight = 0;
    self.theTableView.estimatedSectionHeaderHeight = 0;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
        if (@available(iOS 11.0, *)) {
            self.theTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
#endif
    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];

    [self.view addSubview:self.bottomView];
    [self.bottomView setHidden:YES];

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"请稍候...";
    [self.view addSubview:HUD];

    [self initData];
}
-(void)initData
{
    [HUD show:YES];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *recordsArray = [OIABRecordData ABRecordsArray];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSMutableArray *indexArray_temp = [NSMutableArray array];
            NSMutableDictionary *personDict_temp = [NSMutableDictionary dictionary];
            for(OIABRecord *remind in recordsArray)
            {
                NSString *firstStr = [Hanzi toPinyinFirstStr:remind.name];
                if ([personDict_temp objectForKey:firstStr] == nil)
                {
                    [personDict_temp setObject:[NSMutableArray array] forKey:firstStr];
                }
                [[personDict_temp objectForKey:firstStr] addObject:remind];
            }
            for (NSString *key in personDict_temp) {
                NSMutableArray *persons = [personDict_temp objectForKey:key];
                [persons sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    //            NSString *name1 = [Hanzi toPinyinFirstStr:[obj1 name]];
                    //            NSString *name2 = [Hanzi toPinyinFirstStr:[obj2 name]];
                    NSString *name1 = [obj1 name];
                    NSString *name2 = [obj2 name];
                    return [name1 localizedCompare:name2];
                }];
            }
            NSMutableArray *tempIndexArray = [NSMutableArray arrayWithArray:[[personDict_temp allKeys] sortedArrayUsingSelector:@selector(compare:)]];
            indexArray_temp = tempIndexArray;
            dispatch_sync(dispatch_get_main_queue(), ^{
                [weakSelf.HUD hide:YES];
                [weakSelf.indexArray removeAllObjects];
                [weakSelf.personDict removeAllObjects];
                weakSelf.indexArray = [indexArray_temp mutableCopy];
                weakSelf.personDict = [personDict_temp mutableCopy];
                [weakSelf.indexView setFrame:CGRectMake(weakSelf.view.frame.size.width - 20, (weakSelf.view.frame.size.height-(weakSelf.indexArray.count*20))/2, 20, (weakSelf.indexArray.count*20))];
                [weakSelf.indexView reloadItemViews];
                [weakSelf.indexView setHidden:NO];
                weakSelf.theTableView.tableFooterView = nil;
                if (weakSelf.indexArray.count == 0)
                {
                    [weakSelf.bottomView setHidden:YES];
                    [weakSelf.indexView setHidden:YES];
                    weakSelf.theTableView.tableFooterView = [weakSelf configTableViewFootView];
                }
                else
                {
                    [weakSelf.bottomView setHidden:NO];
                }
                [weakSelf.theTableView reloadData];
            });
        });
    });
}
-(UIView*)configTableViewFootView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.theTableView.bounds.size.height)];
    UIImageView *emptyImage = [[UIImageView alloc]initWithFrame:CGRectMake((view.bounds.size.width-226)/2, 70, 226, 220)];
    [emptyImage setImage:[UIImage imageNamed:@"ab_empty"]];
    [view addSubview:emptyImage];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(emptyImage.frame)+25, view.bounds.size.width, 18)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"联系人都去哪了"];
    [label setFont:kFont(@"PingFangSC-Light", 14)];
    [label setTextColor:OIRGBA(88, 98, 143, 1)];
    [view addSubview:label];

    return view;
}
- (YYNTableViewIndexView *)indexView{
    if (_indexView == nil) {
        _indexView = [[YYNTableViewIndexView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20, (self.view.frame.size.height-(indexArray.count*20))/2, 20, (indexArray.count*20))];
        _indexView.backgroundColor = [UIColor clearColor];
        _indexView.itemHeight = 20;

        _indexView.dataSource = self;
        _indexView.delegate = self;

        [_indexView reloadItemViews];

        [self.view addSubview:_indexView];
    }
    return _indexView;
}
-(void)onBackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)onExportClick
{

}
-(void)onDelClick
{
    NSMutableArray *delData = [NSMutableArray array];
    NSMutableArray *lastData = [NSMutableArray array];
    NSMutableDictionary *kvDic = [NSMutableDictionary dictionary];
    for (int i= 0; i < indexArray.count; i++)
    {
        NSString *key = [indexArray objectAtIndex:i];
        NSArray *array = [personDict objectForKey:key];
        for (int j = 0; j < array.count; j++)
        {
            OIABRecord *record = [array objectAtIndex:j];
            if (record.isSelected)
            {
                [delData addObject:record];
            }
            else
            {
                [lastData addObject:record];
            }
            [kvDic setObject:record forKey:[NSString stringWithFormat:@"%ld",record.recordId]];
        }
    }
    if (delData.count == 0) {
        [CommonUtil showCommonToastWithStrInCenter:@"请选择删除记录" forView:self.view hideAfterSeconds:1.5 andAfterPostAction:nil postObject:nil];
        return;
    }
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();//初始化
    for(int i= 0;i<delData.count;i++)
    {
        CFErrorRef error = NULL;
        OIABRecord *record = [delData objectAtIndex:i];
        ABRecordRef deletedPeople = ABAddressBookGetPersonWithRecordID(iPhoneAddressBook, (int)record.recordId);
        ABAddressBookRemoveRecord(iPhoneAddressBook, deletedPeople, &error);
        if (error)
        {
            if ([kvDic objectForKey:[NSString stringWithFormat:@"%ld",record.recordId]])
            {
                [lastData addObject:[kvDic objectForKey:[NSString stringWithFormat:@"%ld",record.recordId]]];
            }
        }
    }
    CFErrorRef error = NULL;
    ABAddressBookSave(iPhoneAddressBook, &error);
    if (error)
    {
        [CommonUtil showCommonToastWithStrInCenter:@"通讯录删除失败" forView:self.view hideAfterSeconds:1.5 andAfterPostAction:nil postObject:nil];
    }
    else
    {
        [CommonUtil showCommonToastWithStrInCenter:@"通讯录删除成功" forView:self.view hideAfterSeconds:1.5 andAfterPostAction:nil postObject:nil];

        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *recordsArray = lastData;
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                NSMutableArray *indexArray_temp = [NSMutableArray array];
                NSMutableDictionary *personDict_temp = [NSMutableDictionary dictionary];
                for(OIABRecord *remind in recordsArray)
                {
                    NSString *firstStr = [Hanzi toPinyinFirstStr:remind.name];
                    if ([personDict_temp objectForKey:firstStr] == nil)
                    {
                        [personDict_temp setObject:[NSMutableArray array] forKey:firstStr];
                    }
                    [[personDict_temp objectForKey:firstStr] addObject:remind];
                }
                for (NSString *key in personDict_temp) {
                    NSMutableArray *persons = [personDict_temp objectForKey:key];
                    [persons sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        //            NSString *name1 = [Hanzi toPinyinFirstStr:[obj1 name]];
                        //            NSString *name2 = [Hanzi toPinyinFirstStr:[obj2 name]];
                        NSString *name1 = [obj1 name];
                        NSString *name2 = [obj2 name];
                        return [name1 localizedCompare:name2];
                    }];
                }
                NSMutableArray *tempIndexArray = [NSMutableArray arrayWithArray:[[personDict_temp allKeys] sortedArrayUsingSelector:@selector(compare:)]];
                indexArray_temp = tempIndexArray;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [weakSelf.indexArray removeAllObjects];
                    [weakSelf.personDict removeAllObjects];
                    weakSelf.indexArray = [indexArray_temp mutableCopy];
                    weakSelf.personDict = [personDict_temp mutableCopy];
                    [weakSelf.indexView setFrame:CGRectMake(weakSelf.view.frame.size.width - 20, (weakSelf.view.frame.size.height-(weakSelf.indexArray.count*20))/2, 20, (weakSelf.indexArray.count*20))];
                    [weakSelf.indexView reloadItemViews];
                    [weakSelf.indexView setHidden:NO];
                    weakSelf.theTableView.tableFooterView = nil;
                    if (weakSelf.indexArray.count == 0)
                    {
                        [weakSelf.bottomView setHidden:YES];
                        [weakSelf.indexView setHidden:YES];
                        weakSelf.theTableView.tableFooterView = [weakSelf configTableViewFootView];
                    }
                    else
                    {
                        [weakSelf.bottomView setHidden:NO];
                    }
                    [weakSelf updateBottomView];
                    [weakSelf.theTableView reloadData];
                });
            });
        });
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return indexArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [indexArray objectAtIndex:section];
    NSMutableArray *names = [personDict objectForKey:key];
    return [names count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [indexArray objectAtIndex:indexPath.section];
    NSArray *array = [personDict objectForKey:key];
    if (indexPath.row == array.count-1)
    {
        return 80 + 25;
    }
    return 80;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 24;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *key = [indexArray objectAtIndex:section];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 24)];
    [headView setBackgroundColor:[UIColor whiteColor]];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, self.theTableView.bounds.size.width-20, 24)];
    [titleLabel setText:key];
    [titleLabel setFont:[CommonUtil getFontWithFontName:@"PingFangSC-Regular" andFontSize:14]];
    [titleLabel setTextColor:[UIColor colorWithRed:153/255.0 green:141/255.0 blue:175/255.0 alpha:1]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [headView addSubview:titleLabel];

    return headView;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    static NSString *spaceIdentifier = @"spaceIdentifier";

    UITableViewCell *cell = nil;
    if (indexPath.section < indexArray.count) {
        NSString *key = [indexArray objectAtIndex:indexPath.section];
        NSArray *array = [personDict objectForKey:key];
        if (indexPath.row < array.count)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell.contentView setBackgroundColor:[UIColor whiteColor]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                UIImageView *selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 20, 20)];
                [selectImage setTag:2000];
                [selectImage setImage:[UIImage imageNamed:@"check_unselected"]];
                [selectImage setHighlightedImage:[UIImage imageNamed:@"check_selected"]];
                [cell.contentView addSubview:selectImage];

                UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(selectImage.frame)+20, 20, 40, 40)];
                [avatar.layer setMasksToBounds:YES];
                [avatar.layer setCornerRadius:20];
                [avatar setTag:2001];
                [cell.contentView addSubview:avatar];

                UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+14, 21, self.view.bounds.size.width-(CGRectGetMaxX(avatar.frame)+14)-20, 20)];
                [nameLabel setTag:2002];
                [nameLabel setTextColor:OIRGBA(88, 98, 143, 1)];
                [nameLabel setFont:kFont(@"PingFangSC-Medium", 16)];
                [cell.contentView addSubview:nameLabel];

                UILabel *phoneNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+14, 45, self.view.bounds.size.width-(CGRectGetMaxX(avatar.frame)+14)-20, 18)];
                [phoneNumLabel setFont:kFont(@"PingFangSC-Light", 14)];
                [phoneNumLabel setTextColor:OIRGBA(135, 141, 175, 1)];
                [phoneNumLabel setTag:2003];
                [cell.contentView addSubview:phoneNumLabel];

                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(avatar.frame.origin.x, 79.5, self.view.bounds.size.width-avatar.frame.origin.x-30, 0.5)];
                [lineView setBackgroundColor:OIRGBA(239, 238, 255, 1)];
                [cell.contentView addSubview:lineView];
            }
            OIABRecord *record = [array objectAtIndex:indexPath.row];
            UIImageView *selectImage = (UIImageView*)[cell.contentView viewWithTag:2000];
            UIImageView *avatar = (UIImageView*)[cell.contentView viewWithTag:2001];
            UILabel *nameLabel = (UILabel*)[cell.contentView viewWithTag:2002];
            UILabel *phoneNumLabel = (UILabel*)[cell.contentView viewWithTag:2003];
            if (record.imgData)
            {
                [avatar setImage:[UIImage imageWithData:record.imgData]];
            }
            else
            {
                [avatar setImage:[UIImage imageNamed:@"avatar_default.png"]];
            }
            [nameLabel setText:record.name];
            [selectImage setHighlighted:record.isSelected];
            [phoneNumLabel setText:record.phoneNum];
            return cell;
        }
    }
    cell = [tableView dequeueReusableCellWithIdentifier:spaceIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:spaceIdentifier];
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}
#pragma mark - 索引代理方法

- (YYNTableViewIndexItemView *)sectionIndexView:(YYNTableViewIndexView *)sectionIndexView itemViewForSection:(NSInteger)section{

    YYNTableViewIndexItemView *itemView = [[YYNTableViewIndexItemView alloc] init];
    itemView.titleLabel.text = [indexArray objectAtIndex:section];
    itemView.titleLabel.font = [UIFont systemFontOfSize:10];
    itemView.titleLabel.textColor = [UIColor colorWithRed:147/255.0 green:142/255.0 blue:142/255.0 alpha:1];
    itemView.titleLabel.highlightedTextColor = [UIColor grayColor];
    itemView.titleLabel.shadowColor = [UIColor whiteColor];
    itemView.titleLabel.shadowOffset = CGSizeMake(0, 1);

    return itemView;
}
//返回一共有多少组
- (NSInteger)numberOfItemViewForSectionIndexView:(YYNTableViewIndexView *)sectionIndexView
{
    return indexArray.count;
}

//选中索引后做相应的操作
- (void)sectionIndexView:(YYNTableViewIndexView *)sectionIndexView
        didSelectSection:(NSInteger)section{
    NSString *chaStr = indexArray[section];
    for (int i = 0; i < indexArray.count; i++) {
        if ([chaStr isEqualToString:indexArray[i]]) {
            [self.theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return;
        }
    }
    return;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section < indexArray.count) {
        NSString *key = [indexArray objectAtIndex:indexPath.section];
        NSArray *array = [personDict objectForKey:key];
        if (indexPath.row < array.count)
        {
            OIABRecord *record = [array objectAtIndex:indexPath.row];
            record.isSelected = !record.isSelected;
            [self.theTableView reloadData];
            [self updateBottomView];
        }
    }
}
-(void)updateBottomView
{
    BOOL tmpIsSelectAll = YES;
    NSInteger cnt = 0;
    for (int i= 0; i < indexArray.count; i++)
    {
        NSString *key = [indexArray objectAtIndex:i];
        NSArray *array = [personDict objectForKey:key];
        for (int j = 0; j < array.count; j++)
        {
            OIABRecord *record = [array objectAtIndex:j];
            if (record.isSelected)
            {
                cnt ++;
            }
            else
            {
                tmpIsSelectAll = NO;
            }
        }
    }
    self.isSelectAll = tmpIsSelectAll;
    UIButton *delBtn = (UIButton*)[self.bottomView viewWithTag:10001];
    if (cnt == 0)
    {
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    else
    {
        [delBtn setTitle:[NSString stringWithFormat:@"删除（%ld）",cnt] forState:UIControlStateNormal];
    }
    UIImageView *selectImage = (UIImageView*)[self.bottomView viewWithTag:10000];
    [selectImage setHighlighted:self.isSelectAll];
}
-(void)onAllTap
{
    self.isSelectAll = !self.isSelectAll;
    NSInteger cnt = 0;
    for (int i= 0; i < indexArray.count; i++)
    {
        NSString *key = [indexArray objectAtIndex:i];
        NSArray *array = [personDict objectForKey:key];
        for (int j = 0; j < array.count; j++)
        {
            OIABRecord *record = [array objectAtIndex:j];
            record.isSelected = self.isSelectAll;
            if (record.isSelected) {
                cnt++;
            }
        }
    }
    UIButton *delBtn = (UIButton*)[self.bottomView viewWithTag:10001];
    if (cnt == 0)
    {
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    }
    else
    {
        [delBtn setTitle:[NSString stringWithFormat:@"删除（%ld）",cnt] forState:UIControlStateNormal];
    }
    UIImageView *selectImage = (UIImageView*)[self.bottomView viewWithTag:10000];
    [selectImage setHighlighted:self.isSelectAll];
    [self.theTableView reloadData];
}
@end
