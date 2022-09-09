//
//  CustomNutritionPlanListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CustomNutritionPlanListViewController.h"
#import "CustomNutritionPlanListCollectionViewCell.h"
#import "CustomNutritionPlanListBlankCollectionViewCell.h"
#import "CustomNutritionPlanListHeaderCollectionReusableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddEditCustomNutritionViewController.h"
#import "SwapMealViewController.h"
#import "LegendViewController.h"
#import "ChooseGoalViewController.h"
#import "NutritionSettingHomeViewController.h"

#import "CustomNutritionPlanListTableViewCell.h"
#import "CustomNutritionPlanListInnerCollectionViewCell.h"
#import "CustomNutritionPlanListCollectionViewController.h"
#import "SavedNutritionPlanViewController.h"

@interface CustomNutritionPlanListViewController (){
    IBOutlet UICollectionView *collection;
    IBOutlet UILabel *blankMsgLabel;
    IBOutlet UILabel *bgMsgLabel;

    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *previousButton;
    IBOutlet UILabel *weekDateLabel;
    
    IBOutlet UIView *countDownView;
    IBOutlet UILabel *countDownLabel;
    IBOutlet UIButton *shoppingListButton;
    IBOutlet UIButton *customShoppingListButton;
    IBOutlet UIButton *addCustomShoppingListButton;
    IBOutlet UIButton *saveCustomShoppingList;
    IBOutletCollection(UIView) NSArray *shoppingButtonCollection;
    
    NSTimer *countDownTimer;
    
    NSMutableArray *nutritionPlanListArray;
    NSMutableArray *myFavrtPlanList;
    UIView *contentView;
    
    NSDate *beginningOfWeekDate;
    NSDate *joiningDate;
    int apiCount;
    NSDateFormatter *dailyDateformatter;
    NSArray *squadUserDailySessionsArray;
    NSDictionary *mealFrequencyDict;
    BOOL haveToCallGenerateMeal;
    NSMutableArray *squadCustomMealSessionList;
    NSArray *tempShoppingList;

    IBOutlet UIImageView *legendImage;
    //shabbir 16/01
    IBOutlet UIButton *gridButton;
    IBOutlet UIButton *listButton;
    IBOutlet UIButton *favButton;
    IBOutlet UITableView *table;
    IBOutlet UICollectionView *innerCollection;
    IBOutlet UIButton * trackCalorie;
    IBOutlet UIButton * shopList;
    IBOutlet UIButton * foodPrep;
    IBOutlet UIView *myContainer;
    IBOutlet UIView *myFavView;
    IBOutlet UITableView *myFavTable;
    
    int dayNumber;
    BOOL isFirstTime;
    int activeCustomRowNumber;
    int editRowNumber;
    int rowNumber;
    int sectionNumber;
    BOOL shopPopUP;
    BOOL isFav;
    BOOL isCollection;
    NSIndexPath *myIndexPath;
    
    BOOL isCustom;
    BOOL isAllCustom;
    
    NSString *programName; //SetProgram_In
    NSString *weekNumber;//SetProgram_In
    
    IBOutlet NSLayoutConstraint *shopListViewHeight;
    IBOutlet NSLayoutConstraint *emptySpaceHeight;
    IBOutlet UIImageView *shopCountImage;
    IBOutlet UILabel *shopCountLabel;
    IBOutlet UIImageView *inShopCountImage;
    IBOutlet UILabel *inShopCountLabel;
    IBOutlet UIButton *viewCustomShopListButton;
    IBOutlet UIButton *weeklyShopListButton;
    IBOutlet UIView *setprogramRevertView; //Today_SetProgram_In
    IBOutlet NSLayoutConstraint *setprogramRevertHeightConstant; //Today_SetProgram_In
    IBOutlet UITextView *revertTextView; //Today_SetProgram_In
    NSString *UserProgramIdStr;//Today_SetProgram_In
    NSString *ProgramIdStr;//Today_SetProgram_In
    BOOL isLoadController;
    
    __weak IBOutlet UILabel *swapMealNameLabel;
    
    NSMutableArray *savedMealPlanArray;
    __weak IBOutlet UIView *saveMealPlanView;
    __weak IBOutlet UITextField *saveMealTextField;
    __weak IBOutlet UIButton *swapMealPlanButton;
    __weak IBOutlet UITextView *saveMealTextView;
    NSMutableDictionary *savedPlanDict;
    UIToolbar *toolBar;
    __weak IBOutlet UILabel *mealPlanLabel;
    NSNumber *planId;
    BOOL isMealPlanChanged;
    int mealPlanNumber;//1 save, 2 save(update), 3 save as(new create)
}

@end

@implementation CustomNutritionPlanListViewController
@synthesize isComplete,stepnumber,weekDate,fromSetProgram,currentDate;
#pragma mark -Private Method
-(void)save:(NSMutableArray *)avoidAllArray{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:avoidAllArray forKey:@"AvoidMealData"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->collection.hidden = true;
            self->blankMsgLabel.hidden = false;
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AvoidMealDataApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
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
-(void)updateView{
    //to show or hide previous next button
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    /*
    //SetProgram_In
    if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:weekNumber]) {
        weekDateLabel.text = [@"" stringByAppendingFormat:@"%@ - Week %@",programName,weekNumber];
    }else{
        if ([[formatter stringFromDate:beginningOfWeekDate] isEqualToString:[formatter stringFromDate:weekDate]]) {
            weekDateLabel.text = @"CURRENT WEEK";
        }else{
            weekDateLabel.text = [@"WEEK - " stringByAppendingFormat:@"%@",[formatter stringFromDate:weekDate] ];
        }
    }//SetProgram_In
 */
    
    if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr]) {
        weekDateLabel.text = [@"" stringByAppendingFormat:@"%@ - Week %@",programName,weekNumber];
        setprogramRevertView.hidden = false;
        setprogramRevertHeightConstant.constant = 60;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName]];
        NSRange range = [[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName] rangeOfString: @"Revert to Custom Plan"];
        NSRange range1 =[[@"" stringByAppendingFormat:@"Following plan is based on %@ Revert to Custom Plan",programName] rangeOfString: programName];
        
        [text addAttribute:NSLinkAttributeName value:@"Revert://" range:NSMakeRange(range.location, range.length)];
        
        [text addAttribute:NSUnderlineStyleAttributeName
                     value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                     range:NSMakeRange(range.location, range.length)];
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentCenter;
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:13.0],
                                   NSForegroundColorAttributeName : [UIColor grayColor],
                                   NSParagraphStyleAttributeName:paragraphStyle
                                   };
        [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:13] range:NSMakeRange(range1.location,range1.length)];
        
        
        revertTextView.attributedText = text;
        revertTextView.editable = NO;
        revertTextView.delaysContentTouches = NO;
        
    }else{
        setprogramRevertView.hidden = true;
        setprogramRevertHeightConstant.constant = 0;
        if ([[formatter stringFromDate:beginningOfWeekDate] isEqualToString:[formatter stringFromDate:weekDate]]) {
            weekDateLabel.text = @"CURRENT WEEK";
        }else{
            weekDateLabel.text = [@"WEEK - " stringByAppendingFormat:@"%@",[formatter stringFromDate:weekDate] ];
        }
        revertTextView.text= @"";
    }//Today_SetProgram_In
    
    NSTimeInterval sixmonth = 13*24*60*60;
    NSDate *endDate = [beginningOfWeekDate
                       dateByAddingTimeInterval:sixmonth];
    NSDate *nxtDate = [weekDate dateByAddingTimeInterval:7*24*60*60];
    if ([endDate compare:nxtDate] == NSOrderedDescending || [endDate compare:nxtDate] == NSOrderedSame) {
        nextButton.hidden = false;
    }else{
        nextButton.hidden = true;
    }
    NSDate *prevDate = [weekDate dateByAddingTimeInterval:-7*24*60*60];
    if ([joiningDate compare:prevDate] == NSOrderedAscending || [joiningDate compare:prevDate] == NSOrderedSame) {
        previousButton.hidden = false;
    }else{
        previousButton.hidden = true;
    }
}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
   // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    //create date on week start
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:(0 - ([comps weekday] - weekOffset))];
    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[formatter stringFromDate:nextDate ]];
        // shabbir
        NSDate* today = [NSDate date] ;
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *tempDate = [formatter stringFromDate:nextDate];
        NSString *sToday = [formatter stringFromDate:today];
        if (isFirstTime) {
            if (currentDate && [tempDate isEqualToString:[formatter stringFromDate:currentDate]]) {
                dayNumber = i;
                isFirstTime = false;
            }else if([tempDate isEqualToString:sToday]){
                dayNumber = i;
                isFirstTime = false;
            }
        }
        
        //
    }
    return [NSArray arrayWithArray:week];
}
-(void)saveSquadUserSessionCountApiCall:(int)index sessionDate:(NSDate *)sessionDate{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (sessionDate) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString = [formatter stringFromDate:sessionDate];
            if (![Utility isEmptyCheck:dateString]) {
                [mainDict setObject:dateString forKey:@"SessionDate"];
            }
        }
        [mainDict setObject:[NSNumber numberWithInt:index] forKey:@"NoOfSessions"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            [self.view bringSubviewToFront:self->countDownView];

        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveSquadUserSessionCountApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                          [[NSNotificationCenter defaultCenter]postNotificationName:@"savedumble" object:self];
                                                                         [self getSquadMealPlanWithSettings];
                                                                         
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


-(void)deleteMealApiCall:(NSNumber *)mealSessionId{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            [self.view bringSubviewToFront:self->countDownView];

        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadRemoveUserMealSessionApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
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
-(void)repeatMealApiCall:(NSNumber *)mealSessionId repeat:(NSNumber *)repeat{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:mealSessionId forKey:@"MealSessionId"];
        [mainDict setObject:repeat forKey:@"Repeat"];

        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            //contentView = [Utility activityIndicatorView:self withMsg:@"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan." font:[UIFont fontWithName:@"Raleway-SemiBold" size:16] color:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];

            [self.view bringSubviewToFront:self->countDownView];

        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadRepeatMealNextWeekApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
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
-(void)generateSquadUserMealPlans:(NSNumber *)stepNumberForGenerateMeal{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"RunDate"];
        }
        [mainDict setObject:stepNumberForGenerateMeal forKey:@"exerciseStep"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
         });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GenerateSquadUserMealPlansApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->haveToCallGenerateMeal = YES;
                                                                         [self getSquadMealPlanWithSettings];
                                                                     
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

-(void)getSquadMealPlanWithSettings{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"WeekDate"];
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"UserSessionStartSessionDate"];
            NSDate *nxtDate = [weekDate dateByAddingTimeInterval:6*24*60*60];
            [mainDict setObject:[dailyDateformatter stringFromDate:nxtDate ] forKey:@"UserSessionEndSessionDate"];

        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        [self->nutritionPlanListArray removeAllObjects];
        self->isCustom = false;
        self->isAllCustom = false;
        [self->squadCustomMealSessionList removeAllObjects];
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            [Utility stopFlashingbutton:self->saveCustomShoppingList];

            self->collection.hidden = true;
            self->table.hidden = true;
            self->myFavView.hidden = true;
            self->myContainer.hidden = true;
            self->blankMsgLabel.hidden = false;
//            self->saveCustomShoppingList.hidden = true;
            //contentView = [Utility activityIndicatorView:self withMsg:@"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan." font:[UIFont fontWithName:@"Raleway-SemiBold" size:16] color:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1]];
            self->contentView = [Utility activityIndicatorView:self];
            if(self->_isFromShoppingList)
                self->blankMsgLabel.text = @"";
            else
                self->blankMsgLabel.text = @"Don’t forget to watch the Nourish ‘How To’ video to learn how to get the most of your custom plan.";
