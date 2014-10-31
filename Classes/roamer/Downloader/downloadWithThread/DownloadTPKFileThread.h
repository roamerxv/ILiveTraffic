//
//  DownloadThread.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/31.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TCBlobDownload/TCBlobDownload.h>

#import "Tools.h"
#import "Configer.h"

//定义一个静态变量来显示是否有激活的下载线程
static TCBlobDownloadState  currentDownloadStatus = TCBlobDownloadStateReady ;
static TCBlobDownloadManager *sharedDownloadManager;
static TCBlobDownloader * downloadThread;

//完成的百分比
static float percent_of_download =0.0f;


@interface DownloadTPKFileThread : NSObject


+(void) downloadFile;

+(void) pauseDownload;

+(TCBlobDownloadState) getCurrentDownloadStatus;

+(void) setCurrentDownloadStatus:(TCBlobDownloadState)downloadStatus;

@end
