//
//  DEAddPostViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-17.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEAddPostViewController.h"
#import "ASIHTTPRequest.h"
#import "DEParser.h"
#import "DEDeliciousEngine.h"
#import "NSDate+DEDeliciousEngineUtilities.h"

@interface DEAddPostViewController ()

@property (nonatomic, retain) UITextField *linkField;
@property (nonatomic, retain) UITextField *descriptionField;
@property (nonatomic, retain) UITextField *tagsField;

@property (nonatomic, retain) UITableViewCell *linkCell;
@property (nonatomic, retain) UITableViewCell *descriptionCell;
@property (nonatomic, retain) UITableViewCell *tagsCell;

@end

@implementation DEAddPostViewController

@synthesize linkField = _linkField;
@synthesize descriptionField = _descriptionField;
@synthesize tagsField = _tagsField;

@synthesize linkCell = _linkCell;
@synthesize descriptionCell = _descriptionCell;
@synthesize tagsCell = _tagsCell;

- (void)dealloc
{
    DE_RELEASE(_linkField);
    DE_RELEASE(_descriptionField);
    DE_RELEASE(_tagsField);
    [super dealloc];
}

- (void)buildUI
{

    self.linkCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    self.linkField = [[[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.linkCell.contentView.bounds.size.width - 40, 30)] autorelease];
    self.linkField.font = [UIFont systemFontOfSize:18];
    self.linkField.clearButtonMode = UITextFieldViewModeAlways;
    self.linkField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.linkField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.linkField.placeholder = @"bookmark URL (required)";
    [self.linkCell addSubview:self.linkField];
    [self.linkField becomeFirstResponder];


    self.descriptionCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    self.descriptionField = [[[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.descriptionCell.contentView.bounds.size.width - 40, 30)] autorelease];
    self.descriptionField.font = [UIFont systemFontOfSize:18];
    self.descriptionField.clearButtonMode = UITextFieldViewModeAlways;
    self.descriptionField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.descriptionField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.descriptionField.placeholder = @"Description (required)";
    [self.descriptionCell addSubview:self.descriptionField];
    

    self.tagsCell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)] autorelease];
    self.tagsField = [[[UITextField alloc] initWithFrame:CGRectMake(20, 7, self.tagsCell.contentView.bounds.size.width - 40, 30)] autorelease];
    self.tagsField.font = [UIFont systemFontOfSize:18];
    self.tagsField.clearButtonMode = UITextFieldViewModeAlways;
    self.tagsField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.tagsField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.tagsField.placeholder = @"Tags (optional)";
    [self.tagsCell addSubview:self.tagsField];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self buildUI];
    }
    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Add Bookmark";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[rightBtn release];
    
}

- (void)doneAction:(id)sender
{
    if ([self.linkField.text length] && [self.descriptionField.text length]) {
        NSDate *date = [NSDate date];
        NSString *urlString = [NSString stringWithFormat:@"%@add?url=%@&description=%@&tags=%@&dt=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest],self.linkField.text,self.descriptionField.text,self.tagsField.text,[date stringFromDeliciousDate]];
        NSLog(@"%@",urlString);
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        [request setDelegate:self];
        [request startAsynchronous];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@",request.responseString);
    NSString *code = [DEParser parseResult:request.responseString];
    if ([code isEqualToString:@"done"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:code delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Something wrong,try again later" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Add a bookmark must contain a URL and Description";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"when you add many tags,use comma(,) to separated.";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    if (0 == indexPath.row) {
        cell = self.linkCell;
    }
    else if (1 == indexPath.row) {
        cell = self.descriptionCell;
    }
    else if (2 == indexPath.row) {
        cell = self.tagsCell;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
