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
#import "Lottie.h"
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 196 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度
//@interface OIPointHUD : UIView
//@property(nonatomic,strong)CALayer *animationLayer;
//@end
//@implementation OIPointHUD
//
//-(id)init
//{
//    self = [super init];
//    if(self)
//    {
//        //一个圆的大小8 间隔6
//        self.backgroundColor = [UIColor clearColor];
//        self.bounds = CGRectMake(0, 0, 12+24, 16);
//        _animationLayer = [CALayer layer];
//        [self.layer addSublayer:_animationLayer];
//        [self addaAnLayer];
//    }
//    return self;
//}
//-(void)addaAnLayer
//{
//    CGFloat duration = 2;
//    NSArray *beginTimes = @[@0.3f, @0.6f, @0.9f];
//    CGFloat circleSpacing = 6;
//    CGFloat circleSize = 8;
//    CGFloat x = 0;
//    CGFloat y = 0;
//    CGFloat deltaY = 8;
//    CAMediaTimingFunction *timingFunciton = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//
//    // Animation
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
//    animation.removedOnCompletion = NO;
//
//    animation.duration = duration;
//    animation.keyTimes = @[@0.0f, @0.3,@0.6f, @1.0f];
//    animation.values = @[@0.0f, @(deltaY), @0.0f,@0.0f];
//    animation.timingFunctions = @[timingFunciton, timingFunciton, timingFunciton];
//    animation.repeatCount = HUGE_VALF;
//
//    // Draw circles
//    for (int i = 0; i < 3; i++) {
//        CAShapeLayer *circle = [CAShapeLayer layer];
//        UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, circleSize, circleSize) cornerRadius:circleSize / 2];
//
//        animation.beginTime = [beginTimes[i] floatValue];
//        circle.fillColor = [UIColor whiteColor].CGColor;
//        circle.path = circlePath.CGPath;
//        [circle addAnimation:animation forKey:@"animation"];
//        circle.frame = CGRectMake(x + circleSize * i + circleSpacing * i, y, circleSize, circleSize);
//        [self.animationLayer addSublayer:circle];
//    }
//    _animationLayer.speed = 0.0f;
//}
//@end

@interface OIPointView2 : UIView
@property(nonatomic,strong)UIView *point1;
@property(nonatomic,strong)UIView *point2;
@property(nonatomic,strong)UIView *point3;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)void(^showDelBlock)(void);
-(void)startAnimation:(NSInteger)type;//0 基础动画 1 删除做打钩动画
-(void)resetPoint;
@end

@implementation OIPointView2

-(id)init
{
    self = [super init];
    if(self)
    {
        //一个圆的大小8 间隔6
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0, 0, 12+24, 16);

        _point1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        [_point1.layer setCornerRadius:4];
        [_point1 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_point1];

        _point2 = [[UIView alloc]initWithFrame:CGRectMake(14, 0, 8, 8)];
        [_point2.layer setCornerRadius:4];
        [_point2 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_point2];

        _point3 = [[UIView alloc]initWithFrame:CGRectMake(28, 0, 8, 8)];
        [_point3.layer setCornerRadius:4];
        [_point3 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_point3];
    }
    return self;
}
-(void)resetPoint
{
    [_point1 setFrame:CGRectMake(0, 0, 8, 8)];
    [_point2 setFrame:CGRectMake(14, 0, 8, 8)];
    [_point3 setFrame:CGRectMake(28, 0, 8, 8)];
    [_point1 setAlpha:1];
    [_point2 setAlpha:1];
    [_point3 setAlpha:1];
}
-(void)startAnimation:(NSInteger)type
{
    self.type = type;
    [self doAnimation];
}
-(void)doAnimation
{
    [self performSelector:@selector(viewAnimation:) withObject:_point1 afterDelay:0];
    [self performSelector:@selector(viewAnimation:) withObject:_point2 afterDelay:0.3];
    [self performSelector:@selector(viewAnimation:) withObject:_point3 afterDelay:0.6];
    [self performSelector:@selector(checkAnimation) withObject:nil afterDelay:2.6];
}
-(void)viewAnimation:(UIView*)tmpPoint
{
    [UIView animateWithDuration:0.6 animations:^{
        [tmpPoint setCenter:CGPointMake(tmpPoint.center.x, 12)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            [tmpPoint setCenter:CGPointMake(tmpPoint.center.x, 4)];
        } completion:^(BOOL finished) {

        }];
    }];
}
-(void)checkAnimation
{
    if (self.type == 0) {
        [self doAnimation];
    }
    else if(self.type == 1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.point1 setCenter:self.point2.center];
            [self.point3 setCenter:self.point2.center];
        } completion:^(BOOL finished) {
            [self.point1 setAlpha:0];
            [self.point2 setAlpha:0];
            [self.point3 setAlpha:0];
            if (self.showDelBlock) {
                self.showDelBlock();
            }
        }];
    }
}
@end

