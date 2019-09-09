//
//  ABAuthorizeView.m
//  txlgj
//
//  Created by wuzhuanlin on 2019/9/6.
//  Copyright © 2019 com.octInn. All rights reserved.
//

#import "ABAuthorizeView.h"
#import "Common.h"
#import "CommonUtil.h"
@interface ABAuthorizeView ()
@property(nonatomic,strong)UIControl *backgroundControl;
@end

@implementation ABAuthorizeView

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
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:OIRGBA(234, 238, 254, 1)];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:10];
    }
    return self;
}
-(void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window){
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [self showInView:window];
}
-(void)showInView:(UIView *)view
{
    [self.backgroundControl setFrame:view.bounds];
    [view addSubview:self.backgroundControl];
    [view addSubview:self];
    CGFloat viewWidth = view.bounds.size.width-25*2 < 325?(view.bounds.size.width-25*2):325;
    self.bounds = CGRectMake(0, 0, viewWidth, 0);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, viewWidth, 28)];
    [titleLabel setText:@"需要通讯录权限"];
    [titleLabel setFont:kFont(@"PingFangSC-Semibold", 24)];
    [titleLabel setTextColor:OIRGBA(88, 98, 143, 1)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];

    UILabel *contentLabel = [[UILabel alloc]init];
    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [contentLabel setNumberOfLines:0];
    [contentLabel setFont:kFont(@"PingFangSC-Light", 16)];
    [contentLabel setTextColor:OIRGBA(88, 98, 143, 1)];
    contentLabel.bounds = CGRectMake(0, 0, viewWidth-35*2, 0);
    [contentLabel setText:@"管理、美化通讯录，还是需要通讯录权限的。请批准，我们不会滥用。不放心的话，可以先断网。"];
    [contentLabel sizeToFit];
    [contentLabel setFrame:CGRectMake(35, CGRectGetMaxY(titleLabel.frame)+20, viewWidth-35*2, contentLabel.bounds.size.height)];
    [self addSubview:contentLabel];

    CGFloat btnspace = floor((viewWidth-2*100)/3);
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnspace, CGRectGetMaxY(contentLabel.frame)+30, 100, 40)];
    [cancelBtn setTitle:@"退出" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", 16)];
    [cancelBtn addTarget:self action:@selector(onCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    [cancelBtn setBackgroundColor:OIRGBA(70, 95, 253, 1)];
    [cancelBtn.layer setCornerRadius:10];
    [cancelBtn.layer setMasksToBounds:YES];

    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnspace*2+100, CGRectGetMaxY(contentLabel.frame)+30, 100, 40)];
    [agreeBtn setTitle:@"准了" forState:UIControlStateNormal];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [agreeBtn.titleLabel setFont:kFont(@"PingFangSC-Medium", 16)];
    [agreeBtn addTarget:self action:@selector(onAgreeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:agreeBtn];
    [agreeBtn setBackgroundColor:OIRGBA(254, 149, 47, 1)];
    [agreeBtn.layer setCornerRadius:10];
    [agreeBtn.layer setMasksToBounds:YES];

    self.bounds = CGRectMake(0, 0, viewWidth, CGRectGetMaxY(agreeBtn.frame)+18);
    [self setFrame:CGRectMake((view.bounds.size.width-viewWidth)/2, (view.bounds.size.height-self.bounds.size.height)/2, viewWidth, self.bounds.size.height)];
}
-(UIControl*)backgroundControl
{
    if (_backgroundControl == nil)
    {
        _backgroundControl = [[UIControl alloc]init];
        [_backgroundControl setBackgroundColor:OIRGBA(29, 32, 48, 0.7)];
        [_backgroundControl setUserInteractionEnabled:YES];
    }
    return _backgroundControl;
}
-(void)onCancelClick
{
    [self.backgroundControl removeFromSuperview];
    [self removeFromSuperview];
}
-(void)onAgreeClick
{
    [self onCancelClick];
    if (self.agreeBlock) {
        self.agreeBlock();
    }
}
@end