//            self->contentView.backgroundColor = [UIColor clearColor];
            [self.view bringSubviewToFront:self->countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadMealPlanWithSettingsApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"] ]) {
                                                                             NSDate *date = [self->dailyDateformatter dateFromString:responseDict[@"WeekStartDate"]];
                                                                             if (date) {
                                                                                 //savemealplan name
                                                                                 [self updateSavedMealPlanView:responseDict];
                                                                                 //end
                                                                                 self->joiningDate = date;
                                                                                 //SetProgram_In
                                                                                 if (![Utility isEmptyCheck:responseDict[@"MealPlanResponse"]]) {
                                                                                     NSDictionary *dict = responseDict[@"MealPlanResponse"];
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramName"]]) {
                                                                                         self->programName = [dict objectForKey:@"ProgramName"];
                                                                                     }else{
                                                                                         self->programName = @"";
                                                                                     }
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"WeekNumber"]]) {
                                                                                         self->weekNumber = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"WeekNumber"]];
                                                                                     }else{
                                                                                         self->weekNumber =@"";
                                                                                     }
                                                                                     //Today_SetProgram_In
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"UserProgramId"]]) {
                                                                                         self->UserProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"UserProgramId"]];
                                                                                     }else{
                                                                                         self->UserProgramIdStr = @"";
                                                                                     }
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ProgramId"]]) {
                                                                                         self->ProgramIdStr = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProgramId"]];
                                                                                     }else{
                                                                                         self->ProgramIdStr = @"";
                                                                                     }
                                                                                 }//SetProgram_In
                                                                                 [self updateView];
                                                                                 //add_su_3/8/17
                                                                                 NSTimeInterval secondWeekStart = 14*24*60*60;
                                                                                 NSDate *secondJoiningStart = [self->joiningDate
                                                                                                               dateByAddingTimeInterval:secondWeekStart];
                                                                                 
                                                                                 NSDate *secondJoiningEnd = [self->joiningDate
                                                                                                             dateByAddingTimeInterval:secondWeekStart+6*24*60*60];
                                                                                 
                                                                                 
                                                                                 NSTimeInterval fifthWeek = 35*24*60*60;
                                                                                 NSDate *fifthJoiningStart = [self->joiningDate
                                                                                                              dateByAddingTimeInterval:fifthWeek];
                                                                                 
                                                                                 NSDate *fifthJoiningEnd = [self->joiningDate
                                                                                                            dateByAddingTimeInterval:fifthWeek+6*24*60*60];
                                                                                 
                                                                                 if ([self->weekDate compare:secondJoiningStart] == NSOrderedDescending && [self->weekDate compare:secondJoiningEnd] == NSOrderedAscending) {
                                                                                     
                                                                                 }else if ([self->weekDate compare:fifthJoiningStart] == NSOrderedDescending && [self->weekDate compare:fifthJoiningEnd] == NSOrderedAscending){
                                                                                     
                                                                                 }
                                                                                 //
                                                                                 if (![Utility isEmptyCheck:responseDict[@"UserMealFrequency"]]) {
                                                                                     self->mealFrequencyDict=responseDict[@"UserMealFrequency"];
                                                                                 }

                                                                                 
                                                                                 if (![Utility isEmptyCheck:responseDict[@"UserSessionCountList"]]) {
                                                                                     self->squadUserDailySessionsArray = responseDict[@"UserSessionCountList"];

                                                                                 }
                                                                                 if (![Utility isEmptyCheck:responseDict[@"MealPlanResponse"]]) {
                                                                                     NSDictionary *mealPlanResponse = responseDict[@"MealPlanResponse"];
                                                                                     if (![Utility isEmptyCheck:mealPlanResponse] && [mealPlanResponse[@"Success"] boolValue]) {
                                                                                         NSArray *rawNutritionDataArray = [mealPlanResponse[@"SquadMealSessions"] mutableCopy];
                                                                                         if (![Utility isEmptyCheck:rawNutritionDataArray] && rawNutritionDataArray.count > 0) {
                                                                                             NSArray *uniqueDates = [rawNutritionDataArray valueForKeyPath:@"@distinctUnionOfObjects.MealDate"];
                                                                                             NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                                                                                                          ascending:YES];
                                                                                             NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                                                                                             NSArray *sortedArray = [uniqueDates sortedArrayUsingDescriptors:sortDescriptors];
                                                                                             NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                                             formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                                                                                             //[formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
                                                                                             if (sortedArray.count > 0) {
                                                                                                 NSString *sessionDate =[sortedArray objectAtIndex:0];
                                                                                                 if (![Utility isEmptyCheck:sessionDate]) {
                                                                                                     NSDate *fstDate = [formatter dateFromString:sessionDate ];
                                                                                                     NSArray *weekDayArray = [self daysInWeek:2 fromDate:fstDate];
                                                                                                     for (NSString *date in weekDayArray) {
                                                                                                         NSArray *filteredarray = [rawNutritionDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealDate == %@)", date]];
                                                                                                         if (filteredarray.count > 0) {
                                                                                                             [self->nutritionPlanListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredarray,@"mealData",date,@"day", nil]];
                                                                                                         }else{
                                                                                                             [self->nutritionPlanListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc]init],@"mealData",date,@"day", nil]];
                                                                                                         }
                                                                                                     }
                                                                                                     if (self->nutritionPlanListArray.count > 0){
                                                                                                        
                                                                                                         //shabbir
                                                                                                         self->myFavrtPlanList = [[NSMutableArray alloc]init];
                                                                                                         NSMutableArray *tempFavArray = [[rawNutritionDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavorite == true)"]]mutableCopy];
                                                                                                         NSArray *uniqueId = [tempFavArray  valueForKeyPath:@"@distinctUnionOfObjects.MealId"];
                                                                                                    
                                                                                                         for (NSNumber *mealId in uniqueId) {
                                                                                                             NSArray *filteredarray = [tempFavArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(MealId == %@)", mealId]];
                                                                                                             if (filteredarray.count > 0) {
                                                                                                                 [self->myFavrtPlanList addObject:[filteredarray objectAtIndex:0]];
                                                                                                             }
                                                                                                         }
                                                                                                         
                                                                                                         [self->myFavTable reloadData];
                                                                                                         if (self->isFav) {
                                                                                                             self->listButton.selected = false;
                                                                                                             self->gridButton.selected = false;
                                                                                                             self->favButton.selected = true;
                                                                                                             self->myFavView.hidden = false;
                                                                                                         }else if(self->isCollection){
                                                                                                             self->listButton.selected = false;
                                                                                                             self->gridButton.selected = true;
                                                                                                             self->favButton.selected = false;
                                                                                                             self->myFavView.hidden = true;
                                                                                                             self->table.hidden = true;
                                                                                                             self->myContainer.hidden = false;
                                                                                                         }
                                                                                                         //collection.hidden = false;
                                                                                                         if (self->isCollection) {
                                                                                                             self->table.hidden = true;
                                                                                                         }else{
                                                                                                             self->table.hidden = false;
                                                                                                         }
                                                                                                         
                                                                                                         self->blankMsgLabel.hidden = true;
                                                                                                         [self->innerCollection reloadData];
                                                                                                         [self->table reloadData];
                                                                                                         [self getSquadCustomMealSession];
//                                                                                                         [self getSavedMealPlanUsage];
                                                                }
                                                                                                     if (self->apiCount == 0) {
                                                                                                         //[collection reloadData];
                                                                                                         if (self->_isFromShoppingList) {
                                                                                                             self->_isFromShoppingList = false;
                                                                                                             self->listButton.selected = false;
                                                                                                             self->gridButton.selected = true;
                                                                                                             self->favButton.selected = false;
                                                                                                             self->isCollection = true;
                                                                                                             self->table.hidden = true;
                                                                                                             self->myContainer.hidden = false;
                                                                                                             self->myFavView.hidden = true;
                                                                                                             
//                                                                                                             [self getSquadCustomMealSession];
                                                                                                         }
                                                                                                     }
                                                                                                 }else{
                                                                                                     [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                                     return;
                                                                                                 }
                                                                                             }else{
                                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                                 return;
                                                                                             }
                                                                                             
                                                                                         }else{
                                                                                             if (![Utility isEmptyCheck:[responseDict objectForKey:@"NourishSettingsStep"]] && [[responseDict objectForKey:@"NourishSettingsStep"] isEqual:@0]) {
                                                                                                 if (self->haveToCallGenerateMeal) {
                                                                                                     [self generateSquadUserMealPlans:[responseDict objectForKey:@"NourishSettingsStep"]];
                                                                                                 }
                                                                                             }else{
                                                                                                 [Utility msg:@"Please setup your Meal Plan" title:@"Warning!" controller:self haveToPop:NO];
                                                                                                 return;
                                                                                             }
                                                                                         }
                                                                                     }else{
                                                                                        // [collection reloadData];
                                                                 
                                                                                         [Utility msg:mealPlanResponse[@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                                         return;
                                                                                     }
                                                                                 }
                                                                             }
                                                                         }else{
                                                                             [self notLoadAlert];
                                                                           
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
-(void)getSquadCustomMealSession{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"SessionDate"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
//            self->contentView.backgroundColor = [UIColor clearColor];
            [self.view bringSubviewToFront:self->countDownView];
            
        });
