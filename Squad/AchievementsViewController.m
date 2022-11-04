//
//  AchievementsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AchievementsViewController.h"
#import "AchievementsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GratitudeListViewController.h"

@interface AchievementsViewController (){
    IBOutlet UILabel *headerFirstLabel;
    IBOutlet UILabel *headerSecondLabel;
    IBOutlet UILabel *headerThirdLabel;
    
    IBOutlet UIStackView *achievementStackView;
    IBOutlet UIView *videoView;
    IBOutlet UITableView *tableView;
    AVPlayer *videoPlayer;
    AVPlayerViewController *playerController;
    NSArray *achievementsListArray;
    UIView *contentView;
    BOOL isExpand;
    BOOL shouldSetupRem;
    NSDate *selectedDate;
    UIButton *SelectedFilterbtn;
    NSArray *masterAchievementListArr;

    
    IBOutlet UILabel *noDataLabel;
   
    
    IBOutlet UIView *viewFilter;
    IBOutlet UIButton *filterButton;
    
    IBOutlet UIButton *selectDateButton;
    IBOutlet UIButton *showResultButton;
    IBOutlet UIButton *clearAllButton;
    
    IBOutlet UIButton *expandButton;
    IBOutletCollection(UIButton) NSArray *dateOutletCollection;
    IBOutlet UIButton *havePictureButton;
    
    IBOutletCollection(UIView) NSArray *viewOutletCollection;
    NSString *selectedState;
    NSDate *selectedDateFrom;
    NSDate *selectedDateTo;
    
    IBOutlet UITextField *searchTextField;
    IBOutlet UIButton *plusButton;
    UIToolbar *toolBar;
    
    IBOutlet UIButton *fromDateButton;
    IBOutlet UIButton *toDateButton;
    IBOutlet UIView *dateRangeView;
    IBOutlet UIButton *printButton;
    UIRefreshControl *refreshControl;
    IBOutlet UIView *addButtonShowView;
    IBOutlet UIView *editDelView;

    IBOutlet UIButton *editButton;
    IBOutlet UIButton *delButton;
    IBOutlet UIView *editDelSubView;
    
    IBOutlet UIView *walkThroughView;
    IBOutlet UIButton *walkThroughGotItButton;
    IBOutlet UIButton *passwordLockButton;
    IBOutlet UIView *eqView;
    IBOutlet UIButton *eqGotItButton;

    
    NSMutableArray *selectedTypeFilterArray;
    BOOL isAddPresssed;
    NSMutableDictionary *achievementDict;
    BOOL isFromNotesFirstentry;
    BOOL isDropdownShow;
    
    IBOutlet UIButton *crossButton;
    IBOutlet UILabel *hiUserLabel;
    IBOutlet UIButton *chooseButton;
    IBOutlet UIButton *randomButton;
    IBOutlet UIView *dailyPopUpView;
    IBOutlet UIView *dailyPopUpInnerView;
    IBOutlet UIView *chooseBtnView;
    IBOutlet UIView *randomBtnView;
    
    NSString *errorMessageRandom;
    NSString *randomPromptRandom;
    NSInteger *successFlagRandom;
    NSString *userPromptRandom;
    
    IBOutlet UIImageView *achievementImageView;
    IBOutlet UIView *achievementListImageView;
    NSString *localImageName;
    UIImage *selectedImage;
    IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
    
    bool havePictureButtonIsSelected;
}

@end

@implementation AchievementsViewController
@synthesize goalValueArray,gratitudePopUpPressed;

#pragma mark - IBAction
- (IBAction)walkThroughCrossButtonPressed:(UIButton *)sender {
    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeGrowth"];
    walkThroughView.hidden=true;
}

