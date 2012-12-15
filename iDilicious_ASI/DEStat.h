//
//  DEStat.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-3.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEStat : NSObject
{
    NSString *count;
    NSString *date;
}

@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *date;

@end
