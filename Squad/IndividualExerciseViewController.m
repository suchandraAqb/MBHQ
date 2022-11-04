//
//  IndividualExerciseViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 27/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "IndividualExerciseViewController.h"
#import "Utility.h"
@interface IndividualExerciseViewController (){
    IBOutlet UIScrollView *scroll;
    IBOutlet UIView *container;

    IBOutlet UIStackView *detailStackView;
    IBOutlet UILabel *instruction;
    IBOutlet UILabel *tips;
    IBOutlet UIStackView *equipmentRequiredStackView;
    IBOutlet UILabel *equipmentRequired;
    IBOutlet UIStackView *equipmentBasedAlternativesStackView;
    IBOutlet UILabel *equipmentBasedAlertnatives;
    IBOutlet UIStackView *bodyWeightAlertnativesStackView;
    IBOutlet UILabel *bodyWeightAlternative;
    
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *previousButton;
    IBOutlet UIView *playerContainer;
    IBOutlet UIImageView *exImage;
    IBOutlet UIView *playerView;
    IBOutlet UILabel *exerciseName;
    AVPlayerViewController *playerController;
    UIView *contentView;
    AVPlayer *player;
    


}

@end

@implementation IndividualExerciseViewController
@synthesize exerciseId;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getExerciseList:@""];
}
-(void)prepareView:(NSDictionary *)dict{
    if (![Utility isEmptyCheck:dict]) {
        exerciseName.text= ![Utility isEmptyCheck:[dict objectForKey:@"ExerciseName"]] ? [dict objectForKey:@"ExerciseName"]:@"";

        NSArray *imageArray =![Utility isEmptyCheck:[dict objectForKey:@"Photos"]] ? [dict objectForKey:@"Photos"]:[[NSArray alloc]init];
        if (imageArray.count > 0) {
            NSString *imageString = [imageArray objectAtIndex:0];
            [exImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                            placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
        }

        if (![[dict objectForKey:@"LabelOnly"] boolValue]) {
            NSArray *instructions = [dict objectForKey:@"Instructions"];
            if (![Utility isEmptyCheck:instructions] && instructions.count > 0) {
                instruction.text = [@"" stringByAppendingFormat:@"%@",[instructions componentsJoinedByString:@"\n"]];
            }else{
                instruction.text = @"";
                instruction.hidden = true;
            }
            NSArray *tipsArray = [dict objectForKey:@"Tips"];
            if (![Utility isEmptyCheck:tipsArray] && tipsArray.count > 0) {
                tips.attributedText  = [Utility getStringWithHeader:@"Tips : \n" headerFont:[UIFont fontWithName:@"Raleway-Medium" size:13] headerColor:[UIColor blackColor] bodyString:[@"" stringByAppendingFormat:@"\u2022  %@",[tipsArray componentsJoinedByString:@"\n\u2022  "] ] bodyFont:[UIFont fontWithName:@"Raleway" size:13] BodyColor:[UIColor blackColor]];
            }else{
                tips.text = @"";
                tips.hidden = true;
                
            }
            NSArray *equipments = [dict objectForKey:@"Equipments"];
            if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
                equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
                equipmentRequiredStackView.hidden = false;
                
            }else{
                equipmentRequiredStackView.hidden = true;
            }
            NSArray *altBodyWeightExercises = [dict objectForKey:@"AltBodyWeightExercises"];
            if (![Utility isEmptyCheck:altBodyWeightExercises] && altBodyWeightExercises.count > 0) {
                NSString *string = @"";
                for (NSDictionary *dict in altBodyWeightExercises) {
                    if (![Utility isEmptyCheck:[dict objectForKey:@"BodyWeightAltExerciseName"]]) {
                        string = [string stringByAppendingFormat:@"\u2022  %@",[dict objectForKey:@"BodyWeightAltExerciseName"]];

                    }
                }
                if (![Utility isEmptyCheck:string]) {
                    bodyWeightAlternative.text = string;
                    bodyWeightAlertnativesStackView.hidden = false;
                }else{
                    bodyWeightAlertnativesStackView.hidden = true;
                }
                
            }else{
                bodyWeightAlertnativesStackView.hidden = true;
            }
            NSArray *substituteEquipments = [dict objectForKey:@"SubstituteEquipments"];
            if (![Utility isEmptyCheck:substituteEquipments] && substituteEquipments.count > 0) {
                equipmentBasedAlertnatives.text = [@"\u2022  " stringByAppendingString:[substituteEquipments componentsJoinedByString:@"\n\u2022  "]];
                equipmentBasedAlternativesStackView.hidden = false;
                
            }else{
                equipmentBasedAlternativesStackView.hidden = true;
            }
            if (playerController.player) {
                [playerController.player pause];
                [playerController removeFromParentViewController];
            }
            NSString *videoId = [dict objectForKey:@"PublicUrl"];
            
            if (![Utility isEmptyCheck:videoId]) {
                playerContainer.hidden =false;
                
                AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
                NSURL *videoUrl = [NSURL URLWithString:videoId];
                player = [AVPlayer playerWithURL:videoUrl];
                [player play];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = true;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                playerViewController.view.frame = playerView.bounds;
                [playerView addSubview:playerViewController.view];
                playerController = playerViewController;
            }else{
                playerContainer.hidden =true;
            }
            exImage.hidden = true;
            previousButton.hidden = NO;
            playerView.hidden = false;
            nextButton.hidden = NO;
            
        }else{
            if (playerController.player) {
                [playerController.player pause];
                playerController.player = nil;
                [playerController removeFromParentViewController];
            }
        }
        
    }
}
#pragma mark -APICall
- (UIView *)activityIndicatorViewForModal:(UIView *)view{
    UIView *contentView1=[[UIView alloc]initWithFrame:view.bounds];
    contentView1.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.7f];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame= CGRectMake(contentView1.frame.size.width/2,20, 24, 24);
    activityView.color =[UIColor grayColor];
    activityView.center=contentView1.center;
    [activityView startAnimating];
    [activityView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [contentView1 addSubview: activityView];
    [contentView1 addConstraint:[NSLayoutConstraint constraintWithItem:activityView
                                                            attribute:NSLayoutAttributeCenterX
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView1
                                                            attribute:NSLayoutAttributeCenterX
                                                           multiplier:1.0
                                                             constant:0.0]];
    [contentView1 addConstraint:[NSLayoutConstraint constraintWithItem:activityView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:contentView1
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1.0
                                                             constant:0.0]];
    [contentView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view addSubview:contentView1];
    
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:contentView1
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:NSLayoutAttributeWidth
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:contentView1
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:contentView1
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0
                                                                 constant:0.0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:contentView1
                                                                attribute:NSLayoutAttributeCenterY
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:NSLayoutAttributeCenterY
                                                               multiplier:1.0
                                                                 constant:0.0]];
    return contentView1;
    
}
-(void)getExerciseList:(NSString *)searchText{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [self activityIndicatorViewForModal:container];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:exerciseId] forKey:@"ExerciseId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetExerciseApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSDictionary *exerciseDetail = [responseDict objectForKey:@"ExerciseDetail"];
                                                                         if (![Utility isEmptyCheck:exerciseDetail]) {
                                                                             [self prepareView:exerciseDetail];
                                                                         }else{
                                                                             [Utility msg:@"Spmething went wrong. Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
#pragma mark -End

#pragma mark -IBAction
- (IBAction)closeButtonpressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)previous:(UIButton *)sender {
    [playerController.player pause];
    [UIView transitionWithView:playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                    }
                    completion:^(BOOL finished){
                        nextButton.hidden = NO;
                        previousButton.hidden = NO;
                        if (exImage.hidden) {
                            exImage.hidden = NO;
                            playerView.hidden = YES;
                        }else{
                            exImage.hidden = YES;
                            playerView.hidden = NO;
                        }
                        
                        
                    }
     ];
    
}
- (IBAction)next:(UIButton *)sender {
    [playerController.player pause];
    [UIView transitionWithView:playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    }
                    completion:^(BOOL finished){
                        previousButton.hidden = NO;
                        nextButton.hidden = NO;
                        if (exImage.hidden) {
                            exImage.hidden = NO;
                            playerView.hidden = YES;
                        }else{
                            exImage.hidden = YES;
                            playerView.hidden = NO;
                        }
                        
                    }
     ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
