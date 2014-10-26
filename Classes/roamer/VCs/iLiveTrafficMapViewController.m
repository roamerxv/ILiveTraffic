//
//  iLiveTrafficMapViewController.m
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
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
//

#import "iLiveTrafficMapViewController.h"
#import "iLiveTrafficMenuViewController.h"
#import "PPRevealSideViewController.h"
#import "NSDateFormatter+Extras.h"
#import "UIViewController-Extras.h"




@interface iLiveTrafficMapViewController (){
      FBShimmeringView *_shimmeringView;
//      UILabel *_logoLabel;
}

@end

@implementation iLiveTrafficMapViewController

@synthesize mapView = _mapView;
@synthesize aiv;
@synthesize timeLabel;
@synthesize cityCongestLabel;
@synthesize cityCongestDescLabel;
@synthesize refreshBtn;
@synthesize slider;
@synthesize dataTimeLabel;
@synthesize siView;
@synthesize window;

@synthesize scaleText;
@synthesize inputScale;

@synthesize currentArearCongestIndex;
@synthesize currentArearCode;
@synthesize oldArearCode;
@synthesize currentArearName;

@synthesize locationManager;
@synthesize currentLocation;
@synthesize isLocationMode;
@synthesize arearCongestIndex;
@synthesize locationBtn;
@synthesize locateCenterBtn;
@synthesize customizeBtn;
@synthesize aboutBtn;
@synthesize currentScale;
@synthesize ttsBtn;
@synthesize downloadMapBtn;
@synthesize receivedData;

@synthesize queryTask1;
@synthesize query1;
@synthesize queryTask2;
@synthesize query2;
@synthesize query1Completed;
@synthesize query2Completed;

@synthesize graphicsLayer;
@synthesize baseMapLayer;

@synthesize _iFly_uploader;
@synthesize _iFlySpeechRecognizer;

@synthesize isCheckTPKFileByShowButton;

@synthesize maskView;

static bool isSilenceCheckTPKVersion  = true;


//显示图表
-(IBAction)chartBtnClicked:(id)sender{
//    Chart4ViewController *vc = [[[Chart4ViewController alloc] init] autorelease];
//    Chart3ViewController *vc = [[[Chart3ViewController alloc] init] autorelease];
//    Chart2ViewController *vc = [[[Chart2ViewController alloc] init] autorelease];
//    Chart1ViewController *vc =[[[Chart1ViewController alloc] init] autorelease];
//    Chart3MetroViewController *vc =[[[Chart3MetroViewController alloc] init] autorelease];
//    [self presentModalViewController:vc animated:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [[UIColor whiteColor] autorelease];
    
    //创建一个NSInvocationOperation对象，并初始化到方法
    //在这里，selector参数后的值是你想在另外一个线程中运行的方法（函数，Method）
    //在这里，object后的值是想传递给前面方法的数据
//    NSInvocationOperation* theOp = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(showPlotCoreChart:) object:NULL];
    
    // 下面将我们建立的操作“Operation”加入到本地程序的共享队列中（加入后方法就会立刻被执行）
    // 更多的时候是由我们自己建立“操作”队列
//    [[[iLiveTrafficAppDelegate shared] queue ] addOperation:theOp];

    [self showPlotCoreChart:self] ;
    
}



#pragma mark 用TabBar的方式来切换图表
-(IBAction)showPlotCoreChart:(id)data
{
    TabbarViewController * chartMainTabBarViewController = [[[TabbarViewController alloc]init] autorelease];
    [self presentViewController:chartMainTabBarViewController animated:YES completion:nil];
}


-(void)refrestDataPeriodical{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshBtnClicked:) object:nil];
    [self performSelector:@selector(refrestDataPeriodical) withObject:nil afterDelay:refreshTime];
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
    DLog(@"调用结束，收取到的 全部报文是:%@",wsReturnValueString );
    AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
    NSError *error =nil ;
    NSMutableDictionary * results = [parser objectWithString:wsReturnValueString error:&error];
    if(!error)
    {
        NSString * result_count = [results objectForKey:@"result_length"];
        if ([result_count intValue] > 0)
        {
            //    弹出查询路段的车速表单视图
            MainRoadSpeedViewController * mainRoadSpeedViewController = [[[MainRoadSpeedViewController alloc] init] autorelease];
            [mainRoadSpeedViewController  inputData:wsReturnValueString];
            [mainRoadSpeedViewController resizeView:50.0f];
            [self presentViewController:mainRoadSpeedViewController animated:YES completion:nil];
        }else if( [result_count intValue]  == 0)
        {
            NSString * roadNotFound = [[NSString alloc] initWithFormat:@"没有[%@]的数据" ,[results objectForKey:@"result_items"] ];
            [_popUpView setText: roadNotFound];
            [self.view addSubview:_popUpView];

        }
    }
    [parser dealloc];
}

#pragma mark 语音识别
-(void)speechRecognizer:(id)sender
{
    DLog(@"开始语音识别");
    [_popUpView setText: @"正在听取"];
    [self.ttsBtn setImage:[UIImage imageNamed:@"voice_recoginzing.png"] forState:UIControlStateNormal];
    [self.view addSubview:_popUpView];
    //设置为录音模式
    [self._iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    bool ret = [_iFlySpeechRecognizer startListening];

    if (ret) {
    }
    else
    {
        [_popUpView setText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
        [self.view addSubview:_popUpView];
    }


}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{

    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];

    [_popUpView setText: vol];
    [self.view addSubview:_popUpView];
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    [_popUpView setText: @"正在录音"];
    [self.view addSubview:_popUpView];
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调
 *
 * @see
 */
- (void) onEndOfSpeech
{
    [self.ttsBtn setImage:[UIImage imageNamed:@"voice_tts_button.png"] forState:UIControlStateNormal];
    [_popUpView setText: @"停止录音"];
    [self.view addSubview:_popUpView];
}



/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    [self.ttsBtn setImage:[UIImage imageNamed:@"voice_tts_button.png"] forState:UIControlStateNormal];
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];

    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }

    NSString * resultFromJson =  [[ISRDataHelper shareInstance] getResultFromJson:resultString];

    DLog(@"听写结果：‘%@’",  resultFromJson);
    if (resultFromJson == nil  || [resultFromJson stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [resultFromJson isEqualToString:@"。" ] || [resultFromJson isEqualToString:@"."] )
    {
//        [_popUpView setText: @"没有识别到有效的内容！"];
//        [self.view addSubview:_popUpView];
    }else
    {
        NSString * urlString = [[NSString alloc] initWithFormat: [[Tools getServerHost] stringByAppendingString:@"/main_road_speed/main_road_speed_for_name.json?roadName=%@"], [resultFromJson stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] ];
        DLog(@"调用的urlString：%@",urlString  );

        NSURL *url = [[NSURL alloc] initWithString:urlString];
        //异步请求
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];


    }


}


