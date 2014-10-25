//
//  TrafficeIndexController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-3.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrafficeIndexController : NSObject

-(void) addOrUpdateRecord:(NSString *) lastValue;

-(NSString *) lastValue ;

@end
