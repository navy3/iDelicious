//
//  DEDeliciousEngine.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-11.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEDeliciousEngine.h"
#import "DEAccount.h"

@implementation DEDeliciousEngine

+ (NSString *)requestURLwithType:(DEDeliciousRequestType)type
{
    NSString *urlString = @"";
    if (type == DEDeliciousPostsRequest) {
        urlString = [NSString stringWithFormat:@"https://%@:%@@api.del.icio.us/v1/posts/",[DEAccount name],[DEAccount password]];
    }
    else if (type == DEDeliciousTagsRequest) {
        urlString = [NSString stringWithFormat:@"https://%@:%@@api.del.icio.us/v1/tags/",[DEAccount name],[DEAccount password]];        
    }
    else if (type == DEDeliciousTagBundlesRequest) {
        urlString = [NSString stringWithFormat:@"https://%@:%@@api.del.icio.us/v1/tags/bundles/",[DEAccount name],[DEAccount password]];        
    }
    else {
        urlString = [NSString stringWithFormat:@"https://%@:%@@api.del.icio.us/v1/posts/",[DEAccount name],[DEAccount password]];        
    }
    return urlString;
}

@end
