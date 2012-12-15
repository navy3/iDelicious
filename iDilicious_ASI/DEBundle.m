//
//  DEBundle.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-29.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEBundle.h"

@implementation DEBundle

@synthesize bundle,tags;

- (void)dealloc
{
    [bundle release];
    [tags release];
    [super dealloc];
}

@end
