//
//  Chart1ViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Chart1ViewController.h"



/*
 * Notes:
 * 1, You should change the type of view in KSViewController.xib to CPTGraphHostingView;
 * 2, You should add '-all_load -ObjC' to other linker flags in build settings.
 */


@interface Chart1ViewController ()

@end

@implementation Chart1ViewController

@synthesize mapVC;

@synthesize hostingView;
@synthesize plotSpace;

@synthesize arear1_view;
@synthesize arear2_view;

@synthesize todayString;
@synthesize todayTemp1;
@synthesize todayTemp2;
@synthesize todayWeather;
@synthesize todayTemp;

@synthesize lastweekString;
@synthesize lastweekTemp1;
@synthesize lastweekTemp2;
@synthesize lastweekWeather;
@synthesize lastweekTemp;


@synthesize activityIndicatorView;
@synthesize chart1_laoding_img;
@synthesize receivedData;
@synthesize returnBtn;

@synthesize plotSpaceFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"拥堵指数走势图";
        self.receivedData=[[NSMutableData data] retain];  
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    float offset = 0.0f ;
//    if(DEVICE_IS_IPHONE5){
//        offset = 0.0f;
//    }
    if (self.displayReturnButton) {
        offset = offset+0;
    }

    CGRect newRect = self.hostingView.frame ;
    newRect.size.height = self.hostingView.frame.size.height + offset;
    self.hostingView.frame = newRect;


    // 显示或者隐藏 退出按钮,然后调整显示位置
    self.returnBtn.hidden = !self.displayReturnButton;
    if (self.displayReturnButton){
        [self.view superview].backgroundColor=[UIColor clearColor];
        self.view.alpha = 1;
        
    }

    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.plotSpaceFrame = self.hostingView.frame;
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IFlyFlowerCollector OnPageStart:@"指数趋势图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录进入页面:%@", @"指数趋势图");
    CGRect frame =  self.hostingView.frame;
    //记录事件
    if (self.displayReturnButton){ //如果是从首页上来显示的
        [FlowerCollector OnEvent:SHOW_CHART_1_IN_MAIN_VIEW];
        self.arear1_view.hidden = YES;
        self.arear2_view.hidden = YES;
        // 调整Y轴位置和高度
        frame.origin.y = self.plotSpaceFrame.origin.y+50;
        frame.size.height = self.plotSpaceFrame.size.height+50;
        self.hostingView.frame = frame;
        // 隐藏about 按钮
        self.mapVC.aboutBtn.hidden = TRUE;
        //调整遮罩图层
        self.mapVC.maskView.alpha = 0.3;

    }else{//如果是从多个图表上来显示的
        [FlowerCollector OnEvent:SHOW_CHART_1_IN_CHARTS];
        self.arear1_view.hidden = NO;
        self.arear2_view.hidden = NO;
        //  显示天气预报
        [self performSelectorOnMainThread:@selector(showWeather) withObject:NULL waitUntilDone:NO];

    }


    self.activityIndicatorView.hidden = false;
    self.chart1_laoding_img.hidden = self.activityIndicatorView.hidden;
    

    xPlotRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat(46.0f) length:CPTDecimalFromFloat(290-48.0)] ;

    yPlotRange = [[CPTPlotRange alloc] initWithLocation:CPTDecimalFromFloat(0.0)length:CPTDecimalFromFloat(10.0)] ;
    [self generateGraphic];

    [self invokeData];

}