- (IBAction)addAchievementButtonPressed:(id)sender {

    AchievementsAddEditNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEditNew"];
    controller.isEdit = true;
    controller.isNewReverseBucket = true; //gami_badge_popup
    controller.achievementDelegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeView:(UIButton *)sender
{
    viewFilter.hidden = YES;
}

- (IBAction)filterButtonPressed:(UIButton *)sender
{
    viewFilter.hidden = NO;
}

- (IBAction)expandButtonPressed:(UIButton *)sender
{
    expandButton.selected = !expandButton.isSelected;
    
    [expandButton setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
    
    if(expandButton.isSelected){
        [expandButton setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [expandButton setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewOutletCollection) {
            btn.hidden = true;
        }
    }
}



- (IBAction)dateButtonPressed:(UIButton *)sender{
    
  for (UIButton *btn in dateOutletCollection) {
            if (btn.tag == 6) {
                 btn.selected = true;
                SelectedFilterbtn = btn;
            }
    }
//    [self clearSelectedDate];
    [self selectDateButtonPressed:sender];
}



- (IBAction)dateOutletCollectionPressed:(UIButton *)sender
{
    //MArk: ShowAll Button selected
    if (sender.isSelected) {
        if (sender.tag ==1){
            return;
        }
        sender.selected = false;
        if(sender.tag >=7){
            [selectedTypeFilterArray removeObject:[NSNumber numberWithInt:(int)sender.tag]];
            //break;
        }else{
            SelectedFilterbtn = nil;
            dateRangeView.hidden=YES;
        }
        
        if(!SelectedFilterbtn && selectedTypeFilterArray.count<=0){
            [self clearButtonPressed:sender];
        }
        
        //[self clearButtonPressed:sender];
    }else{
        //MArk: ShowAll Button selected
        for (UIButton *btn in dateOutletCollection) {
            if (sender==btn)
            {
                if(btn.tag == 1){
                   [self clearButtonPressed:btn];
                    break;
                }
                
                [self clearSelectedDate];
                btn.selected = true;
                
                if(btn.tag >=7){
                    [selectedTypeFilterArray addObject:[NSNumber numberWithInt:(int)btn.tag]];
                    //break;
                }else{
                    SelectedFilterbtn = btn;
                    if (btn.tag == 6) {
                        //[self selectDateButtonPressed:btn];
                        [fromDateButton setTitle:@"From Date" forState:UIControlStateNormal];
                        [toDateButton setTitle:@"To Date" forState:UIControlStateNormal];
                        dateRangeView.hidden=NO;
                    }
                }
            } else {
                if((btn.tag >=7 || sender.tag>=7) && btn.tag != 1){
                    if(SelectedFilterbtn && SelectedFilterbtn.tag != 6){
                        dateRangeView.hidden=YES;
                    }
                   continue;
                }
                
                btn.selected = false;
                if(btn == SelectedFilterbtn){
                    SelectedFilterbtn = nil;
                }
            }
        }
        if (sender==havePictureButton) {
            havePictureButton.selected = true;
            havePictureButtonIsSelected = true;
//            [selectedTypeFilterArray addObject:[NSNumber numberWithInt:(int)sender.tag]];
        }
    }
}
- (IBAction)selectDateButtonPressed:(UIButton *)sender
{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    if (sender.tag==0) {
        if (![Utility isEmptyCheck:selectedDateFrom]) {
            controller.selectedDate = selectedDateFrom;
        }
        controller.dateType=@"From";
    }
    if (sender.tag==1) {
        if (![Utility isEmptyCheck:selectedDateTo]) {
            controller.selectedDate = selectedDateTo;
        }
        controller.dateType=@"To";
    }
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (IBAction)showResultButtonPressed:(UIButton *)sender
{
    [self filterDataFromDate];
    viewFilter.hidden = YES;
    if (!(SelectedFilterbtn.tag == 1)) {
        filterButton.selected = true;
    }else{
        filterButton.selected = false;
    }
}

- (IBAction)clearButtonPressed:(UIButton *)sender
{
    [self clearSelectedDate];
    if (selectedTypeFilterArray.count>0){
        [selectedTypeFilterArray removeAllObjects];
    }
    filterButton.selected = false;
    for (UIButton *btn in dateOutletCollection) {
        if(btn.tag == 1){
            btn.selected = true;
            SelectedFilterbtn = btn;
        }else{
            btn.selected = false;
        }
    }
    havePictureButton.selected=false;
    havePictureButtonIsSelected = false;
    dateRangeView.hidden=true;
    [self filterDataFromDate];
    viewFilter.hidden = YES;
}
-(IBAction)notificationOnOffButtonPressed:(UIButton*)sender{
//    achievementDict = [[NSMutableDictionary alloc]init];
//    [achievementDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
//    [achievementDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
//    [self saveDataMultiPart];
    
        NSDictionary *dict = [achievementsListArray objectAtIndex:sender.tag];
        if ([Utility isEmptyCheck:dict]) {
            return;
         }
        AchievementsAddEditNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEditNew"];
        controller.isFromListReminder = true;
        controller.achievementsData = [dict mutableCopy];
        controller.achievementDelegate = self;
       [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)addButtonPressed:(id)sender{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([Utility isEmptyCheck:[defaults objectForKey:@"EQShowDate"]]) {
            self->eqView.hidden=false;
            [defaults setObject:[NSDate date] forKey:@"EQShowDate"];
            self->isDropdownShow=YES;
        }else if (![Utility isEmptyCheck:[defaults objectForKey:@"EQShowDate"]]){
            NSDate *lastShownDate=[defaults objectForKey:@"EQShowDate"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
            NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
            
            lastShownDate=[formatter dateFromString:lastShownDateString];
            NSDate *todayDate=[formatter dateFromString:todayDateStr];
            
            if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
                self->eqView.hidden=false;
                [defaults setObject:[NSDate date] forKey:@"EQShowDate"];
                self->isDropdownShow=YES;
            }else{
                self->eqView.hidden=true;
                self->isDropdownShow=NO;
                DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                controller.modalPresentationStyle = UIModalPresentationCustom;
                controller.dropdownDataArray = growthOptionArr;
                controller.apiType = @"Growth";
                if (self->userPromptRandom != nil) {
                    controller.userPromptRandom = self->userPromptRandom;
                }
                
                if (![Utility isEmptyCheck:self->selectedState]) {
                    controller.selectedIndex = (int)[growthOptionArr indexOfObject:self->selectedState];
                }else{
                    controller.selectedIndex = 0;
                }
                controller.delegate = self;
                controller.sender = sender;
                [self presentViewController:controller animated:YES completion:nil];
            }
        }
        
        
            
       
    });
}

- (IBAction)searchButtonPressed:(id)sender {
//    searchTextField.hidden=!searchTextField.hidden;
    plusButton.hidden=!plusButton.hidden;
}

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)printButtonPressed:(id)sender{
    viewFilter.hidden = true;
    [self webServicecallForEmailReverseBucketList];
}
-(IBAction)editDelCrossPressed:(id)sender{
    editDelView.hidden = true;
}
-(IBAction)editPressed:(UIButton*)sender{
       editDelView.hidden = true;
       if ([Utility isEmptyCheck:achievementsListArray[sender.tag]]) {
              return;
        }
         NSDictionary *dict = [achievementsListArray objectAtIndex:sender.tag];
          AchievementsAddEditNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEditNew"];
          controller.achievementsData = [dict mutableCopy];
          controller.achievementDelegate = self;
         [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)deleteButtonPressed:(UIButton*)sender{
        editDelView.hidden = true;
        if ([Utility isEmptyCheck:achievementsListArray[sender.tag]]) {
          return;
        }
        NSDictionary *dict = achievementsListArray[sender.tag];

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Do you want to delete ?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"DELETE"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                [self delete:dict];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

}
-(IBAction)passwordLockValueChanged:(UIButton *)sender{
   [self->passwordLockButton setSelected:!self->passwordLockButton.isSelected];
        
    [defaults setBool:passwordLockButton.isSelected forKey:@"isGrowthScreenLock"];
    [defaults synchronize];
  
}
-(IBAction)eqButtonPressed:(id)sender{
    eqView.hidden = false;
}
-(IBAction)eqGotItPressed:(id)sender{
    eqView.hidden = true;
    if (isDropdownShow) {
        isDropdownShow=NO;
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = growthOptionArr;
        controller.apiType = @"Growth";
        if (![Utility isEmptyCheck:self->selectedState]) {
            controller.selectedIndex = (int)[growthOptionArr indexOfObject:self->selectedState];
        }else{
            controller.selectedIndex = 0;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (IBAction)crossButtonPressed:(id)sender {
    dailyPopUpView.hidden = true;
}
- (IBAction)chooseButtonPressed:(id)sender {
    dailyPopUpView.hidden = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([Utility isEmptyCheck:[defaults objectForKey:@"EQShowDate"]]) {
                self->eqView.hidden=false;
                [defaults setObject:[NSDate date] forKey:@"EQShowDate"];
                self->isDropdownShow=YES;
            }else if (![Utility isEmptyCheck:[defaults objectForKey:@"EQShowDate"]]){
                NSDate *lastShownDate=[defaults objectForKey:@"EQShowDate"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
                NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
                
                lastShownDate=[formatter dateFromString:lastShownDateString];
                NSDate *todayDate=[formatter dateFromString:todayDateStr];
                
                if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
                    self->eqView.hidden=false;
                    [defaults setObject:[NSDate date] forKey:@"EQShowDate"];
                    self->isDropdownShow=YES;
                }else{
                    self->eqView.hidden=true;
                    self->isDropdownShow=NO;
                    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                    controller.modalPresentationStyle = UIModalPresentationCustom;
                    controller.dropdownDataArray = growthOptionArr;
                    controller.apiType = @"Growth";
                    if (![Utility isEmptyCheck:self->selectedState]) {
                        controller.selectedIndex = (int)[growthOptionArr indexOfObject:self->selectedState];
                    }else{
                        controller.selectedIndex = 0;
                    }
                    controller.delegate = self;
                    controller.sender = sender;
                    [self presentViewController:controller animated:YES completion:nil];
                }
            }
            
            
                
           
        });
}
- (IBAction)randomButtonPressed:(id)sender {

    dailyPopUpView.hidden = true;
    
    
    //3 November 2022 AC
    dispatch_async(dispatch_get_main_queue(), ^{
                DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                controller.modalPresentationStyle = UIModalPresentationCustom;
                controller.dropdownDataArray = growthOptionArr;
                controller.apiType = @"Growth";
                if (self->userPromptRandom != nil) {
                    controller.userPromptRandom = self->userPromptRandom;
                }
                controller.selectedIndex = 2;
                controller.delegate = self;
                controller.sender = sender;
                [self presentViewController:controller animated:YES completion:nil];
    });
    //3 November 2022 AC
}
#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date dateType:(NSString *)dateType{
    NSLog(@"%@",date);
    if (date) {
        if ([dateType isEqualToString:@"From"]) {
                    SelectedFilterbtn = nil;
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            selectedDateFrom = date;
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
            NSString *dateString = [dateFormatter stringFromDate:date];
            // [dateLabel setText:[NSString stringWithFormat:@"Date: %@",dateString]];
            //[selectDateButton setText:[NSString stringWithFormat:@"Date: %@",dateString]];
            [fromDateButton setTitle:dateString forState:UIControlStateNormal];
            //        UIButton *btn = [[UIButton alloc]init];
            //        btn.tag = 6;
            //        [self dateOutletcollectionPressed:btn];
        }
        if ([dateType isEqualToString:@"To"]) {
                    SelectedFilterbtn = nil;
            static NSDateFormatter *dateFormatter;
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            selectedDateTo = date;
            [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
            NSString *dateString = [dateFormatter stringFromDate:date];
            [toDateButton setTitle:dateString forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Private Method

//pull to refresh
- (void)refreshTable {
    [refreshControl endRefreshing];
    [self webServicecallForGetReverseBucketListApiCall];
}



-(void)filterDataFromDate
{
    if([Utility isEmptyCheck:masterAchievementListArr] || masterAchievementListArr.count<=0){
        return;
    }
    searchTextField.text=@"";
//    searchTextField.hidden=true;
    plusButton.hidden=false;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *today = [NSDate date];
    
    if(SelectedFilterbtn){
#pragma mark: Filter Show All
        if(SelectedFilterbtn.tag == 1){
            if(selectedTypeFilterArray.count>0){
                [selectedTypeFilterArray removeAllObjects];
            }
            achievementsListArray = masterAchievementListArr;
        }
#pragma mark: Filter Today
        else if(SelectedFilterbtn.tag == 2){
            NSString *dateString = [formatter stringFromDate:today];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CreatedAtString =  %@",dateString];
            achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter This Month
        else if(SelectedFilterbtn.tag == 3){
            NSDate *firstDay = [NSDate dateWithYear:[today year] month:[today month] day:1];
            
            NSDate *lastDay = [NSDate dateWithYear:[today year] month:[today month] day:[today daysInMonth]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:firstDay],[formatter stringFromDate:lastDay]];
            
            achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter 6 Months ago
        else if(SelectedFilterbtn.tag == 4){
            NSDate *sixMonths = [today dateBySubtractingDays:90];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:sixMonths],[formatter stringFromDate:today]];
            achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
        }
#pragma mark: Filter 1 year ago
        else if(SelectedFilterbtn.tag == 5){
            NSDate *oneYear = [today dateBySubtractingDays:365];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <= %@)",[formatter stringFromDate:oneYear],[formatter stringFromDate:today]];
            achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
            
        }
        
#pragma mark: Filter Select Date
        else if (SelectedFilterbtn.tag==6){
            if(selectedDateFrom && selectedDateTo){
                NSString *dateString1 = [formatter stringFromDate:selectedDateFrom];
                NSString *dateString2 = [formatter stringFromDate:selectedDateTo];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <=  %@)",dateString1,dateString2];
                achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
            }
            else{
                [Utility msg:@"Please select date range" title:@"Oops!" controller:self haveToPop:NO];
            }
        }
    }
    else{
#pragma mark: Filter Select Date
        if(selectedDateFrom && selectedDateTo){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSString *dateString1 = [formatter stringFromDate:selectedDateFrom];
            NSString *dateString2 = [formatter stringFromDate:selectedDateTo];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CreatedAtString >= %@) AND (CreatedAtString <=  %@)",dateString1,dateString2];
            achievementsListArray = [masterAchievementListArr filteredArrayUsingPredicate:predicate];
        }
    }
    
    if (selectedTypeFilterArray.count > 0) {
        
        
        if(!selectedDateFrom && !selectedDateTo && !SelectedFilterbtn){//[Utility isEmptyCheck:achievementsListArray]
            achievementsListArray = masterAchievementListArr;
        }

        NSString *tagPredicateString=@"";
        for (int i=0; i<selectedTypeFilterArray.count; i++) {
            int selectedIndex = [selectedTypeFilterArray[i] intValue];
            if (i+1==selectedTypeFilterArray.count) {
                if(selectedIndex == 7){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I am proud of"];
                    
                }else if(selectedIndex == 8){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I\\'ve accomplished"];
                    
                }else if(selectedIndex== 9){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I\\'ve observed"];
                   
                }else if(selectedIndex == 10){
                     tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I\\'ve learned"];
                }else if(selectedIndex == 11){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I\\'ve praised"];
                    
                }else if(selectedIndex == 12){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"Today I\\'ve let"];
                    
                }else if(selectedIndex == 13){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I dreamt of"];
                    
                }else if(selectedIndex == 14){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"Journal Entry"];
                    
                }else if(selectedIndex == 15){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"The story I\\'ve told myself is"];
                    
                }else if(selectedIndex == 16){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I\\'ve been challenged by"];
                }
                else if(selectedIndex == 17){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"A small win I\\'m celebrating is"];
                }
                else if(selectedIndex == 18){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"I laughed"];
                }else if(selectedIndex == 19){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@')",@"Today I\\'m Feeling"];
                }
            }else{
                if(selectedIndex == 7){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I am proud of"];
                    
                }else if(selectedIndex == 8){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I\\'ve accomplished"];
                    
                }else if(selectedIndex== 9){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I\\'ve observed"];
                   
                }else if(selectedIndex == 10){
                    
                     tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I\\'ve learned"];
                    
                }else if(selectedIndex == 11){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I\\'ve praised"];
                    
                }else if(selectedIndex == 12){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"Today I\\'ve let"];
                    
                }else if(selectedIndex == 13){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I dreamt of"];
                    
                }else if(selectedIndex == 14){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"Journal Entry"];
                    
                }else if(selectedIndex == 15){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"The story I\\'ve told myself is"];
                    
                }else if(selectedIndex == 16){
                    tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I\\'ve been challenged by"];
                    
                }else if(selectedIndex == 17){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"A small win I\\'m celebrating is"];
                }
                else if(selectedIndex == 18){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"I laughed"];
                }else if(selectedIndex == 19){
                      tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Achievement beginswith[c] '%@') OR ",@"Today I\\'m Feeling"];
                }
                
            }
        }
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",tagPredicateString]];
        achievementsListArray = [achievementsListArray filteredArrayUsingPredicate:predicate];
    }
    
    if (havePictureButton.isSelected) {
        havePictureButtonIsSelected = true;
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Picture != %@ and Picture != %@)",@"",@"<null>"];
//        achievementsListArray = [achievementsListArray filteredArrayUsingPredicate:predicate];
    }else{
        havePictureButtonIsSelected = false;
    }

    [tableView reloadData];
}

