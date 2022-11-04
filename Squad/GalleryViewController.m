//
//  GalleryViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "GalleryViewController.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
#import "CompareViewController.h"

@interface GalleryViewController ()
{
    IBOutlet UIImageView *galleryImage;
    IBOutlet UIScrollView *mainScroll;
    
    IBOutlet UIView *scrollContainerView;
    IBOutlet UIScrollView *scrollImageView;
    
    IBOutlet UIButton *compareCheckBox;
        
    UIView *contentView;
    NSMutableArray *imageArray;
    
    UIPageControl *pageControl;
    BOOL pageControlIsChangingPage;
    int noOfPages;
    int noOfElements;
    UITapGestureRecognizer *singleTap;
    NSInteger page;
    NSMutableArray *photoIDs;
    
    CGRect imageRect;   //ah 12.5
}
@end
//ah 21.3   //ah 22.3
@implementation GalleryViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArray = [[NSMutableArray alloc] init];
    photoIDs = [[NSMutableArray alloc] init];
    page = 0;
    
    
    [self getUserPhotosApiCall];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appdelegate.autoRotate=NO;
}

#pragma mark - End

#pragma mark - IBAction

-(IBAction)compareButtonPressed:(id)sender{
    if (![Utility isEmptyCheck:photoIDs] && photoIDs.count > 1) {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegate.autoRotate=YES;
        
        CompareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Compare"];
        //    controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else if (![Utility isEmptyCheck:photoIDs] && photoIDs.count == 1) {
        [Utility msg:@"Please select atleast 2 pictures to compare" title:@"Oops!" controller:self haveToPop:NO];
    } else if (photoIDs && photoIDs.count == 0) {
        NSLog(@"page1 %ld",(long)page);
        [photoIDs addObject:[[imageArray objectAtIndex:page] objectForKey:@"UserBodyPhotoID"]];
        compareCheckBox.hidden = false;
        
        UIImageView *imgView = (UIImageView*)[self.view viewWithTag:page+1];
        
        if ([imgView isKindOfClass:[UIImageView class]]) {
            [imgView.layer setBorderColor:[[UIColor greenColor] CGColor]];
            [imgView.layer setBorderWidth:2.0];
        }
    }
    
}

-(IBAction)deleteButtonPressed:(id)sender{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this picture?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deletePhotoWithID:[[[imageArray objectAtIndex:page] objectForKey:@"UserBodyPhotoID"]intValue]];
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
-(IBAction)downLoadButtonPressed:(id)sender{
    NSLog(@"page --> %ld",(long)page);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [contentView removeFromSuperview];
        }
        contentView = [Utility activityIndicatorView:self];
    });
    
    [self saveImage];
}
-(IBAction)prevButtonPressed:(id)sender{
    if (page > 0) {
        [self changeToScrollPage:(int)page-1];
        page = page-1;
    }
}
-(IBAction)nextButtonPressed:(id)sender{
    if (page < imageArray.count-1) {
        [self changeToScrollPage:(int)page+1];
        page = page+1;
    }
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)compareCheckBoxTapped:(id)sender {
    
}
#pragma mark - End

