//
//  RoadInfos.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/21.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadInfos : NSObject <NSCoding>

@property(nonatomic,retain) NSNumber * order;
@property(nonatomic,retain) NSString * name ;
@property(nonatomic,retain) NSString * desc;

@end