-(NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot
{
    if ( [plot.identifier isEqual:@"LastWeek"] )
    {
        return[points count];
    }else if ( [plot.identifier isEqual:@"Today"] ){
        return[points2 count];
    }
    return 0;
}

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    NSNumber *num = nil;
    NSString* key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
    if ( [plot.identifier isEqual:@"LastWeek"] )
    {
        num = [[points objectAtIndex:index] valueForKey:key];
    }else if ( [plot.identifier isEqual:@"Today"] ){
        num = [[points2 objectAtIndex:index] valueForKey:key];
    }
    return num;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
# pragma mark 调用远程rest服务，获得json对象后，赋值到CorePlot的数据中
-(void) invokeData{
    //   获得趋势图的json对象
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/congest_index/congest_index_of_city_for_date.json" ]];
    //异步请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    
}

//异步调用如果调用有错误，则出现此信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"ERROR with theConenction:%@",error );
    
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
    DLog(@"（在大数据量的时候，可能是一部分）获取的返回responseData 是:%@",[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
    [self.receivedData appendData:responseData];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
    DLog(@"%d",[self.receivedData length]);
    NSString * wsReturnValueString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    DLog(@"webserivce 调用结束，收取到的 全部报文是:%@",wsReturnValueString );
    DLog(@"WebService数据接受完成");

    NSError *error =nil ;
    NSString *current_congest_index = wsReturnValueString;
    AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
    NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
    if (error == nil)
    {
        NSMutableDictionary * dataInfo = [jsonDic objectForKey:@"dataset"];
        NSUInteger i = 1;
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init] ;
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        for(NSMutableDictionary * datas  in dataInfo)
        {
            if (i == 1)
            {
                for(NSMutableDictionary * data  in [datas objectForKey:@"data"])
                {
                    //            DLog(@"%@",[[data objectForKey:@"time_id"] description]);
                    [points addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"time_id"], @"x",[f numberFromString:[data objectForKey:@"value"]], @"y", nil]];
                }
            }else if( i ==2 ){
                for(NSMutableDictionary * data  in [datas objectForKey:@"data"])
                {
                    //            DLog(@"%@",[[data objectForKey:@"time_id"] description]);
                    [points2 addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"time_id"], @"x",[f numberFromString:[data objectForKey:@"value"]], @"y", nil]];
                }
            }
            i++;
        }
        [f release];
        [self renderPlot];
    }else{
        DLog(@"$$$$$$$%@", error);
        NSString * message = [NSString stringWithFormat:@"无法获取数据\n请再次点击按钮\n%@",[error description] ];
        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:NO forAlertType:AlertFailure];
        [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
        [alert show];

    }

    //   显示范围 从当前小时数的前个小时，到后4个小时。
    /*
    int hour = [Tools getCurrentHour];
    CPTPlotRange * initZoomXPlotRange = [[CPTPlotRange alloc]initWithLocation:CPTDecimalFromFloat((hour-1)*12) length:CPTDecimalFromFloat(49.0)] ;
    [self.plotSpace setPlotRange:initZoomXPlotRange forCoordinate:CPTCoordinateX ];
     */

    self.activityIndicatorView.hidden = true;
    self.chart1_laoding_img.hidden = self.activityIndicatorView.hidden;
}



# pragma mark 只支持竖屏显示
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation ==  UIInterfaceOrientationMaskPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma -(IBAction)closeBtnClicked:(id)sender 退出图表窗口

-(IBAction)closeBtnClicked:(id)sender{
    [self  dismissViewControllerAnimated:YES completion:nil];
}

#pragma 手指滑动
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft ) {
        DLog(@"Left");
        
    }else if (recognizer.direction==UISwipeGestureRecognizerDirectionRight ) {
        DLog(@"right");
        
    }
    Chart2ViewController * vc = [[Chart2ViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}



#pragma 生成图板区域
-(void) generateGraphic{
//    CGRect frame =  self.view.frame;
//    frame.size.height = frame.size.height*1/2;
//    
//    //图形要放在一个 CPTGraphHostingView 中，CPTGraphHostingView 继承自 UIView
//    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc] initWithFrame:frame];
//    
//    //把 CPTGraphHostingView 加到你自己的 View 中
//    [self.view addSubview:hostingView];
//    
    
    graph = [[CPTXYGraph alloc] initWithFrame:self.hostingView.frame];
    //graph.title =@"交通拥堵指数走势图";
    //CPTTheme *theme = [CPTTheme themeNamed:kCPTStocksTheme];
    //将主题应用于图表。当然，你也可以不在图表上使用任何主题，这样的话你可能无法看到坐标系。因为默认的背景色和坐标轴同为黑色。
//    CPTTheme * theme = [[[Chart1Theme alloc] init] autorelease];
//    [graph applyTheme:theme];
    //将self.view转换为一个CPTGraphHostingView对象（本来就是，因为我们在ViewController.xib中设置过了）。
//    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)self.view;
    //应用了主题的CPTXYGraph对象放到CPTGraphHostingView上，以便图表能够绘制在窗体中。
    hostingView.hostedGraph = graph;
    
    //构造一些数据，以便显示为散点图的形式
    points=[[NSMutableArray alloc]init ];
    points2 =[[NSMutableArray alloc]init ] ;
    
    // Paddings
    graph.paddingLeft   = 0.0f;
    graph.paddingRight  = 0.0f;
    graph.paddingTop    = 0.0f;
    graph.paddingBottom = 0.0f;
    
    // Plot area
    // 设置背景色
    graph.plotAreaFrame.fill          = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[self.view.backgroundColor CGColor]]];
    graph.plotAreaFrame.paddingTop    = 10.0;
    graph.plotAreaFrame.paddingBottom = 30.0;
    graph.plotAreaFrame.paddingLeft   = 30.0;
    graph.plotAreaFrame.paddingRight  = 5.0;
    graph.plotAreaFrame.cornerRadius  = 1.0;
    graph.plotAreaFrame.axisSet.borderLineStyle = [CPTLineStyle lineStyle];
    graph.plotAreaFrame.plotArea.fill = [CPTFill fillWithColor:[CPTColor blackColor]];
    
}

