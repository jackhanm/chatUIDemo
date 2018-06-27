
//
//  JKProgressHud.m
//  Chat
//
//  Created by 余浩 on 2018/6/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "JKProgressHud.h"


@interface JKProgressHud()
{
    NSTimer *_myTimer;
    CGFloat _angle;
}

@property (nonatomic, strong) UIImageView *edgeImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, weak) UIWindow *overlayWindow;
@end
@implementation JKProgressHud

+ (instancetype)shareView
{
   
    static JKProgressHud *shareView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareView= [[JKProgressHud alloc]initWithFrame:[UIScreen mainScreen].bounds];
        shareView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    });
    return shareView;
}

+ (void)show {
    [[JKProgressHud shareView] show];
}

+ (void)changeSubTitle:(NSString *)str
{
    [JKProgressHud shareView].subTitleLabel.text = str;
}

+ (void)dismissWithSuccess:(NSString *)str
{
    [[JKProgressHud shareView] dismiss:str];
}

+ (void)dismissWithError:(NSString *)str
{
    [[JKProgressHud shareView] dismiss:str];
}

-(void)show
{
    [self removeFromSuperview];
    [self.overlayWindow addSubview:self];
    self.titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.titleLabel.text = @"time limit";
    self.subTitleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.subTitleLabel.text = @"slide to cancel";
    self.centerLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.centerLabel.text = @"60";
    self.edgeImageView.center = self.centerLabel.center;
    [self addSubview:self.edgeImageView];
    [self addSubview:self.centerLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.titleLabel];
    if (_myTimer) {
        [_myTimer invalidate];
        _myTimer = nil;
        
    }
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startAnimation) userInfo:nil repeats:YES];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        self.alpha =1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)free
{
    NSArray<UIView *> *subviews = @[_titleLabel, _centerLabel, _edgeImageView, _subTitleLabel];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [subviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = nil;
    }];
    [self removeFromSuperview];
}

- (void)dismiss:(NSString *)state
{
    [_myTimer invalidate];
    _myTimer = nil;
    self.subTitleLabel.text = nil;
    self.titleLabel.text = nil;
    _centerLabel.text = state;
    _centerLabel.textColor = [UIColor whiteColor];
    
    CGFloat timeLonger;
    if ([state isEqualToString:@"TooShort"]) {
        timeLonger = 1;
    } else {
        timeLonger = 0.6;
    }
    [UIView animateWithDuration:timeLonger animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self free];
    }];
}
- (void)startAnimation
{
    _angle -=3;
    self.edgeImageView.transform =  CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    float second  = [_centerLabel.text floatValue];
    self.centerLabel.textColor = second <=10.0f?[UIColor redColor]:[UIColor yellowColor];
    self.centerLabel.text = [NSString stringWithFormat:@"%.1f",second-0.1];
    
    
}
-(UIWindow *)overlayWindow
{
    return [UIApplication sharedApplication].delegate.window;
    
}
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}
- (UILabel *)centerLabel
{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
        _centerLabel.backgroundColor = [UIColor clearColor];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.font = [UIFont systemFontOfSize:30];
        _centerLabel.textColor = [UIColor yellowColor];
    }
    return _centerLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        _subTitleLabel.textColor = [UIColor whiteColor];
    }
    return _subTitleLabel;
}

- (UIImageView *)edgeImageView
{
    if (!_edgeImageView) {
        _edgeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chat_record_circle.png"]];
        _edgeImageView.frame = CGRectMake(0, 0, 154, 154);
    }
    return _edgeImageView;
}












/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
