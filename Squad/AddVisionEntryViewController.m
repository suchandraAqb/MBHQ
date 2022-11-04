//
//  AddVisionEntryViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 20/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddVisionEntryViewController.h"
#import "Utility.h"
#import "NSString+HTML.h"

@interface AddVisionEntryViewController ()
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@end

@implementation AddVisionEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)doneTapped:(id)sender {
    //    NSLog(@"res %@",resultDict);
//    if ([self validationCheck]) {
//        [self saveData];
//    }
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString:@"CKEDITOR.instances.editor.getData()"];
    
    if (html.length > 0){
        [self dismissViewControllerAnimated:YES completion:nil];
        [_addVisionEntryDelegate addVisionEntryFromString:html];
    } else {
        [Utility msg:@"Please enter some text!" title:@"Oops!" controller:self haveToPop:NO];
    }
}
#pragma mark - Load content locally.

- (void)loadContent {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ckeditor/demo.html" ofType:nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}


#pragma mark - WebView Methods

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:_visionBoardDict]) {
            NSString *detailsString = [_visionBoardDict objectForKey:@"OnThisDateIwillLook"];
            if (![Utility isEmptyCheck:detailsString]) {
                [self.webView stringByEvaluatingJavaScriptFromString:[@"" stringByAppendingFormat:@"document.getElementById('editor').innerHTML='%@';",[detailsString stringByRemovingNewLinesAndWhitespace]]];
            }
        } else {
            
        }
    });
    
}


@end
