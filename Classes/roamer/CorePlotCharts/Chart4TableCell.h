//
//  Chart4TableCell.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-27.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Chart4TableCell : UITableViewCell
{
    IBOutlet UILabel * roadName ;
    IBOutlet UILabel * currentSpeed;
//    IBOutlet UILabel * upAndDown;
//    IBOutlet UILabel * lastHourSpeed;
//    IBOutlet UILabel * lastWeekSpeed;
}

@property(nonatomic,retain) IBOutlet UILabel * roadName ;
@property(nonatomic,retain) IBOutlet UILabel * currentSpeed;
//@property(nonatomic,retain) IBOutlet UILabel * upAndDown;
//@property(nonatomic,retain) IBOutlet UILabel * lastHourSpeed;
//@property(nonatomic,retain) IBOutlet UILabel * lastWeekSpeed;

@end
