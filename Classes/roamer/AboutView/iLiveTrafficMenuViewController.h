//
//  iLiveTrafficMenuViewController.h
//  ILiveTraffic
//
//  Created by Gao WenBin on 13-4-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@class iLiveTrafficMapViewController;

@interface iLiveTrafficMenuViewController : UIViewController{
    IBOutlet UILabel * versionLabel ;
    IBOutlet UIButton * checkNewImageBtn;
    IBOutlet UITextView * textView;
    IBOutlet UILabel * label_version;
    IBOutlet UIButton * infoBtn;
    IBOutlet UIButton * commentBtn;
    IBOutlet UIImageView * legendImg ;
}

@property(retain) iLiveTrafficMapViewController *mapVC;
@property(nonatomic,retain) IBOutlet UILabel * versionLabel;
@property(nonatomic,retain) IBOutlet UIButton * checkNewImageBtn;
@property(nonatomic,retain) IBOutlet UITextView * textView;
@property(nonatomic,retain) IBOutlet UILabel * label_version;
@property(nonatomic,retain) IBOutlet UIButton * infoBtn;
@property(nonatomic,retain) IBOutlet UIButton * commentBtn;
@property(nonatomic,retain) IBOutlet UIImageView * legendImg;

-(IBAction)helpBtnClicked:(id)sender;
-(IBAction) goToDownlaodPage:(id)sender;
-(IBAction) goToCommentPage:(id)sender;

@end
