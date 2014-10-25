//
//  iLiveTraffciLocationManager.m
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-5-3.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "iLiveTraffciLocationManager.h"
#import "iLiveTrafficMapViewController.h"

@implementation iLiveTraffciLocationManager

@synthesize locationManager = _locationManager;

#pragma mark - Init
-(id)init{
    self = [super init];
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    [self.locationManager startUpdatingLocation];

    return self;
}

#pragma mark - Action
-(BOOL)locationServicesEnabled{
   return [CLLocationManager locationServicesEnabled];
}

- (BOOL) startNavigation{
	BOOL ret = YES;
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    ret = YES;
    
    return ret;
}

-(BOOL)stopNavigation{
	BOOL ret = YES;
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    
    ret = YES;
    
    return ret;
}


#pragma mark - CLLocationManagerDelegate
- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
			fromLocation: (CLLocation *) oldLocation{
}

- (void) locationManager: (CLLocationManager *) manager
		didFailWithError: (NSError *) error {
}

#pragma mark - Uninit
-(void)dealloc{
    [self stopNavigation];
    self.locationManager = nil;

    [super dealloc];
}

@end
