//
//  MyPhotosCompareViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 11/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyPhotosCompareViewController.h"
#import "MasterMenuViewController.h"
#import "MyPhotosCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddImageViewController.h"
#import "TrackViewController.h"
#import "SharePhotoViewController.h"

@interface MyPhotosCompareViewController ()<UIScrollViewDelegate> {
    IBOutlet UIImageView *rightImageView;
    IBOutlet UIImageView *leftImageView;
    
    IBOutletCollection(UIImageView) NSArray *imageViews;
    
    IBOutlet UIButton *myPhotosUpDownButton;
    IBOutlet UIButton *compareButton;
    IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
    IBOutlet UILabel *fullScreenLabel;
    IBOutlet UIImageView *compareDrageImageView;
    IBOutlet UIView *dragView;
    IBOutlet UICollectionView *bottomCollectionView;
    
    IBOutlet NSLayoutConstraint *leftImgViewTrailing;
    IBOutlet NSLayoutConstraint *rightImgViewLeading;
    IBOutlet NSLayoutConstraint *dragViewCenterX;

    IBOutlet UIButton *fullScreenButton;

    IBOutlet UIView *shareBgView;
    
    UIView *contentView;

    CGFloat firstX, firstY;
    CGFloat firstWidthLeft, firstWidthRight, firstWidth, currentWidth;
    NSArray *photosArray;
    NSMutableArray *selectedIndexes;
    
    UIPanGestureRecognizer *panRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UIPanGestureRecognizer *dragPanRecognizer;
    
    NSLayoutConstraint *top, *topR;
    NSLayoutConstraint *bottom, *bottomR;
    NSLayoutConstraint *leading, *leadingR;
    NSLayoutConstraint *trailing, *trailingR;
    NSLayoutConstraint *centerX, *centerXR;
    NSLayoutConstraint *centerY, *centerYR;
    
    UIImage *editedImage;
    BOOL sizeBeyondLimit;
    int photoID;
    
    IBOutlet UIView *resizableView;
    IBOutlet UIScrollView *leftScroll;
    IBOutlet UIScrollView *rightScroll;
    CGFloat leftImagescale;
    CGFloat rightImagescale;
    
    __weak IBOutlet UIImageView *leftResizableImageView;
   __weak IBOutlet UIImageView *rightResizableImageView;
    IBOutletCollection(UIImageView) NSArray *resizableImageViews;
    CGPoint leftImageCenter;
    CGPoint rightImageCenter;
    
    
}

@end

