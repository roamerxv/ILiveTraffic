// Copyright 2012 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the use restrictions at http://help.arcgis.com/en/sdk/10.0/usageRestrictions.htm
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface SketchToolbar : NSObject <AGSMapViewTouchDelegate> 

@property (nonatomic,strong) AGSSketchGraphicsLayer* sketchLayer;
@property (nonatomic,strong) AGSMapView* mapView;
@property (nonatomic,strong) AGSGraphicsLayer* graphicsLayer;

@property (nonatomic,strong) UISegmentedControl* sketchTools ;
@property (nonatomic,strong) UIButton* undoTool;
@property (nonatomic,strong) UIButton* redoTool;
@property (nonatomic,strong) UIButton* saveTool;
@property (nonatomic,strong) UIButton* clearTool;
@property (nonatomic,strong) UIButton* exitBtn;

@property (nonatomic,strong) AGSGraphic* activeGraphic;

@property (nonatomic) int  save_sketch_order ; //显示和保存的 草图编号（存放在plist中，以便于区分各个内容的收藏）


- (id)initWithToolbar:(UIToolbar*)toolbar sketchLayer:(AGSSketchGraphicsLayer*)sketchLayer mapView:(AGSMapView*) mapView graphicsLayer:(AGSGraphicsLayer*)graphicsLayer withSketchOrderNumToPlist:(int) sketch_order_number_to_plist;

- (void)respondToGeomChanged: (id) sender ;

@end