-(void)clearSelectedDate{
    selectedDate = nil;
    selectedDateFrom=nil;
    selectedDateTo=nil;
    [selectDateButton setTitle:@"SELECT DATE" forState:UIControlStateNormal];
}


-(void)sizeHeaderToFit{
    UIView *headerView = tableView.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    tableView.tableHeaderView = headerView;
}
-(void) playVideoWithUrlStr:(NSString *)urlStr InsideView:(UIView *)playerView {
    if (playerController.player || videoPlayer) {
        [playerController.player pause];
        [videoPlayer pause];
        videoPlayer = nil;
        [playerController removeFromParentViewController];
    }
    NSURL *videoURL = [NSURL URLWithString:urlStr];
    
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    // create an AVPlayer
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    // create a player view controller
    playerController = [[AVPlayerViewController alloc]init];
    playerController.player = videoPlayer;
    playerController.showsPlaybackControls = true;
    [videoPlayer play];
    
    // show the view controller
    [self addChildViewController:playerController];
    [playerView addSubview:playerController.view];
    playerController.view.frame = playerView.bounds;
}

-(void)webServicecallForGetReverseBucketListApiCall{
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
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSLog(@"ReversemainDict====>%@",mainDict);
        NSLog(@"");
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetReverseBucketListApiCall" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       self->masterAchievementListArr = [responseDictionary objectForKey:@"Details"];
                                                                       if (![Utility isEmptyCheck:self->masterAchievementListArr] && self->masterAchievementListArr.count>0) {
                                                                           self->achievementsListArray = [self->masterAchievementListArr mutableCopy];
                                                                           self->addButtonShowView.hidden = true;

                                                                           if (self->shouldSetupRem) {
                                                                               self->shouldSetupRem = NO;
                                                                               [self setUpReminder];    //ah ln
                                                                               self->tableView.hidden = false;
                                                                           }
                                                                       }else{
                                                                           self->achievementsListArray = [[NSArray alloc]init];
                                                                           self->addButtonShowView.hidden = false;
                                                                           self->tableView.hidden = true;
                                                                       }
                                                                       [self->tableView reloadData];
                                                                       [self filterDataFromDate];
                                                                       
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        if ([Utility reachable]) {
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)webServicecallForGetJounalPromptofDay{
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
//        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSLog(@"JournalmainDict====>%@",mainDict);
        NSLog(@"");
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetJounalPromptofDay" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       NSLog(@"responseDictionary=====>%@",responseDictionary);
                                                                       NSLog(@"");
                                                                       
                                                                       self->userPromptRandom = [responseDictionary objectForKey:@"PromptOftheDay"];
                                                                       [defaults setObject:self->userPromptRandom forKey:@"userPromptRandom"];
                                                                       NSLog(@"userPromptRandom======>%@",self->userPromptRandom);
                                                                       NSLog(@"");
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        if ([Utility reachable]) {
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
//-(void)webServicecallForUpdateUserJounalPrompt{
//    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//            self->contentView = [Utility activityIndicatorView:self];
//        });
//        NSURLSession *achieveSession = [NSURLSession sharedSession];
//
//        NSError *error;
//
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
//        [mainDict setObject:AccessKey forKey:@"Key"];
//        [mainDict setObject:[defaults objectForKey:@"userPromptRandom"] forKey:@"Prompt"];
//        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
//        NSLog(@"%@",mainDict);
//        NSLog(@"");
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
//        if (error) {
//            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
//            return;
//        }
//        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
//
//        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateUserJounalPrompt" append:@"" forAction:@"POST"];
//
//        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
//                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                                               dispatch_async(dispatch_get_main_queue(),^ {
//                                                                   if (self->contentView) {
//                                                                       [self->contentView removeFromSuperview];
//                                                                   }
//                                                                   if(error == nil)
//                                                                   {
//                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                       NSLog(@"responseDictionary=====>%@",responseDictionary);
//                                                                       NSLog(@"");
//
//                                                                   }else{
//                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
//                                                                   }
//                                                               });
//                                                           }];
//        [dataTask resume];
//
//    }else{
//        if ([Utility reachable]) {
//            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
//        }
//    }
//
//}
-(void)webServicecallForEmailReverseBucketList{
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
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSLog(@"EmailmainDict====>%@",mainDict);
        NSLog(@"");
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"EmailReverseBucketList" append:@"" forAction:@"POST"];
        
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
                                                                           [Utility msg:@"Growth details sent to mail" title:@"" controller:self haveToPop:NO];
                                                                       }
                                                                      
                                                                   }else{
                                                                       [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                   }
                                                               });
                                                           }];
        [dataTask resume];
        
    }else{
        if ([Utility reachable]) {
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)delete:(NSDictionary*)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[dict valueForKey:@"Id"] forKey:@"ReverseBucketID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteReverseBucketApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@"Success"
                                                                                                               message:@"Growth Deleted Successfully. "
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"OK"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                        self->shouldSetupRem = true;
                                                                                                        [self webServicecallForGetReverseBucketListApiCall];
                                                                                                    }];
                                                                         [alertController addAction:okAction];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
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
-(void) saveDataMultiPart {
    if (Utility.reachable) {
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:achievementDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
       
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateReverseBucketApiCallWithPhoto";
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

- (void) setUpReminder
{
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"Achievement"] == NSOrderedSame) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:req];
            
        }
    }
    
    for (int i = 0; i < achievementsListArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[achievementsListArray objectAtIndex:i]];
        if ([[dict objectForKey:@"PushNotification"] boolValue]) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"Id"]] && ![Utility isEmptyCheck:[dict objectForKey:@"FrequencyId"]]) {
                NSDictionary *dict1 = @{@"Id" : [dict objectForKey:@"Id"]};
                [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:[dict1 mutableCopy] FromController:@"Achievement" Title:[dict objectForKey:@"Name"] Type:@"Achievement" Id:[[dict objectForKey:@"Id"] intValue]];
            }
          
        }
    }
    
}