@implementation MyPhotosCompareViewController
//ah ph(storyboard)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    selectedIndexes = [[NSMutableArray alloc] init];
    leftImageCenter = CGPointZero;
    rightImageCenter = CGPointZero;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [bottomCollectionView addGestureRecognizer:lpgr];
    NSLog(@"data %@",_responseDictionary);
    
    rightScroll.userInteractionEnabled = NO;
    leftScroll.userInteractionEnabled = NO;
    resizableView.hidden=false;
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    firstWidthRight = rightImageView.frame.size.width;
    firstWidthLeft = leftImageView.frame.size.width;

    photosArray = [[_responseDictionary objectForKey:@"UserBodyPhotos"] objectForKey:@"PhotoList"];

    [self photoSelection];
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Scale and pan your progress photos" attributes:@{NSStrokeColorAttributeName:[UIColor blackColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0, NSFontAttributeName: [UIFont fontWithName:@"Raleway-SemiBold" size:13.0]}];
    fullScreenLabel.attributedText = attrString;
    
    collectionViewHeightConstraint.constant = 0;
    [myPhotosUpDownButton setSelected:NO];
    
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    centerX = [leftImageView.centerXAnchor constraintEqualToAnchor:leftImageView.superview.centerXAnchor];
    centerY = [leftImageView.centerYAnchor constraintEqualToAnchor:leftImageView.superview.centerYAnchor];
    top = [leftImageView.topAnchor constraintEqualToAnchor:leftImageView.superview.topAnchor];
    bottom = [leftImageView.bottomAnchor constraintEqualToAnchor:leftImageView.superview.bottomAnchor];
    leading = [leftImageView.leadingAnchor constraintEqualToAnchor:leftImageView.superview.leadingAnchor];
    trailing = [leftImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];

    centerXR = [rightImageView.centerXAnchor constraintEqualToAnchor:rightImageView.superview.centerXAnchor];
    centerYR = [rightImageView.centerYAnchor constraintEqualToAnchor:rightImageView.superview.centerYAnchor];
    topR = [rightImageView.topAnchor constraintEqualToAnchor:rightImageView.superview.topAnchor];
    bottomR = [rightImageView.bottomAnchor constraintEqualToAnchor:rightImageView.superview.bottomAnchor];
    leadingR = [rightImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    trailingR = [rightImageView.trailingAnchor constraintEqualToAnchor:rightImageView.superview.trailingAnchor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    leftImgViewTrailing.constant = rightImgViewLeading.constant = screenWidth/2.0;  //dragView.center.x;
    
    

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    leftImageCenter = leftScroll.contentOffset;
//    rightImageCenter = rightScroll.contentOffset;
    
    [defaults setObject:[NSNumber numberWithFloat:leftImagescale] forKey:@"leftImagescale"];
    [defaults setObject:[NSNumber numberWithFloat:rightImagescale] forKey:@"rightImagescale"];
    [defaults setObject:NSStringFromCGPoint(leftImageCenter) forKey:@"leftImageCenter"];
    [defaults setObject:NSStringFromCGPoint(rightImageCenter) forKey:@"rightImageCenter"];
    
    
}
-(void)viewDidLayoutSubviews{
    NSLog(@"Layout Called");
    [self setupInitialImageScale];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)backTapped:(id)sender {
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController *controller in vcs.reverseObjectEnumerator) {
        if ([controller isKindOfClass:[TrackViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            break;
        }else if ([controller isKindOfClass:[TodayHomeViewController class]]) {
            [self.navigationController popToViewController:controller animated:NO];
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)infoButtonPressed:(UIButton *)sender {//feedback info button
    NSString *urlString=@"https://player.vimeo.com/external/290408389.m3u8?s=43eab43c14d390852b49f5d2131a3fc8ed8756fb";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
}
-(IBAction)myPhotosUpDownButtonTapped:(UIButton *)sender {
    if (sender.selected) {
        [sender setSelected:NO];
        collectionViewHeightConstraint.constant = 0;
    } else {
        [sender setSelected:YES];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 2/3.0 * screenWidth;
        collectionViewHeightConstraint.constant = height;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(IBAction)fullScreenButtonTapped:(UIButton *)sender {
    if (compareButton.isSelected){
        [self compareButtonTapped:compareButton];
    }
    
    if (sender.selected) {
        [sender setSelected:NO];
        fullScreenLabel.hidden = true;

        
        for (UIImageView *imageView in resizableImageViews) {
            [imageView setUserInteractionEnabled:NO];
        }
        
        leftScroll.userInteractionEnabled = NO;
        rightScroll.userInteractionEnabled = NO;
        leftScroll.scrollEnabled = false;
        rightScroll.scrollEnabled = false;
        
    } else {
        [sender setSelected:YES];
        fullScreenLabel.hidden = false;
        
        leftScroll.scrollEnabled = true;
        rightScroll.scrollEnabled = true;
        leftScroll.userInteractionEnabled = YES;
        rightScroll.userInteractionEnabled = YES;
        resizableView.hidden=false;
        
       for (UIImageView *imageView in resizableImageViews) {
            [imageView setUserInteractionEnabled:YES];
            /*imageView.hidden = false;
            panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
            [panRecognizer setMinimumNumberOfTouches:1];
            [panRecognizer setMaximumNumberOfTouches:1];
            [imageView addGestureRecognizer:panRecognizer];
            
            pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureDetected:)];
            
            [imageView addGestureRecognizer:pinchGestureRecognizer];
            
            if(pinchGestureRecognizer.view == leftResizableImageView){
                if(leftImagescale>0) {
                    
                    //if(imageView.transform.a != leftImagescale){
                      [imageView setTransform:CGAffineTransformScale(imageView.transform, leftImagescale, leftImagescale)];
                    //}
                   
                }
                
                if (!CGPointEqualToPoint(leftImageCenter, CGPointZero)){
                   [imageView setCenter:leftImageCenter];
                }
                
            }else if(pinchGestureRecognizer.view == rightResizableImageView){
                
                if(rightImagescale>0){
                     //if(imageView.transform.a != rightImagescale){
                         [imageView setTransform:CGAffineTransformScale(imageView.transform, rightImagescale, rightImagescale)];
                     //}
                    
                }
                
                if (!CGPointEqualToPoint(rightImageCenter, CGPointZero)){
                    [imageView setCenter:rightImageCenter];
                }
            }*/
        }
    }
}
-(IBAction)compareButtonTapped:(UIButton *)sender {
    if (fullScreenButton.isSelected){
        [self fullScreenButtonTapped:fullScreenButton];
    }
    
    leftImageView.transform = CGAffineTransformIdentity;
    rightImageView.transform = CGAffineTransformIdentity;
    
    dragViewCenterX.constant = 0;
    
    if (sender.selected) {
        [sender setSelected:NO];
        
        dragView.hidden = true;
        [dragView setUserInteractionEnabled:true];
        
//        top.active = false;
//        bottom.active = false;
//        leading.active = false;
//        trailing.active = false;
//
//        centerY.active = true;
//        centerX.active = true;
//
//        topR.active = false;
//        bottomR.active = false;
//        leadingR.active = false;
//        trailingR.active = false;
//
//        centerYR.active = true;
//        centerXR.active = true;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        leftImgViewTrailing.constant = rightImgViewLeading.constant = screenWidth/2.0;
        
        
        for (UIImageView *imageView in imageViews) {
           imageView.hidden = true;
            [imageView setUserInteractionEnabled:NO];
        }

        [dragView setUserInteractionEnabled:false];
        resizableView.hidden=false;
    } else {
        [sender setSelected:YES];
        
        for (UIImageView *imageView in imageViews) {
            imageView.hidden = false;
            [imageView setUserInteractionEnabled:NO];
        }
        
        resizableView.hidden=true;
        
        dragView.hidden = false;
        [dragView setUserInteractionEnabled:false];
        
        centerY.active = false;
        centerX.active = false;

        top.active = true;
        bottom.active = true;
        leading.active = true;
        trailing.active = true;

        centerYR.active = false;
        centerXR.active = false;

        topR.active = true;
        bottomR.active = true;
        leadingR.active = true;
        trailingR.active = true;
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        leftImgViewTrailing.constant = rightImgViewLeading.constant = screenWidth/2.0;

        [dragView setUserInteractionEnabled:true];
        dragPanRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
//        [dragPanRecognizer setMinimumNumberOfTouches:1];
//        [dragPanRecognizer setMaximumNumberOfTouches:1];
        [dragView addGestureRecognizer:dragPanRecognizer];
    }
}
-(IBAction)addPicsButtonTapped:(UIButton *)sender {
    AddImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddImageView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.addPhotoDelegate = self;
    controller.existingPhotosArray = photosArray;
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

- (IBAction)leftRightButtonTapped:(UIButton *)sender {
    if ([sender.accessibilityHint caseInsensitiveCompare:@"left"] == NSOrderedSame) {
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:sender.tag] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        
        [leftResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:sender.tag] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        [defaults setInteger:[[[photosArray objectAtIndex:sender.tag] objectForKey:@"UserBodyPhotoID"] integerValue] forKey:@"leftSelectedPic"];
        
        leftImagescale = 1;
        leftImageCenter= CGPointZero;

        [defaults setObject:[NSNumber numberWithFloat:leftImagescale] forKey:@"leftImagescale"];
        [defaults setObject:NSStringFromCGPoint(leftImageCenter) forKey:@"leftImageCenter"];
       

    } else if ([sender.accessibilityHint caseInsensitiveCompare:@"right"] == NSOrderedSame) {
        [rightImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:sender.tag] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        
        [rightResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:sender.tag] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        
        [defaults setInteger:[[[photosArray objectAtIndex:sender.tag] objectForKey:@"UserBodyPhotoID"] integerValue] forKey:@"rightSelectedPic"];
        
        rightImagescale = 1;
        rightImageCenter= CGPointZero;

        [defaults setObject:[NSNumber numberWithFloat:rightImagescale] forKey:@"rightImagescale"];
        [defaults setObject:NSStringFromCGPoint(rightImageCenter) forKey:@"rightImageCenter"];
        
    }
    
    NSIndexPath *ip = [NSIndexPath indexPathForItem:sender.tag inSection:0];
    MyPhotosCollectionViewCell *cell = (MyPhotosCollectionViewCell *)[bottomCollectionView cellForItemAtIndexPath:ip];
    cell.leftButtonCompare.hidden = true;
    cell.rightButtonCompare.hidden = true;
    
    [bottomCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:ip]];
}

- (IBAction)shareButoonTapped:(id)sender {
    UIImage *img;
    if(resizableView.isHidden){
       img = [self captureView:shareBgView];
    }else{
       img = [self captureView:resizableView];
    }
   
    
    SharePhotoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SharePhoto"];
    controller.img = img;
    [self.navigationController pushViewController:controller animated:YES];

}

-(IBAction)downloadButtonTapped:(UIButton *)sender {
    UIImage *newImage = [self getImageFromURL:[[photosArray objectAtIndex:sender.tag] objectForKey:@"Photo"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    });
}
- (IBAction)deleteButtonTapped:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete the picture?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deletePicWithID:[sender tag]];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(IBAction)editButtonTapped:(UIButton *)sender {
    photoID = (int)sender.tag;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserBodyPhotoID == %d)",(int)sender.tag];
    NSArray *filteredSessionCategoryArray = [photosArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[dict objectForKey:@"Photo"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];

        if (image) {
            image =[Utility scaleImage:image width:image.size.width height:image.size.height];
            image = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.3)];
            editedImage = [self imageCompression:image];
            [self openEditor:nil];
        }
    } else {
        
    }
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
                                                                         
                                                                         photosArray = [[responseDictionary objectForKey:@"UserBodyPhotos"] objectForKey:@"PhotoList"];
                                                                         if(photosArray.count > 1){
                                                                             [self photoSelection];
                                                                             
                                                                             //                                                                         [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:0] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageRefreshCached];
                                                                             //                                                                         [rightImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:1] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageRefreshCached];
                                                                             
                                                                             [bottomCollectionView reloadData];
                                                                         }else{
                                                                             [self.navigationController popViewControllerAnimated:YES];
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

-(void)deletePicWithID:(NSInteger)picID {
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
        [mainDict setObject:[NSNumber numberWithInteger:picID] forKey:@"UserBodyPhotoID"];
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteBodyPhoto" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         [self getUserPhotosApiCallWithBodyCategoryID:0];
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
-(void)addUserBodyPhotoApiCall{
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
        [mainDict setObject:@"" forKey:@"FacebookToken"];
        [mainDict setObject:[NSNumber numberWithInteger:photoID] forKey:@"UserBodyPhotoID"];

        if (![Utility isEmptyCheck:editedImage]) {
            NSData *dataImage = [[NSData alloc] init];
            dataImage = UIImagePNGRepresentation(editedImage);
            NSString *stringImage = [dataImage base64EncodedStringWithOptions:0];
            [mainDict setObject:stringImage forKey:@"PhotoData"];
        }
        
//        [mainDict setObject:[bodyCatagoryType objectForKey:bodyCatagorystring] forKey:@"Pose"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateBodyPhoto" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         [Utility msg:@"Image Edited Successfully" title:@"Success!" controller:self haveToPop:NO];
                                                                         [self getUserPhotosApiCallWithBodyCategoryID:0];
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
#pragma mark - Private Methods
-(void)setupInitialImageScale{
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"leftImageCenter"]]){
        leftImageCenter = CGPointFromString([defaults objectForKey:@"leftImageCenter"]);
    }
    
    if(![Utility isEmptyCheck:[defaults objectForKey:@"rightImageCenter"]]){
        rightImageCenter = CGPointFromString([defaults objectForKey:@"rightImageCenter"]);
    }
    
    leftImagescale = [[defaults objectForKey:@"leftImagescale"] floatValue];
    rightImagescale = [[defaults objectForKey:@"rightImagescale"] floatValue];
    
    if(leftImagescale == 0){
        leftImagescale = 1;
    }

    if(rightImagescale == 0){
        rightImagescale = 1;
    }
    
    leftScroll.minimumZoomScale=1.0;
    leftScroll.maximumZoomScale=8.0;
    
    
    [leftScroll setZoomScale:leftImagescale];
    leftScroll.contentSize=CGSizeMake(leftScroll.contentSize.width,leftScroll.contentSize.height);
    [leftScroll setContentOffset:leftImageCenter animated:NO];
    
    
    rightScroll.minimumZoomScale=1.0;
    rightScroll.maximumZoomScale=8.0;
    
    
    [rightScroll setZoomScale:rightImagescale];
     rightScroll.contentSize=CGSizeMake(rightScroll.contentSize.width,rightScroll.contentSize.height);
    [rightScroll setContentOffset:rightImageCenter animated:NO];
    
}

- (void)pinchGestureDetected:(UIPinchGestureRecognizer *)recognizer
{
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan) {
        firstWidth = (recognizer.view == leftResizableImageView) ? firstWidthLeft : firstWidthRight;
    }
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        
       
        
        if(recognizer.view == leftResizableImageView){
            leftImagescale = [recognizer scale];
            if (leftImagescale > 1.0 && currentWidth <= firstWidth*2) {
                [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, leftImagescale, leftImagescale)];
            } else if (leftImagescale < 1.0 && currentWidth >= firstWidth/2) {
                [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, leftImagescale, leftImagescale)];
            }
            
        }else{
            rightImagescale = [recognizer scale];
            if (rightImagescale > 1.0 && currentWidth <= firstWidth*2) {
                [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, rightImagescale, rightImagescale)];
            } else if (rightImagescale < 1.0 && currentWidth >= firstWidth/2) {
                [recognizer.view setTransform:CGAffineTransformScale(recognizer.view.transform, rightImagescale, rightImagescale)];
            }
        }
        
        
        
        
        [recognizer setScale:1.0];
        currentWidth = recognizer.view.frame.size.width;
    }
}