/*识别会话错误返回代理
 @ param error 错误码
 */
- (void)onError: (IFlySpeechError *) error {
    NSString *text ;
    if (error.errorCode ==0 ) {
        text = @"识别完成！";
    }
    else
    {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }

    [_popUpView setText: text];
//    [self.view addSubview:_popUpView];
}


#pragma mark 获得当前视图中心点 对应的区域代码
-(int) getCurrentArearCode
{
    // 2014年8月需求：不用再去获得当前所在区的拥堵指数
    //CGPoint screenPoint = [self.mapView center ];
    //AGSPoint * agsPoint = [self.mapView toMapPoint:screenPoint];
    //    DLog(@"当前的screenPoint 中的x是%f,y是%f", screenPoint.x, screenPoint.y);
    //int arearCode = [Tools getArearCodeWithX:agsPoint.x withY:agsPoint.y];
    double xmin = self.mapView.visibleAreaEnvelope.xmin;
    double xmax = self.mapView.visibleAreaEnvelope.xmax;
    double ymin = self.mapView.visibleAreaEnvelope.ymin;
    double ymax = self.mapView.visibleAreaEnvelope.ymax;
    //DLog(@"当前的agsPoint(地理坐标) 中中心点的x是%f,y是%f\n,区域的xmin是%f, xmax是 %f, ymin 是： %f, ymax 是：%f,对应的城区代码是%d", agsPoint.x, agsPoint.y,xmin,xmax,ymin,ymax,arearCode);
    //设置地图的中心和 区域大小
    //envelopeWithXmin:120.027288000642
    //ymin:30.0734000002107
    //xmax:120.372462000422
    //ymax:30.3930554338621
    [[NSUserDefaults standardUserDefaults] setDouble:xmin forKey:@"visibleAreaEnvelope.xmin"];
    [[NSUserDefaults standardUserDefaults] setDouble:xmax forKey:@"visibleAreaEnvelope.xmax"];
    [[NSUserDefaults standardUserDefaults] setDouble:ymin forKey:@"visibleAreaEnvelope.ymin"];
    [[NSUserDefaults standardUserDefaults] setDouble:ymax forKey:@"visibleAreaEnvelope.ymax"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //return arearCode;
    return 0;
}

#pragma mark 指定缩放比例
-(IBAction)inputScale:(id)sender
{
    //DLog(@"输入的缩放比例是 ：%f", [self.inputScale.text doubleValue]);
    DLog(@"输入的缩放比例是 ：%@", self.inputScale.text);
    [self.mapView zoomToScale:[[self.inputScale text] doubleValue] animated:YES ]   ;
}


#pragma mark 获取指定区域的拥堵指数，并且刷新界面
// 2014年8月需求，不再需要此功能
-(void) refreshCurrentArearCongestIndexWithNetCode:(int)currentNetCode
{
    /*
    DLog(@"刷新指定城区的拥堵指数");
    @try {
        NSMutableArray* itemArray =[[NSMutableArray alloc]init ];
        NSNumberFormatter * f = [[[NSNumberFormatter alloc] init] autorelease];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSError *error =nil ;
        AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:self.arearCongestIndex error:&error];
        for ( NSMutableDictionary * item in jsonDic)
        {
            [itemArray addObject:item];
        }
        for (int i = 0 ; i< itemArray.count; i++) {
            NSDictionary * rowData =  [itemArray objectAtIndex:i];
            int netCode = ((NSNumber  *)[rowData objectForKey:@"net_code"]).intValue;
            if (netCode == currentNetCode)
            {
                float index  = ((NSNumber  *)[rowData objectForKey:@"congest_index"]).floatValue ;
                self.currentArearCongestIndex.textColor = [Tools getLevelColrorWithCongestIndex:index];
                self.currentArearCongestIndex.text = [[NSString alloc] initWithFormat:@"%.1f",index];
                self.currentArearName.text = (NSString *)[rowData objectForKey:@"net_name"];
            }
        }
    }
    @catch (NSException *exception) {
         self.currentArearCongestIndex.text = @"";
        self.currentArearName.text = @"";
    }
    @finally {
        
    }
    */
}


-(IBAction)changeBaseMapLayer:(id)sender{
    DLog(@"开始改变底图");
    //基础底图，离线方式
    DLog(@"开始删除原有的底图");
    [self.mapView removeMapLayerWithName:@"BaseMap"];
    DLog(@"开始载入新的底图");
    //基础底图，离线方式
    self.baseMapLayer = nil;
    NSString * tpkName = [ [NSString alloc] initWithFormat:@"%@-%@",BASE_MAP_TPK_NAME_USED_BY_ARCGIS,[[NSUserDefaults standardUserDefaults ]stringForKey:@"LocalBaseMapTPKVersion"]];
    @try {
        self.baseMapLayer = [AGSLocalTiledLayer localTiledLayerWithName:tpkName];
        [self.baseMapLayer refresh];
        [self.mapView insertMapLayer:self.baseMapLayer withName:@"BaseMap" atIndex:0];
        AGSEnvelope * hanzhouTrafficEnv = [AGSEnvelope
                                           envelopeWithXmin:CENTER_XMIN
                                           ymin:CENTER_YMIN
                                           xmax:CENTER_XMAX
                                           ymax:CENTER_YMAX
                                           spatialReference:self.mapView.spatialReference
                                           ];
        [self.mapView zoomToEnvelope:hanzhouTrafficEnv animated:YES];
        //地图下载完成，改变下载按钮的图片
        [self.downloadMapBtn setImage:[UIImage imageNamed:@"download_map.png"] forState:UIControlStateNormal];
        [self.downloadMapBtn setNeedsDisplay];
    }
    @catch (NSException *exception) {
        NSLog(@"载入离线地图的时候发生错误！\n%@",exception.description);
    }
    @finally {

    }


   }

//在地图上定位道路
-(void)locateRoadOnMap:(id)sender{
    [self.graphicsLayer removeAllGraphics];
    self.query1Completed = false;
    self.query2Completed = false;
    NSArray * finegrits = (NSArray *)[sender object];
    NSMutableArray * whereArray = [NSMutableArray arrayWithCapacity:1];
    DLog(@"将要定位的路段是：%@",finegrits);
    for (NSDictionary * finegrit in finegrits) {
        NSNumber *  link_id = (NSNumber *)  [finegrit objectForKey:@"t#link_id"];
        NSNumber * from_node_id = (NSNumber * )  [finegrit objectForKey:@"t#from_node_id"];
        NSNumber *  to_node_id = (NSNumber *)  [finegrit objectForKey:@"t#to_node_id"];
        NSString * whereString = [ NSString stringWithFormat:@"(ID = %@ and FNODE_ = %@ and TNODE_ = %@)",link_id.stringValue, from_node_id.stringValue,to_node_id.stringValue ];
        DLog(@"%@",whereString);
        [whereArray addObject: whereString];
    }

    [MMProgressHUD showWithTitle:@"注意" status:@"正在进行道路定位!"];

    //set up query task against layer, specify the delegate
    self.query1.where = [whereArray componentsJoinedByString:@" or "];
    [self.queryTask1 executeWithQuery:self.query1];
    
    self.query2.where = query1.where;
    [self.queryTask2 executeWithQuery:self.query2];
    DLog(@"查询条件是:%@",query1.where);

}

-(void) queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error{
    [MMProgressHUD dismiss];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误" message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

//arcgis query task 结束以后调用
-(void) queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet
{
    if ([queryTask isEqual:self.queryTask1]){
        DLog(@"正在查询的url是[%@],查询的任务是1",queryTask.URL);
        self.query1Completed = true;
    }else if ([queryTask isEqual:self.queryTask2]){
        DLog(@"正在查询的url是[%@],查询的任务是2",queryTask.URL)
        self.query2Completed = true;
    }else{
        DLog(@"！！！！未知的queryTask");
    }
    if ( featureSet.features == nil || featureSet.features.count == 0){
        DLog(@"没有查询到对应的道路");
        [MMProgressHUD showWithTitle:@"注意" status:@"无法在地图上定位到此道路!"];
        double delayInSeconds = MMProgressHUD_DELAY_SECONDS;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MMProgressHUD dismiss];
        });
        return;
    }

    DLog(@"查询到%d条记录",featureSet.features.count)
    AGSSimpleLineSymbol *fillSym = [AGSSimpleLineSymbol simpleLineSymbol];
    fillSym.color = [UIColor clearColor];

    for(int i=0; i < featureSet.features.count; i++)
    {
        AGSGraphic *gra = [featureSet.features objectAtIndex:i];
        gra.symbol = fillSym;
        [self.graphicsLayer addGraphic:gra];
    }
    if ( self.query1Completed == self.query2Completed && self.query1Completed == TRUE)
    {
        //开始缩放到路段集合
        if (self.graphicsLayer.graphics != NULL && self.graphicsLayer.graphics.count >=1) {
            //accumulate the min/max
            double xmin = ((AGSGraphic *)self.graphicsLayer.graphics[0]).geometry.envelope.xmin;
            double ymin = ((AGSGraphic *)self.graphicsLayer.graphics[0]).geometry.envelope.ymin;
            double xmax = ((AGSGraphic *)self.graphicsLayer.graphics[0]).geometry.envelope.xmax;
            double ymax = ((AGSGraphic *)self.graphicsLayer.graphics[0]).geometry.envelope.ymax;
            for (int i=0;i<self.graphicsLayer.graphics.count;i++) {
                if (((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.xmin < xmin)
                    xmin = ((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.xmin;

                if (((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.xmax > xmax)
                    xmax = ((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.xmax;

                if (((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.ymin < ymin)
                    ymin = ((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.ymin;

                if (((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.ymax > ymax)
                    ymax = ((AGSGraphic *)self.graphicsLayer.graphics[i]).geometry.envelope.ymax;
            }

            AGSMutableEnvelope *extent = [AGSMutableEnvelope envelopeWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:self.mapView.spatialReference];
            [extent expandByFactor:1.5];

            //  画一个方框,就是在graphicsLayer中加入一个 画好方框的graphic
            AGSCompositeSymbol *symbol = [AGSCompositeSymbol compositeSymbol];
            AGSSimpleLineSymbol *lineSymbol = [[AGSSimpleLineSymbol alloc] init];
            lineSymbol.color = [UIColor colorWithRed:0.286 green:0.690 blue:0.838 alpha:0.800];
            lineSymbol.width = 2;
            [symbol addSymbol:lineSymbol];
            AGSSimpleFillSymbol *fillSymbol = [[AGSSimpleFillSymbol alloc] init];
            fillSymbol.color = [UIColor colorWithRed:0.839 green:0.840 blue:0.422 alpha:0.200];
            [symbol addSymbol:fillSymbol];

            [self.graphicsLayer addGraphic:[AGSGraphic graphicWithGeometry:extent symbol:symbol attributes:nil]];

            // 主线程刷新界面开始
            if ([NSThread isMainThread])
            {
                [extent expandByFactor:2.0];
                [self.mapView zoomToEnvelope:extent animated:YES];
            }
            else
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Update UI in UI thread here
                    [extent expandByFactor:2.0];
                    [self.mapView zoomToEnvelope:extent animated:YES];

                });
            }
            // 主线程刷新界面结束

        }
        [MMProgressHUD dismiss];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self becomeFirstResponder];
    //获取全市拥堵指数和获取各个区域拥堵指数(通过线程方法)
    [self handleTimer:nil];
    //检查地图包版本，进行按钮图片的修改（逻辑在回调函数里面实现，这里定义一个开关键）
    isCheckTPKFileByShowButton = true;
    [Tools asynchronousQueryServerBaseMapTpkFileVersion];

}



- (void) layerDidLoad:(AGSLayer*) layer
{
    DLog(@"layer : %@ 载入完成",layer);
}


- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

//设置 shimmer view的参数
- (void)viewWillLayoutSubviews
{
//    [super viewWillLayoutSubviews];
//    CGRect shimmeringFrame = self.jamLabel.bounds;
//    shimmeringFrame.origin.y = self.view.frame.size.height - 80;
//    shimmeringFrame.origin.x = 10;
//    _shimmeringView.frame =  shimmeringFrame;
//    _shimmeringView.backgroundColor = [UIColor clearColor];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.touchDelegate=self;
    isSilenceCheckTPKVersion = true;
    
    //注册监听事件，用于在地图上定位路段
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(locateRoadOnMap:)
               name:@"locateOnMap"
             object:nil];
    //注册监听事件，用于重新载入底图
    [nc addObserver:self
           selector:@selector(changeBaseMapLayer:)
               name:@"reloadBaseMap"
             object:nil];
    //定义 query task
    NSString * roadLayerURL1=[baseMapServiceURL stringByAppendingString:@"/3"];
    NSString * roadLayerURL2=[baseMapServiceURL stringByAppendingString:@"/4"];
    DLog(@"查询的url是：%@\n%@",roadLayerURL1,roadLayerURL2);
    self.queryTask1 = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:roadLayerURL1]];
    self.queryTask1.delegate = self;
    self.queryTask2 = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:roadLayerURL2]];
    self.queryTask2.delegate = self;

    //return all fields in query
    self.query1 = [AGSQuery query];
    self.query1.outFields = [NSArray arrayWithObjects:@"*",nil];
    self.query1.returnGeometry = YES;

    self.query2 = [AGSQuery query];
    self.query2.outFields = [NSArray arrayWithObjects:@"*",nil];
    self.query2.returnGeometry = YES;

    
    //显示Shimmer视图
//    _shimmeringView = [[FBShimmeringView alloc] init];
//    _shimmeringView.shimmering = YES;
//    _shimmeringView.shimmeringBeginFadeDuration = 0.8;
//    _shimmeringView.shimmeringOpacity = 0.8;
//    [self.mapView addSubview:_shimmeringView];
//    
//    _shimmeringView.contentView = jamLabel;
    //显示Shimmer视图结束
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingRight];

    if (locationManager==nil)
	{
		locationManager =[[CLLocationManager alloc] init];
	}
	
    self.receivedData=[[NSMutableData data] retain];  
    
    //讯飞APP 配置 begin
    //开始进行用户词表的上传
    //创建上传对象
    self._iFly_uploader = [[IFlyDataUploader alloc] init];
    //生成用户词表对象
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
        //设置参数
    [self._iFly_uploader  setParameter:@"iat" forKey:@"sub"];
    [self._iFly_uploader  setParameter:@"userword" forKey:@"dtt"];
    [self._iFly_uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
    {
        //接受返回的grammerID和error
        [self onUploadFinished:grammerID error:error];
    } name:NAME data:[iFlyUserWords toString]];

    _popUpView = [[PopupView alloc]initWithFrame:CGRectMake(100, 300, 0, 0)];
    _popUpView.ParentView = self.view;


    self._iFlySpeechRecognizer = [RecognizerFactory CreateRecognizer:self Domain:@"iat"];

    [self._iFlySpeechRecognizer setParameter: @"0" forKey:@"asr_ptt"]; //识别语音不返回标点， 1是返回标点，0是不返回标点
    //讯飞APP 配置 end


	if ([CLLocationManager locationServicesEnabled])
	{
		locationManager.delegate=self;
		locationManager.desiredAccuracy=kCLLocationAccuracyBest;
		locationManager.distanceFilter=10.0f;
	}
    self.isLocationMode = false;
    
    DLog(@"view did loaded");
    // Do any additional setup after loading the view from its nib.
    
//    [self.mapView initEvent];
    self.aiv.hidden = YES;

    self.revealSideViewController.delegate = self;
    
    [self.siView setVc:self];
    self.siView.backgroundColor = [UIColor clearColor];
    [self becomeFirstResponder];
    
    //    [self makeTipView];
    // 注册arcgis app
    // Set the client ID
    NSError *error = nil;
    [AGSRuntimeEnvironment setClientID:ARCGIS_APP_CLIENT_ID error:&error];
    if(error){
        // We had a problem using our client ID
        NSLog(@"Error using client ID : %@",[error localizedDescription]);
    }
    
    //在线式的基础底图
//    NSURL *url_base = [NSURL URLWithString:baseMapServiceURL];
//    AGSTiledMapServiceLayer *baseLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url_base];
//    [self.mapView addMapLayer:baseLayer withName:@"BaseLayer"];
    
    //基础底图，离线方式
    
    [Tools initLocalTiledLayerInMapView:self.mapView
                              withLayer:self.baseMapLayer];
    
    //载入动态交通图层
    [Tools addTrafficLayerInMapView:self.mapView ];
    
    //设置动态图层透明度
    //    self.mapView.alpha = 0.3;
    //    dynamicLayer.alpha = 0.3;
    AGSSpatialReference * spatialReference = [AGSSpatialReference spatialReferenceWithWKID:4326];

    AGSEnvelope * hanzhouTrafficEnv =nil;
    if ([[NSUserDefaults standardUserDefaults] doubleForKey:@"visibleAreaEnvelope.xmin"] == 0.0 )
    {
        hanzhouTrafficEnv = [AGSEnvelope
                             envelopeWithXmin:CENTER_XMIN
                             ymin:CENTER_YMIN
                             xmax:CENTER_XMAX
                             ymax:CENTER_YMAX
                             spatialReference:spatialReference
                             ];

    }else{
        hanzhouTrafficEnv = [AGSEnvelope
                                       envelopeWithXmin:[[NSUserDefaults standardUserDefaults] doubleForKey:@"visibleAreaEnvelope.xmin"]
                                       ymin:[[NSUserDefaults standardUserDefaults] doubleForKey:@"visibleAreaEnvelope.ymin"]
                                       xmax:[[NSUserDefaults standardUserDefaults] doubleForKey:@"visibleAreaEnvelope.xmax"]
                                       ymax:[[NSUserDefaults standardUserDefaults] doubleForKey:@"visibleAreaEnvelope.ymax"]
                                       spatialReference:spatialReference
                                       ];
    }
//    if (hanzhouTrafficEnv.xmin == hanzhouTrafficEnv.xmax  ){
////        当前的agsPoint(地理坐标) 中中心点的x是13389441.872136,y是3525717.726349 ,区域的xmin是13363419.879201, xmax是 13415463.865072, ymin 是： 3487823.199137, ymax 是：3574671.600559
//        DLog(@"当前底图的位置出现错误！");
//        hanzhouTrafficEnv = [AGSEnvelope
//                             envelopeWithXmin:13363419.879201
//                             ymin:3487823.199137
//                             xmax:13415463.865072
//                             ymax:3574671.600559
//                             spatialReference:spatialReference
//                             ];
//
//    }
    
    //Listen to KVO notifications for map gps's autoPanMode property
    [self.mapView.locationDisplay addObserver:self
                                   forKeyPath:@"navigationMode"
                                      options:(NSKeyValueObservingOptionNew)
                                      context:NULL];
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeNavigation;
    
    
    //1. Zooming
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zoomRespond:)
                                                 name:AGSMapViewDidEndZoomingNotification object:nil];
    
    //2. span moving
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(padRespond:)
                                                 name:AGSMapViewDidEndPanningNotification object:nil];
    
    [self.mapView zoomToEnvelope:hanzhouTrafficEnv animated:YES];
    
    //设置自动定位模式后的显示比例
    self.mapView.locationDisplay.zoomScale = 64000.0f;
    
    oldArearCode = [self getCurrentArearCode];
    currentArearCode = oldArearCode;
    //2014年8月需求，不需要（获取当前视图中心点所对应的区域代码，并且保存，并且刷新拥堵指数。）
    // 强制刷新当前区域的拥堵指数
//    [self refreshCurrentArearCongestIndexWithNetCode:currentArearCode];
    
    //定义查询结果的图层
    self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.graphicsLayer withName:@"Road Graphics Layer"];
    
    // 定时器
    NSTimer *timer;
    timer = [NSTimer scheduledTimerWithTimeInterval: 2*60  //刷新间隔是2分钟
                                             target: self
                                           selector: @selector(handleTimer:)
                                           userInfo: nil
                                            repeats: YES];

    //监听讯飞查询网络参数的消息
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(checkBaseMapVersion:) name:SUNFLOWERNOTIFICATION object:nil];
}

