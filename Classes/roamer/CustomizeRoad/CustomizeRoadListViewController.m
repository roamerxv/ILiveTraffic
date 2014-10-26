//
//  CustomizeRoadListViewController.m
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


#import "CustomizeRoadListViewController.h"


@interface CustomizeRoadListViewController ()

@end


@implementation CustomizeRoadListViewController

@synthesize tableView;
@synthesize stAlertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageview setImage:[UIImage imageNamed:@"customsize_table_background"]];
    [self.tableView setBackgroundView:imageview];
    //初始化数据
    [self initTableData];
    //长按手势支持
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.5;
    [self.tableView addGestureRecognizer:longPressGr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [FlowerCollector OnEvent:RUN_CUSTOMIZE_ROAD_FUNCTION];
}

-(void) closeBtnClicked:(id)sender{
    [self  dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 初始化表单的数据
- (void)initTableData{
    customezieRoadsInfoArray      = [Tools readCustomizeRoadFromFile];
    if (customezieRoadsInfoArray == nil || [customezieRoadsInfoArray count] <= 0 ) {
        //初始化2个不可删除的预制道路
        RoadInfos * roadInfo_home = [[RoadInfos alloc]init ];
        roadInfo_home.name=@"家";
        roadInfo_home.order= [NSNumber numberWithInt:0];
        RoadInfos * roadInfo_company = [[RoadInfos alloc]init ];
        roadInfo_company.name=@"公司";
        roadInfo_company.order=[NSNumber numberWithInt:1];

        RoadInfos * roadInfo_temp = [[RoadInfos alloc]init ];
        roadInfo_temp.name=@"test";
        roadInfo_temp.order=[NSNumber numberWithInt:2];

        NSMutableArray  * roadsInfoArray = [[NSMutableArray alloc]init];
        [roadsInfoArray addObject:roadInfo_home];
        [roadsInfoArray addObject:roadInfo_company];
        [roadsInfoArray addObject:roadInfo_temp];

        [Tools saveCustomizeRoadToFile:roadsInfoArray];
        customezieRoadsInfoArray = roadsInfoArray;
    }
    DLog(@"当前保存的道路定制信息是%@",customezieRoadsInfoArray);
}


//1.每个单元格cell的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44.0f;
}


//2.设定TableView中指定的分区有多少行。默认是1，在这里用他来返回组成文本列表分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [customezieRoadsInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [self.tableView  dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = ((RoadInfos *)[customezieRoadsInfoArray objectAtIndex:indexPath.row]).name;
    return cell;
}

/*  滑动删除 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1 ){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除状态
        [customezieRoadsInfoArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [Tools saveCustomizeRoadToFile:customezieRoadsInfoArray];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

/* 长按手势 响应事件 */
-(void) longPressToDo:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];

        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];

        if(indexPath == nil) return ;

        DLog(@"长按了%d号记录", indexPath.row);
    }
}


/* 选中 一行内容 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"选择了第%d条记录", indexPath.row);
    RoadMapViewController * roadMapViewController = [[RoadMapViewController alloc] initWithNibName:@"RoadMapViewController" bundle:nil];
    roadMapViewController.save_sketch_order = indexPath.row ;
    roadMapViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:roadMapViewController  animated:YES completion:nil];
}

/* 增加一条记录 */
-(IBAction)addItemBtnClicked:(id)sender{
    self.stAlertView = [[STAlertView alloc] initWithTitle:@"请输入信息"
        message:@"填写定制路段的名称"
        textFieldHint:@"唯一的名称"
        textFieldValue:nil
        cancelButtonTitle:@"放弃"
        otherButtonTitles:@"保存"
        cancelButtonBlock:^{

        } otherButtonBlock:^(NSString * result){
            /* 到plist 里面去确认是否有重复的 名字 */
            for ( RoadInfos *  roadInfos in customezieRoadsInfoArray){
                if ([roadInfos.name isEqualToString:result]){
                    [self alertNameExited:result ];
                }
            }
            //在当前table里面增加一条记录
            RoadInfos * roadInfo_item = [[RoadInfos alloc]init ];
            roadInfo_item.name=result;
            roadInfo_item.order=[NSNumber  numberWithInt:([customezieRoadsInfoArray count]+1)];
            [customezieRoadsInfoArray addObject:roadInfo_item];
            [Tools saveCustomizeRoadToFile:customezieRoadsInfoArray];
            //刷新table view
            [self.tableView reloadData];
        }];

}

-(void) alertNameExited:(NSString * )name{
    NSString * message = [NSString stringWithFormat:@"%@\n已经存在了，请重新输入!",name];
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:NO forAlertType:AlertFailure];
    [alert.defaultButton setTitle:@"退出" forState:UIControlStateNormal];
    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
        if(button == alertObj.defaultButton) {
            [self addItemBtnClicked:nil];
        } else {
        }
    };
    [alert show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
