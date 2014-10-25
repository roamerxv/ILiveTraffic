//
//  ChartMainViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-7-4.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "ChartMainViewController.h"

@interface ChartMainViewController ()

@end

@implementation ChartMainViewController

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
    // Do any additional setup after loading the view from its nib.
    TTScrollSlidingPagesController *slider = [[TTScrollSlidingPagesController alloc] init];
    slider.dataSource = self;
    
    //add the slider's view to this view as a subview, and add the viewcontroller to this viewcontrollers child collection (so that it gets retained and stays in memory! And gets all relevant events in the view controller lifecycle)
    slider.view.frame = self.view.frame;
    [self.view addSubview:slider.view];
    [self addChildViewController:slider];
}

#pragma mark TTSlidingPagesDataSource methods
-(int)numberOfPagesForSlidingPagesViewController:(TTScrollSlidingPagesController *)source{
    return 4;
}

-(TTSlidingPage *)pageForSlidingPagesViewController:(TTScrollSlidingPagesController*)source atIndex:(int)index{
    UIViewController *viewController;
    switch (index) {
        case 0:
            viewController = [[Chart3MetroViewController alloc] init];
            break;
        case 1:
            viewController = [[Chart2ViewController alloc] init];
            break;
        case 2:
            viewController = [[Chart4ViewController alloc] init];
            break;
        case 3:
            viewController = [[Chart2ViewController alloc] init];
            break;
        default:
            viewController = nil;
            break;
    }
    DLog(@"切换到第%d个图表",index+1);
    return [[TTSlidingPage alloc] initWithContentViewController:viewController];
}

-(TTSlidingPageTitle *)titleForSlidingPagesViewController:(TTScrollSlidingPagesController *)source atIndex:(int)index{
    TTSlidingPageTitle *title;
    //all other pages just use a simple text header
        switch (index) {
            case 0:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"拥堵指数走势图"];
                break;
            case 1:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"主要交通指标"];
                break;
            case 2:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"主要道路车速"];
                break;
            case 3:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@"区域拥堵指数"];
                break;
            default:
                title = [[TTSlidingPageTitle alloc] initWithHeaderText:@""];
                break;
        }
    return title;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
