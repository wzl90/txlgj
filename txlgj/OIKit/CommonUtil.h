//
//  CommonUtil.h
//  BirthdayReminder
//
//  Created by 筱煜 余 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject


+ (UIFont *)getFontWithFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+(NSString *)mobileNum:(NSString *)str;

+ (void)showCommonToastWithStr:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject;
+ (void)showCommonToastWithStr:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject isCover:(BOOL)isCover;
+ (void)showCommonToastWithStr:(NSString *)str hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject;
+ (void)showCommonToastWithStrInCenter:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject;
+ (void)showCommonToastWithStrInCenter:(NSString *)str hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject;
@end
