//
//  JKMessageContentButton.h
//  Chat
//
//  Created by 余浩 on 2018/6/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKMessageContentButton : UIButton

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *second;
@property (nonatomic, strong) UIImageView *voice;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL isMyMessage;

- (void)benginLoadVoice;

- (void)didLoadVoice;

-(void)stopPlay;


@end