#pragma 设置图表显示格式,并且渲染
-(void) renderPlot{
    plotSpace =(CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction= YES;
    [plotSpace setDelegate:self];
    // 设置x,y坐标范围
    plotSpace.xRange = xPlotRange;
    plotSpace.yRange = yPlotRange;
    // 设置上周趋势图的绘图器
    CPTScatterPlot* boundLinePlot  = [[[CPTScatterPlot alloc] init] autorelease];
    // 设置当然趋势图的绘制器
    CPTScatterPlot* boundLinePlot1  = [[[CPTScatterPlot alloc] init] autorelease];
    //设置线形格式
    CPTMutableLineStyle* lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 0.1f;
    lineStyle.lineWidth =3.0f;
    lineStyle.lineColor = [CPTColor colorWithComponentRed:(79.0/255.0) green:(99.0/255.0) blue:(122.0/255.0) alpha:0.6f];
    boundLinePlot.dataLineStyle= lineStyle;
    boundLinePlot.identifier = @"LastWeek";
    boundLinePlot.dataSource = self;
    //设置线性格式2
    CPTMutableLineStyle* lineStyle2 = [CPTMutableLineStyle lineStyle];
    lineStyle2.miterLimit = 0.1f;
    lineStyle2.lineWidth = 3.0f;
    lineStyle2.lineColor = [CPTColor colorWithComponentRed:(16.0/255.0) green:(255.0/255.0) blue:(255.0/255.0) alpha:1.0f];
    boundLinePlot1.dataLineStyle= lineStyle2;
    boundLinePlot1.identifier = @"Today";
    boundLinePlot1.dataSource = self;
    
    CPTXYAxisSet* axisSet = (CPTXYAxisSet *)graph.axisSet; //1 获取图纸对象的坐标系；
    //固定xy轴的显示位置
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithRelativeOffset:0.0];
    axisSet.xAxis.axisConstraints = [CPTConstraints constraintWithRelativeOffset:0.0];
    
    
    // 设置x轴的显示
    CPTXYAxis* x   = axisSet.xAxis; //2 获取坐标系的x轴坐标；
    x.majorIntervalLength=CPTDecimalFromString(@"12"); //3 设置大刻度线的间隔单位；
    x.orthogonalCoordinateDecimal= CPTDecimalFromString(@"0"); //4 设置x坐标的原点（y轴将在此与x轴相交）
    x.minorTicksPerInterval   = 2; //5 设置小刻度线的间隔为每两个大刻度线之间分布有2个小刻度线
    //    NSArray* exclusionXRanges = [NSArray arrayWithObjects:
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99)length:CPTDecimalFromFloat(0.02)],
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99)length:CPTDecimalFromFloat(0.02)],
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99)length:CPTDecimalFromFloat(0.02)], nil]; //6
    //
    //    x.labelExclusionRanges= exclusionXRanges; //7 这两句将x轴上的某些点排除（即既不显示数字也不显示刻度线）。
    
    // 设置x，y轴的label的风格
    CPTMutableTextStyle*textStyle=[CPTMutableTextStyle textStyle];
    textStyle.color=[CPTColor whiteColor];
    textStyle.fontSize=10;
    
    //设置x轴显示刻度线
    CPTMutableLineStyle*lineStyle1 = [CPTMutableLineStyle lineStyle];
    lineStyle1.lineWidth = 0.5f;
    lineStyle1.lineColor = [CPTColor lightGrayColor];
    x.majorGridLineStyle= lineStyle1;
   
    // 设置X轴label
    x.labelTextStyle = textStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:288];
    for ( int  i = 1 ; i<=288 ;i++)
    {
        CPTAxisLabel *newLabel ;
        if(i == 48)
        {
            newLabel=[[CPTAxisLabel alloc] initWithText:@"4:00" textStyle:x.labelTextStyle];
        }else if (i== 72){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"6:00" textStyle:x.labelTextStyle];
        }else if (i== 96){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"8:00" textStyle:x.labelTextStyle];
        }else if (i== 120){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"10:00" textStyle:x.labelTextStyle];
        }else if (i== 144){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"12:00" textStyle:x.labelTextStyle];
        }else if (i== 168){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"14:00" textStyle:x.labelTextStyle];
        }else if (i== 192){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"16:00" textStyle:x.labelTextStyle];
        }else if (i== 216){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"18:00" textStyle:x.labelTextStyle];
        }else if (i== 240){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"20:00" textStyle:x.labelTextStyle];
        }else if (i== 264){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"22:00" textStyle:x.labelTextStyle];
        }else if (i== 288){
            newLabel=[[CPTAxisLabel alloc] initWithText:@"24:00" textStyle:x.labelTextStyle];
        }
        else{
            newLabel=[[CPTAxisLabel alloc] initWithText:@"" textStyle:x.labelTextStyle];
        }
        newLabel.tickLocation=[[NSNumber numberWithInt:i] decimalValue];
        newLabel.offset=x.labelOffset+x.majorTickLength;
        newLabel.rotation = 0;
        [labelArray addObject:newLabel];
        [newLabel release];
    }
    x.axisLabels=[NSSet setWithArray:labelArray];
    
    
    // 设置y轴的显示
    CPTXYAxis* y   = axisSet.yAxis; //2
    
    y.labelTextStyle = textStyle;
    
    y.majorIntervalLength=CPTDecimalFromString(@"2"); //3
    
    y.orthogonalCoordinateDecimal= CPTDecimalFromString(@"48"); //4
    
    y.minorTicksPerInterval   = 1; //5
    
    //    NSArray* exclusionYRanges = [NSArray arrayWithObjects:
    //
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(1.99)length:CPTDecimalFromFloat(0.02)],
    //
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.99)length:CPTDecimalFromFloat(0.02)],
    //
    //                               [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(2.99)length:CPTDecimalFromFloat(0.02)], nil]; //6
    
    //    y.labelExclusionRanges= exclusionYRanges; //7
    CPTFill *darkGreenBandFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[Tools getLevelColrorWithLevel:1].CGColor]];
    CPTFill *lightGreenBandFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[Tools getLevelColrorWithLevel:2].CGColor]];
    CPTFill *yellowBandFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[Tools getLevelColrorWithLevel:3].CGColor]];
    CPTFill *lightRedBandFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[Tools getLevelColrorWithLevel:4].CGColor]];
    CPTFill *darkRedBandFill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:[Tools getLevelColrorWithLevel:5].CGColor]];
    
    
    [y addBackgroundLimitBand:[CPTLimitBand limitBandWithRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0) length:CPTDecimalFromDouble(2.0)] fill:darkGreenBandFill]];
    [y addBackgroundLimitBand:[CPTLimitBand limitBandWithRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(2.0) length:CPTDecimalFromDouble(2.0)] fill:lightGreenBandFill]];
    [y addBackgroundLimitBand:[CPTLimitBand limitBandWithRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(4.0) length:CPTDecimalFromDouble(2.0)] fill:yellowBandFill]];
    [y addBackgroundLimitBand:[CPTLimitBand limitBandWithRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(6.0) length:CPTDecimalFromDouble(2.0)] fill:lightRedBandFill]];
    [y addBackgroundLimitBand:[CPTLimitBand limitBandWithRange:[CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(8.0) length:CPTDecimalFromDouble(2.0)] fill:darkRedBandFill]];