//        squadCustomMealSessionList = [[NSMutableArray alloc]init];
//        tempShoppingList = [[NSArray alloc]init];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCustomMealSessionApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         NSArray *shoppings = responseDict[@"SquadCustomMealSessionList"];
                                                                         if(![Utility isEmptyCheck:shoppings]){//it is because duplicate is coming from android
                                                                             NSMutableArray *tempControllers = [NSMutableArray new];
                                                                             NSMutableArray *uniqueController = [NSMutableArray new];
                                                                             for (NSDictionary *controller in [shoppings reverseObjectEnumerator]) {
                                                                                 int noServe = ![Utility isEmptyCheck:[controller objectForKey:@"NoofServe"]]?[[controller objectForKey:@"NoofServe"]intValue]:0;
                                                                                 NSString *stringVC = [controller objectForKey:@"MealSessionId"];
                                                                                 if (![tempControllers containsObject:stringVC] && noServe>0) {
                                                                                     [tempControllers addObject:stringVC];
                                                                                     [uniqueController addObject:controller];
                                                                                 }
                                                                             }
                                                                             shoppings = [[uniqueController reverseObjectEnumerator] allObjects];
                                                                         }
                                                                         
                                                                         self->squadCustomMealSessionList = [shoppings mutableCopy];
                                                                         self->tempShoppingList = shoppings;
                                                                         [self updateShoplistButton];
                                                                         
                                                                         if (self->nutritionPlanListArray.count>0) {
                                                                             [self->table reloadData];
                                                                             [self->myFavTable reloadData];
                                                                             self->countDownView.hidden = true;
                                                                             if (self->countDownTimer.isValid) {
                                                                                 [self->countDownTimer invalidate];
                                                                             }
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
-(BOOL)checkCustomShoppinListChange{
    BOOL notMatched = false;
    if (tempShoppingList.count == squadCustomMealSessionList.count) {
        for (NSDictionary *mealData in squadCustomMealSessionList) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            NSArray *filteredArray = [tempShoppingList filteredArrayUsingPredicate:predicate];
            if (filteredArray.count >0) {
                if (![filteredArray[0][@"NoofServe"] isEqualToNumber:mealData[@"NoofServe"]]) {
                    notMatched = true;
                    break;
                }
            }else{
                notMatched = true;
                break;
            }
        }
    }else{
        notMatched = true;
    }
    if (notMatched) {
//        saveCustomShoppingList.hidden = false;
//        saveCustomShoppingList.selected = true;
//        [Utility startFlashingbutton:saveCustomShoppingList];
    }else{
//        saveCustomShoppingList.hidden = false;
//        saveCustomShoppingList.selected = false;
//        [Utility stopFlashingbutton:saveCustomShoppingList];
    }
    [table reloadData];
    return notMatched;
}
-(void)shoppingButtonFlashCheck:(BOOL)notMatched{
    if (!gridButton.isSelected) {
        return;
    }
    if (notMatched) {
        saveCustomShoppingList.hidden = false;
        saveCustomShoppingList.selected = true;
        [Utility startFlashingbutton:saveCustomShoppingList];
    }else{
//        saveCustomShoppingList.hidden = true;
        saveCustomShoppingList.hidden = true;
        saveCustomShoppingList.selected = true;//false;
        [Utility stopFlashingbutton:saveCustomShoppingList];
    }
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    response(YES);
//    if (!saveCustomShoppingList.hidden) {
//        UIAlertController *alertController = [UIAlertController
//                                              alertControllerWithTitle:@"Save Changes"
//                                              message:@"Your changes will be lost if you don’t save them."
//                                              preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *okAction = [UIAlertAction
//                                   actionWithTitle:@"Save"
//                                   style:UIAlertActionStyleDefault
//                                   handler:^(UIAlertAction *action)
//                                   {
//                                       [saveCustomShoppingList sendActionsForControlEvents:UIControlEventTouchUpInside];
//                                       response(NO);
//                                   }];
//        UIAlertAction *cancelAction = [UIAlertAction
//                                       actionWithTitle:@"Don't Save"
//                                       style:UIAlertActionStyleDefault
//                                       handler:^(UIAlertAction *action)
//                                       {
//                                           squadCustomMealSessionList = [[NSMutableArray alloc]init];
//                                           tempShoppingList = [[NSArray alloc]init];
//                                           response(YES);
//                                       }];
//        [alertController addAction:okAction];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//    } else {
//        squadCustomMealSessionList = [[NSMutableArray alloc]init];
//        tempShoppingList = [[NSArray alloc]init];
//        response(YES);
//    }
}
-(void)updateShoplistButton{
    if (squadCustomMealSessionList.count>0) {
//        NSInteger noofServe = [[squadCustomMealSessionList valueForKeyPath:@"@sum.NoofServe"] intValue];
        int noofServe = 0;
        if (nutritionPlanListArray.count>0) {
            for (int i=0;i<nutritionPlanListArray.count;i++) {
                NSDictionary *dict = nutritionPlanListArray[i];
                NSArray *mealDataArray = dict[@"mealData"];
                int j = (int)mealDataArray.count;
                for (int k=0; k<j; k++) {
                    NSDictionary *mealData = mealDataArray[k];
                    if (![Utility isEmptyCheck:mealData]) {
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                        if (filteredArray.count > 0){
                            NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                            noofServe += [temp[@"NoofServe"] intValue];
                        }
                    }
                }
            }
        }
        
        if (noofServe>0) {
            BOOL isHidden = true;
            for (UIView *view in shoppingButtonCollection) {
                if (view.tag == 0) {
                    isHidden = view.isHidden;
                    break;
                }
            }
            if (!isHidden) {
                shopCountImage.hidden = true;
                shopCountLabel.hidden = true;
                shopCountLabel.text = @"";
                inShopCountImage.hidden = false;
                inShopCountLabel.hidden = false;
                inShopCountLabel.text = [NSString stringWithFormat:@"%ld",(long)noofServe];
            }else{
                shopCountImage.hidden = false;
                shopCountLabel.hidden = false;
                shopCountLabel.text = [NSString stringWithFormat:@"%ld",(long)noofServe];
                inShopCountImage.hidden = true;
                inShopCountLabel.hidden = true;
                inShopCountLabel.text = @"";
            }
        } else {
            shopCountImage.hidden = true;
            shopCountLabel.hidden = true;
            inShopCountImage.hidden = true;
            inShopCountLabel.hidden = true;
            shopCountLabel.text = @"";
            inShopCountLabel.text = @"";
        }
    }else {
        shopCountImage.hidden = true;
        shopCountLabel.hidden = true;
        inShopCountImage.hidden = true;
        inShopCountLabel.hidden = true;
        shopCountLabel.text = @"";
        inShopCountLabel.text = @"";
    }
}
-(void)favoriteMealToggleApiCall:(NSNumber *)mealId{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        //        if (weekDate) {
        //            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"RunDate"];
        //        }
        [mainDict setObject:mealId forKey:@"MealId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteMealToggle" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         NSLog(@"%@", responseDict);
                                                                         [self getSquadMealPlanWithSettings];
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
//save meal plan apis
-(void)saveMealPlanApiCall{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:saveMealTextField.text forKey:@"Name"];
        [mainDict setObject:saveMealTextView.text forKey:@"Description"];
        
        [mainDict setObject:nutritionPlanListArray[0][@"day"] forKey:@"WeekStart"];
        [mainDict setObject:nutritionPlanListArray[6][@"day"] forKey:@"WeekEnd"];
        [mainDict setObject:mealFrequencyDict[@"MealCount"] forKey:@"MealFreq"];
        [mainDict setObject:mealFrequencyDict[@"SnackCount"] forKey:@"SnackFreq"];
        if (mealPlanNumber == 2) {
            [mainDict setObject:savedPlanDict[@"Id"] forKey:@"Id"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadUserSavedMealPlan" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@""
                                                                                                               message:@"Meal plan saved Successfully"
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"Ok"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                        self->saveMealPlanView.hidden = true;
                                                                                                    }];
                                                                         [alertController addAction:okAction];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
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
//-(void)GetSquadUserSavedMealPlan{
//    if (Utility.reachable) {
//
//        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
//        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
//
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
////        dispatch_async(dispatch_get_main_queue(), ^{
////            self->apiCount++;
////            if (self->contentView) {
////                [self->contentView removeFromSuperview];
////            }
////        });
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserSavedMealPlan" append:@""forAction:@"POST"];
//
//        NSURLSession *loginSession = [NSURLSession sharedSession];
//        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
//                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                             dispatch_async(dispatch_get_main_queue(), ^{
////                                                                 self->apiCount--;
////                                                                 if (self->contentView && self->apiCount == 0){
////                                                                     [self->contentView removeFromSuperview];
////                                                                 }
//                                                                 if(error == nil)
//                                                                 {
//                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                         if (![Utility isEmptyCheck:responseDict[@"SquadUserSavedMealPlanList"]] ) {
//                                                                             self->savedPlanList = responseDict[@"SquadUserSavedMealPlanList"];
//                                                                             NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
//                                                                             if ([self->planId  isEqual: @-1]) {
//                                                                                 self->mealPlanLabel.attributedText = text;
//                                                                             } else {
//                                                                                 NSArray *temp = [self->savedPlanList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %@)",self->planId]];
//                                                                                 if (temp.count>0) {
//                                                                                     NSString *name = ![Utility isEmptyCheck:temp[0][@"Name"]]?temp[0][@"Name"]:@"";
//
//                                                                                     text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week.",name]];
//
//                                                                                     NSRange range1 =[[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week.",name] rangeOfString: name];
//
//                                                                                     NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
//                                                                                     paragraphStyle.alignment                = NSTextAlignmentCenter;
//
//                                                                                     NSDictionary *attrDict = @{
//                                                                                                                NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:13.0],
//                                                                                                                NSForegroundColorAttributeName : [UIColor grayColor],
//                                                                                                                NSParagraphStyleAttributeName:paragraphStyle
//                                                                                                                };
//                                                                                     [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
//                                                                                     [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:13] range:NSMakeRange(range1.location,range1.length)];
//
//                                                                                     self->mealPlanLabel.attributedText = text;
//                                                                                 } else {
//                                                                                     self->mealPlanLabel.attributedText = text;
//                                                                                 }
//                                                                             }
//                                                                         } else {
//                                                                             self->savedPlanList = [NSArray new];
//                                                                             self->mealPlanLabel.attributedText = [[NSMutableAttributedString alloc] init];
//                                                                         }
//                                                                     }
//                                                                     else{
//                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
//                                                                         return;
//                                                                     }
//                                                                 }else{
//                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                 }
//                                                             });
//
//                                                         }];
//        [dataTask resume];
//
//    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//    }
//}
-(void)SwapSquadUserSavedMealPlanEntry{
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:savedPlanDict[@"Id"] forKey:@"SavedMealPlanId"];
        [mainDict setObject:nutritionPlanListArray[0][@"day"] forKey:@"WeekDate"];
        [mainDict setObject:saveMealTextView.text forKey:@"Description"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SwapSquadUserSavedMealPlanEntry" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@""
                                                                                                               message:@"Meal plan saved Successfully"
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"Ok"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                        self->saveMealPlanView.hidden = true;
                                                                                                    }];
                                                                         [alertController addAction:okAction];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
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
-(void)getSavedMealPlanUsage{
    if (Utility.reachable) {

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
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            self->apiCount++;
        //            if (self->contentView) {
        //                [self->contentView removeFromSuperview];
        //            }
        //        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSavedMealPlanUsage" append:@""forAction:@"POST"];

        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 //                                                                 self->apiCount--;
                                                                 //                                                                 if (self->contentView && self->apiCount == 0){
                                                                 //                                                                     [self->contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"SavedMealPlanUsageList"]] ) {
                                                                             NSDateFormatter *df = [NSDateFormatter new];
                                                                             [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
                                                                             NSDate *planDate = [df dateFromString:self->nutritionPlanListArray[0][@"day"]];
                                                                             [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
                                                                             NSString *strDate = [df stringFromDate:planDate];
                                                                             NSArray *temp = responseDict[@"SavedMealPlanUsageList"];
                                                                             temp = [temp filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(WeekStartDate == %@)",strDate]];
                                                                             if (temp.count>0) {
                                                                                 self->planId = [temp lastObject][@"SquadUserSavedMealPlanId"];
                                                                             }else{
                                                                                 self->planId = @-1;
                                                                             }
                                                                         }else{
                                                                             self->planId = @-1;
                                                                         }
//                                                                         [self GetSquadUserSavedMealPlan];
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
-(void)resetMealPlanForSquadUserFromSavedPlan{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"WeekStartDate"];
        }
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ResetMealPlanForSquadUserFromSavedPlan" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getSquadMealPlanWithSettings];
                                                                         for(UIViewController *controller in [self childViewControllers]){
                                                                             if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                                                                                 CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                                                                                 new.weekDate = self->weekDate;
                                                                                 [new reloadMyCollection];
                                                                             }
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
-(void)addCustomPlanPoints{
    if(!weekDate) return;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyyMMdd"];
    NSString *ReferenceEntityId = [df stringFromDate:weekDate];
    
    NSMutableDictionary *dataDict = [NSMutableDictionary new];
    [dataDict setObject:[NSNumber numberWithInt:41] forKey:@"UserActionId"];
    if(ReferenceEntityId)[dataDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
    [dataDict setObject:@"UserCustomMealPlan" forKey:@"ReferenceEntityType"];
    
    [Utility addGamificationPointWithData:dataDict];
}
-(void)updateSavedMealPlanView:(NSDictionary *)responseDict{
    [savedPlanDict removeAllObjects];
    mealPlanLabel.text = @"";
    isMealPlanChanged = true;
    if(![Utility isEmptyCheck:[responseDict objectForKey:@"IsSavedMealPlanChanged"]]){
        isMealPlanChanged = [[responseDict objectForKey:@"IsSavedMealPlanChanged"] boolValue];
    }
    if (![Utility isEmptyCheck:responseDict[@"SavedMealPlan"]]) {
        savedPlanDict = [responseDict[@"SavedMealPlan"]mutableCopy];
        NSMutableAttributedString *text;
        if (isMealPlanChanged) {
            NSString *name = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
            
            text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week. Changes have been made for this week. To update the changes save the MEAL PLAN again.",name]];
            
            NSRange range1 =[[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week. Changes have been made for this week. To update the changes save the MEAL PLAN again.",name] rangeOfString: name];
            
//            NSRange range2 =[[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week. Changes have been made for this week. To update the changes save the MEAL PLAN again",name] rangeOfString: @"update the changes"];
//            [text addAttributes:@{
//                                  NSLinkAttributeName : @"Update://",
//                                  NSUnderlineStyleAttributeName : [NSNumber numberWithInt:NSUnderlineStyleSingle]
//                                  } range:NSMakeRange(range2.location,range2.length)];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment                = NSTextAlignmentCenter;
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:13.0],
                                       NSForegroundColorAttributeName : [UIColor grayColor],
                                       NSParagraphStyleAttributeName:paragraphStyle
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:13] range:NSMakeRange(range1.location,range1.length)];
        } else {
            savedPlanDict = [responseDict[@"SavedMealPlan"]mutableCopy];
            NSString *name = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
            
            text = [[NSMutableAttributedString alloc] initWithString:[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week.",name]];
            
            NSRange range1 =[[@"" stringByAppendingFormat:@"You have used your saved meal plan %@ for this week.",name] rangeOfString: name];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment                = NSTextAlignmentCenter;
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"Oswald-Regular" size:13.0],
                                       NSForegroundColorAttributeName : [UIColor grayColor],
                                       NSParagraphStyleAttributeName:paragraphStyle
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            [text addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:13] range:NSMakeRange(range1.location,range1.length)];
            
        }
        
        self->mealPlanLabel.attributedText = text;
    }
}
-(void)notLoadAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"please improve internet speed and click here to finalise settings and set up"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
                                   [self.navigationController pushViewController:controller animated:YES];
                               }];
   
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark -End

#pragma -mark IBAction
-(IBAction)mealMatchButtonPressed:(UIButton *)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            MealMatchViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealMatchView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
    
}
-(IBAction)saveCustomShoppingListButtonPressed:(UIButton *)sender{
    if (gridButton.isSelected) {
        for(UIViewController *controller in [self childViewControllers]){
            if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                [new saveCustomShoppingListButtonPressed];
            }
        }
        return;
    }
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (weekDate) {
            [mainDict setObject:[dailyDateformatter stringFromDate:weekDate ] forKey:@"SessionDate"];
        }
        NSMutableArray *mealSessionArray = [[NSMutableArray alloc]init];
        for (NSDictionary *temp in squadCustomMealSessionList) {
            NSString *sessionIds = [NSString stringWithFormat:@"%@-%@",temp[@"MealSessionId"],temp[@"NoofServe"]];
            [mealSessionArray addObject:sessionIds];
        }
        [mainDict setObject:mealSessionArray forKey:@"ArrayMealSessionId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            [self.view bringSubviewToFront:self->countDownView];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddCustomShoppingList" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
//                                                                         self->saveCustomShoppingList.hidden = true;
                                                                         self->saveCustomShoppingList.selected = false;
                                                                         [Utility stopFlashingbutton:self->saveCustomShoppingList];
                                                                         self->isCustom = false;
                                                                         [self->table reloadData];
//                                                                         ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
//                                                                         controller.isCustom = YES;
//                                                                         controller.weekdate = weekDate;
//                                                                         [self.navigationController pushViewController:controller animated:YES];
                                                                         [self getSquadCustomMealSession];
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
-(IBAction)shoppingCheckUncheckButtonPressed:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    if (![Utility isEmptyCheck:mealData]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0){
            if(sender.selected){
                NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                [temp setObject:[NSNumber numberWithInt:1] forKey:@"NoofServe"];
                [squadCustomMealSessionList removeObject:filteredArray[0]];
                [squadCustomMealSessionList addObject:temp];
            }else{
                [squadCustomMealSessionList removeObject:filteredArray[0]];
            }
        }else{
            if(sender.selected){
                NSMutableDictionary *temp = [mealData mutableCopy];
                [temp setObject:[NSNumber numberWithInt:1] forKey:@"NoofServe"];
                [squadCustomMealSessionList addObject:temp];
            }
        }
    }
    [self checkCustomShoppinListChange];
    //[collection reloadData];
    [table reloadData];
}
-(IBAction)shoppingPlusMinus:(UIButton *)sender{
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *)[collection cellForItemAtIndexPath:indexPath];
    CustomNutritionPlanListTableViewCell *tableCell = (CustomNutritionPlanListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
    
    if (![Utility isEmptyCheck:mealData]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0){
            NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
            int noofServe = [temp[@"NoofServe"] intValue];
            if (sender == cell.shoppingPlusButton || sender == tableCell.shoppingPlusButton) {
                noofServe++;
                
            }else{
                if (noofServe>1) {
                    noofServe--;
                }
            }
            [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
            [squadCustomMealSessionList removeObject:filteredArray[0]];
            [squadCustomMealSessionList addObject:temp];
            
        }
    }
    [self checkCustomShoppinListChange];
    //[collection reloadData];
    [table reloadData];
}
- (IBAction)shoppingButtonPressed:(UIButton *)sender {
    [self closeShopView];
    NSIndexPath *indexPath;
    if ([sender.accessibilityHint isEqualToString:@"fav"]) {
        indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    }
    isCustom = true;
    myIndexPath = indexPath;
    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[indexPath.row];
    int noofServe = 0;
    int oldServe = 0;
    if (![Utility isEmptyCheck:mealData]) {
        if (squadCustomMealSessionList.count > 0){
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
            if (![Utility isEmptyCheck:filteredArray]){
                NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                oldServe = [temp[@"NoofServe"] intValue];
                noofServe = [temp[@"NoofServe"] intValue];
            }else{
                NSMutableDictionary *temp = [mealData mutableCopy];
                noofServe = 1;
                [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
                [self->squadCustomMealSessionList addObject:temp];
            }
        }else{
            NSMutableDictionary *temp = [mealData mutableCopy];
            noofServe = 1;
            [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
            [self->squadCustomMealSessionList addObject:temp];
        }
    }
    
    if (oldServe == 0) {
        [self checkCustomShoppinListChange];
        [table reloadData];
        [self updateShoplistButton];
    } else {
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"ADJUST SERVINGS"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       ShoppingCartPopUpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingCartPopUp"];
                                       controller.delegate = self;
                                       controller.noOfServe = noofServe;
                                       controller.indexPath = self->myIndexPath;
                                       controller.top = 241;//table.frame.origin.y;
                                       controller.from = @"table";
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       [self presentViewController:controller animated:YES completion:nil];
                                       
                                       [self checkCustomShoppinListChange];
                                       [self->table reloadData];
                                       [self updateShoplistButton];
                                   }];
        UIAlertAction *removeAction = [UIAlertAction
                                       actionWithTitle:@"REMOVE"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                                           NSArray *filteredArray = [self->squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                                           if (![Utility isEmptyCheck:filteredArray]){
                                               NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                                               [self->squadCustomMealSessionList removeObject:temp];
                                           }
                                           
                                           self->isCustom = [self checkCustomShoppinListChange];
                                           [self->table reloadData];
                                           [self updateShoplistButton];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"CANCEL"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:removeAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}
- (void) countDownAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        int gameOnCount = [self->countDownLabel.text intValue];
        gameOnCount--;
        self->countDownLabel.text = [NSString stringWithFormat:@"%d",gameOnCount];
        if (gameOnCount <= 0) {
            [self->countDownTimer invalidate];
            self->countDownView.hidden = true;
        }
    });
}
- (IBAction)legendButtonPressed:(UIButton *)sender {
    NSString *urlString=@"https://player.vimeo.com/external/290408090.m3u8?s=c5a2636fb44f431346c4573e6ed76c9d1edfbec4";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
//    LegendViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Legend"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)userDailySessionButtonPressed:(UIButton *)sender {
    SquadUserDailySessionsPopUpViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SquadUserDailySessionsPopUp"];
    controller.delegate = self;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSDictionary *dict = nutritionPlanListArray[sender.tag];
    NSString *dateString = dict[@"day"];
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        controller.sessionDate = date;
    }
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)addMealButtonPressed:(UIButton *)sender {
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            for (UIView *view in self->shoppingButtonCollection) {
                view.hidden = true;
            }
            self->editRowNumber = -1;
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
//            listButton.selected = true;
//            gridButton.selected = false;
//            favButton.selected = false;
            
            self->gridButton.selected = false;
            if(self->isFav){
                self->listButton.selected = false;
                self->favButton.selected = true;
            }else if(self->isCollection){
                self->listButton.selected = false;
                self->gridButton.selected = true;
                self->favButton.selected = false;
                self->myFavView.hidden = true;
                self->table.hidden = true;
                self->myContainer.hidden = false;
            }else{
                self->listButton.selected = true;
                self->favButton.selected = false;
            }
            
            self->myFavView.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            NSTimeInterval sixmonth = 7*24*60*60;
            self->weekDate = [self->weekDate
                        dateByAddingTimeInterval:sixmonth];
            //apiCount =0;
            self->haveToCallGenerateMeal = YES;
            //[self getSquadMealPlanWithSettings];
            for(UIViewController *controller in [self childViewControllers]){
                if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                    CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                    new.weekDate=self->weekDate;
                    [self updateView];
                    [new nextButton];
                }
            }
            [self getSquadMealPlanWithSettings];
            [self addCustomPlanPoints];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
        }
    }];
}
- (IBAction)previousButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            for (UIView *view in self->shoppingButtonCollection) {
                view.hidden = true;
            }
            self->editRowNumber = -1;
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
//            listButton.selected = true;
//            gridButton.selected = false;
//            favButton.selected = false;
            self->gridButton.selected = false;
            if(self->isFav){
                self->listButton.selected = false;
                self->favButton.selected = true;
            }else if(self->isCollection){
                self->listButton.selected = false;
                self->gridButton.selected = true;
                self->favButton.selected = false;
                self->myFavView.hidden = true;
                self->table.hidden = true;
                self->myContainer.hidden = false;
            }else{
                self->listButton.selected = true;
                self->favButton.selected = false;
            }
            self->myFavView.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            NSTimeInterval sixmonth = -7*24*60*60;
            self->weekDate = [self->weekDate
                        dateByAddingTimeInterval:sixmonth];
            //apiCount =0;
            self->haveToCallGenerateMeal = YES;
            
          // [self getSquadMealPlanWithSettings];
            for(UIViewController *controller in [self childViewControllers]){
                if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                    CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                    new.weekDate=self->weekDate;
                    [self updateView];
                    [new previousButton];
                }
            }
            [self getSquadMealPlanWithSettings];
            [self addCustomPlanPoints];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
        }
    }];
}
- (IBAction)openQuickEditContainerPressed:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *)[collection cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        cell.quickEditButton.hidden =! cell.quickEditButton.hidden;
        cell.recipeEditButton.hidden =! cell.recipeEditButton.hidden;
        cell.quickEditArrowImage.hidden = ! cell.quickEditArrowImage.hidden;
    } completion:^(BOOL finished) {
        
    }];

}
- (IBAction)swapButtonPressed:(UIButton *)sender {
    NSLog(@"quickEditButtonPressed");
    NSDictionary *dict = nutritionPlanListArray[dayNumber]; //sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    isLoadController = NO;

    //    MealSwapDropDownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealSwapDropDownView"];
//    controller.isFromFoodPrep = NO;
//    controller.delegate = self;
//    controller.controllerNeedToUpdate = self;
//    controller.mealSessionIdToReplace = [[mealData objectForKey:@"MealSessionId"] intValue];
//    [self.navigationController pushViewController:controller animated:YES];
    
    
    FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
    controller.delegate = self;
    controller.sender = sender;
    controller.mealSessionIdToReplace = [[mealData objectForKey:@"MealSessionId"] intValue];
    [self.navigationController pushViewController:controller animated:YES];
    
    
    /*NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *dateStr = mealData[@"MealDate"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    CustomNutritionPlanListTableViewCell *cell = (CustomNutritionPlanListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
    if (sender == cell.recipeSwapButton) {
        if (![Utility isEmptyCheck:dateStr]) {
            NSDate *dailyDate = [formatter dateFromString:dateStr];
            if (dailyDate) {
                SwapMealViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SwapMeal"];
                controller.mealId = [mealData objectForKey:@"MealId"];
                controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                controller.mealDate= dailyDate;
                controller.delegate = self;
                controller.modalPresentationStyle = UIModalPresentationCustom;
                [self presentViewController:controller animated:YES completion:nil];
            }
            
        }
        return;
    }
    
    if (![Utility isEmptyCheck:dateStr]) {
        NSDate *dailyDate = [formatter dateFromString:dateStr];
        if (dailyDate) {
            SwapMealViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SwapMeal"];
            controller.mealId = [mealData objectForKey:@"MealId"];
            controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
            controller.mealDate= dailyDate;
            controller.delegate = self;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    }*/
    
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    NSLog(@"editButtonPressed");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue];
    CustomNutritionPlanListTableViewCell *cell = (CustomNutritionPlanListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
    if (sender == cell.editMealButton) {
        if (cell.editMealButton.isSelected) {
            editRowNumber = -1;
        }else{
            editRowNumber = (int)indexPath.row;
        }
//        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
//        [table reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [table reloadData];
        return;
    }else if (sender == cell.editRecipeButton){
        editRowNumber = -1;
        NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[sender.tag];
        //NSDictionary *mealDetails = mealData[@"MealDetails"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *dateStr = mealData[@"MealDate"];
        if (![Utility isEmptyCheck:dateStr]) {
            NSDate *dailyDate = [formatter dateFromString:dateStr];
            if (dailyDate) {
                [formatter setDateFormat:@"dd MM yyyy"];
                NSString *dateString = [formatter stringFromDate:dailyDate];
                AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
                controller.delegate = self; //Nutrition_local_catch
                controller.mealId = [mealData objectForKey:@"MealId"];
                controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                controller.dateString = dateString;
                controller.fromController = @"Meal";        //ah ux
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }
    }
    
//    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
//    NSArray *mealDataArray = dict[@"mealData"];
//    NSDictionary *mealData = mealDataArray[sender.tag];
//    //NSDictionary *mealDetails = mealData[@"MealDetails"];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
//    NSString *dateStr = mealData[@"MealDate"];
//    if (![Utility isEmptyCheck:dateStr]) {
//        NSDate *dailyDate = [formatter dateFromString:dateStr];
//        if (dailyDate) {
//            [formatter setDateFormat:@"dd MM yyyy"];
//            NSString *dateString = [formatter stringFromDate:dailyDate];
//            AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
//            controller.mealId = [mealData objectForKey:@"MealId"];
//            controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
//            controller.dateString = dateString;
//            controller.fromController = @"Meal";        //ah ux
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//
//    }

}
-(IBAction)updateMealSettingButtonPressed:(UIButton *)sender{
    
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    NSDictionary *mealDetails = mealData[@"MealDetails"];
    //NSDictionary *mealDetails = mealData[@"MealDetails"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    NSString *dateStr = mealData[@"MealDate"];
    editRowNumber = -1;
    if (![Utility isEmptyCheck:dateStr]) {
        NSDate *dailyDate = [formatter dateFromString:dateStr];
        if (dailyDate) {
            [formatter setDateFormat:@"dd MM yyyy"];
            NSString *dateString = [formatter stringFromDate:dailyDate];
            CustomNutritionMealSettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionMealSettingsViewController"];
            controller.mealId = [mealDetails objectForKey:@"Id"];
            controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
            controller.dateString = dateString;
            controller.mealData = mealData;
            controller.fromController = @"Meal";
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (IBAction)repeatButtonPressed:(UIButton *)sender {
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr]) {
        NSString *text = [NSString stringWithFormat:@"This feature is not available on the %@. It is only available with your custom plan.",programName];
        [Utility msg:text title:@"" controller:self haveToPop:NO];
        return;
    }
    NSString *repeatTitle;
    NSString *avoidTitle = @"Avoid this meal in future";
    if ([mealData[@"RepeatNextWeek"] boolValue]) {
        repeatTitle = @"Turn off Repeat";
    }else{
        repeatTitle = @"Repeat";
    }
    if([mealData[@"AvoidMeal"] boolValue]){
        avoidTitle = @"Want this meal in future";
    }else{
        avoidTitle = @"Avoid this meal in future";
    }
    if (![Utility isEmptyCheck:mealData]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:repeatTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"repeatButtonPressed====SquadRepeatMealNextWeekApiCall");
                                       NSString *subTitle;
                                       if ([mealData[@"RepeatNextWeek"] boolValue]) {
                                           subTitle = @"This meal will not repeated in your next week's plan, continue?";
                                       }else{
                                           subTitle = @"This meal will get repeated in your next week's plan, continue?";
                                       }
                                       UIAlertController * alert=   [UIAlertController
                                                                     alertControllerWithTitle:@"Confirm Repeate Meal"
                                                                     message:subTitle
                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                       
                                       UIAlertAction* ok = [UIAlertAction
                                                            actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action)
                                                            {
                                                                NSDictionary *mealData = mealDataArray[sender.tag];
                                                                [self repeatMealApiCall:mealData[@"MealSessionId"] repeat:mealData[@"RepeatNextWeek"]];
                                                            }];
                                       UIAlertAction* cancel = [UIAlertAction
                                                                actionWithTitle:@"No"
                                                                style:UIAlertActionStyleCancel
                                                                handler:^(UIAlertAction * action)
                                                                {
                                                                    NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                                                    
                                                                }];
                                       
                                       [alert addAction:cancel];
                                       [alert addAction:ok];
                                       
                                       
                                       [self presentViewController:alert animated:YES completion:nil];
                                   }];
        UIAlertAction *neverAction = [UIAlertAction
                                      actionWithTitle:avoidTitle
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *action)
                                      {
                                          //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:collection];
                                          //NSIndexPath *indexPath = [collection indexPathForItemAtPoint:buttonPosition];
                                          //CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *)[collection cellForItemAtIndexPath:indexPath];
                                          
                                          NSString *subTitle;
                                          if ([mealData[@"AvoidMeal"] boolValue]) {
//                                              subTitle = @"This meal may repeated in your next week's plan, continue?";
                                              NSMutableArray *avoidAllArray = [[NSMutableArray alloc]init];
                                              for (int i=0; i<4; i++) {
                                                  NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                                                  [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                                                  [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                                                  [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                                                  [mainDict setObject:[NSNumber numberWithInt:i+1] forKey:@"MealType"];
                                                  [mainDict setObject:mealData[@"MealId"] forKey:@"MealId"];
                                                  if([mealData[@"AvoidMeal"] boolValue]){
                                                      [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"Avoid"];
                                                  }else{
                                                      [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"Avoid"];
                                                  }
                                                  //                                              [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"Avoid"];
                                                  if (avoidAllArray.count >0) {
                                                      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealData[@"MealId"],[NSNumber numberWithInt:i+1]];
                                                      NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                                                      if (filteredArray.count > 0) {
                                                          [avoidAllArray removeObject:filteredArray[0]];
                                                      }
                                                      [avoidAllArray addObject:mainDict];
                                                  }else{
                                                      [avoidAllArray addObject:mainDict];
                                                  }
                                              }
                                              if (![Utility isEmptyCheck:avoidAllArray]) {
                                                  [self save:avoidAllArray];
                                              }
                                          }else{
                                              subTitle = @"This meal will avoid in your next week's plan, continue?";
                                              UIAlertController * alert=   [UIAlertController
                                                                            alertControllerWithTitle:nil
                                                                            message:subTitle
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              UIAlertAction* ok = [UIAlertAction
                                                                   actionWithTitle:@"Yes"
                                                                   style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * action)
                                                                   {
                                                                       NSMutableArray *avoidAllArray = [[NSMutableArray alloc]init];
                                                                       for (int i=0; i<4; i++) {
                                                                           NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                                                                           [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
                                                                           [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
                                                                           [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
                                                                           [mainDict setObject:[NSNumber numberWithInt:i+1] forKey:@"MealType"];
                                                                           [mainDict setObject:mealData[@"MealId"] forKey:@"MealId"];
                                                                           if([mealData[@"AvoidMeal"] boolValue]){
                                                                               [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"Avoid"];
                                                                           }else{
                                                                               [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"Avoid"];
                                                                           }
                                                                           //                                              [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"Avoid"];
                                                                           if (avoidAllArray.count >0) {
                                                                               NSPredicate *predicate = [NSPredicate predicateWithFormat:@"MealId == %@ AND MealType==%@",mealData[@"MealId"],[NSNumber numberWithInt:i+1]];
                                                                               NSArray *filteredArray = [avoidAllArray filteredArrayUsingPredicate:predicate];
                                                                               if (filteredArray.count > 0) {
                                                                                   [avoidAllArray removeObject:filteredArray[0]];
                                                                               }
                                                                               [avoidAllArray addObject:mainDict];
                                                                           }else{
                                                                               [avoidAllArray addObject:mainDict];
                                                                           }
                                                                       }
                                                                       if (![Utility isEmptyCheck:avoidAllArray]) {
                                                                           [self save:avoidAllArray];
                                                                       }
                                                                   }];
                                              UIAlertAction* cancel = [UIAlertAction
                                                                       actionWithTitle:@"No"
                                                                       style:UIAlertActionStyleCancel
                                                                       handler:^(UIAlertAction * action)
                                                                       {
                                                                           NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                                                           
                                                                       }];
                                              
                                              [alert addAction:cancel];
                                              [alert addAction:ok];
                                              
                                              
                                              [self presentViewController:alert animated:YES completion:nil];
                                          }
                                          
                                      }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:neverAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    NSLog(@"deleteButtonPressed===SquadRemoveUserMealSessionApiCall");
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete Meal"
                                  message:@"Are you sure you want to delete this meal from your plan?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSDictionary *dict = self->nutritionPlanListArray[sender.accessibilityHint.integerValue];
                             NSArray *mealDataArray = dict[@"mealData"];
                             NSDictionary *mealData = mealDataArray[sender.tag];
                             [self deleteMealApiCall:mealData[@"MealSessionId"]];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 
                             }];
    UIAlertAction* replace = [UIAlertAction
                         actionWithTitle:@"I would Like to Replace Meal."
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                              {
                                  NSDictionary *dict = self->nutritionPlanListArray[sender.accessibilityHint.integerValue];
                                  NSArray *mealDataArray = dict[@"mealData"];
                                  NSDictionary *mealData = mealDataArray[sender.tag];
                                  NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                  formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
                                  NSString *dateStr = mealData[@"MealDate"];
                                  if (![Utility isEmptyCheck:dateStr]) {
                                      NSDate *dailyDate = [formatter dateFromString:dateStr];
                                      if (dailyDate) {
                                          SwapMealViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SwapMeal"];
                                          controller.mealId = [mealData objectForKey:@"MealId"];
                                          controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                                          controller.mealDate= dailyDate;
                                          controller.delegate = self;
                                          controller.modalPresentationStyle = UIModalPresentationCustom;
                                          [self presentViewController:controller animated:YES completion:nil];
                                      }
                                      
                                  }
                            
                              }];
    [alert addAction:cancel];
    [alert addAction:replace];
    [alert addAction:ok];


    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)backToSettingsTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            NutritionSettingHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NutritionSettingHomeView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }];
}

