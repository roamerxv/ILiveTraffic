//
//  MainRoadSpeedViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-9-6.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell4Roadname.h"
#import "Tools.h"

@interface MainRoadSpeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

-(void) inputData:(NSString *)dataString;
-(IBAction) closeView:(id)sender;
-(void) resizeView:(float) height;
@end
