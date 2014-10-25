//
//  RoadInfos.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/21.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import "RoadInfos.h"

@implementation RoadInfos

@synthesize order;
@synthesize name;
@synthesize desc;

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:self.name      forKey:@"name"];
    [aCoder encodeObject:self.order     forKey:@"order"];
    [aCoder encodeObject:self.desc      forKey:@"desc"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        self.name       = [aDecoder decodeObjectForKey:@"name"];
        self.order   = [aDecoder decodeObjectForKey:@"order"];
        self.desc      = [aDecoder decodeObjectForKey:@"desc"];
    }

    return self;
}

@end
