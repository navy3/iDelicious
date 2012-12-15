//
//  DEPostInfoViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-16.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OHAttributedLabel/OHAttributedLabel.h>
#import "DEPost.h"

@interface DEPostInfoViewController : UIViewController <OHAttributedLabelDelegate>

- (void)updateByPost:(DEPost *)post;

@end
