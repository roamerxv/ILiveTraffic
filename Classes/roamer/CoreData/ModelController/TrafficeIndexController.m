//
//  TrafficeIndexController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-3.
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

#import "TrafficeIndexController.h"

@implementation TrafficeIndexController

-(void) addOrUpdateRecord:(NSString *)lastValue{
    @try {
        [[NSUserDefaults standardUserDefaults] setObject:lastValue forKey:@"cityCongestValue"];
    }
    @catch (NSException *exception) {
        DLog(@"发生错误，error:%@",exception);
    }
    @finally {
        [[[NSUserDefaults alloc]init] synchronize];
    }

}

-(NSString *) lastValue{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"cityCongestValue"];
}

-(void) dealloc
{
    [super dealloc];
}

@end