#pragma mark - View Life Cycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if(gratitudePopUpPressed){
   [self addButtonPressed:0];
        gratitudePopUpPressed = false;
    }else{
        if([Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUpInAchievements"]]){
            [defaults setObject:[NSDate date] forKey:@"DailyPopUpInAchievements"];
            dailyPopUpView.hidden = false;
            dailyPopUpInnerView.layer.cornerRadius=15;
            dailyPopUpInnerView.layer.masksToBounds=true;
            chooseButton.layer.cornerRadius=15;
            chooseButton.layer.masksToBounds=true;
            randomButton.layer.cornerRadius=15;
            randomButton.layer.masksToBounds=true;
            chooseBtnView.layer.cornerRadius = 15;
            chooseBtnView.layer.masksToBounds =true;
            randomBtnView.layer.cornerRadius = 15;
            randomBtnView.layer.masksToBounds =true;
            NSString *username = [defaults objectForKey:@"FirstName"];
            username = username.uppercaseString;
            NSLog(@"FirstName======>%@",username);
            NSLog(@"");
            
            NSString *welcomeUser = @"HI ";
            UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
            NSMutableAttributedString *attributedString1 =
            [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
                                                                                       NSFontAttributeName : welcomeUserFont}];
            
            UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
            NSMutableAttributedString *attributedString2 =
            [[NSMutableAttributedString alloc] initWithString:username attributes:@{
                                                                                    NSFontAttributeName : usernameFont}];
            //                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
            [attributedString1 appendAttributedString:attributedString2];
            NSLog(@"attributedString1======>%@",attributedString1);
            NSLog(@"");
            hiUserLabel.attributedText = attributedString1;
        }
        else if (![Utility isEmptyCheck:[defaults objectForKey:@"DailyPopUpInAchievements"]]){
            NSDate *lastShownDate=[defaults objectForKey:@"DailyPopUpInAchievements"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
            NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
            
            lastShownDate=[formatter dateFromString:lastShownDateString];
            NSDate *todayDate=[formatter dateFromString:todayDateStr];
        
            if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
                
                if (![Utility isEmptyCheck:[defaults objectForKey:@"DontShowDailyPopUpInAchievements"]]/*[defaults boolForKey:@"DontShowDailyPopUpInAchievements"]*/) {
                    [defaults setObject:[NSNumber numberWithBool:true] forKey:@"DontShowDailyPopUpInAchievements"];
                    [defaults setObject:[NSDate date] forKey:@"DailyPopUpInAchievements"];
                    dailyPopUpView.hidden = false;
                    dailyPopUpInnerView.layer.cornerRadius=15;
                    dailyPopUpInnerView.layer.masksToBounds=true;
                    chooseButton.layer.cornerRadius=15;
                    chooseButton.layer.masksToBounds=true;
                    randomButton.layer.cornerRadius=15;
                    randomButton.layer.masksToBounds=true;
                    chooseBtnView.layer.cornerRadius = 15;
                    chooseBtnView.layer.masksToBounds =true;
                    randomBtnView.layer.cornerRadius = 15;
                    randomBtnView.layer.masksToBounds =true;
                    NSString *username = [defaults objectForKey:@"FirstName"];
                    username = username.uppercaseString;
                    NSLog(@"FirstName======>%@",username);
                    NSLog(@"");
                    
                    NSString *welcomeUser = @"HI ";
                    UIFont *welcomeUserFont = [UIFont fontWithName:@"Raleway" size:18];
                    NSMutableAttributedString *attributedString1 =
                    [[NSMutableAttributedString alloc] initWithString:welcomeUser attributes:@{
                                                                                               NSFontAttributeName : welcomeUserFont}];
                    
                    UIFont *usernameFont = [UIFont fontWithName:@"Raleway-Bold" size:22];
                    NSMutableAttributedString *attributedString2 =
                    [[NSMutableAttributedString alloc] initWithString:username attributes:@{
                                                                                            NSFontAttributeName : usernameFont}];
                    //                                  NSString *welcomeUser = [@"" stringByAppendingFormat:@"HEY %@",attributedString1];
                    [attributedString1 appendAttributedString:attributedString2];
                    NSLog(@"attributedString1======>%@",attributedString1);
                    NSLog(@"");
                    hiUserLabel.attributedText = attributedString1;
                }else{
                }
            }else{
            }
        }
    }
    selectedTypeFilterArray = [NSMutableArray new];
    isAddPresssed = false;
    if (_isFromToday) {
        _isFromToday = false;
        isAddPresssed = true;
        [self addButtonPressed:0];
    }
    
    
    
    shouldSetupRem = true;
    tableView.rowHeight = UITableViewAutomaticDimension;
    for (int i=0; i<goalValueArray.count;i++ ) {
        NSDictionary *dict = [goalValueArray objectAtIndex:i];
        if (i == 0) {
            headerFirstLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }if (i == 1) {
            headerSecondLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }if (i == 2) {
            headerThirdLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }
    }
    noDataLabel.hidden = true;
    addButtonShowView.hidden = true;
    [achievementStackView removeArrangedSubview:videoView];
    [videoView removeFromSuperview];
    isExpand = false;
    
    
    tableView.estimatedRowHeight = 80;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    viewFilter.hidden = YES;
    selectDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    selectDateButton.clipsToBounds = YES;
    selectDateButton.layer.borderWidth = 1.2;
    selectDateButton.layer.cornerRadius = 10;
    
    showResultButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    showResultButton.clipsToBounds = YES;
    showResultButton.layer.borderWidth = 1.2;
    showResultButton.layer.cornerRadius = 10;
    
    clearAllButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    clearAllButton.clipsToBounds = YES;
    clearAllButton.layer.borderWidth = 1.2;
    clearAllButton.layer.cornerRadius = 15;
    
    printButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    printButton.clipsToBounds = YES;
    printButton.layer.borderWidth = 1.2;
    printButton.layer.cornerRadius = 10;
    
    editButton.layer.cornerRadius = 15;
    editButton.layer.masksToBounds = YES;
    delButton.layer.cornerRadius = 15;
    delButton.layer.masksToBounds = YES;
    editDelSubView.layer.cornerRadius = 15;
    editDelSubView.layer.masksToBounds = YES;
    
    searchTextField.text = @"";
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    searchTextField.inputAccessoryView = toolBar;
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = squadSubColor.CGColor;
    searchTextField.layer.cornerRadius = 10.0;
    searchTextField.layer.masksToBounds = YES;
    [searchTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    fromDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    fromDateButton.clipsToBounds = YES;
    fromDateButton.layer.borderWidth = 1.2;
    fromDateButton.layer.cornerRadius = 10;
    [fromDateButton setTitle:@"From Date" forState:UIControlStateNormal];
    
    toDateButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    toDateButton.clipsToBounds = YES;
    toDateButton.layer.borderWidth = 1.2;
    toDateButton.layer.cornerRadius = 10;
    [toDateButton setTitle:@"To Date" forState:UIControlStateNormal];
    
    dateRangeView.hidden=true;

    eqGotItButton.layer.cornerRadius = 15;
    eqGotItButton.layer.masksToBounds = YES;
    
    
#pragma mark - ShowAll on within Filter view
    
    for (UIButton *button in dateOutletCollection)
    {
        if(button.tag == 1){
            button.selected = true;
            SelectedFilterbtn = button;
        }else{
            button.selected = false;
        }
    }
    havePictureButton.selected=false;
    havePictureButtonIsSelected = false;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"AchivementDelete" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
                      [self webServicecallForGetReverseBucketListApiCall];
                 });
         }];
    
    [self webServicecallForGetReverseBucketListApiCall];
    
    expandButton.selected = true;
    for(UIView *view in viewOutletCollection){
        view.hidden = NO;
    }

//pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        tableView.refreshControl = refreshControl;
    } else {
        [tableView addSubview:refreshControl];
    }
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeGrowth"]] || ![defaults boolForKey:@"isFirstTimeGrowth"]) {
        walkThroughView.hidden=false;
    }else{
        walkThroughView.hidden=true;
    }
    walkThroughGotItButton.layer.cornerRadius=15;
    walkThroughGotItButton.layer.masksToBounds=true;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [passwordLockButton setSelected:[defaults boolForKey:@"isGrowthScreenLock"]];
    
    if(passwordLockButton.isSelected){
        if(![self canAuthenticateBioMetric] && ![self canAuthenticatePasscode]){
            
        }else{
            [self bioMetricAuthentication];
        }
    }
    [self webServicecallForGetJounalPromptofDay];
}
- (void)viewDidDisappear:(BOOL)animated{
//    [defaults removeObjectForKey:@"userPromptRandom"];
//    [self webServicecallForUpdateUserJounalPrompt];
}

#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    searchTextField.hidden=true;

        
        
        //i can try adding popup view here

    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsGrowthListShow" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
        self->isFromNotesFirstentry = true;
        [self webServicecallForGetReverseBucketListApiCall];
    }];
//    [self webServicecallForGetJounalPromptofDay];
    isDropdownShow=NO;
    
    
    
          NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
          [formatter setDateFormat:@"yyyy-MM-dd"];
             if (!_isFromGrowthList && !isAddPresssed) {
                 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                 [formatter setDateFormat:@"yyyy-MM-dd"];
                 NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
                 if([DBQuery isRowExist:@"todayGetGrowthDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]]){
                   DAOReader *dbObject = [DAOReader sharedInstance];
                   if([dbObject connectionStart]){
                       NSArray *todayHabitCoursearr = [dbObject selectBy:@"todayGetGrowthDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"AddedDate",@"TodayData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and AddedDate = '%@'",[NSNumber numberWithInt:[[defaults objectForKey:@"UserID"]intValue]],currentDateStr]];
                       NSString *str = todayHabitCoursearr[0][@"TodayData"];
                       NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                       NSDictionary *todayHabitCourseList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                           if(![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Gratitude"]] || ![Utility isEmptyCheck:[todayHabitCourseList objectForKey:@"Growth"]]){
//                      else{
                       
                           if (isFromNotesFirstentry) {
                               
//                             TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                               GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
//                             [self.navigationController pushViewController:controller animated:NO];
                           }
                       }
                   }
                    [dbObject connectionEnd];
                 }else{
                     
//                          TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                                                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
//                                                   [self.navigationController pushViewController:controller animated:NO];
//                      
                 }
                 
             }else{
                 _isFromGrowthList = false;
             }
    plusButton.hidden=false;
    
    //Gesture Recognizer
   UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
   longPress.minimumPressDuration = 1.0;
   [tableView addGestureRecognizer:longPress];
    
     [[NSNotificationCenter defaultCenter] addObserverForName:@"IsAchievementRealod" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
         [self webServicecallForGetReverseBucketListApiCall];
        }];
        [[NSNotificationCenter defaultCenter] addObserverForName:@"IsTodayGetGratitudeGrowthReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
            [self webServicecallForGetReverseBucketListApiCall];
       }];
}



