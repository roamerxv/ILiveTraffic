//
//  CustomizeRoadListViewController.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/21.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//
//
//                     _ooOoo_
//                    o8888888o
//                    88" . "88
//                    (| -_- |)
//                    O\  =  /O
//                    _/`---'\____
//               .'  \\|     |//  `.
//              /  \\|||  :  |||//  \
//             /  _||||| -:- |||||-  \
//             |   | \\\  -  /// |   |
//             | \_|  ''\---/''  |   |
//             \  .-\__  `-`  ___/-. /
//           ___`. .'  /--.--\  `. . __
//        ."" '<  `.___\_<|>_/___.'  >'"".
//       | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//       \  \ `-.   \_ __\ /__ _/   .-` /  /
//  ======`-.____`-.___\_____/___.-`____.-'======
//                     `=---='
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//              佛祖保佑       永无BUG


#import <UIKit/UIKit.h>
#import "FlowerCollector.h"

#import <STAlertView/STAlertView.h>

#import "AMSmoothAlertView.h"

#import "RoadInfos.h"
#import "Configer.h"

#import "RoadMapViewController.h"



@interface CustomizeRoadListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UITableView * tableView;
    NSMutableArray * customezieRoadsInfoArray ;
}


@property(nonatomic,retain) IBOutlet UITableView * tableView;

@property (nonatomic, strong) STAlertView *stAlertView;

-(IBAction) closeBtnClicked:(id)sender;
-(IBAction) addItemBtnClicked:(id)sender;

@end
