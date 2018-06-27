//
//  JKProgressHud.h
//  Chat
//
//  Created by 余浩 on 2018/6/27.
//  Copyright © 2018年 jack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKProgressHud : UIView
+ (void)show;

+ (void)dismissWithSuccess:(NSString *)str;

+ (void)dismissWithError:(NSString *)str;

+ (void)changeSubTitle:(NSString *)str;
@end
