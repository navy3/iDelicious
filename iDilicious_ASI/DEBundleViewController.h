//
//  DEBundleViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-29.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "DEBundleEditorViewController.h"

@interface DEBundleViewController : UITableViewController<EGORefreshTableHeaderDelegate,DEBundleEditorDelegate>
{
    BOOL _reloading;
    NSInteger selectedIndex;
}

@end
