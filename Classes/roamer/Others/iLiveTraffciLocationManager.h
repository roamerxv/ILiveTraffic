//
//  iLiveTraffciLocationManager.h
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-5-3.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface iLiveTraffciLocationManager : NSObject<CLLocationManagerDelegate>{
	CLLocationManager *_locationManager;
}

@property(retain,nonatomic) CLLocationManager *locationManager;

-(BOOL)locationServicesEnabled;
-(BOOL)startNavigation;
-(BOOL)stopNavigation;

@end
