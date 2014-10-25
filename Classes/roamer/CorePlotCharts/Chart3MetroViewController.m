//
//  Chart3MetroViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-6-2.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Chart3MetroViewController.h"

@interface Chart3MetroViewController ()
{
    NSMutableArray * itemArray;
    IBOutlet UIView * v1;
    IBOutlet UIView * v2;
    IBOutlet UIView * v3;
    IBOutlet UIView * v4;
    IBOutlet UIView * v5;
    IBOutlet UIView * v6;
    IBOutlet UILabel * label_last_update;
    UIActivityIndicatorView * activityIndicatorView;
}
@property(nonatomic,retain)     NSMutableArray * itemArray;
@property(nonatomic,retain) IBOutlet UIView * v1;
@property(nonatomic,retain) IBOutlet UIView * v2;
@property(nonatomic,retain) IBOutlet UIView * v3;
@property(nonatomic,retain) IBOutlet UIView * v4;
@property(nonatomic,retain) IBOutlet UIView * v5;
@property(nonatomic,retain) IBOutlet UIView * v6;
@property(nonatomic,retain) IBOutlet UILabel* label_last_update;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView * activityIndicatorView;


-(void) getData;

@end

@implementation Chart3MetroViewController
@synthesize itemArray;
@synthesize v1;
@synthesize v2;
@synthesize v3;
@synthesize v4;
@synthesize v5;
@synthesize v6;
@synthesize label_last_update;
@synthesize activityIndicatorView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (DEVICE_IS_IPHONE5)
    {
        [Tools offsetUIViewYForIPhone5:self.v1 withOffset:20.0f];
        [Tools offsetUIViewYForIPhone5:self.v2 withOffset:20.0f];
        [Tools offsetUIViewYForIPhone5:self.v3 withOffset:45.0f];
        [Tools offsetUIViewYForIPhone5:self.v4 withOffset:45.0f];
        [Tools offsetUIViewYForIPhone5:self.v5 withOffset:70.0f];
        [Tools offsetUIViewYForIPhone5:self.v6 withOffset:70.0f];
        
        [self expandFrame:self.v1 withOffset:20];
        [self expandFrame:self.v2 withOffset:20];
        [self expandFrame:self.v3 withOffset:20];
        [self expandFrame:self.v4 withOffset:20];
        [self expandFrame:self.v5 withOffset:20];
        [self expandFrame:self.v6 withOffset:20];
        
        [Tools offsetUIViewYForIPhone5:self.activityIndicatorView withOffset:80.0f];
    }
    DLog(@"viewDidLoad");
    // Do any additional setup after loading the view from its nib.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [FlowerCollector OnEvent:SHOW_CHART_3_IN_CHARTS];

    self.activityIndicatorView.hidden = FALSE;
    [self performSelectorOnMainThread:@selector(getData) withObject:nil waitUntilDone:NO];
}

-(void) expandFrame:(UIView *) uiView withOffset:(float)offset{
    CGRect newFrame  = uiView.frame ;
    newFrame.size.height =newFrame.size.height + offset;
    uiView.frame=   newFrame;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 获取远程数据
-(void) getData{
    DLog(@"调用远程方法，获得指数数据");
    itemArray =[[NSMutableArray alloc]init ];
    //    调用远程方法，获得指数数据
    NSNumberFormatter * f = [[[NSNumberFormatter alloc] init] autorelease];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/congest_index/congest_index_of_net_for_date.json" ] ];
    NSError *error =nil ;
    NSStringEncoding encoding;
    //NSString *my_string = [[NSString alloc] initWithContentsOfURL:url
    //                                                     encoding:NSUTF8StringEncoding
    //                                                        error:&error];
    NSString *current_congest_index = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    if (error == nil) {
        AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
        for ( NSMutableDictionary * item in jsonDic)
        {
            [itemArray addObject:item];
        }
        [self drawCell];
    }else{
        DLog(@"无法解析远程调用的json");
    }
    self.activityIndicatorView.hidden = TRUE;
}

#pragma 画出各个方格
-(void) drawCell{
    for (int i = 0 ; i< self.itemArray.count; i++) {
        if ( i == 0)
        {
            NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
            [dateFormatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+08:00'"];
            NSTimeInterval seconds5Minutes = 5 * 60;
            NSDate* updateTime = [[dateFormatter dateFromString:(NSString *)[[itemArray objectAtIndex:i] objectForKey:@"record_date"]] dateByAddingTimeInterval:seconds5Minutes];
            if (updateTime == nil)
            {
                label_last_update.text =@"";
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                label_last_update.text =[[NSString alloc] initWithFormat:@"%@", [dateFormatter stringFromDate:updateTime ]];
            }
        }
        
        NSDictionary * rowData =  [itemArray objectAtIndex:i];
        UILabel * name = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 120, 30)];
        UILabel * indexLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 45, 60, 30)];
        UILabel * indexDesc = [[UILabel alloc]initWithFrame:CGRectMake(60, 88, 80, 20)];
        if (DEVICE_IS_IPHONE5)
        {
            [self expandFrame:indexLabel withOffset:10.0f];
            [self expandFrame:indexDesc withOffset:20.0f];
        }
        name.text = [rowData objectForKey:@"net_name"];
        float index  = ((NSNumber  *)[rowData objectForKey:@"congest_index"]).floatValue ;
        indexLabel.text = [[NSString alloc] initWithFormat:@"%.1f",index];
        NSString * description = @"";
        UIColor*  color  = nil;
        
        color = [Tools getLevelColrorWithCongestIndex:index];
        description = [Tools getLevelDescriptionWithCongestIndex:index];
        

        indexLabel.font =  [UIFont fontWithName:@"Arial" size:30];
        indexLabel.backgroundColor=color;
        indexLabel.textAlignment = NSTextAlignmentCenter;
        name.font =  [UIFont fontWithName:@"Arial" size:24];
        name.backgroundColor=color;
        indexDesc.text = description;
        indexDesc.font =  [UIFont fontWithName:@"Arial" size:18];
        indexDesc.backgroundColor=color;
        indexDesc.textAlignment = NSTextAlignmentRight;
        switch (i+1) {
            case 1:
                v1.backgroundColor=color;
                [v1 addSubview:name];
                [v1 addSubview:indexLabel];
                [v1 addSubview:indexDesc];
                break;
            case 2:
                v2.backgroundColor=color;
                [v2 addSubview:name];
                [v2 addSubview:indexLabel];
                [v2 addSubview:indexDesc];
                break;
            case 3:
                v3.backgroundColor=color;
                [v3 addSubview:name];
                [v3 addSubview:indexLabel];
                [v3 addSubview:indexDesc];
                break;
            case 4:
                v4.backgroundColor=color;
                [v4 addSubview:name];
                [v4 addSubview:indexLabel];
                [v4 addSubview:indexDesc];
                break;
            case 5:
                v5.backgroundColor=color;
                [v5 addSubview:name];
                [v5 addSubview:indexLabel];
                [v5 addSubview:indexDesc];
                break;
            case 6:
                v6.backgroundColor=color;
                [v6 addSubview:name];
                [v6 addSubview:indexLabel];
                [v6 addSubview:indexDesc];
                break;
            default:
                break;
        }
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IFlyFlowerCollector OnPageStart:@"区域拥堵指数图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录进入页面:%@", @"区域拥堵指数图");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IFlyFlowerCollector OnPageEnd:@"区域拥堵指数图"];
    [IFlyFlowerCollector Flush];
    DLog(@"记录离开页面:%@", @"区域拥堵指数图");
}



@end
