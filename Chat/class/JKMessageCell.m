


//
//  JKMessageCell.m
//  Chat
//
//  Created by 余浩 on 2018/6/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import "JKMessageCell.h"
#import "JKMessageContentButton.h"
@interface JKMessageCell()
{
    NSString *_voiceURL;
    NSData *_songData;
    
   
    
    UIView *_headImageBackView;
    BOOL _contentVoiceIsPlaying;
}
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) JKMessageContentButton *btnContent;

@end

@implementation JKMessageCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 1.创建时间
        // 1、创建时间
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor grayColor];
        self.dateLabel.font = [UIFont systemFontOfSize:11] ;
        [self.contentView addSubview:self.dateLabel];
        
        // 2、创建头像
        _headImageBackView = [[UIView alloc]init];
        _headImageBackView.layer.cornerRadius = 22;
        _headImageBackView.layer.masksToBounds = YES;
        _headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:_headImageBackView];
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.layer.cornerRadius = 20;
        self.headImageButton.layer.masksToBounds = YES;
        [self.headImageButton addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_headImageBackView addSubview:self.headImageButton];
        
        
        // 3、创建头像下标
        self.namelabel = [[UILabel alloc] init];
        self.namelabel.textColor = [UIColor grayColor];
        self.namelabel.textAlignment = NSTextAlignmentCenter;
        self.namelabel.font = [UIFont systemFontOfSize:11] ;
        self.namelabel.numberOfLines = 0;
        [self.contentView addSubview:self.namelabel];
        
        // 4、创建内容
        self.btnContent = [JKMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
    }
    return self;
}


//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(chatCell:headImageDidClick:)])  {
        [self.delegate chatCell:self headImageDidClick:self.messageFrame.message.strId];
    }
}




















- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
