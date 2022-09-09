//
//  SetProgramViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 24/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "SetProgramViewController.h"
#import "SetProgramTableViewCell.h"
#import "ViewPersonalSessionViewController.h"
#import "CoursesListViewController.h"
#import "CustomNutritionPlanListViewController.h"
#import "DatePickerViewController.h"
#import "ShoppingListViewController.h"
@interface SetProgramViewController ()
{
    UIView *contentView;
    NSArray *availabelProgramList;
    NSArray *completedProgramList;
    NSDictionary *startProgramDict;
    NSString *currentProgramDate;
    NSString *nextProgramDate;
    NSDate *selectedDate;
    NSString *cancelCurrentDateStr;//Add_New
    NSString *cancelNextDateStr;//Add_New

    IBOutlet UITableView *programTable;
    IBOutlet UIView *startProgramView;
    IBOutlet UITextView *starProgText;
    IBOutlet UIButton *startYesButton;
    IBOutlet UIButton *startNoButton;
    IBOutlet UIView *startprogramNextView;
    IBOutlet UITextView *nextprogramTextView;
    IBOutlet UIButton *currentminiDateButton;
    IBOutlet UIButton *nextminiDateButton;
    IBOutlet UIButton *startProgramNextViewNoButton;
    IBOutlet UIView *deleteProgramView;
    IBOutlet UIView *editProgramView;
    IBOutlet UIButton *editProgramDateButton;
    IBOutlet UIButton *completeButton;
    IBOutlet UIView *completeView;
    IBOutlet NSLayoutConstraint *completeButtonHeightConstant;
    IBOutlet UIView *cancelAlertView;
    IBOutlet UIStackView *cancelAlertStackView;
    IBOutlet UIStackView *cancelAlertHorizentalStack;
    IBOutlet UIButton *cancelExerciseButton;
    IBOutlet UIButton *cancelNutritionButton;
    IBOutlet UIButton *cancelEntireProgramButton;
    IBOutlet UILabel *cancelAlertLabel;
    IBOutlet UIView *commonCancelDateView;
    IBOutlet UIButton *commomCurrentDateButton;
    IBOutlet UIButton *commonNextDateButton;
    IBOutlet UILabel *commonCancelHeaderLabel;
    IBOutlet UILabel *commonCancelDetailsLabel;
    IBOutlet UIButton *editProgramYesButton;
    IBOutlet UIStackView *commonStack;
    IBOutlet UIView *descriptionTextView;
    IBOutlet UITextView *descriptionText;
    BOOL isComplete;
    IBOutlet UILabel *custombarHeaderlabel;
    NSDate *currentMiniProgramDate;
    BOOL isCheckSelected;
    
    NSMutableArray *selectedIndexArray;
    BOOL isFirstLoadForActive;
}
@end

@implementation SetProgramViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    programTable.estimatedRowHeight = 70;
    programTable.rowHeight = UITableViewAutomaticDimension;
    selectedIndexArray = [NSMutableArray new];
    
    isFirstLoadForActive = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isComplete = false;
    completedProgramList = [[NSArray alloc]init];
    availabelProgramList = [[NSArray alloc]init];
    custombarHeaderlabel.text = @"AVAILABLE/ACTIVE PROGRAMS"; //15may2018
    [completeButton setTitle:@"COMPLETED PROGRAM" forState:UIControlStateNormal];
    [self commonCrossPressed:nil];
    completeButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    completeButton.layer.borderWidth = 1.0;
    completeButton.layer.cornerRadius = 8;
    
    
    completeButton.layer.masksToBounds = YES;
    [self webSerViceCall_GetSquadMiniProgram];
}
#pragma mark  -End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -End

#pragma mark - IBAction
- (IBAction)cellExpandCollapse:(UIButton *)sender {
    
    if ([selectedIndexArray containsObject:[NSNumber numberWithInteger:sender.tag]]) {
        
        [selectedIndexArray removeObject:[NSNumber numberWithInteger:sender.tag]];
    }else{
        
        [selectedIndexArray addObject:[NSNumber numberWithInteger:sender.tag]];
    }
    [programTable reloadData];
    //[programTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue]] withRowAnimation:UITableViewRowAnimationTop];
    [programTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(IBAction)courseButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        CoursesListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CoursesList"];
        if (![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]]) {
            controller.courseName = [dict objectForKey:@"CourseName"];
            controller.fromSetProgram = true;
            controller.isRedirectToSetProgram = true;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }
   
}
-(IBAction)exerciseButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];//yyyy-MM-dd'T'HH:mm:ss
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
            BOOL ischeck = [self numberOfWeek:2 fromDate:startDate with:YES];
            if (ischeck) {
                if (![Utility isEmptyCheck:startDate]) {
                    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                    //controller.weekStartDate = startDate;
                    controller.isFromSetProgram = true;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
//            if (issameDate) {
//                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }else{
//                if (![Utility isEmptyCheck:startDate]) {
//                    ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
//                    controller.weekStartDate = startDate;
//                    controller.isFromSetProgram = true;
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
//            }
        }
    }
}

-(IBAction)nutritionButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
            
            BOOL isCheck = [self numberOfWeek:2 fromDate:startDate with:YES];
         
            if (isCheck) {
                if (![Utility isEmptyCheck:startDate]) {
                    CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                    controller.weekDate = startDate;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
//            if (issameDate) {
//                CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
//                [self.navigationController pushViewController:controller animated:YES];
//            }else{
//                if (![Utility isEmptyCheck:startDate]) {
//                    CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
//                    controller.weekDate = startDate;
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
//            }
           
        }
    }
}
-(IBAction)shoppingListButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
            
            BOOL isCheck = [self numberOfWeek:2 fromDate:startDate with:YES];
            
            if (isCheck) {
                if (![Utility isEmptyCheck:startDate]) {
                    ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
                    controller.weekdate = startDate;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }
}
-(IBAction)startButtonPressed:(UIButton*)sender{
    
    NSDictionary *dict;
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
       dict = [availabelProgramList objectAtIndex:sender.tag];
    }
    
    if([Utility isSquadLiteUser]){
     [Utility showSubscribedAlert:self];
     return;
     }else if([Utility isSquadFreeUser]){
     [Utility showAlertAfterSevenDayTrail:self];
     return;
     }else if(![Utility isSubscribedUser] || [defaults boolForKey:@"IsNonSubscribedUser"]){
     //[Utility showSubscribedAlert:self];
     [Utility showSetProgramSubscribedAlert:self withData:dict];
     return;
     }
    
    
    int programId = [[dict objectForKey:@"ProgramId"] intValue];
    startYesButton.layer.cornerRadius = 8;
    startYesButton.layer.masksToBounds = YES;
    
    startNoButton.layer.cornerRadius = 8;
    startNoButton.layer.masksToBounds = YES;
    
    [self webSerViceCall_GetStartProgram:programId];
}

