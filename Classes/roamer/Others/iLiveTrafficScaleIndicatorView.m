//
//  iLiveTrafficScaleIndicatorView.m
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-25.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "iLiveTrafficScaleIndicatorView.h"
#import "iLiveTrafficMapViewController.h"


@implementation iLiveTrafficScaleIndicatorView

@synthesize vc;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGPoint p = CGPointMake(20,self.center.y - 10);

	CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 2.0);
	int gap = [self bounds].size.width-5 - 5 - p.x;
//	int stageCount = [self.vc.mapView getMapManager]->getDisplayStageCount();
    int stageCount = 10;

	gap = gap/ stageCount;

    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.5);

	double curRadius = 0;			//current stage radius
//	int l = [self.vc.mapView getMapManager]->getDisplayStage();		//current stage(level)
    int l = 10;
	for (int i=0; i<stageCount; i++) {
		double radius = (i +1) * 0.35 + 3;
		CGContextFillEllipseInRect(context, CGRectMake(p.x + gap * i-radius, p.y-radius, radius*2, radius * 2));
		if (l==i)
			curRadius = radius;			//highlight current stage(level)
	}

    CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	//double radius = 8 * 0.5;
	//CGContextFillEllipseInRect(context, CGRectMake(p.x + gap * l-radius, p.y-radius, 2 * radius, 2* radius));
	CGContextFillEllipseInRect(context, CGRectMake(p.x + gap * l-curRadius, p.y-curRadius, 2 * curRadius, 2* curRadius));
    
    [super drawRect:rect];
}


@end