#pragma mark 
#pragma mark - IFlyDataUploaderDelegate
/**
 * @fn  onUploadFinished
 * @brief   上传完成回调
 * @param grammerID 上传用户词、联系人为空
 * @param error 上传错误
 */
- (void) onUploadFinished:(NSString *)grammerID error:(IFlySpeechError *)error
{
    DLog(@"%d",[error errorCode]);
    
    if (![error errorCode]) {
        DLog(@"%@",@"用户词表上传成功！");
    }
    else {
        DLog(@"用户词表上传失败！错误是：%@",[error description]);
    }
    
}


#pragma mark 定时器刷新
- (void) handleTimer: (NSTimer *) timer
{
    DLog(@"定时器开始刷新拥堵指数");
    @try {
        [NSThread detachNewThreadSelector:@selector(refreshAll:) toTarget:self withObject:nil];
    }
    @catch (NSException *exception) {
        DLog(@"捕获错误：%@",exception);
    }

    
    
}

-(void)refreshAll:(id)sender
{
    DLog(@"线程开始获得远程调用");
    @try {
        [self refreshCongestIndexOfCity];
//        [self getArearCongestIndex];
//        [self refreshCurrentArearCongestIndexWithNetCode:currentArearCode];
    }
    @catch (NSException *exception) {
        DLog(@"捕获错误：%@",exception);
    }
    @finally {
        
    }
}


