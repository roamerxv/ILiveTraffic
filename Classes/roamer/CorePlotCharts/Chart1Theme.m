//
//  Chart1Theme.m
//  ILiveTraffic
//
//  Created by 徐泽宇 on 13-5-15.
//  Copyright (c) 2013年 Tongji University. All rights reserved.
//

#import "Chart1Theme.h"

@implementation Chart1Theme

-( void )applyThemeToBackground:( CPTXYGraph *)graph
{
    // 终点色： 20 ％的灰度
    CPTColor *endColor = [ CPTColor colorWithGenericGray : 0.2f ];
    // 创建一个渐变区：起点、终点都是 0.2 的灰度
    CPTGradient *graphGradient = [ CPTGradient gradientWithBeginningColor :endColor endingColor :endColor];
    // 设置中间渐变色 1 ，位置在 30 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[ CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.3f ];
    // 设置中间渐变色 2 ，位置在 50 ％处，颜色为 5 0 ％的灰
    graphGradient = [graphGradient addColorStop :[ CPTColor colorWithGenericGray : 0.5f ] atPosition : 0.5f ];
    // 设置中间渐变色 3 ，位置在 60 ％处，颜色为 3 0 ％的灰
    graphGradient = [graphGradient addColorStop :[ CPTColor colorWithGenericGray : 0.3f ] atPosition : 0.6f ];
    // 渐变角度：垂直 90 度（逆时针）
    graphGradient. angle = 0.0f ;
    // 渐变填充
    graph. fill = [ CPTFill fillWithGradient :graphGradient];
}



//2、在坐标轴上画上网格线：

// 在 Y 轴上添加平行线
-( void )applyThemeToAxisSet:( CPTXYAxisSet *)axisSet {
    // 设置网格线线型
    CPTMutableLineStyle *majorGridLineStyle = [ CPTMutableLineStyle lineStyle ];
    majorGridLineStyle.lineWidth =2.0f ;
    majorGridLineStyle.lineColor = [ CPTColor lightGrayColor ];
    CPTXYAxis *y_axis=axisSet. yAxis ;
    // 轴标签方向： CPTSignNone －无，同 CPTSignNegative ， CPTSignPositive －反向 , 在 y 轴的右边， CPTSignNegative －正向，在 y 轴的左边
    y_axis.tickDirection = CPTSignNegative ;
    // 设置平行线，默认是以大刻度线为平行线位置
    y_axis.majorGridLineStyle = majorGridLineStyle ;

    
    // 如果 labelingPolicy 设置为 CPTAxisLabelingPolicyNone ， majorGridLineStyle 将不起作用
    //axis.labelingPolicy = CPTAxisLabelingPolicyNone ;
}


//3、设置绘图区
//
//下面的代码在绘图区（PlotArea）填充一个灰色渐变。注意由于绘图区（PlotArea）位于背景图（Graph）的上层（参考 Core Plot 框架的类层次图 ），因此对于绘图区所做的设置会覆盖对 Graph 所做的设置，除非你故意在 Graph 的 4 边留白，否则看不到背景图的设置。

-( void )applyThemeToPlotArea:( CPTPlotAreaFrame *)plotAreaFrame
{
    // 创建一个 20 ％ -50 ％的灰色渐变区，用于设置绘图区。
    CPTGradient *gradient = [ CPTGradient gradientWithBeginningColor :[ CPTColor colorWithGenericGray : 0.2f ] endingColor :[ CPTColor colorWithGenericGray : 0.7f ]];
    gradient. angle = 0.0f ;
    // 渐变填充
    plotAreaFrame. fill = [ CPTFill fillWithGradient :gradient];
}

@end
