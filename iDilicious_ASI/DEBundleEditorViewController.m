//
//  DEBundleEditorViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-16.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEBundleEditorViewController.h"

@interface DEBundleEditorViewController ()

@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextView *tagsView;

@end

@implementation DEBundleEditorViewController

@synthesize nameField,tagsView,delegate;

- (void)dealloc
{
    DE_RELEASE(nameField);
    DE_RELEASE(tagsView);
    [super dealloc];
}

- (void)buildUI
{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[rightBtn release];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.bounds.size.width - 40, 40)];
	nameField.borderStyle = UITextBorderStyleRoundedRect;
	nameField.rightViewMode = UITextFieldViewModeWhileEditing;
	nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	nameField.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
	nameField.textAlignment = NSTextAlignmentCenter;
    nameField.clearButtonMode = UITextFieldViewModeAlways;
    nameField.placeholder = @"Bundle name";
	[self.view addSubview:nameField];
	[nameField becomeFirstResponder];
    
    tagsView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, self.view.bounds.size.width - 40, 120)];
    [self.view addSubview:tagsView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, self.view.bounds.size.width - 40, 20)];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    tipLabel.text = @"comma separated between tags";
    [self.view addSubview:tipLabel];
    [tipLabel release]; 
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self buildUI];
    }
    return self;
}

- (void)loadWithName:(NSString *)name andTags:(NSString *)tags
{
    nameField.text = name;
    tagsView.text = tags;
}

- (void)doneAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([delegate respondsToSelector:@selector(bundleEditorViewController:withName:andTags:)]) {
        [delegate bundleEditorViewController:self withName:nameField.text andTags:tagsView.text];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
