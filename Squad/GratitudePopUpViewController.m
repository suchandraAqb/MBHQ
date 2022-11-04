//
//  GratitudePopUpViewController.m
//  Squad
//
//  Created by Dhiman on 29/01/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import "GratitudePopUpViewController.h"
#import "GratitudeListViewController.h"
@interface GratitudePopUpViewController ()
{
    IBOutlet UITextView *gratitudeTextView;
    IBOutlet UIButton *picAddedButton;
    IBOutletCollection(UIButton) NSArray *shareCancelButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIStackView *shareView;
    IBOutlet UIView *gratitudeTextSuperView;
    IBOutlet NSLayoutConstraint *heightConstantForpicoverView;
    IBOutlet UITextView *picOverTextView;
    IBOutlet UIView *gratitudePicView;
    IBOutletCollection(UIButton) NSArray *alignmentButtons;
    IBOutlet UIStackView *borderStack;
    IBOutlet UIStackView *whiteBackBlackText;
    IBOutlet UIStackView *blackBackWhiteText;
    IBOutlet UIStackView *transBlackText;
    IBOutlet UIStackView *transWhiteText;
    IBOutlet UIButton *fontButton;
    IBOutletCollection(UIButton) NSArray *backgroundBtton;
    IBOutlet UIStackView *designStackView;
    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
    IBOutlet NSLayoutConstraint *leadingPicConstant;
    IBOutlet NSLayoutConstraint *trallingPicConstant;
    IBOutlet UIView *designView;
    IBOutlet UIView *shareSuperView;
    IBOutletCollection(UIButton) NSArray *moveTextViewButtonArr;
    IBOutlet NSLayoutConstraint *picOverHeightConstant;
    IBOutlet UIView *gratitudeImgView;
    IBOutlet UILabel *grateFulTextLabel;
    IBOutlet UIButton *smallLogo;
    IBOutlet NSLayoutConstraint *picOverTextHeighConstant;
    IBOutlet UIView *logoView;
    
    UIButton *btnSub;

    UIImage *mileStoneImg;
    UIToolbar *toolBar;
    UITextField *activeTextField;
    UITextView *activeTextView;
    NSString *localImageName;
    BOOL isExistingImageChange;
    UIImage *selectedImage;

}
@end

@implementation GratitudePopUpViewController

#pragma mark - view Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    gratitudeTextView.layer.borderColor = [UIColor blackColor].CGColor;//[Utility colorWithHexString:mbhqBaseColor].CGColor;
    gratitudeTextView.layer.borderWidth = 2;
//    gratitudeTextView.layer.cornerRadius = 15;
//    gratitudeTextView.layer.masksToBounds = YES;
    
    picAddedButton.layer.borderColor = [UIColor blackColor].CGColor;//[Utility colorWithHexString:mbhqBaseColor].CGColor;
    picAddedButton.layer.borderWidth = 2;
//    picAddedButton.layer.cornerRadius = 15;
//    picAddedButton.layer.masksToBounds = YES;
    
