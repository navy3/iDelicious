//
//  DEHomeViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-29.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEHomeViewController.h"
#import "DEBundleViewController.h"
#import "DETagListViewController.h"
#import "FGLoginViewController.h"
#import "DEAccount.h"

@interface DEHomeViewController ()

@property (nonatomic, retain) DEPostListViewController *postViewController;
@property (nonatomic, retain) DEBundleViewController *bundleViewController;
@property (nonatomic, retain) DETagListViewController *tagViewController;

@end

@implementation DEHomeViewController

@synthesize postViewController = _postViewController;
@synthesize bundleViewController = _bundleViewController;
@synthesize tagViewController = _tagViewController;

- (void)dealloc
{
    [_postViewController release];
    _postViewController = nil;
    
    [_bundleViewController release];
    _bundleViewController = nil;
    
    [_tagViewController release];
    _tagViewController = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"iDelicious";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.20f green:0.45f blue:0.82f alpha:1.00f];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (![[DEAccount name] length] || ![[DEAccount password] length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"please set your delicious account when you first use this application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        FGLoginViewController *login = [[FGLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section)
        return @"All";
    else if (1 == section)
        return @"Recent";
    else if (2 == section)
        return @"Bundles";
    else if (3 == section)
        return @"Tags";
    return @"Account";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
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
    
    if (0 == indexPath.section) {
        cell.textLabel.text = @"All Bookmarked";
    }
    else if (1 == indexPath.section) {
        cell.textLabel.text = @"Rectently Bookmarked";
    }
    else if (2 == indexPath.section) {
        cell.textLabel.text = @"All Bundles";
    }
    else if (3 == indexPath.section) {
        cell.textLabel.text = @"All Tags";
    }
    else {
        cell.textLabel.text = @"Account";
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
    if (0 == indexPath.section) {
        if (!self.postViewController) {
            self.postViewController = [[[DEPostListViewController alloc] init] autorelease];
        }
        self.postViewController.title = @"All";
        [self.navigationController pushViewController:self.postViewController animated:YES];
        [self.postViewController loadPostByType:@"All"];
        

    }
    else if (1 == indexPath.section) {
        if (!self.postViewController) {
            self.postViewController = [[[DEPostListViewController alloc] init] autorelease];
            

        }
        self.postViewController.title = @"Recent";
        [self.navigationController pushViewController:self.postViewController animated:YES];
        [self.postViewController loadPostByType:@"Recent"];
        
    }
    else if (2 == indexPath.section) {
        if (!self.bundleViewController) {
            self.bundleViewController = [[[DEBundleViewController alloc] init] autorelease];
        }
        [self.navigationController pushViewController:self.bundleViewController animated:YES];
    }
    else if (3 == indexPath.section) {
        if (!self.tagViewController) {
            self.tagViewController = [[[DETagListViewController alloc] init] autorelease];
        }
        [self.navigationController pushViewController:self.tagViewController animated:YES];
    }
    else {
        FGLoginViewController *login = [[FGLoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
        [login release];
    }
}

@end
