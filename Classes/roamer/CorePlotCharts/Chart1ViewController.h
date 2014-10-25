//
//  Chart1ViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Chart1Theme.h"
#import "Tools.h"

//使用事件监控sdk
#import "FlowerCollector.h"

#import "AMSmoothAlertView.h"


@interface Chart1ViewController : UIViewController <CPTPlotDataSource, CPTAxisDelegate,CPTPlotSpaceDelegate >
{
    CPTXYGraph * graph;
    
    NSMutableArray* points;
    NSMutableArray* points2;
    
    CPTPlotRange * xPlotRange;
    CPTPlotRange * yPlotRange;
    
    CPTGraphHostingView * hostingView;
    
    CPTXYPlotSpace *plotSpace;
    
    IBOutlet UILabel * todayString ;
    IBOutlet UILabel * todayTemp1;
    IBOutlet UILabel * todayTemp2;
    IBOutlet UILabel * todayWeather;
    IBOutlet UILabel * todayTemp;
    
    IBOutlet UILabel * lastweekString ;
    IBOutlet UILabel * lastweekTemp1;
    IBOutlet UILabel * lastweekTemp2;
    IBOutlet UILabel * lastweekWeather;
    IBOutlet UILabel * lastweekTemp;

    IBOutlet UIButton * returnBtn;

    IBOutlet UIView * arear1_view;
    IBOutlet UIView * arear2_view;

    
    UIActivityIndicatorView * activityIndicatorView;
    UIImageView * loadingImageView ;
    
    NSMutableData * receivedData ;

    CGRect plotSpaceFrame ;
}

@property(retain) iLiveTrafficMapViewController *mapVC;

@property(nonatomic,retain) IBOutlet CPTGraphHostingView * hostingView;
@property(nonatomic,retain) CPTXYPlotSpace *plotSpace;

@property(nonatomic,retain) IBOutlet UIView * arear1_view ;
@property(nonatomic,retain) IBOutlet UIView * arear2_view ;

@property(nonatomic,retain) IBOutlet UILabel * todayString;
@property(nonatomic,retain) IBOutlet UILabel * todayTemp1;
@property(nonatomic,retain) IBOutlet UILabel * todayTemp2;
@property(nonatomic,retain) IBOutlet UILabel * todayWeather;
@property(nonatomic,retain) IBOutlet UILabel * todayTemp;

@property(nonatomic,retain) IBOutlet UILabel * lastweekString;
@property(nonatomic,retain) IBOutlet UILabel * lastweekTemp1;
@property(nonatomic,retain) IBOutlet UILabel * lastweekTemp2;
@property(nonatomic,retain) IBOutlet UILabel * lastweekWeather;
@property(nonatomic,retain) IBOutlet UILabel * lastweekTemp;


@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;
@property(nonatomic,retain) IBOutlet UIImageView * chart1_laoding_img ;

@property(nonatomic,retain) NSMutableData * receivedData ;

@property(nonatomic,retain) IBOutlet UIButton * returnBtn;

@property CGRect plotSpaceFrame;

@property Boolean  displayReturnButton;


-(IBAction)closeBtnClicked:(id)sender;
-(void) showWeather;

@end