//    picOverTextView.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
//    picOverTextView.layer.borderWidth = 1;
//    picOverTextView.layer.cornerRadius = 15;
//    picOverTextView.layer.masksToBounds = YES;
    
    picOverTextView.textContainerInset= UIEdgeInsetsMake(10, 20, 10, 20);
    
    fontButton.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
    fontButton.layer.borderWidth = 1;
    fontButton.layer.cornerRadius = 9;
    fontButton.layer.masksToBounds = YES;
    
    for (UIButton *btn in moveTextViewButtonArr) {
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
        btn.layer.borderWidth = 1;
    }
    
    if (![Utility isEmptyCheck:_dict] && ![Utility isEmptyCheck:[_dict objectForKey:@"Name"]]) {
        gratitudeTextView.text = [_dict objectForKey:@"Name"];
        gratitudeTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
        
        picOverTextView.text =[_dict objectForKey:@"Name"];
        picOverTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];

    }else{
        gratitudeTextView.text =@"Start typing";
        gratitudeTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
        
        picOverTextView.text = @"Start typing";
        picOverTextView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:0.5];
    }
    
    if(![Utility isEmptyCheck:[_dict objectForKey:@"PictureDevicePath"]]){
        localImageName = [_dict objectForKey:@"PictureDevicePath"];
        selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
        
        if(selectedImage){
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            CGFloat imageViewHeight = selectedImage.size.height/selectedImage.size.width * screenWidth;
            self->imageViewHeightConstraint.constant = imageViewHeight;
            self->picOverTextHeighConstant.constant = imageViewHeight;
            [picAddedButton setImage:selectedImage forState:UIControlStateNormal];
        }else if (![Utility isEmptyCheck:[_dict objectForKey:@"Picture"]]) {
            NSString *imageUrlString =[_dict objectForKey:@"Picture"];
            [picAddedButton sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_holder.png"]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                    self->imageViewHeightConstraint.constant = imageViewHeight;
                    self->picOverTextHeighConstant.constant = imageViewHeight;

                    self->selectedImage = image;
                }
            }];
        }else{
            [picAddedButton setImage:[UIImage imageNamed:@"plus-circle_today_habit.png"] forState:UIControlStateNormal];//upload_image.png
        }
    }else if (![Utility isEmptyCheck:[_dict objectForKey:@"Picture"]]) {
        NSString *imageUrlString =[_dict objectForKey:@"Picture"];
        [picAddedButton sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_holder.png"]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                self->imageViewHeightConstraint.constant = imageViewHeight;
                self->picOverTextHeighConstant.constant = imageViewHeight;

                self->selectedImage = image;
            }
        }];
        
    }
    else{
        localImageName = [Utility createImageFileNameFromTimeStamp];
        [picAddedButton setImage:[UIImage imageNamed:@"plus-circle_today_habit.png"] forState:UIControlStateNormal];
    }
   
    
    for (UIButton *btn in shareCancelButton) {
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
    }
    for (UIButton *btn in alignmentButtons) {
        if (!btn.selected) {
            btn.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
            btn.layer.borderWidth = 1;
        }
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
    }
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [self registerForKeyboardNotifications];
    if([_type isEqualToString:@"TextWithPic"]){
        gratitudeTextSuperView.hidden = false;
        gratitudePicView.hidden = false;
        heightConstantForpicoverView.constant = 0;
//        borderStack.hidden = false;
        borderStack.hidden = true;
        blackBackWhiteText.hidden = true;
        whiteBackBlackText.hidden = true;
        transBlackText.hidden = true;
        transWhiteText.hidden = true;
        for (UIButton *btn in moveTextViewButtonArr) {
            btn.hidden = true;
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:gratitudePicView.bounds];
        [gratitudeImgView addSubview:btn];
        [btn addTarget:self action:@selector(openImagePickerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        picOverHeightConstant.constant = 0;
        picOverTextView.hidden = true;
        gratitudeImgView.hidden = false;
        
    }else if([_type isEqualToString:@"TextOverPic"]){
        gratitudeTextSuperView.hidden = true;
        gratitudePicView.hidden = false;
        heightConstantForpicoverView.constant = 128;
        //        borderStack.hidden = false;
                borderStack.hidden = true;
        blackBackWhiteText.hidden = false;
        whiteBackBlackText.hidden = false;
        transBlackText.hidden = false;
        transWhiteText.hidden = false;
       for (UIButton *btn in moveTextViewButtonArr) {
           btn.hidden = false;
        }
         picOverTextView.hidden = false;
         gratitudeImgView.hidden = false;
         BOOL isPicEmpty = NO;
          if (![Utility isEmptyCheck:[_dict objectForKey:@"PictureDevicePath"]]) {
              isPicEmpty = NO;
          }else if(![Utility isEmptyCheck:[_dict objectForKey:@"Picture"]]){
              isPicEmpty = false;
          }else if(mileStoneImg || selectedImage){
              isPicEmpty= false;
          }else{
              isPicEmpty= true;
          }
        if (isPicEmpty) {
            btnSub = [[UIButton alloc]initWithFrame:gratitudePicView.bounds];
            [gratitudeImgView addSubview:btnSub];
            [btnSub addTarget:self action:@selector(openImagePickerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            for (UIButton *btn in moveTextViewButtonArr) {
                btn.hidden = true;
                
            }
        }else{
           for (UIButton *btn in moveTextViewButtonArr) {
                btn.hidden = false;
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[Utility colorWithHexString:mbhqBaseColor] forState:UIControlStateNormal];
                btn.layer.borderColor = [Utility colorWithHexString:mbhqBaseColor].CGColor;
                btn.layer.borderWidth = 1;
            }
            [btnSub removeFromSuperview];
        }
        
    }else{
        heightConstantForpicoverView.constant = 0;
        gratitudeTextSuperView.hidden = false;
        gratitudePicView.hidden = true;
//        borderStack.hidden = false;
        borderStack.hidden = true;
        
        blackBackWhiteText.hidden = true;
        whiteBackBlackText.hidden = true;
        transBlackText.hidden = true;
        transWhiteText.hidden = true;
         for (UIButton *btn in moveTextViewButtonArr) {
              btn.hidden = true;
         }
        picOverHeightConstant.constant = 0;
        picOverTextView.hidden = true;
        gratitudeImgView.hidden = true;
    }
    UIButton *button = [[UIButton alloc]init];
    button.tag = 0;
    [self backgroundWithTextFontPressed:button];
    [fontButton setTitle:@"20" forState:UIControlStateNormal];
    [gratitudeTextView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:18]];
    [picOverTextView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:18]];
    leadingPicConstant.constant = 0;
    trallingPicConstant.constant = 0;
    
    mainScroll.scrollEnabled = true;

     picAddedButton.userInteractionEnabled = false;
     [picOverTextView setUserInteractionEnabled:true];
     UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
     panRecognizer.minimumNumberOfTouches = 1;
     panRecognizer.delegate = self;
     [picOverTextView addGestureRecognizer:panRecognizer];
     UISwitch *sw = [[UISwitch alloc]init];
     sw.on = false;
     [self borderNoBorderSwitchPressed:sw];
     UIButton *btn = [[UIButton alloc]init];
     btn.tag = 1;
     [self textAlignmentButtonPressed:btn];
     picOverTextView.userInteractionEnabled = false;

    // Do any additional setup after loading the view.
}

