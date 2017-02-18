//
//  CountDownServer.m
//  验证倒计时
//
//  Created by 纵昂 on 2017/2/17.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "CountDownServer.h"

//保存正在执行倒计时的标识
NSMutableArray *data;

@implementation CountDownServer
//开始计时
+ (void)startCountDown:(int)total identifier:(NSString *)identifier
{
    NSDate *timerStartDate = [NSDate date];
    
    //block块
    __block int secondsCountDown = total;
    
    if (data == nil) {
        data = [NSMutableArray array];
    }
    [data addObject:identifier];
    
    //多线程 全局并发的队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSTimeInterval aTimer = [[NSDate date]timeIntervalSinceDate:timerStartDate];
        if (aTimer < total) {
            secondsCountDown = total -aTimer;
        }else{
            secondsCountDown = 0;
        }
        
        //通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CountDownUpdate" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:identifier, @"CountDownIdentifier", [NSNumber numberWithInt:secondsCountDown], @"SecondsCountDown", nil]];
        
        if (secondsCountDown <= 0) {
            dispatch_source_cancel(_timer);
            //   dispatch_release(_timer);
            
            [data removeObject:identifier];
        }
    });
    dispatch_resume(_timer);
    
}


+ (BOOL)isCountDowning:(NSString *)identifier
{
    return [data containsObject:identifier];
}


@end
