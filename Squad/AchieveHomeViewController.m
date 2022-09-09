//
//  AchieveHomeViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 06/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AchieveHomeViewController.h"
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "ChalengesHomeViewController.h"
#import "AccountabilityBuddyHomeViewController.h"

@interface AchieveHomeViewController () {
    IBOutlet UIButton *headerCalenderButton;
    IBOutlet UIButton *headerHelpButton;
    IBOutlet UILabel *headerFirstLabel;
    IBOutlet UILabel *headerSecondLabel;
    IBOutlet UILabel *headerThirdLabel;
    
    //chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    
    UIView *contentView;
    NSMutableArray *goalValueArray;
    IBOutlet UIView *headerContainerView;
    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end

@implementation AchieveHomeViewController
@synthesize fromTodayPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    // Do any additional setup after loading the view.
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
//    blankView.hidden = false;
    goalValueArray = [[NSMutableArray alloc] init];
//    [self getGoalValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//chayan
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
}
-(void) viewDidAppear:(BOOL)animated {  //ah ux
    [super viewDidAppear:YES];
    
//    if(!_redirectBackToTodayPage){
//        if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAchieve"] boolValue]) {
//            [self animateHelp];
//        }
//        
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"Achieve"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"Achieve"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"Achieve"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}

#pragma mark - API Call
-(void) getGoalValue {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalValueListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                           
                                                                           self->goalValueArray = [responseDictionary objectForKey:@"Details"];
                                                                           
                                                                           for (int i = 0; i < self->goalValueArray.count; i++) {
                                                                               switch (i) {
                                                                                   case 0:
                                                                                       self->headerFirstLabel.text = [[[self->goalValueArray objectAtIndex:i] objectForKey:@"value"] uppercaseString];
                                                                                       break;
                                                                                       
                                                                                   case 1:
                                                                                       self->headerSecondLabel.text = [[[self->goalValueArray objectAtIndex:i] objectForKey:@"value"] uppercaseString];
                                                                                       break;
                                                                                       
                                                                                   case 2:
                                                                                       self->headerThirdLabel.text = [[[self->goalValueArray objectAtIndex:i] objectForKey:@"value"] uppercaseString];
                                                                                       break;
                                                                                       
                                                                                   default:
                                                                                       break;
                                                                               }
                                                                           }
                                                                       }else{
//                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
#pragma mark - IBAction

- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)calenderTapped:(id)sender {
    
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)headerHelpTapped:(id)sender {
    
}
-(IBAction)personalChallengesButtonTapped:(id)sender{
    PersonalChallengeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalChallenge"];
//        [Utility msg:@"Coming in July 2018" title:@"Alert" controller:self haveToPop:NO];
//        ChalengesHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChalengesHome"];
    [self.navigationController pushViewController:controller animated:NO];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)visionGoalsActionsButtonTapped:(id)sender {
    VisionGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisionGoalAction"];
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)visionBoardButtonTapped:(id)sender {
//    return;
   /***Prev**Ru**
    VisionHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisionHome"];
    [self.navigationController pushViewController:controller animated:NO];
    */
    //**Updated**Ru**
    AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionBoard"];
    [self.navigationController pushViewController:controller animated:NO];
    
}
- (IBAction)bucketListTapped:(id)sender {
    BucketListNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNew"];
    controller.goalValueArray = goalValueArray;
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)checkListTapped:(id)sender {
    
}
- (IBAction)actionHistoryTapped:(id)sender {
    
}
- (IBAction)goalHistoryTapped:(id)sender {
    
}
-(IBAction)setAGoalTapped:(id)sender{
    VisionGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisionGoalAction"];
    controller.isFromSetGoal = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)createAnAction:(id)sender{
    VisionGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VisionGoalAction"];
    controller.isFromCreateAction = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)accountabilityBuddiesTapped:(id)sender {    //ah 5.9 (storyboard)
    //HealthyHabitBuilderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthyHabitBuilder"];
    AccountabilityBuddyHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountabilityBuddyHomeView"];
    [self.navigationController pushViewController:controller animated:NO];
    
    
}
//chayan : questionHelpButtonPressed
- (IBAction)helpButtonPressed:(id)sender {
    NSString *urlString=@"https://player.vimeo.com/external/220937662.m3u8?s=38a17694e14093b93c516efe24d9c6592677ba25";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAchieve"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeAchieve"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
        
        
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}


#pragma mark - Private Method

//chayan
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        self->helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            self->helpButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateHelp];
        }];
    }];
}
- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" :  @"Click here for tools and tips to get the most out of the ACHIEVE section.",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      ] mutableCopy];
    
    int multiplierX = 1;
    for (int i = 0; i < overlayViews.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:overlayViews[i]];
        if ([[dict objectForKey:@"isCustomFrame"] boolValue]) {
            CGRect newFrame = headerContainerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            newFrame.origin.x = (screenWidth/2.0)*multiplierX;//(screenWidth/5.0) +
            NSLog(@"%f",newFrame.origin.x);
            newFrame.size.width = (screenWidth/2.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierX++;
        }
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}
//- (void) showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the ACHIEVE section."
//                              ];
//    for (int i = 0;i<actionButtons.count;i++) {
//        UIButton *button =actionButtons[i];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//        [dict setObject:button forKey:@"view"];
//        [dict setObject:@NO forKey:@"onTop"];
//        [dict setObject:messageArray[i] forKey:@"insText"];
//        [dict setObject:@YES forKey:@"isCustomFrame"];
//        NSLog(@"%@",NSStringFromCGRect([self.view convertRect:button.frame fromView:button.superview]));
//        CGRect tempRect=[self.view convertRect:button.frame fromView:button.superview];
//        //        tempRect.cen
//        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-tempRect.size.height/2, tempRect.size.width, tempRect.size.height);
//        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
//        [overlayViews addObject:dict];
//    }
//    [Utility initializeInstructionAt:self OnViews:overlayViews];
//}

#pragma mark - End



@end
