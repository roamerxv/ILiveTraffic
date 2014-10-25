//
//  NSDateFormatter+Extras.h
//  JZ
//
//  Created by G on 11-4-27.
//  Copyright 2011 Wenbin.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDateFormatter (Extras)
+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString;
+ (BOOL)isNeedRefreshTip:(NSString *)dateString;
+ (NSString*)currentDateTime;
@end
