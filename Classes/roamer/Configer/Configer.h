//
//  Configer.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14-9-11.
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

#define DOWNLOAD_BASE_MAP_FILE_DISPLAY_NAME @"杭州地图"
#define DOWNLOAD_BASE_MAP_FILE_PHYSICS_NAME @"iLiveTraffic_Base_Map"



#define BASE_MAP_TPK_FILE_URL @"http://115.238.43.206:8300/mobilebase_map_file.tpk"
//#define BASE_MAP_TPK_NAME_USED_BY_ARCGIS @"iLiveTraffic_Base_Map"
#define BASE_MAP_TPK_NAME_USED_BY_ARCGIS @"iLiveTraffic_Base_Map"

//定于底图中心点的x和y
#define CENTER_POINT_X 120.181936
#define CENTER_POINT_Y 30.156538

#define CENTER_XMIN 120.027288000642
#define CENTER_XMAX 120.372462000422
#define CENTER_YMIN 30.0734000002107
#define CENTER_YMAX 30.3930554338621 

//ArcGIS SDK 参数
#define ARCGIS_APP_CLIENT_ID @"UKbGWxKZm9gl7L47"

//讯飞语音的配置参数
#define IFLY_APP_ID @"521ace1a"
#define IFLY_TIMEOUT_VALUE         @"20000"            // timeout      连接超时的时间，以ms为单位
#define NAME @"userwords"
//语音识别关键词
#define USERWORDS   @"{\"userword\":[{\"name\":\"iflytek\",\"words\":[\"体育场路\",\"秋涛路\",\"浣纱路\",\"凤起路\",\"环城西路\",\"建国路\",\"中山路\",\"中河路\",\"中河地面路\",\"环城西路\",\"文三路\",\"环城东路\",\"延安路\",\"文一路\",\"秋涛路\",\"湖墅路\",\"庆春路\",\"灵溪隧道\",\"曙光路\",\"上塘地面路\",\"南山路\",\"天城路\",\"莫干山路\",\"庆春路\",\"北山路\",\"凤起东路\",\"体育场路\",\"解放路\",\"潮王路\",\"秋涛北路\",\"曙光路\",\"中河地面路\",\"灵隐路\",\"望江路\",\"东新路\",\"湖墅路\",\"文二路\",\"文晖路\",\"艮山西路\",\"绍兴路\",\"环城北路\",\"天目山路\",\"德胜东路\",\"西溪路\",\"钱江四桥\",\"文一西路\",\"钱江四桥\",\"虎跑路\",\"杨公堤\",\"湖滨隧道\",\"梅灵路\",\"中河高架路\",\"石祥路\",\"上塘高架路\",\"石桥高架路\"]}]}"

//微信sdk的参数
#define WEBCHART_APP_ID @"64206ae5"

//crashlytics APP_ID
#define CRASHLYTICS_APP_ID @"df5790710b6debf17578f252f8aaadcb7de2af79"

//ArcGIS rest 服务参数
#define baseMapServiceURL @"http://www.hzctrc.com/arcgis/rest/services/V32/mobilebasetest/MapServer"
//#define trafficMapServiceURL @"http://www.hzctrc.com/arcgis/rest/services/V32/mobiletraffictest/MapServer"
#define trafficMapServiceURL @"http://www.hzctrc.com/arcgis/rest/services/V32/mobiletrafficios/MapServer"


//判断是否要弹出投票窗口的运行间隔次数
#define SHOW_COMMENT_INTERVAL_VALUE 30

//MMProgressHUD 显示的等待时间长
#define MMProgressHUD_DELAY_SECONDS  2.0

//定制道路的 区域宽度
#define CUSTOMIZE_ROAD_BUFFER_WIDTH 0.0023

@interface Configer : NSObject



@end
