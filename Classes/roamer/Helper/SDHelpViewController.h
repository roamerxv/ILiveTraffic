//
//  SDHelpViewController.h
//  SD
//
//  Created by Gao WenBin on 12-12-11.
//
//

#import <UIKit/UIKit.h>
#import "Tools.h"

@interface SDHelpViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    IBOutlet UIButton * closeBtn;
}

@property(retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UIButton * closeBtn;

-(IBAction)closeBtnClicked:(id)sender;

@end