- (IBAction)showMenu:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            [self.slidingViewController anchorTopViewToRightAnimated:YES];
            [self.slidingViewController resetTopViewAnimated:YES];
        }
    }];
}
-(IBAction)logoTapped:(id)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];

}
- (IBAction)back:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            self->squadCustomMealSessionList = [[NSMutableArray alloc]init];
            self->tempShoppingList = [[NSArray alloc]init];
//            self->saveCustomShoppingList.hidden = true;
            [Utility stopFlashingbutton:self->saveCustomShoppingList];
            if (self->isComplete) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    
}

- (IBAction)cellLegendButtonPressed:(UIButton *)sender {
    NSDictionary *dict = nutritionPlanListArray[sender.accessibilityHint.integerValue];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[sender.tag];
    if (![Utility isEmptyCheck:mealData]) {
        NSDictionary *mealDetails = mealData[@"MealDetails"];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.integerValue];
        CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *) [collection cellForItemAtIndexPath:indexpath];
        cell.legendPopupView.hidden = false;
        NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
        NSDictionary *attrsDictionary = @{
                                          NSFontAttributeName : cell.mealType.font,
                                          NSForegroundColorAttributeName : cell.mealType.textColor
                                          
                                          };
        NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:@" " attributes:attrsDictionary];
        if ( ![Utility isEmptyCheck:mealDetails[@"IsVegetarian"]] && [mealDetails[@"IsVegetarian"] intValue] > 0)
        {
            //            if ([mealDetails[@"IsVegetarian"] intValue] == [VegetarianType[@"Other"] intValue])
            //            {
            //                //V
            //                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            //                textAttachment.image = [UIImage imageNamed:@"mp_v_ico.png"];
            //                textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            //                NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            //                [newString appendAttributedString:attrStringWithImage];
            //                [newString appendAttributedString:attributedString];
            //
            //            }
            if ([mealDetails[@"IsVegetarian"] intValue] == [VegetarianType[@"Pescatarian"]intValue])
            {
                //VP
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"mp_vp_ico.png"];
                textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
                NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [newString appendAttributedString:attrStringWithImage];
                [newString appendAttributedString:attributedString];
                
            }
            else if ([mealDetails[@"IsVegetarian"] intValue] == [VegetarianType[@"Vegan"]intValue])
            {
                //VE
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //textAttachment.image = [UIImage imageNamed:@"mp_ve_ico.png"];
                textAttachment.image = [UIImage imageNamed:@"mp_v_ico.png"];
                
                textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
                NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [newString appendAttributedString:attrStringWithImage];
                [newString appendAttributedString:attributedString];
                
                
                NSTextAttachment *textAttachment1 = [[NSTextAttachment alloc] init];
                textAttachment1.image = [UIImage imageNamed:@"mp_vl_ico.png"];
                
                textAttachment1.bounds = CGRectMake(0, 0, textAttachment1.image.size.width, textAttachment1.image.size.height);
                NSAttributedString *attrStringWithImage1 = [NSAttributedString attributedStringWithAttachment:textAttachment1];
                [newString appendAttributedString:attrStringWithImage1];
                [newString appendAttributedString:attributedString];
                
                NSTextAttachment *textAttachment2 = [[NSTextAttachment alloc] init];
                textAttachment2.image = [UIImage imageNamed:@"mp_vp_ico.png"];
                
                textAttachment2.bounds = CGRectMake(0, 0, textAttachment2.image.size.width, textAttachment2.image.size.height);
                NSAttributedString *attrStringWithImage2 = [NSAttributedString attributedStringWithAttachment:textAttachment2];
                [newString appendAttributedString:attrStringWithImage2];
                [newString appendAttributedString:attributedString];
                
                
            }else if ([mealDetails[@"IsVegetarian"] intValue] == [VegetarianType[@"Lacto_Ovo"]intValue])
            {
                //VL
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"mp_vl_ico.png"];
                textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
                NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [newString appendAttributedString:attrStringWithImage];
                [newString appendAttributedString:attributedString];
                
                NSTextAttachment *textAttachment1 = [[NSTextAttachment alloc] init];
                textAttachment1.image = [UIImage imageNamed:@"mp_vp_ico.png"];
                
                textAttachment1.bounds = CGRectMake(0, 0, textAttachment1.image.size.width, textAttachment1.image.size.height);
                NSAttributedString *attrStringWithImage1 = [NSAttributedString attributedStringWithAttachment:textAttachment1];
                [newString appendAttributedString:attrStringWithImage1];
                [newString appendAttributedString:attributedString];
                
            }
        }
        if ([mealDetails[@"IsDairyFree"] boolValue])
        {
            //LF
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_df_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        if ([mealDetails[@"IsGlutenFree"] boolValue])
        {
            //GF
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_gf_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        if ([mealDetails[@"IsFodmapFriendly"] boolValue])
        {
            //FF
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_ff_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        //        if ([mealDetails[@"IsKETO"] boolValue])
        //        {
        //            //K
        //            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        //            textAttachment.image = [UIImage imageNamed:@"mp_k_ico.png"];
        //            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
        //            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        //            [newString appendAttributedString:attrStringWithImage];
        //            [newString appendAttributedString:attributedString];
        //
        //        }
        if ([mealDetails[@"IsPaleo"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_pf_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        if ([mealDetails[@"NoLegumes"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_nl_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        if ([mealDetails[@"NoEggs"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_ne_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
            
        }
        if ([mealDetails[@"NoNuts"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_nn_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
        }
        if ([mealDetails[@"NoSeaFood"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_ns_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
        }
        if ([mealDetails[@"HasWhiteMeat"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_nr_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
        }
        if ([mealDetails[@"IsAntiOx"] boolValue])
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            textAttachment.image = [UIImage imageNamed:@"mp_nc_ico.png"];
            textAttachment.bounds = CGRectMake(0, 0, textAttachment.image.size.width, textAttachment.image.size.height);
            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [newString appendAttributedString:attrStringWithImage];
            [newString appendAttributedString:attributedString];
        }
        
        if (![Utility isEmptyCheck:newString] && newString.length > 0 ) {
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 3;
            style.alignment = NSTextAlignmentCenter;
            
            [newString addAttribute:NSParagraphStyleAttributeName
                              value:style
                              range:NSMakeRange(0, newString.length)];
            cell.legendLabel.attributedText = newString;
        }else{
            cell.legendLabel.attributedText = [[NSAttributedString alloc]initWithString:@""];
        }
        [cell layoutIfNeeded];
    }
    
}
- (IBAction)cellLegendPopupCloaseButtonPressed:(UIButton *)sender {
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.integerValue];
    CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *) [collection cellForItemAtIndexPath:indexpath];
    cell.legendPopupView.hidden = true;
    
}

-(IBAction)dayButtonPressed:(UIButton *)sender{
    
    dayNumber = (int)sender.tag;
    editRowNumber = -1;
    [table reloadData];
    [innerCollection reloadData];
}

-(IBAction)calorieTrackButtonPressed:(UIButton *)sender{
    MealMatchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MealMatchView"];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)shopListButtonPressed:(UIButton *)sender{
//    ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
//    controller.isCustom = YES;
//    controller.weekdate = weekDate;
//    controller.delegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
    
    BOOL isHidden = true;
    for (UIView *view in shoppingButtonCollection) {
        if (view.tag == 0) {
            isHidden = view.isHidden;
            break;
        }
    }
    for (UIView *view in shoppingButtonCollection) {
        if (view.tag == 2) {
            
            int noofServe = 0;
            if (nutritionPlanListArray.count>0 && squadCustomMealSessionList.count>0) {
                for (int i=0;i<nutritionPlanListArray.count;i++) {
                    NSDictionary *dict = nutritionPlanListArray[i];
                    NSArray *mealDataArray = dict[@"mealData"];
                    int j = (int)mealDataArray.count;
                    for (int k=0; k<j; k++) {
                        NSDictionary *mealData = mealDataArray[k];
                        if (![Utility isEmptyCheck:mealData]) {
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                            if (filteredArray.count > 0){
                                NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                                noofServe += [temp[@"NoofServe"] intValue];
                            }
                        }
                    }
                }
            }
            
            if (isHidden) {
                if (noofServe>0) {
                    view.hidden = !isHidden;
                }
            } else {
                view.hidden = !isHidden;
            }
        }else{//3 for save->always visible
            
//            if (savedPlanDict.count == 0) {
//                [savedMealPlanArray addObject:@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"}];
//            }else if (savedPlanDict.count>0 && isMealPlanChanged) {
//                [savedMealPlanArray addObject:@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"}];
//            }
//            if (savedPlanDict.count>0) {
//                [savedMealPlanArray addObject:@{@"Number":@"3",@"Value":@"SAVE MEAL PLAN AS"}];
//                [savedMealPlanArray addObject:@{@"Number":@"5",@"Value":@"REVERT TO CUSTOM MEAL PLANS"}];
//            }
//            [savedMealPlanArray addObject:@{@"Number":@"4",@"Value":@"VIEW SAVED MEAL PLANS"}];
            if (view.tag == 3) {// save
                if (savedPlanDict.count == 0) {
                    view.hidden = !isHidden;
                }else if (savedPlanDict.count>0 && isMealPlanChanged) {
                    view.hidden = !isHidden;
                } else {
                    view.hidden = true;
                }
            }else if (view.tag == 4) {//4 view saved
                view.hidden = !isHidden;
            }else if (view.tag == 5 || view.tag == 6) {// revert || save as
                if (savedPlanDict.count>0) {
                    view.hidden = !isHidden;
                } else {
                    view.hidden = true;
                }
            }else{
                view.hidden = !isHidden;
            }
        }
    }
    [self updateShoplistButton];
//    [self getSquadCustomMealSession];

    if (sender == viewCustomShopListButton) {
        ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
        controller.isCustom = YES;
        controller.weekdate = weekDate;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else if(sender == weeklyShopListButton){
        ShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingListView"];
        controller.weekdate = weekDate;
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    } else if(sender.tag == 98){
        UIButton *btn =[UIButton new];
        btn.tag = 99;
        [self gridButtonPressed:btn];
    }
//    [self shoppingButtonPressed:sender];
}

-(IBAction)foodPrepButtonPressed:(UIButton *)sender{
    
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
    [savedMealPlanArray removeAllObjects];
//    [savedMealPlanArray addObject:@{@"Number":@"1",@"Value":@"FOOD PREP HELPER"}];
    
    if (savedPlanDict.count == 0) {
        [savedMealPlanArray addObject:@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"}];
    }else if (savedPlanDict.count>0 && isMealPlanChanged) {
            [savedMealPlanArray addObject:@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"}];
    }
    if (savedPlanDict.count>0) {
        [savedMealPlanArray addObject:@{@"Number":@"3",@"Value":@"SAVE MEAL PLAN AS"}];
        [savedMealPlanArray addObject:@{@"Number":@"5",@"Value":@"REVERT TO CUSTOM MEAL PLANS"}];
    }
    [savedMealPlanArray addObject:@{@"Number":@"4",@"Value":@"VIEW SAVED MEAL PLANS"}];
    
//    controller.dropdownDataArray = savedMealPlanArray;
//    controller.selectedIndex = -1;
//    controller.mainKey = @"Value";
//    controller.apiType = @"Meal";
//    controller.delegate = self;
//    controller.sender = sender;
//    [self presentViewController:controller animated:YES completion:nil];
    
//    FoodPrepViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrep"];
//    controller.delegate = self;
//    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)mealPlanButtonsPressed:(UIButton *)sender{
    
    if (sender.tag == 1) {
        
        if(savedPlanDict.count == 0 || savedPlanDict == nil){// new save
            saveMealPlanView.hidden = false;
            swapMealPlanButton.hidden = true;
            saveMealTextField.text = @"";
            saveMealTextView.text = @"";
            saveMealTextField.userInteractionEnabled = true;
            mealPlanNumber = 1;
        }else{//changes save
            saveMealTextField.text = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
            saveMealTextView.text = ![Utility isEmptyCheck:savedPlanDict[@"Description"]]?savedPlanDict[@"Description"]:@"";
            //                    saveMealTextField.userInteractionEnabled = false;
            mealPlanNumber = 2;
            [self saveMealPlanPressed:0];
        }
    }else if (sender.tag == 2) {//view
        SavedNutritionPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SavedNutritionPlan"];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if (sender.tag == 3) {//revert
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Are you sure want to revert the current Saved meal plan to Custom meal plan?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self resetMealPlanForSquadUserFromSavedPlan];
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (sender.tag == 4) {//save as
        saveMealPlanView.hidden = false;
        mealPlanNumber = 3;
        
        saveMealTextField.userInteractionEnabled = true;
        swapMealPlanButton.hidden = true;
        //                [swapMealPlanButton setTitle:![Utility isEmptyCheck:selectedDict[@"Name"]]?selectedDict[@"Name"]:@"" forState:UIControlStateNormal];
        saveMealTextField.text = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
        saveMealTextView.text = ![Utility isEmptyCheck:savedPlanDict[@"Description"]]?savedPlanDict[@"Description"]:@"";
    }
    for (UIView *view in shoppingButtonCollection) {
        view.hidden = true;
    }
}
-(IBAction)gridButtonPressed:(UIButton *)sender{
    if (isCustom) {
        return;
    }
    BOOL isShow = false;
    if (sender.tag == 99) {
        isShow = true;
    }else if(!gridButton.isSelected){
        isShow = true;
    }
    if(isShow){
        for (UIView *view in shoppingButtonCollection) {
            view.hidden = true;
        }
        [self updateShoplistButton];
        gridButton.selected=true;
        listButton.selected=false;
        favButton.selected=false;
        
        for(UIViewController *controller in [self childViewControllers]){
            if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                new.weekDate = weekDate;
                if (sender.tag == 99) {
                    new.isCustom = true;
                } else {
                    new.isCustom = false;
                }
                [new reloadMyCollection];
            }
        }
        
        isFav = false;
        isCollection = true;
        collection.hidden=true;
        table.hidden=true;
        myFavView.hidden = true;
        myContainer.hidden=false;
    }
}
-(IBAction)listButtonPressed:(UIButton *)sender{
    if (gridButton.isSelected) {
        if(!saveCustomShoppingList.isHidden){
            return;
        }
    }
    if(!listButton.isSelected){
        saveCustomShoppingList.hidden = true;
        for (UIView *view in shoppingButtonCollection) {
            view.hidden = true;
        }
        [self updateShoplistButton];
        listButton.selected=true;
        gridButton.selected=false;
        favButton.selected=false;
        
        [innerCollection reloadData];
        [table reloadData];
        [self getSquadMealPlanWithSettings];
        
        isFav = false;
        isCollection = false;
        myFavView.hidden = true;
        myContainer.hidden=true;
        collection.hidden=true;
        table.hidden=true;
    }
}
-(IBAction)favButtonPressed:(UIButton *)sender{
    if(!favButton.isSelected){
        
        if (myFavrtPlanList.count == 0) {
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@" "
                                          message:@"No favorite meal found"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];

            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            for (UIView *view in shoppingButtonCollection) {
                view.hidden = true;
            }
            [self updateShoplistButton];
            favButton.selected=true;
            gridButton.selected=false;
            listButton.selected=false;
            
            isFav = true;
            isCollection = false;
            [myFavTable reloadData];
            myFavView.hidden = false;
        }
    }
}
-(void)selectedCartOPtion:(int)numberOfMeals row:(int)mrowNumber section:(int)msectionNumber{
    //numberOfMeal = numberOfMeals;
    //rowNumber = mrowNumber;
    //sectionNumber = msectionNumber;
    shopCountImage.hidden = true;
    shopCountLabel.hidden = true;
    shopCountLabel.text = @"";
    inShopCountImage.hidden = true;
    inShopCountLabel.hidden = true;
    inShopCountLabel.text = @"";
    //[self newShoppingPlusMinus:rowNumber section:sectionNumber];
 }
-(void)selectedSaveOption:(int)numberOfMeals row:(int)mrowNumber section:(int)msectionNumber{

    [self getSquadCustomMealSession];
}
-(void)closeShopView{
    for (UIView *view in shoppingButtonCollection) {
        view.hidden = true;
    }
}
-(void)collectionCartSelected:(int)numberOfMeal index:(NSIndexPath *)indexPath{

    NSDictionary *mealData;
    if (isFav) {
        mealData = myFavrtPlanList[indexPath.row];
    } else {
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        mealData = mealDataArray[indexPath.row];
    }
//    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
//    NSArray *mealDataArray = dict[@"mealData"];
//    NSDictionary *mealData = mealDataArray[indexPath.row];
    int noofServe = numberOfMeal;
    if (![Utility isEmptyCheck:mealData]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
        NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0){
            NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
//            noofServe = [temp[@"NoofServe"] intValue];
            
            [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
            [squadCustomMealSessionList removeObject:filteredArray[0]];
            [squadCustomMealSessionList addObject:temp];
            
        }else{
//            NSMutableDictionary *temp = [mealData mutableCopy];
//            [temp setObject:[NSNumber numberWithInt:noofServe] forKey:@"NoofServe"];
//            [squadCustomMealSessionList addObject:temp];
        }
    }
    CustomNutritionPlanListTableViewCell *cell;
    if (isFav) {
        cell = [myFavTable cellForRowAtIndexPath:indexPath];

    } else {
        cell = [table cellForRowAtIndexPath:indexPath];

    }
//    CustomNutritionPlanListTableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    cell.circleLabel.text = [NSString stringWithFormat:@"%d",noofServe];
    [table reloadData];
    [self updateShoplistButton];
    [self checkCustomShoppinListChange];
}
-(void)saveCartPressed:(int)numberOfMeal index:(NSIndexPath *)indexPath{
    //
//    shopPopUP = false;
    NSDictionary *mealData;
    if (isFav) {
        mealData = myFavrtPlanList[indexPath.row];
    } else {
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        mealData = mealDataArray[indexPath.row];
    }
    if (numberOfMeal == 0) {
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            if (squadCustomMealSessionList.count>0) {
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    [squadCustomMealSessionList removeObject:filteredArray[0]];
                }
            }
        }
    }
    
    isCustom = [self checkCustomShoppinListChange];
    [table reloadData];
    [self updateShoplistButton];
}
-(void)cancelPressed:(int)oldNoOfMeal index:(NSIndexPath *)indexPath{
    //
    shopPopUP = false;
    NSDictionary *mealData;
    if (isFav) {
        mealData = myFavrtPlanList[indexPath.row];
    } else {
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        mealData = mealDataArray[indexPath.row];
    }
    if (oldNoOfMeal != 0) {
//        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
//        NSArray *mealDataArray = dict[@"mealData"];
//        NSDictionary *mealData = mealDataArray[indexPath.row];
        
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
            if (filteredArray.count > 0){
                NSMutableDictionary *temp = [filteredArray[0] mutableCopy];
                [temp setObject:[NSNumber numberWithInt:oldNoOfMeal] forKey:@"NoofServe"];
                [squadCustomMealSessionList removeObject:filteredArray[0]];
                [squadCustomMealSessionList addObject:temp];
//                [self saveCustomShoppingListButtonPressed:nil];
            }
        }
    } else {
//        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
//        NSArray *mealDataArray = dict[@"mealData"];
//        NSDictionary *mealData = mealDataArray[indexPath.row];
        if (![Utility isEmptyCheck:mealData]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
            if (squadCustomMealSessionList.count>0) {
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    [squadCustomMealSessionList removeObject:filteredArray[0]];
//                    [self saveCustomShoppingListButtonPressed:nil];
                }
            }
        }
    }
    isCustom = [self checkCustomShoppinListChange];
    [table reloadData];
    [self updateShoplistButton];
}

-(IBAction)favrtCheckUncheckPressed:(UIButton *)sender{
    NSLog(@"favrt pressed");
    if (sender.isSelected) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"This meal will be removed from your favorite meal list, continue?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Yes"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 if ([sender.accessibilityHint isEqualToString:@"fav"]) {
                                     NSDictionary *mealData = self->myFavrtPlanList[sender.tag];
                                     [self favoriteMealToggleApiCall:mealData[@"MealId"]];
                                 } else {
                                     NSDictionary *dict = self->nutritionPlanListArray[[sender.accessibilityHint intValue]];
                                     NSArray *mealDataArray = dict[@"mealData"];
                                     NSDictionary *mealData = mealDataArray[sender.tag];
                                     
                                     [self favoriteMealToggleApiCall:mealData[@"MealId"]];
                                 }
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:cancel];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if ([sender.accessibilityHint isEqualToString:@"fav"]) {
            NSDictionary *mealData = myFavrtPlanList[sender.tag];
            [self favoriteMealToggleApiCall:mealData[@"MealId"]];
        } else {
            NSDictionary *dict = nutritionPlanListArray[[sender.accessibilityHint intValue]];
            NSArray *mealDataArray = dict[@"mealData"];
            NSDictionary *mealData = mealDataArray[sender.tag];
            
            [self favoriteMealToggleApiCall:mealData[@"MealId"]];
        }
    }
    
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    saveMealPlanView.hidden = true;
}
- (IBAction)swapMealPlanPressed:(UIButton *)sender {
//    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//    controller.modalPresentationStyle = UIModalPresentationCustom;
//    controller.dropdownDataArray = savedPlanList;
//    controller.selectedIndex = -1;
//    controller.mainKey = @"Name";
//    controller.apiType = @"SavePlan";
//    controller.delegate = self;
//    controller.sender = sender;
//    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)saveMealPlanPressed:(UIButton *)sender {
    if (saveMealTextField.text.length <= 0) {
        [Utility msg:@"Please enter Name." title:@"" controller:self haveToPop:NO];
        return;
    }else if (saveMealTextView.text.length <= 0) {
        [Utility msg:@"Please enter Description." title:@"" controller:self haveToPop:NO];
        return;
    }else if (mealPlanNumber == 3 && ![Utility isEmptyCheck:savedPlanDict] && [savedPlanDict[@"Name"] isEqualToString:saveMealTextField.text]){
        [Utility msg:@"Please enter different name." title:@"" controller:self haveToPop:NO];
        return;
    }
    
    [self.view endEditing:YES];
    [self saveMealPlanApiCall];
//    if (swapMealPlanButton.isHidden) {
//        [self saveMealPlanApiCall];
//    } else {
//        [self SwapSquadUserSavedMealPlanEntry];
//    }
}
- (IBAction)keyBoardDoneButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}

#pragma mark -End
#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    nutritionPlanListArray = [[NSMutableArray alloc]init];
    squadCustomMealSessionList = [[NSMutableArray alloc]init];
    savedPlanDict = [NSMutableDictionary new];
    savedMealPlanArray = [[NSMutableArray alloc]init];
    
    isLoadController = YES;
    collection.hidden = true;
    table.hidden=true;
    myContainer.hidden = true;
    isFav = false;
    isCollection = false;
    dayNumber = 0;
    isFirstTime = true;
    activeCustomRowNumber = -1;
    editRowNumber = -1;
    rowNumber = -1;
    sectionNumber = -1;
    planId = @-1;
    blankMsgLabel.hidden = false;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    saveMealPlanView.hidden = true;
    swapMealPlanButton.hidden = true;
    swapMealPlanButton.layer.borderWidth = 1.0f;
    swapMealPlanButton.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    saveMealTextField.layer.borderWidth = 1.0f;
    saveMealTextField.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    saveMealTextView.layer.borderWidth = 1.0f;
    saveMealTextView.layer.borderColor = [UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    saveMealTextField.leftView = paddingView;
    saveMealTextField.leftViewMode = UITextFieldViewModeAlways;
    //    savedMealPlanArray = [@[@{@"Number":@"1",@"Value":@"FOOD PREP"},@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"},@{@"Number":@"3",@"Value":@"SAVE MEAL PLAN AS"},@{@"Number":@"4",@"Value":@"VIEW SAVED MEAL PLANS"}]mutableCopy];
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    [self registerForKeyboardNotifications];
    apiCount = 0;
    
    //shabbir 16/01
    listButton.selected = true;
    gridButton.selected = false;
    favButton.selected = false;
    
    trackCalorie.layer.borderWidth = 2.0f;
    trackCalorie.layer.borderColor =[UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    foodPrep.layer.borderWidth = 2.0f;
    foodPrep.layer.borderColor =[UIColor colorWithRed:235/255.0f green:92/255.0f blue:192/255.0f alpha:1.0].CGColor;
    [foodPrep setTitle:@"MORE OPTIONS" forState:UIControlStateNormal];
    //    NSDateFormatter *dailyDateformatter123 = [[NSDateFormatter alloc]init];
    //    [dailyDateformatter123 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    //    NSDate* sourceDate = [NSDate date];
    //
    //    NSTimeZone* sourceTimeZone = [NSTimeZone systemTimeZone];
    //    NSTimeZone* destinationTimeZone = [NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]];
    //
    //    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    //    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    //    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //
    //    NSDate* today = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] ;
    NSDate* today = [NSDate date];
    
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:today];
    today = [dailyDateformatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //[gregorian setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];

    if (beginningOfWeek) {
        beginningOfWeekDate = beginningOfWeek;
    }
    if (!weekDate) {
        weekDate = beginningOfWeekDate;
    }
    if (currentDate) {
        
        NSDate* today = currentDate;
        
        dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dailyDateformatter stringFromDate:today];
        today = [dailyDateformatter dateFromString:dateString];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        if ([weekdayComponents weekday] == 1) {
            [componentsToSubtract setDay:-6];
        }else{
            [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
        }
        weekDate = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!self->_isFromShoppingList){
            [self.view bringSubviewToFront:self->countDownView];
            self->countDownView.hidden = false;
            self->countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        }
    });
    
    [self addCustomPlanPoints];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish
    for (UIView *view in shoppingButtonCollection) {
        view.hidden = true;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didCheckAnyChangeForMealPlan:) name:@"customNutritionview" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCustom:) name:@"NutritionSettingsUpdate" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadFromFooter:) name:@"NutritionUpdateFromFooter" object:nil];

    if(!isLoadController){
        return;
    }
    isLoadController = false;
    
    collection.hidden = true;
//    myContainer.hidden = false;
    table.hidden = true;
    myContainer.hidden = true;
    myFavView.hidden = true;
    
    
    gridButton.selected = false;
    if(isFav){
        listButton.selected = false;
        favButton.selected = true;
    }else if(isCollection){
        listButton.selected = false;
        gridButton.selected = true;
        favButton.selected = false;
        myFavView.hidden = true;
        table.hidden = true;
        myContainer.hidden = false;
    }else{
        listButton.selected = true;
        favButton.selected = false;
    }
    haveToCallGenerateMeal = YES;
    [nutritionPlanListArray removeAllObjects];
    myFavrtPlanList = [[NSMutableArray alloc]init];
    isCustom = false;
    shopPopUP = false;
    editRowNumber = -1;
    myIndexPath = [[NSIndexPath alloc]init];
//    numberOfMeal = 0;
    shopCountImage.hidden = true;
    shopCountLabel.hidden = true;
    inShopCountImage.hidden = true;
    inShopCountLabel.hidden = true;
    shopCountLabel.text = @"";
    inShopCountLabel.text = @"";
    isAllCustom = false;
    saveCustomShoppingList.hidden = true;
    [Utility stopFlashingbutton:saveCustomShoppingList];
    squadCustomMealSessionList = [[NSMutableArray alloc]init];
    for(UIViewController *controller in [self childViewControllers]){
        if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
            CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
            new.delegate = self;
            new.weekDate = weekDate;
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getSquadMealPlanWithSettings];
    });
}
#pragma mark -End
#pragma -mark CollectionView Delegate & DataSource


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CustomNutritionPlanListHeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CustomNutritionPlanListHeaderCollectionReusableView" forIndexPath:indexPath];
        reusableview = headerView;
        headerView.userDailySessionButton.tag = (int)indexPath.section;

        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSDictionary *dict = nutritionPlanListArray[indexPath.section];
        NSString *dateString = dict[@"day"];
        NSDate *date = [formatter dateFromString:dateString];
        if (date) {
            formatter.dateFormat = @"EEEE";
            headerView.dayName.text =[formatter stringFromDate:date].uppercaseString;
            if(![Utility isEmptyCheck:squadUserDailySessionsArray]){
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                NSString *sessionDateString = [formatter stringFromDate:date];
                NSArray *filteredarray = [squadUserDailySessionsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionDate == %@)", sessionDateString]];
                NSLog(@"%@",filteredarray);
                if (![Utility isEmptyCheck:filteredarray]) {
                    NSDictionary *dailySessionDict = filteredarray[0];
                    if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@2])
                    {
                        [headerView.userDailySessionButton setImage:[UIImage imageNamed:@"dumbl_three.png"] forState:UIControlStateNormal];
                        [headerView.userDailySessionButton setTitle:@"2 sessions" forState:UIControlStateNormal];
                    }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@0]){
                        [headerView.userDailySessionButton setImage:[UIImage imageNamed:@"stop_dumbl.png"] forState:UIControlStateNormal];
                        [headerView.userDailySessionButton setTitle:@"No session" forState:UIControlStateNormal];
                    }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@-1]){
                        [headerView.userDailySessionButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        [headerView.userDailySessionButton setTitle:@"As per Exercise Plan" forState:UIControlStateNormal];
                    }else{
                        [headerView.userDailySessionButton setImage:[UIImage imageNamed:@"dumbl_two.png"] forState:UIControlStateNormal];
                        [headerView.userDailySessionButton setTitle:@"1 session" forState:UIControlStateNormal];
                        
                    }
                }
            }
        }
        
        
        
    }
    
    return reusableview;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //shabbir 19/01
    if(collectionView==innerCollection){
        return 1;
    }
    return nutritionPlanListArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //shabbir 19/01
   
    if(collectionView==innerCollection){
        return 7;
    }
    NSDictionary *dict = nutritionPlanListArray[section];
    NSArray *mealDataArray = dict[@"mealData"];
    return mealDataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *collectionViewCell;
    
    if(collectionView==innerCollection){
        
        NSString *CellIdentifier=@"CustomNutritionPlanListInnerCollectionViewCell";
        CustomNutritionPlanListInnerCollectionViewCell *cell=(CustomNutritionPlanListInnerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        if(nutritionPlanListArray.count>0){
            NSDictionary *dict = nutritionPlanListArray[indexPath.row];
            NSString *sDate=dict[@"day"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            NSDate *date = [formatter dateFromString:sDate];
            formatter.dateFormat = @"EEEE";
            NSString *dayName=[formatter stringFromDate:date].uppercaseString;
            dayName=[dayName substringToIndex:3];
            formatter.dateFormat = @"d";
            NSString *dateStr = [formatter stringFromDate:date];
            
            if (date) {
                cell.dayLabel.text=dayName;
                cell.dateLabel.text=dateStr;
                cell.dayButton.tag=indexPath.row;
                cell.dumbleButton.tag=indexPath.row;
                if(indexPath.row==dayNumber){
                    [cell.dayImage setImage:[UIImage imageNamed:@"white_circle_background.png"]];
                }else{
                    [cell.dayImage setImage:nil];
                }
                if(![Utility isEmptyCheck:squadUserDailySessionsArray]){
                    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                    NSString *sessionDateString = [formatter stringFromDate:date];
                    NSArray *filteredarray = [squadUserDailySessionsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionDate == %@)", sessionDateString]];
                    NSLog(@"%@",filteredarray);
                    if (![Utility isEmptyCheck:filteredarray]) {
                        //====
                        if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr]) {
                            
                            if (![Utility isEmptyCheck:[dict objectForKey:@"mealData"]]) {
                                NSArray *mealdataArr = [dict objectForKey:@"mealData"];
                                if (![Utility isEmptyCheck:[mealdataArr objectAtIndex:0]]) {
                                    NSDictionary *mealdatadict = [mealdataArr objectAtIndex:0];
                                    if ([Utility isEmptyCheck:[mealdatadict objectForKey:@"CalorieType"]] || [[mealdatadict objectForKey:@"CalorieType"]intValue] == 0) {
                                        cell.dumbleImage.hidden = false;
                                        cell.dumbleButton.hidden = false;
                                        cell.dumbleLabel.hidden = false;
                                        NSDictionary *dailySessionDict = filteredarray[0];
                                        if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@2])
                                        {
                                            cell.dumbleLabel.text = @"2";
                                        }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@0]){
                                            cell.dumbleLabel.text = @"X";
                                        }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@-1]){
                                            cell.dumbleLabel.text = @"C";
                                        }else{
                                            cell.dumbleLabel.text = @"1";
                                            
                                        }
                                    }else{
                                        cell.dumbleButton.hidden = true;
                                        cell.dumbleImage.hidden = true;
                                        cell.dumbleLabel.hidden = true;
                                    }
                                }
                            }
                        }else{
                            NSDictionary *dailySessionDict = filteredarray[0];
                            if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@2])
                            {
                                cell.dumbleLabel.text = @"2";
                            }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@0]){
                                cell.dumbleLabel.text = @"X";
                            }else if ([dailySessionDict[@"NoOfSessions"] isEqualToNumber:@-1]){
                                cell.dumbleLabel.text = @"C";
                            }else{
                                cell.dumbleLabel.text = @"1";
                                
                            }
                        }
                    }
                }
            }
            
        }
        
        return cell;
    }
    
    NSDictionary *dict = nutritionPlanListArray[indexPath.section];
    NSArray *mealDataArray = dict[@"mealData"];
    NSDictionary *mealData = mealDataArray[indexPath.row];
    if (![Utility isEmptyCheck:mealData]) {
        NSString *CellIdentifier =@"CustomNutritionPlanListCollectionViewCell";
        CustomNutritionPlanListCollectionViewCell *cell = (CustomNutritionPlanListCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.quickEditButton.hidden = true;
        cell.recipeEditButton.hidden = true;
        cell.quickEditArrowImage.hidden = true;

        NSDictionary *mealDetails = mealData[@"MealDetails"];
        if (![Utility isEmptyCheck:mealFrequencyDict]) {
            int totalMeal = ![Utility isEmptyCheck:mealFrequencyDict[@"TotalMeals"]] ? [mealFrequencyDict[@"TotalMeals"] intValue] : 0;
            int mealCount = ![Utility isEmptyCheck:mealFrequencyDict[@"MealCount"]] ? [mealFrequencyDict[@"MealCount"] intValue] : 0;
            int snackCount = ![Utility isEmptyCheck:mealFrequencyDict[@"SnackCount"]] ? [mealFrequencyDict[@"SnackCount"] intValue] : 0;
            if (totalMeal > 0) {
                if (snackCount >0){
                    if (indexPath.row == 0) {
                        cell.recipeType.text = @"Breakfast";
                    }else if (indexPath.row == 1) {
                        cell.recipeType.text = @"Lunch";
                    }else if (indexPath.row == 2) {
                        cell.recipeType.text = @"Dinner";
                    }else if(indexPath.row < snackCount+3){
                        cell.recipeType.text = [@"" stringByAppendingFormat:@"Snack-%d",(int)indexPath.row+1-3];
                    }else{
                        cell.recipeType.text = [@"" stringByAppendingFormat:@"Additional-%d",(int)indexPath.row+1-mealCount-snackCount ];
                    }
                }else if(indexPath.row < mealCount){
                    cell.recipeType.text = [@"" stringByAppendingFormat:@"Meal-%d",(int)indexPath.row+1 ];
                }else{
                    cell.recipeType.text = [@"" stringByAppendingFormat:@"Meal-%d",(int)indexPath.row+1 ];
                }
            }else{
                cell.recipeType.text = [@"" stringByAppendingFormat:@"Additional-%d",(int)indexPath.row+1-mealCount ];
            }

        }else{
            cell.recipeType.text = [@"" stringByAppendingFormat:@"Meal-%d",(int)indexPath.row+1 ];
        }
        cell.recipeName.text =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
        NSString *imageString = mealDetails[@"PhotoSmallPath"];
        if (![Utility isEmptyCheck:imageString]) {
            [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
        } else {
            cell.recipeImage.image = [UIImage imageNamed:@"image_loading.png"];
        }
        if (![Utility isEmptyCheck:mealDetails[@"MealClassifiedID"]] && [mealDetails[@"MealClassifiedID"]intValue] == 2)
        {
            cell.noMeasureMealButton.hidden = false;
        }else{
            cell.noMeasureMealButton.hidden = true;
        }
        cell.legendPopupView.hidden = true;
        [cell layoutIfNeeded];
        
        //[cell.recipeEditButtonContainerStackView removeArrangedSubview:cell.recipeEditButton];
        //[cell.recipeEditButton removeFromSuperview];
        cell.recipeDeleteButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.recipeRepeatButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.openQuickEditButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.quickEditButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.recipeEditButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];

        cell.cellLegendButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.legendClose.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.avoidOrNotButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        
        
        cell.shoppingMinusButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.shoppingPlusButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.shoppingCheckUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        
        cell.shoppingMinusButton.tag = (int)indexPath.row;
        cell.shoppingPlusButton.tag = (int)indexPath.row;
        cell.shoppingCheckUncheckButton.tag = (int)indexPath.row;
        
        cell.avoidOrNotButton.tag = (int)indexPath.row;
        cell.recipeDeleteButton.tag = (int)indexPath.row;
        cell.recipeRepeatButton.tag = (int)indexPath.row;
        cell.openQuickEditButton.tag = (int)indexPath.row;
        cell.quickEditButton.tag = (int)indexPath.row;
        cell.recipeEditButton.tag = (int)indexPath.row;
        cell.cellLegendButton.tag = (int)indexPath.row;
        cell.legendClose.tag = (int)indexPath.row;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *dateStr = mealData[@"MealDate"];
        if (![Utility isEmptyCheck:dateStr]) {
            NSDate *mealDate = [formatter dateFromString:dateStr];
            NSDate *dateNow = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSInteger comps = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
            
            NSDateComponents *date1Components = [calendar components:comps
                                                            fromDate: mealDate];
            NSDateComponents *date2Components = [calendar components:comps
                                                            fromDate: dateNow];
            
            mealDate = [calendar dateFromComponents:date1Components];
            dateNow = [calendar dateFromComponents:date2Components];
            
            NSComparisonResult result = [mealDate compare:dateNow];
            if (result == NSOrderedAscending) {
                cell.openQuickEditButton.hidden = true;
                cell.recipeDeleteButton.hidden = true;
            }else {
                cell.openQuickEditButton.hidden = false;
                //cell.recipeDeleteButton.hidden = false;
                cell.recipeDeleteButton.hidden = true;
            }
        }else{
            cell.openQuickEditButton.hidden = true;
            cell.recipeDeleteButton.hidden = true;
        }
        cell.recipeRepeatButton.selected=[mealData[@"RepeatNextWeek"] boolValue];
        cell.recipeEditButtonContainerStackView.hidden = cell.openQuickEditButton.hidden && cell.recipeRepeatButton.hidden && cell.recipeDeleteButton.hidden;
        
        
        if (isCustom) {
            cell.addCustomShoppingView.hidden = false;
            if (squadCustomMealSessionList.count > 0){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0) {
                    cell.shoppingCheckUncheckButton.selected = true;
                    cell.shoppingQuantity.text =[NSString stringWithFormat:@"%@", filteredArray[0][@"NoofServe"]];
                    cell.shoppingPlusButton.enabled = true;
                    cell.shoppingMinusButton.enabled = true;
                }else{
                    cell.shoppingCheckUncheckButton.selected = false;
                    cell.shoppingQuantity.text = @"0";
                    cell.shoppingPlusButton.enabled = false;
                    cell.shoppingMinusButton.enabled = false;
                }
            }else{
                cell.shoppingCheckUncheckButton.selected = false;
                cell.shoppingQuantity.text = @"0";
                cell.shoppingPlusButton.enabled = false;
                cell.shoppingMinusButton.enabled = false;
            }
        }else{
            cell.addCustomShoppingView.hidden = true;
        }
        
        collectionViewCell = cell;
    }else{
        NSString *CellIdentifier =@"CustomNutritionPlanListBlankCollectionViewCell";
        CustomNutritionPlanListBlankCollectionViewCell *cell = (CustomNutritionPlanListBlankCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        collectionViewCell = cell;

    }
    

    return collectionViewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView==innerCollection){
        return;
    }else{
        if (!isCustom) {
            NSDictionary *dict = nutritionPlanListArray[indexPath.section];
            NSArray *mealDataArray = dict[@"mealData"];
            NSDictionary *mealData = mealDataArray[indexPath.row];
            //NSDictionary *mealDetails = mealData[@"MealDetails"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            NSString *dateStr = mealData[@"MealDate"];
            if (![Utility isEmptyCheck:dateStr]) {
                NSDate *dailyDate = [formatter dateFromString:dateStr];
                if (dailyDate) {
                    [formatter setDateFormat:@"dd MM yyyy"];
                    NSString *dateString = [formatter stringFromDate:dailyDate];
                    DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
                    controller.delegate = self;
                    controller.mealId = [mealData objectForKey:@"MealId"];
                    controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                    controller.dateString = dateString;
                    controller.fromController = @"Meal";    //ah ux
                    [self.navigationController pushViewController:controller animated:YES];
                }
                
            }
        }
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //shabbir
    if(collectionView==innerCollection){
        
        CGFloat w = (CGRectGetWidth(innerCollection.frame))/(float)7;
        CGFloat h = (CGRectGetHeight(innerCollection.frame));
        
        return CGSizeMake(w,h);
    }
    CGFloat w1 = (CGRectGetWidth(collectionView.frame)-32)/(float)3;
    return CGSizeMake(w1, w1*2);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if(collectionView == innerCollection){
        return 0;
    }
    return 8;

}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == innerCollection){
        return UIEdgeInsetsMake(0,0,0,0);
    }
    return UIEdgeInsetsMake(8, 8, 8, 8);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if(collectionView == innerCollection){
        return 0.0;
    }
    return 8.0;
}

