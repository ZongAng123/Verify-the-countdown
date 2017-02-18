//
//  CountDownServer.h
//  验证倒计时
//
//  Created by 纵昂 on 2017/2/17.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountDownServer : NSObject
//开始倒计时
+ (void) startCountDown:(int)total identifier:(NSString *)identifier;


//表示倒计时是否正在进行
+ (BOOL) isCountDowning:(NSString *)identifier;

@end
