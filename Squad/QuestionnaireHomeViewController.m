//
//  QuestionnaireHomeViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 24/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "QuestionnaireHomeViewController.h"
#import "QuestionAttemptListViewController.h"


@interface QuestionnaireHomeViewController (){
    
    __weak IBOutlet UIButton *CSScaleCompletedButton;
    __weak IBOutlet UIButton *CSScaleStartButton;
    
    __weak IBOutlet UIButton *RPStressCompletedButton;
    __weak IBOutlet UIButton *RPStressStartButton;
    
    __weak IBOutlet UIButton *HQCompletedButton;
    __weak IBOutlet UIButton *HQStartButton;
    
    
    IBOutlet UIButton *stressFirstTestRatingButton;
    IBOutlet UILabel *stressFirstTestRatingDateLabel;
    
    IBOutlet UIButton *stressSecondTestRatingButton;
    IBOutlet UILabel *stressSecondTestRatingDateLabel;
    
    IBOutlet UIButton *happinessFirstTestRatingButton;
    IBOutlet UILabel *happinessFirstTestRatingDateLabel;
    
    IBOutlet UIButton *happinessSecondTestRatingButton;
    IBOutlet UILabel *happinessSecondTestRatingDateLabel;
    
    IBOutlet UIView *happinessBigPlayView;
    IBOutlet UIView *stressBigPlayView;
    
    IBOutlet UIView *happinessBeforeAfterView;
    IBOutlet UIView *stressBeforeAfterView;
    
    IBOutlet UIButton *happinessBigStart;
    IBOutlet UIButton *stressBigStart;
    
    IBOutlet UIStackView *happinessBeforeStackView;
    IBOutlet UIStackView *happinessAfterStackView;
    
    IBOutlet UIStackView *stressBeforeStackView;
    IBOutlet UIStackView *stressAfterStackView;
    
    IBOutlet UIView *walkThroughView;
    IBOutlet UIButton *walkThroughOkButton;
    
    
    UIView *contentView;
    int apiCount;
    NSArray *mixedDataArray;
    
}

@end

@implementation QuestionnaireHomeViewController

#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CSScaleStartButton.tag = -1;
    RPStressStartButton.tag = -1;
    HQStartButton.tag = -1;
    stressBigStart.tag= -1;
    happinessBigStart.tag = -1;
    stressSecondTestRatingButton.tag = -1;
    happinessSecondTestRatingButton.tag = -1;
    stressFirstTestRatingButton.layer.borderColor=squadMainColor.CGColor;
//    stressFirstTestRatingButton.layer.borderColor=[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;

    [stressFirstTestRatingButton setBackgroundColor:squadMainColor];
    stressFirstTestRatingButton.clipsToBounds=YES;
    stressFirstTestRatingButton.layer.borderWidth=2;
    stressFirstTestRatingButton.layer.cornerRadius=stressFirstTestRatingButton.frame.size.height/2;
    
    stressSecondTestRatingButton.layer.borderColor=squadMainColor.CGColor;
    [stressSecondTestRatingButton setBackgroundColor:squadMainColor];
    stressSecondTestRatingButton.clipsToBounds=YES;
    stressSecondTestRatingButton.layer.borderWidth=2;
    stressSecondTestRatingButton.layer.cornerRadius=stressFirstTestRatingButton.frame.size.height/2;
    
    happinessFirstTestRatingButton.layer.borderColor=squadMainColor.CGColor;
    [happinessFirstTestRatingButton setBackgroundColor:squadMainColor];
    happinessFirstTestRatingButton.clipsToBounds=YES;
    happinessFirstTestRatingButton.layer.borderWidth=2;
    happinessFirstTestRatingButton.layer.cornerRadius=stressFirstTestRatingButton.frame.size.height/2;
    
    happinessSecondTestRatingButton.layer.borderColor=squadMainColor.CGColor;
    [happinessSecondTestRatingButton setBackgroundColor:squadMainColor];
    happinessSecondTestRatingButton.clipsToBounds=YES;
    happinessSecondTestRatingButton.layer.borderWidth=2;
    happinessSecondTestRatingButton.layer.cornerRadius=stressFirstTestRatingButton.frame.size.height/2;
   
    walkThroughOkButton.layer.cornerRadius=15;
    walkThroughOkButton.layer.masksToBounds=true;
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeTest"]] || ![defaults boolForKey:@"isFirstTimeTest"]) {
        [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeTest"];
        walkThroughView.hidden=false;
    }else{
        walkThroughView.hidden=true;
    }
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getQuestionnaireAttemptStatus_Webservicecall];
}
#pragma mark-End

