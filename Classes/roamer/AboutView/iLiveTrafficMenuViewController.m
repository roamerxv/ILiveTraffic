//
//  iLiveTrafficMenuViewController.m
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "iLiveTrafficMenuViewController.h"
#import "PPPickerSheet.h"
#import "iLiveTrafficMapViewController.h"
#import "SDHelpViewController.h"
@interface iLiveTrafficMenuViewController ()

@end

@implementation iLiveTrafficMenuViewController

@synthesize mapVC;
@synthesize versionLabel;
@synthesize checkNewImageBtn;
@synthesize textView;
@synthesize label_version;
@synthesize infoBtn;
@synthesize commentBtn;
@synthesize legendImg;
@synthesize downloadTPKBtn;
@synthesize progressView;


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
    //判断是否投票过。是否要显示投票按钮
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"neverComment"]) {
        self.commentBtn.hidden = FALSE;
    }else{
        self.commentBtn.hidden = TRUE;
    }
    // Do any additional setup after loading the view from its nib.

    [self.downloadTPKBtn setTitle:@"正在检查地图版本" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pkgDownloadBg.png"]];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = versionNum;



    //注册监听事件，用于在地图上定位路段
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //监听讯飞查询网络参数的消息,判断是否有新地图
    [nc addObserver:self
           selector:@selector(checkBaseMapVersion:)
               name:SUNFLOWERNOTIFICATION
             object:nil];

    //注册监听程序，接受开始下载的消息
    [nc addObserver:self
           selector:@selector(downloadBegin:)
               name:@"dwonloanding_tpk_begin"
             object:nil];

    //注册监听事件，用于刷新下载进度条
    [nc addObserver:self
           selector:@selector(refreshProgressBar:)
               name:@"dwonloanding_tpk_percent"
             object:nil];
    //注册监听事件，用于在下载暂停的情况下进行处理
    [nc addObserver:self
           selector:@selector(downloadCanceled:)
               name:@"dwonloanding_tpk_canceled"
             object:nil];
    //注册监听事件，用于下载完成后，进行ui处理
    [nc addObserver:self
           selector:@selector(downloadFinished:)
               name:@"dwonloanding_tpk_finished"
             object:nil];

    //检查地图包版本，进行按钮图片的修改（逻辑在回调函数里面实现，这里定义一个开关键）
    [Tools asynchronousQueryServerBaseMapTpkFileVersion];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [FlowerCollector OnEvent:RUN_ABOUT_FUNCTION];
    //设置成一个 下载状态不涵盖的 状态。用于表示不用下载
    [DownloadTPKFileThread setCurrentDownloadStatus:-1];
    self.progressView.hidden=YES;


}


#pragma mark - 判断地图版本,通过 Tools 中的 asynchronousQueryServerBaseMapTpkFileVersion 方法回调
- (void) checkBaseMapVersion:(NSNotification*) notification{
    NSDictionary* obj = (NSDictionary*)[notification object];//获取到传递的对象
    DLog(@"获取到传递的对象%@",obj);
    NSString * serverVersion = [IFlyFlowerCollector getOnlineParams:@"BaseMapTPKVersion"];
    if ([[(NSString *)[obj objectForKey:@"config_update"] uppercaseString] isEqualToString:@"YES"])
    { //如果本地对象还没设置,则来拆分对象获得服务器端设置
        serverVersion = (NSString *) [(NSDictionary*)[obj objectForKey:@"online_params"] objectForKey:@"BaseMapTPKVersion"];
    }else{
            serverVersion = [IFlyFlowerCollector getOnlineParams:@"BaseMapTPKVersion"];
    }
    NSString * localVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocalBaseMapTPKVersion"];
    DLog(@"服务器上设置的tpk 文件版本是%@,本地的版本是%@", serverVersion,localVersion);
    if (localVersion == nil){
        localVersion =@"未知";
    }
    if (serverVersion == nil){
        [self.downloadTPKBtn setTitle:@"地图版本未知" forState:UIControlStateNormal];
    }else  if ([localVersion isEqualToString:serverVersion])
    {  //如果本地版本和服务器版本一样
        // 主线程刷新界面开始
        //设置成一个 下载状态不涵盖的 状态。用于表示不用下载
        needDownlaod = false;
        [DownloadTPKFileThread setCurrentDownloadStatus:-1];
        if ([NSThread isMainThread])
        {
            [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"地图是最新版本%@",localVersion ] forState:UIControlStateNormal];
            self.progressView.hidden=true;
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"地图是最新版本%@",localVersion ] forState:UIControlStateNormal];
                self.progressView.hidden=YES;

            });
        }
        // 主线程刷新界面结束
    }else
    { //如果本地版本和服务器版本不一样
        needDownlaod = true;
        Tools * tools = [Tools sharedInstance];
        tools.baseMapVersionAtServer = serverVersion;
        [DownloadTPKFileThread setCurrentDownloadStatus:TCBlobDownloadStateReady];
        if ([NSThread isMainThread])
        {
            [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"有新地图%@,点击更新",serverVersion ] forState:UIControlStateNormal];
            self.progressView.hidden=YES;
            [self.downloadTPKBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"有新地图%@,点击更新",serverVersion ] forState:UIControlStateNormal];
                self.progressView.hidden=YES;
                [self.downloadTPKBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            });
        }
    }
}

