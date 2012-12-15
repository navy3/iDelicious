//
//  DEBundleViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-29.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEBundleViewController.h"
#import "ASIHTTPRequest.h"
#import "DEParser.h"
#import "DEBundle.h"
#import "DEPostListViewController.h"
#import "DEDeliciousEngine.h"

@interface DEBundleViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;

@end

@implementation DEBundleViewController

@synthesize dataArray = _dataArray;
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
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
    _reloading = YES;
	[self loadBundle];
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
    
    self.title = @"Bundles";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Edit",@"Add",nil]];
	segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segCtrl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[segCtrl release];
	[rightBtn release];

    if (self.refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		self.refreshHeaderView = view;
		[view release];
		
	}
    
    [self loadBundle];
}

- (void)segAction:(UISegmentedControl *)segCtrl
{
    if (0 == segCtrl.selectedSegmentIndex) {
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
		self.navigationItem.rightBarButtonItem = rightBtn;
		[self.navigationItem setRightBarButtonItem:rightBtn animated:YES];
		[rightBtn release];
        
        [self.tableView setEditing:YES animated:YES];

    }
    else {
        DEBundleEditorViewController *editor = [[DEBundleEditorViewController alloc] init];
        editor.title = @"Add Bundle";
        editor.delegate = self;
        [self.navigationController pushViewController:editor animated:YES];
        [editor release];
    }
    
    segCtrl.selectedSegmentIndex = -1;
}

- (void)doneAction:(id)sender
{	
	UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Edit",@"Add",nil]];
	segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
	[segCtrl addTarget:self action:@selector(segAction:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:segCtrl];
	[self.navigationItem setRightBarButtonItem:rightBtn animated:YES];
	[segCtrl release];
	[rightBtn release];
    
    [self.tableView setEditing:NO animated:YES];
}

- (void)bundleEditorViewController:(DEBundleEditorViewController *)vc withName:(NSString *)name andTags:(NSString *)tags
{
    NSString *urlString = [NSString stringWithFormat:@"%@set?bundle=%@&tags=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousTagBundlesRequest],name,tags];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Add" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];

}

- (void)loadBundle
{
    NSString *urlString = [NSString stringWithFormat:@"%@all",[DEDeliciousEngine requestURLwithType:DEDeliciousTagBundlesRequest]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Get" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([[request.userInfo objectForKey:@"Type"] isEqualToString:@"Get"]) {
        self.dataArray = [DEParser parseBundles:[request responseString]];
        [self.tableView reloadData];
    }
    else {
        NSString *code = [DEParser parseResult:request.responseString];
        if ([code isEqualToString:@"done"]||[code isEqualToString:@"ok"]) {
           [self loadBundle];
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
    DEBundle *object = self.dataArray[indexPath.row];
    cell.textLabel.text = object.bundle;
    cell.detailTextLabel.text = object.tags;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    DEBundle *object = self.dataArray[indexPath.row];
    DEBundleEditorViewController *editor = [[DEBundleEditorViewController alloc] init];
    editor.title = @"Editor Bundle";
    editor.delegate = self;
    [self.navigationController pushViewController:editor animated:YES];
    [editor loadWithName:object.bundle andTags:object.tags];
    [editor release];
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
        DEBundle *object = self.dataArray[indexPath.row];
        NSString *urlString = [NSString stringWithFormat:@"%@delete?bundle=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousTagBundlesRequest],object.bundle];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        request.userInfo = [NSDictionary dictionaryWithObject:@"Add" forKey:@"Type"];
        [request setDelegate:self];
        [request startAsynchronous];
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
    DEBundle *object = self.dataArray[indexPath.row];
    //NSArray *arr = [object.tags componentsSeparatedByString:@" "];
    
    DEPostListViewController *post = [[DEPostListViewController alloc] init];
    [self.navigationController pushViewController:post animated:YES];
    post.title = object.bundle;
    [post loadMutableTags:object.tags];
    [post release];
}

@end