#pragma mark - End

#pragma mark - IBActions
-(IBAction)shareButtonPressed:(id)sender{
    BOOL isPicEmpty = NO;
    if (![Utility isEmptyCheck:[_dict objectForKey:@"PictureDevicePath"]]) {
        isPicEmpty = NO;
    }else if(![Utility isEmptyCheck:[_dict objectForKey:@"Picture"]]){
        isPicEmpty = false;
    }else if(mileStoneImg || selectedImage){
        isPicEmpty= false;
    }else{
        isPicEmpty= true;
    }
    if([_type isEqualToString:@"TextOverPic"]){
        if (([Utility isEmptyCheck:picOverTextView.text] || [picOverTextView.text isEqualToString:@"Start typing"]) || isPicEmpty) {
            [Utility msg:@"Please write something or add pic that you want to share" title:@"" controller:self haveToPop:NO];
            return;
        }
    }
    else if([_type isEqualToString:@"TextWithPic"]){
        if (([Utility isEmptyCheck:gratitudeTextView.text] || [gratitudeTextView.text isEqualToString:@"Start typing"]) || isPicEmpty ) {
           [Utility msg:@"Please write something or add pic that you want to share" title:@"" controller:self haveToPop:NO];
           return;
        }
    }else{
        if ([Utility isEmptyCheck:gratitudeTextView.text] || [gratitudeTextView.text isEqualToString:@"Start typing"]) {
            [Utility msg:@"Please write something that you want to share" title:@"" controller:self haveToPop:NO];
            return;
        }
    }
    if (![Utility isEmptyCheck:[_dict objectForKey:@"PictureDevicePath"]]) {
           picAddedButton.hidden = false;
       }else if(![Utility isEmptyCheck:[_dict objectForKey:@"Picture"]]){
           picAddedButton.hidden = false;
       }else if(mileStoneImg || selectedImage){
           picAddedButton.hidden = false;
       }else{
           picAddedButton.hidden = true;
       }
       for (UIButton *btn in  shareCancelButton) {
        btn.hidden = true;
       }
        designStackView.hidden = true;
        designView.hidden = true;
        shareSuperView.hidden = true;
        UIImage *shareImage = [self captureView:shareView];
        NSArray *items = @[shareImage];
        
        // build an activity view controller
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
        
        // and present it
        [self presentActivityController:controller];
}
-(IBAction)cancelButtonPressed:(id)sender{
//    BOOL isTrue = false;
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGratitudeEditView" object:nil];
        NSArray *arr = [self->_controller.navigationController viewControllers];
        for (UIViewController *controller in arr) {
            if ([controller isKindOfClass:[GratitudeListViewController class]]) {
                [self->_controller.navigationController popToViewController:controller animated:NO];
            }
        }
        
    }];
}
-(IBAction)openImagePickerButtonPressed:(UIButton*)sender{
        mainScroll.scrollEnabled = true;
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Take A Photo" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 NSLog(@"Photo is selected");
                                                                 [self showCamera];
                                                             }];
        
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Browse Photo" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  NSLog(@"Gallery is selected");
                                                                  [self openPhotoAlbum];
                                                              }];
        
        UIAlertAction * defaultAct = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * action) {
                                                                NSLog(@"Cancel is clicked");
                                                                [self closeActionsheet];
                                                            }];
        
        [alert addAction:cameraAction];
        [alert addAction:galleryAction];
        [alert addAction:defaultAct];
        
        [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)borderNoBorderSwitchPressed:(UISwitch*)sender{
    if (sender.on) {
        gratitudeTextView.layer.borderWidth = 1;
        picAddedButton.layer.borderWidth = 1;
        leadingPicConstant.constant = 0;
        trallingPicConstant.constant = 0;
    }else{
        gratitudeTextView.layer.borderWidth = 0;
        picAddedButton.layer.borderWidth = 0;
        leadingPicConstant.constant = 0;
        trallingPicConstant.constant = 0;
    }
    
}
-(IBAction)textAlignmentButtonPressed:(UIButton*)sender{
    if (sender.tag == 0) {
        gratitudeTextView.textAlignment = NSTextAlignmentLeft;
        picOverTextView.textAlignment = NSTextAlignmentLeft;
    }else if (sender.tag == 1){
        gratitudeTextView.textAlignment = NSTextAlignmentCenter;
        picOverTextView.textAlignment = NSTextAlignmentCenter;

    }else{
        gratitudeTextView.textAlignment = NSTextAlignmentRight;
        picOverTextView.textAlignment = NSTextAlignmentRight;
    }
}
-(IBAction)backgroundWithTextFontPressed:(UIButton*)sender{
    int value = (int)sender.tag;
    
    for (UIButton *btn in backgroundBtton) {
        if (btn.tag == value) {
            btn.selected = true;
        }else{
            btn.selected = false;
        }
    }
    if (value == 0) {
        picOverTextView.backgroundColor = [UIColor whiteColor];
        picOverTextView.textColor = [UIColor blackColor];
        grateFulTextLabel.backgroundColor = [UIColor whiteColor];
        smallLogo.backgroundColor = [UIColor whiteColor];
        grateFulTextLabel.textColor = [UIColor blackColor];
        [smallLogo setImage:[UIImage imageNamed:@"mbhq_signup_logo.png"] forState:UIControlStateNormal];
        logoView.backgroundColor = [UIColor whiteColor];

    }else if (value == 1){
        picOverTextView.backgroundColor = [UIColor blackColor];
        picOverTextView.textColor = [UIColor whiteColor];
        grateFulTextLabel.backgroundColor = [UIColor blackColor];
        smallLogo.backgroundColor = [UIColor blackColor];
        grateFulTextLabel.textColor = [UIColor whiteColor];
        [smallLogo setImage:[UIImage imageNamed:@"logo_white.png"] forState:UIControlStateNormal];
        logoView.backgroundColor = [UIColor blackColor];
    }else if (value == 2){
        picOverTextView.backgroundColor = [UIColor clearColor];
        picOverTextView.textColor = [UIColor blackColor];
        grateFulTextLabel.backgroundColor = [UIColor whiteColor];
        smallLogo.backgroundColor = [UIColor whiteColor];
        grateFulTextLabel.textColor = [UIColor blackColor];
        [smallLogo setImage:[UIImage imageNamed:@"mbhq_signup_logo.png"] forState:UIControlStateNormal];
        logoView.backgroundColor = [UIColor whiteColor];

    }else{
        picOverTextView.backgroundColor = [UIColor clearColor];
        picOverTextView.textColor = [UIColor whiteColor];
        grateFulTextLabel.backgroundColor = [UIColor blackColor];
        smallLogo.backgroundColor = [UIColor blackColor];
        grateFulTextLabel.textColor = [UIColor whiteColor];
        [smallLogo setImage:[UIImage imageNamed:@"logo_white.png"] forState:UIControlStateNormal];
        logoView.backgroundColor = [UIColor blackColor];

    }
}
-(IBAction)fontPickerButtonPressed:(id)sender{
    SettingsPickersViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"SettingsPickers"];
    controller.selectRow = 4;
    controller.pickerArray = @[@"12",@"14",@"16",@"18",@"20",@"22",@"24",@"26",@"28",@"30",@"32",@"34",@"36",@"38",@"40",@"42",@"44",@"46",@"48"];
    controller.settingsCustomPickerDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)moveTextViewButtonPressed:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        mainScroll.scrollEnabled = false;
        sender.backgroundColor = [Utility colorWithHexString:mbhqBaseColor];
        picOverTextView.userInteractionEnabled = true;;

    }else{
        mainScroll.scrollEnabled = true;
        sender.backgroundColor = [UIColor whiteColor];
        picOverTextView.userInteractionEnabled = false;
    }
}
#pragma mark - End

