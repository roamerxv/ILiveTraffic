//
//  Tools.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-6.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Tools.h"

@implementation Tools

@synthesize baseMapVersionAtServer;
@synthesize backgroudIsDownlaoding;


NSMutableArray *arear_array = [NSMutableArray arrayWithObjects:
                         @"11|西湖风景区|120.0934316|30.20210576|120.1546636|30.26849775",
                         @"600|核心区|120.1291656|30.23817238|120.1844949|30.30869275",
                         @"620|城南片区|120.1244194|30.19173653|120.2170221|30.25044613",
                         @"610|城东片区|120.1793218|30.23047152|120.2442706|30.30993885",
                         @"630|城西片区|120.0767503|30.2424044|120.1314753|30.32477578",
                         @"640|城北片区|120.1008026|30.2920586|120.2351612|30.33847686",
                         nil];

+ (id)sharedInstance {
    static Tools * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init{
    if (self = [super init]) {
        backgroudIsDownlaoding = false;
        baseMapVersionAtServer = @"";
    }
    return self;
}


+(int) getArearCodeWithX:(double)x withY:(double)y
{
    int arear_code = 0;
    for (int i = 0; i< [arear_array count]; i++) {
        if ( [self isPointInDistrictWithX:x  withY:y  districtString:((NSString *)arear_array[i])])
        {
            arear_code =  [((NSString *)arear_array[i]) intValue];
            return  arear_code ;
        }
    }
    return arear_code;
}

+(bool ) isPointInDistrictWithX:(float )x withY:(float)y districtString:(NSString *) dimensions{
    bool result = false;
    NSArray *dimension = [dimensions componentsSeparatedByString:@"|"]; 
    if ( [((NSString *)dimension[2]) floatValue] <= x && [((NSString *)dimension[4]) floatValue] >= x && [((NSString *)dimension[3]) floatValue] <= y && [((NSString *)dimension[5]) floatValue] >= y) {
        result = true;
    }
    return result;
}

+(NSString *)createUUID{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);

    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+(NSString *) uniqueGlobalDeviceIdentifier
{
    return [NSString stringWithFormat:@"%@",
            [[UIDevice currentDevice] uniqueDeviceIdentifier]];
}

+(UIColor *) getLevelColrorWithCongestIndexString:(NSString *)indexString
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    return [self getLevelColrorWithCongestIndex:[f numberFromString:indexString].floatValue ];
}

+(int) getLevelWithCongestIndex:(float)index
{
    if(index  >= 0.0 && index  <= 2.0){
        return 1 ;
    }else if (index  >= 2.0 && index  <= 4.0){
        return 2 ;
    }else if(index  >= 4.0 && index  <= 6.0){
        return 3 ;
    }else if(index  >= 6.0 && index  <= 8.0){
        return 4 ;
    }else if(index  >= 8.0 && index  <= 10.0){
        return 5 ;
    }else
    {
        return 0;
    }
    
}

+(UIColor *) getLevelColrorWithCongestIndex:(float)index{
    int level = [self getLevelWithCongestIndex:index];
    if (level == 1 || level == 2 || level == 3 || level == 4 || level == 5)
    {
        return [self getLevelColrorWithLevel:level];
    }else
    {
        return nil;
    }
    
}

+(UIColor *) getLevelColrorWithLevel:(int)level
{
    if (level == 1)
    {
        return [UIColor colorWithRed:0.271f
                           green:0.545f
                            blue:0.165f
                           alpha:1];
    }else if (level == 2)
    {
        return [UIColor colorWithRed:0.435f
                            green:0.835f
                            blue:0.267f
                            alpha:1];
    }else if (level == 3)
    {
        return [UIColor colorWithRed:1.0f
                               green:1.0f
                                blue:0.0f
                               alpha:1];
    }else if (level == 4)
    {
        return [UIColor colorWithRed:0.933f
                               green:0.588f
                                blue:0.2f
                               alpha:1];
    }
    else if (level == 5)
    {
        return [UIColor colorWithRed:1.0f
                               green:0.0f
                                blue:0.0f
                               alpha:1];
    }
    else{
        return nil;
    }
}

+(NSString *) getLevelDescriptionWithCongestIndex:(float)congestIndex
{
    int level = [self getLevelWithCongestIndex:congestIndex];
    return [self getLevelDescriptionWithLevel:level];
}

+(NSString *) getLevelDescriptionWithLevel:(int)level
{
    if (level == 1)
    {
        return @"畅通";
    }else if (level == 2)
    {
        return @"基本畅通";
    }else if (level == 3)
    {
        return @"轻度拥堵";
    }else if (level == 4)
    {
        return @"中度拥堵";
    }
    else if (level == 5)
    {
        return @"严重拥堵";
    }
    else{
        return @"无数据";
    }
}

+(NSString *) getServerHost{
    return @"http://115.238.43.206:8300";
//    return @"http://127.0.0.1:3000";
}

+(int) getCurrentHour{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH"];
    int  hour =  [[dateformatter stringFromDate:senddate] intValue];
    return hour;
    
}

+(void) offsetUIViewYForIPhone5:(UIView *)uiView withOffset:(float)offset
{
    CGRect newFrame  = uiView.frame ;
    newFrame.origin.y =newFrame.origin.y+ offset;
    uiView.frame=   newFrame;
}


