//
//  Chart4TableCellType2.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-7-17.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface Chart4TableCellType2 : UITableViewCell
{
    IBOutlet UILabel * roadName ;
    IBOutlet UILabel * currentSpeed;
    IBOutlet UIButton * selectBtn;
    bool isFavorited;
}

@property (nonatomic,retain) IBOutlet UILabel* roadName;
@property(nonatomic,retain) IBOutlet UILabel * currentSpeed;
@property(nonatomic,retain) IBOutlet UIButton * selectBtn;
@property(nonatomic) bool isFavorited;
@end
