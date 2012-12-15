//
//  DEPostListViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-21.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
typedef enum DEPostsType{
    DEPost_Single,
    DEPost_Mutable,
}DEPostsType;

@interface DEPostListViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
    NSInteger selectedRow;
    NSInteger selectedSection;
    DEPostsType postType;
}

- (void)loadPostByType:(NSString *)type;
- (void)showStatBar;

- (void)loadMutableTags:(NSString *)tags;

@end
