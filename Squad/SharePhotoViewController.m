//
//  SharePhotoViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 02/08/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SharePhotoViewController.h"

@interface SharePhotoViewController () {
    IBOutlet UIImageView *imgView;
    IBOutlet UIView *bgShareView;
    IBOutlet UILabel *leftWeightLabel;
    IBOutlet UILabel *rightWeightLabel;
    IBOutlet UILabel *leftDateLabel;
    IBOutlet UILabel *rightDateLabel;
}

@end

@implementation SharePhotoViewController
//ah ph

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    imgView.image = _img;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    
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
- (IBAction)editButtonTapped:(id)sender {
    NSString *leftWeight =@"";
    NSString *rightWeight=@"";
    
    if(leftWeightLabel.attributedText.string.length>0){
        NSArray *arr = [leftWeightLabel.attributedText.string componentsSeparatedByString:@" "];
        leftWeight = arr[0];
    }
    
    if(rightWeightLabel.attributedText.string.length>0){
        NSArray *arr = [rightWeightLabel.attributedText.string componentsSeparatedByString:@" "];
        rightWeight = arr[0];
    }
    
    
    SharePicDataViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SharePicData"];
    controller.picDataDelegate = self;
    controller.prevLeftWeight = leftWeight;
    controller.prevRightWeight = rightWeight;
    controller.prevLeftDate = leftDateLabel.attributedText.string;
    controller.prevRightDate = rightDateLabel.attributedText.string;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)shareButtonTapped:(id)sender {
    UIImage *shareImage = [self captureView:bgShareView];
    NSArray *items = @[shareImage];
    
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    // and present it
    [self presentActivityController:controller];
}
#pragma mark - Private Methods

- (UIImage*)captureView:(UIView *)captureView {
    CGRect rect = captureView.bounds;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [captureView.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

#pragma mark - PicDataDelegate
- (void) getPicDataLeftWeight:(NSString *)leftWeight RightWeight:(NSString *)rightWeight LeftDate:(NSString *)leftDate RightDate:(NSString *)rightDate {
//    leftWeightLabel.text = leftWeight;
//    rightWeightLabel.text = rightWeight;
//    leftDateLabel.text = leftDate;
//    rightDateLabel.text = rightDate;
    
    NSAttributedString *leftDateAttr = [[NSAttributedString alloc] initWithString:leftDate attributes:@{NSStrokeColorAttributeName:[UIColor blackColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0, NSFontAttributeName: [UIFont fontWithName:@"Oswald-Regular" size:15.0]}];
    
    NSAttributedString *leftWeightAttr = [[NSAttributedString alloc] initWithString:leftWeight attributes:@{NSStrokeColorAttributeName:[UIColor blackColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0, NSFontAttributeName: [UIFont fontWithName:@"Oswald-Regular" size:20.0]}];
    
    NSAttributedString *rightDateAttr = [[NSAttributedString alloc] initWithString:rightDate attributes:@{NSStrokeColorAttributeName:[UIColor blackColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0, NSFontAttributeName: [UIFont fontWithName:@"Oswald-Regular" size:15.0]}];
    
    NSAttributedString *rightWeightAttr = [[NSAttributedString alloc] initWithString:rightWeight attributes:@{NSStrokeColorAttributeName:[UIColor blackColor], NSForegroundColorAttributeName:[UIColor whiteColor], NSStrokeWidthAttributeName: @-1.0, NSFontAttributeName: [UIFont fontWithName:@"Oswald-Regular" size:20.0]}];

    leftDateLabel.attributedText = leftDateAttr;
    leftWeightLabel.attributedText = leftWeightAttr;
    rightDateLabel.attributedText = rightDateAttr;
    rightWeightLabel.attributedText = rightWeightAttr;
}

@end