#pragma mark-IBAction

- (IBAction)walkThroughCrossButtonPressed:(UIButton *)sender {
    walkThroughView.hidden=true;
}


- (IBAction)happinessFirstTestRatingButtonPressed:(UIButton *)sender {
    [self completedButtonPressed:sender];
}

- (IBAction)happinessSecondTestRatingButtonPressed:(UIButton *)sender {
//    if(sender.tag>=0 && ![Utility isEmptyCheck:mixedDataArray]){
//        [self startButtonPressed:sender];
//    }
    [self completedButtonPressed:sender];
}

- (IBAction)stressFirstTestRatingButtonPressed:(UIButton *)sender {
    [self completedButtonPressed:sender];
}

- (IBAction)stressSecondTestRatingButtonPressed:(UIButton *)sender {
//    if(sender.tag>=0 && ![Utility isEmptyCheck:mixedDataArray]){
//    [self startButtonPressed:sender];
//    }
    [self completedButtonPressed:sender];
}



- (IBAction)completedButtonPressed:(UIButton *)sender {
    
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        if(mixedDataArray.count>0){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
    }
    
    QuestionType typeId = 0;
    
    if(sender == CSScaleCompletedButton || sender == stressFirstTestRatingButton || sender == stressSecondTestRatingButton){
        typeId = COHENSTRESS;
    }else if(sender == RPStressCompletedButton){
        typeId = RAHEPERCEIVED;
        
    }else if(sender == HQCompletedButton || sender ==happinessFirstTestRatingButton || sender ==happinessSecondTestRatingButton){
        typeId = HAPPINESS;
    }
    
    QuestionAttemptListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuestionAttemptListView"];
    controller.typeId = typeId;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)startButtonPressed:(UIButton *)sender {
    
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
        
    }else if([Utility isSquadFreeUser]){
        if(mixedDataArray.count>0){
            [Utility showAlertAfterSevenDayTrail:self];
            return;
        }
    }
    
    
    
    QuestionType typeId = 0;
    
    if(sender == CSScaleStartButton || sender == stressSecondTestRatingButton || sender == stressBigStart){
        typeId = COHENSTRESS;
    }else if(sender == RPStressStartButton){
        typeId = RAHEPERCEIVED;
        
    }else if(sender == HQStartButton || sender == happinessSecondTestRatingButton || sender == happinessBigStart){
        typeId = HAPPINESS;
    }
    
    
    
    if(sender.tag>=0 && ![Utility isEmptyCheck:mixedDataArray]){
        NSDictionary *detailsDict = [mixedDataArray objectAtIndex:sender.tag];
        [self movedToQuestionnaireSectionWithType:typeId withDetails:detailsDict];
    }else{
       [self attemptQuestionsWithQuestionType:typeId];
    }
    
    
}

