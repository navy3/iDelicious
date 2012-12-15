//
//  DEStat.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-3.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEStat.h"

@implementation DEStat

@synthesize count,date;

- (void)dealloc
{
    [count release];
    [date release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
