//
//  RoadMapViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/22.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import "RoadMapViewController.h"

@interface RoadMapViewController ()

@end

@implementation RoadMapViewController

@synthesize mapView;
@synthesize baseMapLayer;
@synthesize save_sketch_order;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Show magnifier to help with sketching
    self.mapView.showMagnifierOnTapAndHold = YES;

    //Tiled basemap layer
    [Tools initLocalTiledLayerInMapView:self.mapView withLayer:self.baseMapLayer];

    // add traffic layer */
    [Tools addTrafficLayerInMapView:self.mapView];

    //Graphics layer to hold all sketches (points, polylines, and polygons)
    AGSGraphicsLayer* graphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:graphicsLayer withName:@"Mask Layer"];

    //A composite symbol for the graphics layer's renderer to symbolize the sketches
    AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
    AGSSimpleMarkerSymbol* markerSymbol = [[AGSSimpleMarkerSymbol alloc] init];
    markerSymbol.style = AGSSimpleMarkerSymbolStyleSquare;
    markerSymbol.color = [UIColor clearColor];
    [composite addSymbol:markerSymbol];
    AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init];
    lineSymbol.color= [UIColor grayColor];
    lineSymbol.width = 1;
    [composite addSymbol:lineSymbol];
    AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init];
    fillSymbol.color = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.0] ;
    [composite addSymbol:fillSymbol];
    AGSSimpleRenderer* renderer = [AGSSimpleRenderer simpleRendererWithSymbol:composite];
    graphicsLayer.renderer = renderer;

    //Sketch layer
    AGSSketchGraphicsLayer* sketchLayer = [[AGSSketchGraphicsLayer alloc] initWithGeometry:nil];
    [self.mapView addMapLayer:sketchLayer withName:@"Sketch layer"];

    //Helper class to manage the UI toolbar, Sketch Layer, and Graphics Layer
    //Basically, where the magic happens
    self.sketchToolbar = [[SketchToolbar alloc] initWithToolbar:self.toolbar
        sketchLayer:sketchLayer
        mapView:self.mapView
        graphicsLayer:graphicsLayer
        withSketchOrderNumToPlist:save_sketch_order];

}

#pragma mark - 共享功能按钮点击
-(void) shareMenuBtnClicked:(id)sender{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"SharePopViewController" owner:self options:nil];
    UIView *contentView = [nibObjects objectAtIndex:0];

    CGRect frame = contentView.frame;
    frame.origin.x = 100;
    frame.origin.y = 100;
    frame.size.width = 200;
    frame.size.height = 200;
    contentView.frame = frame ;




//    KLCPopupLayout layout = KLCPopupLayoutMake((KLCPopupHorizontalLayout)KLCPopupHorizontalLayoutCenter,(KLCPopupVerticalLayout)KLCPopupVerticalLayoutBelowCenter);

    KLCPopup* popup = [KLCPopup popupWithContentView:contentView
                                            showType:(KLCPopupShowType)KLCPopupShowTypeFadeIn 
                                         dismissType:(KLCPopupDismissType)KLCPopupDismissTypeShrinkOut
                                            maskType:(KLCPopupMaskType)KLCPopupMaskTypeNone 
                            dismissOnBackgroundTouch:NO
                               dismissOnContentTouch:NO];
    [popup show];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) dealloc{
    self.mapView = nil;
}

@end
