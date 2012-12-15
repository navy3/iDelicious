//
//  DETag.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DETag.h"

@implementation DETag

@synthesize tag,count;

- (void)dealloc
{
    [tag release];
    [count release];
    [super dealloc];
}

@end