-(void)didCancel{
    [Utility msg:@"Recipe saved successfully." title:@"Success" controller:self haveToPop:NO];
    [self viewWillAppear:YES];
}
-(void)didSelectAdvanceSearch:(NSNumber *)mealId mealSessionId:(NSNumber *)mealSessionId mealDate:(NSDate *)mealDate{
    RecipeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RecipeList"];
    controller.mealDate = mealDate;
    controller.mealId = mealId;
    controller.mealSessionId = mealSessionId;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)didChooseOption:(int)index sessionDate:(NSDate *)sessionDate{
    NSLog(@"..........%d",index);
    [self saveSquadUserSessionCountApiCall:index sessionDate:sessionDate];
}
#pragma -mark End

//shabbir 16/01
#pragma mark -TableView Delegate And DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == table) {
        return nutritionPlanListArray.count;
    } else {
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == table) {
        if(section != dayNumber){
            return 0;
        }
        if (nutritionPlanListArray.count>0) {
            NSDictionary *dict = nutritionPlanListArray[dayNumber];
            NSArray *mealDataArray = dict[@"mealData"];
            return mealDataArray.count;
        } else {
            return 0;
        }
        
    } else {
        return myFavrtPlanList.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == table) {
        if(indexPath.row == editRowNumber){
            return 280;
        }else{
            return 230;
        }
    } else {
        return 230;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tableViewCell;
    
    if (tableView == myFavTable) {
        NSString *CellIdentifier =@"CustomNutritionPlanListTableViewCell";
        CustomNutritionPlanListTableViewCell *cell = (CustomNutritionPlanListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (myFavrtPlanList.count>0) {

            NSDictionary *mealData = myFavrtPlanList[indexPath.row];
//            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
            NSDictionary *mealDetails = mealData[@"MealDetails"];
            
            cell.recipeName.text =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
            NSString *imageString = mealDetails[@"PhotoSmallPath"];
            if (![Utility isEmptyCheck:imageString]) {
                [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                    placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            } else {
                cell.recipeImage.image = [UIImage imageNamed:@"image_loading.png"];
            }
            
            cell.favoriteButton.selected = [mealData[@"IsFavorite"]intValue];
            int prepMins = [mealDetails[@"PreparationMinutes"] intValue]*60;
            cell.calorieLabel.text = [Utility formatTimeFromSeconds:prepMins];
            //cell.calorieLabel.text = [NSString stringWithFormat:@"%@ MIN",mealDetails[@"PreparationMinutes"]];
            float totalCals = (![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsTotal"]] && ![Utility isEmptyCheck:[mealData objectForKey:@"Quantity"]]) ? ((float)[[mealDetails objectForKey:@"CalsTotal"] floatValue]*[[mealData objectForKey:@"Quantity"] floatValue]) :0.0f;
//            cell.totalCalorieLabel.text = [NSString stringWithFormat:@"%@ Calories",mealDetails[@"CalsTotal"]];
            cell.totalCalorieLabel.text = [NSString stringWithFormat:@"%.0f Calories",totalCals];
            if (![Utility isEmptyCheck:mealDetails[@"MealClassifiedID"]] && [mealDetails[@"MealClassifiedID"] intValue] == 2) {
                
                [cell.measureImage setImage:[UIImage imageNamed:@"calorie_icon.png"]];
                cell.measureImage.hidden = false;
                cell.totalCalorieLabel.hidden = true;
            }else{
                [cell.measureImage setImage:[UIImage imageNamed:@"calorie_icon.png"]];
                cell.measureImage.hidden = true;
                cell.totalCalorieLabel.hidden = false;
            }
            cell.shoppingButton.selected = false;
            cell.circleImage.hidden = true;
            cell.circleLabel.hidden = true;
            if (squadCustomMealSessionList.count>0) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                if (filteredArray.count > 0){
                    cell.shoppingButton.selected = true;
                    cell.circleImage.hidden = false;
                    cell.circleLabel.hidden = false;
                    cell.circleLabel.text = [NSString stringWithFormat:@"%@", filteredArray[0][@"NoofServe"]];
                }
            }
            
            cell.shoppingButton.accessibilityHint = @"fav";
            cell.favoriteButton.accessibilityHint = @"fav";
            cell.recipeName.tag = indexPath.row;
            cell.recipeImage.tag = indexPath.row;
            cell.favoriteButton.tag = indexPath.row;
            cell.shoppingButton.tag = indexPath.row;
        }
        
        return cell;
    }
    
    if(indexPath.section != dayNumber){
        return nil;
    }
    if (nutritionPlanListArray.count>0) {
        NSDictionary *dict = nutritionPlanListArray[dayNumber]; //[indexPath.section];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[indexPath.row];
        if (![Utility isEmptyCheck:mealData]) {
            NSString *CellIdentifier =@"CustomNutritionPlanListTableViewCell";
            CustomNutritionPlanListTableViewCell *cell = (CustomNutritionPlanListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            [[cell.shoppingButton imageView] setContentMode:UIViewContentModeScaleAspectFit];
            
            NSDictionary *mealDetails = mealData[@"MealDetails"];
            if (![Utility isEmptyCheck:mealFrequencyDict]) {
                //                int totalMeal = ![Utility isEmptyCheck:mealFrequencyDict[@"TotalMeals"]] ? [mealFrequencyDict[@"TotalMeals"] intValue] : 0;
                //                int mealCount = ![Utility isEmptyCheck:mealFrequencyDict[@"MealCount"]] ? [mealFrequencyDict[@"MealCount"] intValue] : 0;
                int snackCount = ![Utility isEmptyCheck:mealFrequencyDict[@"SnackCount"]] ? [mealFrequencyDict[@"SnackCount"] intValue] : 0;
                if (snackCount > 0){
                    if (indexPath.row == 0) {
                        cell.recipeType.text = @"Breakfast";
                    }else if (indexPath.row == 1) {
                        cell.recipeType.text = @"Lunch";
                    }else if (indexPath.row == 2) {
                        cell.recipeType.text = @"Dinner";
                    }else {
                        cell.recipeType.text = [@"" stringByAppendingFormat:@"Snack-%d",(int)indexPath.row-2];
                    }
                }else{
                    cell.recipeType.text = [@"" stringByAppendingFormat:@"Meal-%d",(int)indexPath.row+1];
                }
            }else{
                cell.recipeType.text = [@"" stringByAppendingFormat:@"Meal%d",(int)indexPath.row+1];
            }
            cell.recipeName.text =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
            NSString *imageString = mealDetails[@"PhotoSmallPath"];
            if (![Utility isEmptyCheck:imageString]) {
                [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                    placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];  //ah 17.5
            } else {
                cell.recipeImage.image = [UIImage imageNamed:@"image_loading.png"];
            }
            
            cell.favoriteButton.selected = [mealData[@"IsFavorite"]intValue];
            
            int prepMins = [mealDetails[@"PreparationMinutes"] intValue]*60;
            cell.calorieLabel.text = [Utility formatTimeFromSeconds:prepMins];
            //cell.calorieLabel.text = [NSString stringWithFormat:@"%@ MIN",mealDetails[@"PreparationMinutes"]];
            float totalCals = (![Utility isEmptyCheck:[mealDetails objectForKey:@"CalsTotal"]] && ![Utility isEmptyCheck:[mealData objectForKey:@"Quantity"]]) ? ((float)[[mealDetails objectForKey:@"CalsTotal"] floatValue]*[[mealData objectForKey:@"Quantity"] floatValue]) :0.0f;
            //            cell.totalCalorieLabel.text = [NSString stringWithFormat:@"%@ Calories",mealDetails[@"CalsTotal"]];
            cell.totalCalorieLabel.text = [NSString stringWithFormat:@"%.0f Calories",totalCals];
            if (![Utility isEmptyCheck:mealDetails[@"MealClassifiedID"]] && [mealDetails[@"MealClassifiedID"] intValue] == 2) {
                
                [cell.measureImage setImage:[UIImage imageNamed:@"calorie_icon.png"]];
                cell.measureImage.hidden = false;
                cell.totalCalorieLabel.hidden = true;
            }else{
                [cell.measureImage setImage:[UIImage imageNamed:@"calorie_icon.png"]];
                cell.measureImage.hidden = true;
                cell.totalCalorieLabel.hidden = false;
            }
            
            [cell layoutIfNeeded];
            cell.recipeSwapButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.recipeRepeatButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.shoppingButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.addCustomShoppingButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.favoriteButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.shoppingMinusButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.shoppingPlusButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.saveCustomShoppingButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.shoppingCheckUncheckButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.editMealButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.updateMealSettingButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            cell.editRecipeButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)dayNumber];
            
            cell.shoppingMinusButton.tag = (int)indexPath.row;
            cell.shoppingPlusButton.tag = (int)indexPath.row;
            cell.shoppingCheckUncheckButton.tag = (int)indexPath.row;
            cell.saveCustomShoppingButton.tag = (int)indexPath.row;
            cell.recipeRepeatButton.tag = (int)indexPath.row;
            cell.recipeSwapButton.tag = (int)indexPath.row;
            cell.shoppingButton.tag = (int)indexPath.row;
            cell.addCustomShoppingButton.tag = (int)indexPath.row;
            cell.favoriteButton.tag = (int)indexPath.row;
            cell.editMealButton.tag = (int)indexPath.row;
            cell.updateMealSettingButton.tag = (int)indexPath.row;
            cell.editRecipeButton.tag = (int)indexPath.row;
            
//            cell.recipeRepeatButton.selected = [mealData[@"RepeatNextWeek"] boolValue];
            if ([mealData[@"RepeatNextWeek"] boolValue]) {
                [cell.recipeRepeatButton setImage:[UIImage imageNamed:@"new_repeat_active.png"] forState:UIControlStateNormal];
            }else if([mealData[@"AvoidMeal"] boolValue]){
                [cell.recipeRepeatButton setImage:[UIImage imageNamed:@"new_repeat.png"] forState:UIControlStateNormal];
            }else{
                [cell.recipeRepeatButton setImage:[UIImage imageNamed:@"new_repeat_default.png"] forState:UIControlStateNormal];
            }
            
            cell.updateMealSettingButton.layer.borderWidth = 2.0f;
            cell.updateMealSettingButton.layer.borderColor =[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor;
            cell.editRecipeButton.layer.borderWidth = 2.0f;
            cell.editRecipeButton.layer.borderColor =[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0].CGColor;
            
            if (editRowNumber == indexPath.row) {
                cell.editMealButton.selected = true;
                cell.editMealButtonHeight.constant = 50;
                cell.editCustomMealViewHeight.constant = 50;
                cell.addCustomShoppingView.hidden = false;
            }else{
                cell.editMealButton.selected = false;
                cell.editMealButtonHeight.constant = 40;
                cell.editCustomMealViewHeight.constant = 0;
                cell.addCustomShoppingView.hidden = true;
            }
            
            if (isCustom && (isAllCustom || indexPath.row == activeCustomRowNumber)) {
                cell.addCustomShoppingView.hidden = false;
                if (squadCustomMealSessionList.count > 0){
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                    NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                    if (filteredArray.count > 0) {
                        cell.shoppingCheckUncheckButton.selected = true;
                        cell.shoppingQuantity.text =[NSString stringWithFormat:@"%@", filteredArray[0][@"NoofServe"]];
                        
                        cell.saveCustomShoppingButton.enabled=true;
                        cell.shoppingPlusButton.enabled = true;
                        cell.shoppingMinusButton.enabled = true;
                    }else{
                        cell.shoppingCheckUncheckButton.selected = false;
                        cell.shoppingQuantity.text = @"0";
                        cell.saveCustomShoppingButton.enabled=false;
                        cell.shoppingPlusButton.enabled = false;
                        cell.shoppingMinusButton.enabled = false;
                    }
                }else{
                    cell.shoppingCheckUncheckButton.selected = false;
                    cell.shoppingQuantity.text = @"0";
                    cell.saveCustomShoppingButton.enabled=false;
                    cell.shoppingPlusButton.enabled = false;
                    cell.shoppingMinusButton.enabled = false;
                }
            }else{
                cell.addCustomShoppingView.hidden = true;
            }
            if (isAllCustom) {
                cell.saveCustomShoppingButton.hidden = true;
            } else {
                cell.saveCustomShoppingButton.hidden = false;
            }
            
            [cell.shoppingButton setImage:[UIImage imageNamed:@"cart.png"] forState:UIControlStateNormal];
            cell.circleImage.hidden = true;
            cell.circleLabel.hidden = true;
            cell.recipeSwapButton.hidden = isCustom;
            if(isCustom){
                [cell.shoppingButton setImage:[UIImage imageNamed:@"sL_uncheck.png"] forState:UIControlStateNormal];
                if (squadCustomMealSessionList.count>0) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                    NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                    int noOfServe = 0;
                    if (![Utility isEmptyCheck:filteredArray]) {
                        noOfServe = [filteredArray[0][@"NoofServe"]intValue];
                        if (noOfServe <= 0) {
                            [cell.shoppingButton setImage:[UIImage imageNamed:@"sL_uncheck.png"] forState:UIControlStateNormal];
                        } else if (noOfServe == 1) {
                            [cell.shoppingButton setImage:[UIImage imageNamed:@"sL_check.png"] forState:UIControlStateNormal];
                        } else {
                            [cell.shoppingButton setImage:[UIImage imageNamed:@"cart_pink_background.png"] forState:UIControlStateNormal];
                            cell.circleImage.hidden = false;
                            cell.circleLabel.hidden = false;
                            cell.circleLabel.text = [NSString stringWithFormat:@"%d", noOfServe];
                        }
                    }
                }
            }else{
                if (squadCustomMealSessionList.count>0) {
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(MealId == %@) AND (MealSessionId == %@)",mealData[@"MealId"],mealData[@"MealSessionId"]];
                    NSArray *filteredArray = [squadCustomMealSessionList filteredArrayUsingPredicate:predicate];
                    int noOfServe = 0;
                    if (![Utility isEmptyCheck:filteredArray]) {
                        noOfServe = [filteredArray[0][@"NoofServe"]intValue];
                        [cell.shoppingButton setImage:[UIImage imageNamed:@"cart_pink_background.png"] forState:UIControlStateNormal];
                        cell.circleImage.hidden = false;
                        cell.circleLabel.hidden = false;
                        cell.circleLabel.text = [NSString stringWithFormat:@"%d", noOfServe];
                    }
                }
            }
            
            tableViewCell = cell;
        }
    }else{
        /*NSString *CellIdentifier =@"CustomNutritionPlanListBlankCollectionViewCell";
        CustomNutritionPlanListBlankCollectionViewCell *cell = (CustomNutritionPlanListBlankCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        tableViewCell = cell;*/
        NSString *CellIdentifier =@"CustomNutritionPlanListTableViewCell";
        CustomNutritionPlanListTableViewCell *cell = (CustomNutritionPlanListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSLog(@"no meal data found");
        tableViewCell = cell;
    }
    
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isCustom){
        return;
    }
    if (tableView == table) {
        NSDictionary *dict = nutritionPlanListArray[dayNumber]; //indexPath.section];
        NSArray *mealDataArray = dict[@"mealData"];
        NSDictionary *mealData = mealDataArray[indexPath.row];
        //NSDictionary *mealDetails = mealData[@"MealDetails"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        NSString *dateStr = mealData[@"MealDate"];
        if (![Utility isEmptyCheck:dateStr]) {
            NSDate *dailyDate = [formatter dateFromString:dateStr];
            if (dailyDate) {
                [formatter setDateFormat:@"dd MM yyyy"];
                NSString *dateString = [formatter stringFromDate:dailyDate];
                DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
                controller.delegate = self;
                controller.mealId = [mealData objectForKey:@"MealId"];
                controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
                controller.dateString = dateString;
                controller.fromController = @"Meal";    //ah ux
                [self.navigationController pushViewController:controller animated:YES];
            }
            
        }
    } else {
        if (myFavrtPlanList.count>0) {
            NSDictionary *mealData = myFavrtPlanList[indexPath.row];
//            NSDictionary *mealDetails = mealData[@"MealDetails"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
            NSString *dateStr = mealData[@"MealDate"];
            NSDate *dailyDate = [formatter dateFromString:dateStr];
            NSString *dateString = [formatter stringFromDate:dailyDate];
            DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
            controller.delegate = self;
            controller.mealId = [mealData objectForKey:@"MealId"];
            controller.mealSessionId = [mealData objectForKey:@"MealSessionId"];
            controller.dateString = dateString;
            controller.fromController = @"Meal";
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

}

#pragma mark -End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - TextViewDelegate

//Today_SetProgram_In
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"Revert"])
    {
        if (![Utility isEmptyCheck:ProgramIdStr] && ![Utility isEmptyCheck:UserProgramIdStr] && ![Utility isEmptyCheck:weekDate]) {
            ResetProgramViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ResetProgramView"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd'T'HH:mm:ss"
            NSString *weekStartStr = [dateFormat stringFromDate:weekDate];
            controller.weekStartDayStr = weekStartStr;
            
            controller.programIdStr = ProgramIdStr;
            controller.userprogramIdStr = UserProgramIdStr;
            controller.option = @"CancelNutrition";
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView setInputAccessoryView:toolBar];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [textView resignFirstResponder];
    
}
#pragma mark - End
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
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
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    mainScroll.contentInset = contentInsets;
//    mainScroll.scrollIndicatorInsets = contentInsets;
//
//    if (activeTextField !=nil) {
//        CGRect aRect = mainScroll.frame;
//        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
//        aRect.size.height -= kbSize.height;
//        CGPoint tempPoint = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
//        if (!CGRectContainsPoint(aRect,tempPoint) ) {
//            [mainScroll scrollRectToVisible:frame animated:YES];
//        }
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    mainScroll.contentInset = contentInsets;
//    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End
#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField endEditing:YES];
}

#pragma mark - End
#pragma mark -DropDownView Delegates
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender{
    //@{@"Number":@"1",@"Value":@"FOOD PREP"}
    //@{@"Number":@"2",@"Value":@"SAVE MEAL PLAN"}
    //@{@"Number":@"3",@"Value":@"SAVE MEAL PLAN AS"}
    //@{@"Number":@"4",@"Value":@"VIEW SAVED MEAL PLANS"}
    if (![Utility isEmptyCheck:data]){
        if ([type caseInsensitiveCompare:@"Meal"] == NSOrderedSame) {
            if ([[data objectForKey:@"Number"]intValue] == 1) {
                FoodPrepViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrep"];
                controller.delegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([[data objectForKey:@"Number"]intValue] == 2) {
                
                if(savedPlanDict.count == 0 || savedPlanDict == nil){// new save
                    saveMealPlanView.hidden = false;
                    swapMealPlanButton.hidden = true;
                    saveMealTextField.text = @"";
                    saveMealTextView.text = @"";
                    saveMealTextField.userInteractionEnabled = true;
                    mealPlanNumber = 1;
                }else{//changes save
                    saveMealTextField.text = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
                    saveMealTextView.text = ![Utility isEmptyCheck:savedPlanDict[@"Description"]]?savedPlanDict[@"Description"]:@"";
//                    saveMealTextField.userInteractionEnabled = false;
                    mealPlanNumber = 2;
                    [self saveMealPlanPressed:0];
                }
            }else if ([[data objectForKey:@"Number"]intValue] == 3) {//save as
                saveMealPlanView.hidden = false;
                mealPlanNumber = 3;
                
                saveMealTextField.userInteractionEnabled = true;
                swapMealPlanButton.hidden = true;
//                [swapMealPlanButton setTitle:![Utility isEmptyCheck:selectedDict[@"Name"]]?selectedDict[@"Name"]:@"" forState:UIControlStateNormal];
                saveMealTextField.text = ![Utility isEmptyCheck:savedPlanDict[@"Name"]]?savedPlanDict[@"Name"]:@"";
                saveMealTextView.text = ![Utility isEmptyCheck:savedPlanDict[@"Description"]]?savedPlanDict[@"Description"]:@"";
            }else if ([[data objectForKey:@"Number"]intValue] == 4) {
                SavedNutritionPlanViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SavedNutritionPlan"];
                controller.delegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([[data objectForKey:@"Number"]intValue] == 5) {
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@""
                                                      message:@"Are you sure want to revert the current Saved meal plan to Custom meal plan?"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"Yes"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self resetMealPlanForSquadUserFromSavedPlan];
                                           }];
                UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"No"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               
                                           }];
                [alertController addAction:okAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }else if ([type caseInsensitiveCompare:@"SavePlan"] == NSOrderedSame) {
            [sender setTitle:data[@"Name"] forState:UIControlStateNormal];
            saveMealTextView.text = ![Utility isEmptyCheck:data[@"Description"]]?data[@"Description"]:@"";
            savedPlanDict = [data mutableCopy];
        }
    }
}
#pragma mark -End
#pragma mark - ResetViewControllerDelegate
-(void)didPerformRevertOption{
    [self getSquadMealPlanWithSettings];
    for(UIViewController *controller in [self childViewControllers]){
        if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
            CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
            new.weekDate = weekDate;
            [new reloadMyCollection];
        }
    }
}
#pragma mark - End
//Today_SetProgram_In

