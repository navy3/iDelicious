//
//  DEParser.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-1.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEParser : NSObject

+ (NSString *)parseResult:(NSString *)xmlString;
+ (NSMutableArray *)parsePosts:(NSString *)xmlString;
+ (NSMutableArray *)parseBundles:(NSString *)xmlString;
+ (NSMutableArray *)parseTags:(NSString *)xmlString;
+ (NSMutableArray *)parseStats:(NSString *)xmlString;

@end