@interface HUDProgress : UIView
@property(nonatomic,strong)CAShapeLayer *trackLayer;
@property(nonatomic,strong)CAShapeLayer *progressLayer;
@end

@implementation HUDProgress

-(id)init
{
    self = [super init];
    if (self) {
        self.bounds = CGRectMake(0, 0, 88, 88);
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:(self.bounds.size.width/2-PROGRESS_LINE_WIDTH/2) startAngle:degreesToRadians(126) endAngle:degreesToRadians(54) clockwise:NO];

        _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = [[UIColor clearColor] CGColor];
        _trackLayer.strokeColor = [[UIColor whiteColor] CGColor];//指定path的渲染颜色
        _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
        _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
        _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
        _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染

        _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
        _progressLayer.frame = self.bounds;
        [self.layer addSublayer:_progressLayer];
        _progressLayer.fillColor = [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor = [[UIColor whiteColor] CGColor];//指定path的渲染颜色
        _progressLayer.opacity = 1; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
        _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
        _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
        _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0.0;
    }
    return self;
}
-(void)resetStatus
{
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0.0;
}
@end

@interface MergeAnimation : UIView
@property(nonatomic,strong)UIImageView *hudPerson;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL stop;
@property(nonatomic,copy)void(^MergeAnimationBlock)(void);
@end

@implementation MergeAnimation

-(id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0, 0, 120, 120);

        _hudPerson = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        [_hudPerson setImage:[UIImage imageNamed:@"hud_person.png"]];
        [self addSubview:_hudPerson];

        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 78, self.bounds.size.width, 14)];
        [_contentLabel setBackgroundColor:[UIColor clearColor]];
        [_contentLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_contentLabel];
        [_contentLabel setFont:kFont(@"PingFangSC-Medium", 12)];

        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 21, self.bounds.size.width, 14)];
        [_numberLabel setTextColor:[UIColor whiteColor]];
        [_numberLabel setBackgroundColor:[UIColor clearColor]];
        [_numberLabel setTextAlignment:NSTextAlignmentCenter];
        [_numberLabel setFont:kFont(@"PingFangSC-Medium", 14)];
        [self addSubview:_numberLabel];
        [_contentLabel setAlpha:0];
        [_numberLabel setAlpha:0];

    }
    return self;
}
-(void)startAnimation
{
    _index = 0;
    _stop = NO;
    [self doAnimation];

}
-(void)doAnimation
{
    NSArray *titlArr = @[@"+1",@"+2",@"+3"];
    NSArray *contentArr = @[@"DRESS",@"TELE",@"NAME"];

    [_numberLabel setFrame:CGRectMake(0, 21, self.bounds.size.width, 14)];
    [_numberLabel setText:titlArr[_index]];
    [_contentLabel setText:contentArr[_index]];
    [_numberLabel setAlpha:0];
    [_contentLabel setAlpha:1];
    [UIView animateWithDuration:0.3 animations:^{
        [self.numberLabel setFrame:CGRectMake(0, 19, self.bounds.size.width, 14)];
        [self.numberLabel setAlpha:1];
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.numberLabel setFrame:CGRectMake(0, 17, self.bounds.size.width, 14)];
            [self.numberLabel setAlpha:0];
        } completion:^(BOOL finished) {
            self.index ++;
            [self.numberLabel setFrame:CGRectMake(0, 21, self.bounds.size.width, 14)];
            if (self.index%3==0)
            {
                self.index = 0;
                [self.contentLabel setAlpha:0];
                [self performSelector:@selector(checkAnimation) withObject:nil afterDelay:0.5];
            }
            else
            {
                [self doAnimation];
            }
        }];
    }];
}
-(void)checkAnimation
{
    if (self.stop)
    {
        if (self.MergeAnimationBlock) {
            self.MergeAnimationBlock();
        }
    }
    else
    {
        [self doAnimation];
    }
}
@end