-(void)move:(UIPanGestureRecognizer*)sender {
    [self.view bringSubviewToFront:sender.view];
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        firstX = sender.view.center.x;
        firstY = sender.view.center.y;
    }
    
    
    translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y+translatedPoint.y);
    //    NSLog(@"tp %@",NSStringFromCGPoint(translatedPoint));
    
    [sender.view setCenter:translatedPoint];
    [sender setTranslation:CGPointZero inView:sender.view];
    
    
    if(sender.view == leftResizableImageView){
        leftImageCenter = translatedPoint;
    }else{
        rightImageCenter = translatedPoint;
    }
    
//    if (sender.state == UIGestureRecognizerStateEnded) {
//        CGFloat velocityX = (0.2*[sender velocityInView:self.view].x);
//        CGFloat velocityY = (0.2*[sender velocityInView:self.view].y);
//        
//        CGFloat finalX = translatedPoint.x + velocityX;
//        CGFloat finalY = translatedPoint.y + velocityY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
//        
//        if (finalX < 0) {
//            finalX = 0;
//        } else if (finalX > self.view.frame.size.width) {
//            finalX = self.view.frame.size.width;
//        }
//        
//        if (finalY < 50) { // to avoid status bar
//            finalY = 50;
//        } else if (finalY > self.view.frame.size.height) {
//            finalY = self.view.frame.size.height;
//        }
//        
//        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
//        
//        NSLog(@"the duration is: %f", animationDuration);
//        
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:animationDuration];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//        [UIView setAnimationDelegate:self];
//        //        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//        [[sender view] setCenter:CGPointMake(finalX, finalY)];
//        [UIView commitAnimations];
//        
//        //        if (sender.view.frame.origin.x <= 0 || sender.view.frame.origin.x >= firstX*2) {
//        //            [UIView animateWithDuration:0.2 animations:^{
//        //                CGRect frame = sender.view.frame;
//        //                frame.origin.x = firstX;
//        //                sender.view.frame = frame;
//        //            }];
//        //        } else if (sender.view.frame.origin.y <= 0 || sender.view.frame.origin.y >= firstX*2) {
//        //            [UIView animateWithDuration:0.2 animations:^{
//        //                CGRect frame = sender.view.frame;
//        //                frame.origin.y = firstY;
//        //                sender.view.frame = frame;
//        //            }];
//        //        }
//    }
}