#pragma mark 移动后触发
//2014年8月需求，不再需要
-(void) padRespond:(id)sender{
    self.currentArearCode = [self getCurrentArearCode];
    if(self.currentArearCode == 0 )
    {
        self.currentArearCongestIndex.text = @"";
        self.currentArearName.text =@"";
        return;
    }
    if (self.currentArearCode != self.oldArearCode)
    {
        [self refreshCurrentArearCongestIndexWithNetCode:currentArearCode];
        self.oldArearCode = self.currentArearCode;
    }else{
        
    }
}

#pragma mark 缩放后触发
-(void) zoomRespond:(id)sender{
    //    DLog(@"0:-zooooooming,map view  scale is  %f", self.mapView.mapScale );
    //    DLog(@"1:-zooooooming,map view  scale is  %f", [((AGSTiledMapServiceLayer *)[self.mapView  mapLayerForName:@"BaseLayer"]) convertedScaleForLodScale:self.mapView.mapScale ]);
    
    //    [self.mapView zoomToScale:[((AGSTiledMapServiceLayer *)[self.mapView  mapLayerForName:@"BaseLayer"]) convertedScaleForLodScale:self.mapView.mapScale* 132/96  ] animated:YES];
    //
    //    显示比例数值
    if (! self.scaleText.hidden )
    {
        self.scaleText.text = [[NSString alloc] initWithFormat:@"%f", self.mapView.mapScale ];
        self.inputScale.text =[[NSString alloc] initWithFormat:@"%f", self.mapView.mapScale ];
    }
    
    //    DLog(@"2:zooooooming,map view  scale is  %f", self.mapView.mapScale );
    //    if (self.mapView.mapScale >= 500000.0)
    //    {
    //        [self.mapView zoomToScale:500000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 500000.0 && self.mapView.mapScale >=250000.0)
    //    {
    //        [self.mapView zoomToScale:250000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 250000.0 && self.mapView.mapScale >=125000.0)
    //    {
    //        [self.mapView zoomToScale:125000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 125000.0 && self.mapView.mapScale >=64000.0)
    //    {
    //        [self.mapView zoomToScale:64000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 64000.0 && self.mapView.mapScale >=32000.0)
    //    {
    //        [self.mapView zoomToScale:32000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 32000.0 && self.mapView.mapScale >=16000.0)
    //    {
    //        [self.mapView zoomToScale:16000.0 animated:YES];
    //    }else if(self.mapView.mapScale <16000.0 && self.mapView.mapScale >=8000.0)
    //    {
    //        [self.mapView zoomToScale:8000.0 animated:YES];
    //    }else if(self.mapView.mapScale < 8000.0 && self.mapView.mapScale >=4000.0)
    //    {
    //        [self.mapView zoomToScale:4000.0 animated:YES];
    //    }
    //2014年8月需求，不需要获得当前区域的信息
    self.currentArearCode = [self getCurrentArearCode];
    if (self.currentArearCode != self.oldArearCode)
    {
//        [self refreshCurrentArearCongestIndexWithNetCode:currentArearCode];
        self.oldArearCode = self.currentArearCode;
    }else{
        
    }

}

