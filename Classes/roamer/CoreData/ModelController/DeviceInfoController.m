//
//  DeviceInfoController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-6.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//
//
//                     _ooOoo_
//                    o8888888o
//                    88" . "88
//                    (| -_- |)
//                    O\  =  /O
//                    _/`---'\____
//               .'  \\|     |//  `.
//              /  \\|||  :  |||//  \
//             /  _||||| -:- |||||-  \
//             |   | \\\  -  /// |   |
//             | \_|  ''\---/''  |   |
//             \  .-\__  `-`  ___/-. /
//           ___`. .'  /--.--\  `. . __
//        ."" '<  `.___\_<|>_/___.'  >'"".
//       | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//       \  \ `-.   \_ __\ /__ _/   .-` /  /
//  ======`-.____`-.___\_____/___.-`____.-'======
//                     `=---='
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//              佛祖保佑       永无BUG
//

#import "DeviceInfoController.h"

@implementation DeviceInfoController
-(void) saveDeviceID:(NSString * )deviceID{
    [[NSUserDefaults standardUserDefaults] setObject:deviceID forKey:@"deviceID"];
    //同时保存 运行记录数
    NSNumber * runned_times = [[NSUserDefaults standardUserDefaults] objectForKey:@"runnedTimes"];
    if ( runned_times == nil){
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"runnedTimes"];
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:runned_times.integerValue+1  forKey:@"runnedTimes"];
    }
    [[[NSUserDefaults alloc]init] synchronize];
    DLog(@"保存的设备uuid是：%@",deviceID);
}

-(bool) showCommentAllert
{
        NSInteger  runned_times = [[[NSUserDefaults standardUserDefaults] objectForKey:@"runnedTimes"] integerValue];
        //  开始判断运行次数是否达到显示投票提示的要求
        DLog(@"当前已经运行了%d次",runned_times);
        if ( runned_times != 0 &&  (runned_times % SHOW_COMMENT_INTERVAL_VALUE ) == 0)
        {
            return true;
        }else{
            return false;
        }
}

@end
