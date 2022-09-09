//
//  PrivacyPolicyAndTermsServiceViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 20/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "PrivacyPolicyAndTermsServiceViewController.h"


@interface PrivacyPolicyAndTermsServiceViewController ()<WKNavigationDelegate>

{
    IBOutlet UIImageView *headerBg;
    IBOutlet WKWebView *webView;
    UIView *contentView;
    NSURLSession *session;
    IBOutlet UIButton *shareButton;
    
    
}

@end

@implementation PrivacyPolicyAndTermsServiceViewController
@synthesize url,isFromCourse;
#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)backButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(),^ {
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

-(IBAction)shareButtonPressed:(id)sender{
    if (isFromCourse) {
        NSURL *sourceURL = url;
        shareButton.hidden = false;
        if ([self checkForDownload]) {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
//            NSLog(@"fullPathToFile=%@",fullPathToFile);
            NSURL *documentDirectoryURl = [NSURL fileURLWithPath:fullPathToFile];
            NSArray *activityItems = @[documentDirectoryURl];
            UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
            activityController.excludedActivityTypes = @[
                                                         UIActivityTypeAssignToContact,
                                                         UIActivityTypePrint,
                                                         UIActivityTypeAddToReadingList,
                                                         UIActivityTypeSaveToCameraRoll,
                                                         UIActivityTypeOpenInIBooks,
                                                         @"com.apple.mobilenotes.SharingExtension",
                                                         @"com.apple.reminders.RemindersEditorExtension"
                                                         ];
            [self presentViewController:activityController animated:YES completion:nil];
        }else{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];
                
                if ([fileManager fileExistsAtPath:[destinationURL path]]) {
                    [fileManager removeItemAtURL:destinationURL error:nil];
                }
                return destinationURL;
                
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self->contentView){
                        [self->contentView removeFromSuperview];
                    }
                });
                
                if(!error){
                    if(self->contentView){
                        [self->contentView removeFromSuperview];
                    }
                   
                    NSURL *sourceURL = self->url;
                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString* documentsDirectory = [paths objectAtIndex:0];
                    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                    
                    if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                        [self->shareButton setImage:[UIImage imageNamed:@"share_course.png"] forState:UIControlStateNormal];
                        NSLog(@"Single Download success. original main.");
                        NSLog(@"url %@",fullPathToFile);
                        NSURL *documentDirectoryURl = [NSURL fileURLWithPath:fullPathToFile];
                        NSArray *activityItems = @[documentDirectoryURl];
                        UIActivityViewController *activityController = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
                        activityController.excludedActivityTypes = @[
                                                                     UIActivityTypeAssignToContact,
                                                                     UIActivityTypePrint,
                                                                     UIActivityTypeAddToReadingList,
                                                                     UIActivityTypeSaveToCameraRoll,
                                                                     UIActivityTypeOpenInIBooks,
                                                                     @"com.apple.mobilenotes.SharingExtension",
                                                                     @"com.apple.reminders.RemindersEditorExtension"
                                                                     ];
                        [self presentViewController:activityController animated:YES completion:nil];
                    }
                    
                }else{
                    if(self->contentView){
                        [self->contentView removeFromSuperview];
                    }
                    NSLog(@"Download completed with error: %@", [error localizedDescription]);
                    if(![Utility isOfflineMode])[Utility msg: [@"" stringByAppendingString:@" Error downloading video.Check Your network connection and try again."] title:@"Oops! " controller:self haveToPop:NO];
                }
            }];
            [downloadTask resume];
        }
    }else{
        shareButton.hidden = true;
    }
}


#pragma mark -End

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    if (isFromCourse) {
            if ([self checkForDownload]) {
                 shareButton.hidden = false;
            }else{
                 shareButton.hidden = true;
            }
    }else{
            shareButton.hidden = true;
        }
    if (![Utility isEmptyCheck:url]) {
        if ([Utility reachable]) {
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            webView.navigationDelegate = self;
            [webView loadRequest:request];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - End


#pragma mark -Privete method
-(BOOL)checkForDownload{
    BOOL alreadyExist = NO;
    NSURL *sourceURL = url;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
    NSLog(@"fullPathToFile=%@",fullPathToFile);
    
    if([fileManager fileExistsAtPath:fullPathToFile]) {
        [shareButton setImage:[UIImage imageNamed:@"share_course.png"] forState:UIControlStateNormal];
        alreadyExist = true;
    }else{
        [shareButton setImage:[UIImage imageNamed:@"cloud_course.png"] forState:UIControlStateNormal];
        alreadyExist = false;
    }
    return alreadyExist;
}

#pragma mark -End




#pragma mark - WebView Delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    if (contentView) {
           [contentView removeFromSuperview];
           if (isFromCourse) {
                if (![self checkForDownload]) {
                  shareButton.hidden = false;
               }
           }
          
       }
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation  withError:(NSError *)error{
     if (contentView) {
             [contentView removeFromSuperview];
         }
         [Utility msg:@"Something went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:YES];
}


#pragma mark - End
#pragma mark - ReceiveMemoryWarning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End
@end
