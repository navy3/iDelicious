//
//  GTTextFieldViewController.m
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import "GTTextFieldViewController.h"

@interface GTTextFieldViewController ()

@property (nonatomic, retain) UITextField *textField;

@end

@implementation GTTextFieldViewController

@synthesize textField,delegate;

- (void)dealloc
{
    [textField release];
    textField = nil;
    [super dealloc];
}

- (void)createTextField
{
	textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 240, 40)];
	textField.borderStyle = UITextBorderStyleRoundedRect;
	textField.rightViewMode = UITextFieldViewModeWhileEditing;
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
	textField.textAlignment = NSTextAlignmentCenter;
	textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeAlways;
	textField.center = CGPointMake(self.view.center.x, 80);
	textField.returnKeyType = UIReturnKeyDone;
	[self.view addSubview:textField];
	[textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doneAction:nil];
    return YES;
}

- (void)groupName:(NSString *)str
{
    textField.text = str;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self createTextField];
        
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(doneAction:)];
        self.navigationItem.rightBarButtonItem = rightItem;
        [rightItem release];
    }
    return self;
}

- (void)doneAction:(id)sender
{
	if ([textField.text length]) {
		[self.navigationController popViewControllerAnimated:YES];
		if ([delegate respondsToSelector:@selector(didInputTextField:rootController:)]) {
			[delegate didInputTextField:textField.text rootController:self];
		}
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
