//
//  DEPostInfoViewController.m
//  iDilicious_ASI
//
//  Created by navy on 12-12-16.
//  Copyright (c) 2012年 navy. All rights reserved.
//

#import "DEPostInfoViewController.h"
#import <objc/runtime.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import "SVWebViewController.h"

@interface DEPostInfoViewController ()

@property (nonatomic, retain) OHAttributedLabel *contentLabel;
@property (nonatomic, retain) DEPost *detailPost;

@end

@implementation DEPostInfoViewController

@synthesize contentLabel = _contentLabel;
@synthesize detailPost = _detailPost;

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self buildUI];
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"Bookmark";
    }
    return self;
}

- (void)buildUI
{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(doneAction:)];
	self.navigationItem.rightBarButtonItem = rightBtn;
	[rightBtn release];
    
    self.contentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width - 40, self.view.bounds.size.height)];
    self.contentLabel.shadowColor = [UIColor lightGrayColor];
    [self.view addSubview:self.contentLabel];
    
}

- (void)doneAction:(id)sender
{
    NSURL *URL = [NSURL URLWithString:self.detailPost.href];
	SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
	[self.navigationController pushViewController:webViewController animated:YES];
    [webViewController release];
}

- (void)updateByPost:(DEPost *)post
{
    NSString *contentString = @"";
    self.detailPost = post;
    
    NSMutableArray *arr = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self.detailPost class], &outCount);
    for(i = 0; i < outCount; i++) {
    	objc_property_t property = properties[i];
    	const char *propName = property_getName(property);
    	if(propName) {
    		//const char *propType = getPropertyType(property);
    		NSString *propertyName = [NSString stringWithCString:propName encoding:[NSString defaultCStringEncoding]];
    		//NSString *propertyType = [NSString stringWithCString:propType encoding:[NSString defaultCStringEncoding]];
            [arr addObject:propertyName];
            if ([[self.detailPost valueForKey:propertyName] length]) {
                contentString = [contentString stringByAppendingFormat:@"\n%@ : %@\n",[propertyName capitalizedString],[self.detailPost valueForKey:propertyName]]; 
            }
    	}
    }
    free(properties);
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:contentString];
    [attrStr setFont:[UIFont fontWithName:@"Helvetica" size:18]];

    for (NSString *str in arr)
    {
        [attrStr setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.5 alpha:1.f] range:[contentString rangeOfString:[str capitalizedString]]];
        [attrStr setTextColor:[UIColor darkGrayColor] range:[contentString rangeOfString:[self.detailPost valueForKey:str]]];
    }
    
    self.contentLabel.attributedText = attrStr;
    
//    [self.contentLabel addCustomLink:[NSURL URLWithString:@"web"] inRange:[contentString rangeOfString:self.detailPost.href]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
