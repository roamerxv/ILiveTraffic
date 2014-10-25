//
//  Chart4ViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-27.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidingTabsControl.h"
#import "Chart4TableCell.h"
#import "Chart4TableCellType2.h"
#import "Chart4TableCellType3.h"
#import "Tools.h"

//使用事件监控sdk
#import "FlowerCollector.h"



@interface Chart4ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,SlidingTabsControlDelegate,UISearchDisplayDelegate,NSURLConnectionDelegate>

@end
