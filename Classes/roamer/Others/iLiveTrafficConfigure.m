//
//  iLiveTrafficConfigure.m
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "iLiveTrafficConfigure.h"

@implementation iLiveTrafficConfigure

-(void)setRefreshTime:(NSString*)refreshTime{
    [[NSUserDefaults standardUserDefaults] setObject:(id)refreshTime forKey:ILIVE_TRAFFIC_REFRESHTIME];
	[NSUserDefaults resetStandardUserDefaults];
}

-(NSString*)refreshTime{
    return (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:ILIVE_TRAFFIC_REFRESHTIME];
}

-(void)setRefreshType:(int)refreshType{
    [[NSUserDefaults standardUserDefaults] setInteger:refreshType forKey:ILIVE_TRAFFIC_REFRESHTYPE];
	[NSUserDefaults resetStandardUserDefaults];
}

-(int)refreshType{
    return [[NSUserDefaults standardUserDefaults] integerForKey:ILIVE_TRAFFIC_REFRESHTYPE];
}

-(void)setDisplayedTipView:(UIViewController*)vc{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *displayedTipViewArray = [ud objectForKey:ILIVE_TRAFFIC_DISPLAYED_TIPVIEW];
    if (displayedTipViewArray && [displayedTipViewArray isKindOfClass:[NSMutableArray class]]) {
        
    } else {
        displayedTipViewArray = [NSMutableArray array];
    }
    
    [displayedTipViewArray addObject:NSStringFromClass([vc class])];
    [ud setObject:displayedTipViewArray forKey:ILIVE_TRAFFIC_DISPLAYED_TIPVIEW];
    [NSUserDefaults resetStandardUserDefaults];
}

-(BOOL)isTipViewDisplayed:(UIViewController*)vc{
    BOOL ret = NO;
    
    NSMutableArray *displayedTipViewArray = [[NSUserDefaults standardUserDefaults] objectForKey:ILIVE_TRAFFIC_DISPLAYED_TIPVIEW];
    if ([displayedTipViewArray isKindOfClass:[NSMutableArray class]]) {
        if ([displayedTipViewArray containsObject:NSStringFromClass([vc class])]) {
            ret = YES;
        }
    }
    
    return ret;
}

@end