-(IBAction)cancelButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        startProgramView.hidden = true;
        startprogramNextView.hidden = true;
        deleteProgramView.hidden = true;
        editProgramView.hidden = true;
        cancelAlertView.hidden = false;
        commonCancelDateView.hidden = true;
        descriptionTextView.hidden = true;//change_setprogram_feedback
        
        NSString *detailStr = @"";
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
//        if ([[dict objectForKey:@"ExerciseProgram"]boolValue]) {
        if ([Utility isEmptyCheck:[dict objectForKey:@"ExerciseCancelDate"]]) {
            detailStr = @"Cancel Exercise, ";
            [cancelAlertHorizentalStack addArrangedSubview:cancelExerciseButton];
        }else{
            [cancelAlertHorizentalStack removeArrangedSubview:cancelExerciseButton];
            [cancelExerciseButton removeFromSuperview];
        }
    
//        if (![Utility isEmptyCheck:[dict objectForKey:@"NutritionProgram"]]) {
        if ([Utility isEmptyCheck:[dict objectForKey:@"NutritionCancelDate"]]) {
                detailStr = [detailStr stringByAppendingString:@"Cancel Nutrition,"];
                [cancelAlertHorizentalStack addArrangedSubview:cancelNutritionButton];
            }else{
                [cancelAlertHorizentalStack removeArrangedSubview:cancelNutritionButton];
                [cancelNutritionButton removeFromSuperview];
            }
//        }
//            if ([[dict objectForKey:@"ExerciseProgram"]boolValue] || [[dict objectForKey:@"NutritionProgram"]boolValue]) {
        if ([Utility isEmptyCheck:[dict objectForKey:@"ExerciseCancelDate"]]||[Utility isEmptyCheck:[dict objectForKey:@"NutritionCancelDate"]] ) {
            [cancelAlertStackView addArrangedSubview:cancelAlertHorizentalStack];
            [cancelAlertStackView addArrangedSubview:cancelEntireProgramButton];
            }else{
                [cancelAlertStackView addArrangedSubview:cancelEntireProgramButton];
            }
        cancelAlertLabel.text= [@"" stringByAppendingFormat:@"Select Option to %@ Cancel Entire Program",detailStr];
    }
}

-(IBAction)cancelExerciseButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        [self webSerViceCall_GetDatesForResetExerciseNutritionPlan:[availabelProgramList objectAtIndex:sender.tag] with:@"CancelExercise"];
    }
}
-(IBAction)cancelNutritionButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        [self webSerViceCall_GetDatesForResetExerciseNutritionPlan:[availabelProgramList objectAtIndex:sender.tag] with:@"CancelNutrition"];
    }
}
-(IBAction)resetExerciseNutritionPlan:(UIButton*)sender{ //Add_new
   
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSString *fromdate=@"";
        NSString *fromWhere=@"";
        if ([commonCancelHeaderLabel.text isEqualToString:@"Cancel Exercise"]) {
            fromWhere =@"ResetExercise";
        }else{
            fromWhere = @"ResetNutrition";
        }
        if ([sender isEqual:commomCurrentDateButton]) {
            fromdate = cancelCurrentDateStr;
        }else{
            fromdate = cancelNextDateStr;
        }
        if (![Utility isEmptyCheck:fromWhere] && ![Utility isEmptyCheck:fromdate]) {
            [self webSerViceCall_ResetPlan:[availabelProgramList objectAtIndex:sender.tag] with:fromWhere with:fromdate];
        }
    }
}

-(IBAction)cancelEntireProgramButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        [self showAlertonCancelEntireProgram:[availabelProgramList objectAtIndex:sender.tag]];
     }
}
-(IBAction)editButtonPressed:(id)sender{
    editProgramView.hidden = false;
    startProgramView.hidden = true;
    startprogramNextView.hidden = true;
    deleteProgramView.hidden = true;
    cancelAlertView.hidden = true;
    descriptionTextView.hidden = true;//change_setprogram_feedback
    editProgramDateButton.layer.borderColor = [Utility colorWithHexString:@"DFDFDF"].CGColor;
    editProgramDateButton.layer.borderWidth = 1;
}

-(IBAction)editProgramDatePressed:(id)sender{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)deleteYesButtonPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        [self webSerViceCall_DeleteQueuedProgram:dict];
    }
}
-(IBAction)editProgramYesPressed:(UIButton*)sender{
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
         if (![Utility isEmptyCheck:editProgramDateButton.titleLabel.text]) {
             NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
             [self showAlert:dict];
         }else{
             [Utility msg:@"Please Select Date" title:@"Alert" controller:self haveToPop:NO];
         }
    }
}
-(IBAction)commonCrossPressed:(id)sender{
    editProgramView.hidden = true;
    startProgramView.hidden = true;
    startprogramNextView.hidden = true;
    deleteProgramView.hidden = true;
    cancelAlertView.hidden = true;
    commonCancelDateView.hidden = true;
    descriptionTextView.hidden = true; //change_setprogram_feedback
}
-(IBAction)editProgramNoPressed:(id)sender{
    [editProgramDateButton setTitle:@"" forState:UIControlStateNormal];
    [self commonCrossPressed:nil];
}
-(IBAction)deleteNoButtonPressed:(id)sender{
    [self commonCrossPressed:nil];
}
-(IBAction)deleteButtonPressed:(UIButton*)sender{
    deleteProgramView.hidden = false;
    startProgramView.hidden = true;
    startprogramNextView.hidden = true;
    editProgramView.hidden = true;
    cancelAlertView.hidden = true;
    commonCancelDateView.hidden = true;
    descriptionTextView.hidden = true; //change_setprogram_feedback
}

-(IBAction)startYesButtonPressed:(id)sender{
    startProgramNextViewNoButton.layer.cornerRadius = 8;
    startProgramNextViewNoButton.layer.masksToBounds = YES;
    
    currentminiDateButton.layer.cornerRadius = 8;
    currentminiDateButton.layer.masksToBounds = YES;
    
    nextminiDateButton.layer.cornerRadius = 8;
    nextminiDateButton.layer.masksToBounds = YES;
    
    if (![Utility isEmptyCheck:startProgramDict] && ![Utility isEmptyCheck:[startProgramDict objectForKey:@"ProgramId"]]) {
        [self webSerViceCall_GetStartDateOfNextProgram];
    }
}
-(IBAction)startNoButtonPressed:(id)sender{
    [self commonCrossPressed:nil];
}

-(IBAction)startProgramNextViewCrossPressed:(id)sender{
    startprogramNextView.hidden = true;
    deleteProgramView.hidden = true;
    editProgramView.hidden = true;
    cancelAlertView.hidden = true;
    commonCancelDateView.hidden = true;
    descriptionTextView.hidden = true; //change_setprogram_feedback
}
-(IBAction)startProgramNextViewNoPressed:(id)sender{
    [self commonCrossPressed:nil];

}
-(IBAction)startProgramNextViewFirstDateButtonPressed:(id)sender{
    if (![Utility isEmptyCheck:currentProgramDate]) {
        [self webSerViceCall_StartProgramCourse:currentProgramDate];
    }
}
-(IBAction)startProgramNextViewNextDateButtonPressed:(id)sender{
    if (![Utility isEmptyCheck:nextProgramDate]) {
        [self webSerViceCall_StartProgramCourse:nextProgramDate];
    }
}

-(BOOL)getCurrentStartWeekDay{
    NSDate *today = selectedDate;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:selectedDate options:0];
    if ([weekstart compare:selectedDate] == NSOrderedSame){
        return YES;
    }
    return NO;
}