//    y.title =@"拥堵指数";
    
    [graph addPlot:boundLinePlot];
    [graph addPlot:boundLinePlot1];
    
}

//放大缩小的时候调用
-(CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
//限制缩放和移动的时候。不超过原始范围
    if ( coordinate == CPTCoordinateX)
    {
        if ([ xPlotRange containsRange:newRange])
        {
            //如果缩放范围在 原始范围内。则返回缩放范围
            return newRange;
            
        }else if([newRange containsRange:xPlotRange])
        {
            //如果缩放范围在原始范围外，则返回原始范围
            return xPlotRange;
        }
        else{
            //如果缩放和移动，导致新范围和元素范围向交叉。则要控制 左边或者右边超界的情况
            NSDecimalNumber *myXPlotLocationNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:xPlotRange.location];
            NSDecimalNumber *myXPlotLengthNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:xPlotRange.length];
            
            NSDecimalNumber *myNewRangeLocationNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:newRange.location];
            NSDecimalNumber *myNewRangeLengthNSDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:newRange.length];
            DLog(@"willChangePlotRangeTo  newRange :%@\n xplotRange is %@",newRange,xPlotRange);
            if ( myXPlotLocationNSDecimalNumber.doubleValue >= myNewRangeLocationNSDecimalNumber.doubleValue)
            {
                //限制左边不超界
                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:xPlotRange.location length:newRange.length];
                return returnPlot;
            }
            if ((myNewRangeLocationNSDecimalNumber.doubleValue + myNewRangeLengthNSDecimalNumber.doubleValue) > (myXPlotLengthNSDecimalNumber.doubleValue +myXPlotLocationNSDecimalNumber.doubleValue))
            {
                double offset = (myNewRangeLocationNSDecimalNumber.doubleValue + myNewRangeLengthNSDecimalNumber.doubleValue) -(myXPlotLengthNSDecimalNumber.doubleValue+myXPlotLocationNSDecimalNumber.doubleValue);
                //限制右边不超界
                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:[NSDecimalNumber numberWithDouble:(myNewRangeLocationNSDecimalNumber.doubleValue - offset)].decimalValue length:newRange.length];
