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


#import "SketchToolbar.h"


@implementation SketchToolbar

@synthesize save_sketch_order;

// in iOS7 this gets called and hides the status bar so the view does not go under the top iPhone status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithToolbar:(UIToolbar*)toolbar sketchLayer:(AGSSketchGraphicsLayer*)sketchLayer mapView:(AGSMapView*) mapView graphicsLayer:(AGSGraphicsLayer*)graphicsLayer withSketchOrderNumToPlist:(int)sketch_order_number_to_plist{
    self = [super init];
    //Register for "Geometry Changed" notifications
    //We want to enable/disable UI elements when sketch geometry is modified
    if (self) {
        self.save_sketch_order = sketch_order_number_to_plist;
		//hold references to the mapView, graphicsLayer, and sketchLayer
		self.sketchLayer = sketchLayer;
        /* 定制草案图层里面，绘画时候用的各种符号*/
        AGSCompositeSymbol* composite = [AGSCompositeSymbol compositeSymbol];
        AGSSimpleMarkerSymbol* markerSymbol = [[AGSSimpleMarkerSymbol alloc] init];
        markerSymbol.style = AGSSimpleMarkerSymbolStyleCircle;
        markerSymbol.color = [UIColor clearColor];
        [composite addSymbol:markerSymbol];
        AGSSimpleLineSymbol* lineSymbol = [[AGSSimpleLineSymbol alloc] init];
        lineSymbol.color= [UIColor purpleColor];
        lineSymbol.width = 10.0f;
        [composite addSymbol:lineSymbol];
        AGSSimpleFillSymbol* fillSymbol = [[AGSSimpleFillSymbol alloc] init];
        fillSymbol.color = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.0] ;
        [composite addSymbol:fillSymbol];
        /* 定制结束 */

        sketchLayer.mainSymbol = composite;

		self.mapView = mapView;
		self.graphicsLayer = graphicsLayer;

		//Get references to the UI elements in the toolbar
		//Each UI element was assigned a "tag" in the nib file to make it easy to find them
		self.sketchTools = (UISegmentedControl* )[toolbar viewWithTag:55];
        
        //to display actual images in iOS 7 for segmented control
        if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7) {
            NSUInteger index = self.sketchTools.numberOfSegments;
            for (int i = 0; i < index; i++) {
                UIImage *image = [self.sketchTools imageForSegmentAtIndex:i];
                UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [self.sketchTools setImage:newImage forSegmentAtIndex:i];
            }
        }
        
        //disable the select tool if no graphics available
