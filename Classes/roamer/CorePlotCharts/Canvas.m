
#import "Canvas.h"


@implementation Canvas


@dynamic piesData;
@dynamic lastUpdateTime;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        long_mark_line_length = 8;
        short_mark_line_length = 3;
        radius = 0;

         /* 自动计算匹配的 直径 */
        if(self.bounds.size.width <= self.bounds.size.height)
        {
            radius = self.bounds.size.width/2-long_mark_line_length-15;
        }else{
            radius = self.bounds.size.height/2-long_mark_line_length-15;
        }
        center_x = self.bounds.origin.x + self.bounds.size.width/2;
        
        center_y = self.bounds.origin.y + self.bounds.size.height/2;



        //显示背景图
        /*
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"clockBGImg"]];
        */
        
        /*
        lastUpdateTime = [[UILabel alloc]initWithFrame:CGRectMake(center_x-20.0f, center_y-20.0f , 100.0f, 33.0f)];
        lastUpdateTime.text=@"";
        [self addSubview:lastUpdateTime];
         */
        
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    DLog(@"$$$$%@",@"Draw rect");
    // 获得饼图数据
    piesData=[[NSMutableArray alloc]init ];
    [self renderPies];
}



-(void) renderPies{
    [self getPiesData];
    [self drawPies];
    [self drawLastUpdateTimeLabel:@""];
}

#pragma 调用rest服务，获得远程数据

-(void) getPiesData
{
    //   获得全市拥堵指数
    piesData=[[NSMutableArray alloc]init ];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSURL *url = [[NSURL alloc] initWithString:[[Tools getServerHost] stringByAppendingString:@"/congest_index/congest_index_of_city_for_today.json"]];
    NSError *error =nil ;
    NSStringEncoding encoding;
    //NSString *my_string = [[NSString alloc] initWithContentsOfURL:url
    //                                                     encoding:NSUTF8StringEncoding
    //                                                        error:&error];
    NSString *current_congest_index = [[NSString alloc] initWithContentsOfURL:url
                                                                 usedEncoding:&encoding
                                                                        error:&error];
    DLog(@"画饼图的url是:%@,远程方法返回的内容是：%@", [url absoluteString], current_congest_index);
    if (error == nil) {
        AGSSBJsonParser * parser = [[AGSSBJsonParser alloc] init];
        NSMutableDictionary *jsonDic = [parser objectWithString:current_congest_index error:&error];
        NSMutableDictionary * datasetIndexInfo = [jsonDic objectForKey:@"dataset"];
        // 获得上午还是下午的标记位数据
        section_flag = [(NSString *)[datasetIndexInfo objectForKey:@"section"] intValue];
        DLog(@"需要显示的饼图是上午还是下午(0：上午，1：下午)=%d", section_flag);
        
        for(NSMutableDictionary * data  in [datasetIndexInfo objectForKey:@"data"])
        {
            //            DLog(@"%@",[[data objectForKey:@"time_id"] description]);
            [piesData addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[data objectForKey:@"time_id"], @"x",[f numberFromString:[data objectForKey:@"value"]], @"y", nil]];
        }
    }else{
        DLog(@"$$$$$$$%@", error);
        NSString * message = [NSString stringWithFormat:@"无法获取数据\n请再次点击按钮\n%@",[error description] ];
        AMSmoothAlertView *alert = [[AMSmoothAlertView alloc] initDropAlertWithTitle:@"提示" andText:message andCancelButton:NO forAlertType:AlertFailure];
        [alert.defaultButton setTitle:@"OK" forState:UIControlStateNormal];
        [alert show];
    }
    DLog(@"获取饼图数据");
}