#pragma mark - 子视图被去掉以后调用的功能
-(void) viewWillDismiss{
    DLog(@"子视图被去掉了！");
}


#pragma mark - 检测晃动
-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        DLog(@"接受到摇晃动作");
        //[self locationBtnClicked:self];
    }
}


#pragma mark - Action
-(IBAction)menuBtnClicked:(id)sender{

    iLiveTrafficMenuViewController *vc = [[iLiveTrafficMenuViewController alloc] init];
    [vc setMapVC:self];
    [self.revealSideViewController pushViewController:vc onDirection:PPRevealSideDirectionRight animated:YES];
    [vc release];
}

#pragma mark 获得位置信息
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    self.currentLocation = [locations lastObject];
    float latitude = self.currentLocation.coordinate.latitude;
    float longitude = self.currentLocation.coordinate.longitude;
//    DLog(@"locationManager didUpdateLocations,获得的坐标是 :%f|%f",latitude, longitude);
    
    //判断当前位置是否在 杭州市内,如果不在，则设置定位关闭标记。并且停止定位
    if (![Tools isPosInCityWithAGSMapView:self.mapView withLongitude:longitude withLatitude:latitude])
    {
        DLog(@"当前位置 不在杭州范围");
        self.locateCenterBtn.hidden = TRUE;
        self.isLocationMode = false;
        [self.locationBtn setImage:[UIImage imageNamed:@"button_location.png"] forState:UIControlStateNormal];
//        [SVProgressHUD showErrorWithStatus:@"对不起，您的当前位置不在本地图的有效范围之内!" ];
        NSString * message = @"对不起，您的当前位置\n不在本地图的有效范围之内!";
        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:NO forAlertType:AlertFailure];
        [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
        [alert show];

        [self.locationManager stopUpdatingLocation];
        [self.mapView.locationDisplay stopDataSource];
        [self.mapView zoomToScale:self.currentScale animated:YES];

    }else{ //如果当前位置在杭州区域内
        DLog(@"当前位置位于杭州范围");        
        [self.mapView.locationDisplay startDataSource];
        if (self.locateCenterBtn.hidden)
        {
            //依然不显示此按钮
            self.locateCenterBtn.hidden = TRUE;
        }
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self locateError:error];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    [self locateError:error];
}

