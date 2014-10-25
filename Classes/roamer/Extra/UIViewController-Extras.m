//
//  UIViewController-Extras.m
//  iTravel
//
//  Created by G on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UIViewController-Extras.h"


@implementation UIViewController (Extras)


-(void)makeTipView{
    if (![CONFIG isTipViewDisplayed:self]) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",NSStringFromClass([self class])]];
        if (image) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            UIButton *helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [helpBtn setFrame:window.frame];
            
            [helpBtn setImage:image forState:UIControlStateNormal];
            [helpBtn setImage:image forState:UIControlStateHighlighted];
            [helpBtn setImage:image forState:UIControlStateSelected];
            [helpBtn addTarget:self action:@selector(helpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            helpBtn.alpha = 0;
            [window addSubview:helpBtn];
            
            [UIView beginAnimations:nil context:nil];
            helpBtn.alpha = 1;
            [UIView commitAnimations];
            
            [CONFIG setDisplayedTipView:self];
        }
    }
}

-(void)helpBtnClicked:(id)sender{
    UIButton *btn =(UIButton*)sender;
    [btn removeFromSuperview];
}
@end
