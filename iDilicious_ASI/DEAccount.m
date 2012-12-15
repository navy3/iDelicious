//
//  DEAccount.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-12.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEAccount.h"
#import "SSKeychain.h"

NSString *const kDeliciousServiceName = @"kDeliciousServiceName";
NSString *const kDeliciousAccountName = @"kDeliciousAccountName";
NSString *const kDeliciousPassword = @"kDeliciousPassword";

@implementation DEAccount

+ (void)saveName:(NSString *)name andPwd:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kDeliciousAccountName];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [SSKeychain setPassword:pwd forService:kDeliciousServiceName account:name];
}

+ (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kDeliciousAccountName];
}

+ (NSString *)password
{
    return [SSKeychain passwordForService:kDeliciousServiceName account:[DEAccount name]];
}

+ (void)registerAllDefaults
{
	NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"", kDeliciousAccountName,
                                   nil];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
