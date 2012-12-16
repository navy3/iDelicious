//
//  FGLoginViewController.m
//  FreeGo
//
//  Created by navy on 11-11-6.
//  Copyright 2011 freelancer. All rights reserved.
//

#import "FGLoginViewController.h"
#import "DEAccount.h"

#define TEXTFIELD_TAG   2


@implementation FGLoginViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Account";
		
//	UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)];
//	self.navigationItem.leftBarButtonItem = leftBtn;
//	[leftBtn release];
	
	UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[rightBtn release];
	
//	self.navigationItem.rightBarButtonItem.enabled = NO;
	
//	UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
//	footerView.backgroundColor = [UIColor clearColor];
//	
//	UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//	[regBtn setTitle:@"没有帐号?点击注册一个" forState:UIControlStateNormal];
//	[regBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//	[regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//	[regBtn addTarget:self action:@selector(regAction:) forControlEvents:UIControlEventTouchUpInside];
//	regBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//	[regBtn setFrame:CGRectMake(160, 5, 160, 30)];
//	[footerView addSubview:regBtn];
//	[_tableView setTableFooterView:footerView];
//	[footerView release];
	
	[nameField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.3];
}

#pragma mark -
#pragma mark textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	if (textField == nameField) {
		[pwdField becomeFirstResponder];
	} 
	else {
		[self doneAction:nil];
	}
	return YES;
}

#pragma mark -
#pragma mark nav action
- (void)regAction:(id)sender
{

}

- (void)cancelAction:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doneAction:(id)sender
{
    if ([nameField.text length]|| [pwdField.text length]) {
       [DEAccount saveName:nameField.text andPwd:pwdField.text];
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell...
	
	if (indexPath.row == 0) 
	{
		cell = nameCell;
        nameField.text = [DEAccount name];
	}
	else 
	{
		cell = pwdCell;
        pwdField.text = [DEAccount password];
	}
	
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UITextField *text = (UITextField*)[cell viewWithTag:TEXTFIELD_TAG];
	[text becomeFirstResponder];
	
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