-(IBAction)completeButtonPressed:(UIButton *)sender{ //15may2018
    if (![Utility isEmptyCheck:completedProgramList]) {
        if (isComplete) {
            isComplete = false;
            custombarHeaderlabel.text = @"AVAILABLE/ACTIVE PROGRAMS";
            [completeButton setTitle:@"COMPLETED PROGRAM" forState:UIControlStateNormal];
        }else{
            isComplete = true;
            custombarHeaderlabel.text = @"COMPLETED PROGRAM";
            [completeButton setTitle:@"AVAILABLE/ACTIVE PROGRAMS" forState:UIControlStateNormal];
        }
        
        //isCheckSelected = false;
        if ([selectedIndexArray containsObject:[NSNumber numberWithInteger:sender.tag]]){
            [selectedIndexArray removeObject:[NSNumber numberWithInteger:sender.tag]];
        }
        [programTable reloadData];
    }
}
-(IBAction)commonCancelDateViewNoPressed:(id)sender{
    [self commonCrossPressed:nil];
}

-(IBAction)clickHereButtonPressed:(UIButton*)sender{ //Change_setprogram_feedback
    if (![Utility isEmptyCheck:availabelProgramList] && ![Utility isEmptyCheck:[availabelProgramList objectAtIndex:sender.tag]]) {
        descriptionTextView.hidden = false;
        NSDictionary *dict = [availabelProgramList objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:[dict objectForKey:@"Description"]]) {
           NSString *descriptionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", descriptionText.font.fontName, descriptionText.font.pointSize,[UIColor darkGrayColor], [dict objectForKey:@"Description"]];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[descriptionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding),
                                                                                           NSFontAttributeName : descriptionText.font,
                                                                                           NSForegroundColorAttributeName : descriptionText.textColor
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            
            descriptionText.attributedText = strAttributed;
        }else{
            descriptionText.attributedText = [[NSAttributedString alloc]initWithString:@""];
        }
    }
}
#pragma mark - End

#pragma mark - Private Function
-(void) showAlert:(NSDictionary*)dict{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"You are about to update start date of the program, if any queued program that will start on/after till the end date of the program will be deleted."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                   [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                   NSString *date = [dateFormat stringFromDate:selectedDate];
                                   if (![Utility isEmptyCheck:date]) {
                                       [self webSerViceCall_UpdateProgram:dict with:date];
                                   }
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"CANCEL"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) showAlertonCancelEntireProgram:(NSDictionary*)dict{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:@"Are you sure, you want to cancel entire mini program ?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes,Cancel Entire Program"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self webSerViceCall_CancelMiniProgram:dict with:@""];

                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"NO"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(BOOL)numberOfWeek:(int)weekOffset fromDate:(NSDate*)date with:(BOOL)ispop
{
    BOOL isCheck;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *programStartDate = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    NSDate *nextWeekFormCurrentDate = [[NSDate date] dateByAddingDays:7];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM YYYY"];
    NSString *startdateStr = [dateFormat stringFromDate:date];
    
    if ([nextWeekFormCurrentDate compare:programStartDate] == NSOrderedAscending) {
        NSString *str = [@"" stringByAppendingFormat:@"Your Program Starts [ %@ ] , So this plan will be available [ %@ ]",startdateStr,startdateStr];
        if (ispop) {
            [Utility msg:str title:@"" controller:self haveToPop:NO];
        }
        isCheck = false;
    }else{
        isCheck = true;
    }
    return isCheck;
}
#pragma mark - End
#pragma mark - WebService Call

-(void)webSerViceCall_GetSquadMiniProgram{
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
 
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMiniProgram" append:@""forAction:@"POST"];
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
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"AvailableProgramList"]]) {
                                                                              availabelProgramList = [responseDict objectForKey:@"AvailableProgramList"];
                                                                         }
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"CompletedProgramList"]]) {
                                                                               completedProgramList = [responseDict objectForKey:@"CompletedProgramList"];
                                                                             completeView.hidden = false;
                                                                             completeButtonHeightConstant.constant = 50;
                                                                         }else{
                                                                             completeView.hidden = true;
                                                                             completeButtonHeightConstant.constant = 0;
                                                                         }
                                                                         isCheckSelected = false;
                                                                         [programTable reloadData];
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

