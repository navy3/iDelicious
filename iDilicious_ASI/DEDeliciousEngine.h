//
//  DEDeliciousEngine.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-11.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DEDeliciousRequestTypes.h"

@interface DEDeliciousEngine : NSObject

+ (NSString *)requestURLwithType:(DEDeliciousRequestType)type;

@end