-(void) locateError:(NSError *)error
{
    DLog(@"定位功能错误: %@", error);
    [self.locationBtn setImage:[UIImage imageNamed:@"button_location.png"] forState:UIControlStateNormal];
    [self.locationManager stopUpdatingLocation];
    [self.mapView.locationDisplay stopDataSource];
    self.locateCenterBtn.hidden = TRUE;
//    [SVProgressHUD showErrorWithStatus:@"对不起，无法正确定位。\n请确定您的手机已启用定位服务!\n设置->隐私->定位服务启用->杭州路况->启用" ];
    NSString * message = @"对不起，无法正确定位。\n请确定您的手机已启用定位服务!";
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:NO forAlertType:AlertFailure];
    [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
    [alert show];

    self.isLocationMode = false;
    [self.mapView zoomToScale:self.currentScale animated:YES];
}

# pragma 点击定位按钮
-(IBAction)locationBtnClicked:(id)sender{

    [FlowerCollector OnEvent:RUN_LOCATION_FUNCTION];

    // Make sure location is enabled and allowed, required after ios8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    if([CLLocationManager  locationServicesEnabled])
    {
        self.currentScale = self.mapView.mapScale;
        if ( self.isLocationMode )
        {
            DLog(@"关闭定位");
            self.locateCenterBtn.hidden = TRUE;
            [self.locationBtn setImage:[UIImage imageNamed:@"button_location.png"] forState:UIControlStateNormal];

            [self.locationManager stopUpdatingLocation];
            [self.mapView.locationDisplay stopDataSource];
            self.isLocationMode = false;
        }else{
            DLog(@"开始定位");
            [self.locationBtn setImage:[UIImage imageNamed:@"button_location_on.png"] forState:UIControlStateNormal];
            if (self.mapView.mapScale > 64000.0f)
            {
                [self.mapView zoomToScale:64000.0f animated:YES];
            }
            self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
            [self.locationManager startUpdatingLocation];
            self.isLocationMode = true;
        }
    }else{
        [self.locationBtn setImage:[UIImage imageNamed:@"button_location.png"] forState:UIControlStateNormal];
//        [SVProgressHUD showErrorWithStatus:@"对不起，设备的定位服务没有开启!"];
        [MMProgressHUD showWithTitle:@"注意" status:@"对不起，设备的定位服务没有开启!"];
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MMProgressHUD dismiss];
        });
        self.locateCenterBtn.hidden = TRUE;
        self.isLocationMode = false;
    }
}

