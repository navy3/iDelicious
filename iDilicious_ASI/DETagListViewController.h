//
//  DETagListViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-11-30.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTTextFieldViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface DETagListViewController : UITableViewController<UIActionSheetDelegate,GTTextFieldDelegate,EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;
    NSInteger selectedIndex;
}
@end
