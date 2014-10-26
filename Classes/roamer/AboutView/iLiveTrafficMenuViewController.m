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
    // 检测新版本
//    [NSThread detachNewThreadSelector:@selector(checkVersion:) toTarget:self withObject:nil];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [FlowerCollector OnEvent:RUN_ABOUT_FUNCTION];
}

#pragma mark - 检测新版本

-(void) checkVersion:(id)sender{
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:[[NSString alloc] initWithFormat:@"/system/check_version?platform=000000&version=%@",versionLabel.text ]]];
    DLog(@"开始检测新版本。当前版本是%@\n调用的url是:%@", versionLabel.text,url);
    NSError *error =nil ;
    NSStringEncoding encoding;
    //NSString *my_string = [[NSString alloc] initWithContentsOfURL:url
    //                                                     encoding:NSUTF8StringEncoding
    //                                                        error:&error];
    NSString * checkResult = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    if (error == NULL)
    {
        DLog(@"返回的值:%@",checkResult);
        if([checkResult isEqualToString:@""] ||  [checkResult isEqualToString:@"error"] )
        {
            self.checkNewImageBtn.alpha =0.0f ;
            self.checkNewImageBtn.enabled = false;
            
        }else{
            self.checkNewImageBtn.alpha = 1.0f ;
            self.checkNewImageBtn.enabled = true ;
        }
    }else{
        DLog(@"检测版本的调用发生错误,错误是:%@，url是:%@",error,url);
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