@interface OIHUD ()
//@property(nonatomic,strong)OIPointHUD *pointView;
@property(nonatomic,strong)UIControl *backgroundControl;
@property(nonatomic,strong)OIPointView2 *pointView2;
@property(nonatomic,strong)LOTAnimationView *lottieImage;
@property(nonatomic,strong)LOTAnimationView *mergeImage;
@property(nonatomic,strong)HUDProgress *progressView;
@property(nonatomic,strong)MergeAnimation *mergeView;
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
    [self removeFromSuperview];
    [self.backgroundControl removeFromSuperview];
}
-(UIControl*)backgroundControl
{
    if(!_backgroundControl)
    {
        _backgroundControl = [[UIControl alloc]init];
        [_backgroundControl setBackgroundColor:[UIColor clearColor]];
        [_backgroundControl addTarget:self action:@selector(changeMergeStauts) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundControl;
}
-(void)checkStatus:(NSInteger)type;
{
    _pointView2.type = type;
}
-(void)showInView:(UIView*)view type:(NSInteger)type
{
    [view addSubview:self.backgroundControl];
    self.backgroundControl.frame = view.bounds;
    [view addSubview:self];
    [self setCenter:view.center];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self addSubview:self.pointView2];
    [_pointView2 resetPoint];
    if (type == 0)
    {
        //请稍候
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 66)];
        [label setText:@"请稍候"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:kFont(@"PingFangSC-Medium", 16)];
        [self addSubview:label];

        [_pointView2 startAnimation:0];
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
-(OIPointView2*)pointView2
{
    __weak typeof(self) weakSelf = self;
    if (!_pointView2) {
        _pointView2 = [[OIPointView2 alloc]init];
        [_pointView2 setFrame:CGRectMake(42, 86, _pointView2.bounds.size.width, _pointView2.bounds.size.height)];
        _pointView2.showDelBlock = ^{
            [weakSelf addLottie];
        };
    }
    return _pointView2;
}
-(void)showInView:(UIView *)view deleteCnt:(NSInteger)deleteCnt
{
    [view addSubview:self.backgroundControl];
    self.backgroundControl.frame = view.bounds;
    [view addSubview:self];
    [self setCenter:view.center];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self addSubview:self.pointView2];

    [_pointView2 resetPoint];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, self.bounds.size.width, 26)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:@"正在删除"];
    [titleLabel setFont:kFont(@"PingFangSC-Regular", 16)];
    [titleLabel setTag:1001];
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
    [_pointView2 startAnimation:0];
}
-(void)setDeleteProgress:(NSInteger)progress deleteCnt:(NSInteger)deleteCnt
{
    UILabel *numberLabel = (UILabel*)[self viewWithTag:1000];
    NSLog(@"%@",[NSString stringWithFormat:@"%ld/%ld",progress,deleteCnt]);
    [numberLabel setText:[NSString stringWithFormat:@"%ld/%ld",progress,deleteCnt]];
}
-(void)addLottie
{
    UILabel *numberLabel = (UILabel*)[self viewWithTag:1000];
    UILabel *titleLabel = (UILabel*)[self viewWithTag:1001];
    [numberLabel setAlpha:0];
    [titleLabel setAlpha:0];
    [self doFinish];
}
-(void)showInView:(UIView *)view mergeCnt:(NSInteger)mergeCnt
{
    [view addSubview:self.backgroundControl];
    self.backgroundControl.frame = view.bounds;
    [view addSubview:self];
    [self setCenter:view.center];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    __weak typeof(self) weakSelf = self;

    _mergeView = [[MergeAnimation alloc]init];
    [_mergeView setFrame:CGRectMake(0, 0, 120, 120)];
    _mergeView.MergeAnimationBlock = ^{
        [weakSelf addMergeFinishAnimation];
    };
    [self addSubview:_mergeView];

    _progressView = [[HUDProgress alloc]init];
    _progressView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:_progressView];

    [_mergeView startAnimation];
}
-(void)changeMergeStauts
{
    _mergeView.stop = YES;
}
-(void)addMergeFinishAnimation
{
    [_mergeView setAlpha:0];
    [_progressView setAlpha:0];
    __weak typeof(self) weakSelf = self;

    if (_mergeImage)
    {
        if (_mergeImage.superview != nil) {
            [_mergeImage removeFromSuperview];
        }
        _mergeImage = nil;
    }
    _mergeImage = [LOTAnimationView animationNamed:@"merge.json"];
    _mergeImage.frame = CGRectMake(0, 0, 120, 120);
    [self addSubview:_mergeImage];
    [_mergeImage playWithCompletion:^(BOOL animationFinished) {
        [weakSelf doFinish];
    }];
}
-(void)doFinish
{
    [_mergeImage removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    if (_lottieImage)
    {
        if (_lottieImage.superview != nil) {
            [_lottieImage removeFromSuperview];
        }
        _lottieImage = nil;
    }
    _lottieImage = [LOTAnimationView animationNamed:@"gou.json"];
    _lottieImage.frame = CGRectMake(0, 0, 120, 120);
    [self addSubview:_lottieImage];
    [_lottieImage playWithCompletion:^(BOOL animationFinished) {
        [weakSelf hideView];
    }];
}
@end
