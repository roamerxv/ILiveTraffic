//
//  TableCell4Roadname.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-9-9.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Cell4Roadname.h"

@interface Cell4Roadname ()

@end


@implementation Cell4Roadname

@synthesize roadName;
@synthesize roadSpeed;
@synthesize _iFlySpeechSynthesizer;

-(IBAction)speechIt:(id)sender
{
    DLog(@"发音内容:%@", self.roadName.text);
    // 创建合成对象,为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
    //设置语音合成的参数 begin
    //语速,取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]]; //音量;取值范围 0~100
//    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]]; //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表 [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
//    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]]; //asr_audio_path保存录音文件路径,如不再需要,设置value为nil表示取消,默认目录是 documents
//    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    //设置语音合成的参数 end
    NSString * roadTTSName = [[NSString alloc] initWithString:self.roadName.text];
    roadTTSName = [roadTTSName stringByReplacingOccurrencesOfString:@"-" withString:@"向" ];

    [_iFlySpeechSynthesizer startSpeaking: [[NSString alloc]initWithFormat:@"%@的车速是每小时%@公里",roadTTSName, self.roadSpeed.text]];

}

/** 结束回调

 当整个合成结束之后会回调此函数

 @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error{

}


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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) dealloc
{

}

@end
