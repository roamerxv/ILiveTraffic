//
//  Canvas.h
//  demo
//
//  Created by 张 玺 on 13-3-29.
//  Copyright (c) 2013年 me.zhangxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ZXQuartz.h"
#import "Tools.h"
#include <math.h>
#import "AMSmoothAlertView.h"


@interface Canvas : UIView
{
    NSMutableArray * piesData;
    int section_flag;
    CGFloat center_x ;
    CGFloat center_y ;
    float radius;
    int long_mark_line_length ;
    int short_mark_line_length ;
    UILabel* lastUpdateTime ;
}

@property(nonatomic,retain)  NSMutableArray* piesData;
@property(nonatomic,retain) UILabel* lastUpdateTime;

-(void) drawMarkLine; //画刻度线
-(void) renderPies;
-(void) drawPies;
-(void) getPiesData;
-(void) drawLastUpdateTimeLabel:(NSString *)lastupdatedTimeString;

@end
