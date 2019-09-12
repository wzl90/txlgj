//
//  ViewController.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/2.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "MainVC.h"
#import "Common.h"
#import "ABAuthorizeView.h"
#import <AddressBook/AddressBook.h>
#import "DeleteVC.h"
#import "AppDelegate.h"
#import "commonUtil.h"

@interface MainVC ()
@property(nonatomic,strong)UIScrollView *theScrollView;
@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setExtendedLayoutIncludesOpaqueBars:NO];
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.theScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-(80+kIPhoneXBottomHeight))];
    [self.theScrollView setShowsVerticalScrollIndicator:YES];
    if (@available(iOS 11.0, *)) {
        self.theScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self.view addSubview:_theScrollView];

    CGFloat startY = 20+kIPhoneXTopHeight+ 44;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, startY, self.theScrollView.bounds.size.width-30, kAutoW(24)+4)];
    [titleLabel setTextColor:OIRGBA(88, 98, 143, 1)];
    [titleLabel setFont:kFont(@"PingFangSC-Medium", kAutoW(24))];
    [titleLabel setText:@"整理通讯录"];
    [self.theScrollView addSubview:titleLabel];

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.theScrollView.bounds.size.width-kAutoW(335))/2, CGRectGetMaxY(titleLabel.frame)+kAutoW(34), kAutoW(335), kAutoW(300))];
    [imageView setImage:[UIImage imageNamed:@"main_ab"]];
    [self.theScrollView addSubview:imageView];

    UIButton *mergeBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.theScrollView.bounds.size.width-kAutoW(224))/2, CGRectGetMaxY(imageView.frame), kAutoW(224), kAutoW(50))];
    [mergeBtn setTitle:@"合并重复联系人" forState:UIControlStateNormal];
    [mergeBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", kAutoW(16))];
    [mergeBtn setBackgroundColor:OIRGBA(70, 95, 253, 1)];
    [mergeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mergeBtn.layer setCornerRadius:kAutoW(10)];
    [mergeBtn.layer setMasksToBounds:YES];
    [mergeBtn addTarget:self action:@selector(doOperClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:mergeBtn];
    [mergeBtn setTag:1000];

    UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.theScrollView.bounds.size.width-kAutoW(224))/2, CGRectGetMaxY(mergeBtn.frame)+kAutoW(14), kAutoW(224), kAutoW(50))];
    [delBtn setTitle:@"批量删除联系人" forState:UIControlStateNormal];
    [delBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", kAutoW(16))];
    [delBtn setBackgroundColor:OIRGBA(254, 149, 47, 1)];
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delBtn.layer setCornerRadius:kAutoW(10)];
    [delBtn.layer setMasksToBounds:YES];
    [delBtn addTarget:self action:@selector(doOperClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:delBtn];
    [delBtn setTag:1001];

    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.theScrollView.bounds.size.width-kAutoW(224))/2, CGRectGetMaxY(delBtn.frame)+kAutoW(14), kAutoW(224), kAutoW(50))];
    [clearBtn setTitle:@"一键清空通讯录" forState:UIControlStateNormal];
    [clearBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", kAutoW(16))];
    [clearBtn setBackgroundColor:OIRGBA(255, 182, 21, 1)];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [clearBtn.layer setCornerRadius:kAutoW(10)];
    [clearBtn.layer setMasksToBounds:YES];
    [clearBtn addTarget:self action:@selector(doOperClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.theScrollView addSubview:clearBtn];
    [clearBtn setTag:1002];

    [self.theScrollView setContentSize:CGSizeMake(self.theScrollView.bounds.size.width, CGRectGetMaxY(clearBtn.frame)+20)];
}
-(void)doOperClick:(id)sender
{
    UIButton *btn = (id)sender;
    NSInteger type = btn.tag - 1000;
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized)
    {
        [self doOper:type];
    }
    else if(status==kABAuthorizationStatusNotDetermined)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ABAuthorizeView *abView = [[ABAuthorizeView alloc]init];
            abView.agreeBlock = ^{
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
                ABAddressBookRequestAccessWithCompletion(addressBook,^(bool granted, CFErrorRef error){
                    if(granted)
                    {
                        [self performSelectorOnMainThread:@selector(onAuthorizeAction:) withObject:@(type) waitUntilDone:NO];
                    }
                    else
                    {

                    }
                });

            };
            [abView show];
        });
    }
    else
    {
        ABAuthorizeView *abView = [[ABAuthorizeView alloc]init];
        abView.agreeBlock = ^{
            if ([UIApplication instancesRespondToSelector:@selector(currentUserNotificationSettings)])
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        };
        [abView show];
    }
}
-(void)onAuthorizeAction:(NSNumber*)type
{
    [self doOper:type.integerValue];
}
-(void)doOper:(NSInteger)type
{
    if (type == 0) {

    }
    else if(type == 1)
    {
        DeleteVC *delVC = [[DeleteVC alloc]init];
        [BRAppDelegate.navigationController pushViewController:delVC animated:YES];
    }
    else
    {

    }
}
@end