//        [self.sketchTools setEnabled:(graphicsLayer.graphicsCount>0) forSegmentAtIndex:1];

        
		self.undoTool = (UIButton*) [toolbar viewWithTag:56];
		self.redoTool = (UIButton*) [toolbar viewWithTag:57];
		self.saveTool = (UIButton*) [toolbar viewWithTag:58];
		self.clearTool = (UIButton*) [toolbar viewWithTag:59];
        self.exitBtn = (UIButton*) [toolbar viewWithTag:60];
		
		//Set target-actions for the UI elements in the toolbar
		[self.sketchTools addTarget:self action:@selector(toolSelected) forControlEvents:UIControlEventValueChanged];
		[self.undoTool addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
		[self.redoTool addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
		[self.saveTool addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
		[self.clearTool addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        [self.exitBtn addTarget:self action:@selector(exitView) forControlEvents:UIControlEventTouchUpInside];

        //  relaod from plist graphics with sketch_order_number_to_plist
        /**********************/
        NSDictionary * revertedGraphicsDict =  [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",self.save_sketch_order ]];

        if (revertedGraphicsDict != nil){
            NSDictionary * graphics_json = [revertedGraphicsDict objectForKey:@"graphics"];
            NSDictionary * envelope_json = [revertedGraphicsDict objectForKey:@"envelope"];

            if (graphics_json != nil)
            {
                AGSGeometry* sketchGeometry = [self.sketchLayer.geometry copy];
                AGSSimpleFillSymbol *filledSymbol = [[AGSSimpleFillSymbol alloc] init];
                filledSymbol.color = [UIColor colorWithRed:0.951 green:0.666 blue:0.444 alpha:0.80];
                AGSGraphic  * graphic = [AGSGraphic graphicWithGeometry:sketchGeometry symbol:filledSymbol attributes:nil ];
                [graphicsLayer addGraphic: [graphic  initWithJSON:graphics_json ]];
            }
            if (envelope_json != nil) {
                [self.mapView  zoomToEnvelope: [[AGSEnvelope alloc]initWithJSON:envelope_json] animated:YES];
            }
        }
        /*********************/



        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(respondToGeomChanged:)
                   name:AGSSketchGraphicsLayerGeometryDidChangeNotification
                 object:nil];


        //call this so we can properly initialize the state of undo,redo,clear, and save
        [self respondToGeomChanged:nil];


    }
    return self;
}



- (void)respondToGeomChanged: (id) sender {
	//Enable/disable UI elements appropriately
	self.undoTool.enabled = [self.sketchLayer.undoManager canUndo];
	self.redoTool.enabled = [self.sketchLayer.undoManager canRedo];
	self.clearTool.enabled = ![self.sketchLayer.geometry isEmpty] && self.sketchLayer.geometry!=nil;
	self.saveTool.enabled = [self.sketchLayer.geometry isValid];
}
- (IBAction) undo {
	if([self.sketchLayer.undoManager canUndo]) //extra check, just to be sure
		[self.sketchLayer.undoManager undo];
}
- (IBAction) redo {
	if([self.sketchLayer.undoManager canRedo]) //extra check, just to be sure
		[self.sketchLayer.undoManager redo];
}
- (IBAction) clear {
	[self.sketchLayer clear];
}
- (IBAction) save {

    NSString * message = @"保存后，将覆盖原有的设置，是否继续？";
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:YES forAlertType:AlertSuccess];
    [alert.defaultButton setTitle:@"不覆盖" forState:UIControlStateNormal];
    [alert.cancelButton setTitle:@"覆盖保存" forState:UIControlStateNormal];
    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
        if(button == alertObj.defaultButton) {

        } else {
            /* 先清除原有的 图层 */
            [self.mapView  removeMapLayerWithName:@"Mask Layer"];
            //Get the sketch geometry
            AGSGeometry* sketchGeometry = [self.sketchLayer.geometry copy];

            //If this is not a new sketch (i.e we are modifying an existing graphic)
            if(self.activeGraphic!=nil){
                //Modify the existing graphic giving it the new geometry
                self.activeGraphic.geometry = sketchGeometry;
                self.activeGraphic = nil;

                //Re-enable the sketch tools
                [self.sketchTools setEnabled:YES forSegmentAtIndex:0];
                [self.sketchTools setEnabled:YES forSegmentAtIndex:1];
                //		[self.sketchTools setEnabled:YES forSegmentAtIndex:2];
                //        [self.sketchTools setEnabled:YES forSegmentAtIndex:3];

            }else {
                //Add a new graphic to the graphics layer
                AGSGraphic* graphic = [AGSGraphic graphicWithGeometry:sketchGeometry symbol:nil attributes:nil ];
                //        [self.graphicsLayer addGraphic:graphic];

                /*针对画出的Polyline，先用Engine算Buffer，我给了一个0.004度的Buffer，这样出来一个粗的线条图形，然后用地图的整个Envelop的图去减掉Polyline的粗线条，就是一个应该盖在地图上的几何图形，给这个几何图形加上Fill属性就可以加载到Graphics Layer上了。
                 */
                //enable the select tool if there is atleast one graphic to select
                AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
                // 以sketch 的空间信息 做buffer，buffer 的跨度是 0.004度（和图层单位匹配）
                AGSGeometry *bufferedGeomery = [engine  bufferGeometry:graphic.geometry byDistance:CUSTOMIZE_ROAD_BUFFER_WIDTH];
                AGSGeometry *revertedGeomery = [engine differenceOfGeometry:self.mapView.baseLayer.fullEnvelope andGeometry:bufferedGeomery];

                AGSSimpleFillSymbol *filledSymbol = [[AGSSimpleFillSymbol alloc] init];
                filledSymbol.color = [UIColor colorWithRed:0.551 green:0.566 blue:0.444 alpha:0.800];

                AGSGraphic *revertedGraphics = [AGSGraphic graphicWithGeometry:revertedGeomery symbol:filledSymbol attributes:nil];

                AGSGraphicsLayer * maskLayer =  [[AGSGraphicsLayer alloc] initWithFullEnvelope:self.mapView.baseLayer.fullEnvelope ];

                [maskLayer addGraphic:revertedGraphics];
                [self.mapView addMapLayer:maskLayer withName:@"Mask Layer"];
                
                //保存envelope 和 graphics 到 NSDirctionary 中
                NSMutableDictionary * revertedGraphicsDict = [[NSMutableDictionary alloc] init];
                [revertedGraphicsDict setValue:[revertedGraphics encodeToJSON ] forKey:@"graphics"];
                [revertedGraphicsDict setValue:[self.mapView.visibleAreaEnvelope encodeToJSON ] forKey:@"envelope"];

                // 保存到plist 中
                [[NSUserDefaults standardUserDefaults] setObject:revertedGraphicsDict forKey:[NSString stringWithFormat:@"%d",self.save_sketch_order] ];
                [self.sketchTools setEnabled:(self.graphicsLayer.graphicsCount>0) forSegmentAtIndex:1];
                [self.sketchLayer clear];
                [self.sketchLayer.undoManager removeAllActions];
            }
        }
    };
    [alert show];
}