+(bool) isPosInCityWithAGSMapView:(AGSMapView *) mapView withLongitude:(double)longitude  withLatitude:(double) latitude
{
    AGSSpatialReference * spatialReference = [AGSSpatialReference spatialReferenceWithWKID:4326];
    AGSPoint * point = [[AGSPoint alloc]initWithX:longitude y:latitude spatialReference:spatialReference];
    return [mapView.maxEnvelope containsPoint:point];
}

+(UIColor *) getColorWithSpeed:(float) speed withClazz:(int) clazz
{
    UIColor * color = [[UIColor alloc ]init];
    if (clazz == 1 ){
        if ( speed > 50.0)
        {
            color = [Tools getLevelColrorWithLevel:1];
        }else if ( speed > 40.0 && speed < 50.0)
        {
            color = [Tools getLevelColrorWithLevel:2];
        }else if ( speed > 30.0 && speed < 40.0)
        {
            color = [Tools getLevelColrorWithLevel:3];
        }else if ( speed > 20.0 && speed < 30.0)
        {
            color = [Tools getLevelColrorWithLevel:4];
        }else if ( speed <= 20.0)
        {
            color = [Tools getLevelColrorWithLevel:5];
        }
        
    }else if (clazz == 2){
        if ( speed > 35.0)
        {
            color = [Tools getLevelColrorWithLevel:1];
        }else if ( speed > 25.0 && speed < 35.0)
        {
            color = [Tools getLevelColrorWithLevel:2];
        }else if ( speed > 18.0 && speed < 25.0)
        {
            color = [Tools getLevelColrorWithLevel:3];
        }else if ( speed > 13.0 && speed < 18.0)
        {
            color = [Tools getLevelColrorWithLevel:4];
        }else if ( speed <= 13.0)
        {
            color = [Tools getLevelColrorWithLevel:5];
        }
    }else if (clazz == 5){
        if ( speed > 25.0)
        {
            color = [Tools getLevelColrorWithLevel:1];
        }else if ( speed > 20.0 && speed < 25.0)
        {
            color = [Tools getLevelColrorWithLevel:2];
        }else if ( speed > 15.0 && speed < 20.0)
        {
            color = [Tools getLevelColrorWithLevel:3];
        }else if ( speed > 10.0 && speed < 15.0)
        {
            color = [Tools getLevelColrorWithLevel:4];
        }else if ( speed <= 10.0)
        {
            color = [Tools getLevelColrorWithLevel:5];
        }
        
    }
    return color;
}

+ (void)asynchronousQueryServerBaseMapTpkFileVersion{
    [IFlyFlowerCollector updateOnlineConfig]; //异步方法，完成后，会发出 SUNFLOWERNOTIFICATION 的消息
}

/* 获取Documents文件夹路径 */
+(NSString *)getDocumentPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = documents[0];
    return documentPath;
}

+(void) saveCustomizeRoadToFile:(NSMutableArray *) customizeRoadsArray {
    // 归档数组
    NSString *documentPath       = [Tools getDocumentPath];
    NSString *arrayFilePath      = [documentPath stringByAppendingPathComponent:@"List_Of_Customize_Roads.list"];
    [NSKeyedArchiver archiveRootObject:customizeRoadsArray   toFile:arrayFilePath];

}

+(NSMutableArray *) readCustomizeRoadFromFile{
    NSString *documentPath       = [Tools getDocumentPath];
    NSString *arrayFilePath      = [documentPath stringByAppendingPathComponent:@"List_Of_Customize_Roads.list"];
    return (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithFile:arrayFilePath];
}

+(void) initLocalTiledLayerInMapView:(AGSMapView *)mapView withLayer:(AGSLayer *) baseMapLayer{
    @try {
        NSString * localMapVersion  =[[NSUserDefaults standardUserDefaults] stringForKey:@"LocalBaseMapTPKVersion"] ;
        if( localMapVersion != nil)
        {
            NSString * tpkName = [ [NSString alloc] initWithFormat:@"%@-%@",BASE_MAP_TPK_NAME_USED_BY_ARCGIS,[[NSUserDefaults standardUserDefaults ]stringForKey:@"LocalBaseMapTPKVersion"]];
            baseMapLayer = [AGSLocalTiledLayer localTiledLayerWithName:tpkName];

        }else{
            baseMapLayer = [AGSLocalTiledLayer localTiledLayerWithName:BASE_MAP_TPK_NAME_USED_BY_ARCGIS];
        }
        [mapView insertMapLayer:baseMapLayer withName:@"BaseMap" atIndex:0];


        UIColor * color = [UIColor colorWithRed:10.0f/255.0f green:10.0f/255.0f blue:10.0f/255.0f alpha:1.0f];

        mapView.backgroundColor = color;
        mapView.gridLineColor = color;
    }
    @catch (NSException *exception) {
        NSLog(@"载入离线地图的时候发生错误！%@\n", exception.description);
    }
    @finally {
    }

}

+(void) addTrafficLayerInMapView:(AGSMapView *)mapView{
    NSURL *url_traffic =[NSURL URLWithString:trafficMapServiceURL];
    AGSDynamicMapServiceLayer * trafficLayer =[AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:url_traffic];
    //    trafficLayer.delegate =self;
    trafficLayer.renderNativeResolution = YES;
    trafficLayer.dpi = 96;
    [mapView insertMapLayer:trafficLayer  withName:@"TrafficLayer" atIndex:1];
}


@end
