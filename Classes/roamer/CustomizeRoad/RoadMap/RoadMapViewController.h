//
//  RoadMapViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/22.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "SketchToolbar.h"

@interface RoadMapViewController : UIViewController{
    AGSMapView* mapView;
}


@property (nonatomic, retain) IBOutlet AGSMapView * mapView;
@property(nonatomic,retain) AGSLayer * baseMapLayer; //底图

@property (nonatomic) int  save_sketch_order ; //显示和保存的 草图编号（存放在plist中，以便于区分各个内容的收藏）

@property (nonatomic,strong) IBOutlet UIToolbar* toolbar;
@property (nonatomic,strong) SketchToolbar* sketchToolbar;

@end
