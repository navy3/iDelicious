//
//  DEBundleEditorViewController.h
//  iDilicious_ASI
//
//  Created by navy on 12-12-16.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum DEBundleType{
    DEBundle_Add_Type,
    DEBundle_Edit_Type,
}DEBundleType;

@protocol DEBundleEditorDelegate;

@interface DEBundleEditorViewController : UIViewController
{
    id<DEBundleEditorDelegate> delegate;
}

@property (nonatomic, assign) id<DEBundleEditorDelegate> delegate;

- (void)loadWithName:(NSString *)name andTags:(NSString *)tags;

@end

@protocol DEBundleEditorDelegate <NSObject>

- (void)bundleEditorViewController:(DEBundleEditorViewController *)vc withName:(NSString *)name andTags:(NSString *)tags;

@end