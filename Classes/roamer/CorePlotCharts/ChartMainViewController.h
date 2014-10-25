//
//  ChartMainViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-7-4.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTSlidingPagesDataSource.h"
#import "TTScrollSlidingPagesController.h"
#import "TTSlidingPage.h"
#import "TTSlidingPageTitle.h"

#import "Chart1ViewController.h"
#import "Chart2ViewController.h"
#import "Chart3MetroViewController.h"
#import "Chart4ViewController.h"


@interface ChartMainViewController : UIViewController<TTSlidingPagesDataSource>

@end
