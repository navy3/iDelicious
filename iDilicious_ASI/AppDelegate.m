//
//  AppDelegate.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-20.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "AppDelegate.h"

#import "ASIHTTPRequest.h"

#import "TouchXML.h"

#import "DEHomeViewController.h"

#import "ASIFormDataRequest.h"

#import "DEAccount.h"

#import <OHAttributedLabel/OHAttributedLabel.h>

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DEAccount saveName:@"xiewenwei" andPwd:@"focusspeed1204"];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary]
//                         objectForKey:@"CFBundleVersion"];
//    NSLog(@"%@",version);
    
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://xiewenwei:focusspeed1204@api.del.icio.us/v1/tags/bundles/all"]];
//    [request setDelegate:self];
//    [request startAsynchronous];

//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.scjj.gov.cn:8635/view.aspx"]];
//	[request setPostValue:@"510113199310258049" forKey:@"jxname"];
//	[request setPostValue:@"DSHJPD" forKey:@"jxpwd"];
//    //[request setPostValue:@"46" forKey:@"jxlogin.x"];
//	//[request setPostValue:@"11" forKey:@"jxlogin.y"];
//	//[request setPostValue:@"on" forKey:@"rkxz"];
//    //[request setPostValue:@"213" forKey:@"jxyzm"];
//	[request setDelegate:self];
//	[request startAsynchronous];

//    NSDictionary *properties = [[[NSMutableDictionary alloc] init] autorelease];
//    [properties setValue:@"Test Value" forKey:NSHTTPCookieValue];
//    [properties setValue:@"ASIHTTPRequestTestCookie" forKey:NSHTTPCookieName];
//    [properties setValue:@".allseeing-i.com" forKey:NSHTTPCookieDomain];
//    [properties setValue:[NSDate dateWithTimeIntervalSinceNow:60*60] forKey:NSHTTPCookieExpires];
//    [properties setValue:@"/asi-http-request/tests" forKey:NSHTTPCookiePath];
//    NSHTTPCookie *cookie = [[[NSHTTPCookie alloc] initWithProperties:properties] autorelease];

    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.scjj.gov.cn:8635/login.aspx"]];
//    [request setUseSessionPersistence:YES];
//    [request setRequestCookies:[NSMutableArray arrayWithObject:cookie]];
//	[request setDelegate:self];
//	[request startAsynchronous];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    DEHomeViewController *masterViewController = [[[DEHomeViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)requestFinished:(ASIHTTPRequest *)re
{
    //NSLog(@"%@",re.responseCookies);
    UIImage *img = [UIImage imageWithData:re.responseData];
    NSLog(@"%@",img);
        
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.scjj.gov.cn:8635/indexBitmap.aspx"]];
    //[request setUseSessionPersistence:YES];
    //[request setRequestCookies:re.responseCookies];
	[request setDelegate:self];
	[request startAsynchronous];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
