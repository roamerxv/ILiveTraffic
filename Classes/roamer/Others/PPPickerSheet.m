//
//  PPPickerSheet.m
//
//  Created by G on 1/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PPPickerSheet.h"

@interface PPPickerSheet()
@end

@implementation PPPickerSheet

@synthesize picker, toolbar, dataArray, selectedIndex, indexPath;

- (id)initWithTitle:(NSString *)title
{
	self = [super initWithTitle:@""
					   delegate:nil
			  cancelButtonTitle:nil
		 destructiveButtonTitle:nil
			  otherButtonTitles:nil];
	
	if(self)
	{
		self.picker = [[[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320, 216)] autorelease];
		self.picker.delegate = self;
		self.picker.dataSource = self;
		self.picker.showsSelectionIndicator = YES;

		self.toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
		self.toolbar.barStyle = UIBarStyleBlack;
		self.toolbar.translucent = YES;
		[self.toolbar sizeToFit];

		NSMutableArray *barItems = [NSMutableArray arrayWithCapacity:4];
		
		UILabel *promptLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
		promptLabel.text = title;
		promptLabel.backgroundColor = [UIColor clearColor];
		promptLabel.textColor = [UIColor whiteColor];
		UIBarButtonItem *promtpBtn = [[[UIBarButtonItem alloc] initWithCustomView:promptLabel] autorelease];
		[barItems addObject:promtpBtn];

		UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
		[barItems addObject:flexSpace];
		
        UIBarButtonItem *cancelBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)] autorelease];
		[barItems addObject:cancelBtn];
        
		UIBarButtonItem *doneBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"完成",nil) style:UIBarButtonItemStyleBordered target:self action:@selector(done:)] autorelease];
		[barItems addObject:doneBtn];

		[self.toolbar setItems:barItems animated:NO];

		[self addSubview:self.toolbar];
		[self addSubview:self.picker];
	}
	return self;
}

- (void)dealloc
{
	self.picker = nil;
	self.toolbar = nil;
	[super dealloc];
}

- (void)showInView:(UIView *)view
{
	[super showInView:view];
	[self setBounds:CGRectMake(0,0,320, 464)];
}

- (void)setDataArray:(NSArray *)anArray
{
	if(dataArray != anArray)
	{
		[dataArray release];
		dataArray = [anArray retain];
		[self.picker reloadAllComponents];
	}
}

- (void)setSelectedIndex:(int)anIndex
{
	if(selectedIndex == anIndex)
		return;
	
	selectedIndex = anIndex;
	[self.picker selectRow:selectedIndex inComponent:0 animated:NO];
}

- (IBAction)done:(id)sender
{
	[self dismissWithClickedButtonIndex:0 animated:YES];

	if(target && [target respondsToSelector:action])
	{
		if(self.indexPath)
			[target performSelector:action withObject:self.indexPath withObject:[NSNumber numberWithInt:self.selectedIndex]];
		else
			[target performSelector:action withObject:[NSNumber numberWithInt:self.selectedIndex]];
	}
}

-(void)cancel{
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)setTarget:(id)aTarget action:(SEL)anAction
{
	target = aTarget;
	action = anAction;
}

#pragma mark -
#pragma mark Picker DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.selectedIndex = row;
}

@end
