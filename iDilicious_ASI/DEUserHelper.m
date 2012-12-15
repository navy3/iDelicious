//
//  EDUserHelper.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-30.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEUserHelper.h"

#define DENameKey @"DENameKey"
#define DEPwdKey @"DEPwdKey"

@implementation DEUserHelper

+ (void)registerAllDefaults
{
    NSDictionary *defaultValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"", DENameKey,
								   @"",DEPwdKey,
                                   nil];
	
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:DENameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)savePassword:(NSString *)pwd
{
    [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:DEPwdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DENameKey];
}

+ (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:DEPwdKey];
}

@end
