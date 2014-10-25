//
//  tabbarViewController.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "TabbarViewController.h"
#import "TabbarView.h"

#define SELECTED_VIEW_CONTROLLER_TAG 98456345

@interface TabbarViewController ()

@end

@implementation TabbarViewController

@synthesize arrayViewcontrollers;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGFloat orginHeight = self.view.frame.size.height- 60;
    _tabbar = [[TabbarView alloc]initWithFrame:CGRectMake(0,  orginHeight, self.view.frame.size.width, 60)];
    _tabbar.delegate = self;
    [self.view addSubview:_tabbar];

    self.arrayViewcontrollers = [self getViewcontrollers];
    [self touchBtnAtIndex:0];
}

-(void) viewWillLayoutSubviews{

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        DLog(@"摇晃！");
        [self touchBtnAtIndex:-1];
    }
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchBtnAtIndex:(NSInteger)index
{
    if (index == -1)
    {
        [self  dismissViewControllerAnimated:YES completion:nil];
    }else
    {
        UIView* currentView = [self.view viewWithTag:SELECTED_VIEW_CONTROLLER_TAG];
        [currentView removeFromSuperview];
    
        NSDictionary* data = [self.arrayViewcontrollers objectAtIndex:index];
    
        UIViewController *viewController = data[@"viewController"];
        viewController.view.tag = SELECTED_VIEW_CONTROLLER_TAG;
        viewController.view.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height- 50);
    
        [self.view insertSubview:viewController.view belowSubview:_tabbar];
    }

}

-(NSArray *)getViewcontrollers
{
    NSArray* tabBarItems = nil;
    
    Chart2ViewController *first = [[Chart2ViewController alloc] init] ;
    
    Chart1ViewController *second = [[Chart1ViewController alloc]init];
    
    Chart3MetroViewController *third = [[Chart3MetroViewController alloc]init];
    
    Chart4ViewController *fouth = [[Chart4ViewController alloc]init];
    
    tabBarItems = [NSArray arrayWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", first, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", second, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", third, @"viewController",@"主页",@"title", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:@"tabicon_home", @"image",@"tabicon_home", @"image_locked", fouth, @"viewController",@"主页",@"title", nil],nil
                   ];
    return tabBarItems;
    
}

@end
