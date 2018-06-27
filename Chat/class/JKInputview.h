//
//  JKInputview.h
//  Chat
//
//  Created by 余浩 on 2018/6/26.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class JKInputview;
@protocol JKInputviewDelegate <NSObject>

//text
-(void)JKInputview:(JKInputview *)funview sendMessage:(NSString *)message;

//image
-(void)JKInputview:(JKInputview *)funview sendPicture:(UIImage *)image;

//audio
-(void)JKInputview:(JKInputview *)funview sendVoice:(NSData *)voice time:(NSInteger)second;



@end



@interface JKInputview : UIView<UITextViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,AVAudioRecorderDelegate>
@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *textViewInput;
@property (nonatomic, assign) BOOL isAbleToSendTextMessage;
@property (nonatomic, assign) id<JKInputviewDelegate>delegate;


@end
