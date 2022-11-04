//
//  CompareViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 21/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CompareViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompareViewController () {
    IBOutlet UIStackView *mainStackView;
    IBOutlet UIImageView *firstImageView;
    IBOutlet UIImageView *secondImageView;
    IBOutlet UIImageView *thirdImageView;
    IBOutlet UIView *firstView;     //ah 22.3
    IBOutlet UIView *secondView;
    IBOutlet UIView *thirdView;
    
    UIView *contentView;
}

@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=YES;
    
    firstView.hidden = YES;
    secondView.hidden = YES;
    thirdView.hidden = YES;
    
    [self getUserPhotos];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)backTapped:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - API Call
-(void)getUserPhotos {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_photoIDs componentsJoinedByString:@","] forKey:@"PhotoIds"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"BodyPicsCompare" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         NSArray *photoArray = [[responseDictionary objectForKey:@"BodyPoseList"] objectForKey:@"PhotoList"];
                                                                         
                                                                         NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                                                                             sortDescriptorWithKey:@"DateTaken"
                                                                                                             ascending:NO];
                                                                         NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                                                                         NSArray *sortedArray = [photoArray
                                                                                                 sortedArrayUsingDescriptors:sortDescriptors];
                                                                         
                                                                         
                                                                         [self prepareViewWithArray:sortedArray];
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
    }
}

-(void) prepareViewWithArray:(NSArray *)picArray {
    for (int i = 0; i < picArray.count; i++) {
        switch (i) {
            case 0:
                [firstImageView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:i] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                firstView.hidden = NO;
                break;
               
            case 1:
                [secondImageView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:i] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                secondView.hidden = NO;
                break;
                
            case 2:
                [thirdImageView sd_setImageWithURL:[NSURL URLWithString:[[picArray objectAtIndex:i] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                }];
                thirdView.hidden = NO;
                break;
                
            default:
                break;
        }
    }
}
@end
