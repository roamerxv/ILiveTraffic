
//  iLiveTrafficAppDelegate.m
//  iLiveTrafficƒ
//
//  Created by sheva2003 on 10-8-20.
//  Copyright __Simon Zhang__ 2010. All rights reserved.
//

#import "iLiveTrafficAppDelegate.h"


@interface iLiveTrafficAppDelegate ()
@property (nonatomic, assign) NSInteger    networkingCount;
@end

static iLiveTrafficAppDelegate *shared;

@implementation iLiveTrafficAppDelegate

@synthesize window;
@synthesize toolbar;
@synthesize barItemUpdate;
@synthesize barItemNavigaton;
@synthesize barItemSwitchRoad;
@synthesize barItemZoomToCity;
@synthesize barItemShowPark;
@synthesize barItemHelp;
@synthesize barItemSetting;
@synthesize queue;


@synthesize networkingCount = _networkingCount;

// 增加变量 设备号       徐泽宇 2013.05.09
@synthesize deviceInfoID;


- (id)init
{
    [super init];
    [queue setMaxConcurrentOperationCount:1];
    queue = [[NSOperationQueue alloc] init];
    shared = self;
    return self;
}

+ (id)shared;
{
    if (!shared) {
        [[iLiveTrafficAppDelegate alloc] init];
    }
    return shared;
}


/******************
 modified by wbgao
 ******************/
@synthesize mapViewController = _mapViewController;
@synthesize configure = _configure;
@synthesize locationManager = _locationManager;
#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    DLog(@"开始应用，存放路径是 %@", NSHomeDirectory());

//    讯飞测试设备号取得
    Class cls = NSClassFromString(@"IFlySysInfo");
    SEL deviceIDSelector = @selector(getDeviceid);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSLog(@"{\"deviceid\":\"%@\"}", deviceID);
    

    //设置log等级，此处log为默认在documents目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];

    //输出在console的log开关
    [IFlySetting showLogcat:NO];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    //设置msc.log的保存路径
    [IFlySetting setLogFilePath:cachePath];

    //创建语音配置
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",IFLY_APP_ID,IFLY_TIMEOUT_VALUE];

    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    DLog(@"讯飞服务调用完成！");

//    开始调用iFlytek Analytics功能
    [IFlyFlowerCollector SetDebugMode:NO];
//    默认为 NO,设置 YES,则会打印 LOG,如需发布到 appstore 请设置为 NO。
    [IFlyFlowerCollector SetCaptureUncaughtException:YES];
//    默认 NO,如需开启收集崩溃日志,请设置为 YES。
    [IFlyFlowerCollector SetAppid:IFLY_APP_ID];
//    是否上传位置信息。
    [IFlyFlowerCollector SetAutoLocation:YES];

    //增加标识，用于判断是否是第一次启动应用...
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"] ) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //设置从未投票过的标记
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"neverComment"];
    }
    
    //设置地图的中心和 区域大小
    //envelopeWithXmin:120.027288000642
    //ymin:30.0734000002107
    //xmax:120.372462000422
    //ymax:30.3930554338621
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"visibleAreaEnvelope.xmin"] == Nil)
    {
        [[NSUserDefaults standardUserDefaults] setDouble:120.027288000642 forKey:@"visibleAreaEnvelope.xmin"];
        [[NSUserDefaults standardUserDefaults] setDouble:120.372462000422 forKey:@"visibleAreaEnvelope.xmax"];
        [[NSUserDefaults standardUserDefaults] setDouble:30.0734000002107 forKey:@"visibleAreaEnvelope.ymin"];
        [[NSUserDefaults standardUserDefaults] setDouble:30.3930554338621 forKey:@"visibleAreaEnvelope.ymax"];
    }

    
    
 
    //added by roamer  .2013-05-05
    DLog(@"开始获取mac地址并且进行md5，作为用户号。并且保存在本地。");
    DLog(@"%@", [Tools uniqueGlobalDeviceIdentifier]);
    
    self.deviceInfoID = [Tools uniqueGlobalDeviceIdentifier];
    [[[[DeviceInfoController alloc] init] autorelease] saveDeviceID:self.deviceInfoID];
    
    DLog(@"应用中变量-设备号是：%@", self.deviceInfoID);
    //


    // 判断是否要显示评价提示的窗口
    if ([[[[DeviceInfoController alloc] init] autorelease] showCommentAllert])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"参与评价" message:@"欢迎对我们的应用提出您宝贵的意见和建议,这对我们来说很重要!" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"好的", nil];
        [alert show];
        [alert release];
    }
	
    
	NSString* coverpath = [[NSBundle mainBundle] pathForResource:@"cover" ofType:@"jpg"];
	NSData * coverData= [[NSData alloc] initWithContentsOfFile:coverpath];
	coverImage = [[[UIImage alloc] initWithData:coverData] autorelease];
    
    
    [[UIApplication sharedApplication ] setIdleTimerDisabled:YES];

    self.configure = [[[iLiveTrafficConfigure alloc] init] autorelease];
    self.mapViewController = [[[iLiveTrafficMapViewController alloc] init] autorelease];
    self.locationManager = [[[iLiveTraffciLocationManager alloc] init] autorelease];
    
    PPRevealSideViewController *vc = [[[PPRevealSideViewController alloc] initWithRootViewController:self.mapViewController] autorelease];

    self.window.rootViewController = vc;
	self.window.backgroundColor = [UIColor blackColor];
	curView = map;
	[window makeKeyAndVisible];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        DLog(@"第一次运行，显示guide界面");
        [WZGuideViewController show];
    }else{
        DLog(@"非第一次运行，不显示guide界面");
    }

    //使用 crashlytics sdk
    [Crashlytics startWithAPIKey:@"df5790710b6debf17578f252f8aaadcb7de2af79"];

	return YES;
}

	
-(UIImage*)getCoverImage{
	return coverImage;
}

