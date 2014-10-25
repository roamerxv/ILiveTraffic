//
//  iLiveTrafficConfigure.h
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <Foundation/Foundation.h>

/* *******************************************************************************
 * configure define
 *********************************************************************************/

#define ILIVE_TRAFFIC_REFRESHTIME                          @"refreshTime"
#define ILIVE_TRAFFIC_REFRESHTYPE                          @"refreshType"
#define ILIVE_TRAFFIC_DISPLAYED_TIPVIEW                    @"displayedTipView"

@interface iLiveTrafficConfigure : NSObject

-(void)setRefreshTime:(NSString*)refreshTime;
-(NSString*)refreshTime;

-(void)setRefreshType:(int)refreshType;
-(int)refreshType;

-(void)setDisplayedTipView:(UIViewController*)vc;
-(BOOL)isTipViewDisplayed:(UIViewController*)vc;
@end
