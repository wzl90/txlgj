//
//  CommonUtil.m
//  BirthdayReminder
//
//  Created by 筱煜 余 on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommonUtil.h"
#import "AppDelegate.h"
@implementation CommonUtil

+ (UIFont *)getFontWithFontName:(NSString *)fontName andFontSize:(CGFloat)fontSize
{
    UIFont * font = [UIFont fontWithName:fontName size:fontSize];
    if (font == nil)
    {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];


    if ([cString length] < 6)
        return [UIColor whiteColor];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor whiteColor];

    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];


    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
+(NSString *)mobileNum:(NSString *)str
{
    if(str==nil)
        return @"";
    NSString *mobile = [NSString stringWithString:str];
    if([mobile hasPrefix:@"+86"])
        mobile = [mobile substringFromIndex:3];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mobile;
}
+ (void)showCommonToastWithStr:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject
{
    //左右15，上下10，可多行显示，
    UIFont * tipFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    if (tipFont == nil)
    {
        tipFont = [UIFont systemFontOfSize:14];
    }
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(view.frame.size.width - 2 * 15 - 2 * 15, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:tipFont} context:NULL].size;
    if (strSize.width < 30)
    {
        strSize.width = 30;
    }
    if (strSize.height < 20)
    {
        strSize.height = 20;
    }
    __block UIView * bacView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - (strSize.width + 15 * 2) / 2.f, view.frame.size.height - 131 - strSize.height - 10 * 2, strSize.width + 2 * 15, strSize.height + 10 * 2)];
    bacView.backgroundColor = [UIColor clearColor];
    bacView.layer.cornerRadius = 10.f;
    bacView.layer.masksToBounds = YES;
    [view addSubview:bacView];

    UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bacView.frame.size.width, bacView.frame.size.height)];
    tipView.backgroundColor = [UIColor colorWithWhite:51 / 255.f alpha:0.8];
    [bacView addSubview:tipView];

    UILabel * tipLabel = [[UILabel alloc] initWithFrame:tipView.frame];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = str;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = tipFont;
    tipLabel.numberOfLines = 0;
    [bacView addSubview:tipLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [bacView removeFromSuperview];
        bacView = nil;
        if (postActionName && postActionName.length > 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:postActionName object:postObject];
        }
        view.userInteractionEnabled = YES;
    });
}
+ (void)showCommonToastWithStr:(NSString *)str hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject
{
    //左右15，上下10，可多行显示，
    UIFont * tipFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    if (tipFont == nil)
    {
        tipFont = [UIFont systemFontOfSize:14];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    window.userInteractionEnabled = NO;
    [self showCommonToastWithStr:str forView:window hideAfterSeconds:timeInterval andAfterPostAction:postActionName postObject:postObject];
}

+ (void)showCommonToastWithStr:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject isCover:(BOOL)isCover
{
    if (isCover)
    {
        //左右15，上下10，可多行显示，
        UIFont * tipFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
        if (tipFont == nil)
        {
            tipFont = [UIFont systemFontOfSize:14];
        }
        CGSize strSize = [str boundingRectWithSize:CGSizeMake(view.frame.size.width - 2 * 15 - 2 * 15, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:tipFont} context:NULL].size;
        if (strSize.width < 40)
        {
            strSize.width = 40;
        }
        if (strSize.height < 20)
        {
            strSize.height = 20;
        }
        UIWindow * window = [[UIApplication sharedApplication].delegate window];
        __block UIView * coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
        coverView.backgroundColor = [UIColor clearColor];
        [window addSubview:coverView];

        UIView * bacView = [[UIView alloc] initWithFrame:CGRectMake(coverView.frame.size.width / 2 - (strSize.width + 15 * 2) / 2.f, coverView.frame.size.height - 131 - strSize.height - 10 * 2, strSize.width + 2 * 15, strSize.height + 10 * 2)];
        bacView.backgroundColor = [UIColor clearColor];
        bacView.layer.cornerRadius = 10.f;
        bacView.layer.masksToBounds = YES;
        [coverView addSubview:bacView];

        UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bacView.frame.size.width, bacView.frame.size.height)];
        tipView.backgroundColor = [UIColor colorWithWhite:51 / 255.f alpha:0.8];
        [bacView addSubview:tipView];

        UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, bacView.frame.size.width - 2 * 15, bacView.frame.size.height)];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = str;
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = tipFont;
        tipLabel.numberOfLines = 0;
        [bacView addSubview:tipLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [coverView removeFromSuperview];
            coverView = nil;
            if (postActionName && postActionName.length > 0)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:postActionName object:postObject];
            }
        });
    }
    else
    {
        [CommonUtil showCommonToastWithStr:str forView:view hideAfterSeconds:timeInterval andAfterPostAction:postActionName postObject:postObject];
    }
}
+ (void)showCommonToastWithStrInCenter:(NSString *)str forView:(UIView *)view hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject
{
    //左右15，上下10，可多行显示，
    UIFont * tipFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    if (tipFont == nil)
    {
        tipFont = [UIFont systemFontOfSize:14];
    }
    CGSize strSize = [str boundingRectWithSize:CGSizeMake(view.frame.size.width - 2 * 15 - 2 * 15, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:tipFont} context:NULL].size;
    if (strSize.width < 30)
    {
        strSize.width = 30;
    }
    if (strSize.height < 20)
    {
        strSize.height = 20;
    }
    __block UIView * bacView = [[UIView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - (strSize.width + 15 * 2) / 2.f, (view.frame.size.height - strSize.height - 10 * 2)/2, strSize.width + 2 * 15, strSize.height + 10 * 2)];
    bacView.backgroundColor = [UIColor clearColor];
    bacView.layer.cornerRadius = 10.f;
    bacView.layer.masksToBounds = YES;
    [view addSubview:bacView];

    UIView * tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bacView.frame.size.width, bacView.frame.size.height)];
    tipView.backgroundColor = [UIColor colorWithWhite:51 / 255.f alpha:0.8];
    [bacView addSubview:tipView];

    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tipView.frame.size.width - 2 * 15, tipView.frame.size.height)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = str;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = tipFont;
    tipLabel.numberOfLines = 0;
    [bacView addSubview:tipLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [bacView removeFromSuperview];
        bacView = nil;
        if (postActionName && postActionName.length > 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:postActionName object:postObject];
        }
        view.userInteractionEnabled = YES;
    });
}
+ (void)showCommonToastWithStrInCenter:(NSString *)str hideAfterSeconds:(NSTimeInterval)timeInterval andAfterPostAction:(NSString *)postActionName postObject:(id)postObject
{
    //左右15，上下10，可多行显示，
    UIFont * tipFont = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    if (tipFont == nil)
    {
        tipFont = [UIFont systemFontOfSize:14];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    window.userInteractionEnabled = NO;
    [self showCommonToastWithStrInCenter:str forView:window hideAfterSeconds:timeInterval andAfterPostAction:postActionName postObject:postObject];
}
@end
