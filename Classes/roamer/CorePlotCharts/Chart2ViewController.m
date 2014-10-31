//
//  Chart2ViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-20.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Chart2ViewController.h"

@interface Chart2ViewController ()
@end

@implementation Chart2ViewController

@synthesize piesCanvas;
@synthesize label_value_1;
@synthesize label_value_2;
@synthesize label_value_3;
@synthesize label_value_4;
@synthesize label_last_update;
@synthesize label_arear_1;
@synthesize label_arear_2;
@synthesize label_arear_3;
@synthesize label_arear_4;
@synthesize label_name_1;
@synthesize label_name_2;
@synthesize label_name_3;
@synthesize label_name_4;
@synthesize activityIndicatorView;
@synthesize receivedData ;
@synthesize pieChartCanvasView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

}

-(void) viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [FlowerCollector OnEvent:SHOW_CHART_2_IN_CHARTS];

    DLog(@"view did appear");
    self.activityIndicatorView.hidden = FALSE;
    [self drawCanvas ];
}

-(void) drawCanvas{
    [self drawTable];
    [self performSelectorOnMainThread:@selector(drawPies) withObject:NULL waitUntilDone:NO];
}

-(void) drawPies{
    Canvas *canvas = [[Canvas alloc] initWithFrame:self.pieChartCanvasView.frame];
    [self.view addSubview:canvas];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 画指标项部分
-(void) drawTable{
  
    self.activityIndicatorView.hidden = FALSE;
    //    调用远程方法，获得指数数据
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    NSURL *url = [[NSURL alloc] initWithString: [[Tools getServerHost] stringByAppendingString:@"/traffic_index/traffic_index_data_for_date.json"] ];
    DLog(@"开始调用的url是:%@",[url absoluteString] );
    //异步请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

//异步调用如果调用有错误，则出现此信息
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    DLog(@"ERROR with theConenction:%@",error );
    self.activityIndicatorView.hidden = true;
    
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
    NSString * wsReturnValueString = [[NSString alloc] initWithData:self.receivedData encoding:NSUTF8StringEncoding];
    DLog(@"webserivce 调用结束，收取到的 全部报文是:%@",wsReturnValueString );
    DLog(@"WebService数据接受完成");
    NSString *current_congest_index = wsReturnValueString;
    NSError *error =nil ;
    if (error == nil) {
        AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
        DLog(@"远程方法返回：%@",current_congest_index);
        for ( NSMutableDictionary * item in jsonDic)
        {
            int display  = [((NSNumber *)[item objectForKey:@"display_order"]) intValue ];
            switch (display) {
                case 0:
                {
                    label_value_1.text =(NSString *) [item objectForKey:@"index_value"];
                    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
                    NSTimeInterval seconds5Minutes = 5 * 60;
                    NSDate* updateTime = [[dateFormatter dateFromString:(NSString *)[item objectForKey:@"record_date"]] dateByAddingTimeInterval:seconds5Minutes];
                    if (updateTime == nil)
                    {
                        label_last_update.text =@"";
                    }else{
                        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                        label_last_update.text =[[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:updateTime ]];
                    }
                    label_arear_1.backgroundColor= [Tools getLevelColrorWithCongestIndexString:(NSString *) [item objectForKey:@"index_value"]];
                    break;
                }
                case 1:
                    label_value_2.text =(NSString *) [item objectForKey:@"index_value"];
                    break;
                case 2:
                    label_value_3.text =(NSString *) [item objectForKey:@"index_value"];
                    break;
                case 3:
                    label_value_4.text =(NSString *) [item objectForKey:@"index_value"];
                    break;
                default:
                    break;
            }
        }
        DLog(@"处理完成！");
        self.activityIndicatorView.hidden = TRUE;
        
    }else{
        DLog(@"$$$$$$$%@", error);
    }

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IFlyFlowerCollector OnPageStart:@"主要交通指标图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录进入页面:%@", @"主要交通指标图");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IFlyFlowerCollector OnPageEnd:@"主要交通指标图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录离开页面:%@", @"主要交通指标图");
}




# pragma mark 只支持竖屏显示
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation ==  UIInterfaceOrientationMaskPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
