//
//  SDHelpViewController.m
//  SD
//
//  Created by Gao WenBin on 12-12-11.
//
//

#import "SDHelpViewController.h"

#define HELP_IMAGES_ARRAY [NSArray arrayWithObjects:@"ios_guide_01.png", @"ios_guide_02.png",@"ios_guide_03.png",@"ios_guide_04.png",@"ios_guide_05.png",nil]

@interface SDHelpViewController ()

@end

@implementation SDHelpViewController

@synthesize scrollView = _scrollView;
@synthesize closeBtn;

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

    [self initScrollView];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)initScrollView{
    
	self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    {
        CGFloat cx = 0;
        NSArray *imagesArray = HELP_IMAGES_ARRAY;
        NSInteger imageCount = [imagesArray count];
    
        NSInteger scrollerHeight = self.scrollView.frame.size.height;
        
        for (int i=0; i < imageCount; i++) {
            NSString *imageName = [imagesArray objectAtIndex:i];
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            iv.tag = i;
            iv.contentMode = UIViewContentModeScaleAspectFit;
            
            CGRect rect = iv.frame;
            
            rect.size.width = 320;
            rect.size.height = scrollerHeight;
            rect.origin.x = cx;
            rect.origin.y = 0;
            
            iv.frame = rect;
            
            [self.scrollView addSubview:iv];
            cx += self.scrollView.frame.size.width;
        }
        
        [self.scrollView setContentSize:CGSizeMake(320 * imageCount, scrollerHeight)];
        
    }
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    

}

-(IBAction)closeBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.scrollView = nil;
}

@end
