//
//  OIHUD.h
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/11.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIHUD : UIView
//0请稍候 1导出功能即将上线
-(void)showInView:(UIView*)view type:(NSInteger)type;
-(void)hideView;
-(void)showInView:(UIView *)view deleteCnt:(NSInteger)deleteCnt;
-(void)setDeleteProgress:(NSInteger)progress deleteCnt:(NSInteger)deleteCnt;
@end

NS_ASSUME_NONNULL_END
