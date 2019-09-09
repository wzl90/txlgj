//
//  MergeVC.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/6.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "MergeVC.h"

@interface MergeVC ()

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
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
