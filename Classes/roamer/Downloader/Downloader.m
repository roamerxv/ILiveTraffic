//
//  Downloader.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14-10-18.
//  Copyright (c) 2014年 Alcor. All rights reserved.
//

#import "Downloader.h"

@interface Downloader ()

@end



@implementation Downloader

@synthesize progressView;
@synthesize borderWidth;
@synthesize messageLabel;
@synthesize opButton;
@synthesize downloadSizeLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sharedDownloadManager = [TCBlobDownloadManager sharedInstance];
        downloadThread = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.progressView.borderWidth = 5.0;
    self.progressView.lineWidth = 10.0;
    self.progressView.fillOnTouch = NO;
    self.progressView.tintColor = [UIColor yellowColor];

    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 32.0)];
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:24];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor yellowColor];
    textLabel.backgroundColor = [UIColor clearColor];
    self.progressView.centralView = textLabel;
    // Do any additional setup after loading the view from its nib.
}


-(void) viewDidAppear:(BOOL)animated{

    switch (currentDownloadStatus){
        case Ready:
            break;
        case Downloading:
            // 先停止原来下载的进程。再继续下载。否则会引起多进程问题
            [sharedDownloadManager cancelAllDownloadsAndRemoveFiles:NO];
            [self downloadFile];
            break;
        case Paused:
            break;
        case Finished:
            break;
        default:
            break;
    }
    [self freshOpBtnBackgroundImg];
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 操作按钮被点击
-(void) btnClicked:(id)sender{
    DLog(@"操作按钮被点击！，当前状态是%d", currentDownloadStatus);
    switch (currentDownloadStatus) {
        case Ready:
            currentDownloadStatus = Downloading;
            [self downloadFile];
            break;
        case Downloading:
            currentDownloadStatus = Paused;
            [self pauseDownload];
            break;
        case Paused:
            currentDownloadStatus = Downloading;
            [self downloadFile];
            break;
        case Finished:
            currentDownloadStatus = Downloading;
            [self downloadFile];
            break;
        default:
            break;
    }

    [self freshOpBtnBackgroundImg];
}

-(void) freshOpBtnBackgroundImg{
    switch (currentDownloadStatus) {
        case Ready:
            [self.opButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
        case Downloading:
            [self.opButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            break;
        case Paused:
            {
                float percent = [[NSUserDefaults standardUserDefaults] floatForKey:@"PERCENT_OF_DOWNLOAD"];
                if(percent_of_download >= 0.0f ){
                    [self.progressView setProgress:percent];
                }
                [self.opButton setBackgroundImage:[UIImage imageNamed:@"replay"] forState:UIControlStateNormal];
            }
            break;
        case Finished:
            [self.opButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}

-(void) pauseDownload{
    currentDownloadStatus = Paused;
    [self freshOpBtnBackgroundImg];
    [sharedDownloadManager cancelAllDownloadsAndRemoveFiles:NO];
//    [self.downloadThread cancelDownloadAndRemoveFile:NO];

}

-(void) downloadFile{
    NSURL * url =   [ NSURL URLWithString:BASE_MAP_TPK_FILE_URL];
    DLog(@"将要下载文件:\n%@", url);
    /*
    [self.sharedDownloadManager startDownloadWithURL:url
            customPath:nil
            delegate: self];
*/
    [self downloadFileWithTCBlobDownload:url];

}

// 下载文件
-(void) downloadFileWithTCBlobDownload:(NSURL * ) url {
        Tools * tools = [Tools sharedInstance];
        downloadThread  =  [sharedDownloadManager startDownloadWithURL:url customPath:nil
            firstResponse:^(NSURLResponse *response)
            {
                tools.backgroudIsDownlaoding = true;
                percent_of_download = 0.0f ;
                DLog(@"要下载文件大小为 %lld",response.expectedContentLength);                                                                 NSNumber  * expectedFileLength = [NSNumber numberWithLongLong:response.expectedContentLength];                                                                 [[NSUserDefaults standardUserDefaults] setObject:expectedFileLength forKey:@"EXCEPT_SIZE_OF_DOWNLOAD_FILE"];                                                                 NSString * fileName = response.suggestedFilename ;
                //获取本地缓存文件大小
                NSFileManager* fileManager=[NSFileManager defaultManager];
                NSString * downloadTempFile = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(),fileName];
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:downloadTempFile error:nil];
                NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
                long long tempFileSize = [fileSizeNumber longLongValue];
                long long totalSizeOfFile =response.expectedContentLength+tempFileSize;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:totalSizeOfFile] forKey:@"TOTAL_SIZE_OF_DOWNLOAD_FILE"];
                currentDownloadStatus = Downloading;
                [self freshOpBtnBackgroundImg];
            }progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress)
            {
                tools.backgroudIsDownlaoding = true;
                long long savedServerFileSizeInfo =((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TOTAL_SIZE_OF_DOWNLOAD_FILE"]).unsignedLongLongValue;
                float total_download =( float )(savedServerFileSizeInfo - (long long)totalLength + (long long) receivedLength);
                float total_progress  =  total_download / savedServerFileSizeInfo;
//                NSString * message = [NSString stringWithFormat:@"本次下载了%qu字节(%lld)，\n本次要下载%qu字节，\n总共要下载%lld,\n还有%@秒，完成%@",receivedLength,[NSNumber numberWithUnsignedLong:receivedLength].longLongValue,totalLength,savedServerFileSizeInfo,[NSString stringWithFormat:@"%ld", (long)remainingTime],[NSString stringWithFormat:@"%2.00f%%", total_progress * 100] ];
//                                    NSLog(@"%@",message);
//               self.messageLabel.text = message;

                //保存下载进度，以便恢复的时候显示(会导致界面卡顿)
                //[[NSUserDefaults standardUserDefaults] setFloat:total_progress forKey:@"PERCENT_OF_DOWNLOAD"];
                percent_of_download = total_progress;
                //显示文字提示

                self.downloadSizeLabel.text =[NSString stringWithFormat:@"%.2fM/%.2fM",total_download/1024.0/1024.0,(float)savedServerFileSizeInfo/1024.0/1024.0];

               [self.progressView setProgress:total_progress];
               [(UILabel *)progressView.centralView setText:[NSString stringWithFormat:@"%2.0f%%", total_progress * 100]];
               currentDownloadStatus = Downloading;
           }error:^(NSError *error)
           {
               NSLog(@"%@", error);
               percent_of_download = 0.0f ;
               currentDownloadStatus = Ready;
               tools.backgroudIsDownlaoding = false;
               [self freshOpBtnBackgroundImg];
           }complete:^(BOOL downloadFinished, NSString *pathToFile)
           {
               NSString *str = downloadFinished ? @"Completed" : @"Cancelled";
               NSLog(@"当前下载的完成操作是%@产生的",str);
               /* 以下这个判断是 中断还是完整结束的方法不再使用*/

//               self.currentDownloadStatus = Finished;
//               [self freshOpBtnBackgroundImg];
//               /* 判断已经下载的文件的大小和服务器上文件大小是否一致
//               如果一致，说明下载完成。进行复制文件和删除。
//               如果不一致，说明要断点续传
//               */
//               NSFileManager* fileManager=[NSFileManager defaultManager];
//               // 如果是中断下载来产生的这个回调，pathFile 仅仅是文件名
//               // 如果是下载完成来产生的这个回调，pathFile 是全路径文件名
//               NSString * downloadTempFile = nil;
//               NSString * tempFilePath = [NSString stringWithFormat:@"%@/tmp/", NSHomeDirectory()];
//               DLog(@"缓存文件是：\n%@,\n路径是\n%@",pathToFile,tempFilePath);
//               NSRange range  = [pathToFile rangeOfString:tempFilePath];
//               if ( range.length == 0){ //如果包含路径，说明是下载完成的。不再需要拼前面的全路径
//                  downloadTempFile = [NSString stringWithFormat:@"%@/tmp/%@", NSHomeDirectory(),pathToFile];
//               }else{
//                  downloadTempFile = pathToFile;
//               }
//
//              NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:downloadTempFile error:nil];
//              NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
//              long long fileSize = [fileSizeNumber longLongValue];
//              long long savedServerFileSizeInfo =((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TOTAL_SIZE_OF_DOWNLOAD_FILE"]).unsignedLongLongValue;
//              DLog(@"下载的缓存文件是:\n%@\n文件大小是:%lld\n保存在本地的服务器文件字节信息是:%lld", downloadTempFile,fileSize,savedServerFileSizeInfo);
              if (  downloadFinished )
              {
                  tools.backgroudIsDownlaoding = false;
                  percent_of_download = 1.0f ;
                  currentDownloadStatus = Finished;
                  //复制下载底图文件到Documents目录
                  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                  NSString *docDir = [paths objectAtIndex:0];
                  Tools * tools = [Tools sharedInstance];
                  NSString * targetFile = [docDir stringByAppendingFormat:@"/%@-%@.tpk", DOWNLOAD_BASE_MAP_FILE_PHYSICS_NAME,tools.baseMapVersionAtServer ];
                  NSData *myData =[NSData dataWithContentsOfFile:pathToFile]; ;
                  [myData writeToFile:targetFile atomically:YES];
                  [[NSUserDefaults standardUserDefaults] setObject:tools.baseMapVersionAtServer forKey:@"LocalBaseMapTPKVersion"];
                  //删除 下载文件
                  NSFileManager* fileManager=[NSFileManager defaultManager];
                  NSString * downloadTempFile = pathToFile;
                  DLog(@"正在准备删除文件\n%@",downloadTempFile);
                  BOOL blDele= [fileManager removeItemAtPath:downloadTempFile error:nil];
                  if (blDele) {
                      DLog(@"dele success");
                  }else {
                      DLog(@"dele fail");
                  }
                  //给主界面发送通知,重新载入底图
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBaseMap" object:nil];
                  //退出界面
                  [self  dismissViewControllerAnimated:YES completion:nil];
               }else{
                   tools.backgroudIsDownlaoding = true;
                   if (  percent_of_download  >= 0.0f) {
                       [[NSUserDefaults standardUserDefaults] setFloat:percent_of_download forKey:@"PERCENT_OF_DOWNLOAD"];
                   }
                   currentDownloadStatus = Paused;
               }
               [self freshOpBtnBackgroundImg];

  }];
}

-(void) closeBtnClicked:(id)sender{
    if (  percent_of_download  >= 0.0f) {
        [[NSUserDefaults standardUserDefaults] setFloat:percent_of_download forKey:@"PERCENT_OF_DOWNLOAD"];
    }
    [self  dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - TCBlobDownloaderDelegate


//- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
//{
//
//}
//
//- (void)download:(TCBlobDownloader *)blobDownload
//  didReceiveData:(uint64_t)receivedLength
//         onTotal:(uint64_t)totalLength
//{
//    NSLog(@"######");
//}
//
//- (void)download:(TCBlobDownloader *)blobDownload didStopWithError:(NSError *)error
//{
//
//}
//
//- (void)download:(TCBlobDownloader *)blobDownload didCancelRemovingFile:(BOOL)fileRemoved
//{
//
//}
//
//- (void)download:(TCBlobDownloader *)blobDownload didFinishWithSuccess:(BOOL)downloadFinished atPath:(NSString *)pathToFile
//{
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
