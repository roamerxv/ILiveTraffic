//
//  Chart4ViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-27.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

@interface Chart4ViewController ()
{
    SlidingTabsControl* tabs;
    
    IBOutlet UITableView * tableView;
    NSMutableArray * itemArray;
    Boolean is_favorite;
    IBOutlet UILabel * label_last_update;
    int current_roadtype ;
    IBOutlet UIActivityIndicatorView * activityIndicatorView;
    NSMutableArray *searchResults;
    NSMutableArray *favoriteItems;
    NSMutableData * receivedData ;
    BOOL _loadingMore;
    UILabel *loadMoreText;

}

@property(nonatomic,retain) SlidingTabsControl * tabs;

@property(nonatomic,retain) UITableView * tableView ;
@property(nonatomic,retain) IBOutlet UILabel* label_last_update;
@property() Boolean is_favorite ;
@property() int current_roadtype ;
@property(nonatomic,retain) UIActivityIndicatorView * activityIndicatorView;

@property(nonatomic,retain) NSMutableData * receivedData ;


@property(nonatomic,retain) NSMutableArray * itemArray;
@property(nonatomic,retain) NSMutableArray *searchResults;
@property(nonatomic,retain) NSMutableArray *favoriteItems;

@property (readwrite, nonatomic) BOOL isSearching;
@property(nonatomic,retain)  UILabel *loadMoreText;


-(void) getDataWithType:(NSNumber *) type ;
// 创建表格底部
- (void) createTableFooter;


@end

@implementation Chart4ViewController

@synthesize tabs;
@synthesize tableView;
@synthesize itemArray;
@synthesize is_favorite;
@synthesize label_last_update;
@synthesize current_roadtype;
@synthesize activityIndicatorView;
@synthesize searchResults;
@synthesize isSearching;
@synthesize favoriteItems;
@synthesize receivedData;
@synthesize loadMoreText;


