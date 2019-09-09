//
//  ABAuthorizeView.h
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/6.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ABAuthorizeView : UIView
@property (nonatomic,copy)void(^agreeBlock)();
-(void)showInView:(UIView*)view;
-(void)show;
@end

