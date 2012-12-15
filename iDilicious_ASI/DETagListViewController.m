//
//  DETagListViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-30.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DETagListViewController.h"
#import "DEPostListViewController.h"
#import "ASIHTTPRequest.h"
#import "DEParser.h"
#import "DETag.h"
#import "DEDeliciousEngine.h"

@interface DETagListViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) DETag *deTag;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation DETagListViewController

@synthesize dataArray = _dataArray;
@synthesize deTag = _deTag;
@synthesize refreshHeaderView = _refreshHeaderView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_refreshHeaderView release];
    _refreshHeaderView = nil;
    [_dataArray release];
    _dataArray = nil;
    [_deTag release];
    _deTag = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
    _reloading = YES;
	[self loadTag];
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tags";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sheetAction)];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    [rightItem release];
    if (self.refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		self.refreshHeaderView = view;
		[view release];
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    [self loadTag];
}

- (void)sheetAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Action" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add",@"Edit",@"Refresh", nil];
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
    }
    else if(1 == buttonIndex) {
        [self.tableView setEditing:!self.tableView.isEditing animated:YES];
    }
    else if(2 == buttonIndex) {
        [self loadTag];
    }
}

- (void)loadTag
{
    NSString *urlString = [NSString stringWithFormat:@"%@get",[DEDeliciousEngine requestURLwithType:DEDeliciousTagsRequest]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Get" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)renameTag:(NSString *)tagName
{
    DETag *object = self.dataArray[selectedIndex];
 
    NSString *urlString = [NSString stringWithFormat:@"%@rename?old=%@&new=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousTagsRequest],object.tag,tagName];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Rename" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)deleteTag:(NSString *)tagName
{
    NSString *urlString = [NSString stringWithFormat:@"%@delete?tag=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousTagsRequest],tagName];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Delete" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[request.userInfo objectForKey:@"Type"] isEqualToString:@"Get"])
    {
        self.dataArray = [DEParser parseTags:[request responseString]];
        self.title = [NSString stringWithFormat:@"Tags (%d)",[self.dataArray count]];
        [self.tableView reloadData];
    }
    else if([[request.userInfo objectForKey:@"Type"] isEqualToString:@"Delete"])
    {
        NSString *code = [DEParser parseResult:request.responseString];

        if ([code isEqualToString:@"done"]) {
            [self.dataArray removeObjectAtIndex:selectedIndex];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            self.title = [NSString stringWithFormat:@"Tags (%d)",[self.dataArray count]];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:code delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
    else {
        NSString *code = [DEParser parseResult:request.responseString];
        if ([code isEqualToString:@"done"]) {
            [self.dataArray replaceObjectAtIndex:selectedIndex withObject:self.deTag];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:code delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
    }
    
    // Configure the cell...
    DETag *object = self.dataArray[indexPath.row];
    cell.textLabel.text = object.tag;
    cell.detailTextLabel.text = object.count;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    self.deTag = self.dataArray[selectedIndex];

    GTTextFieldViewController *tf = [[GTTextFieldViewController alloc] init];
    [tf groupName:self.deTag.tag];
    tf.delegate = self;
    [self.navigationController pushViewController:tf animated:YES];
    [tf release];
}

-(void)didInputTextField:(NSString *)text rootController:(UIViewController *)ctrl
{
    self.deTag.tag = text;
    [self renameTag:self.deTag.tag];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        selectedIndex = indexPath.row;
        DETag *object = self.dataArray[selectedIndex];
        [self deleteTag:object.tag];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    DEPostListViewController *post = [[DEPostListViewController alloc] init];
    DETag *object = self.dataArray[indexPath.row];
    post.title = object.tag;
    [self.navigationController pushViewController:post animated:YES];
    [post showStatBar];
    [post loadPostByType:object.tag];
    [post release];
}

@end
