//
//  DEBaseViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-15.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface DEBaseViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
}

- (void)loadData;

@end
