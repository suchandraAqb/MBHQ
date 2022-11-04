//
//  BadgePopUpViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 05/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "BadgePopUpViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BadgePopUpViewController ()
{
    IBOutlet UIImageView *badgeImage;
    IBOutlet UILabel *badgeText;
    IBOutlet UIProgressView *progressBar;
    IBOutlet UILabel *badgeRangeText;
    IBOutlet UILabel *congratsLabel;
    IBOutlet UIView *popDayView;
    IBOutlet UIButton *readMoreButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UILabel *noOfdaysLabel;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *popUpDetailsLabel;
    IBOutlet UIButton *okGotItButton;
    IBOutlet UIView *streakdayView;
    IBOutlet UILabel *day1UserNamelabel;
    
    IBOutlet UIButton *plusButton;
    IBOutlet UILabel *mileStonePoint;
    IBOutlet UIButton *shareCrewButton;
    IBOutlet UILabel *gratitudeNameLabel;
    IBOutlet UIView *shareView;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIView *shareSuccessView;
    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *mileStonePointSuccessView;
    IBOutletCollection(UIButton) NSArray*successViewButton;
    IBOutlet UIButton *mileStonenextLabelPoint;
    IBOutlet UILabel *addYourPicLabel;
    IBOutlet UILabel *mbhqtag;
    IBOutlet UITextView *websoteTextview;
    IBOutlet UILabel *gratititudeCrewLabel;
    IBOutlet UIStackView *shareScreenView;
    NSArray *mileStoneArr;
    UIImage *mileStoneImg;
    NSTimer *timer;
    int remainingCounts;
    int currentStreak;
    int pbStreak;
    int laststreak;
    BOOL previousStreakBroken;
}
@end