#pragma mark - MealSwapDropDown Delegate
-(void)didSwapComplete:(BOOL)isComplete{
    
    isLoadController = YES;
}
-(void)didMultiSwapCompleteWithDropdown:(NSDictionary *)swapDict{
    if(!gridButton.isSelected){
        
        NSDictionary *mealDetailDict = swapDict[@"MealDetail"];
        NSString *dataStr = @"";
        if(![Utility isEmptyCheck:mealDetailDict[@"MealName"]]){
            dataStr = mealDetailDict[@"MealName"];
        }
        
        swapMealNameLabel.text = dataStr;
        _multipleSwapHeaderView.hidden = false;
        
        
        for (UIView *view in shoppingButtonCollection) {
            view.hidden = true;
        }
        gridButton.selected=true;
        listButton.selected=false;
        favButton.selected=false;
        
        for(UIViewController *controller in [self childViewControllers]){
            if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                new.isMultipleSwap = true;
                new.isListView = true;
                new.swapMealDict = swapDict;
                new.applyMultipleSwapButton.hidden = false;
                [new reloadMyCollection];
            }
        }
        
        isFav = false;
        isCollection = true;
        collection.hidden=true;
        table.hidden=true;
        myFavView.hidden = true;
        myContainer.hidden=false;
    }
    
}
-(void)swapMealHeaderName:(NSDictionary *)swapDict active:(BOOL)isActive{
    if (isActive) {
        NSString *dataStr = @"";
        if(![Utility isEmptyCheck:swapDict[@"MealName"]]){
            dataStr = swapDict[@"MealName"];
        }
        
        swapMealNameLabel.text = dataStr;
        _multipleSwapHeaderView.hidden = false;
    } else {
        _multipleSwapHeaderView.hidden = true;
        [self getSquadMealPlanWithSettings];
    }
}
#pragma mark - End

