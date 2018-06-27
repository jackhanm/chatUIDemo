//
//  JKInputview.m
//  Chat
//
//  Created by 余浩 on 2018/6/26.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "JKInputview.h"
#import <AVFoundation/AVFoundation.h>
#import "JKProgressHud.h"
@interface JKInputview()
{
    BOOL isbeginVoiceRecord;
    NSInteger playTime;
    NSString *_docmentFilePath;
}

@property(nonatomic, strong) NSTimer *playTimer;
@property(nonatomic, strong) UILabel *placeHold;
@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, weak, readonly) UIViewController *superVC;

@end


@implementation JKInputview


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.isAbleToSendTextMessage = NO;
        // 发送消息
        self.btnSendMessage =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture.png"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(btnSendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音，文字）
        self.btnChangeVoiceState =[UIButton buttonWithType:UIButtonTypeCustom];
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record.png"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];
        
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setImage:[UIImage imageNamed:@"chat_message_back.png"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord  setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"按住说话" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"松手发送" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.textViewInput =[[UITextView alloc]init];
        self.textViewInput.layer.cornerRadius = 4;
        self.textViewInput.layer.masksToBounds = YES;
        self.textViewInput.delegate =self;
        self.textViewInput.layer.borderWidth =1;
        self.textViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] CGColor];
        [self addSubview:self.textViewInput];
        
        //输入框的提示语
        _placeHold =[[UILabel alloc]init];
        _placeHold.text = @"消息输入";
        _placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.textViewInput addSubview:_placeHold];
        
        //分割线
        self.layer.borderWidth =1;
        self.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.3] CGColor];
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
-(UIViewController *)superVC
{
   return  [self uu_findNextResonderInClass:[UIViewController class]];
}
- (nullable __kindof UIResponder *)uu_findNextResonderInClass:(nonnull Class)responderClass
{
    UIResponder *next = self;
    do {
        next = [next nextResponder];
        if ([next isKindOfClass:responderClass]) {
            break;
        }
        // next 不为空 且 不是达到最底层的 appdelegate
    } while (next!=nil && ![next conformsToProtocol:@protocol(UIApplicationDelegate)]);
    
    return next;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.btnVoiceRecord.frame = CGRectMake(70, 5, self.frame.size.width-70*2, 30);
    self.btnSendMessage.frame = CGRectMake(self.frame.size.width-40, 5, 30, 30);
    self.textViewInput.frame = CGRectMake(45, 5, self.frame.size.width-2*45, 30);
    _placeHold.frame =CGRectMake(20, 0, 200, 30);
    self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
    
}
-(void)btnSendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        NSString *resultStr =[self.textViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate JKInputview:self sendMessage:resultStr];
    }else{
        [self.textViewInput resignFirstResponder];
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
        [actionSheet showInView:self.window];
    }
}
//改变输入和录音状态
-(void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.textViewInput.hidden = !self.textViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message.png"] forState:UIControlStateNormal];
        [self.textViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record.png"] forState:UIControlStateNormal];
        [self.textViewInput becomeFirstResponder];
    }
}

#pragma mark 录音touch事件
-(void)beginRecordVoice:(UIButton *)button
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&err];
    [audioSession setActive:YES error:&err];
    if (err) {
        NSLog(@"audioSession: %@ %zd %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    NSDictionary *recordSetting = @{AVEncoderAudioQualityKey : [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderBitRateKey : [NSNumber numberWithInt:16],
                                    AVFormatIDKey : [NSNumber numberWithInt:kAudioFormatMPEG4AAC],
                                    AVNumberOfChannelsKey : @2,
                                    AVLinearPCMBitDepthKey : @8};
    NSError *error =nil;
    NSString *docments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    _docmentFilePath = [NSString stringWithFormat:@"%@/%@",docments,@"123"];
    
    NSURL *pathURL = [NSURL fileURLWithPath:_docmentFilePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:pathURL settings:recordSetting error:&error];
    if (error || !_recorder) {
        NSLog(@"recorder: %@ %zd %@", [error domain], [error code], [[error userInfo] description]);
        return;
    }
    _recorder.delegate = self;
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    
    if (!audioSession.inputIsAvailable) {
        
        return;
    }
    
    
    [_recorder record];
    playTime = 0;
    _playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [JKProgressHud show];
    
}
-(void)countVoiceTime{
    playTime++;
    if (playTime >=60) {
        [self endRecordVoice:nil];
    }
}
-(void)endRecordVoice:(UIButton *)sender
{
    [_recorder stop];
    [_playTimer invalidate];
    _playTimer = nil;
}
-(void)cancelRecordVoice:(UIButton *)button
{
    if (_playTimer) {
        [_recorder stop];
        [_recorder deleteRecording];
        [_playTimer invalidate];
        _playTimer = nil;
    }
    [JKProgressHud dismissWithError:@"cancel"];
}
-(void)RemindDragExit:(UIButton *)button
{
    [JKProgressHud changeSubTitle:@"release to cancel"];
    
}
-(void)RemindDragEnter:(UIButton *)button
{
    [JKProgressHud changeSubTitle:@"slide to cancel"];
}
#pragma mark TextViewdelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    _placeHold.hidden = textView.text.length>0;
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    [self.btnSendMessage setTitle:isPhoto?@"":@"send" forState:UIControlStateNormal];
    CGRect sendFrame = self.btnSendMessage.frame;
    sendFrame.size.width = isPhoto ? 30:35;
    self.btnSendMessage.frame = sendFrame;
    UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture.png":@"chat_send_message.png"];
    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    _placeHold.hidden = self.textViewInput.text.length > 0;
}

#pragma mark Picture
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCaremal];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
    
}
-(void)addCaremal
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)openPicLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate JKInputview:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark AvaudioRecorderdelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSURL *url = [NSURL fileURLWithPath:_docmentFilePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options:0 error:&err];
    if (audioData) {
        [self endConvertWithData:audioData];
    }
    
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error
{
    
}
-(void)endConvertWithData:(NSData *)voiceData
{
    [self.delegate JKInputview:self sendVoice:voiceData time:playTime+1];
    [JKProgressHud dismissWithSuccess:@"Success"];
    //缓冲消失时间（最好有block回调消失完成）
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled= YES;
    });
    
}
- (void)failRecord
{
    [JKProgressHud dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
