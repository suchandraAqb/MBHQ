//
//  TrackAllViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 14/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "TrackAllViewController.h"
#import "WaterTrackerViewController.h"

static NSString *before = @"BEFORE";
static NSString *after = @"AFTER";

@interface TrackAllViewController (){
    
    __weak IBOutlet UILabel *noDataLabel;
    __weak IBOutlet UIScrollView *mainScroll;
    
    __weak IBOutlet UILabel *stepLabel;
    __weak IBOutlet UILabel *weeklyStepAvgLabel;//cal
    __weak IBOutlet UILabel *distanceLabel;
    __weak IBOutlet UILabel *waterLabel;
    
    __weak IBOutlet UIView *firstImageView;
    __weak IBOutlet UIImageView *firstImage;
    __weak IBOutlet UILabel *firstImageLabel;
    __weak IBOutlet UIView *secondImageView;
    __weak IBOutlet UIImageView *secondImage;
    __weak IBOutlet UILabel *secondImageLabel;
    __weak IBOutlet UIButton *addPhotoButton;
    
    __weak IBOutlet UILabel *weightLabel;
    __weak IBOutlet UILabel *bfLabel;
    __weak IBOutlet UILabel *muscleLabel;
    __weak IBOutlet UILabel *cmsLabel;
    
    __weak IBOutlet UILabel *currentQuestionnaireLabel;
    __weak IBOutlet UIButton *startQuestionnaireButton;
    
    __weak IBOutlet UIStackView *dailyVitaminStack;
    __weak IBOutlet UIButton *addVitaminButton;
    
    NSDictionary *todaysDataDict;
    NSDate *currentDate;
    UIView *contentView;
    NSDateFormatter *formatter;
    
    NSDictionary *currprogram;
    int stepnumber;
    int apiCount;
    BOOL isLoadController;
    
    IBOutletCollection(UIImageView) NSArray *circularImageView;
    IBOutletCollection(UIButton) NSArray *vitaminButton;
    IBOutlet UIButton *guideImageView;
    IBOutlet UIStackView *vitaminPartNextStackView;
    IBOutlet UIStackView *vitaminLastPartStackView;
    
}

@end

