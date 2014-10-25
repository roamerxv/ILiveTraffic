//
//  Downloader.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14-10-18.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UAProgressView.h>
#import <TCBlobDownload/TCBlobDownload.h>

#import "Tools.h"
#import "Configer.h"

typedef NS_ENUM(int, DOWNLOAD_STATUS)  {
    Ready = 0,
    Downloading  = 1,
    Paused  = 2 ,
    Finished = 3
};

//定义一个静态变量来显示是否有激活的下载线程
static DOWNLOAD_STATUS  currentDownloadStatus = Ready ;
static TCBlobDownloadManager *sharedDownloadManager;
static TCBlobDownloader * downloadThread;

//完成的百分比
static float percent_of_download =0.0f;

@interface Downloader : UIViewController <TCBlobDownloaderDelegate>{

}





@property (nonatomic, retain) IBOutlet UAProgressView *progressView;
@property (nonatomic, retain) IBOutlet UILabel *downloadSizeLabel;

@property (nonatomic, assign) BOOL paused;

@property (nonatomic, assign) float localProgress;
@property (nonatomic, retain) IBOutlet UILabel * messageLabel;
@property (nonatomic, retain) IBOutlet UIButton * opButton;



//线宽
@property (nonatomic, assign) CGFloat borderWidth;

-(IBAction) btnClicked:(id)sender;
-(IBAction) closeBtnClicked:(id)sender;

@end
