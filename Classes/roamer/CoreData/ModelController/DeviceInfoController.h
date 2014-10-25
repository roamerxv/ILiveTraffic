//
//  DeviceInfoController.h
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

#import <Foundation/Foundation.h>
#import "Configer.h"
#import "Tools.h"

@interface DeviceInfoController : NSObject
//保存或者获得设备号
-(void) saveDeviceID:(NSString * )deviceID;
//判断是否达到显示评价的窗口条件
-(bool) showCommentAllert;
@end