#pragma mark- End

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table{
    return 1;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"achievementsListArray====> %@",achievementsListArray);
    NSLog(@"");
       return achievementsListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *CellIdentifier = @"AchievementsTableViewCell";
    AchievementsTableViewCell *cell;
    cell=[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AchievementsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [achievementsListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {

        NSString *detailString= @"";

        if (![Utility isEmptyCheck:[dict objectForKey:@"CreatedAtString"]]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'HH:mm:ss
            NSDate *date = [formatter dateFromString:[dict objectForKey:@"CreatedAtString"]];
            NSLog(@"%@",[dict objectForKey:@"CreatedAtString"]);
            if(date){
                if([date isToday]){
                    detailString = @"Today";
                }else if ([date isYesterday]){
                    detailString = @"Yesterday";
                }else{
                    [formatter setDateFormat:@"EEEE d MMMM"];
                    NSString *dateStr = [@"" stringByAppendingFormat:@"%@",[formatter stringFromDate:date]];

                    NSInteger currentDay = [date day];
                    NSString *daySuffix = [@"" stringByAppendingFormat:@"%ld%@",currentDay,[Utility daySuffixForDate:date]];

                    dateStr = [dateStr stringByReplacingOccurrencesOfString:[@"" stringByAppendingFormat:@"%ld",currentDay] withString:daySuffix options:NSCaseInsensitiveSearch range:[dateStr rangeOfString:[@"" stringByAppendingFormat:@"%ld",(long)currentDay]]];
                    detailString = dateStr;
                }
            }
        }
        cell.achievementListDayLabel.text = detailString;
        if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]){
            cell.achievementListDayLabel.textColor=[Utility colorWithHexString:mbhqBaseColor];
        }else{
            cell.achievementListDayLabel.textColor=[Utility colorWithHexString:@"474747"];
        }

        //---------------------------------
        if (havePictureButtonIsSelected) {
            cell.achievementListImage.layer.cornerRadius = 15;
            cell.achievementListImage.layer.masksToBounds = YES;
            //-----------------------------------------//
        if(![Utility isEmptyCheck:[dict objectForKey:@"PictureDevicePath"]]){
            cell.achievementListImageView.hidden = false;
                   localImageName = [dict objectForKey:@"PictureDevicePath"];
                   selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:localImageName];
                   if(selectedImage){
                      
                       cell.achievementListImage.image = selectedImage;
                     if([Utility isEmptyCheck:cell.achievementListImage.image]){
                                cell.achievementListImageView.hidden = true;
                           }else{
                                cell.achievementListImageView.hidden = false;
                           }
                   }
                   else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {
//                       cell.achievementListImageView.hidden = false;
                       NSString *imageUrlString =[dict objectForKey:@"Picture"];
                       [cell.achievementListImage sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                            [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                     placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                            options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                  if (image) {
//                                                       self->selectedImage = image;
//                                                      cell.achievementListImageView.hidden = false;
//                                                      cell.achievementListImage.image = image;
                       if([Utility isEmptyCheck:cell.achievementListImage.image]){
                           cell.achievementListImageView.hidden = true;
                        }else{
                        cell.achievementListImageView.hidden = false;
                     }
                  }
                else {
                                                       
                                                       self->selectedImage = nil;
                                                       cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];
                                                        NSString *uploadPictureImgFileName = [dict objectForKey:@"UploadPictureImgFileName"];
                                                      
                       if([uploadPictureImgFileName isEqual: [NSNull null]]){
                                                                cell.achievementListImageView.hidden = true;
                                                           }else{
                                                                cell.achievementListImageView.hidden = false;
                                                           }
                                                       }
                                                });
                                            }];
                   }else{
//                       cell.achievementListImageView.hidden = false;
                       cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];

                        NSString *uploadPictureImgFileName = [dict objectForKey:@"UploadPictureImgFileName"];

                       if([uploadPictureImgFileName isEqual: [NSNull null]]){
                                cell.achievementListImageView.hidden = true;
                           cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];
                           }else{
                                cell.achievementListImageView.hidden = false;
                               cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];
                           }
                   }
       }else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {

           cell.achievementListImageView.hidden = false;
           NSString *imageUrlString =[dict objectForKey:@"Picture"];
           [cell.achievementListImage sd_setImageWithURL:[NSURL URLWithString:[imageUrlString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                [NSCharacterSet URLQueryAllowedCharacterSet]]]
                         placeholderImage:[UIImage imageNamed:@"img_holder.png"]
                                options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      if (image) {
                                          
//                                           self->selectedImage = image;
//                                           cell.achievementListImage.image = image;
                                           NSString *Picture = [dict objectForKey:@"Picture"];
                       if([Utility isEmptyCheck:cell.achievementListImage.image]){
                                                   cell.achievementListImageView.hidden = true;
                                              }else{
                                                   cell.achievementListImageView.hidden = false;
                                              }
                                      
                                       }else{
                                           self->selectedImage = nil;
//                                           cell.achievementListImageView.hidden = false;
                                           cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];
                                        NSString *uploadPictureImgFileName = [dict objectForKey:@"UploadPictureImgFileName"];

                       if([uploadPictureImgFileName isEqual: [NSNull null]]){
                                                    cell.achievementListImageView.hidden = true;
                           cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];
                                               }else{
                                                    cell.achievementListImageView.hidden = false;
                                               }
                                            }
                                    });
                                }];
       }
       else{
           localImageName = [Utility createImageFileNameFromTimeStamp];
//           cell.achievementListImageView.hidden = false;
           cell.achievementListImage.image = [UIImage imageNamed:@"upload_image.png"];

            NSString *uploadPictureImgFileName = [dict objectForKey:@"UploadPictureImgFileName"];

           if([uploadPictureImgFileName  isEqual: [NSNull null]]){
                    cell.achievementListImageView.hidden = true;
               }else{
                    cell.achievementListImageView.hidden = false;
               }
            }
        }else{
            cell.achievementListImageView.hidden = true;
            }
        
    if ((![Utility isEmptyCheck:[dict objectForKey:@"PushNotification"]] && [[dict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[dict objectForKey:@"Email"]] && [[dict objectForKey:@"Email"] boolValue])) {
        cell.notificationButton.selected = true;
        cell.notificationButton.hidden = false;
    }else{
        cell.notificationButton.selected = false;
        cell.notificationButton.hidden = true;
    }
    if (![Utility isEmptyCheck:[dict objectForKey:@"Achievement"]]){
        
        if (indexPath.row%2 == 0) {
            NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[dict objectForKey:@"Achievement"]];
            NSArray *splitArr = [[dict objectForKey:@"Achievement"] componentsSeparatedByString:@":"];
            NSRange foundRange1 = [text1.mutableString rangeOfString:[splitArr objectAtIndex:0]];
            
            NSDictionary *attrDict1 = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0],
                                        NSForegroundColorAttributeName : [Utility colorWithHexString:@"41515C"]
                                        
                                        };
            [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
            [text1 addAttributes:@{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0]
                                   
                                   }
                           range:foundRange1];
            cell.achievementLabel.attributedText = text1;
        }else{
            NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[dict objectForKey:@"Achievement"]];
            NSArray *splitArr = [[dict objectForKey:@"Achievement"] componentsSeparatedByString:@":"];
            NSRange foundRange1 = [text1.mutableString rangeOfString:[splitArr objectAtIndex:0]];
            
            NSDictionary *attrDict1 = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0],
                                        NSForegroundColorAttributeName : [Utility colorWithHexString:@"41515C"]
                                        
                                        };//Raleway-Bold
            [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
            [text1 addAttributes:@{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0]
                                   
                                   }
                           range:foundRange1];
            cell.achievementLabel.attributedText = text1;
        }
       
    }else{
        cell.achievementLabel.text = @"";
    }
    cell.notificationButton.tag = indexPath.row;
  
}
return cell;
}
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [achievementsListArray objectAtIndex:indexPath.row];
   
