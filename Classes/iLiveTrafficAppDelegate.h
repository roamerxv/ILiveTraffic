
//  iLiveTrafficAppDelegate.h
//  iLiveTraffic
//
//  Created by sheva2003 on 10-8-20.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iLiveTrafficMapViewController.h"
#import "PPRevealSideViewController.h"
#import "NSDateFormatter+Extras.h"
#import "iLiveTrafficConfigure.h"
#import "iLiveTraffciLocationManager.h"
#import "Tools.h"
#import "DeviceInfoController.h"

#import "WZGuideViewController.h"

#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlySetting.h"
#import "IFlyFlowerCollector.h"
#import "Configer.h"

#import <Crashlytics/Crashlytics.h>

@class ViewController;

@interface iLiveTrafficAppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate> {
    
	UIWindow *window;
    
	NSInteger _networkingCount;
	UIToolbar* toolbar;
	
	UIBarItem* barItemUpdate;
	UIBarItem* barItemNavigaton;
	UIBarItem* barItemSwitchRoad;
	UIBarItem* barItemZoomToCity;
	UIBarItem* barItemShowPark;
	UIBarItem* barItemHelp;
	UIBarItem* barItemSetting;
	UIImage * updateBarImage;
	UIImage*  cancelBarImage;
	UIImage* coverImage;
	
	UIActivityIndicatorView* activeView;
	UIActivityIndicatorView* activeViewLoadingMap;
    
	
//	MapView* mapView;
	
	enum CURVIEWTYPE {
		map,info,setting,cityChange
	};
	
	CURVIEWTYPE curView;

    
	bool m_bAppInit;
	bool m_bAppActive;
	
    
    iLiveTrafficMapViewController *_mapViewController;
    iLiveTrafficConfigure *_configure;
    iLiveTraffciLocationManager *_locationManager;
    
    NSString* deviceInfoID;
    
    NSOperationQueue *queue;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;


@property (nonatomic, retain) IBOutlet UIToolbar* toolbar;

@property (nonatomic, retain) IBOutlet UIBarItem* barItemUpdate;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemNavigaton;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemSwitchRoad;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemZoomToCity;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemShowPark;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemHelp;
@property (nonatomic, retain) IBOutlet UIBarItem* barItemSetting;
@property (nonatomic, retain) NSOperationQueue *queue;




/******************
 modified by wbgao
 ******************/
@property (nonatomic, retain) iLiveTrafficMapViewController *mapViewController;
@property (nonatomic, retain) iLiveTrafficConfigure *configure;
@property (nonatomic, retain) iLiveTraffciLocationManager *locationManager;

@property(nonatomic,retain) NSString * deviceInfoID;

#define CONFIG [iLiveTrafficAppDelegate sharedAppDelegate].configure
#define LOCATIONMANAGER [iLiveTrafficAppDelegate sharedAppDelegate].locationManager

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)

+ (iLiveTrafficAppDelegate *)sharedAppDelegate;

- (NSURL *)smartURLForString:(NSString *)str;
- (NSString *)pathForTemporaryFileWithPrefix:(NSString *)prefix;


-(IBAction) clickbarItemUpdate:(id)sender;


-(void) updateBarItems;


-(void) updateAllSetting;

-(UIImage*) getCoverImage;
-(void) startLoadingAnimation;
-(void) stopLoadingAnimation;

+ (id)shared;



@end