-(IBAction)exitView{
//    [self save];
    //退出当前界面
    self.sketchLayer = nil;
    self.graphicsLayer = nil;
    [(RoadMapViewController *)[self.mapView.superview nextResponder] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) toolSelected {
	switch (self.sketchTools.selectedSegmentIndex) {
		case -1://point tool
			//sketch layer should begin tracking touch events to sketch a point
			self.mapView.touchDelegate = self.sketchLayer;  
			self.sketchLayer.geometry = [[AGSMutablePoint alloc] initWithX:NAN y:NAN spatialReference:self.mapView.spatialReference];
            [[self.sketchLayer undoManager]removeAllActions];
			break;
		
		case 0://polyline tool
			//sketch layer should begin tracking touch events to sketch a polyline
			self.mapView.touchDelegate = self.sketchLayer; 
			self.sketchLayer.geometry = [[AGSMutablePolyline alloc] initWithSpatialReference:self.mapView.spatialReference];
            [[self.sketchLayer undoManager]removeAllActions];
			break;
		
		case 1://polygon tool
			//sketch layer should begin tracking touch events to sketch a polygon
			self.mapView.touchDelegate = self.sketchLayer; 
			self.sketchLayer.geometry = [[AGSMutablePolygon alloc] initWithSpatialReference:self.mapView.spatialReference];
            [[self.sketchLayer undoManager]removeAllActions];
			break;
		
		case -2: //select tool
			//nothing to sketch
			self.sketchLayer.geometry = nil; 
			
			//We will track touch events to find which graphic to modify
			self.mapView.touchDelegate = self;
			break;
		default:
			break;
	}
	
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint features:(NSDictionary *)features{
	//find which graphic to modify
	NSEnumerator *enumerator = [features objectEnumerator];
	NSArray* graphicArray = (NSArray*) [enumerator nextObject];
	if(graphicArray!=nil && [graphicArray count]>0){
		//Get the graphic's geometry to the sketch layer so that it can be modified
		self.activeGraphic = (AGSGraphic*)[graphicArray objectAtIndex:0];
		AGSGeometry* geom = [self.activeGraphic.geometry mutableCopy];
        
        //clear out the graphic's geometry so that it is not displayed under the sketch
        self.activeGraphic.geometry = nil;
        
        //Feed the graphic's geometry to the sketch layer so that user can modify it
		self.sketchLayer.geometry = geom;
        [[self.sketchLayer undoManager]removeAllActions];

		//sketch layer should begin tracking touch events to modify the sketch
		self.mapView.touchDelegate = self.sketchLayer;
		
        //Disable other tools until we finish modifying a graphic
        [self.sketchTools setEnabled:NO forSegmentAtIndex:0];
        [self.sketchTools setEnabled:NO forSegmentAtIndex:1];
//        [self.sketchTools setEnabled:NO forSegmentAtIndex:2];
//        [self.sketchTools setEnabled:NO forSegmentAtIndex:3];

        
		//Activate the appropriate sketch tool
		if([geom isKindOfClass:[AGSPoint class]]){
			[self.sketchTools setSelectedSegmentIndex:0];
		}else if ([geom isKindOfClass:[AGSPolyline class]]) {
			[self.sketchTools setSelectedSegmentIndex:1];
		}else if ([geom isKindOfClass:[AGSPolygon class]]) {
			[self.sketchTools setSelectedSegmentIndex:2];
		}
	}
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AGSSketchGraphicsLayerGeometryDidChangeNotification object:nil];
    self.sketchLayer=nil;
    self.mapView=nil;
    self.graphicsLayer=nil;

    self.sketchTools=nil ;
    self.undoTool=nil;
    self.redoTool=nil;
    self.saveTool=nil;
    self.clearTool=nil;
    self.exitBtn=nil;

    self.activeGraphic=nil;
}


@end