@implementation BadgePopUpViewController
@synthesize type,colourCode,pointRange,streakDict;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    shareSuccessView.hidden = false;
    shareView.hidden = true;
    shareCrewButton.hidden = true;
    cancelButton.hidden = true;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    [self setUpTimer];
    
    if ([pointRange isEqualToString:@"25000"]) {
        badgeImage.image = [UIImage imageNamed:@"black_badge_gami.png"];
    }else{
        if (![Utility isEmptyCheck:colourCode]) {
            [badgeImage setImage:[[UIImage imageNamed:@"black_badge_gami.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            [badgeImage setTintColor:[Utility colorWithHexString:colourCode]];
        }
    }
  
    if (![Utility isEmptyCheck:type]) {
        badgeText.text = type;
    }
    if (![Utility isEmptyCheck:pointRange]) {
        badgeRangeText.text = pointRange;
    }
    if (![Utility isEmptyCheck:pointRange] && ![Utility isEmptyCheck:type]) {
        congratsLabel .text = [@""stringByAppendingFormat:@"You are now level \n%@ \n%@",pointRange,type];
    }
     */
    if (_isFromGami) {
        [self shareMySuccessBtnPressed:nil];
    }
    mileStoneArr = @[@3,@7,@14,@21,@28,@35,@42,@50,@75,@100,@125,@150,@175,@200,@225,@250,@275,@300,@325,@350,@375,@400,@425,@450,@475,@500,@550,@600,@650,@700,@750,@800,@850,@900,@950,@1000,@1100,@1200,@1300,@1400,@1500,@1600,@1700,@1800,@1900,@2000,@2250,@2500,@2750,@3000,@5000,@10000];
    
    for(UIButton *btn in successViewButton){
        btn.layer.cornerRadius = 15;
        btn.layer.masksToBounds = YES;
    }
    if (![Utility isEmptyCheck:streakDict]) {
        [self setUpStreakDetails];
    }
    
}
#pragma mark - End

#pragma mark - IBAction

-(IBAction)openImagePickerButtonPressed:(id)sender{
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
-(IBAction)addPicPickerButtonPressed:(id)sender{
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Add Pic" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
//                                                             self->mbhqtag.textColor = [[Utility colorWithHexString:mbhqBaseColor];
//                                                             self->websoteTextview.tintColor = [Utility colorWithHexString:mbhqBaseColor];
//                                                             self->gratititudeCrewLabel.textColor = [Utility colorWithHexString:mbhqBaseColor];
                                                             [self openImagePickerButtonPressed:nil];
                                                             }];
        
        UIAlertAction* galleryAction = [UIAlertAction actionWithTitle:@"Use template" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                self->mileStoneImg = [UIImage imageNamed:@"manny_trophy_big.png"];
                                                                [self->plusButton setImage:[UIImage imageNamed:@"manny_trophy_big.png"] forState:UIControlStateNormal];
                                                                 self->addYourPicLabel.hidden = true;
                                                                 self->plusButton.layer.borderWidth = 0;

//                                                                 self->mbhqtag.textColor = [UIColor blackColor];
//                                                                 self->websoteTextview.tintColor = [UIColor blackColor];
//                                                                 self->gratititudeCrewLabel.textColor = [UIColor blackColor];

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
-(IBAction)shareButtonPressed:(id)sender{
    if (!addYourPicLabel.hidden) {
        [Utility msg:@"Please add your pic to share" title:@"" controller:self haveToPop:NO];
        return;
    }
    shareCrewButton.hidden = true;
    cancelButton.hidden = true;
    
     UIImage *shareImage = [self captureView:shareView];
     NSArray *items = @[shareImage];
     
     // build an activity view controller
     UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
     
     // and present it
     [self presentActivityController:controller];
}
-(IBAction)shareMySuccessBtnPressed:(id)sender{
    shareView.hidden = false;
    shareSuccessView.hidden = true;
    shareCrewButton.hidden = false;
    cancelButton.hidden = false;
    [self addPicPickerButtonPressed:nil];
}
-(IBAction)keepItMyselfPressed:(id)sender{
    shareCrewButton.hidden = true;
    cancelButton.hidden =true;
    UIViewController *Controller = self.parentcontroller;
    if ([Controller isKindOfClass:[GamificationViewController class]]) {
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
         GamificationViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GamificationView"];
        controller.streakDict = self->streakDict;
        [Controller.navigationController pushViewController:controller animated:NO];
    }];
   
}
#pragma mark - End


#pragma mark  - Private Function
-(void)setUpStreakDetails{
    [defaults setObject:@"NO" forKey:@"todaySet"];
//    okGotItButton.layer.cornerRadius = 8;
//    okGotItButton.layer.masksToBounds = YES;

    [plusButton setImage:[UIImage imageNamed:@"plus-circle_today_habit.png"] forState:UIControlStateNormal];
    addYourPicLabel.hidden = false;
    
    plusButton.layer.cornerRadius = 15;
    plusButton.layer.masksToBounds = YES;
    plusButton.layer.borderColor = [UIColor blackColor].CGColor;//[Utility colorWithHexString:mbhqBaseColor].CGColor;
    plusButton.layer.borderWidth = 1;
    
    mileStonePoint.layer.cornerRadius = mileStonePoint.frame.size.height/2;
    mileStonePoint.layer.masksToBounds = YES;
    
    mileStonePointSuccessView.layer.cornerRadius = mileStonePointSuccessView.frame.size.height/2;
    mileStonePointSuccessView.layer.masksToBounds = YES;
    
    shareCrewButton.layer.cornerRadius = 15;
    shareCrewButton.layer.masksToBounds = YES;
    
    cancelButton.layer.cornerRadius = 15;
    cancelButton.layer.masksToBounds = YES;
    
    mileStonenextLabelPoint.layer.cornerRadius = mileStonenextLabelPoint.frame.size.height/2;
    mileStonenextLabelPoint.layer.masksToBounds = YES;
    
//    self->currentStreak = [[streakDict objectForKey:@"CurrentStreak"]intValue];
//    self->pbStreak = [[streakDict objectForKey:@"TopStreak"]intValue];
//    if ([[streakDict objectForKey:@"PreviousStreakBroken"]boolValue]) {
//        self->previousStreakBroken = true;
//    }else{
//        self->previousStreakBroken = false;
//    }
//    self->popDayView.hidden = false;
//    [self setUpRewardsView];
    
    if (![Utility isEmptyCheck:streakDict]) {
        //gratitudeNameLabel.text = @"I'm grateful for you";
        int total =[[streakDict objectForKey:@"Total"]intValue];
        if ([mileStoneArr containsObject:[NSNumber numberWithInt:total]]) {
            int index = (int)[mileStoneArr indexOfObject:[NSNumber numberWithInt:total]];
            [mileStonenextLabelPoint setTitle:[@"" stringByAppendingFormat:@"%@",mileStoneArr[index+1]] forState:UIControlStateNormal];
        }else{
            if (total==0) {
                [mileStonenextLabelPoint setTitle:@"3" forState:UIControlStateNormal];
            }else{
                [mileStonenextLabelPoint setTitle:@"" forState:UIControlStateNormal];
            }
        }
        if (![Utility isEmptyCheck:[streakDict objectForKey:@"Total"]]) {
            mileStonePoint.text = [@"" stringByAppendingFormat:@"%@",[streakDict objectForKey:@"Total"]];
            mileStonePointSuccessView.text =[@"" stringByAppendingFormat:@"%@",[streakDict objectForKey:@"Total"]];
        }
        textLabel.text = [@"" stringByAppendingFormat:@"Congratulations %@!\n\n Your gratitude level is rising",[defaults objectForKey:@"FirstName"]];

    }
    
//    if (self->currentStreak>=1 && self->currentStreak<=21 && self->currentStreak!=19 && self->currentStreak!=20) {
//        self->popDayView.hidden = false;
//        [self setUpRewardsView];
//    }else{
//        self->popDayView.hidden = true;
//    }
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
- (UIImage*)captureView:(UIView *)captureView {
    CGRect rect = captureView.bounds;
//    UIGraphicsBeginImageContext(rect.size);
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
            
        } else {
            
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
        self->shareCrewButton.hidden = false;
        self->cancelButton.hidden = false;
    };
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

//-(void)setUpRewardsView{ //change_rewards
//    NSString *dayStr=@"";
//    shareButton.hidden =true;
//    readMoreButton.hidden = true;
//    popDayView.hidden =false;
//    streakdayView.hidden = true;
//
//    if (currentStreak == 1) {
//        if (!previousStreakBroken) {
//            streakdayView.hidden = false;
//            if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//                   day1UserNamelabel.text = [[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//                }
//
////            noOfdaysLabel.text =@"1 DAY IN A ROW";
////            readMoreButton.hidden = false;
////            if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
////                userNameLabel.text =[[NSString stringWithFormat:@"Hey %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
////            }
////            if (readMoreButton.selected) {
////                dayStr = @"Your goal if you choose to accept it, is to use the app for 21 days in a row to create a new habit and change your body.\n\nIt’s simple... All you need to do is open the app each day for 21 days... That’s it!.\n\nIf you do this we know you are more likely to achieve your goals.\n\nWe have found the number 1 factor to long term success in our community is simply creating the habit of using the app and connecting with the community.\n\nSo even if you’ve had a tough day, even if you can’t do a workout even if all you can do is read the quote of the day then thats great.\n\nIt may not seem like much, but the health habit you are creating is incredibly powerful and by just your 21st day in a row you will be seeing big changes in yourself.\n\nYour streak can be seen in the top right of your app and if you click on this you can see your streak history and create other motivating streaks too\n\nLove Ashy xx";
////            }else{
////                dayStr = @"Your goal if you choose to accept it, is to use the app for 21 days in a row to create a new habit and change your body.\n\nIt’s simple... All you need to do is open the app each day for 21 days... That’s it!";
////            }
//        }
//        else{
//            noOfdaysLabel.text =@"STREAK DAY 1";
//            readMoreButton.hidden = true;
//            if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//                userNameLabel.text =[[NSString stringWithFormat:@"Hey %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//            }
//            dayStr = [@"" stringByAppendingFormat:@"Your last Squad Streak was %d days and your pb is %d days \n\n Are you ready to smash a new pb? What should we do first ? \n\n You got this!",laststreak+1,pbStreak];
//        }
//    }else if (currentStreak == 2){
//        noOfdaysLabel.text =@"2 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//
//            userNameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:17.0];
//            userNameLabel.textColor = [UIColor whiteColor];
//
//            userNameLabel.text =[[NSString stringWithFormat:@"Oh yeah %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr = @"Now you're on a real streak.\n\nKeep it up, and watch the changes occur!\n\nLove Ashy xx";
//    }else if (currentStreak == 3){
//        noOfdaysLabel.text =@"3 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"Damn %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr = @"I love your commitment!\n\nKeep it up!.\n\nLove Ashy xx";
//    }else if (currentStreak == 4){
//        noOfdaysLabel.text =@"";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr = @"Can i get a HELL YEAH!\n\nYou're over half way to completing one week in a row.\n\nI hope you're pretty dam impressed with yourself.\n\nI am\n\nKeep it up!\n\nLove Ashy xx";
//    }else if (currentStreak == 5){
//        noOfdaysLabel.text =@"5 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr = @"Ever heard the word 'unstoppable'?\n\nLook it up, I'm pretty sure there will be a picture of you next to the definition!\n\nKeep it up!\n\nLove Ashy xx";
//    }else if (currentStreak == 6){
//        noOfdaysLabel.text =@"";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr = @"Just 6 days ago you decided to change your health.\n\nYou have done everything I've asked of you thus far.\n\nCan you believe tomorrow is 1 week already?\n\nYou're on fire girl!\n\nKeep it up!\n\nLove Ashy xx";
//    }else if (currentStreak == 7){
//        noOfdaysLabel.text =@"";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"Happy 1 week anniversary %@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr = @"1 week of using the app and committing to yourself, your new body and your health.\n\nPretty impressive and you know what.... The hardest part has been done!\n\nIf you can make 7 days, you can do 14. If you can do 14 you can do 21. if you can do 21 you can do 42 and before you know it a new you will be looking back in the mirror!\n\nKeep it up! I love your determination\n\nLove Ashy xx\n\n[Share your streak now]";
//        shareButton.hidden = false;
//    }else if (currentStreak == 8){
//        noOfdaysLabel.text =@"8 DAYS";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr = @"1 week and 1 day down and you're so close to the first and biggest goal for every new Squad member.  21 days in a row.\n\nYou're pretty impressive. I hope you know that\n\nLove Ashy xx";
//    }else if (currentStreak == 9){
//        noOfdaysLabel.text =@"9 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
//    }
//    else if (currentStreak == 10){
//        noOfdaysLabel.text =@"10 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
//    }else if (currentStreak == 11){
//        noOfdaysLabel.text =@"Day 11";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr =@"Today is officially half way to your first big goal. 21 days in a row of using Squad.\n\nKeep it up! Every day you are getting fitter, healthier, more educated and self aware.\n\nHave you started one of my courses yet to increase your knowledge? Why not try one today. Click here.\n\nLove Ashy xx";
//    }else if (currentStreak == 12){
//        noOfdaysLabel.text =@"12 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",[defaults objectForKey:@"FirstName"]];
//    }else if (currentStreak == 13){
//        noOfdaysLabel.text =@"13 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !\n\nLove Ashy xx",userNameLabel.text];
//    }else if (currentStreak == 14){
//        noOfdaysLabel.text =@"";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr =@"Day 14 done and dusted!\n\nThat's 2 full weeks of using Squad daily.\n\nI hope you are as impressed with yourself as much as I am.\n\nKeep it up!\n\nDid you know tracking your food is a great way to improve your results. Try my meal tracker today [click here]\n\nLove Ashy xx\n\n[Share your streak now]";
//        shareButton.hidden= false;
//    }else if (currentStreak == 15){
//        noOfdaysLabel.text =@"15 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",userNameLabel.text];
//    }else if (currentStreak == 16){
//        noOfdaysLabel.text =@"16 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr =[@"" stringByAppendingFormat:@"Keep it up %@ !",userNameLabel.text];
//    }else if (currentStreak == 17){
//        noOfdaysLabel.text =@"17 DAYS IN A ROW";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =[[NSString stringWithFormat:@"%@,",[defaults objectForKey:@"FirstName"]]capitalizedString];
//        }
//        dayStr =@"Just let that sink in for a while. 17 days in a row. Are you sure you're not part machine!!\n\nHave you tried a fitness challenge yet? My finishers take between 3 and 5 minutes and are great at the end of a workout or on days when you don't have time to workout but want to do something!";
//    }else if (currentStreak == 18){
//        noOfdaysLabel.text =@"Day 18";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr =@"Motivation is what gets us started, habit is what keeps us going!\n\nCongratulations babe, you're commitment to the new you is inspiring and your new habits are getting stronger and stronger every day\n\nKeep it up\n\n3 days til you achieve the first Squad goal!  21 days in a row";
//    }
//    else if (currentStreak == 21){
//        noOfdaysLabel.text =@"";
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {
//            userNameLabel.text =@"";
//        }
//        dayStr = [@"" stringByAppendingFormat:@"ACHIEVEMENT UNLOCKED\n\nYou did it!\n\n21 days in a row and the first step in creating the new fitter, stronger, healthier you has been ticked off.\n\nThat doesn't mean you can get complacent, we're only just getting started!\n\nYour next target is 42 days in a row!\n\nAre you ready?\n\n[please share your success on the forum now] and tell us about the journey thus far. What you are doing, what you are feeling and where you are heading.\n\n %@,I am so excited for you. Congratulations once again on achieving the first goal for my squad babes to tick off.",[defaults objectForKey:@"FirstName"]];
//        shareButton.hidden=false;
//    }
//    popUpDetailsLabel.text = dayStr;
//}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - IBAction
//-(IBAction)readMoreButtonPressed:(id)sender{ //change_rewards
//    if (readMoreButton.selected) {
//        readMoreButton.selected = false;
//    }else{
//        readMoreButton.selected = true;
//    }
//    [self setUpRewardsView];
//}
//-(IBAction)crossDayButtonPressed:(id)sender{ //change_rewards
////    popDayView.hidden = true;
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//-(IBAction)okGotItButtonPressed:(id)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End

//#pragma mark - Private Function
//
//-(void)setUpTimer{
//    timer = [NSTimer scheduledTimerWithTimeInterval:1
//                                             target:self
//                                           selector:@selector(countDown)
//                                           userInfo:nil
//                                            repeats:YES];
//    remainingCounts = 0;
//
////        if (![Utility isEmptyCheck:badgeText]) {
////
////            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"You’ve gained a %@ and %@\n for %@",info,points,from]];
////
////            NSRange range = [[@"" stringByAppendingFormat:@"You’ve gained a %@ and %@\n for %@",info,points,from] rangeOfString:info];
////            NSRange range1 = [[@"" stringByAppendingFormat:@"You’ve gained a %@ and %@\n for %@",info,points,from] rangeOfString:points];
////            NSRange range2 = [[@"" stringByAppendingFormat:@"You’ve gained a %@ and %@\n for %@",info,points,from] rangeOfString:from];
////
////            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:16] range:NSMakeRange(range.location,range.length)];
////            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:16] range:NSMakeRange(range1.location,range1.length)];
////            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:16] range:NSMakeRange(range2.location,range2.length)];
////            badgeText.attributedText = text;
////        }
//
//}
//-(void)countDown {
//    remainingCounts++;
//    if (remainingCounts<=5) {
//        [progressBar setProgress:(float)remainingCounts*2/10.f];
//    }else{
//        [timer invalidate];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:nil];
//    }
//}
//#pragma mark - End

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //galaryimage=[Utility scaleImage:image width:profileImage.frame.size.width height:profileImage.frame.size.width];
    mileStoneImg=[Utility scaleImage:image width:image.size.width height:image.size.height];
    
    //galaryimage=image;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self->plusButton setImage:self->mileStoneImg forState:UIControlStateNormal];
        self->addYourPicLabel.hidden = true;
        self->shareSuccessView.hidden =true;
        self->shareView.hidden = false;
        [self openEditor:nil];

    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:^{
//        self->isChanged = YES;
        [self->plusButton setImage:self->mileStoneImg forState:UIControlStateNormal];
        self->addYourPicLabel.hidden = true;
        self->shareSuccessView.hidden =true;
        self->shareView.hidden = false;
        self->plusButton.layer.borderWidth = 0;
    }];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    [plusButton setImage:croppedImage forState:UIControlStateNormal];
    mileStoneImg = croppedImage;
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
