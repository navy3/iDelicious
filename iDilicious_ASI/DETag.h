//
//  DETag.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DETag : NSObject
{
    NSString *tag;
    NSString *count;
}

@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *count;

@end
