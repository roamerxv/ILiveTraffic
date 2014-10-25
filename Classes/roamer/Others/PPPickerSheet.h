//
//  PPPickerSheet.h
//
//  Created by G on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PPPickerSheet : UIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView		*picker;
	UIToolbar			*toolbar;
	NSArray				*dataArray;
	int					selectedIndex;
	id					target;
	SEL					action;
	NSIndexPath			*indexPath;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (id)initWithTitle:(NSString *)title;
- (void)setTarget:(id)aTarget action:(SEL)anAction;

@end
