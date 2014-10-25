//
//  Chart4TableCellType3.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-8-7.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface Chart4TableCellType3 : UITableViewCell
{
    IBOutlet UILabel * roadName ;
    IBOutlet UILabel * roadDirection;
    IBOutlet UILabel * subRoadName;
    IBOutlet UILabel * currentSpeed;
    IBOutlet UIButton * selectBtn;
}

@property (nonatomic,retain) IBOutlet UILabel* roadName;
@property (nonatomic,retain) IBOutlet UILabel* roadDirection;
@property(nonatomic,retain) IBOutlet UILabel * currentSpeed;
@property (nonatomic,retain) IBOutlet UILabel * subRoadName;
@property(nonatomic,retain) IBOutlet UIButton * selectBtn;

@end
