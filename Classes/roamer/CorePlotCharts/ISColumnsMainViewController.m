//
//  ISColumnsMainViewController.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-7-4.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "ISColumnsMainViewController.h"

@interface ISColumnsMainViewController ()

@end

@implementation ISColumnsMainViewController

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize columnsController = _columnsController;

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
    self.columnsController = [[[ISColumnsController alloc] init] autorelease];
    self.columnsController.navigationItem.rightBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"重新加载"
                                      style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(reloadViewControllers)] autorelease];
    [self reloadViewControllers];
    
    self.navigationController = [[[UINavigationController alloc] init] autorelease];
    self.navigationController.viewControllers = [NSArray arrayWithObject:self.columnsController];
    
    self.window.rootViewController = self.navigationController;
}

- (void)reloadViewControllers
{
    Chart1ViewController *viewController1 = [[[Chart1ViewController alloc] init] autorelease];
    viewController1.navigationItem.title = @"拥堵指数走势图";
    
    Chart2ViewController *viewController2 = [[[Chart2ViewController alloc] init] autorelease];
    viewController2.navigationItem.title = @"主要交通指标";
    
    Chart3MetroViewController *viewController3 = [[[Chart3MetroViewController alloc] init] autorelease];
    viewController3.navigationItem.title = @"区域交通指标";

    
    Chart4ViewController *viewController4 = [[[Chart4ViewController alloc] init] autorelease];
    viewController4.navigationItem.title = @"主要道路车速";
    
    self.columnsController.viewControllers = [NSArray arrayWithObjects:
                                              viewController1,
                                              viewController2,
                                              viewController3,
                                              viewController4,nil];
}


#pragma mark 手势摇动

-(BOOL)canBecomeFirstResponder {
    return YES;
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
        DLog(@"图表接受手势摇动");
        [self closeBtnClicked:nil];
    }
}

-(IBAction) closeBtnClicked:(id)sender
{
    DLog(@"退出控制菜单");
    [self  dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
