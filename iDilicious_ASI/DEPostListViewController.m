//
//  DEPostListViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEPostListViewController.h"
#import "DEPost.h"
#import "ASIHTTPRequest.h"
#import "DEParser.h"
#import "DEStatViewController.h"
#import "DEDeliciousEngine.h"
#import "DEPostInfoViewController.h"

@interface DEPostListViewController ()

@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *requestString;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, copy) NSArray *requestArray;
@end

@implementation DEPostListViewController

@synthesize dataArray = _dataArray;
@synthesize requestString = _requestString;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize requestArray = _requestArray;

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
    DE_RELEASE(_requestArray);
    DE_RELEASE(_requestString);
    DE_RELEASE(_refreshHeaderView);
    DE_RELEASE(_dataArray);
    [super dealloc];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
    _reloading = YES;
    [self loadPosts];
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

    if (self.refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		self.refreshHeaderView = view;
		[view release];
		
	}
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)showStatBar
{
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self action:@selector(statAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
}

- (void)statAction:(id)sender
{
    DEStatViewController *stat = [[DEStatViewController alloc] init];
    [stat setTagString:self.requestString];
    [self.navigationController pushViewController:stat animated:YES];
    [stat release];
}

- (void)loadPosts
{
    NSString *urlString;
    if (postType == DEPost_Single) {
        if ([self.requestString isEqualToString:@"Recent"]) {
            urlString = [NSString stringWithFormat:@"%@recent?count=20",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest]];
        }
        else if ([self.requestString isEqualToString:@"All"]) {
            urlString = [NSString stringWithFormat:@"%@all",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest]];
        }
        else {
            urlString = [NSString stringWithFormat:@"%@all?tag=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest],self.requestString];
        }
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"Get" forKey:@"Type"];
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else {
        for (int i = 0; i < [self.requestArray count]; i++) {
            NSString *tag = [self.requestArray objectAtIndex:i];
            urlString = [NSString stringWithFormat:@"%@all?tag=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest],tag];
            NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Get",@"Type",[NSNumber numberWithInt:i],@"Index", nil];
            [request setDelegate:self];
            [request startAsynchronous];
        }
    }


}

- (void)loadPostByType:(NSString *)type
{
    postType = DEPost_Single;
    if (![self.requestString isEqualToString:type]) {
        self.requestString = type;
        [self loadPosts];
    }

}

- (void)loadMutableTags:(NSString *)tags
{
    postType = DEPost_Mutable;
    self.requestArray = [tags componentsSeparatedByString:@" "];
    self.dataArray = [NSMutableArray arrayWithCapacity:[self.requestArray count]];
    for (int i = 0; i < [self.requestArray count]; i++) {
        [self.dataArray addObject:[NSMutableArray array]];
    }
    [self loadPosts];
}

- (void)deletePost:(NSString *)href
{
    NSString *urlString = [NSString stringWithFormat:@"%@delete?url=%@",[DEDeliciousEngine requestURLwithType:DEDeliciousPostsRequest],href];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    request.userInfo = [NSDictionary dictionaryWithObject:@"Delete" forKey:@"Type"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if([[request.userInfo objectForKey:@"Type"] isEqualToString:@"Get"])
    {
        if (postType == DEPost_Single) {
            self.dataArray = [DEParser parsePosts:[request responseString]];
            //self.title = [NSString stringWithFormat:@"%@ (%d)",self.requestString,[self.dataArray count]];
            [self.tableView reloadData];
        }
        else {
            int index = [[request.userInfo objectForKey:@"Index"] intValue];
            [self.dataArray replaceObjectAtIndex:index withObject:[DEParser parsePosts:[request responseString]]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
        }

    }
    else if([[request.userInfo objectForKey:@"Type"] isEqualToString:@"Delete"]) {
        NSString *code = [DEParser parseResult:request.responseString];
        if ([code isEqualToString:@"done"]) {
            if (postType == DEPost_Single) {
                [self.dataArray removeObjectAtIndex:selectedRow];
            }
            else {
                NSMutableArray *arr = [self.dataArray objectAtIndex:selectedSection];
                [arr removeObjectAtIndex:selectedRow];
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedRow inSection:selectedSection];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

            //self.title = [NSString stringWithFormat:@"%@ (%d)",self.requestString,[self.dataArray count]];
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
    if (postType == DEPost_Single)
        return  1;
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (postType == DEPost_Mutable) 
        return self.requestArray[section];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (postType == DEPost_Single)
        return [self.dataArray count];
    return [[self.dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        //}
    }
    
    if (postType == DEPost_Single) {
        DEPost *object = self.dataArray[indexPath.row];
        cell.textLabel.text = object.description;
        cell.detailTextLabel.text = object.href;
    }
    else {
        DEPost *object = self.dataArray[indexPath.section][indexPath.row];
        cell.textLabel.text = object.description;
        cell.detailTextLabel.text = object.href;
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        selectedRow = indexPath.row;
        selectedSection = indexPath.section;
        DEPost *object;
        if (postType == DEPost_Single) {
            object = self.dataArray[selectedRow];
        }
        else {
            object = self.dataArray[indexPath.section][indexPath.row];
        }
        [self deletePost:object.href];

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
    DEPost *object;
    if (postType == DEPost_Single) {
        object = self.dataArray[indexPath.row];
    }
    else {
        object = self.dataArray[indexPath.section][indexPath.row];
    }
    DEPostInfoViewController *detail = [[DEPostInfoViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    [detail updateByPost:object];
    [detail release];
}

@end