#pragma mark - 监听开始下载的通知
-(void) downloadBegin:(NSNotification*) notification{
    needDownlaod = YES;
    [self.downloadTPKBtn setTitle:@"下载请求成功，开始下载文件!" forState:UIControlStateNormal ];
    self.progressView.hidden=NO;

}


#pragma mark - 监听下载暂停通知
-(void) downloadCanceled:(NSNotification*) notification{
    [DownloadTPKFileThread setCurrentDownloadStatus:TCBlobDownloadStateCancelled];
    [self.downloadTPKBtn setTitle:@"下载暂停，点击继续" forState:UIControlStateNormal ];
    needDownlaod = YES;
    self.progressView.hidden=NO;
    [self.downloadTPKBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];

}

#pragma mark - 监听下载完成的通知
-(void)downloadFinished:(NSNotification*) notification{
    NSString * localVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"LocalBaseMapTPKVersion"];
    [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"地图是最新版本%@",localVersion ] forState:UIControlStateNormal];
    //设置成一个 下载状态不涵盖的 状态。用于表示不用下载
    [DownloadTPKFileThread setCurrentDownloadStatus:-1];
    needDownlaod = NO;
    self.progressView.hidden=YES;
    [self.downloadTPKBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    //讯飞上记录下载完成的功能
    [FlowerCollector OnEvent:RUN_DOWNLOAD_FUNCTION];

}

#pragma mark - 监听消息的回调，用于刷新进度条
- (void) refreshProgressBar:(NSNotification*) notification{
    NSNumber* percent = (NSNumber *)[notification object];//获取到传递的对象
    [self.progressView setProgress:[percent floatValue]];
    [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"下载了%0.1f%%，点击暂停",[percent floatValue]*100 ] forState:UIControlStateNormal ];
    needDownlaod = YES;
}


#pragma mark - 点击下载地图按钮
-(IBAction)downloadBtnClicked:(id)sender{
    DLog(@"下载按钮被点击！");
    if ([DownloadTPKFileThread getCurrentDownloadStatus] == TCBlobDownloadStateReady)
    {
        [DownloadTPKFileThread downloadFile];
    }else if ([DownloadTPKFileThread getCurrentDownloadStatus] == TCBlobDownloadStateDownloading){
        [DownloadTPKFileThread pauseDownload];
    }else if ([DownloadTPKFileThread getCurrentDownloadStatus] == TCBlobDownloadStateCancelled){
        [DownloadTPKFileThread downloadFile];
    }

}


#pragma mark -跳转到下载页面
-(IBAction)goToDownlaodPage:(id)sender{
    DLog(@"跳转到下载页面");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hang-zhou-shi-shi-lu-kuang/id452574035?mt=8"]];
}

#pragma mark -跳转到评论界面
-(IBAction)goToCommentPage:(id)sender
{
    NSString *str = [NSString stringWithFormat:
                    @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",
                    452574035];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    self.commentBtn.hidden = true;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"neverComment"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    if (section == 0 || section == 1) {
        count = 2;
    } else {
        count = 2;      //更新时间改为只有手工和自动2个选项
    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str = @"";

    switch (section) {
        case 0:
            str = @"路网切换";
            break;
        case 1:
            str = @"停车场";
            break;
        case 2:
            str = @"更新时间";
            break;
        default:
            break;
    }
    
    return str;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"MyIdentifier";
    UITableViewCell *cell = (UITableViewCell*) [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSString *text;
    int row = indexPath.row;
    
    if (indexPath.section == 0) {
        if (row == 0) {
            text = @"主要道路";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            text = @"全部道路";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if(indexPath.section == 1){
        if (row == 0) {
            text = @"显示停车场";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            text = @"隐藏停车场";
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else if(indexPath.section == 2){
        if (row == 0) {
            text = @"手动更新";
//        } else if (row == 1){
//            text = @"5分钟";
//        } else if (row == 2){
//            text = @"10分钟";
//        }  else if (row == 3){
//            text = @"20分钟";
        }  else{
            text = @"自动更新(每5分钟)";
        }
        
    }
    
    cell.textLabel.text = text;

    return cell;
}

#pragma mark - Others
-(IBAction)helpBtnClicked:(id)sender{
    SDHelpViewController *vc = [[SDHelpViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.mapVC = nil;
}

@end
