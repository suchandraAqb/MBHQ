//
//  MyPhotosDefaultViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 11/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyPhotosDefaultViewController.h"
#import "MasterMenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MyPhotosCompareViewController.h"

@interface MyPhotosDefaultViewController () {
    IBOutlet UIImageView *imgView;
    IBOutlet UILabel *addImgLabel;
    
    UIView *contentView;
    NSArray *photoArray;
    BOOL isChanged;
}

@end

@implementation MyPhotosDefaultViewController
//ah newt

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserPhotosApiCallWithBodyCategoryID:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addImageButtonPressed:(UIButton*)sender{
    AddImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddImageView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.addPhotoDelegate = self;
    controller.existingPhotosArray = photoArray;
    NSLog(@"%ld",(long)sender.tag);
    NSString *bodyCatagoryString=@"";
//    if (sender.tag == 0) { //Font
        bodyCatagoryString=@"Front";
//    }
//    else if (sender.tag == 1) //Side
//        bodyCatagoryString=@"Side";
//    else if (sender.tag == 2) //Back
//        bodyCatagoryString=@"Back";
//    else if (sender.tag == 3) //Final
//        bodyCatagoryString=@"Final";
    
    controller.bodyCatagorystring=bodyCatagoryString;
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)weighInsTapped:(id)sender {
   
}

#pragma mark - API Call
-(void)getUserPhotosApiCallWithBodyCategoryID:(NSInteger)bodyCategoryID {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        if (bodyCategoryID == 4) {
            bodyCategoryID++;
        }
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        //        [mainDict setObject:[NSNumber numberWithInteger:bodyCategoryID] forKey:@"BodyCategoryID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBodyPhotos" append:@"" forAction:@"POST"];
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
                                                                         
                                                                         photoArray = [[responseDictionary objectForKey:@"UserBodyPhotos"] objectForKey:@"PhotoList"];
                                                                         
                                                                         if (photoArray.count == 1) {
                                                                             [imgView sd_setImageWithURL:[NSURL URLWithString:[[photoArray objectAtIndex:0] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
                                                                             imgView.contentMode = UIViewContentModeScaleAspectFit;
                                                                             
                                                                             addImgLabel.text = @"Add one more image";
                                                                         } else if (photoArray.count > 1) {
                                                                             MyPhotosCompareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPhotosCompare"];
                                                                             controller.responseDictionary = responseDictionary;
                                                                             [self.navigationController pushViewController:controller animated:NO];
                                                                         }
                                                                         
                                                                         
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

#pragma mark - AddPhotoDelegate
-(void) didPhotoAdded:(BOOL)isAdded {
    if (isAdded) {
        [self getUserPhotosApiCallWithBodyCategoryID:0];
    }
}
@end
