//
//  JKMessageCell.h
//  Chat
//
//  Created by 余浩 on 2018/6/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JKMessageCell;


@protocol JKMessageCelldelegate<NSObject>
@optional
- (void)chatCell:(JKMessageCell *)cell headImageDidClick:(NSString *)userId;
@end

@interface JKMessageCell : UITableViewCell
@property(nonatomic, weak) id<JKMessageCelldelegate>delegate;
@end
