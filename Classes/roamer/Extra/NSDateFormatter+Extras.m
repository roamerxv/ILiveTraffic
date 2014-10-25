//
//  NSDateFormatter+Extras.m
//  JZ
//
//  Created by G on 11-4-27.
//  Copyright 2011 Wenbin.Gao. All rights reserved.
//

#import "NSDateFormatter+Extras.h"


@implementation NSDateFormatter (Extras)

+ (NSString*)currentDateTime{
	NSDate *currentDateTime = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
	return dateInString;
}

+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	NSMutableString* str = [dateString mutableCopy];
//	[str replaceOccurrencesOfString:@"T" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [str length])];
//	[str replaceOccurrencesOfString:@"+08:00" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [str length])];
	DLog(@"dateDifferenceStringFromString str : %@",str);
	
	NSDate *date = [dateFormatter dateFromString:str];
	[str release];
	[dateFormatter release];
	NSDate *now = [NSDate date];
	
	double time = [date timeIntervalSinceDate:now];
	time *= -1;
	if(time < 1) {
		return @"刚刚";
	} else if (time < 60) {
		return @"1分钟前";
	} else if (time < 3600) {
		int diff = round(time / 60);
		return [NSString stringWithFormat:@"%d分钟前", diff];
	} else if (time < 86400) {
		int diff = round(time / 60 / 60);
		if (diff == 24)
			return @"昨天";
		return [NSString stringWithFormat:@"%d小时前", diff];
	} else if (time < 604800) {
		int diff = round(time / 60 / 60 / 24);
		if (diff == 1) 
			return @"昨天";
		if (diff == 7) 
			return @"上周";
		return[NSString stringWithFormat:@"%d天前", diff];
	} else {
		int diff = round(time / 60 / 60 / 24 / 7);
		if (diff == 1)
			return @"上周";
		return [NSString stringWithFormat:@"%d周前", diff];
	}   
}

+ (BOOL)isNeedRefreshTip:(NSString *)dateString{
    DLog(@"dateString : %@, class : %@",dateString,[dateString class]);
    if (dateString && [dateString isKindOfClass:[NSString class]] && dateString.length > 0 ) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSMutableString* str = [dateString mutableCopy];
        DLog(@"isLastDayDate str : %@",str);

        NSDate *date = [dateFormatter dateFromString:str];
        [str release];
        [dateFormatter release];
        NSDate *now = [NSDate date];

        double time = [date timeIntervalSinceDate:now];
        time *= -1;    

        if(time < 1) {
            return NO;
        } else if (time < 60) {
            return NO;
        } else if (time < 3600) {
            int diff = round(time / 60);
            if (diff > 5) { // 5 min
                return YES;
            } else {
                return NO;   
            }
        } else {
            return YES;
        }   
    } else {
        return YES;
    }
}

@end
