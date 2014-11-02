//
//  DownloadThread.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 14/10/31.
//  Copyright (c) 2014年 ；. All rights reserved.
//

#import "DownloadTPKFileThread.h"

@implementation DownloadTPKFileThread


+( TCBlobDownloadState ) getCurrentDownloadStatus{
    return currentDownloadStatus ;
}

+(void) setCurrentDownloadStatus:(TCBlobDownloadState)downloadStatus{
    currentDownloadStatus = downloadStatus;
}

+(void)downloadFile{
    NSURL * url =   [ NSURL URLWithString:BASE_MAP_TPK_FILE_URL];
    DLog(@"将要下载文件:\n%@", url);
    Tools * tools = [Tools sharedInstance];
    sharedDownloadManager = [TCBlobDownloadManager sharedInstance];
    downloadThread = nil;
    downloadThread  =
        [sharedDownloadManager startDownloadWithURL:url customPath:nil
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
            currentDownloadStatus = TCBlobDownloadStateDownloading;
            //发出通知机制，告知开始下载
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dwonloanding_tpk_begin" object:[[NSNumber alloc ] initWithFloat:nil]];
        }
        progress:^(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress)
        {
            tools.backgroudIsDownlaoding = true;
            long long savedServerFileSizeInfo =((NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"TOTAL_SIZE_OF_DOWNLOAD_FILE"]).unsignedLongLongValue;
            float total_download =( float )(savedServerFileSizeInfo - (long long)totalLength + (long long) receivedLength);
            float total_progress  =  total_download / savedServerFileSizeInfo;
            
            currentDownloadStatus = TCBlobDownloadStateDownloading;
            //发出通知机制，告知完成百分比
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dwonloanding_tpk_percent" object:[[NSNumber alloc ] initWithFloat:total_progress]];
        }
        error:^(NSError *error)
        {
            DLog(@"！！！！！！%@",error);
        }
        complete:^(BOOL downloadFinished, NSString *pathToFile)
        {
            NSString *str = downloadFinished ? @"Completed" : @"Cancelled";
            NSLog(@"当前下载的完成操作是%@产生的",str);
            if (  downloadFinished )
            {
                tools.backgroudIsDownlaoding = false;
                percent_of_download = 1.0f ;
                currentDownloadStatus = TCBlobDownloadStateDone;
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
                //发送下载完成的通知.
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dwonloanding_tpk_finished" object:nil];
                //给主界面发送通知,重新载入底图
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBaseMap" object:nil];
            }else{
                tools.backgroudIsDownlaoding = true;
                if (  percent_of_download  >= 0.0f) {
                    [[NSUserDefaults standardUserDefaults] setFloat:percent_of_download forKey:@"PERCENT_OF_DOWNLOAD"];
                }
                currentDownloadStatus = TCBlobDownloadStateCancelled;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dwonloanding_tpk_canceled" object:nil];
            }

        }];

}


+(void) pauseDownload{
    currentDownloadStatus = TCBlobDownloadStateCancelled;
    [sharedDownloadManager cancelAllDownloadsAndRemoveFiles:NO];
}
@end
