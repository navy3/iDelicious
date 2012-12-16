//
//  FGLoginViewController.h
//  FreeGo
//
//  Created by navy on 11-11-6.
//  Copyright 2011 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FGLoginViewController : UIViewController {
	IBOutlet	UITableViewCell	*nameCell;
	IBOutlet	UITableViewCell	*pwdCell;
	
	IBOutlet	UITextField		*nameField;
	IBOutlet	UITextField		*pwdField;
	
	IBOutlet UITableView        *_tableView;

}

- (void)doneAction:(id)sender;

@end