-(void)webSerViceCall_UpdateProgram:(NSDictionary*)dict with:(NSString*)date{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        [mainDict setObject:date forKey:@"StartDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateProgram" append:@""forAction:@"POST"];
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
                                                                         [self commonCrossPressed:nil];
                                                                         [editProgramDateButton setTitle:@"" forState:UIControlStateNormal];                                                                         [self webSerViceCall_GetSquadMiniProgram];
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

-(void)webSerViceCall_GetStartProgram:(int)programId{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:programId] forKey:@"ProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"StartProgram" append:@""forAction:@"POST"];
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
                                                                         startProgramDict = [responseDict objectForKey:@"startProgramModel"];
                                                                         
                                                                         if (![Utility isEmptyCheck:startProgramDict]) {
                                                                             startProgramView.hidden = false;
                                                                             startprogramNextView.hidden = true;
                                                                             deleteProgramView.hidden = true;
                                                                             editProgramView.hidden = true;
                                                                             cancelAlertView.hidden = true;
                                                                             commonCancelDateView.hidden = true;
                                                                             descriptionTextView.hidden = true; //change_setprogram_feedback
                                                                             
                                                                             NSString *str = @"";
                                                                             
                                                                             if (![Utility isEmptyCheck:[startProgramDict objectForKey:@"HasNutrition"]]) {
                                                                                 str = @"- A Custom Nutrition Plan";
                                                                             }
                                                                             
                                                                             if (![Utility isEmptyCheck:[startProgramDict objectForKey:@"HasExercise"]]) {
                                                                                 str = [@"" stringByAppendingFormat:@"%@ \n - A Custom Exercise Plan",str];
                                                                             }
                                                                             
                                                                             NSString *strTextView = [@"" stringByAppendingFormat:@"Hi %@ \n You are about to start the %@ that goes for %@ weeks \n This program contains \n %@ \n And will update your current SQUAD settings for the duration of the Program. \n At any time if you aren't enjoying an individual component of the 'Set Program' just come back to this page and cancel it.\n You may also chose to cancel a single component of the 'Set Program'. IE you might love the nutrition plan but prefer your normal custom exercise plan. Thats ok, and you have the flexibility to do this.\n Any questions, please post on the Worldwide Forum \n Are you ready to START?",[startProgramDict objectForKey:@"UserName"],[startProgramDict objectForKey:@"ProgramName"],[startProgramDict objectForKey:@"Duration"],str];
                                                                             
                                                                             NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                                                             paragraphStyle.alignment= NSTextAlignmentLeft;
                                                                             
                                                                             NSRange rangeBold = [strTextView rangeOfString:[startProgramDict objectForKey:@"ProgramName"]];
                                                                             NSDictionary *dictBoldText =  @{
                                                                                                             NSFontAttributeName : [UIFont fontWithName:@"Oswald-bold" size:15],
                                                                                                             NSForegroundColorAttributeName : [Utility colorWithHexString:@"000000"],
                                                                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                                                                             };
                                                                             
                                                                             NSRange rangeBold1 = [strTextView rangeOfString:[@"" stringByAppendingFormat:@"%@ weeks",[startProgramDict objectForKey:@"Duration"]]];
                                                                             
                                                                             NSDictionary *dictBoldText1 = @{
                                                                                                             NSFontAttributeName : [UIFont fontWithName:@"Oswald-bold" size:15],
                                                                                                             NSForegroundColorAttributeName : [Utility colorWithHexString:@"000000"],
                                                                                                             NSParagraphStyleAttributeName:paragraphStyle
                                                                                                             };
                                                                             
                                                                             NSDictionary *attrDict1 = @{
                                                                                                         NSFontAttributeName : [UIFont fontWithName:@"Oswald-regular" size:15.0],
                                                                                                         NSForegroundColorAttributeName : [Utility colorWithHexString:@"555555"],
                                                                                                         NSParagraphStyleAttributeName:paragraphStyle
                                                                                                         };
                                                                             
                                                                             NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView attributes:attrDict1];
                                                                             [mutAttrTextViewString setAttributes:dictBoldText range:rangeBold];
                                                                             [mutAttrTextViewString setAttributes:dictBoldText1 range:rangeBold1];
                                                                             
                                                                             [starProgText setAttributedText:mutAttrTextViewString];
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

-(void)webSerViceCall_StartProgramCourse:(NSString*)dateStr{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[startProgramDict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [mainDict setObject:[startProgramDict objectForKey:@"ProgramName"] forKey:@"ProgramName"];
        [mainDict setObject:[startProgramDict objectForKey:@"CourseId"] forKey:@"CourseId"];
        [mainDict setObject:[startProgramDict objectForKey:@"CourseName"] forKey:@"CourseName"];
        [mainDict setObject:[startProgramDict objectForKey:@"StartFromCurrentWeek"] forKey:@"StartFromCurrentWeek"];
        [mainDict setObject:[startProgramDict objectForKey:@"StartFromNextWeek"] forKey:@"StartFromNextWeek"];
        [mainDict setObject:[startProgramDict objectForKey:@"JoinedProgramName"] forKey:@"JoinedProgramName"];
        [mainDict setObject:[startProgramDict objectForKey:@"JoinedProgramId"] forKey:@"JoinedProgramId"];
        [mainDict setObject:dateStr forKey:@"CourseStartDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"StartProgramCourse" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self commonCrossPressed:nil];
                                                                         [self webSerViceCall_GetSquadMiniProgram];
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
-(void)webSerViceCall_DeleteQueuedProgram:(NSDictionary*)dict{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteQueuedProgram" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [self commonCrossPressed:nil];
                                                                         [self webSerViceCall_GetSquadMiniProgram];
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

-(void)webSerViceCall_GetStartDateOfNextProgram{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[startProgramDict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetStartDateOfNextProgram" append:@""forAction:@"POST"];
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
                                                                         
                                                                         startprogramNextView.hidden = false;
                                                                         deleteProgramView.hidden = true;
                                                                         editProgramView.hidden = true;
                                                                         cancelAlertView.hidden = true;
                                                                         commonCancelDateView.hidden = true;
                                                                         descriptionTextView.hidden = true;
                                                                         NSString *currentMiniProgramDateStr = @"";
                                                                         NSString *nextMiniProgramDateStr = @"";
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"CurrentMiniProgramDate"]]) {
                                                                             
                                                                             currentProgramDate = [responseDict objectForKey:@"CurrentMiniProgramDate"];
                                                                             
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             currentMiniProgramDate = [dateFormat dateFromString:[responseDict objectForKey:@"CurrentMiniProgramDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             currentMiniProgramDateStr = [dateFormat stringFromDate:currentMiniProgramDate];
                                                                             [currentminiDateButton setTitle:currentMiniProgramDateStr forState:UIControlStateNormal];
                                                                         }
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"NextMiniProgramDate"]]) {
                                                                             
                                                                             nextProgramDate = [responseDict objectForKey:@"NextMiniProgramDate"];
                                                                             
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSDate *nextMiniProgramDate = [dateFormat dateFromString:[responseDict objectForKey:@"NextMiniProgramDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             nextMiniProgramDateStr = [dateFormat stringFromDate:nextMiniProgramDate];
                                                                             [nextminiDateButton setTitle:nextMiniProgramDateStr forState:UIControlStateNormal];
                                                                         }
                                                                          NSString *strTextView = [@"" stringByAppendingFormat:@"Would you like to start the %@ \n - Start Date: [%@] \n Or \n - Start Date: [%@] \n If you chose [%@] your current plan will update and any meals/shopping lists for this week will change. \n If you chose [%@],remember when you go to your Custom Plans you will need to click forward to 'Next Week' to see your plan ahead of time... A tip is to always look at the DATE at the top to make sure you know which week you're on.",[startProgramDict objectForKey:@"ProgramName"],currentMiniProgramDateStr,nextMiniProgramDateStr,currentMiniProgramDateStr,nextMiniProgramDateStr];

                                                                              NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                                                              paragraphStyle.alignment= NSTextAlignmentLeft;

                                                                              NSRange rangeBold = [strTextView rangeOfString:[startProgramDict objectForKey:@"ProgramName"]];
                                                                              NSDictionary *dictBoldText =  @{
                                                                                                              NSFontAttributeName : [UIFont fontWithName:@"Oswald-bold" size:15],
                                                                                                              NSForegroundColorAttributeName : [Utility colorWithHexString:@"000000"],
                                                                                                              NSParagraphStyleAttributeName:paragraphStyle
                                                                                                              };

                                                                              NSRange rangeBold1 = [strTextView rangeOfString:currentMiniProgramDateStr];

                                                                              NSDictionary *dictBoldText1 = @{
                                                                                                              NSFontAttributeName : [UIFont fontWithName:@"Oswald-bold" size:15],
                                                                                                              NSForegroundColorAttributeName : [Utility colorWithHexString:@"000000"],
                                                                                                              NSParagraphStyleAttributeName:paragraphStyle
                                                                                                              };
                                                                         
                                                                            NSRange rangeBold2 = [strTextView rangeOfString:nextMiniProgramDateStr];

                                                                            NSDictionary *dictBoldText2 = @{
                                                                                                         NSFontAttributeName : [UIFont fontWithName:@"Oswald-bold" size:15],
                                                                                                         NSForegroundColorAttributeName : [Utility colorWithHexString:@"000000"],
                                                                                                         NSParagraphStyleAttributeName:paragraphStyle
                                                                                                         };

                                                                              NSDictionary *attrDict1 = @{
                                                                                                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-regular" size:15.0],
                                                                                                          NSForegroundColorAttributeName : [Utility colorWithHexString:@"555555"],
                                                                                                          NSParagraphStyleAttributeName:paragraphStyle
                                                                                                          };

                                                                              NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView attributes:attrDict1];
                                                                              [mutAttrTextViewString setAttributes:dictBoldText range:rangeBold];
                                                                              [mutAttrTextViewString setAttributes:dictBoldText1 range:rangeBold1];
                                                                              [mutAttrTextViewString setAttributes:dictBoldText2 range:rangeBold2];
                                                                              [nextprogramTextView setAttributedText:mutAttrTextViewString];

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

-(void)webSerViceCall_GetDatesForResetExerciseNutritionPlan:(NSDictionary*)dict with:(NSString*)option{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        [mainDict setObject:[dict objectForKey:@"StartDate"] forKey:@"WeekStartDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *exerciseNutritionStr;
        if ([option isEqualToString:@"CancelExercise"]) {
            exerciseNutritionStr = @"GetDatesForResetExercisePlan";
        }else{
            exerciseNutritionStr = @"GetDatesForResetNutritionPlan";
        }
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:exerciseNutritionStr append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         startProgramView.hidden = true;
                                                                         startprogramNextView.hidden = true;
                                                                         deleteProgramView.hidden = true;
                                                                         editProgramView.hidden = true;
                                                                         cancelAlertView.hidden = true;
                                                                         commonCancelDateView.hidden = false;
                                                                         descriptionTextView.hidden =true;
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"CurrentWeekDate"]] ) {
                                                                             [commonStack insertArrangedSubview:commomCurrentDateButton atIndex:0];
                                                                             cancelCurrentDateStr = [responseDict objectForKey:@"CurrentWeekDate"];
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSDate *startDate = [dateFormat dateFromString:[responseDict objectForKey:@"CurrentWeekDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             NSString *date = [dateFormat stringFromDate:startDate];
                                                                             [commomCurrentDateButton setTitle:date forState:UIControlStateNormal];
                                                                         }else{
                                                                             [commomCurrentDateButton setTitle:@"" forState:UIControlStateNormal];
                                                                             [commonStack removeArrangedSubview:commomCurrentDateButton];
                                                                             [commomCurrentDateButton removeFromSuperview];
                                                                         }
                                                                         
                                                                         if (![Utility isEmptyCheck:[responseDict objectForKey:@"NextWeekDate"]]) {
                                                                             [commonStack insertArrangedSubview:commonNextDateButton atIndex:1];
                                                                             cancelNextDateStr = [responseDict objectForKey:@"NextWeekDate"];
                                                                             NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                                                             [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSDate *nextWeekDate = [dateFormat dateFromString:[responseDict objectForKey:@"NextWeekDate"]];
                                                                             [dateFormat setDateFormat:@"dd MMM YYYY"];
                                                                             NSString *date = [dateFormat stringFromDate:nextWeekDate];
                                                                             [commonNextDateButton setTitle:date forState:UIControlStateNormal];
                                                                         }else{
                                                                              [commonNextDateButton setTitle:@"" forState:UIControlStateNormal];
                                                                             [commonStack removeArrangedSubview:commonNextDateButton];
                                                                             [commonNextDateButton removeFromSuperview];
                                                                            }
                                                                         
                                                                     if ([option isEqualToString:@"CancelExercise"]) {
                                                                         commonCancelHeaderLabel.text = @"Cancel Exercise";
                                                                     }else{
                                                                         commonCancelHeaderLabel.text = @"Cancel Nutrition";
                                                                        }

                                                                      if (![Utility isEmptyCheck:commomCurrentDateButton.titleLabel.text] && ![Utility isEmptyCheck:commonNextDateButton.titleLabel.text] ) {
                                                                          commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from this week monday (%@) or next week monday (%@)",commomCurrentDateButton.titleLabel.text,commonNextDateButton.titleLabel.text];
                                                                      }else if(![Utility isEmptyCheck:commomCurrentDateButton.titleLabel.text]){
                                                                           commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from this week monday (%@)",commomCurrentDateButton.titleLabel.text];
                                                                      }else if(![Utility isEmptyCheck:commonNextDateButton.titleLabel.text]){
                                                                           commonCancelDetailsLabel.text = [@"" stringByAppendingFormat:@"Do you want the new plan effective from next week monday (%@)",commonNextDateButton.titleLabel.text];
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

-(void)webSerViceCall_ResetPlan:(NSDictionary*)dict with:(NSString*)option with:(NSString*)dateStr{  //Add_new
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"ProgramId"];
        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"UserProgramId"];
        [mainDict setObject:dateStr forKey:@"fromDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSString *exerciseNutritionStr;
        if ([option isEqualToString:@"ResetExercise"]) {
            exerciseNutritionStr = @"ResetExercisePlan";
        }else{
            exerciseNutritionStr = @"ResetNutritionPlan";
        }
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:exerciseNutritionStr append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self commonCrossPressed:nil];
                                                                         isComplete = false;
                                                                         [self webSerViceCall_GetSquadMiniProgram];
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

-(void)webSerViceCall_CancelMiniProgram:(NSDictionary*)dict with:(NSString*)dateStr{  //Add_new
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"SquadUserId"];
        [mainDict setObject:[dict objectForKey:@"UserCourseId"] forKey:@"UserCourseId"];
        [mainDict setObject:[dict objectForKey:@"UserMiniProgramId"] forKey:@"SquadUserMiniProgramId"];
        [mainDict setObject:[dict objectForKey:@"ProgramId"] forKey:@"SquadMiniProgramId"];
        [mainDict setObject:[dict objectForKey:@"HasExercise"] forKey:@"HasExercise"];
        [mainDict setObject:[dict objectForKey:@"HasNutrition"] forKey:@"HasNutrition"];
        [mainDict setObject:[NSNumber numberWithInt:4] forKey:@"CancelProgramTypeId"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormat dateFromString:currentDateStr];
        [dateFormat setDateFormat:@"dd MMM YYYY"];
        NSString *date = [dateFormat stringFromDate:currentDate];
        
        [mainDict setObject:date forKey:@"CancellationDate"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
       
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CancelMiniProgram" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self commonCrossPressed:nil];
                                                                         self->isComplete = false;
                                                                         [defaults setObject:@"" forKey:@"CurrentProgramName"];
                                                                         [self webSerViceCall_GetSquadMiniProgram];
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

#pragma mark  - End

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isComplete) {
       return completedProgramList.count;
    }else{
        return availabelProgramList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"SetProgramTableViewCell";
    SetProgramTableViewCell *cell = (SetProgramTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[SetProgramTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.clickHereButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.clickHereButton.layer.borderWidth = 1;
    
    cell.cancelButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.cancelButton.layer.borderWidth = 1;
    
    cell.editButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.editButton.layer.borderWidth = 1;
    
    cell.deleteButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.deleteButton.layer.borderWidth = 1;

    
    NSDictionary *dict;

    if (isComplete) {
        dict = [completedProgramList objectAtIndex:indexPath.row];
        [cell.detailsStackView removeArrangedSubview:cell.actionView];
        [cell.actionView removeFromSuperview];
    }else{
        dict = [availabelProgramList objectAtIndex:indexPath.row];
        [cell.detailsStackView addArrangedSubview:cell.actionView];
    }
    
    cell.expandCollapse.tag = indexPath.row;
    [cell.expandCollapse addTarget:self
                            action:@selector(cellExpandCollapse:)
                  forControlEvents:UIControlEventTouchUpInside];
    if (![Utility isEmptyCheck:dict]) {
        if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
            cell.programName.text = [dict objectForKey:@"ProgramName"];
        }
       
        if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
//            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setDateFormat:@"dd MMM YYYY"];
            NSString *date = [dateFormat stringFromDate:startDate];
            cell.startDate.text = date;
        }else{
            cell.startDate.text = @"";
        }
        if (![Utility isEmptyCheck:[dict objectForKey:@"EndDate"]]) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"EndDate"]];
            //            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
            [dateFormat setDateFormat:@"dd MMM YYYY"];
            NSString *date = [dateFormat stringFromDate:startDate];
            cell.endDate.text = date;
        }else{
            cell.endDate.text = @"";
        }
        
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]] && ![Utility isEmptyCheck:[dict objectForKey:@"EndDate"]]) {
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
            
            NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
            NSDate *currentDate = [dateFormat dateFromString:currentDateStr];
            
            NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
            NSDate *endDate = [dateFormat dateFromString:[dict objectForKey:@"EndDate"]];
            
            BOOL issameDate =  [Utility date:currentDate isBetweenDate:startDate andDate:endDate];
            
            
            
            if (!isComplete) {//Change_Feedback
                if (issameDate) {
                    isCheckSelected = true;
                    cell.mainView.backgroundColor = [Utility colorWithHexString:@"9ecee0"];
                    
                    if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
                        [defaults setObject:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProgramName"]] forKey:@"CurrentProgramName"];
                    }
                    
                    
                    if (![selectedIndexArray containsObject:[NSNumber numberWithInteger:indexPath.row]] && isFirstLoadForActive){
                        isFirstLoadForActive = NO;
                        [selectedIndexArray addObject:[NSNumber numberWithInteger:indexPath.row]];
                    }
                }else{
                    BOOL check = [self numberOfWeek:2 fromDate:startDate with:NO];
                    if (check) {
                        if (!isCheckSelected) {
                            cell.mainView.backgroundColor = [Utility colorWithHexString:@"9ecee0"];
                            if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
                                [defaults setObject:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProgramName"]] forKey:@"CurrentProgramName"];
                            }
                            if (![selectedIndexArray containsObject:[NSNumber numberWithInteger:indexPath.row]] && isFirstLoadForActive){
                                isFirstLoadForActive = NO;
                                [selectedIndexArray addObject:[NSNumber numberWithInteger:indexPath.row]];
                            }
                        }else{
                            cell.mainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                        }
                    }else{
                        cell.mainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
                    }
                }
            }else{
                cell.mainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            }
            
            if (isComplete) {
                if (![Utility isEmptyCheck:[dict objectForKey:@"NutritionProgram"]]) {
                    cell.nutritionCurrenDateView.hidden = true;
                    cell.nutritionButton.userInteractionEnabled = false;
                    
                    cell.shoppingCurrentDateView.hidden = true;
                    cell.shoppingButton.userInteractionEnabled = false;
                    
                    if ([[dict objectForKey:@"NutritionProgram"]boolValue]) {
                        [cell.nutritionButton setTitle:@"Yes" forState:UIControlStateNormal];
                        [cell.shoppingButton setTitle:@"Yes" forState:UIControlStateNormal];
                    }else{
                        [cell.nutritionButton setTitle:@"" forState:UIControlStateNormal];
                        [cell.shoppingButton setTitle:@"" forState:UIControlStateNormal];
                    }
                }else{
                    cell.nutritionCurrenDateView.hidden = true;
                    cell.shoppingCurrentDateView.hidden = true;
                    cell.nutritionButton.userInteractionEnabled = false;
                    cell.shoppingButton.userInteractionEnabled = false;
                }
                
                if (![Utility isEmptyCheck:[dict objectForKey:@"ExerciseProgram"]]) {
                    cell.execiseCurrentDateView.hidden = true;
                    cell.exerciseButton.userInteractionEnabled = false;
                    if ([[dict objectForKey:@"ExerciseProgram"]boolValue]) {
                        [cell.exerciseButton setTitle:@"Yes" forState:UIControlStateNormal];
                    }else{
                        [cell.exerciseButton setTitle:@"" forState:UIControlStateNormal];
                    }
                }else{
                    cell.execiseCurrentDateView.hidden = true;
                    cell.exerciseButton.userInteractionEnabled = false;
                }
            }else{
//                if ([[dict objectForKey:@"ExerciseProgram"]boolValue]) {
                    cell.execiseCurrentDateView.hidden = false;
                    cell.exerciseButton.userInteractionEnabled = true;
                    cell.exerciseButton.tag= indexPath.row;
                    [cell.exerciseButton setTitle:@"" forState:UIControlStateNormal];
//                }
                
//                if ([[dict objectForKey:@"NutritionProgram"]boolValue]) {
                    cell.nutritionCurrenDateView.hidden = false;
                    cell.nutritionButton.userInteractionEnabled =true;
                    cell.nutritionButton.tag = indexPath.row;
                    [cell.nutritionButton setTitle:@"" forState:UIControlStateNormal];
                
                
                cell.shoppingCurrentDateView.hidden = false;
                cell.shoppingButton.userInteractionEnabled =true;
                cell.shoppingButton.tag = indexPath.row;
                [cell.shoppingButton setTitle:@"" forState:UIControlStateNormal];
                
                //Change_Feedback
                if (![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]]) {
                    cell.courseLabel.text = [dict objectForKey:@"CourseName"];
                    cell.courseArrow.hidden = false;
                    cell.courseArrowWidthConstant.constant = 6;
                    cell.courseButton.userInteractionEnabled = true;
                    cell.courseUnderlineView.hidden = false;
                }else{
                    cell.courseLabel.text = @"";
                    cell.courseArrow.hidden = true;
                    cell.courseArrowWidthConstant.constant = 0;
                    cell.courseButton.userInteractionEnabled = false;
                    cell.courseUnderlineView.hidden = true;
                } //Change_Feedback
                
//                }
            }
        }else{
            cell.mainView.backgroundColor = [Utility colorWithHexString:@"E425A0"];
            if (![Utility isEmptyCheck:[dict objectForKey:@"NutritionProgram"]]) {
                cell.nutritionCurrenDateView.hidden = true;
                cell.nutritionButton.userInteractionEnabled = false;
                
                cell.shoppingCurrentDateView.hidden = true;
                cell.shoppingButton.userInteractionEnabled = false;
                
                if ([[dict objectForKey:@"NutritionProgram"]boolValue]) {
                    [cell.nutritionButton setTitle:@"Yes" forState:UIControlStateNormal];
                    [cell.shoppingButton setTitle:@"Yes" forState:UIControlStateNormal];
                }else{
                    [cell.nutritionButton setTitle:@"" forState:UIControlStateNormal];
                    [cell.shoppingButton setTitle:@"" forState:UIControlStateNormal];
                }
            }else{
                cell.nutritionCurrenDateView.hidden = true;
                cell.nutritionButton.userInteractionEnabled = false;
                cell.shoppingCurrentDateView.hidden = true;
                cell.shoppingButton.userInteractionEnabled = false;
            }
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"ExerciseProgram"]]) {
                cell.execiseCurrentDateView.hidden = true;
                cell.exerciseButton.userInteractionEnabled = false;
                if ([[dict objectForKey:@"ExerciseProgram"]boolValue]) {
                    [cell.exerciseButton setTitle:@"Yes" forState:UIControlStateNormal];
                }else{
                    [cell.exerciseButton setTitle:@"" forState:UIControlStateNormal];
                }
            }else{
                cell.execiseCurrentDateView.hidden = true;
                cell.exerciseButton.userInteractionEnabled = false;
            }
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]]) {
                cell.courseLabel.text = [dict objectForKey:@"CourseName"];
            }else{
                cell.courseLabel.text = @"";
            }
            cell.courseArrow.hidden = true;
            cell.courseArrowWidthConstant.constant = 0;
            cell.courseButton.userInteractionEnabled = false;
            cell.courseUnderlineView.hidden = true;
        }//Change_Feedback
        
  
        
        if ([selectedIndexArray containsObject:[NSNumber numberWithInteger:indexPath.row]]){ //selectedIndex == indexPath.row if ([selectedIndexArray containsObject:[NSNumber numberWithInteger:sender.tag]]) {
            [cell.detailsStackView insertArrangedSubview:cell.startDescriptionView atIndex:0];
            [cell.detailsStackView insertArrangedSubview:cell.durationView atIndex:1];
            [cell.detailsStackView insertArrangedSubview:cell.exerciseView atIndex:2];
            [cell.detailsStackView insertArrangedSubview:cell.nutritionView atIndex:3];
            [cell.detailsStackView insertArrangedSubview:cell.shoppingView atIndex:4];
            [cell.detailsStackView insertArrangedSubview:cell.courseView atIndex:5];
            [cell.detailsStackView insertArrangedSubview:cell.actionView atIndex:6];
            
            cell.courseButton.tag = indexPath.row;
            cell.startButton.tag = indexPath.row;
            cell.deleteYesButton.tag = indexPath.row;
            
            cell.editButton.tag = indexPath.row;
            editProgramYesButton.tag = cell.editButton.tag;
            
            cell.cancelButton.tag = indexPath.row;
            cancelExerciseButton.tag = cell.cancelButton.tag;
            cancelNutritionButton.tag = cell.cancelButton.tag;
            commomCurrentDateButton.tag =cell.cancelButton.tag;
            commonNextDateButton.tag = cell.cancelButton.tag;
            cancelEntireProgramButton.tag = cell.cancelButton.tag;
            cell.clickHereButton.tag = indexPath.row;//Change_setprogram_feedback
            
            cell.plusMinusImage.image = [UIImage imageNamed:@"minus_setprogram.png"];
            [cell.programStack insertArrangedSubview:cell.detailsView atIndex:1];
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"Duration"]]) {
                cell.durationLabel.text = [@"" stringByAppendingFormat:@"%@ week",[dict objectForKey:@"Duration"]];
            }else{
                cell.durationLabel.text = @"";
            }
            //Change_Setprogram_feedback
            if (![Utility isEmptyCheck:[dict objectForKey:@"Description"]]) {
                cell.clickHereButton.hidden = false;
                cell.viewDescriptionHeightConstant.constant = 50;
            }else{
                cell.clickHereButton.hidden = true;
                cell.viewDescriptionHeightConstant.constant = 0;
            }
            //Change_Setprogram_feedback
           
