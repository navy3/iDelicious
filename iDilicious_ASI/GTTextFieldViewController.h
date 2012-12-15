//
//  GTTextFieldViewController.h
//  GPSTracker
//
//  Created by  on 12-7-5.
//  Copyright (c) 2012年 freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GTTextFieldDelegate;

@interface GTTextFieldViewController : UIViewController<UITextFieldDelegate>
{
    id<GTTextFieldDelegate> delegate;
}

@property (nonatomic, assign) id<GTTextFieldDelegate> delegate;

- (void)groupName:(NSString *)str;

@end

@protocol GTTextFieldDelegate<NSObject>

@optional

-(void)didInputTextField:(NSString *)text rootController:(UIViewController *)ctrl;

@end