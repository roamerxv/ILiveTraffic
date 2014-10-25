//
//  TableCell4Roadname.h
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-9-9.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tools.h"

#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechConstant.h"



@interface Cell4Roadname : UITableViewCell<IFlySpeechSynthesizerDelegate>
{
    IBOutlet UILabel * roadName ;
    IBOutlet UILabel * roadSpeed;
    IFlySpeechSynthesizer *_iFlySpeechSynthesizer;

}

@property (nonatomic,retain) IBOutlet UILabel* roadName;
@property(nonatomic,retain) IBOutlet UILabel * roadSpeed;
@property(nonatomic,retain) IFlySpeechSynthesizer *_iFlySpeechSynthesizer;

-(IBAction) speechIt:(id) sender;

@end