/*
 在跟随模式下，移动过地图后 ，将不再跟随。这个功能则是以当前位置为中心，并且启动跟随
 */
-(IBAction) currentLocationAsCenter:(id)sender
{
    float latitude = self.currentLocation.coordinate.latitude;
    float longitude = self.currentLocation.coordinate.longitude;
    DLog(@"locationManager didUpdateLocations,获得的坐标是 :%f|%f",latitude, longitude);
    AGSPoint * currentPoint = [[AGSPoint alloc]initWithX:longitude y:latitude spatialReference:nil];
    [self.mapView centerAtPoint:currentPoint animated:YES ];
    
    self.mapView.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
    [self.locationManager startUpdatingLocation];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
}


#pragma mark 调用与远程方法，获取各个区域拥堵指数
// 2014年8月 需求不再需要此功能
-(void) getArearCongestIndex{
    DLog(@"调用远程方法，获得指数数据");
    //    调用远程方法，获得各个分区指数数据
    NSNumberFormatter * f = [[[NSNumberFormatter alloc] init] autorelease];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/congest_index/congest_index_of_net_for_date.json" ] ];
    NSError *error =nil ;
    NSStringEncoding encoding;
    self.arearCongestIndex = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    if (error)
    {
        self.arearCongestIndex = @"";
    }
}

-(void) refreshCongestIndexOfCity{
    //   获得全市拥堵指数
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/traffic_index/current_traffic_index_of_city_for_today"]];
    NSError *error =nil ;
    NSStringEncoding encoding;
    //NSString *my_string = [[NSString alloc] initWithContentsOfURL:url
    //                                                     encoding:NSUTF8StringEncoding
    //                                                        error:&error];
    NSString *current_congest_index = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
    NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
    //    NSMutableDictionary *jsonDic = [current_congest_index JSONValue];
    NSMutableDictionary * congestIndexInfo = [jsonDic objectForKey:@"congest_index"];
    NSMutableDictionary * congestDescInfo = [jsonDic objectForKey:@"congest_index_desc"];
    NSMutableDictionary * congestIndexColorInfo = [jsonDic objectForKey:@"contest_index_color"];
    UIColor *color = [UIColor colorWithRed:[[congestIndexColorInfo objectForKey:@"R"] floatValue] green:[[congestIndexColorInfo objectForKey:@"G"] floatValue] blue:[[congestIndexColorInfo objectForKey:@"B"] floatValue] alpha:[[congestIndexColorInfo objectForKey:@"alpha"] floatValue]];
    [self jamLabelUpdate:[NSString stringWithFormat:(@"%@"),congestIndexInfo ] withDesc:[NSString stringWithFormat:(@"%@"),congestDescInfo] withColor:color];
    DLog(@"调用拥堵指数结束");
    if (error)
    {
        UIColor *colorError = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.currentArearName.text =@"无网络";
        DLog(@"无法访问网络，从缓存里面获取");
        NSString * lastValue = [[[TrafficeIndexController alloc]init]  lastValue];
        if ( lastValue == nil)
        {
            DLog(@"第一次访问就无法访问网络，缓存也没有数据。");
            [self jamLabelUpdate:[NSString stringWithFormat:(@"%@"),@"0.0" ] withDesc:@"" withColor:colorError];
        }else{
            DLog(@"此次访问无法访问网络，从缓存中获取数据。");
            [self jamLabelUpdate:[NSString stringWithFormat:(@"%@"),lastValue ] withDesc:@"" withColor:colorError];
        }
        
    }else{
        //        保存结果到缓冲数据表单
        [[[TrafficeIndexController alloc]init] addOrUpdateRecord:[NSString stringWithFormat:(@"%@"),congestIndexInfo ]];
    }
    
}

-(void)jamLabelUpdate:(NSString*)text  withDesc:(NSString *)desc  withColor:(UIColor*)color{
    self.cityCongestLabel.text = text;
    self.cityCongestDescLabel.text = desc;
    self.cityCongestLabel.textColor = color;
    self.cityCongestDescLabel.textColor = color;
//    self.jamDescLabel.textColor = color;
}

//点击全市拥堵指数
-(IBAction)onCityCongestIndexButtonClick:(id)sender{
    DLog(@"全市拥堵指数区域被点击");
    Chart1ViewController * vc = [[[Chart1ViewController alloc]init] autorelease];
    vc.displayReturnButton = true;
    [vc setMapVC:self];
    [self.revealSideViewController pushViewController:vc onDirection:PPRevealSideDirectionBottom  withOffset:110.0 animated:YES];
}

-(IBAction)downloadBtnClicked:(id)sender{
    isSilenceCheckTPKVersion = false;
    self.isCheckTPKFileByShowButton = false;
    Tools * tools = [Tools sharedInstance];
    if (tools.backgroudIsDownlaoding){ //如果有下载进程，直接显示，不用做版本检查
        [MMProgressHUD dismiss];
        [self showDownloadView];
        return ;
    }else{
        [MMProgressHUD showWithTitle:@"检查" status:@"开始检查版本"];
        [Tools asynchronousQueryServerBaseMapTpkFileVersion];
    }

    DLog(@"下载按钮被点击");
}

