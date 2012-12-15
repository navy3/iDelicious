//
//  EDUserHelper.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-30.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEUserHelper : NSObject

+ (void)registerAllDefaults;
+ (void)saveName:(NSString *)name;
+ (void)savePassword:(NSString *)pwd;
+ (NSString *)name;
+ (NSString *)password;

@end
