//
//  tabbarView.m
//  tabbarTest
//
//  Created by Kevin Lee on 13-5-6.
//  Copyright (c) 2013年 Kevin. All rights reserved.
//

#import "tabbarView.h"



@implementation TabbarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setFrame:frame];
//        [self setBackgroundColor:[UIColor blueColor]];
        [self layoutView];
    }
    return self;
}

-(void)layoutView
{
    _tabbarView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_0"]];
    [_tabbarView setFrame:CGRectMake(0, 9, self.viewForBaselineLayout.frame.size.width, 51)];
    [_tabbarView setUserInteractionEnabled:YES];
    
    _tabbarViewCenter = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tabbar_mainbtn_bg"]];

    _tabbarViewCenter.center = CGPointMake(self.center.x, self.bounds.size.height/2.0);
    
    [_tabbarViewCenter setUserInteractionEnabled:YES];
    
    _button_center = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_center.adjustsImageWhenHighlighted = YES;
    [_button_center setBackgroundImage:[UIImage imageNamed:@"tabbar_mainbtn"] forState:UIControlStateNormal];

//    [_button_center.layer setBorderWidth:1.0f];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
//    [_button_center.layer setBorderColor:colorref];

    [_button_center setFrame:CGRectMake(0, 0, 46, 46)];
    
    _button_center.center =CGPointMake(_tabbarViewCenter.bounds.size.width/2.0, _tabbarViewCenter.bounds.size.height/2.0 + 5) ;
    [_button_center setTag:100];
    [_button_center addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tabbarViewCenter addSubview:_button_center];
    
    [self addSubview:_tabbarView];
    [self addSubview:_tabbarViewCenter];
    
    [self layoutBtn];

}

-(void)layoutBtn
{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });

    int button_width = (self.viewForBaselineLayout.frame.size.width - _button_center.frame.size.width- 12)/4 ;
    _button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button_1 setBackgroundColor:[UIColor blueColor]];
    [_button_1 setFrame:CGRectMake(0, 0, button_width, 60)];
    [_button_1 setTag:101];
    [_button_1 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_button_1.layer setBorderWidth:1.0f];
//    [_button_1.layer setBorderColor:colorref];

    _button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_2 setFrame:CGRectMake(_button_1.frame.origin.x+_button_1.frame.size.width+2, 0, button_width, 60)];
    [_button_2 setTag:102];
    [_button_2 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_button_2.layer setBorderWidth:1.0f];
//    [_button_2.layer setBorderColor:colorref];


    _button_4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_4 setFrame:CGRectMake(self.viewForBaselineLayout.frame.size.width -button_width -4 , 0, button_width, 60)];
    [_button_4 setTag:104];
    [_button_4 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_button_4.layer setBorderWidth:1.0f];
//    [_button_4.layer setBorderColor:colorref];



    _button_3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_3 setFrame:CGRectMake(_button_4.frame.origin.x - button_width - 4, 0, button_width, 60)];
    [_button_3 setTag:103];
    [_button_3 addTarget:self action:@selector(btn1Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_button_3.layer setBorderWidth:1.0f];
//    [_button_3.layer setBorderColor:colorref];



    [_tabbarView addSubview:_button_1];
    [_tabbarView addSubview:_button_2];
    [_tabbarView addSubview:_button_3];
    [_tabbarView addSubview:_button_4];
    
}

-(void)btn1Click:(id)sender
{
        
    UIButton *btn = (UIButton *)sender;
    DLog(@"%i",btn.tag);
    switch (btn.tag) {
        case 100:
            [self.delegate touchBtnAtIndex:-1];
            break;
        case 101:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_0"]];
            [self.delegate touchBtnAtIndex:0];
            break;
        }
        case 102:
        {
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_1"]];
            [self.delegate touchBtnAtIndex:1];
            break;
        }
        case 103:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_3"]];
            [self.delegate touchBtnAtIndex:2];
            break;
        case 104:
            [_tabbarView setImage:[UIImage imageNamed:@"tabbar_4"]];
            [self.delegate touchBtnAtIndex:3];
            break;
        default:
            DLog(@"点击了tab bar上的其他按钮");
            break;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