-(void) drawPies
{
    DLog(@"开始渲染");
    if (piesData == nil || piesData.count >0) {
        UIColor *leve1Color = [Tools getLevelColrorWithLevel:1];
        UIColor *leve2Color = [Tools getLevelColrorWithLevel:2];
        UIColor *leve3Color = [Tools getLevelColrorWithLevel:3];
        UIColor *leve4Color = [Tools getLevelColrorWithLevel:4];
        UIColor *leve5Color = [Tools getLevelColrorWithLevel:5];
        
        UIColor * bgColor = [UIColor whiteColor];
        [bgColor setFill];
        
        float startAngle = -M_PI/2;
        float stepAngle = 360.0/144/180*M_PI;
        //    设置线宽
        CGContextSetLineWidth (UIGraphicsGetCurrentContext(), 0.0);
        //    画钟表圈
        [self drawCircleWithCenter: CGPointMake(center_x,center_y) radius:radius];
        // 画外圈的弧
        bgColor = [UIColor blackColor];
        [self drawArcFromCenter:CGPointMake(center_x,center_y) radius:radius+1.0f  startAngle:0.0f endAngle:360.0f  clockwise:YES] ;

        bgColor = [UIColor whiteColor];
        int begin_time_id = 1 ;
        int end_time_id  = 144;
        if ( section_flag == 0)
        {
            begin_time_id = 1;
            end_time_id = 144;
        }else
        {
            begin_time_id = 145;
            end_time_id = 288;
        }
        for (  ;begin_time_id <=end_time_id; begin_time_id++)
        {
            NSMutableDictionary * item = ((NSMutableDictionary *)[piesData objectAtIndex:begin_time_id-1]);
            //        DLog(@"时间点是：%@，数值是：%@",[ item objectForKey:@"x"], [item objectForKey:@"y"]);
            if ( [item objectForKey:@"y"]== NULL || [(NSNumber *)[item objectForKey:@"y"] floatValue]  < 0.0 )
            {
                [bgColor setFill];
            }else if([(NSNumber *)[item objectForKey:@"y"] floatValue]  >= 0.0 && [(NSNumber *)[item objectForKey:@"y"] floatValue]  <= 2.0){
                [leve1Color setFill];
            }else if([(NSNumber *)[item objectForKey:@"y"] floatValue]  >= 2.0 && [(NSNumber *)[item objectForKey:@"y"] floatValue]  < 4.0){
                [leve2Color setFill];
            }else if([(NSNumber *)[item objectForKey:@"y"] floatValue]  >= 4.0 && [(NSNumber *)[item objectForKey:@"y"] floatValue]  < 6.0){
                [leve3Color setFill];
            }else if([(NSNumber *)[item objectForKey:@"y"] floatValue]  >= 6.0 && [(NSNumber *)[item objectForKey:@"y"] floatValue]  < 8.0){
                [leve4Color setFill];
            }else if([(NSNumber *)[item objectForKey:@"y"] floatValue]  >= 8.0 && [(NSNumber *)[item objectForKey:@"y"] floatValue]  < 10.0){
                [leve5Color setFill];
            }
            [self drawSectorFromCenter:CGPointMake(center_x,center_y)
                                radius:radius
                            startAngle:startAngle
                              endAngle:startAngle+stepAngle
                             clockwise:YES];
            startAngle = startAngle+ stepAngle ;
            
        }
    }
    //    画刻度线
    [self drawMarkLine];

}

#pragma 画钟表刻度线和数字
-(void) drawMarkLine{
    DLog(@"圆形的半径:%f",radius);
    //设置字体样式
    UIFont *font = [UIFont fontWithName:@"Courier" size:13.0f];
    UIColor *magentaColor =[UIColor blackColor];
    /* Set the color in the graphical context */
    [magentaColor set];
    CGContextSetLineWidth (UIGraphicsGetCurrentContext(), 1.0);
    for(int i = 1 ; i <= 48 ; i++)
    {
        float start_x  = center_x+ radius*cos((i-1)*(360.0/48.0)*M_PI/180.0) ;
        float start_y =  center_y + radius*sin((i-1)*(360.0/48.0)*M_PI/180.0);
        float end_x = 0.0f;
        float end_y = 0.0f;
        if( i == 1 || ((i-1) % 4 )== 0 )
        {
            end_x = center_x + (radius - long_mark_line_length)*cos((i-1)*(360.0/48.0)*M_PI/180.0);
            end_y  =   center_y + (radius - long_mark_line_length) * sin((i-1)*(360.0/48.0)*M_PI/180.0);
        }else{
            end_x = center_x + (radius - short_mark_line_length)*cos((i-1)*(360.0/48.0)*M_PI/180.0);
            end_y  =   center_y + (radius - short_mark_line_length) * sin((i-1)*(360.0/48.0)*M_PI/180.0);
        }
        magentaColor =[UIColor blackColor];
        [magentaColor set];
        [self  drawLineFrom:CGPointMake(start_x, start_y) to:CGPointMake(end_x, end_y)];
        
        // 画时钟数组
        NSString * hour = @"" ;
        switch (i)
        {
                case 1:
                    end_x = end_x+12;
                    end_y = end_y-8;
                    hour =  @"3" ;
                    break;
                case 13:
                    end_x = end_x-4;
                    end_y = end_y+10;
                    hour =  @"6" ;
                    break;
                case 25:
                    end_x = end_x-20;
                    end_y = end_y-7;
                    hour =  @"9" ;
                    break;
                case 37:
                    end_x = end_x-6;
                    end_y = end_y-25;
                    hour =  @"12" ;
                    break;

                default:
                    break;
        }
        magentaColor =[UIColor whiteColor];
        [magentaColor set];
        /* 这段代码是使用skd 7.0 里面的方法。但是在 ios 6 运行的时候，会出现问题
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = NSTextAlignmentRight;
        NSDictionary * dictionary = @{
                                        NSFontAttributeName: font,
                                        NSForegroundColorAttributeName: magentaColor,
                                        NSParagraphStyleAttributeName: paragraphStyle
                                      };
        
        [hour drawInRect:CGRectMake(end_x,end_y,200,100) withAttributes:dictionary];
        */
        DLog(@"当前版本%@",[UIDevice currentDevice].systemVersion);
        // #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
        [hour  drawInRect:CGRectMake(end_x,/* x */
                                     end_y, /* y */
                                     200, /* width */
                                     10) /* height */
                 withFont:font];
  
        
    }
}

#pragma mark 显示最后时间
-(void) drawLastUpdateTimeLabel:(NSString *) lastupdatedTimeString{
//    self.lastUpdateTime.text = lastupdatedTimeString;
}


@end