-(void) stopLoadingAnimation{
	[activeViewLoadingMap stopAnimating];
}

-(void) startLoadingAnimation{
	[activeViewLoadingMap startAnimating];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	m_bAppActive = false;
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
//	[activeViewLoadingMap startAnimating];
	
//	[self.mapViewController.mapView go2Foreground];
//	toolbar.hidden = false;
//	[window addSubview:self.mapViewController.mapView];
//	[window addSubview:activeView];
//	[window addSubview:activeViewLoadingMap];
//	[window makeKeyAndVisible];
	m_bAppActive = true;
//	[self.mapViewController refreshTimeLabel];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {

	if (updateBarImage != nil)
		[updateBarImage release];
	if (cancelBarImage != nil)
		[cancelBarImage release];
	if (coverImage != nil) {
		[coverImage release];
	}
	
	if (activeView != nil)
		[activeView release];
	
	if (activeViewLoadingMap != nil)
		[activeViewLoadingMap release];
    /******************
     modified by wbgao
     ******************/
//	if (mapView != nil)
//		[mapView release];
	
    if (window != nil)
		[window release];
    
    self.mapViewController = nil;
    self.configure = nil;
    self.locationManager = nil;
	
    [queue release];
    queue = nil;
    [super dealloc];
}


-(IBAction) clickbarItemUpdate:(id)sender{
    DLog(@"正在调用刷新按钮");

//	if ([self.mapViewController.mapView isDownloadFinished]) {// not in updating progress
//		barItemUpdate.image = cancelBarImage;
//		//barItemUpdate.title = @"取消";
//		barItemUpdate.enabled = true;//[mapView getSwitchBarItemEnabled];
//		[activeView startAnimating];
//		[self.mapViewController.mapView startDownloadSpeed];
//	}
//	else {
//		barItemUpdate.image = updateBarImage;
//		//barItemUpdate.title = @"更新";
//		barItemUpdate.enabled = true;//[mapView getSwitchBarItemEnabled];
//		[activeView stopAnimating];
//		[self.mapViewController.mapView stopDownload];
//	}	
}

-(void) updateBarItems{
//    
//	barItemSwitchRoad.title = [self.mapViewController.mapView getSwitchBarItemTitle];
//	barItemSwitchRoad.enabled = [self.mapViewController.mapView getSwitchBarItemEnabled];
//	barItemShowPark.enabled = [self.mapViewController.mapView getSwitchBarItemEnabled];
}



+ (iLiveTrafficAppDelegate *)sharedAppDelegate
{
    return (iLiveTrafficAppDelegate *) [UIApplication sharedApplication].delegate;
}

- (void)didStartNetworking
{
    self.networkingCount += 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didStopNetworking
{
    assert(self.networkingCount > 0);
    self.networkingCount -= 1;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = (self.networkingCount != 0);
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
	
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
				|| ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}

- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix
{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    
    uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    
    uuidStr = CFUUIDCreateString(NULL, uuid);
    assert(uuidStr != NULL);
    
    result = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@", prefix, uuidStr]];
    assert(result != nil);
    
    CFRelease(uuidStr);
    CFRelease(uuid);
    
    return result;
}

-(void) updateAllSetting{
//	[self.mapViewController.mapView updateAllElementsAfterSetting];
	
}

//《选择城市》的按钮点击后刷新相关变量     徐泽宇-2011.11.08 begin
-(void) updateCityInfo :(NSString *) theCitySelected
{
//    DLog(@"当前确定选择的城市是：%@",theCitySelected);
//    if (![ self.mapViewController.mapView.theCityName2Display isEqualToString:theCitySelected])
//    {
//        [self.mapViewController.mapView updateAllElementsAfterCityChanged:theCitySelected];
//        [self.mapViewController.mapView  go2Foreground];
//        //[mapView startZoomToCity];
//    }
}

//获得设备号
-(NSString *) getDeviceInfoID{
    return self.deviceInfoID;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    https://itunes.apple.com/cn/app/hang-zhou-shi-shi-lu-kuang/id452574035?mt=8
    DLog(@"评论界面显示,选择的按钮index是%d",buttonIndex);
    if (buttonIndex == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hang-zhou-shi-shi-lu-kuang/id452574035?mt=8"]];
    } else if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/hang-zhou-shi-shi-lu-kuang/id452574035?mt=8"]];
    }
}


@end
