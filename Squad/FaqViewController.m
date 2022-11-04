//
//  FaqViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 06/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "FaqViewController.h"

@interface FaqViewController () {
    IBOutlet UITextView *mainTextView;
}

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"squad" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]
                                            initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                            documentAttributes: nil
                                            error: nil
                                            ];
//    UIFont *font = [UIFont fontWithName:@"Raleway-Bold" size:16];
       // [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    mainTextView.attributedText = attributedString;
//    mainTextView.textAlignment = NSTextAlignmentCenter;
    mainTextView.textColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
