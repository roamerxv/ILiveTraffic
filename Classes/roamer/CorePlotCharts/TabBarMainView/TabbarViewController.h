//
//  tabbarViewController.h
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Chart1ViewController.h"
#import "Chart2ViewController.h"
#import "Chart3MetroViewController.h"
#import "Chart4ViewController.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : 0)
#define addHeight 0


@protocol tabbarDelegate <NSObject>

-(void)touchBtnAtIndex:(NSInteger)index;

@end

@class TabbarView;

@interface TabbarViewController : UIViewController<tabbarDelegate>

@property(nonatomic,strong) TabbarView *tabbar;
@property(nonatomic,retain) NSArray *arrayViewcontrollers;
@end