//            [cell.actionStack removeArrangedSubview:cell.startView];
//            [cell.startView removeFromSuperview];

            [cell.actionStack removeArrangedSubview:cell.cancelButton];
            [cell.cancelButton removeFromSuperview];
            
            [cell.actionStack removeArrangedSubview:cell.editButton];
            [cell.editButton removeFromSuperview];
            
            [cell.actionStack removeArrangedSubview:cell.deleteButton];
            [cell.deleteButton removeFromSuperview];
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"StartDate"]] && ![Utility isEmptyCheck:[dict objectForKey:@"EndDate"]]) {
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
                [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                
                NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
                NSDate *currentDate = [dateFormat dateFromString:currentDateStr];
                
                NSDate *startDate = [dateFormat dateFromString:[dict objectForKey:@"StartDate"]];
                NSDate *endDate = [dateFormat dateFromString:[dict objectForKey:@"EndDate"]];
                
                if (!isComplete){
                    if (![Utility isEmptyCheck:[dict objectForKey:@"ExerciseCancelDate"]]) {
                        cell.exerciseCurrentDateViewLabel.hidden = false;
                        cell.exerciseCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"231F20"];
                        cell.exerciseCurrentDateViewLabel.text = @"Exercise Plan";
                        cell.exerciseCurrentDateViewArrowImage.hidden = true;
                        cell.exerciseCurrentDateViewUndelineView.hidden = true;
                        cell.exerciseButton.userInteractionEnabled = false;
                        
                        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                        NSDate *exerciseCancelDate = [dateFormat dateFromString:[dict objectForKey:@"ExerciseCancelDate"]];
                        //            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
                        [dateFormat setDateFormat:@"dd MMM YYYY"];
                        NSString *exerciseCancelDateStr = [dateFormat stringFromDate:exerciseCancelDate];
                        cell.exerciseCancelLabelHeight.constant = 15;
                        cell.execiseCancelLabel.hidden = false;
                        cell.execiseCancelLabel.text = [@"" stringByAppendingFormat:@"Reverted to custom from - %@",exerciseCancelDateStr];
                    }else{
                        cell.exerciseCancelLabelHeight.constant = 0;
                        cell.execiseCancelLabel.hidden = true;
                        
                        cell.exerciseCurrentDateViewLabel.hidden = false;
                        cell.exerciseCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                        cell.exerciseCurrentDateViewLabel.text = @"Go To Exercise Plan";
                        cell.exerciseCurrentDateViewArrowImage.hidden = false;
                        cell.exerciseCurrentDateViewUndelineView.hidden = false;
                        cell.exerciseButton.userInteractionEnabled = true;
                        
                    }
                }
      
                
                 if (!isComplete) {
                     if (![Utility isEmptyCheck:[dict objectForKey:@"NutritionCancelDate"]]) {
                         cell.mealPlanCurrentDateViewLabel.hidden = false;
                         cell.mealPlanCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"231F20"];
                         cell.mealPlanCurrentDateViewLabel.text = @"Meal Plan";
                         cell.mealPlanCurrentDateViewArrowImage.hidden = true;
                         cell.mealPlanCurrentDateViewUndelineView.hidden = true;
                         cell.nutritionButton.userInteractionEnabled = false;
                         
                         cell.shoppingCurrentDateView.hidden = false;
                         cell.shoppingListCurrentDateViewLabel.hidden = false;
                         cell.shoppingListCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"231F20"];
                         cell.shoppingListCurrentDateViewLabel.text = @"Shopping List";
                         cell.shoppingListCurrentDateViewArrowImage.hidden = true;
                         cell.shoppingListCurrentDateViewUndelineView.hidden = true;
                         cell.shoppingButton.userInteractionEnabled = false;
                         
                         
                         NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                         [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                         NSDate *nutritionCancelDate = [dateFormat dateFromString:[dict objectForKey:@"NutritionCancelDate"]];
                         //            [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
                         [dateFormat setDateFormat:@"dd MMM YYYY"];
                         NSString *nutritionCancelDateStr = [dateFormat stringFromDate:nutritionCancelDate];
                         cell.nutritionCancelLabelHeight.constant = 15;
                         cell.nutritionCancelLabel.hidden = false;
                         cell.nutritionCancelLabel.text = [@"" stringByAppendingFormat:@"Reverted to custom from - %@",nutritionCancelDateStr];
                         
                         cell.shoppingcancelLabel.hidden = false;
                         cell.shoppingCancelLabelHeight.constant = 15;
                         cell.shoppingcancelLabel.text = [@"" stringByAppendingFormat:@"Reverted to custom from - %@",nutritionCancelDateStr];
                     }else{
                         cell.mealPlanCurrentDateViewLabel.hidden = false;
                         cell.mealPlanCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                         cell.mealPlanCurrentDateViewLabel.text = @"Go To Meal Plan";
                         cell.mealPlanCurrentDateViewArrowImage.hidden = false;
                         cell.mealPlanCurrentDateViewUndelineView.hidden = false;
                         cell.nutritionButton.userInteractionEnabled = true;
                         
                         cell.shoppingCurrentDateView.hidden = false;
                         cell.shoppingListCurrentDateViewLabel.hidden = false;
                         cell.shoppingListCurrentDateViewLabel.textColor = [Utility colorWithHexString:@"E425A0"];
                         cell.shoppingListCurrentDateViewLabel.text = @"Go To Shopping List";
                         cell.shoppingListCurrentDateViewArrowImage.hidden = false;
                         cell.shoppingListCurrentDateViewUndelineView.hidden = false;
                         cell.shoppingButton.userInteractionEnabled = true;
                         
                         cell.nutritionCancelLabelHeight.constant = 0;
                         cell.nutritionCancelLabel.hidden = true;
                         
                         cell.shoppingCancelLabelHeight.constant = 0;
                         cell.shoppingcancelLabel.hidden = true;
                         
                     }
                 }
                
            
                
                bool issameDate =  [Utility date:currentDate isBetweenDate:startDate andDate:endDate];
                if (issameDate) {
                     cell.actionView.hidden = false;
                    cell.startButton.hidden = true;
                    cell.startButtonHeightConstant.constant = 0;

                    if ([Utility isEmptyCheck:[dict objectForKey:@"Description"]]) {
                        [cell.detailsStackView removeArrangedSubview:cell.startDescriptionView];
                        [cell.startDescriptionView removeFromSuperview];
                    }else{
                        [cell.detailsStackView insertArrangedSubview:cell.startDescriptionView atIndex:0];
                    }
                    
//                     if ([[dict objectForKey:@"ExerciseProgram"]boolValue]) {
//                         cell.execiseCurrentDateView.hidden = false;
//                         cell.exerciseButton.userInteractionEnabled = true;
//                         [cell.exerciseButton setTitle:@"" forState:UIControlStateNormal];
//                     }
//
//                    if ([[dict objectForKey:@"NutritionProgram"]boolValue]) {
//                        cell.nutritionCurrenDateView.hidden = false;
//                        cell.nutritionButton.userInteractionEnabled =true;
//                        [cell.nutritionButton setTitle:@"" forState:UIControlStateNormal];
//                    }
                    
                    [cell.actionStack insertArrangedSubview:cell.cancelButton atIndex:0];
                    
                }else{
//                    cell.exerciseButton.userInteractionEnabled = false;
//                    cell.execiseCurrentDateView.hidden = false;
//
//                    cell.exerciseCancelLabelHeight.constant = 15;
//                    cell.execiseCancelLabel.hidden = false;
//
//                    cell.nutritionCancelLabelHeight.constant = 15;
//                    cell.nutritionCancelLabel.hidden = false;
                    
                    cell.startButton.hidden = true;
                    cell.startButtonHeightConstant.constant = 0;
                    if ([Utility isEmptyCheck:[dict objectForKey:@"Description"]]) {
                        [cell.detailsStackView removeArrangedSubview:cell.startDescriptionView];
                        [cell.startDescriptionView removeFromSuperview];
                    }else{
                        [cell.detailsStackView insertArrangedSubview:cell.startDescriptionView atIndex:0];
                    }
                   
                    //Change_Feedback
                    if(!isComplete){
//                        cell.courseLabel.text = @"";
//                        cell.courseArrow.hidden = true;
//                        cell.courseArrowWidthConstant.constant = 0;
//                        cell.courseButton.userInteractionEnabled = false;
//                        cell.courseUnderlineView.hidden = true;
                        cell.actionView.hidden = false;
//                        [cell.detailsStackView insertArrangedSubview:cell.startDescriptionView atIndex:0];
                        [cell.actionStack insertArrangedSubview:cell.editButton atIndex:0];
                        [cell.actionStack insertArrangedSubview:cell.deleteButton atIndex:1];
                    }else{
                        if (![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]]) {
                            cell.courseLabel.text = [dict objectForKey:@"CourseName"];
                        }else{
                            cell.courseLabel.text = @"";
                        }
                       
                        cell.courseArrow.hidden = true;
                        cell.courseArrowWidthConstant.constant = 0;
                        cell.courseButton.userInteractionEnabled = false;
                        cell.courseUnderlineView.hidden = true;
                        cell.actionView.hidden = true;
                        
                        [cell.detailsStackView removeArrangedSubview:cell.startDescriptionView];
                        [cell.startDescriptionView removeFromSuperview];
                    }
                    //Change_Feedback
                }
            }else{
//                [cell.actionStack insertArrangedSubview:cell.startView atIndex:0];
                cell.actionView.hidden = true;
                [cell.detailsStackView insertArrangedSubview:cell.startDescriptionView atIndex:0];
                cell.startButton.hidden = false;
                cell.startButtonHeightConstant.constant = 106;
                
            }
        }else{
            cell.plusMinusImage.image = [UIImage imageNamed:@"plus_setprogram.png"];
            
//            cell.exerciseButton.userInteractionEnabled = true;
//            [cell.exerciseButton setTitle:@"" forState:UIControlStateNormal];
//            cell.execiseCurrentDateView.hidden = false;
//            cell.nutritionButton.userInteractionEnabled = true;
//            [cell.nutritionButton setTitle:@"" forState:UIControlStateNormal];
//            cell.nutritionCurrenDateView.hidden = false;
            
            //Change_Feedback
            if(!isComplete){
//                cell.courseLabel.text = @"";
//                cell.courseArrow.hidden = true;
//                cell.courseArrowWidthConstant.constant = 0;
//                cell.courseButton.userInteractionEnabled = false;
//                cell.courseUnderlineView.hidden = true;
                
            }else{
                if (![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]]) {
                    cell.courseLabel.text = [dict objectForKey:@"CourseName"];
                }else{
                    cell.courseLabel.text = @"";
                }
                cell.courseArrow.hidden = true;
                cell.courseArrowWidthConstant.constant = 0;
                cell.courseButton.userInteractionEnabled = false;
                cell.courseUnderlineView.hidden = true;
            }
              
            //Change_Feedback
            
            [cell.programStack removeArrangedSubview:cell.detailsView];
            [cell.detailsView removeFromSuperview];
        }
    }
    
   return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
#pragma mark - End

#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@\n%@",date,[defaults objectForKey:@"Timezone"]);
    if (date) {
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        
        //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        selectedDate = date;
        if ([self getCurrentStartWeekDay]) {
            [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            [editProgramDateButton setTitle:dateString forState:UIControlStateNormal];
        }else{
            [Utility msg:@"Please select first day of week" title:@"" controller:self haveToPop:NO];
        }
    }
}
@end
