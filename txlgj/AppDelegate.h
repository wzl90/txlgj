//
//  AppDelegate.h
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/2.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OINavigationController.h"

#define BRAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) OINavigationController *navigationController;

@end

