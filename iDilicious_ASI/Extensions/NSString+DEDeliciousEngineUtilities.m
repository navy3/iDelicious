//
//  NSString+NSString_DeliciousEngineUtilities.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-12.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "NSString+DEDeliciousEngineUtilities.h"

@implementation NSString (NSString_DeliciousEngineUtilities)

- (NSDate *)dateFromGithubDateString {
	
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	NSString *dateString = self;
    
    if (![[self substringWithRange:NSMakeRange([self length] - 1, 1)] isEqualToString:@"Z"])
    {
        NSMutableString *newDate = [self mutableCopy];
        [newDate deleteCharactersInRange:NSMakeRange(19, 1)];
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        dateString = newDate;
    }
    else
    {
        [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    
    return [df dateFromString:dateString];
    
}


- (NSString *)encodedString
{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@";/?:@&=$+{}<>,", kCFStringEncodingUTF8);
    
}

@end