// 创建表格底部
- (void) createTableFooter
{
    self.tableView.tableFooterView = nil;
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    loadMoreText = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
    loadMoreText.textAlignment = NSTextAlignmentLeft;
    [loadMoreText setCenter:tableFooterView.center];
    [loadMoreText setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [loadMoreText setText:[ [NSString alloc] initWithFormat:@"现有%d条记录", self.itemArray.count]];
    [tableFooterView addSubview:loadMoreText];
    
    self.tableView.tableFooterView = tableFooterView;
}


-(void) refreshTableFooterLoadMoreText
{
    [loadMoreText setText:[ [NSString alloc] initWithFormat:@"现有%d条记录，松开后获取更多", self.itemArray.count]];
}

#pragma mark - Scroll
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    DLog(@"scrollViewDidEndDragging");
    if(!_loadingMore && scrollView.contentOffset.y > ((scrollView.contentSize.height - scrollView.frame.size.height)))
    {
        DLog(@"tableFooterView is displayer");
        [self getDataWithType: [NSNumber numberWithInt:current_roadtype]];
        self.activityIndicatorView.hidden = false;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.current_roadtype = 0;
    if (self) {
        // Custom initialization
        self.receivedData=[[NSMutableData data] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tabs = [[SlidingTabsControl alloc] initWithTabCount:4 withWidth:[[UIScreen mainScreen] bounds].size.width delegate:self];
    [self.view addSubview:tabs];
    self.isSearching = NO;
    is_favorite = true;
    [self createTableFooter];
    itemArray =[[NSMutableArray alloc]init ];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [FlowerCollector OnEvent:SHOW_CHART_4_IN_CHARTS];

    NSNumber * type = [[NSNumber alloc]initWithInt:self.current_roadtype];
    [self performSelectorOnMainThread:@selector(getDataWithType:) withObject:type waitUntilDone:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 搜索条出现后，把当前内容放入到 查询数组中
 */
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}

/* 输入查询字符串以后进行过滤显示
 */

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    DLog(@"searchDisplayController shouldReloadTableForSearchString :%@",searchString);
    if(self.searchDisplayController.searchBar.text.length>0) {
        self.isSearching=YES;
        NSString *strSearchText = self.searchDisplayController.searchBar.text;
        NSMutableArray *ar=[NSMutableArray array];
        for (NSDictionary *d in self.itemArray) {
            NSString *strData = [d valueForKey:@"road_name"];
            if([strData rangeOfString:strSearchText].length>0) {
                [ar addObject:d];
            }
        }
        self.searchResults=[NSMutableArray arrayWithArray:ar];
    } else {
        self.isSearching=NO;
    }
    return YES;
}

# pragma mark 只支持竖屏显示
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation ==  UIInterfaceOrientationMaskPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark SlidingTabsControl Delegate
- (UILabel*) labelFor:(SlidingTabsControl*)slidingTabsControl atIndex:(NSUInteger)tabIndex;
{
    UILabel* label = [[UILabel alloc] init];
    if (tabIndex == 0 ) {
        label.text = @"我的收藏";
    }else if (tabIndex == 1)
    {
        label.text = @"粗粒度";
    }else if (tabIndex == 2)
    {
        label.text = @"中粒度";
    }else if (tabIndex ==3)
    {
        label.text = @"细粒度";
    }else{
        label.text=@"";
    }
    
    
    return label;
}

-(void) refreshTableView
{
}

- (void) touchUpInsideTabIndex:(NSUInteger)tabIndex
{
    DLog(@"点击的tab index 是 %d",tabIndex);
    self.activityIndicatorView.hidden = FALSE;
    self.current_roadtype = tabIndex  ;
    [self.itemArray removeAllObjects];
    
    [self performSelectorOnMainThread:@selector(getDataWithType:) withObject:[NSNumber numberWithInt:tabIndex]  waitUntilDone:NO];

}

- (void) touchDownAtTabIndex:(NSUInteger)tabIndex
{
    
}

#pragma 获取远程数据
-(void) getDataWithType:(NSNumber *)type {
    int typeOfInt = [type intValue];
    
    self.tabs.userInteractionEnabled = NO;
    self.searchDisplayController.searchBar.text=@"";
    [self.searchDisplayController setActive:NO];
    //    调用远程方法，获得指数数据
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init] ;
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSURL * url = nil;
    if (typeOfInt == 0 )
    {
        iLiveTrafficAppDelegate * delegate = (iLiveTrafficAppDelegate *)[[UIApplication sharedApplication]delegate];
        url = [[NSURL alloc] initWithString:[ [NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_favorite?clientID=%@&begin_num=%d" ], delegate.deviceInfoID , self.itemArray.count]];
        is_favorite = true;
    }else{
        url = [[NSURL alloc] initWithString:[ [NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/main_road_speed/main_road_speed_for_date.json?level=%d&begin_num=%d" ], typeOfInt, self.itemArray.count]];
        is_favorite = false;
    }
    DLog(@"调用的url：%@",url);
    //异步请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//异步调用如果调用有错误，则出现此信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"ERROR with theConenction:%@",error.description );
    self.activityIndicatorView.hidden = true;
    self.tabs.userInteractionEnabled = YES;
    
}

//开始调用请求
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // store data
    DLog(@"didReceiveResponse");
    [self.receivedData setLength:0  ];            //通常在这里先清空接受数据的缓存
}

//调用成功(大数据量的时候可能会多次调用)，获得soap信息
-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)responseData
{
    DLog(@"（在大数据量的时候，可能是一部分）获取的返回responseData 是:%@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    [self.receivedData appendData:responseData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    DLog(@"%d",[self.receivedData length]);
    NSString* wsReturnValueString = [[NSString alloc] initWithBytes:[self.receivedData bytes] length:[self.receivedData length] encoding:NSUTF8StringEncoding];

    DLog(@"webserivce 调用结束，收取到的 全部报文是:\n%@",wsReturnValueString );
    DLog(@"WebService数据接受完成");
    
    NSString *current_congest_index = wsReturnValueString;
    AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
    NSError *error =nil ;
    NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
    for ( NSMutableDictionary * item in jsonDic)
    {
        [itemArray addObject:item];
    }
    DLog(@"返回的数据有%d条记录",[self.itemArray count]);
    if ([self.itemArray count ] > 0)
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
        NSTimeInterval seconds5Minutes = 5 * 60;
        NSDate* updateTime = [[dateFormatter dateFromString:(NSString *)[[itemArray objectAtIndex:0] objectForKey:@"record_date"]] dateByAddingTimeInterval:seconds5Minutes];
        if (updateTime == nil)
        {
            label_last_update.text =@"";
        }else{
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            label_last_update.text =[[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:updateTime ]];
        }
    }
    DLog(@"远程调用结束！");
    self.searchResults = self.itemArray;
    if ( current_roadtype == 0)
    {
        self.favoriteItems = [self.itemArray copy];
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
    [self.searchDisplayController.searchResultsTableView reloadData];
    [self.searchDisplayController.searchResultsTableView setNeedsDisplay];

    
    self.activityIndicatorView.hidden = true;
    self.tabs.userInteractionEnabled = YES;
    [self refreshTableFooterLoadMoreText];
    _loadingMore = NO;
}


//1.每个单元格cell的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 45.0f;
}


//2.设定TableView中指定的分区有多少行。默认是1，在这里用他来返回组成文本列表分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.isSearching)?self.searchResults.count:self.itemArray.count;
}

//3.绘制表行的方法。第一个参数是 UITableView的实例。第二个参数用来确定表行的位置
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //DLog(@"开始调用方法：cellForRowAtIndexPath,indexPaht的值是：%@",indexPath);
    
    //4。声明一个静态字符串，作为表示TableView的单元的键。
    static NSString * cellIdentifier =@"";
    if (self.current_roadtype == 1 )
    {
        cellIdentifier = @"Chart4CellIdentifier";
        //5.使用NoteScanIDentifier类型的可重用单元
        Chart4TableCell * cell = (Chart4TableCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            //6.检查以下代码是否为空。如果是空，就使用前面的标识符字符串来创建一个新的表视图单位
            //        cell = [[Chart3TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier] ;
            NSArray * nib =[[ NSBundle mainBundle]loadNibNamed:@"Chart4TableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }        
        NSUInteger row = [indexPath row];
        
        
        NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
        
        cell.roadName.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
        cell.currentSpeed.text = [[NSString alloc]initWithFormat:@"%.1f",((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue ];
        //    cell.upAndDown.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"up_and_down"] ];
        //    cell.lastHourSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_hour_avg_speed"] ];
        //    cell.lastWeekSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_week_avg_speed"] ];
        //    设置颜色
        UIColor * color = [[UIColor alloc ]init];
        int clazz = ((NSNumber  *)[rowData objectForKey:@"road_class"]).intValue;
        float speed = ((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue;
        color = [Tools getColorWithSpeed:speed withClazz:clazz];
        cell.currentSpeed.textColor = [UIColor blackColor];
//        cell.contentView.backgroundColor = color;
        cell.currentSpeed.backgroundColor = color;
        return cell;
    }else if ( self.current_roadtype == 0 ||  self.current_roadtype ==  2){ //如果是中粒度和收藏
        cellIdentifier = @"Chart4CellType2Identifier";
        //5.使用NoteScanIDentifier类型的可重用单元
        Chart4TableCellType2 * cell = (Chart4TableCellType2 *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            //6.检查以下代码是否为空。如果是空，就使用前面的标识符字符串来创建一个新的表视图单位
            //        cell = [[Chart3TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier] ;
            NSArray * nib =[[ NSBundle mainBundle]loadNibNamed:@"Chart4TableCellType2" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSUInteger row = [indexPath row];

        NSDictionary * rowData = nil;

        @try{
            rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
            NSString * roadName = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
            roadName  =  [roadName stringByReplacingOccurrencesOfString:@"（" withString:@"(" ];
            roadName  =  [roadName stringByReplacingOccurrencesOfString:@"）" withString:@")" ];
            cell.currentSpeed.text = [[NSString alloc]initWithFormat:@"%.1f",((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue ];
            cell.roadName.text = roadName;
            //    cell.upAndDown.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"up_and_down"] ];
            //    cell.lastHourSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_hour_avg_speed"] ];
            //    cell.lastWeekSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_week_avg_speed"] ];
            //    设置颜色
            int clazz = ((NSNumber  *)[rowData objectForKey:@"road_class"]).intValue;
            float speed = ((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue;
            cell.currentSpeed.textColor = [UIColor blackColor];
            //        cell.contentView.backgroundColor = color;
            cell.currentSpeed.backgroundColor = [Tools getColorWithSpeed:speed withClazz:clazz];
            //进行图片按钮的处理
            if (self.current_roadtype == 0)
            {
                //是收藏菜单。则显示图片是蓝色
                [cell.selectBtn setImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateNormal];
                //收藏的时候。点击是 删除收藏
                cell.selectBtn.tag = row ;
                cell.isFavorited = true;
                [cell.selectBtn addTarget:self action:@selector(favorite_click:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //是显示中粒度菜单，点击是收藏
                bool itemIsFavorited = false;
                DLog(@"self.favoriteItems  count is %d",self.favoriteItems.count);
                for (int i = 0 ; i < self.favoriteItems.count; i++)
                {
                    NSDictionary * rowData = [favoriteItems objectAtIndex:i];
                    NSString * itemRoadName = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
                    itemRoadName  =  [itemRoadName stringByReplacingOccurrencesOfString:@"（" withString:@"(" ];
                    itemRoadName  =  [itemRoadName stringByReplacingOccurrencesOfString:@"）" withString:@")" ];
                    if ([itemRoadName isEqualToString:roadName])
                    {
                        //如果路名匹配，则说明收藏过了。
                        itemIsFavorited = true;
                    }
                }
                if (itemIsFavorited)
                {
                    //收藏过了。
                    [cell.selectBtn setImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateNormal];
                    cell.selectBtn.tag = row ;
                    cell.isFavorited = true;
                }else{
                    [cell.selectBtn setImage:[UIImage imageNamed:@"favorite_unselected"] forState:UIControlStateNormal];
                    cell.selectBtn.tag = row ;
                    cell.isFavorited = false;
                }
                [cell.selectBtn addTarget:self action:@selector(favorite_click:) forControlEvents:UIControlEventTouchUpInside];
            }
        }@catch (NSException * e) {
            DLog(@"Exception: %@", e);
        }
        @finally {
        }

        return cell;
    }else { //如果是细粒度
        cellIdentifier = @"Chart4CellType3Identifier";
        //5.使用NoteScanIDentifier类型的可重用单元
        Chart4TableCellType3 * cell = (Chart4TableCellType3 *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            //6.检查以下代码是否为空。如果是空，就使用前面的标识符字符串来创建一个新的表视图单位
            //        cell = [[Chart3TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: cellIdentifier] ;
            NSArray * nib =[[ NSBundle mainBundle]loadNibNamed:@"Chart4TableCellType3" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        NSUInteger row = [indexPath row];
        cell.selectBtn.tag = row ;
        
        NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
        NSString * roadName = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
        roadName  =  [roadName stringByReplacingOccurrencesOfString:@"（" withString:@"(" ];
        roadName  =  [roadName stringByReplacingOccurrencesOfString:@"）" withString:@")" ];
        NSArray * array = [roadName componentsSeparatedByString:@"(" ];
        if (array.count == 1) {
            cell.subRoadName.text = @"";
            cell.roadDirection.text=@"";
            cell.roadName.text = array[0];
        }else if (array.count == 2){
            cell.roadName.text = array[0];
            cell.subRoadName.text = [array[1] stringByReplacingOccurrencesOfString:@")"withString:@""];
            cell.roadDirection.text =@"";
        }else if (array.count == 3){
            cell.roadName.text = array[0];
            cell.subRoadName.text = [array[1] stringByReplacingOccurrencesOfString:@")"withString:@""];
            cell.roadDirection.text = [array[2] stringByReplacingOccurrencesOfString:@")"withString:@""];
        }else if (array.count >= 4){
            //cell.roadName.text =[((NSString *) array[0]) stringByAppendingFormat:(@"(%@"),array[1]];
            for(int i =0 ; i <= array.count-3 ; i++)
            {
                if ( i == 0)
                {
                    cell.roadName.text = [cell.roadName.text stringByAppendingString:array[i]];
                }else{
                    cell.roadName.text = [cell.roadName.text stringByAppendingFormat:@"(%@",array[i]];
                }
            }
            cell.subRoadName.text = [array[array.count-2] stringByReplacingOccurrencesOfString:@")"withString:@""];
            cell.roadDirection.text = [array[array.count-1] stringByReplacingOccurrencesOfString:@")"withString:@""];
        }else{
            cell.roadDirection.text =@"";
            cell.roadName.text=@"";
            cell.subRoadName.text=@"";
        }
        cell.currentSpeed.text = [[NSString alloc]initWithFormat:@"%.1f",((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue ];
        //    cell.upAndDown.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"up_and_down"] ];
        //    cell.lastHourSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_hour_avg_speed"] ];
        //    cell.lastWeekSpeed.text = [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"last_week_avg_speed"] ];
        //    设置颜色
        UIColor * color = [[UIColor alloc ]init];
        int clazz = ((NSNumber  *)[rowData objectForKey:@"road_class"]).intValue;
        float speed = ((NSNumber  *)[rowData objectForKey:@"speed"]).floatValue;
        color = [Tools getColorWithSpeed:speed withClazz:clazz];
        
        cell.currentSpeed.textColor = [UIColor blackColor];
        //        cell.contentView.backgroundColor = color;
        cell.currentSpeed.backgroundColor = color;
        
        [cell.selectBtn addTarget:self action:@selector(lcoate_in_map_click:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

/* 去除滑动功能
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.tableView.editing)
        return UITableViewCellEditingStyleNone;
    else {
        return UITableViewCellEditingStyleDelete;
    }
    
}

/** 
 cell 的地图定位按钮点击
 */
-(void) lcoate_in_map_click:(id)sender
{
    Chart4TableCellType3 * cell = nil;
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 4.0 && [UIDevice currentDevice].systemVersion.doubleValue < 7.0 )
    {
        cell = ((Chart4TableCellType3 *) [[sender superview] superview]);
    }else{
        cell = ((Chart4TableCellType3 *) [[[sender superview] superview] superview]);
    }

    int row = ((UIButton *)sender).tag;
    NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
    
    id view = [cell  superview];
    
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }

    NSDictionary * finegrit = (NSDictionary *)[rowData objectForKey:@"finegrit"];
    DLog(@"地图定位开始,要查询的路是:%@\n%@",(NSString *)[rowData objectForKey:@"road_name"],finegrit);
    TabbarViewController * responder =(TabbarViewController *) [[view superview] superview].nextResponder;
    [responder  dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"locateOnMap" object:finegrit];
    }];

}

/**
 cell的收藏按钮点击
 */

- (void)favorite_click:(id)sender
{
    int row = ((UIButton *)sender).tag;
    iLiveTrafficAppDelegate * delegate = (iLiveTrafficAppDelegate *)[[UIApplication sharedApplication]delegate];
    if (self.is_favorite)
    {
        //删除收藏
        [MMProgressHUD showWithTitle:@"注意" status:@"已经取消收藏"];
        self.view.userInteractionEnabled = false;
        NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
        NSString * roadName = (NSString *)[rowData objectForKey:@"road_name"];
        DLog(@"在收藏的情况下，删除收藏按钮点击了,tag是：%d,路名%@",((UIButton *)sender).tag,roadName);
        
        NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_favorite_delete?roadName=%@&clientID=%@"], [roadName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], delegate.deviceInfoID  ];
        DLog(@"调用的urlString：%@",urlString  );
        NSURL * url_collect = [[NSURL alloc] initWithString:urlString];
        NSError *error =nil ;
        NSStringEncoding encoding;
        [[NSString alloc] initWithContentsOfURL:url_collect  usedEncoding:&encoding error:&error];
        [self.itemArray removeAllObjects];
        [self getDataWithType:0];
        self.searchDisplayController.searchBar.text=@"";
        [self.searchDisplayController setActive:NO];
//        double delayInSeconds = 3.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [MMProgressHUD dismiss];
//        });
        [MMProgressHUD dismiss];
        
        self.view.userInteractionEnabled = true;
      
        //删除itemarry和 searchResult中的结果，不去后台重新加载
        /*
        if (self.isSearching) {
        
            [self.searchResults removeObjectAtIndex:row  ];
            int itemAttayCount = self.itemArray.count;
            for ( int i = 0 ; i < itemAttayCount ; i++)
            {
                if ([(NSString *) [(( NSDictionary * ) self.itemArray[i]) objectForKey:@"road_name"] isEqualToString:roadName])
                {
                    [self.itemArray removeObjectAtIndex:i];
                }
            }

            
        }else{
            [self.itemArray removeObjectAtIndex:row];
            int itemAttayCount = self.searchResults.count;
            for ( int i = 0 ; i < itemAttayCount ; i++)
            {
                if ([(NSString *) [(( NSDictionary * ) self.searchResults[i]) objectForKey:@"road_name"] isEqualToString:roadName])
                {
                    [self.searchResults removeObjectAtIndex:i];
                }
            }

        }
        [self.tableView reloadData];
        [self.searchDisplayController.searchResultsTableView reloadData];
         */
    }else{
        Chart4TableCellType2 * cell = nil;

        double version_float_value =[UIDevice currentDevice].systemVersion.doubleValue ;

        if (version_float_value >= 7 && version_float_value <8){
            cell = ((Chart4TableCellType2 *) [[[sender superview] superview] superview]);
        }else{
            cell = ((Chart4TableCellType2 *) [[sender superview] superview]);
        }
        if (cell.isFavorited )
        {
            DLog(@"在中粒度中，点击了删除收藏，开始删除收藏功能");
            DLog(@"按钮点击了,路名%d",((UIButton *)sender).tag);
            [MMProgressHUD showWithTitle:@"注意" status:@"开始取消收藏"];
            int row = ((UIButton *)sender).tag;
            iLiveTrafficAppDelegate * delegate = (iLiveTrafficAppDelegate *)[[UIApplication sharedApplication]delegate];
            //删除收藏
            NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
            
            NSString * roadName = (NSString *)[rowData objectForKey:@"road_name"];
            NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_favorite_delete?roadName=%@&clientID=%@"], [roadName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], delegate.deviceInfoID  ];
            DLog(@"调用的urlString：%@",urlString  );
            NSURL * url_collect = [[NSURL alloc] initWithString:urlString];
            NSError *error =nil ;
            NSStringEncoding encoding;
            [[NSString alloc] initWithContentsOfURL:url_collect  usedEncoding:&encoding error:&error];
//            double delayInSeconds = 3.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [MMProgressHUD dismiss];
//            });
            
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"favorite_unselected"] forState:UIControlStateNormal];
            cell.isFavorited = false;
            [self.tableView setNeedsDisplay];
            [((UIButton *)sender) setNeedsDisplay];
            [MMProgressHUD dismiss];

        }else{
            DLog(@"在中粒度中，点击了收藏，开始收藏功能");
            [MMProgressHUD showWithTitle:@"注意" status:@"开始收藏"];
//            double delayInSeconds = 3.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [MMProgressHUD dismiss];
//            });
            
            NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
            
            NSString * roadName = (NSString *)[rowData objectForKey:@"road_name"];
            DLog(@"准备收藏的路段名称是：%@,设备号是:%@", roadName, delegate.deviceInfoID);
            NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_collect?roadName=%@&clientID=%@"], [roadName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], delegate.deviceInfoID  ];
            DLog(@"调用的urlString：%@",urlString  );
            NSURL * url_collect = [[NSURL alloc] initWithString:urlString];
            NSError *error =nil ;
            NSStringEncoding encoding;
            [[NSString alloc] initWithContentsOfURL:url_collect  usedEncoding:&encoding error:&error];
            [((UIButton *)sender) setImage:[UIImage imageNamed:@"favorite_selected"] forState:UIControlStateNormal];
            cell.isFavorited = true;
            [self.tableView setNeedsDisplay];
            [((UIButton *)sender) setNeedsDisplay];
            [MMProgressHUD dismiss];
        }
    }
}



//当在Cell上滑动时会调用此函数
/*
-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary * rowData =  (self.isSearching)?[searchResults objectAtIndex:row]:[itemArray objectAtIndex:row];
    NSString * roadName =  [[NSString alloc]initWithFormat:@"%@",[rowData objectForKey:@"road_name"] ];
    iLiveTrafficAppDelegate * delegate =(iLiveTrafficAppDelegate *) [[UIApplication sharedApplication]delegate];
    if (!is_favorite)
    {
        DLog(@"点击了收藏，开始收藏功能");
        DLog(@"准备收藏的路段名称是：%@,设备号是:%@", roadName, delegate.deviceInfoID);
        NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_collect?roadName=%@&clientID=%@"], [roadName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], delegate.deviceInfoID  ];
        DLog(@"调用的urlString：%@",urlString  );
        NSURL * url_collect = [[[NSURL alloc] initWithString:urlString] autorelease];
        NSError *error =nil ;
        NSStringEncoding encoding;
        [[NSString alloc] initWithContentsOfURL:url_collect  usedEncoding:&encoding error:&error];
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"收藏成功!" afterDelay:2];

    }else{
        DLog(@"点击了删除，开始删除收藏的功能");
        NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/customer_road/main_road_speed_favorite_delete?roadName=%@&clientID=%@"], [roadName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ], delegate.deviceInfoID  ];
        DLog(@"调用的urlString：%@",urlString  );
        NSURL * url_collect = [[[NSURL alloc] initWithString:urlString] autorelease];
        NSError *error =nil ;
        NSStringEncoding encoding;
        [[NSString alloc] initWithContentsOfURL:url_collect  usedEncoding:&encoding error:&error];
        [SVProgressHUD show];
        [SVProgressHUD dismissWithError:@"已取消收藏!" afterDelay:2];
        [self getDataWithType:0];
    }
}
 */

/*此时删除按钮为Delete，如果想显示为“删除” 中文的话，则需要实现
 UITableViewDelegate中的- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath方法*/

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (is_favorite)
    {
        return @"取消";
    }
    return @"收藏";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IFlyFlowerCollector OnPageStart:@"主要道路车速列表"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录进入页面:%@", @"主要道路车速列表");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IFlyFlowerCollector OnPageEnd:@"主要道路车速列表"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录离开页面:%@", @"主要道路车速列表");
}




@end