@implementation TrackAllViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCount = 0;
    formatter = [NSDateFormatter new];
    todaysDataDict = [NSMutableDictionary new];
    mainScroll.hidden = true;
    noDataLabel.hidden = true;
    isLoadController = true;
    for (UIImageView *myView in circularImageView) {
        myView.layer.cornerRadius = myView.frame.size.height / 2;
        myView.layer.masksToBounds = YES;
    }
    
    
    for(UIButton *btn in vitaminButton){
        
        [btn setImage:nil forState:UIControlStateNormal];
    }
    
    guideImageView.clipsToBounds = YES;
    guideImageView.layer.cornerRadius = guideImageView.frame.size.height / 2;
    guideImageView.layer.borderWidth = 1.0;
    guideImageView.layer.borderColor = [Utility colorWithHexString:@"90D1D8"].CGColor;
    
    startQuestionnaireButton.layer.cornerRadius = 5.0;
    startQuestionnaireButton.layer.masksToBounds = YES;
    addVitaminButton.layer.cornerRadius = 5.0;
    addVitaminButton.layer.masksToBounds = YES;
    
    currentDate = [NSDate date];
    
    NSDate* sourceDate = currentDate;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+10"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    NSDate *today = destinationDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    
    if([Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
        dispatch_async(dispatch_get_main_queue(),^{
            [self webSerViceCall_GetSquadCurrentProgram];
        });
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     [Utility startFlashingbutton:guideImageView];
    //    isLoadController = false;
    [mainScroll addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [self getAppHomePageValues:currentDate];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Utility stopFlashingbutton:guideImageView];
    [mainScroll addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    CGFloat yOffset = mainScroll.contentOffset.y;
    CGFloat totalHeight = mainScroll.contentSize.height;
    if (totalHeight - yOffset - mainScroll.frame.size.height > 0) {
        guideImageView.hidden = false;
    }else{
        guideImageView.hidden = true;
    }
}
#pragma mark -IBAction

- (IBAction)stepsAndWaterButtonPressed:(UIButton *)sender {
    if (sender.tag == 0 || sender.tag == 2) {
        //steps and distance
       
    } else if (sender.tag == 1) {
        //intake cal
        if([Utility isSquadFreeUser]){
            [self customPopUp];
            return;
        }
        [self checkNutritionStep:4];
    } else if (sender.tag == 3) {//TODO:water tracker
        //water
        if([Utility isSquadFreeUser]){
            [self customPopUp];
            return;
        }
        WaterTrackerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WaterTrackerView"];
        controller.isFromTodayOrMealMatch = true;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)addPhotoPressed:(UIButton *)sender {
    if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    //    MyPhotosDefaultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPhotosDefault"];
    //    [self.navigationController pushViewController:controller animated:YES];
    AddImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddImageView"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    //    controller.addPhotoDelegate = self;
    //    controller.existingPhotosArray = photoArray;
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
    controller.addPhotoDelegate = self;
    controller.bodyCatagorystring=bodyCatagoryString;
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)didPhotoAdded:(BOOL)isAdded{
    if (isAdded) {
        [self getAppHomePageValues:currentDate];
    }
}
- (IBAction)photoPressed:(UIButton *)sender {
    if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    MyPhotosDefaultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPhotosDefault"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)measurementPressed:(UIButton *)sender {
    if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    LatestResultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LatestResultView"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)walkRunPressed:(UIButton *)sender {
    [CustomNavigation startNavigation:self fromMenu:NO navDict:@{@"Identifier":@"TrackMiddle"}];
//    LatestResultViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LatestResultView"];
//    [self.navigationController pushViewController:controller animated:YES];
}
-(void)customPopUp{//need to change it
    [Utility showAlertAfterSevenDayTrail:self];
}

- (IBAction)startQuestionnaireButtonPressed:(UIButton *)sender {
    
    
    if([Utility isSquadFreeUser]){
        if(![Utility isEmptyCheck:todaysDataDict[@"RecentQuestionnnaire"]]){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
    }
    
    
    QuestionnaireHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionnaireHomeView"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)addVitaminButtonPressed:(UIButton *)sender {
    
    if([Utility isSquadFreeUser]){
        [self customPopUp];
        return;
    }
    VitaminViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"VitaminView"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)goToBottomPressed:(UIButton *)sender{
    CGFloat yOffset = mainScroll.contentOffset.y;
    CGFloat totalHeight = mainScroll.contentSize.height;
    CGFloat targetOffset = totalHeight - yOffset - mainScroll.frame.size.height;
    targetOffset += yOffset;
    [self->mainScroll setContentOffset:CGPointMake(0, targetOffset) animated:YES];
    if (totalHeight - targetOffset - mainScroll.frame.size.height > 0) {
        guideImageView.hidden = false;
    }else{
        guideImageView.hidden = true;
    }
}

#pragma mark -End
#pragma mark -Private Method
-(void)checkNutritionStep:(int)tag{
    //        if (stepnumber == 0 || stepnumber == 6) {
    //            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
    //            controller.isComplete =false;
    //            [self.navigationController pushViewController:controller animated:YES];
    
    if ((stepnumber == -1 || stepnumber == 1) && [Utility isEmptyCheck:currprogram] )   {//add1
        ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
        controller.isNutritionSettings=true;
        [self.navigationController pushViewController:controller animated:YES];
    }else if((stepnumber == -1 && ![Utility isEmptyCheck:currprogram])){//add1
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 1 || stepnumber == 2) {
        DietaryPreferenceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DietaryPreferenceView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (stepnumber == 3) {
        MealFrequencyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealFrequencyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 4){
        MealVarietyViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealVarietyView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (stepnumber == 5){
        MealPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealPlanView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (tag == 1) {
            CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
            controller.isComplete =false;
            controller.stepnumber = stepnumber;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 2){
            MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
            controller.fromToday = true;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 3){
            SetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetProgramView"];
            [self.navigationController pushViewController:controller animated:YES];
        }else if(tag == 4){
            MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        
        
    }
}
-(void)checkExerciseStep:(int)step{
    switch (step) {
            
        case -1:
            //api call
            [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep" tag:-1];
            break;
            //
            //        case 0:
            //        {
            //            //current week
            //            //current week
            //            //if([[self.navigationController.viewControllers firstObject] isKindOfClass:[TrailHomeViewController class]]){
            //            //                                                                                  if([defaults boolForKey:@"IsNonSubscribedUser"]){
            //            //                                                                                      [self.navigationController popToRootViewControllerAnimated:YES];
            //            //                                                                                  }else{
            //            //
            //            //                                                                                  }
            //            ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
            //            [self.navigationController pushViewController:controller animated:YES];
            //            break;
            //        }
            
        case 1:
        {
            CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 2:
        {
            ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 3:
        {
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = true;
            controller.isWeeklySession = false;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 4:
        {
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = false;
            controller.isWeeklySession = false;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 5:
        {
            RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
            controller.isRateFitness = false;
            controller.isWeeklySession = true;
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 6:
        {
            PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        case 7:
        {
            MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        default:
            break;
    }
}
-(void)getAppHomePageValues:(NSDate *)currentDate{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"SquadUserId"];
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [mainDict setObject:[formatter stringFromDate:currentDate] forKey:@"DateFor"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetAppHomePageValues" append:@""forAction:@"POST"];
        NSURLSessionDataTask *dataTask =[loginSession dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                self->apiCount--;
                                                                if (self->contentView && self->apiCount==0) {
                                                                    [self->contentView removeFromSuperview];
                                                                }
                                                                if(error == nil)
                                                                {
                                                                    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                    NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                        [self updateView:responseDict];
                                                                    }
                                                                    else{
                                                                        [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)updateView:(NSDictionary *)responseDict{
    
    todaysDataDict = [responseDict objectForKey:@"model"];
    if (![Utility isEmptyCheck:todaysDataDict]) {
        mainScroll.hidden = false;
        noDataLabel.hidden = true;
    } else {
        mainScroll.hidden = true;
        noDataLabel.hidden = false;
        return;
    }
    
    stepnumber = [[todaysDataDict objectForKey:@"NourishSettingsStep"]intValue];
//    if([Utility isSubscribedUser]){//redirect only for subscribed user
//        if (stepnumber != 0) {
//            [self checkNutritionStep:-1];
//            return;
//        }
//        int exerciseStep = [[todaysDataDict objectForKey:@"ExerciseSettingsStep"]intValue];
//        if (exerciseStep != 0) {
//            [self checkExerciseStep:exerciseStep];
//            return;
//        }
//    }
    
    //steps avgStep and water
    float steps = 0;
    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"Steps"]]) {
        steps = [[todaysDataDict objectForKey:@"Steps"] floatValue];
    }
    stepLabel.text = [NSString stringWithFormat:@"%@",[Utility customRoundNumber:steps]];
    
    float averageSteps = 0.0;
    //    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"AverageSteps"]]) {
    //        averageSteps = [[todaysDataDict objectForKey:@"AverageSteps"] floatValue];
    //    }
    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"IntakeTotal"]]) {
        averageSteps = [[todaysDataDict objectForKey:@"IntakeTotal"] floatValue];
    }//TotalCalorie
    weeklyStepAvgLabel.text = [NSString stringWithFormat:@"%@ Cal",[Utility customRoundNumber:averageSteps]];
    
    double water = 0;
    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"UserWaterIntakeDataModel"]]) {
        NSDictionary *waterDict = [todaysDataDict objectForKey:@"UserWaterIntakeDataModel"];
        water = ![Utility isEmptyCheck:[waterDict objectForKey:@"amount"]]?[[waterDict objectForKey:@"amount"] doubleValue]:0;
        water /= 1000.0;
    }
    waterLabel.text = [NSString stringWithFormat:@"%@ L",[Utility customRoundNumber:water]];
    
    double distance = 0;
    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"TotalDistance"]]) {
        distance = ![Utility isEmptyCheck:[todaysDataDict objectForKey:@"TotalDistance"]]?[[todaysDataDict objectForKey:@"TotalDistance"] doubleValue]:0;
//        water /= 1000.0;
    }
    distanceLabel.text = [NSString stringWithFormat:@"%@ km",[Utility customRoundNumber:distance]];
    
    //My PROGRESS
    firstImageView.hidden = true;
    secondImageView.hidden = true;
    addPhotoButton.hidden = false;
    if(![Utility isEmptyCheck:[todaysDataDict objectForKey:@"UserBodyPhotosModel"]]){
        NSArray *photoArray = [todaysDataDict objectForKey:@"UserBodyPhotosModel"];
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"DateTaken"
                                            ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        NSArray *sortedArray = [photoArray
                                sortedArrayUsingDescriptors:sortDescriptors];
        
        if (![Utility isEmptyCheck:sortedArray]) {
            if (sortedArray.count>1) {// > 1
                [self photoSelection:sortedArray];
            }else{// == 1
                firstImageView.hidden = false;
                NSDictionary *dict = [sortedArray objectAtIndex:0];
                [firstImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                /*NSDate *date = [formatter dateFromString:dict[@"DateTaken"]];
                [formatter setDateFormat:@"dd MMM yyyy"];
                firstImageLabel.text = [formatter stringFromDate:date];*/
                firstImageLabel.text = before;
            }
        }
    }
    
    int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
    NSString *weight, *measurements;
    if (unitPrefererence ==0 || unitPrefererence ==1) {
        weight = @"kg";
        measurements = @"cm";
    }else{
        weight = @"lb";
        measurements = @"inches";
    }
    
    if(![Utility isEmptyCheck:[todaysDataDict objectForKey:@"bodyWeight"]]){
        weightLabel.text = [NSString stringWithFormat:@"%@ %@",[Utility customRoundNumber:[[self getMass:[todaysDataDict objectForKey:@"bodyWeight"]]floatValue]],weight];
    }else{
        weightLabel.text = @"N/A";
    }
    
    if(![Utility isEmptyCheck:[todaysDataDict objectForKey:@"bodyFat"]]){
        bfLabel.text = [NSString stringWithFormat:@"%@%%",[Utility customRoundNumber:[[todaysDataDict objectForKey:@"bodyFat"]floatValue]]];
    }else{
        bfLabel.text = @"N/A";
    }
    
    if(![Utility isEmptyCheck:[todaysDataDict objectForKey:@"Muscle"]]){
        muscleLabel.text = [NSString stringWithFormat:@"%@ %@",[Utility customRoundNumber:[[self getMass:[todaysDataDict objectForKey:@"Muscle"]]floatValue]],weight];
    }else{
        muscleLabel.text = @"N/A";
    }
    
    if(![Utility isEmptyCheck:[todaysDataDict objectForKey:@"CMS"]]){
        cmsLabel.text = [NSString stringWithFormat:@"%@ %@",[Utility customRoundNumber:[[self getLength:[todaysDataDict objectForKey:@"CMS"]]floatValue]],measurements];
    }else{
        cmsLabel.text = @"N/A";
    }
    
    
    if(![Utility isEmptyCheck:todaysDataDict[@"RecentQuestionnnaire"]]){
        
        NSDictionary *dict = todaysDataDict[@"RecentQuestionnnaire"];
        
        int typeId = [dict[@"QuestionnaireTypeId"] intValue];
        if(typeId == HAPPINESS){
            if(![Utility isEmptyCheck:dict[@"Total"]]){
                
                double totalMaxPoints = 120.0;
                double totalPoint  = [dict[@"Total"] doubleValue];
                
                currentQuestionnaireLabel.text = [@"" stringByAppendingFormat:@"HAPPINESS: %.2f%%",(totalPoint/totalMaxPoints)*100];
            }
            
            
        }else{
            NSString *type = @"";
            
            if(typeId == COHENSTRESS){
                type = @"COHEN";
            }else if(typeId == RAHEPERCEIVED){
                type = @"RAHE";
            }
            
            
            
            if(![Utility isEmptyCheck:dict[@"Total"]]){
                int total = [dict[@"Total"] intValue];
                currentQuestionnaireLabel.text = [@"" stringByAppendingFormat:@"%@: %d",type,total];
            }
        }
        
        startQuestionnaireButton.hidden = true;
    }else{
        startQuestionnaireButton.hidden = false;
    }
    
    NSMutableArray *vitaminShowArr = [[NSMutableArray alloc]init];
    if (![Utility isEmptyCheck:[todaysDataDict objectForKey:@"VitaminData"]]) {
        addVitaminButton.hidden = true;
        NSArray *arr = [todaysDataDict objectForKey:@"VitaminData"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(VitaminTaskList[0].DoneCount = 0)"];
        NSArray *filteredArray = [arr filteredArrayUsingPredicate:predicate];
        NSLog(@"========%@",filteredArray);
        if (![Utility isEmptyCheck:filteredArray] && filteredArray.count>0) {
            if (filteredArray.count<=9) {
                for (int i =0 ; i<filteredArray.count; i++) {
                    [vitaminShowArr addObject:filteredArray[i]];
                }
            }else{
                for (int i =0 ; i<9; i++) {
                    [vitaminShowArr addObject:filteredArray[i]];
                }
            }
            if (vitaminShowArr.count<9) {
                int count=0;
                if (arr.count<9) {
                    count = (int)arr.count-(int)vitaminShowArr.count;
                }else{
                    count = 9-(int)vitaminShowArr.count;
                }
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(VitaminTaskList[0].DoneCount > 0)"];
                NSArray *filteredOtherArray = [arr filteredArrayUsingPredicate:predicate];
                if (filteredArray.count>0) {
                    for (int j=0; j<count; j++) {
                        [vitaminShowArr addObject:filteredOtherArray[j]];
                    }
                }
            }
        }else{
            int count=0;
            if (arr.count<9) {
                count = (int)arr.count;
            }else{
                count = 9;
            }
            for (int k =0 ; k<count; k++) {
                [vitaminShowArr addObject:arr[k]];
            }
        }
        
        if (vitaminShowArr.count<=3) {
            dailyVitaminStack.hidden = false;
            vitaminPartNextStackView.hidden= true;
            vitaminLastPartStackView.hidden = true;
        }else if(vitaminShowArr.count>3 && vitaminShowArr.count<=6){
            dailyVitaminStack.hidden = false;
            vitaminPartNextStackView.hidden = false;
            vitaminLastPartStackView.hidden = true;
        }else{
            dailyVitaminStack.hidden = false;
            vitaminPartNextStackView.hidden = false;
            vitaminLastPartStackView.hidden = false;
        }
        for (int i =0; i<vitaminShowArr.count; i++) {
            
            UIButton *btn = [vitaminButton objectAtIndex:i];
            [btn setImage:[UIImage imageNamed:@"Vitamin_darkcircle_black.png"] forState:UIControlStateNormal];
            
            
            NSDictionary *individualVitaminDetailsDict = [arr objectAtIndex:i];
            NSArray *vitaminTaskListArr = [individualVitaminDetailsDict objectForKey:@"VitaminTaskList"];
            if (![Utility isEmptyCheck:individualVitaminDetailsDict]) {
                if (![Utility isEmptyCheck:[vitaminTaskListArr objectAtIndex:0]]) {
                    NSDictionary *taskListDict = [vitaminTaskListArr objectAtIndex:0];
                    if ([[taskListDict objectForKey:@"DoneCount"]intValue]==0){
                        [btn setImage:[UIImage imageNamed:@"Vitamin_darkcircle_black.png"] forState:UIControlStateNormal];
                    }else if ([[taskListDict objectForKey:@"PendingCount"]intValue]==0){
                        [btn setImage:[UIImage imageNamed:@"tick_black.png"] forState:UIControlStateNormal];
                    }else{
                        if ([[taskListDict objectForKey:@"TotalCount"]intValue]==2) {
                            int totalComplete = [self getPercerntageOfDone:[[taskListDict objectForKey:@"DoneCount"]intValue] total:[[taskListDict objectForKey:@"TotalCount"]intValue]];
                            
                            if (totalComplete>=10 && totalComplete<100) {
                                [btn setImage:[UIImage imageNamed:@"half_circle_black.png"] forState:UIControlStateNormal];
                            }
                        }else{
                            int totalComplete = [self getPercerntageOfDone:[[taskListDict objectForKey:@"DoneCount"]intValue] total:[[taskListDict objectForKey:@"TotalCount"]intValue]];
                            if (totalComplete>=10 && totalComplete<=50) {
                                [btn setImage:[UIImage imageNamed:@"1of3rd_black.png"] forState:UIControlStateNormal];
                            }else if ((totalComplete>=50 && totalComplete<100)){
                                [btn setImage:[UIImage imageNamed:@"2of3rd_black.png"] forState:UIControlStateNormal];
                            }
                        }
                    }
                }
            }
            
            btn.hidden = false;
            
        }
    }else{
        addVitaminButton.hidden = false;
        dailyVitaminStack.hidden = true;
        vitaminPartNextStackView.hidden = true;
        vitaminLastPartStackView.hidden = true;
    }
}

-(int)getPercerntageOfDone:(int)doneCount total:(int)totalCount{
    if (doneCount == 0 && totalCount == 0) {
        return 0;
    }else{
        return (100 * doneCount)/totalCount;
    }
}

-(NSString *)getMass:(NSString *)myDistance{//kg to lb
    NSString *calcDistance = @"";
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
        float convDistance = [myDistance floatValue];
        convDistance *= 2.20462;
        calcDistance = [NSString stringWithFormat:@"%.02f",convDistance];
    } else {//metric
        calcDistance = myDistance;
    }
    return calcDistance;
}

-(NSString *)getLength:(NSString *)myDistance{//cm to inches
    NSString *calcDistance = @"";
    if (![Utility isEmptyCheck:[defaults objectForKey:@"UnitPreference"]] && [[defaults objectForKey:@"UnitPreference"]intValue] == 2) {//imperial
        float convDistance = [myDistance floatValue];
        convDistance *= 0.393701;
        calcDistance = [NSString stringWithFormat:@"%.02f",convDistance];
        
    } else {//metric
        calcDistance = myDistance;
    }
    return calcDistance;
}
- (void) photoSelection:(NSArray *)photosArray{
    NSInteger leftSelectedIndex = 0;
    NSInteger rightSelectedIndex = 1;
    
    firstImageView.hidden = false;
    secondImageView.hidden = false;
    addPhotoButton.hidden = true;
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"leftSelectedPic"]] && [defaults integerForKey:@"leftSelectedPic"] > 0) {
        leftSelectedIndex = [defaults integerForKey:@"leftSelectedPic"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserBodyPhotoID == %ld)",(long)leftSelectedIndex];
        NSArray *filteredSessionCategoryArray = [photosArray filteredArrayUsingPredicate:predicate];
        if (filteredSessionCategoryArray.count > 0) {
            NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
            [firstImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
           /* NSDate *date = [formatter dateFromString:dict[@"DateTaken"]];
            [formatter setDateFormat:@"dd MMM yyyy"];
            firstImageLabel.text = [formatter stringFromDate:date];*/
            firstImageLabel.text = before;
        } else {
            [firstImage sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:0] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            /*NSDate *date = [formatter dateFromString:[[photosArray objectAtIndex:0] objectForKey:@"DateTaken"]];
            [formatter setDateFormat:@"dd MMM yyyy"];
            firstImageLabel.text = [formatter stringFromDate:date];*/
            firstImageLabel.text = before;
        }
    } else {//secondImage//secondImageLabel
        [secondImage sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:leftSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        /*NSDate *date = [formatter dateFromString:[[photosArray objectAtIndex:leftSelectedIndex] objectForKey:@"DateTaken"]];
        [formatter setDateFormat:@"dd MMM yyyy"];
        secondImageLabel.text = [formatter stringFromDate:date];*/
        secondImageLabel.text = after;
    }
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"rightSelectedPic"]] && [defaults integerForKey:@"rightSelectedPic"] > 0) {
        rightSelectedIndex = [defaults integerForKey:@"rightSelectedPic"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(UserBodyPhotoID == %ld)",(long)rightSelectedIndex];
        NSArray *filteredSessionCategoryArray = [photosArray filteredArrayUsingPredicate:predicate];
        if (filteredSessionCategoryArray.count > 0) {
            NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
            [secondImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            //            NSDateFormatter *formatter = [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            /*NSDate *date = [formatter dateFromString:dict[@"DateTaken"]];
            [formatter setDateFormat:@"dd MMM yyyy"];
            secondImageLabel.text = [formatter stringFromDate:date];*/
            secondImageLabel.text = after;
        } else {
            [secondImage sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:1] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            /*NSDate *date = [formatter dateFromString:[[photosArray objectAtIndex:1] objectForKey:@"DateTaken"]];
            [formatter setDateFormat:@"dd MMM yyyy"];
            secondImageLabel.text = [formatter stringFromDate:date];*/
            secondImageLabel.text = after;
        }
    } else {//firstImage//firstImageLabel
        [firstImage sd_setImageWithURL:[NSURL URLWithString:[[photosArray objectAtIndex:rightSelectedIndex] objectForKey:@"Photo"]] placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        /*NSDate *date = [formatter dateFromString:[[photosArray objectAtIndex:rightSelectedIndex] objectForKey:@"DateTaken"]];
        [formatter setDateFormat:@"dd MMM yyyy"];
        firstImageLabel.text = [formatter stringFromDate:date];*/
        firstImageLabel.text = before;
    }
    
}
#pragma mark -End
#pragma mark -Nutrition Step
-(void)webSerViceCall_GetSquadCurrentProgram{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self->apiCount++;
            //            if (self->contentView) {
            //                [self->contentView removeFromSuperview];
            //            }
            //            self->contentView = [Utility activityIndicatorView:self];
            //            self->loadingView.hidden = false;
            //            [self.view bringSubviewToFront:self->loadingView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCurrentProgram" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 self->apiCount--;
                                                                 //                                                                 if (self->contentView && self->apiCount == 0) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 //                                                                 if (self->apiCount == 0) {
                                                                 //                                                                     self->loadingView.hidden = true;
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->currprogram=[responseDict objectForKey:@"SquadProgram"];
                                                                         
                                                                     }
                                                                     else{
                                                                         //                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                                 
                                                                 [self webSerViceCall_SquadNutritionSettingStep];
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

-(void)webSerViceCall_SquadNutritionSettingStep{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //            self->apiCount++;
            //            if (self->contentView) {
            //                [self->contentView removeFromSuperview];
            //            }
            //            self->contentView = [Utility activityIndicatorView:self];
            //            self->loadingView.hidden = false;
            //            [self.view bringSubviewToFront:self->loadingView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadNutritionSettingStep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 self->apiCount--;
                                                                 //                                                                 if (self->contentView && self->apiCount == 0) {
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 //                                                                 if (self->apiCount == 0) {
                                                                 //                                                                     self->loadingView.hidden = true;
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         self->stepnumber=[[responseDict objectForKey:@"StepNumber"]intValue];
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
#pragma mark -Program Step
-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName tag:(int)tag{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          
                                                                          [defaults setInteger:[[responseDict objectForKey:@"StepNumber"] intValue] forKey:@"CustomExerciseStepNumber"];
                                                                          
                                                                          switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                  
                                                                              case -1:
                                                                                  //api call
                                                                                  [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep" tag:tag];
                                                                                  break;
                                                                                  
                                                                              case 0:
                                                                              {
                                                                                  //                                                                                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                  //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  //                                                                                  break;
                                                                                  
                                                                                  [self checkNutritionStep:tag];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 1:
                                                                              {
                                                                                  CustomProgramSetupViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomProgramSetup"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 2:
                                                                              {
                                                                                  ChooseGoalViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChooseGoal"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 3:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = true;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 4:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = false;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 5:
                                                                              {
                                                                                  RateFitnessLevelViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RateFitnessLevel"];
                                                                                  controller.isRateFitness = false;
                                                                                  controller.isWeeklySession = true;
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 6:
                                                                              {
                                                                                  PersonalSessionsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonalSessions"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              case 7:
                                                                              {
                                                                                  MovePersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MovePersonalSession"];
                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                  break;
                                                                              }
                                                                                  
                                                                              default:
                                                                                  break;
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
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
   if(object == mainScroll){
        CGFloat yOffset = mainScroll.contentOffset.y;
        CGFloat totalHeight = mainScroll.contentSize.height;
        if (totalHeight - yOffset - mainScroll.frame.size.height > 0) {
            guideImageView.hidden = false;
        }else{
            guideImageView.hidden = true;
        }
    }
}
#pragma mark - End
#pragma mark - ScrollView delegate -
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat yOffset = targetContentOffset->y;
    CGFloat totalHeight = mainScroll.contentSize.height;
    if (totalHeight - yOffset - mainScroll.frame.size.height > 0) {
        guideImageView.hidden = false;
    }else{
        guideImageView.hidden = true;
    }
}
#pragma mark - End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
