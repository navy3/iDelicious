//
//  DLPost.m
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEPost.h"

@implementation DEPost

@synthesize description,extended,hash,href,isPrivate,isShared,tag,time;

- (void)dealloc
{
    [description release];
    [extended release];
    [hash release];
    [href release];
    [tag release];
    [time release];
    [isPrivate release];
    [isShared release];
    [super dealloc];
}

@end