//    AchievementsAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEdit"];
//    controller.dict = [dict mutableCopy];
//    controller.achievementDelegate = self;
//   [self.navigationController pushViewController:controller animated:YES];
        AchievementsAddEditNewViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AchievementsAddEditNew"];
        controller.achievementsData = [dict mutableCopy];
        controller.achievementDelegate = self;
       [self.navigationController pushViewController:controller animated:YES];
    

}

#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{

    NSLog(@"search for %@", textField.text);
    NSLog(@"");
    if(textField.text.length>0){
        achievementsListArray=[masterAchievementListArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Achievement CONTAINS[c] %@)", textField.text]];
    }else{
        achievementsListArray=masterAchievementListArr;
    }
//    if (![Utility isEmptyCheck:achievementsListArray]) {
//        addButtonShowView.hidden = true;
//    }else{
//        addButtonShowView.hidden = false;
//    }
    [tableView reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    viewFilter.hidden = true;
    if(textField.text.length>0){
        achievementsListArray=[masterAchievementListArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Achievement CONTAINS[c] %@)", textField.text]];
    }else{
        achievementsListArray=masterAchievementListArr;
    }
    if (![Utility isEmptyCheck:achievementsListArray]) {
        addButtonShowView.hidden = true;
    }else{
        addButtonShowView.hidden = false;
    }
    [tableView reloadData];
    [textField resignFirstResponder];
}
#pragma mark - End



