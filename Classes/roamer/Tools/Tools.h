//
//  Tools.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-6.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "UIDevice+IdentifierAddition.h"


#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


@interface Tools : NSObject
{
    NSMutableArray *array ;
    NSString *  baseMapVersionAtServer;
}

@property (nonatomic ) bool backgroudIsDownlaoding;
@property (nonatomic, retain) NSString * baseMapVersionAtServer;

+ (id)sharedInstance;

//根据x，y获得对应的片区的代码
+(int) getArearCodeWithX:(double)x withY:(double)y ;

+(NSString *)createUUID  ;

//(返回MAC的MD5值)
+(NSString *)uniqueGlobalDeviceIdentifier;

//根据拥堵指数获得拥堵级别
+(int) getLevelWithCongestIndex:(float)congestIndex;
//根据拥堵指数获得对应的颜色
+(UIColor *) getLevelColrorWithCongestIndex:(float)index;
//根据拥堵指数字符串获得对应的颜色
+(UIColor *) getLevelColrorWithCongestIndexString:(NSString *)indexString;
//根据拥堵级别获得颜色
+(UIColor *) getLevelColrorWithLevel:(int)level;
//根据拥堵指数获得拥堵描述
+(NSString *) getLevelDescriptionWithCongestIndex:(float) congestIndex;
//根据用的级别获得拥堵描述
+(NSString *) getLevelDescriptionWithLevel:(int)level;

+(NSString *) getServerHost;

//根据iphone5来调整空间的y坐标
+(void) offsetUIViewYForIPhone5:(UIView *) uiView withOffset:(float)offset;

+(int) getCurrentHour;

//判断当前位置是否在杭州
+(bool) isPosInCityWithAGSMapView:(AGSMapView *) mapView withLongitude:(double) longitude  withLatitude:(double) latitude;

//根据等级和车速获得颜色
+(UIColor *) getColorWithSpeed:(float) speed withClazz:(int) clazz;

//异步获得服务器上地图包的版本调用
+(void) asynchronousQueryServerBaseMapTpkFileVersion;


/* 获取Documents文件夹路径 */
+(NSString *)getDocumentPath ;

/* 保存定制的道路信息*/
+(void) saveCustomizeRoadToFile:(NSMutableArray * )customizeRoadsArray ;

/* 读取定制的道路信息*/
+(NSMutableArray *) readCustomizeRoadFromFile;

/* 在mapview 中载入项目的离线地图，并且设置图层*/
+(void) initLocalTiledLayerInMapView:(AGSMapView *)mapView withLayer:(AGSLayer *) baseMapLayer;

/* 在mapview 中加入交通状况动态图层 */
+(void) addTrafficLayerInMapView:(AGSMapView *)mapView ;



@end
