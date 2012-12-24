//
//  NSDate+DEDeliciousEngineUtilities.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-17.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "NSDate+DEDeliciousEngineUtilities.h"

@implementation NSDate (DEDeliciousEngineUtilities)

- (NSString *)stringFromDeliciousDate
{
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    NSDate *date = self;
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [df stringFromDate:date];
}

@end
