//
//  NewMyDiaryAddEdit.m
//  Squad
//
//  Created by AQB Mac 4 on 30/11/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "NewMyDiaryAddEdit.h"

@interface NewMyDiaryAddEdit ()
@end

@implementation NewMyDiaryAddEdit;
@synthesize delegate;


#pragma mark - Private Method



#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alwaysShowToolbar = NO;
    self.receiveEditorDidChangeEvents = YES;
    self.toolbarItemTintColor = [Utility colorWithHexString:@"32CDB8"];//[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:BASEURL];
    self.shouldShowKeyboard = NO;
}

- (void)editorDidChangeWithText:(NSString *)text andHTML:(NSString *)html{
    NSLog(@"%@",text );
    [delegate isTextChanged:YES];
}

#pragma  mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
