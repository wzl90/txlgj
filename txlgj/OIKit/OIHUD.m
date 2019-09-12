//
//  OIHUD.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/11.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "OIHUD.h"
#import "Common.h"
#import "CommonUtil.h"
@interface OIPointHUD : UIView
@property(nonatomic,strong)CALayer *animationLayer;
@end
@implementation OIPointHUD

-(id)init
{
    self = [super init];
    if(self)
    {
        //一个圆的大小8 间隔6
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0, 0, 12+24, 16);
        _animationLayer = [CALayer layer];
        [self.layer addSublayer:_animationLayer];
        [self addaAnLayer];
    }
    return self;
}
-(void)addaAnLayer
{
    CGFloat duration = 2;
    NSArray *beginTimes = @[@0.3f, @0.6f, @0.9f];
    CGFloat circleSpacing = 6;
    CGFloat circleSize = 8;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat deltaY = 8;
    CAMediaTimingFunction *timingFunciton = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    // Animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.removedOnCompletion = NO;

    animation.duration = duration;
    animation.keyTimes = @[@0.0f, @0.3,@0.6f, @1.0f];
    animation.values = @[@0.0f, @(deltaY), @0.0f,@0.0f];
    animation.timingFunctions = @[timingFunciton, timingFunciton, timingFunciton];
    animation.repeatCount = HUGE_VALF;

    // Draw circles
    for (int i = 0; i < 3; i++) {
        CAShapeLayer *circle = [CAShapeLayer layer];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circleSize, circleSize) cornerRadius:circleSize / 2];

        animation.beginTime = [beginTimes[i] floatValue];
        circle.fillColor = [UIColor whiteColor].CGColor;
        circle.path = circlePath.CGPath;
        [circle addAnimation:animation forKey:@"animation"];
        circle.frame = CGRectMake(x + circleSize * i + circleSpacing * i, y, circleSize, circleSize);
        [self.animationLayer addSublayer:circle];
    }
    _animationLayer.speed = 0.0f;
}
@end

@interface OIHUD ()
@property(nonatomic,strong)OIPointHUD *pointView;
@property(nonatomic,strong)UIControl *backgroundControl;
@end

@implementation OIHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = OIRGBA(70, 95, 253, 0.8);
        [self.layer setMasksToBounds:YES];
        self.bounds = CGRectMake(0, 0, 120, 120);
        [self.layer setCornerRadius:60];
    }
    return self;
}
-(void)hideView
{
    _pointView.animationLayer.speed = 0;
    [self removeFromSuperview];
    [self.backgroundControl removeFromSuperview];
}
-(UIControl*)backgroundControl
{
    if(!_backgroundControl)
    {
        _backgroundControl = [[UIControl alloc]init];
        [_backgroundControl setBackgroundColor:[UIColor clearColor]];
//        [_backgroundControl addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundControl;
}
-(void)showInView:(UIView*)view type:(NSInteger)type
{
    [view addSubview:self.backgroundControl];
    self.backgroundControl.frame = view.bounds;
    [view addSubview:self];
    [self setCenter:view.center];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_pointView) {
        _pointView = [[OIPointHUD alloc]init];
        [_pointView setFrame:CGRectMake(42, 86, _pointView.bounds.size.width, _pointView.bounds.size.height)];
    }
    if (_pointView.superview == nil) {
        [self addSubview:_pointView];
    }
    if (type == 0)
    {
        //请稍候
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 66)];
        [label setText:@"请稍候"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:kFont(@"PingFangSC-Medium", 16)];
        [self addSubview:label];

        _pointView.animationLayer.speed = 1;
    }
    else if(type == 1)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 66)];
        [label setText:@"导出功能\n即将上线"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:kFont(@"PingFangSC-Medium", 16)];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByCharWrapping];
        [self addSubview:label];
        [self performSelector:@selector(hideView) withObject:nil afterDelay:1];
    }
}
-(void)showInView:(UIView *)view deleteCnt:(NSInteger)deleteCnt
{
    [view addSubview:self.backgroundControl];
    self.backgroundControl.frame = view.bounds;
    [view addSubview:self];
    [self setCenter:view.center];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (!_pointView) {
        _pointView = [[OIPointHUD alloc]init];
        [_pointView setFrame:CGRectMake(42, 86, _pointView.bounds.size.width, _pointView.bounds.size.height)];
    }
    if (_pointView.superview == nil) {
        [self addSubview:_pointView];
    }
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, self.bounds.size.width, 26)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"正在删除"];
    [titleLabel setFont:kFont(@"PingFangSC-Regular", 16)];
    [self addSubview:titleLabel];

    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 51, self.bounds.size.width-5*2, 24)];
    [numberLabel setTextAlignment:NSTextAlignmentCenter];
    [numberLabel setFont:kFont(@"PingFangSC-Medium", 22)];
    [numberLabel setTextColor:[UIColor whiteColor]];
    [numberLabel setAdjustsFontSizeToFitWidth:YES];
    [numberLabel setMinimumScaleFactor:0.5];
    [self addSubview:numberLabel];
    [numberLabel setText:[NSString stringWithFormat:@"0/%ld",deleteCnt]];
    [numberLabel setTag:1000];
    _pointView.animationLayer.speed = 1;
}
-(void)setDeleteProgress:(NSInteger)progress deleteCnt:(NSInteger)deleteCnt
{
    UILabel *numberLabel = (UILabel*)[self viewWithTag:1000];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld/%ld",progress,deleteCnt]);
    [numberLabel setText:[NSString stringWithFormat:@"%ld/%ld",progress,deleteCnt]];
}
@end