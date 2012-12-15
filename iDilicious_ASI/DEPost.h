//
//  DLPost.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEPost : NSObject
{
    NSString *description;
    NSString *extended;
    NSString *hash;
    NSString *href;
    NSString *isPrivate;
    NSString *isShared;
    NSString *tag;
    NSString *time;
}

@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *extended;
@property (nonatomic, copy) NSString *hash;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *isPrivate;
@property (nonatomic, copy) NSString *isShared;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *time;

@end
