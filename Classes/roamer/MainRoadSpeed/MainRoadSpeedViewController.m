//
//  MainRoadSpeedViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-9-6.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "MainRoadSpeedViewController.h"

@interface MainRoadSpeedViewController ()
{
    NSMutableArray * itemArray;
    IBOutlet UITableView * tableView;
}

@property(nonatomic,retain) UITableView * tableView ;
@property(nonatomic,retain) NSMutableArray * itemArray;





@end

@implementation MainRoadSpeedViewController

@synthesize itemArray;
@synthesize tableView;

-(IBAction)closeView:(id)sender
{
    [self  dismissViewControllerAnimated:YES completion:nil];
}

-(void)inputData:(NSString *)dataString
{
    DLog(@"设置的数据是 :%@",dataString);
    AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
    NSError *error =nil ;
    NSMutableDictionary *jsonDic = [[parser objectWithString:dataString error:&error]  objectForKey:@"result_items"];
    for ( NSMutableDictionary * item in jsonDic)
    {
        [itemArray addObject:item];
    }
    DLog(@"返回的数据有%d条记录",[self.itemArray count]);
}

//1.每个单元格cell的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 53.0f;
}

//2.设定TableView中指定的分区有多少行。默认是1，在这里用他来返回组成文本列表分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

//3.绘制表行的方法。第一个参数是 UITableView的实例。第二个参数用来确定表行的位置
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //DLog(@"开始调用方法：cellForRowAtIndexPath,indexPaht的值是：%@",indexPath);
    
    //4。声明一个静态字符串，作为表示TableView的单元的键。
    static NSString * cellIdentifier =@"";
    cellIdentifier = @"Cell4RoadnameIdentifier";
    //5.使用NoteScanIDentifier类型的可重用单元
    Cell4Roadname * cell = (Cell4Roadname *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        //6.检查以下代码是否为空。如果是空，就使用前面的标识符字符串来创建一个新的表视图单位
        //cell = [[Cell4Roadname alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier] ;
        NSArray * nib =[[ NSBundle mainBundle]loadNibNamed:@"Cell4Roadname" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
        
    NSDictionary * rowData = [itemArray objectAtIndex:row];
    NSString * roadName = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
    roadName  =  [roadName stringByReplacingOccurrencesOfString:@"（" withString:@"(" ];
    roadName  =  [roadName stringByReplacingOccurrencesOfString:@"）" withString:@")" ];
    cell.roadSpeed.text = [[[NSString alloc]initWithFormat:@"%.1f",((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue ]autorelease];
    cell.roadName.text = roadName;
    //    设置颜色
    UIColor * color = [[[UIColor alloc ]init]autorelease];
    int clazz = ((NSNumber  *)[rowData objectForKey:@"road_class"]).intValue;
    float speed = ((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue;
    color = [Tools getColorWithSpeed:speed withClazz:clazz];
    cell.roadSpeed.textColor = [UIColor blackColor];
    //        cell.contentView.backgroundColor = color;
    cell.roadSpeed.backgroundColor = color;
    if (row == 0)
    {
        [cell speechIt:cell];
    }
    return cell;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        itemArray =[[NSMutableArray alloc]init ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void) resizeView:(float)height
{
    CGRect rect = self.view.frame;
    rect.size.height = height;
    self.view.frame = rect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
