//
//  iLiveTrafficMapViewController.h
//  ILiveTraffic
//  Copyright (c) 2014年 徐泽宇. All rights reserved.
//
//
//                     _ooOoo_
//                    o8888888o
//                    88" . "88
//                    (| -_- |)
//                    O\  =  /O
//                    _/`---'\____
//               .'  \\|     |//  `.
//              /  \\|||  :  |||//  \
//             /  _||||| -:- |||||-  \
//             |   | \\\  -  /// |   |
//             | \_|  ''\---/''  |   |
//             \  .-\__  `-`  ___/-. /
//           ___`. .'  /--.--\  `. . __
//        ."" '<  `.___\_<|>_/___.'  >'"".
//       | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//       \  \ `-.   \_ __\ /__ _/   .-` /  /
//  ======`-.____`-.___\_____/___.-`____.-'======
//                     `=---='
//  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//              佛祖保佑       永无BUG
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "iLiveTrafficScaleIndicatorView.h"
#import <ArcGIS/ArcGIS.h>
#import "TrafficeIndexController.h"
#import "Chart2ViewController.h"
#import "Chart1ViewController.h"
#import "Chart4ViewController.h"
#import "Chart3MetroViewController.h"
#import "CustomizeRoadListViewController.h"

#import "MainRoadSpeedViewController.h"

#import "tabbarViewController.h"

#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"



//讯飞语音使用的头文件
//不带界面的语音识别控件
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
//不带界面的语音合成控件
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"

#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"


#import "ISRDataHelper.h"
#import "RecognizerFactory.h"
#import "PopupView.h"

#import "FBShimmeringView.h"
#import "AMSmoothAlertView.h"


#import "Configer.h"



@interface iLiveTrafficMapViewController : UIViewController<PPRevealSideViewControllerDelegate,AGSMapViewTouchDelegate,AGSLayerDelegate,AGSQueryTaskDelegate,IFlySpeechRecognizerDelegate,CLLocationManagerDelegate,NSURLConnectionDelegate>{
    
    AGSMapView* _mapView;
    
    CLLocationManager *locationManager;
    CLLocation *        currentLocation;
    bool isLocationMode ;
    
    int refreshTime;
    
    IBOutlet UILabel * scaleText;
    IBOutlet UITextField * inputScale;
    
    IBOutlet UILabel * currentArearCongestIndex ;
    int currentArearCode ;
    IBOutlet UILabel * currentArearName;
    
    IBOutlet UIButton * locationBtn;
    
    IBOutlet UIButton * locateCenterBtn; //在导航模式下当前位置置中。
    
    IBOutlet UIButton * ttsBtn; //发音按钮

    IBOutlet UIButton * downloadMapBtn; //下载地图按钮

    IBOutlet UIButton * aboutBtn ; //关于的按钮

    IBOutlet UIButton * customizeBtn ; //定制按钮
    
    double currentScale;//保持当前的比例尺

    IBOutlet UIView * maskView ;
    
    
    NSMutableData * receivedData ;
    
    
    AGSQueryTask      *queryTask1;
    AGSQuery                *query1;
    AGSQueryTask      *queryTask2;
    AGSQuery                *query2;

    AGSGraphicsLayer    *graphicsLayer;
    
    //查询任务是否结束的开关
    BOOL query1Completed ;
    BOOL query2Completed ;
    
    //讯飞用户词表上传对象
    IFlyDataUploader * _iFly_uploader ;
    //语音识别对象
    IFlySpeechRecognizer * _iFlySpeechRecognizer;

    PopupView * _popUpView;
    
}

@property (nonatomic, retain) IBOutlet AGSMapView * mapView;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *aiv;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel * cityCongestLabel;
@property (nonatomic, retain) IBOutlet UILabel * cityCongestDescLabel;

@property (nonatomic, retain) IBOutlet UIButton *refreshBtn;
@property (nonatomic, retain) IBOutlet UIButton *locateCenterBtn;
@property (nonatomic,retain) IBOutlet UIButton *locationBtn;
@property (nonatomic,retain) IBOutlet UIButton * ttsBtn;
@property (nonatomic,retain) IBOutlet UIButton * downloadMapBtn;
@property (nonatomic,retain) IBOutlet UIButton * customizeBtn;
@property (nonatomic,retain) IBOutlet UIButton * aboutBtn;

@property (nonatomic, retain) IBOutlet UILabel *dataTimeLabel;
@property (nonatomic, retain) IBOutlet iLiveTrafficScaleIndicatorView *siView;
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) BOOL query1Completed;
@property (nonatomic) BOOL query2Completed;


@property (nonatomic,retain) IBOutlet UILabel * scaleText;
@property (nonatomic,retain) IBOutlet UITextField * inputScale;

@property (nonatomic,retain) IBOutlet UILabel* currentArearCongestIndex;
@property (nonatomic) int currentArearCode;
@property(nonatomic) int oldArearCode;
@property(nonatomic,retain) IBOutlet UILabel* currentArearName;

@property(nonatomic,retain) CLLocationManager *locationManager; 
@property(nonatomic,retain)  CLLocation*   currentLocation;
@property(nonatomic) bool isLocationMode;
@property(nonatomic) double currentScale;

@property(nonatomic,retain) NSMutableData * receivedData ;
//保存各个分区拥堵指数
@property(nonatomic,retain) NSString * arearCongestIndex;

//Arcgis 图层的查询
@property(nonatomic, retain) IBOutlet AGSQueryTask     *queryTask1;
@property(nonatomic, retain) IBOutlet AGSQuery   *query1;
@property(nonatomic, retain) IBOutlet AGSQueryTask     *queryTask2;
@property(nonatomic, retain) IBOutlet AGSQuery   *query2;

@property(nonatomic,retain) AGSLayer * baseMapLayer; //底图

@property(nonatomic, retain) IBOutlet AGSGraphicsLayer   *graphicsLayer;

@property(nonatomic,retain)  IFlyDataUploader * _iFly_uploader ;
@property (nonatomic, strong) IFlySpeechRecognizer * _iFlySpeechRecognizer;

@property(nonatomic,retain) IBOutlet UIView * maskView;

//道路定制
-(IBAction) customizeBtnClicked:(id)sender;


-(IBAction)menuBtnClicked:(id)sender;
-(IBAction)locationBtnClicked:(id)sender;
-(IBAction)chartBtnClicked:(id)sender;

//刷新所有后台数据
-(IBAction)refreshAll:(id)sender;

//显示图表界面
-(IBAction) showPlotCoreChart:(id)data ;
//指定缩放比例
-(IBAction) inputScale:(id)sender;
//在跟随模式下，移动过地图后 ，将不再跟随。这个功能则是以当前位置为中心，并且启动跟随
-(IBAction) currentLocationAsCenter:(id)sender;

//语音识别 进行查询
-(IBAction) speechRecognizer:(id)sender;


//点击全市拥堵指数按钮
-(IBAction) onCityCongestIndexButtonClick:(id)sender;

//改变底图
-(IBAction) changeBaseMapLayer:(id)sender;


@end