//                CPTPlotRange * returnPlot = [[CPTPlotRange alloc ] initWithLocation:newRange.location length:xPlotRange.length];
                DLog(@"右边超界，超界 %f", offset);
                DLog(@"将要返回的 range 是：%@",returnPlot);
                return returnPlot;
            }
        }
        return newRange;
    }else{
        return yPlotRange;
    }
}



//显示天气预报
-(void)showWeather
{
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init] ;
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //   获得天气预报的json对象
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/weather_info/weather_info_by_date.json" ]];
    NSError *error =nil ;
    NSStringEncoding encoding;
    NSString * weather_index = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    if (error == nil)
    {
        AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:weather_index error:&error];
        NSMutableDictionary * dataInfo = [jsonDic objectForKey:@"data"];
        // 今日天气信息
        NSMutableDictionary * today = [dataInfo objectForKey:@"today"];
        todayString.text  = [@"今日：" stringByAppendingString:[today objectForKey:@"date"]];

    
        NSMutableDictionary * todayInfo = [today objectForKey:@"info"];
    
        @try {
            NSString * ctime = [todayInfo objectForKey:@"ctime"];
            if ( [ctime isEqualToString:@"18:00" ])
            {
                todayTemp1.text = [[NSString alloc] initWithFormat:@"↑%@",[todayInfo objectForKey:@"temp2"]];
                todayTemp2.text = [[NSString alloc] initWithFormat:@"↓%@",[todayInfo objectForKey:@"temp1"]];
                
            }else
            {
                todayTemp1.text = [[NSString alloc] initWithFormat:@"↑%@",[todayInfo objectForKey:@"temp1"]];
                todayTemp2.text = [[NSString alloc] initWithFormat:@"↓%@",[todayInfo objectForKey:@"temp2"]];
            }
            
            todayWeather.text = [todayInfo objectForKey:@"weather"];
            NSMutableDictionary * todaySK = [today objectForKey:@"sk"];
            todayTemp.text = [[NSString alloc] initWithFormat:@"↑%@", [todaySK objectForKey:@"temp"] ];
            // 上周天气信息
            NSMutableDictionary * lastweek = [dataInfo objectForKey:@"last_week"];
            lastweekString.text  = [@"上周同期：" stringByAppendingString:[lastweek objectForKey:@"date"]];
            
            NSMutableDictionary * lastweekInfo = [lastweek objectForKey:@"info"];
            
            ctime = [lastweekInfo objectForKey:@"ctime"];
            
            if ( [ctime isEqualToString:@"18:00" ])
            {

                lastweekTemp1.text = [[NSString alloc] initWithFormat:@"↑%@",((NSString *)[lastweekInfo objectForKey:@"temp2"])]; 
                lastweekTemp2.text = [[NSString alloc] initWithFormat:@"↓%@",[lastweekInfo objectForKey:@"temp1"]];
            }else{
                lastweekTemp1.text = [[NSString alloc] initWithFormat:@"↑%@",((NSString *)[lastweekInfo objectForKey:@"temp1"])];
                lastweekTemp2.text = [[NSString alloc] initWithFormat:@"↓%@",[lastweekInfo objectForKey:@"temp2"]];
            }
            lastweekWeather.text = [lastweekInfo objectForKey:@"weather"];
            
            NSMutableDictionary * lastweekSK = [lastweek objectForKey:@"sk"];
            lastweekTemp.text = [[NSString alloc] initWithFormat:@"%@℃", [lastweekSK objectForKey:@"temp"] ];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }else{
        DLog(@"$$$$$$$%@", error);
    }
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapVC.aboutBtn.hidden = NO;
    self.mapVC.maskView.alpha = 0;
    [IFlyFlowerCollector OnPageEnd:@"指数趋势图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录离开页面:%@", @"指数趋势图");
}


-(void)dealloc{
    self.mapVC = nil;
    [super dealloc];
}


@end