#pragma mark - Private Function

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(UIImage *) loadImage:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, extension]];
    
    return result;
}
- (void)changeToScrollPage:(int)toPage
{
    //move the scroll view
    CGRect frame = mainScroll.frame;
    frame.origin.x = frame.size.width * toPage;
    frame.origin.y = 0;
    //    frame.origin.x = frame.size.width * 1;
    [mainScroll scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
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

-(void) saveImage {
    UIImage *newImage = [self getImageFromURL:[[imageArray objectAtIndex:page] objectForKey:@"Photo"]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    });
//    if ([NSThread isMainThread]) {
//        UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    } else {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        });
//    }
}
#pragma mark - API Call
-(void)getUserPhotosApiCall{
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
                                                                         
                                                                         NSArray *photoList = [[responseDictionary objectForKey:@"UserBodyPhotos"] objectForKey:@"PhotoList"];
                                                                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(BodyCategoryID == %d)",(int)_bodyCategoryID];
                                                                         NSArray *filteredArray = [photoList filteredArrayUsingPredicate:predicate];
                                                                         
                                                                         NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                                                                                             sortDescriptorWithKey:@"DateTaken"
                                                                                                             ascending:NO];
                                                                         NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
                                                                         NSArray *sortedArray = [filteredArray
                                                                                                      sortedArrayUsingDescriptors:sortDescriptors];
                                                                         
                                                                         imageArray = [sortedArray mutableCopy];
                                                                         if (![Utility isEmptyCheck:imageArray]) {
                                                                             [self addImageScroll:imageArray];
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
- (void) deletePhotoWithID:(int)photoID {
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
        [mainDict setObject:[NSNumber numberWithInt:photoID] forKey:@"PhotoId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteBodyPhotoById" append:@"" forAction:@"POST"];
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
                                                                         [Utility msg:@"Deleted Successfully" title:@"Oops" controller:self haveToPop:NO];
                                                                         [self getUserPhotosApiCall];
                                                                     }else{
                                                                         [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Oops" controller:self haveToPop:NO];
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
#pragma mark - End
#pragma mark - UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (pageControlIsChangingPage) {
        return;
    }
    CGFloat pageWidth = scrollImageView.frame.size.width;
    float fractionalPage = scrollImageView.contentOffset.x / pageWidth;
    page = lround(fractionalPage);
    pageControl.currentPage = page;
//    NSLog(@"page %ld",(long)page);
//    int showPageNo = (int)page;
//    imageNumberLabel.text = [NSString stringWithFormat:@"%d",showPageNo+1];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
}

#pragma mark - End
#pragma mark - UIPageControl method

//Method to swipe between the pages
- (IBAction)changePage:(id)sender
{
    //move the scroll view
    CGRect frame = scrollImageView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    [scrollImageView scrollRectToVisible:frame animated:YES];
    //scrollViewDidEndDecelerating will turn this off
    pageControlIsChangingPage = YES;
}
#pragma mark - End
#pragma mark - ImageScrollMethod
-(void)addImageScroll:(NSArray *)array{
    [[scrollImageView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [pageControl removeFromSuperview];
    // NSLog(@"%d",array.count);
    noOfElements=(int)array.count;
    // noOfElements=10;
    scrollImageView.delegate=self;
    [scrollImageView setShowsHorizontalScrollIndicator:NO];
    [scrollImageView setShowsVerticalScrollIndicator:NO];
    scrollImageView.pagingEnabled = YES;
    
    
    noOfPages= noOfElements;
    int noOfPagesCount = 0;
    for ( noOfPagesCount = 0; noOfPagesCount < noOfElements; noOfPagesCount++) {
        // NSString *imageString=@"banner_bg";
        
        CGRect frame;
        frame.origin.x = galleryImage.frame.size.width * noOfPagesCount;
        frame.origin.y = 0;
        frame.size = galleryImage.frame.size;
        galleryImage=[[UIImageView alloc] initWithFrame:frame];
        galleryImage.backgroundColor=[UIColor clearColor];
        galleryImage.userInteractionEnabled=true;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButton:)];
        [galleryImage addGestureRecognizer:singleTap];
        galleryImage.tag=noOfPagesCount+1;
        
        [galleryImage sd_setImageWithURL:[NSURL URLWithString:[[imageArray objectAtIndex:noOfPagesCount] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {    //ah 12.3
                CGFloat imageViewWidth = galleryImage.frame.size.width;
                CGFloat imageViewHeight = image.size.height/image.size.width * imageViewWidth;
//                imageViewWidthConstraint.constant = imageViewWidth;
                
                if (imageViewHeight > galleryImage.frame.size.height) {
                    imageViewHeight = galleryImage.frame.size.height;
                    imageViewWidth = image.size.width/image.size.height * imageViewHeight;
                }
                
                imageRect = CGRectMake(galleryImage.frame.origin.x, galleryImage.frame.origin.y, imageViewWidth, imageViewHeight);
            }
        }];
        
        [scrollImageView addSubview:galleryImage];
    }
    
    // [self addButtonScroll:scrollImageView imageview:imageView array:array];
    
    scrollImageView.contentSize = CGSizeMake(galleryImage.frame.size.width * noOfPages, scrollImageView.contentSize.height);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-galleryImage.frame.size. width/2, scrollContainerView.frame.size.height-15,galleryImage.frame.size.width,15)];
        
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(129.0/255) green:(129.0/255) blue:(129.0/255) alpha:1.0];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(06.0/255) green:(122.0/255) blue:(145.0/255) alpha:1.0];
    }else{
        pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-galleryImage.frame.size. width/2, scrollContainerView.frame.size.height+scrollContainerView.frame.origin.y-45,galleryImage.frame.size.width,60)];
        pageControl.backgroundColor=[UIColor blackColor];
        pageControl.pageIndicatorTintColor = [UIColor colorWithRed:(129.0/255) green:(129.0/255) blue:(129.0/255) alpha:1.0];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(06.0/255) green:(122.0/255) blue:(145.0/255) alpha:1.0];
    }
    
    //ah 12.5
    galleryImage.translatesAutoresizingMaskIntoConstraints = YES;
    CGPoint center = galleryImage.center;
    [galleryImage setBounds:imageRect];
    [galleryImage setCenter:center];
    //end ah 12.5
    
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = noOfPages;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    [scrollContainerView bringSubviewToFront:pageControl];
    //[scrollContainerView  addSubview:pageControl];
}
-(IBAction)imageButton:(UIGestureRecognizer *)sender
{
    //
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.autoRotate=YES;
//    [timer invalidate];
//    counter = 0;
//    isHeighestBidder = NO;
//    PhotoViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"Photo"];
//    controller.imageArray=imagesArray;
//    [self.navigationController pushViewController:controller animated:NO];
    
}
#pragma mark - End

#pragma mark - Memeory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

//-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return galleryImage;
//}

@end