#pragma mark - Private Method
-(IBAction)btnClickedDone:(id)sender{
//    [picOverTextView resignFirstResponder];
    [self.view endEditing:YES];
    if([_type isEqualToString:@"TextOverPic"]){
        if (picOverTextView.userInteractionEnabled) {
            mainScroll.scrollEnabled = false;
        }else{
            mainScroll.scrollEnabled = true;
        }
    }
}
- (void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        // Has camera
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Camera not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)closeActionsheet{
    NSLog(@"calcelpress");
}
- (IBAction)openEditor:(id)sender
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = mileStoneImg;
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
- (UIImage*)captureView:(UIView *)captureView {
    CGRect rect = captureView.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,[UIScreen mainScreen].scale);
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
            [self saveDataMultiPart];
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
        for (UIButton *btn in self->shareCancelButton) {
            btn.hidden = false;
        }
        self->picAddedButton.hidden = false;
        self->designStackView.hidden = false;
        self->designView.hidden = false;
        self->shareSuperView.hidden = false;
    };
}
-(void)move:(UIPanGestureRecognizer *)recognizer {
    [self.view bringSubviewToFront:recognizer.view];
    CGPoint translation = [recognizer translationInView:gratitudePicView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:gratitudePicView];
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            [UIView beginAnimations:nil context:NULL];
            [UIView commitAnimations];

        }
}
//-(void)move:(UIPanGestureRecognizer*)sender {
//    [self.view bringSubviewToFront:sender.view];
//    CGPoint translatedPoint = [sender translationInView:sender.view.superview];
//    CGFloat firstX;
//    CGFloat firstY;
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        firstX = sender.view.center.x;
//        firstY = sender.view.center.y;
//    }
//
//
//    translatedPoint = CGPointMake(sender.view.center.x+translatedPoint.x, sender.view.center.y+translatedPoint.y);
//
//    [sender.view setCenter:translatedPoint];
//    [sender setTranslation:CGPointZero inView:sender.view];
//
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
//        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//        [[sender view] setCenter:CGPointMake(translatedPoint.x, translatedPoint.y)];
//        [UIView commitAnimations];
//    }
//}
#pragma mark - End
-(void) saveDataMultiPart {
    NSMutableDictionary *gratitudeData = [[NSMutableDictionary alloc]init];
    gratitudeData = [_dict mutableCopy];
    if (Utility.reachable) {
         if([_type isEqualToString:@"TextOverPic"]){
             if (![Utility isEmptyCheck:picOverTextView.text] && picOverTextView.text.length > 0 && ![picOverTextView.text isEqualToString:@"Add Gratitude"]) {
                       [gratitudeData setObject:picOverTextView.text forKey:@"Name"];
                   }else{
                       [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
                       return;
                   }
         }else{
             if (![Utility isEmptyCheck:gratitudeTextView.text] && gratitudeTextView.text.length > 0 && ![gratitudeTextView.text isEqualToString:@"Add Gratitude"]) {
                       [gratitudeData setObject:gratitudeTextView.text forKey:@"Name"];
                   }else{
                       [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
                       return;
                   }
         }
      

        if (![Utility isEmptyCheck:[_dict objectForKey:@"Description"]]) {
                [gratitudeData setObject:[_dict objectForKey:@"Description"] forKey:@"Description"];
        }else{
                [gratitudeData setObject:@"" forKey:@"Description"];
        }
        
        if ([gratitudeData objectForKey:@"FrequencyId"] == nil) {
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt1"];
            [gratitudeData setObject:[NSNumber numberWithInt:43200] forKey:@"ReminderAt2"];
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        if (gratitudeData[@"Id"] == nil) {
            [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (gratitudeData[@"CreatedBy"] == nil) {
            [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        if(![Utility isEmptyCheck:localImageName]){
            [gratitudeData setObject:localImageName forKey:@"PictureDevicePath"];
        }else{
            [gratitudeData setObject:@"" forKey:@"PictureDevicePath"];
        }
        
        
        
        
        
        
        [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        //controller.chosenImage=selectedImage;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark -
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }else if (activeTextView !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect,frame.origin) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - textView Delegate
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    [self.view layoutIfNeeded];
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
    [textView setInputAccessoryView:toolBar];
    return YES;
}
//gratitudeDetails
- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView = textView;
    [textView becomeFirstResponder];
    if ([textView.text isEqualToString:@"Start typing"]) {
        textView.text = @"";
        textView.textColor = [[Utility colorWithHexString:@"333333"]colorWithAlphaComponent:1];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView = nil;
}
- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            
            [Utility saveImageDetails:self->localImageName imagetype:GratitudeList Itemid:[[[responseDict objectForKey:@"Details"] objectForKey:@"Id"]intValue] existingImageChange:self->isExistingImageChange selectedImage:self->mileStoneImg];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadGratitudeEditView" object:self userInfo:nil];
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self->_controller isKindOfClass:[NotesViewController class]]) {
                    [self->_controller.navigationController popViewControllerAnimated:NO];
                }
            }];
            

//            UIAlertController *alertController = [UIAlertController
//                                                  alertControllerWithTitle:@"Success"
//                                                  message:@"Gratitude Saved Successfully. "
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *okAction = [UIAlertAction
//                                       actionWithTitle:@"OK"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
////                                              if([self->gratitudeDelegate respondsToSelector:@selector(didGratitudeBackAction:)]){
////                                               [self->gratitudeDelegate didGratitudeBackAction:self->isLoad];
////                                           }
//                                           [self dismissViewControllerAnimated:YES completion:nil];
//
//                                       }];
//            [alertController addAction:okAction];
//            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}
-(void)updateSettingsCustomPickerValue:(NSString *)key withValue:(NSString *)pickerValue{
    NSLog(@"%@",pickerValue);
    if (![Utility isEmptyCheck:pickerValue]) {
        [fontButton setTitle:pickerValue forState:UIControlStateNormal];
    }
    [gratitudeTextView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:[pickerValue floatValue]]];
    [picOverTextView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:[pickerValue floatValue]]];
}
#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //galaryimage=[Utility scaleImage:image width:profileImage.frame.size.width height:profileImage.frame.size.width];
    mileStoneImg=[Utility scaleImage:image width:image.size.width height:image.size.height];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewHeight = mileStoneImg.size.height/mileStoneImg.size.width * screenWidth;
    
    self->imageViewHeightConstraint.constant = imageViewHeight;
    self->picOverTextHeighConstant.constant = imageViewHeight;

    isExistingImageChange = true;
    //galaryimage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self->picAddedButton setImage:self->mileStoneImg forState:UIControlStateNormal];
//        self->addYourPicLabel.hidden = true;
        if([self->_type isEqualToString:@"TextOverPic"]){
           for (UIButton *btn in self->moveTextViewButtonArr) {
             btn.hidden = false;
             btn.selected = false;
             btn.backgroundColor = [UIColor whiteColor];
          }
          [self->btnSub removeFromSuperview];
        }
        [self openEditor:nil];

    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:^{
        [self->picAddedButton setImage:self->mileStoneImg forState:UIControlStateNormal];
//        self->addYourPicLabel.hidden = true;
        self->picAddedButton.layer.borderWidth = 0;
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    [picAddedButton setImage:croppedImage forState:UIControlStateNormal];
    isExistingImageChange = true;
    mileStoneImg = croppedImage;
    localImageName = [Utility createImageFileNameFromTimeStamp];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat imageViewHeight = mileStoneImg.size.height/mileStoneImg.size.width * screenWidth;
    self->imageViewHeightConstraint.constant = imageViewHeight;
    self->picOverTextHeighConstant.constant = imageViewHeight;

    [Utility writeImageInDocumentsDirectory:mileStoneImg imageName:localImageName];
     if([self->_type isEqualToString:@"TextOverPic"]){
              for (UIButton *btn in self->moveTextViewButtonArr) {
                btn.hidden = false;
                btn.selected = false;
                btn.backgroundColor = [UIColor whiteColor];
             }
             [self->btnSub removeFromSuperview];
           }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    }
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    [controller dismissViewControllerAnimated:YES completion:^{
        //self->isChanged = YES;
    }];
}
@end
