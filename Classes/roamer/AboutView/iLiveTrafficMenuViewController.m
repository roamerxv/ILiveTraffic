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

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pkgDownloadBg.png"]];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    versionLabel.text = versionNum;
    //监听讯飞查询网络参数的消息,判断是否有新地图
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(checkBaseMapVersion:) name:SUNFLOWERNOTIFICATION object:nil];
    //检查地图包版本，进行按钮图片的修改（逻辑在回调函数里面实现，这里定义一个开关键）
    [Tools asynchronousQueryServerBaseMapTpkFileVersion];


}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [FlowerCollector OnEvent:RUN_ABOUT_FUNCTION];

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
        if ([NSThread isMainThread])
        {
            [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"地图是最新版本%@",localVersion ] forState:UIControlStateNormal];
            [self refreshUIStatus:NO];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"地图是最新版本%@",localVersion ] forState:UIControlStateNormal];
                [self refreshUIStatus:NO];

            });
        }
        // 主线程刷新界面结束
    }else
    { //如果本地版本和服务器版本不一样
        if ([NSThread isMainThread])
        {
            [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"有新地图%@,点击更新",localVersion ] forState:UIControlStateNormal];
            [self refreshUIStatus:YES];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                //Update UI in UI thread here
                [self.downloadTPKBtn setTitle:[[NSString alloc]initWithFormat:@"有新地图%@,点击更新",localVersion ] forState:UIControlStateNormal];
                [self refreshUIStatus:YES];
            });
        }
    }
}


#pragma mark - 刷新下载按钮和进度条
-(void) refreshUIStatus:(BOOL) canDownload{
    if (canDownload)
    {
        [self.downloadTPKBtn setEnabled:YES];
        [self.downloadTPKBtn setBackgroundColor:[UIColor redColor] ];
    }else{
        [self.downloadTPKBtn setEnabled:NO];
        [self.downloadTPKBtn setBackgroundColor:[UIColor clearColor] ];

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

#pragma mark - 点击下载地图按钮
-(IBAction)downloadBtnClicked:(id)sender{
    DLog(@"下载地图");
//    isSilenceCheckTPKVersion = false;
//    self.isCheckTPKFileByShowButton = false;
//    Tools * tools = [Tools sharedInstance];
//    if (tools.backgroudIsDownlaoding){ //如果有下载进程，直接显示，不用做版本检查
//        [MMProgressHUD dismiss];
//        [self showDownloadView];
//        return ;
//    }else{
//        [MMProgressHUD showWithTitle:@"检查" status:@"开始检查版本"];
//        [Tools asynchronousQueryServerBaseMapTpkFileVersion];
//    }
//
//    DLog(@"下载按钮被点击");
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
        
        if([CONFIG refreshType] == row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
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
