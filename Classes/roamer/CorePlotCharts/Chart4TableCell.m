//
//  Chart4TableCell.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-27.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Chart4TableCell.h"

@implementation Chart4TableCell

@synthesize roadName;
@synthesize currentSpeed;
//@synthesize upAndDown;
//@synthesize lastHourSpeed;
//@synthesize lastWeekSpeed;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    DLog(@"table view cell willTransitionToState ");
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
            DLog(@"按钮的子视图的类名:%@", NSStringFromClass([subview class]));
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                subview.superview.backgroundColor = self.contentView.backgroundColor ;
            }
            if ([NSStringFromClass([subview class]) isEqualToString:@"UIView"]) {
                
            }else{
                
            }
        }
    }
}

- (void)setFrame:(CGRect)frame {

    frame.size.width = self.window.frame.size.width;
    [super setFrame:frame];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