#pragma mark-End
#pragma mark-Private Method
-(void)setupAttemptStatusWithResponse:(NSArray *)details{
    stressSecondTestRatingButton.tag= -1;
    happinessSecondTestRatingButton.tag = -1;
    
    mixedDataArray = details;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"QuestionnaireTypeId = %d",COHENSTRESS];
    
    NSArray *CSAttemptArr = [details filteredArrayUsingPredicate:predicate];
    
    if(CSAttemptArr.count>0){
        
        CSScaleCompletedButton.hidden=false;
        stressBigPlayView.hidden = true;
        stressBeforeAfterView.hidden = false;
        
        NSDictionary *latestAttempt = [CSAttemptArr firstObject];
        NSDictionary *oldestAttempt;
        if (CSAttemptArr.count>1) {
            oldestAttempt= [CSAttemptArr lastObject];
        }
        
        int latestAttemptScore_stress=0;
        int oldestAttemptScore_stress=0;
        
        
        if(![Utility isEmptyCheck:latestAttempt]){
            QuestionStatusType status = [[latestAttempt objectForKey:@"QuestionnaireStatusID"] intValue];
            
            int index = (int)[details indexOfObject:latestAttempt];
            
            stressSecondTestRatingButton.tag=index;
            CSScaleStartButton.tag = -1;
//            CSScaleCompletedButton.hidden = false;
            
            if(status == INPROCESS){
                [CSScaleStartButton setImage:[UIImage imageNamed:@"progress_grn_mbhq.png"] forState:UIControlStateNormal];
                CSScaleStartButton.tag = index;
            }else if(status == COMPLETED){
                [CSScaleStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }else{
                [CSScaleStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }
            
            
            if (![Utility isEmptyCheck:[latestAttempt objectForKey:@"Total"]]) {
                latestAttemptScore_stress=[[latestAttempt objectForKey:@"Total"] intValue];
                NSNumber* score=[latestAttempt objectForKey:@"Total"];
                int b = [score intValue];
                b = b * 4;
                score = [NSNumber numberWithInt:b];
                [stressSecondTestRatingButton setTitle:[@"" stringByAppendingFormat:@"%@",score] forState:UIControlStateNormal];
                stressAfterStackView.hidden=false;
            }else{
                [ stressSecondTestRatingButton setTitle:@"0" forState:UIControlStateNormal];
                stressAfterStackView.hidden=true;
            }
            
            
            
            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//            NSString* d=[latestAttempt objectForKey:@"CreatedAt"];
//            NSDate *date = [formatter dateFromString:d];
//
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//            formatter1.dateFormat = @"dd-MM-yyyy";
//            NSString *dateString = [formatter1 stringFromDate:date];
//
//            if (![Utility isEmptyCheck:dateString]) {
//                stressSecondTestRatingDateLabel.text=[@"" stringByAppendingFormat:@"%@",dateString];
//            }else{
//                stressSecondTestRatingDateLabel.text=@"";
//            }
        }
        
        if (![Utility isEmptyCheck:oldestAttempt]) {
            if (![Utility isEmptyCheck:[oldestAttempt objectForKey:@"Total"]]) {
                oldestAttemptScore_stress=[[oldestAttempt objectForKey:@"Total"] intValue];
                NSNumber* score=[oldestAttempt objectForKey:@"Total"];
                int b = [score intValue];
                b = b * 4;
                score = [NSNumber numberWithInt:b];
                    [ stressFirstTestRatingButton setTitle:[@"" stringByAppendingFormat:@"%@",score] forState:UIControlStateNormal];
                    stressBeforeStackView.hidden=false;
            }else{
                [ stressFirstTestRatingButton setTitle:@"0" forState:UIControlStateNormal];
                stressBeforeStackView.hidden=true;
            }
            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//            NSString* d=[oldestAttempt objectForKey:@"CreatedAt"];
//            NSDate *date = [formatter dateFromString:d];
//
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//            formatter1.dateFormat = @"dd-MM-yyyy";
//            NSString *dateString = [formatter1 stringFromDate:date];
//            if (![Utility isEmptyCheck:dateString]) {
//                stressFirstTestRatingDateLabel.text=[@"" stringByAppendingFormat:@"%@",dateString];
//            }else{
//                stressFirstTestRatingDateLabel.text=@"";
//            }
        }else{
            stressBeforeStackView.hidden=true;
        }
        
        if (CSAttemptArr.count>1) {
            if (latestAttemptScore_stress < oldestAttemptScore_stress) {
            //            [stressSecondTestRatingButton setImage:[UIImage imageNamed:@"smiley_mbhq.png"] forState:UIControlStateNormal];
                [stressSecondTestRatingButton setBackgroundImage:[UIImage imageNamed:@"smiley_mbhq.png"] forState:UIControlStateNormal];
            }
        }
        
        
    }else{
        [CSScaleStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
        CSScaleCompletedButton.hidden=true;
        stressBigPlayView.hidden = false;
        stressBeforeAfterView.hidden = true;
    }
    
    
    predicate = [NSPredicate predicateWithFormat:@"QuestionnaireTypeId = %d",RAHEPERCEIVED];
    
    NSArray *RPAttemptArr = [details filteredArrayUsingPredicate:predicate];
    
    if(RPAttemptArr.count>0){
        NSDictionary *latestAttempt = [RPAttemptArr firstObject];
        
        if(![Utility isEmptyCheck:latestAttempt]){
            QuestionStatusType status = [[latestAttempt objectForKey:@"QuestionnaireStatusID"] intValue];
            
            int index = (int)[details indexOfObject:latestAttempt];
            RPStressStartButton.tag = -1;
            RPStressCompletedButton.hidden = false;
            
            if(status == INPROCESS){
                
                [RPStressStartButton setImage:[UIImage imageNamed:@"progress_grn_mbhq.png"] forState:UIControlStateNormal];
                RPStressStartButton.tag = index;
                
            }else if(status == COMPLETED){
                [RPStressStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }else{
                [RPStressStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    //Happiness
    predicate = [NSPredicate predicateWithFormat:@"QuestionnaireTypeId = %d",HAPPINESS];
    
    NSArray *HQAttemptArr = [details filteredArrayUsingPredicate:predicate];
    
    if(HQAttemptArr.count>0){
        HQCompletedButton.hidden=false;
        happinessBigPlayView.hidden = true;
        happinessBeforeAfterView.hidden = false;
        
        NSDictionary *latestAttempt = [HQAttemptArr firstObject];
        NSDictionary *oldestAttempt;
        if (HQAttemptArr.count>1) {
            oldestAttempt= [HQAttemptArr lastObject];
        }
        int latestAttemptScore_Happiness=0;
        int oldestAttemptScore_Happiness=0;
        
        if(![Utility isEmptyCheck:latestAttempt]){
            QuestionStatusType status = [[latestAttempt objectForKey:@"QuestionnaireStatusID"] intValue];
            
            int index = (int)[details indexOfObject:latestAttempt];
            happinessSecondTestRatingButton.tag=index;
            HQStartButton.tag = -1;
            HQCompletedButton.hidden = false;
            
            if(status == INPROCESS){
                
                [HQStartButton setImage:[UIImage imageNamed:@"progress_grn_mbhq.png"] forState:UIControlStateNormal];
                HQStartButton.tag = index;
                
            }else if(status == COMPLETED){
                [HQStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }else{
                [HQStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
            }
            
            
//            NSNumber* score=[latestAttempt objectForKey:@"Total"];
            
            if (![Utility isEmptyCheck:[latestAttempt objectForKey:@"Total"]]) {
                latestAttemptScore_Happiness=[[latestAttempt objectForKey:@"Total"] intValue];
                double totalMaxPoints = 120.0;
                double totalPoint  = [latestAttempt[@"Total"] doubleValue];
                NSString* score = [@"" stringByAppendingFormat:@"%.0f",(totalPoint/totalMaxPoints)*100];
                [happinessSecondTestRatingButton setTitle:score forState:UIControlStateNormal];
                happinessAfterStackView.hidden=false;
            }else{
                [ happinessSecondTestRatingButton setTitle:@"0" forState:UIControlStateNormal];
                happinessAfterStackView.hidden=true;
            }

            
            
            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//            NSString* d=[latestAttempt objectForKey:@"CreatedAt"];
//            NSDate *date = [formatter dateFromString:d];
//
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//            formatter1.dateFormat = @"dd-MM-yyyy";
//            NSString *dateString = [formatter1 stringFromDate:date];
//            if (![Utility isEmptyCheck:dateString]) {
//                happinessSecondTestRatingDateLabel.text=[@"" stringByAppendingFormat:@"%@",dateString];
//            }else{
//                happinessSecondTestRatingDateLabel.text=@"";
//            }
        }
        
        if (![Utility isEmptyCheck:oldestAttempt]) {
            		
//            double totalMaxPoints = 120.0;
//            double totalPoint  = [oldestAttempt[@"Total"] doubleValue];
//            NSString* score = [@"" stringByAppendingFormat:@"%.2f%%",(totalPoint/totalMaxPoints)*100];
//            [happinessFirstTestRatingButton setTitle:score forState:UIControlStateNormal];
//            NSNumber* score=[oldestAttempt objectForKey:@"Total"];
            if (![Utility isEmptyCheck:[oldestAttempt objectForKey:@"Total"]]) {
                oldestAttemptScore_Happiness=[[oldestAttempt objectForKey:@"Total"] intValue];
                double totalMaxPoints = 120.0;
                double totalPoint  = [oldestAttempt[@"Total"] doubleValue];
                NSString* score = [@"" stringByAppendingFormat:@"%.0f",(totalPoint/totalMaxPoints)*100];
                [happinessFirstTestRatingButton setTitle:score forState:UIControlStateNormal];
                happinessBeforeStackView.hidden=false;
            }else{
                [ happinessFirstTestRatingButton setTitle:@"0" forState:UIControlStateNormal];
                happinessBeforeStackView.hidden=true;
            }
            
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//            NSString* d=[oldestAttempt objectForKey:@"CreatedAt"];
//            NSDate *date = [formatter dateFromString:d];
//
//            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
//            formatter1.dateFormat = @"dd-MM-yyyy";
//            NSString *dateString = [formatter1 stringFromDate:date];
//            if (![Utility isEmptyCheck:dateString]) {
//                happinessFirstTestRatingDateLabel.text=[@"" stringByAppendingFormat:@"%@",dateString];
//            }else{
//                happinessFirstTestRatingDateLabel.text=@"";
//            }
        }else{
            happinessBeforeStackView.hidden=true;
        }
        
        if (HQAttemptArr.count>1) {
            if (latestAttemptScore_Happiness > oldestAttemptScore_Happiness) {
            //[happinessSecondTestRatingButton setImage:[UIImage imageNamed:@"smiley_mbhq.png"] forState:UIControlStateNormal];
                [happinessSecondTestRatingButton setBackgroundImage:[UIImage imageNamed:@"smiley_mbhq.png"] forState:UIControlStateNormal];
            }
        }
        
    }else{
        [HQStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
        HQCompletedButton.hidden=true;
        happinessBigPlayView.hidden = false;
        happinessBeforeAfterView.hidden = true;
    }
    
    
    
}
-(void)movedToQuestionnaireSectionWithType:(QuestionType)typeId withDetails:(NSDictionary *)details{
    
    if(typeId == COHENSTRESS){
        CSScaleViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CSScaleView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(typeId == RAHEPERCEIVED){
        RPStressViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RPStressView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(typeId == HAPPINESS){
        HQuestionnaireViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HQuestionnaireView"];
        controller.attemptDetailsDict = details;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
#pragma mark-End
#pragma mark-Web Service Call
-(void)getQuestionnaireAttemptStatus_Webservicecall{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserQuestionnaireAttemptListMixedType" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         NSArray *detailsArr = [responseDict objectForKey:@"Details"];
                                                                         
                                                                         
                                                                         if(![Utility isEmptyCheck:detailsArr]){
                                                                             [self setupAttemptStatusWithResponse:detailsArr];
                                                                         }else{
                                                                             [self->HQStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
                                                                             [self->CSScaleStartButton setImage:[UIImage imageNamed:@"plus_mbhq_test.png"] forState:UIControlStateNormal];
                                                                             self->CSScaleCompletedButton.hidden=true;
                                                                             self->HQCompletedButton.hidden=true;
                                                                             self->stressBigPlayView.hidden = false;
                                                                             self->stressBeforeAfterView.hidden = true;
                                                                             self->happinessBigPlayView.hidden = false;
                                                                            self->happinessBeforeAfterView.hidden = true;
                                                                             
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

-(void)attemptQuestionsWithQuestionType:(QuestionType)typeId{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSMutableDictionary *modelDict = [NSMutableDictionary new];
        [modelDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [modelDict setObject:[NSNumber numberWithInt:typeId] forKey:@"QuestionnaireTypeId"];
        [modelDict setObject:[NSNumber numberWithInt:INPROCESS] forKey:@"QuestionnaireStatusID"];
        [mainDict setObject:modelDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateUserQuestionnaireAttemptDetails" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         NSDictionary *detailsDict = [responseDict objectForKey:@"Details"];
                                                                         
                                                                         
                                                                         if(![Utility isEmptyCheck:detailsDict]){
                                                                             [self movedToQuestionnaireSectionWithType:typeId withDetails:detailsDict];
                                                                         }
                                                                         
                                                                     }else{
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
#pragma mark-End
@end
