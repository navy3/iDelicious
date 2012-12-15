//
//  DEBundle.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-29.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEBundle : NSObject
{
    NSString *bundle;
    NSString *tags;
}

@property (nonatomic, copy) NSString *bundle;
@property (nonatomic, copy) NSString *tags;

@end
