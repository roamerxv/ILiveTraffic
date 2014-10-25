//
//  WZGuideViewController.m
//  WZGuideViewController
//
//  Created by Wei on 13-3-11.
//  Copyright (c) 2013年 ZhuoYun. All rights reserved.
//

#import "WZGuideViewController.h"

@interface WZGuideViewController ()

@end

@implementation WZGuideViewController

@synthesize animating = _animating;

@synthesize pageScroll = _pageScroll;
@synthesize pageControl;
@synthesize enterButton;

@synthesize imageNameArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DLog(@"图片滑动结束");
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageControl setCurrentPage:offset.x / bounds.size.width];
    if(self.pageControl.currentPage == self.imageNameArray.count - 1)
    {
        [self.view addSubview:self.enterButton];
    }else{
        [self.enterButton removeFromSuperview];
    }
}

#pragma mark -

- (CGRect)onscreenFrame
{
	return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
	CGRect frame = [self onscreenFrame];
	switch ([UIApplication sharedApplication].statusBarOrientation)
    {
		case UIInterfaceOrientationPortrait:
			frame.origin.y = frame.size.height;
			break;
		case UIInterfaceOrientationPortraitUpsideDown:
			frame.origin.y = -frame.size.height;
			break;
		case UIInterfaceOrientationLandscapeLeft:
			frame.origin.x = frame.size.width;
			break;
		case UIInterfaceOrientationLandscapeRight:
			frame.origin.x = -frame.size.width;
			break;
	}
	return frame;
}

- (void)showGuide
{
	if (!_animating && self.view.superview == nil)
	{
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[[self mainWindow] addSubview:[WZGuideViewController sharedGuide].view];
		
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideShown)];
		[WZGuideViewController sharedGuide].view.frame = [self onscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideShown
{
	_animating = NO;
}

- (void)hideGuide
{
	if (!_animating && self.view.superview != nil)
	{
		_animating = YES;
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(guideHidden)];
		[WZGuideViewController sharedGuide].view.frame = [self offscreenFrame];
		[UIView commitAnimations];
	}
}

- (void)guideHidden
{
	_animating = NO;
	[[[WZGuideViewController sharedGuide] view] removeFromSuperview];
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

+ (void)show
{
    [[WZGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
	[[WZGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
	[[WZGuideViewController sharedGuide] hideGuide];
}

#pragma mark - 

+ (WZGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WZGuideViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

- (void)pressCheckButton:(UIButton *)checkButton
{
    [checkButton setSelected:!checkButton.selected];
}

- (void)pressEnterButton:(UIButton *)enterButton
{
    [self hideGuide];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageNameArray = [NSArray arrayWithObjects:@"ios_guide_01", @"ios_guide_02", @"ios_guide_03",@"ios_guide_04",@"ios_guide_05", nil];
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    if (DEVICE_IS_IPHONE5) {
        _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    }
    self.pageScroll.pagingEnabled = YES;
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imageNameArray.count, self.view.frame.size.height);
    self.pageScroll.delegate = self ;
    [self.view addSubview:self.pageScroll];
    
    self.pageControl = [[UIPageControl alloc] init];
    if (DEVICE_IS_IPHONE5) {
        self.pageControl.frame = CGRectMake(0, 484, 320, 36);
    }else{
        self.pageControl.frame = CGRectMake(0, 424, 320, 36);
    }
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = [imageNameArray count];
    self.pageControl.userInteractionEnabled= YES;
    self.pageControl.enabled =TRUE;
    [self.view addSubview:self.pageControl];
    
    for (int i = 0; i < imageNameArray.count; i++) {
        NSString *imgName = nil;
        UIImageView *imgView;

        imgName = [imageNameArray objectAtIndex:i];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width * i), 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:imgName];
        imgView.backgroundColor = [UIColor blackColor];

        [self.pageScroll addSubview:imgView];
        
        if (i == imageNameArray.count - 1) {
            UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(80.f, 355.f, 15.f, 15.f)];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_selectCheck"] forState:UIControlStateSelected];
            [checkButton setImage:[UIImage imageNamed:@"checkBox_blankCheck"] forState:UIControlStateNormal];
            [checkButton addTarget:self action:@selector(pressCheckButton:) forControlEvents:UIControlEventTouchUpInside];
            [checkButton setSelected:YES];
//            [view addSubview:checkButton];
            enterButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 173.0f, 96.0f)];
//            [enterButton setTitle:@"开始使用" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            if(DEVICE_IS_IPHONE5)
            {
                [enterButton setCenter:CGPointMake(self.view.center.x, 467.f)];
            }else{
                [enterButton setCenter:CGPointMake(self.view.center.x, 407.f)];
            }
            [enterButton setBackgroundImage:[UIImage imageNamed:@"ios_guide_start_button"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"ios_guide_start_button"] forState:UIControlStateHighlighted];
            [enterButton addTarget:self action:@selector(pressEnterButton:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:enterButton];
//            [enterButton.superview bringSubviewToFront:enterButton];
        }
    }
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