#pragma mark - arcgis map 事件响应
-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    DLog(@"arcgis map 点击事件响应");
}

#pragma mark - PPRevealSideViewControllerDelegate
- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController{

}



#pragma mark - 判断地图版本,通过 Tools 中的 asynchronousQueryServerBaseMapTpkFileVersion 方法回调
- (void) checkBaseMapVersion:(NSNotification*) notification{
    Tools * tools = [Tools sharedInstance];
    [MMProgressHUD dismiss];
    NSDictionary* obj = (NSDictionary*)[notification object];//获取到传递的对象
    DLog(@"获取到传递的对象%@",obj);
    NSString * serverVersion = [IFlyFlowerCollector getOnlineParams:@"BaseMapTPKVersion"];
    if ([[(NSString *)[obj objectForKey:@"config_update"] uppercaseString] isEqualToString:@"YES"] ){ //如果本地对象还没设置,则来拆分对象获得服务器端设置
        serverVersion = (NSString *) [(NSDictionary*)[obj objectForKey:@"online_params"] objectForKey:@"BaseMapTPKVersion"];
    }else{
        serverVersion = [IFlyFlowerCollector getOnlineParams:@"BaseMapTPKVersion"];
    }
    tools.baseMapVersionAtServer = serverVersion ;

    NSString * localVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocalBaseMapTPKVersion"];
    DLog(@"服务器上设置的tpk 文件版本是%@,本地的版本是%@", serverVersion,localVersion);
    NSString * message = nil;
    if (serverVersion == nil){
        if (self.isCheckTPKFileByShowButton){

        }else{
            message =  [[NSString alloc]initWithFormat:@"检查失败\n请联网"];
            DLog("%@",message);
            [MMProgressHUD showWithTitle:@"温馨提示" status:message];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [MMProgressHUD dismiss];
            });
        }

    }else  if ([localVersion isEqualToString:serverVersion]){  //如果本地版本和服务器版本一样
        // 主线程刷新界面开始
        if ([NSThread isMainThread])
        {
            [self.downloadMapBtn setImage:[UIImage imageNamed:@"download_map.png"] forState:UIControlStateNormal];
            [self.downloadMapBtn setNeedsDisplay];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadMapBtn setImage:[UIImage imageNamed:@"download_map.png"] forState:UIControlStateNormal];
                [self.downloadMapBtn setNeedsDisplay];

            });
        }
        // 主线程刷新界面结束
        // 如果只是用于改变 按钮图片，则就退出
        if (self.isCheckTPKFileByShowButton){
            return ;
        }
        [MMProgressHUD dismiss];
        // 主线程刷新界面开始
        if ([NSThread isMainThread])
        {
            [self confirmDownloadTPKFile:localVersion];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self confirmDownloadTPKFile:localVersion];
            });
        }
        // 主线程刷新界面结束

    }else{ //如果本地版本和服务器版本不一样
        // 主线程刷新界面开始
        if ([NSThread isMainThread])
        {
            [self.downloadMapBtn setImage:[UIImage imageNamed:@"download_new_map.png"] forState:UIControlStateNormal];
            [self.downloadMapBtn setNeedsDisplay];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadMapBtn setImage:[UIImage imageNamed:@"download_new_map.png"] forState:UIControlStateNormal];
                [self.downloadMapBtn setNeedsDisplay];

            });
        }
        // 主线程刷新界面结束

        if (self.isCheckTPKFileByShowButton){
            return ;
        }
        message =  [[NSString alloc]initWithFormat:@"发现新版本地图-%@" ,serverVersion ];
        DLog(@"%@",message);
        [MMProgressHUD showWithTitle:@"温馨提示" status:message];
        double delayInSeconds = MMProgressHUD_DELAY_SECONDS;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MMProgressHUD dismiss];
            [self showDownloadView];
        });

    }
}




#pragma mark - 弹出对话窗，确定用户是否一定要下载
-(void) confirmDownloadTPKFile:(NSString *) localVersion{
    NSString * message =  [[NSString alloc]initWithFormat:@"您在使用最新版地图\n%@\n可以不用再下载",localVersion];
    AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:YES forAlertType:AlertInfo];
    [alert.defaultButton setTitle:@"不下载了" forState:UIControlStateNormal];
    [alert.cancelButton setTitle:@"仍然下载" forState:UIControlStateNormal];
    alert.completionBlock = ^void (AMSmoothAlertView *alertObj, UIButton *button) {
        if(button == alertObj.defaultButton) {

        } else {
            [self showDownloadView];
        }
    };
    [MMProgressHUD dismiss];
    [alert show];
}


#pragma mark - 载入下载组件界面
-(void) showDownloadView{
//    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"DownloadManager" bundle:nil];
//    UIViewController *initialViewController = [mainStoryboard instantiateInitialViewController];
//    [self presentViewController:initialViewController animated:YES completion:nil];
    Downloader * downloader = [[Downloader alloc] initWithNibName:@"Downloader" bundle:nil];
    [self presentViewController:downloader  animated:NO completion:nil];


}

-(void) customizeBtnClicked:(id)sender{
    DLog(@"道路定制功能被调用！");
    CustomizeRoadListViewController * customizeRoadListViewController = [[CustomizeRoadListViewController alloc] initWithNibName:@"CustomizeRoadListViewController" bundle:nil];
    customizeRoadListViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:customizeRoadListViewController  animated:YES completion:nil];
}


#pragma mark - Uninit
-(void)dealloc{
    self.mapView = nil;
    self.cityCongestLabel = nil;
    self.cityCongestDescLabel=nil;
    self.timeLabel = nil;
    self.aiv = nil;
    self.slider = nil;
    self.dataTimeLabel = nil;
    self.siView = nil;
    [super dealloc];
}

@end
