//
//  OINavigationController.m
//  BirthdayReminder
//
//  Created by YuXiao on 13-11-11.
//
//

#import "OINavigationController.h"

@interface OINavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation OINavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    __weak OINavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.interactivePopGestureRecognizer.enabled = NO;
#endif

    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //NewGuideVC,CoverViewController,RemindNotifierVC,GuideViewController这几个界面应该禁用手势返回功能。通过加disableGesture方法来判断是否是以上几个界面
    //PwdLoginViewController,PwdSetupViewController在navigationController中是允许返回功能的
    //    if([viewController respondsToSelector:@selector(disableGesture)])
    //        return;

    // Enable the gesture again once the new controller is shown
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        if([viewController respondsToSelector:@selector(disableGesture)])
            self.interactivePopGestureRecognizer.enabled = NO;
        else
            self.interactivePopGestureRecognizer.enabled = YES;
    }

#endif
}

@end
