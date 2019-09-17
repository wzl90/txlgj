//
//  MergeVC.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/6.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "MergeVC.h"
#import "OIHUD.h"
#import "Common.h"
#import "commonUtil.h"
@interface MergeVC ()
@property(nonatomic,strong)OIHUD *oiHUD;
@end

@implementation MergeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
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



    [self.oiHUD showInView:self.view mergeCnt:0];
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
-(OIHUD*)oiHUD
{
    if (!_oiHUD) {
        _oiHUD = [[OIHUD alloc]init];
    }
    return _oiHUD;
}
@end
