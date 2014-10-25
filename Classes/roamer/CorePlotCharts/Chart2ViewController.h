//
//  Chart2ViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-20.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ZXQuartz.h"
#include "Canvas.h"
#import "Chart1ViewController.h"
#import "Tools.h"

//使用事件监控sdk
#import "FlowerCollector.h"


#define OFFSET_OF_IPHONE5 80.0f;

@interface Chart2ViewController : UIViewController<NSURLConnectionDelegate>
{
    IBOutlet Canvas * piesCanvas;
    
    UILabel * label_value_1;
    UILabel * label_value_2;
    UILabel * label_value_3;
    UILabel * label_value_4;
    UILabel * label_last_update;
    UILabel * label_arear_1;
    UILabel * label_arear_2;
    UILabel * label_arear_3;
    UILabel * label_arear_4;
    UILabel * label_name_1;
    UILabel * label_name_2;
    UILabel * label_name_3;
    UILabel * label_name_4;
    UIActivityIndicatorView * activityIndicatorView;
    NSMutableData * receivedData ;

    UIView * pieChartCanvasView; //饼图画布范围视图
}

@property(nonatomic,retain) IBOutlet Canvas * piesCanvas;
@property(nonatomic,retain) IBOutlet UILabel* label_value_1;
@property(nonatomic,retain) IBOutlet UILabel* label_value_2;
@property(nonatomic,retain) IBOutlet UILabel* label_value_3;
@property(nonatomic,retain) IBOutlet UILabel* label_value_4;
@property(nonatomic,retain) IBOutlet UILabel* label_last_update;
@property(nonatomic,retain) IBOutlet UILabel* label_arear_1;
@property(nonatomic,retain) IBOutlet UILabel* label_arear_2;
@property(nonatomic,retain) IBOutlet UILabel* label_arear_3;
@property(nonatomic,retain) IBOutlet UILabel* label_arear_4;
@property(nonatomic,retain) IBOutlet UILabel* label_name_1;
@property(nonatomic,retain) IBOutlet UILabel* label_name_2;
@property(nonatomic,retain) IBOutlet UILabel* label_name_3;
@property(nonatomic,retain) IBOutlet UILabel* label_name_4;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;
@property(nonatomic,retain) NSMutableData * receivedData ;
@property(nonatomic,retain) IBOutlet UIView * pieChartCanvasView;



-(void) drawTable;



@end
