//
//  ISColumnsMainViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-7-4.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColumnsController.h"

#import "Chart1ViewController.h"
#import "Chart2ViewController.h"
#import "Chart3MetroViewController.h"
#import "Chart4ViewController.h"




@interface ISColumnsMainViewController : UIViewController
{
    IBOutlet UIWindow * window;
    IBOutlet UINavigationController * navigationController;
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (retain, nonatomic) ISColumnsController *columnsController;

-(IBAction)closeBtnClicked:(id)sender;

@end
