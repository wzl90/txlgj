//
//  BRTabbarVC.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/2.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "BRTabbarVC.h"
#import "MainVC.h"
#import "Common.h"
#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface BRTabbarVC ()
{
    NSMutableArray *viewControllers;//TabBar控制的界面
    NSInteger selectedIndex;//选中的Tab项
    UIView *tabBarView;
    NSMutableArray *buttons;
}
@end

@implementation BRTabbarVC
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    //第一级页面不能有手势返回功能，会出问题
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
#endif
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    viewControllers = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++)
    {
        [viewControllers addObject:[NSNull null]];
    }
    selectedIndex = -1;

    tabBarView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-80-kIPhoneXBottomHeight, self.view.bounds.size.width, 80+kIPhoneXBottomHeight)];
    [tabBarView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tabBarView];

    UIView *bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tabBarView.bounds.size.width, 60)];
    [bg1 setBackgroundColor:[UIColor whiteColor]];
    bg1.layer.shadowColor = [UIColor colorWithWhite:224/255.0 alpha:1].CGColor;
    bg1.layer.shadowRadius = 30;
    bg1.layer.shadowOpacity = 0.7;
    bg1.layer.shadowOffset = CGSizeMake(0, 0);
    [bg1.layer setCornerRadius:30];
    [tabBarView addSubview:bg1];

    UIView *bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 30, tabBarView.bounds.size.width, tabBarView.bounds.size.height-30)];
    [bg2 setBackgroundColor:[UIColor whiteColor]];
    [tabBarView addSubview:bg2];

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
#endif
    buttons = [NSMutableArray array];
    NSArray *tabIcons = @[@{@"up":@"tabbar_0_on",@"down":@"tabbar_0_off",@"title":@"整理"},@{@"up":@"tabbar_1_on",@"down":@"tabbar_1_off",@"title":@"美化"}];
    NSInteger itemCnt = tabIcons.count;
    for (int i = 0; i<itemCnt; i++)
    {
        CGFloat btnW = tabBarView.bounds.size.width/itemCnt;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0.0, 0.0,btnW , 80);
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.frame = CGRectMake(i*btnW, 0.0, button.frame.size.width, button.frame.size.height);
        [button setTag:(1000+i)];
        button.adjustsImageWhenHighlighted = YES;
        [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];

        UIImageView *btnImage = [[UIImageView alloc]initWithFrame:CGRectMake((btnW-40)/2, 13, 40, 40)];
        [btnImage setTag:10000];
        [button addSubview:btnImage];

        UILabel *iconTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 56, btnW, 16)];
        [iconTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [iconTitleLabel setTag:10001];
        [iconTitleLabel setFont:kFont(@"PingFangSC-Regular", 12)];
        [button addSubview:iconTitleLabel];

        NSDictionary *dic = [tabIcons objectAtIndex:i];
        [btnImage setImage:[UIImage imageNamed:dic[@"down"]]];
        [btnImage setHighlightedImage:[UIImage imageNamed:dic[@"up"]]];
        [iconTitleLabel setText:dic[@"title"]];

        [buttons addObject:button];
        [tabBarView addSubview:button];
    }

    [self touchDownAction:[buttons objectAtIndex:0]];
}
- (void)touchDownAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    [self touchDownAtItemAtIndex:[buttons indexOfObject:button]];
}
- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}
- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    NSInteger tempIndex = [buttons indexOfObject:selectedButton];
    if (tempIndex < buttons.count)
    {
        for (UIButton* button in buttons)
        {
            UIImageView *iconImage = (UIImageView*)[button viewWithTag:10000];
            UILabel *iconTitleLabel = (UILabel*)[button viewWithTag:10001];

            if (button == selectedButton)
            {
//                button.selected = YES;
//                button.highlighted = button.selected ? NO : YES;
                [iconImage setHighlighted:YES];
                [iconTitleLabel setTextColor:OIRGBA(135, 141, 175, 1)];
            }
            else
            {
//                button.selected = NO;
//                button.highlighted = NO;
                [iconImage setHighlighted:NO];
                [iconTitleLabel setTextColor:OIRGBA(135, 141, 175, 0.5)];
            }
        }
    }
}
- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    if(itemIndex==selectedIndex)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"vcScrollToTop" object:nil userInfo:@{@"index":[NSNumber numberWithInteger:selectedIndex]}];
        return;
    }
    UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
    [currentView removeFromSuperview];

    if(selectedIndex>=0)
    {
        UIViewController* currentViewController = [viewControllers objectAtIndex:selectedIndex];
        [currentViewController removeFromParentViewController];
    }
    selectedIndex = itemIndex;

    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    //    NSNumber *preUseLayout = [[NSUserDefaults standardUserDefaults]objectForKey:@"preUseLayout"];
    //    NSNumber *preGiftUseLayout = [[NSUserDefaults standardUserDefaults]objectForKey:@"preGiftUseLayout"];

    UIViewController* viewController = [viewControllers objectAtIndex:selectedIndex];
    if((NSNull*)viewController==[NSNull null])
    {
        CGRect frame = self.view.bounds;
        switch (itemIndex) {
            case 0:
            {
                //不减50的原因是首页搜索的时候要展示到全屏，不能加上tabbar
                viewController = [[MainVC alloc] init];
                viewController.view.frame = frame;
            }
                break;
            case 1:
            {
                viewController = [[MainVC alloc] init];
                viewController.view.frame = frame;
            }
                break;
            case 2:
            {

            }
                break;
            case 3:
            {

            }
                break;
            case 4:
            {

            }
                break;
                //            case kTabDiscoverTag:
            default:
            {

            }
                break;
        }
        [viewControllers replaceObjectAtIndex:selectedIndex withObject:viewController];
    }
    [self addChildViewController:viewController];
    viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;

    [self.view insertSubview:viewController.view belowSubview:tabBarView];
}
-(BOOL)disableGesture
{
    return YES;
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    for(int i = 0;i<viewControllers.count;i++)
    {
        UIViewController* viewController = [viewControllers objectAtIndex:i];
        if(i!=selectedIndex)
        {
            if ((NSNull *)viewController != [NSNull null])
            {
                [viewController removeFromParentViewController];
                [viewControllers replaceObjectAtIndex:i withObject:[NSNull null]];
            }
        }
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