#pragma mark - GratitudeAddEditDelegate
- (void)didAchievementsBackAction:(BOOL)ischanged{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    self->shouldSetupRem = true;
    [self webServicecallForGetReverseBucketListApiCall];
}
#pragma mark - End

#pragma mark - Notes Delegate
-(void)reloadData:(BOOL)isreload{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IsTodaypageReload" object:self userInfo:nil];
    [self webServicecallForGetReverseBucketListApiCall];
}

#pragma mark - DropDown Delegate

-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type caseInsensitiveCompare:@"Growth"] == NSOrderedSame) {
        selectedState = selectedValue;
        NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
        if([selectedState isEqual:@"Prompt of the Day"]){
            controller.selectGrowth = userPromptRandom;
            controller.currentDate = _todaySelectDate;
            controller.notesDelegate = self;
            controller.fromStr = @"Growth";
            controller.growthStr = userPromptRandom;
        }else{
            controller.selectGrowth = selectedState;
            controller.currentDate = _todaySelectDate;
            controller.notesDelegate = self;
            controller.fromStr = @"Growth";
            controller.growthStr = selectedState;
        }
        
        controller.notesDelegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark - End


#pragma mark - LongPressGestureRecognizer Delegate

-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
   }
  else if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan");
            editDelView.hidden = false;
            CGPoint location = [sender locationInView:tableView];
            NSIndexPath *indexpath= [tableView indexPathForRowAtPoint:location];
            editButton.tag = indexpath.row;
            delButton.tag = indexpath.row;

   }
}
#pragma mark - End

//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    CGPoint p = [gestureRecognizer locationInView:tableView];
//    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
//    if (indexPath != nil) {
//        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
//            NSDictionary *dict = [achievementsListArray objectAtIndex:indexPath.row];
//            [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[dict objectForKey:@"Achievement"]]? [dict objectForKey:@"Achievement"] : @"";
//            [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
//        }
//    }
//}

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
          self->shouldSetupRem = YES;
          [self webServicecallForGetReverseBucketListApiCall];
        }
    });
}

#pragma mark - Added For Screen Lock
-(LAContext *)contextSharedInstance
{
    static dispatch_once_t onceToken;
    static LAContext * context;
    
    dispatch_once(&onceToken, ^{
        context = [LAContext new];;
    });
    return context;
}
-(void)bioMetricAuthentication{
    
    if([self canAuthenticateBioMetric]){
        [self authenticateWithBioMetrics];
    }else if ([self canAuthenticatePasscode]){
        [self authenticateWithPasscode];
    }
    
}
-(BOOL)canAuthenticateBioMetric{
    
    NSError *error;
    return [[self contextSharedInstance] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
}

-(BOOL)canAuthenticatePasscode{
    
    NSError *error;
    return [[self contextSharedInstance] canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
}


-(void)authenticateWithBioMetrics{
    
    [[self contextSharedInstance] evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Authenticate Touch Id/Face Id to gain access." reply:^(BOOL success, NSError * _Nullable error) {
        
            dispatch_async(dispatch_get_main_queue(),^ {
                
                if(success){
                    
                }else{
                    NSInteger code = (LAError)error.code;
                    
                    
                    if(code == LAErrorBiometryLockout || code == LAErrorUserFallback){
                        [self authenticateWithPasscode];
                    }else{
                        [Utility msg:error.localizedDescription title:@"Alert" controller:self haveToPop:YES];
                        
                    }
                    
//                    if(code == LAErrorUserCancel || code == LAErrorSystemCancel){
//
//                    }
                    
                    
                }
            });
        
        
    }];
}

-(void)authenticateWithPasscode{
    
    [[self contextSharedInstance] evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"Enter passcode to gain access" reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            
            NSInteger code = (LAError)error.code;
            
            if(success){
                
            }else{
                [Utility msg:error.localizedDescription title:@"Alert" controller:self haveToPop:YES];
//                if(code == LAErrorUserCancel || code == LAErrorSystemCancel){
//
//                }
            }
        });
    }];
}



#pragma mark - End
@end
