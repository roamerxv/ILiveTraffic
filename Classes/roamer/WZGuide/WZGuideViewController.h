//
//  WZGuideViewController.h
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface WZGuideViewController : UIViewController<UIScrollViewDelegate>
{
    BOOL _animating;
    UIPageControl *pageControl;
    
    UIScrollView *_pageScroll;
    
    UIButton * enterButton;
    NSArray * imageNameArray ;
}

@property (nonatomic, assign) BOOL animating;

@property (nonatomic, strong) UIScrollView *pageScroll;

@property (nonatomic,retain) UIPageControl *pageControl;
@property (nonatomic,retain) UIButton * enterButton;

@property (nonatomic,retain) NSArray * imageNameArray;

+ (WZGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
