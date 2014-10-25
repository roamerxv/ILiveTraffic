//
//  FlowerCollector.h
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

#import <Foundation/Foundation.h>
#import "IFlyFlowerCollector.h"

//首页显示拥堵指数趋势图（chart1）的功能
#define SHOW_CHART_1_IN_MAIN_VIEW @"0000000010"

//从多个图表中选择显示拥堵指数趋势图（chart1）的功能
#define SHOW_CHART_1_IN_CHARTS @"0000010010"
//从图表列表中显示主要交通指标(chart2)
#define SHOW_CHART_2_IN_CHARTS @"0000010020"
//从图表列表中显示区域拥堵指数（chart3）
#define SHOW_CHART_3_IN_CHARTS @"0000010030"
//从图表列表中显示主要道路车速（chart4）
#define SHOW_CHART_4_IN_CHARTS @"0000010040"

//点击定位功能
#define RUN_LOCATION_FUNCTION @"0000000020"
//点击下载功能
#define RUN_DOWNLOAD_FUNCTION @"0000000030"
//点击帮助功能
#define RUN_ABOUT_FUNCTION @"0000000040"
//点击语音识别功能
#define RUN_SPEECH_RECOGNIZER @"0000000050"
//定制个性化道路
#define RUN_CUSTOMIZE_ROAD_FUNCTION @"0000000060"

@interface FlowerCollector : NSObject

/**
 *  自定义事件统计
 *
 *  @param eventId 网站上注册的事件Id.
 */
+ (void) OnEvent:(NSString *)eventId;


@end