- (void) drag:(UIPanGestureRecognizer *)sender {
    [self.view bringSubviewToFront:sender.view];
    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
    CGFloat translatedX = translatedPoint.x;
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        firstX = sender.view.center.x;
        firstY = sender.view.center.y;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    if ((dragViewCenterX.constant + translatedX) > -(screenWidth/2.0 - dragView.frame.size.width/2.0) && (dragViewCenterX.constant + translatedX) < (screenWidth/2.0 - dragView.frame.size.width/2.0)) {
        leftImgViewTrailing.constant -= translatedX;
        rightImgViewLeading.constant += translatedX;
        dragViewCenterX.constant += translatedX;
    }
    
    translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y);
    [sender setTranslation:CGPointZero inView:sender.view];
}
- (UIImage*)captureView:(UIView *)captureView {
    CGRect rect = captureView.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [captureView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:bottomCollectionView];
        
        NSIndexPath *indexPath = [bottomCollectionView indexPathForItemAtPoint:p];
        if (indexPath == nil) {
            NSLog(@"long press on table view but not on a row");
        } else {
            NSLog(@"long press on table view at row %ld", indexPath.row);
        }
        
        MyPhotosCollectionViewCell *cell = (MyPhotosCollectionViewCell *)[bottomCollectionView cellForItemAtIndexPath:indexPath];
        cell.deleteButton.hidden = false;
        cell.downloadButton.hidden = false;
        cell.editButton.hidden = false;
        cell.buttonBottomView.hidden = false;
        //    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"long press on table view at row %ld", indexPath.row);
        //    } else {
        //        NSLog(@"gestureRecognizer.state = %ld", gestureRecognizer.state);
        //    }
    }
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [contentView removeFromSuperview];
        }
    });
    if (error != nil) {
        [Utility msg:@"Image can not be saved" title:@"Oops!" controller:self haveToPop:NO];
    } else {
        [Utility msg:@"Image saved successfully" title:@"Success" controller:self haveToPop:NO];
    }
}
- (void) photoSelection {
    NSInteger leftSelectedIndex = 0;
    NSInteger rightSelectedIndex = 1;
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"leftSelectedPic"]] && [defaults integerForKey:@"leftSelectedPic"] > 0) {
        leftSelectedIndex = [defaults integerForKey:@"leftSelectedPic"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserBodyPhotoID == %ld)",(long)leftSelectedIndex];
        NSArray *filteredSessionCategoryArray = [photosArray filteredArrayUsingPredicate:predicate];
        if (filteredSessionCategoryArray.count > 0) {
            NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
             [leftResizableImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
            
        } else {
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:0] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
             [leftResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:0] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
           
        }
    } else {
        [leftImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:leftSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        
        [leftResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:leftSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
    }
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"rightSelectedPic"]] && [defaults integerForKey:@"rightSelectedPic"] > 0) {
        rightSelectedIndex = [defaults integerForKey:@"rightSelectedPic"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserBodyPhotoID == %ld)",(long)rightSelectedIndex];
        NSArray *filteredSessionCategoryArray = [photosArray filteredArrayUsingPredicate:predicate];
        if (filteredSessionCategoryArray.count > 0) {
            NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
            [rightImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
            [rightResizableImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        } else {
            [rightImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:1] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            
             [rightResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:1] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        }
    } else {
        [rightImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:rightSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        
        [rightResizableImageView sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:rightSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
    }
    
    
    
   
}
-(UIImage *)imageCompression:(UIImage *)image{
    UIImage *compressedImage;
    NSData * imagedata =  UIImageJPEGRepresentation(image, 0.8);
    NSUInteger imageSize = imagedata.length;
    compressedImage = [UIImage imageWithData:imagedata];
    float sizeInMB=(float)imageSize/1024/1024;
    if(sizeInMB>5){
        sizeBeyondLimit=YES;
    }
    // NSLog(@"SIZE OF IMAGE: %.2f Mb, %.2f KB %.2f B", (float)imageSize/1024/1024,(float)imageSize/1024,(float)imageSize);
    return compressedImage;
}
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = editedImage;
    controller.keepingCropAspectRatio = YES;
    
    //    UIImage *image = profileImageView.image;
    //    CGFloat width = image.size.width;
    //    CGFloat height = image.size.height;
    //    CGFloat length = MIN(width, height);
    //    controller.imageCropRect = CGRectMake((width - length) / 2,
    //                                          (height - length) / 2,
    //                                          length,
    //                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - CollectionView DataSource/Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  photosArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"MyPhotosCollectionViewCell";
    
    MyPhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell.galaryImageViewCompare sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:indexPath.row] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
    cell.galaryImageViewCompare.contentMode = UIViewContentModeScaleAspectFit;
    
    cell.bgViewCompare.layer.cornerRadius = 5;
    cell.bgViewCompare.layer.masksToBounds = YES;

    [cell.leftButtonCompare addTarget:self action:@selector(leftRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.rightButtonCompare addTarget:self action:@selector(leftRightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.leftButtonCompare setTag:indexPath.row];
    [cell.rightButtonCompare setTag:indexPath.row];
    [cell.leftButtonCompare setAccessibilityHint:@"left"];
    [cell.rightButtonCompare setAccessibilityHint:@"right"];
    
    cell.leftButtonCompare.hidden = YES;
    cell.rightButtonCompare.hidden= YES;
    cell.deleteButton.hidden = true;
    cell.downloadButton.hidden = true;
    cell.editButton.hidden = true;
    cell.buttonBottomView.hidden = true;

    [cell.downloadButton addTarget:self action:@selector(downloadButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [cell.editButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [cell.downloadButton setTag:indexPath.row];
    [cell.deleteButton setTag:[[[photosArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"] integerValue]];
    [cell.editButton setTag:[[[photosArray objectAtIndex:indexPath.row] objectForKey:@"UserBodyPhotoID"] integerValue]];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    MyPhotosCollectionViewCell *cell = (MyPhotosCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.leftButtonCompare.hidden = !cell.leftButtonCompare.hidden;
    cell.rightButtonCompare.hidden = !cell.rightButtonCompare.hidden;
    
    cell.deleteButton.hidden = true;
    cell.downloadButton.hidden = true;
    cell.editButton.hidden = true;
    cell.buttonBottomView.hidden = true;
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];

    editedImage = croppedImage;
    [self addUserBodyPhotoApiCall];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - AddPhotoDelegate
-(void) didPhotoAdded:(BOOL)isAdded {
    if (isAdded) {
        [Utility msg:@"Image saved Successfully" title:@"Alert" controller:self haveToPop:NO];
        [self getUserPhotosApiCallWithBodyCategoryID:0];
    }
}
#pragma mark- End
#pragma mark - UIScrollViewDelegate method

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView==leftScroll){
        return leftResizableImageView;
    }else if(scrollView==rightScroll){
        return rightResizableImageView;
    }
    return nil;//[imageArray objectAtIndex:pageControl.currentPage];
}



- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    if(scrollView !=leftScroll && scrollView !=rightScroll){
        return CGRectZero;
    }
    
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    
    if(scrollView == leftScroll){
        
        zoomRect.size.height = leftScroll.frame.size.height / scale;
        zoomRect.size.width  = leftScroll.frame.size.width  / scale;
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
        
    }else if(scrollView == rightScroll){
        zoomRect.size.height = rightScroll.frame.size.height / scale;
        zoomRect.size.width  = rightScroll.frame.size.width  / scale;
        
        // choose an origin so as to get the right center.
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    }else{
        return CGRectZero;
    }
    
    
    return zoomRect;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"Zoomscale %f",scale);
    NSLog(@"Zoom End!");
    
    if(scrollView == leftScroll){
        leftImagescale = scale;
        [defaults setObject:[NSNumber numberWithFloat:leftImagescale] forKey:@"leftImagescale"];
    }else if(scrollView == rightScroll){
        NSLog(@"RightScroll Content_Offest-%@",NSStringFromCGPoint(rightScroll.contentOffset));
        rightImagescale = scale;
        [defaults setObject:[NSNumber numberWithFloat:rightImagescale] forKey:@"rightImagescale"];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView == leftScroll){
        NSLog(@"LeftScroll Content_Offest-%@",NSStringFromCGPoint(leftScroll.contentOffset));
        leftImageCenter = scrollView.contentOffset;
        [defaults setObject:NSStringFromCGPoint(leftImageCenter) forKey:@"leftImageCenter"];
        
    }else if(scrollView == rightScroll){
        NSLog(@"RightScroll Content_Offest-%@",NSStringFromCGPoint(rightScroll.contentOffset));
        rightImageCenter = scrollView.contentOffset;
        [defaults setObject:NSStringFromCGPoint(rightImageCenter) forKey:@"rightImageCenter"];
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if(decelerate) return;
    
    if(scrollView == leftScroll){
         NSLog(@"LeftScroll Content_OffestVDS-%@",NSStringFromCGPoint(scrollView.contentOffset));
        leftImageCenter = scrollView.contentOffset;
        [defaults setObject:NSStringFromCGPoint(leftImageCenter) forKey:@"leftImageCenter"];
    }else if(scrollView == rightScroll){
        NSLog(@"RightScroll Content_OffestVDS-%@",NSStringFromCGPoint(scrollView.contentOffset));
        rightImageCenter = scrollView.contentOffset;
        [defaults setObject:NSStringFromCGPoint(rightImageCenter) forKey:@"rightImageCenter"];
    }
}

#pragma mark- End



@end
