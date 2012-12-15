//
//  DEAccount.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-12.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDeliciousServiceName;
extern NSString *const kDeliciousAccountName;
extern NSString *const kDeliciousPassword;

@interface DEAccount : NSObject

+ (void)saveName:(NSString *)name andPwd:(NSString *)pwd;
+ (NSString *)name;
+ (NSString *)password;

+ (void)registerAllDefaults;

@end
