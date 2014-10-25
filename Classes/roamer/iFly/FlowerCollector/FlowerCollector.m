//
//  FlowerCollector.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14-9-20.
//  Copyright (c) 2014年 Alcor. All rights reserved.
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

#import "FlowerCollector.h"

@implementation FlowerCollector

/**
 *  自定义事件统计
 *
 *  @param eventId 网站上注册的事件Id.
 */
+ (void) OnEvent:(NSString *)eventId{
    DLog(@"开始记录日志事件:[%@]",eventId);
    [IFlyFlowerCollector OnEvent:eventId];
    [IFlyFlowerCollector Flush];
    DLog(@"记录日志事件:[%@]完成！",eventId);
}


@end