#pragma mark - Advanced Search Delegate
-(void)didSwapCompleteWithSearchedMeal:(BOOL)isComplete{
  isLoadController = YES;
}
- (void)didMultipleSwap:(NSDictionary *)swapDict{
    
    if(!gridButton.isSelected){
        
        
        NSString *dataStr = @"";
        if(![Utility isEmptyCheck:swapDict[@"MealName"]]){
            dataStr = swapDict[@"MealName"];
        }
        
        swapMealNameLabel.text = dataStr;
        _multipleSwapHeaderView.hidden = false;
        
        for (UIView *view in shoppingButtonCollection) {
            view.hidden = true;
        }
        gridButton.selected=true;
        listButton.selected=false;
        favButton.selected=false;
        
        for(UIViewController *controller in [self childViewControllers]){
            if ([controller isKindOfClass:[CustomNutritionPlanListCollectionViewController class]]) {
                CustomNutritionPlanListCollectionViewController *new = (CustomNutritionPlanListCollectionViewController *)controller;
                new.isMultipleSwap = true;
                new.swapMealDict = swapDict;
                new.applyMultipleSwapButton.hidden = false;
                [new reloadMyCollection];
            }
        }
        
        isFav = false;
        isCollection = true;
        collection.hidden=true;
        table.hidden=true;
        myFavView.hidden = true;
        myContainer.hidden=false;
    }
}
#pragma mark - End
//Nutrition_Local_catch
#pragma mark - AddEditCustomNutritionDelegate
-(void)didCheckAnyChange:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - CustomNutritionMealSettingsDelegate
-(void)didCheckAnyChangeForMealSettings:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - CustomNutritionCollection

-(void)didCheckAnyChangeForCollection:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - FoodPrepDelegate
-(void)didCheckAnyChangeForFoodPrep:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - ShoppingListViewDelegate

-(void)didCheckAnyChangeForShoppingList:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - MealMatchViewDelegate
-(void)didCheckAnyChangeForMealMatch:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - End

#pragma mark - DailyGoodnessDetailsDelegate
-(void)didCheckAnyChangeForDailyGoodness:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - SavedNutritionViewDelegate
-(void)didCheckAnyChangeForSavedNutrition:(BOOL)ischanged{
    isLoadController = ischanged;
}
#pragma mark - NutritionPlanNotification
-(void)didCheckAnyChangeForMealPlan:(NSNotification*)notification{
    isLoadController = true;
}
-(void)reloadCustom:(NSNotification*)notification{
    isLoadController = true;
}
-(void)reloadFromFooter:(NSNotification*)notification{
    isLoadController = true;
}
//Nutrition_Local_catch
@end
