//
//  AccountabilityGoalActionViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 31/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "AccountabilityGoalActionViewController.h"
#import "VisionGoalActionHeaderView.h"
#import "VisionGoalActionTableViewCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AddGoalsViewController.h"
#import "AddActionViewController.h"
#import "YLProgressBar.h"

@interface AccountabilityGoalActionViewController (){      //ah ac     //ah ac2
    
    IBOutlet UIButton *headerCalenderButton;
    IBOutlet UIButton *headerHelpButton;
    IBOutlet UILabel *headerFirstLabel;
    IBOutlet UILabel *headerSecondLabel;
    IBOutlet UILabel *headerThirdLabel;
    
    IBOutlet UIStackView *visionStackView;
    IBOutlet UIStackView *goalStackView;
    IBOutlet UIStackView *myActionsStackView;
    IBOutlet UIStackView *myValuesStackView;
    IBOutlet UIView *visionVideoView;
    IBOutlet UIView *myGoalVideoView;
    IBOutlet UIView *myActionsVideoView;
    IBOutlet UITableView *myGoalTableView;
    IBOutlet NSLayoutConstraint *myGoalTableHeightConstraint;
    IBOutlet UITableView *myActionsTableView;
    IBOutlet NSLayoutConstraint *myActionsTableHeightConstraint;
    IBOutlet UITableView *myValuesTableView;
    IBOutlet NSLayoutConstraint *myValuesTableHeightConstraint;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIImageView *visionImageView;
    IBOutlet UIView *visionLabelView;
    IBOutlet UILabel *visionLabel;
    IBOutlet UITextField *myValuesTextField;
    IBOutlet UIView *myGoalAddNew;
    IBOutlet UIView *myActionsAddNew;
    IBOutlet UIView *myValuesAddNew;
    IBOutlet UIView *visionAddNew;
    IBOutlet UIButton *visionEditButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    
    IBOutlet UIButton *myGoalButton;
    IBOutlet UIButton *myActionsButton;
    IBOutlet UIButton *myValuesButton;
    IBOutlet UIButton *myVisionBoardButton;
    IBOutlet NSLayoutConstraint *visionImageViewHeightConstraint;
    __weak IBOutlet UIButton *saveButton;
    
    UIView *contentView;
    NSMutableArray *goalListArray;
    NSArray *actionArray;
    NSArray *valuesArray;
    UITextField *activeTextField;
    AVPlayer *videoPlayer;
    AVPlayerViewController *playerController;
    NSMutableDictionary *totalVisionDict;
    NSArray *helpVideos;
    int helpVideoCount;
    
    BOOL shouldSetupRem;    //ah ln
    
    NSMutableDictionary *visionMutableDict; //ah ln1
    
    UIColor *selectedColor;
    UIColor *grayColor;
    __weak IBOutlet UIButton *creatGoalButton;
    __weak IBOutlet UIButton *reArrangeButton;
    NSMutableArray *selectedHeader;
    NSMutableArray *selectedRow;
    int activeDayIndex;
    NSMutableArray *toggleArray;
    
    __weak IBOutlet UIView *customAddView;
    __weak IBOutlet UITextField *goalNameTextField;
    IBOutlet UIButton *headerButton;
    IBOutlet UIImageView *buddiesImg;
    IBOutlet UILabel *buddiesLabel;
    BOOL isShowExpGoal;
    BOOL isArranging;
    int moveFrom;
    int moveTo;
    NSMutableArray *goalTempOrder;
    NSInteger expRowNumber;
    NSMutableArray *activeGoalArray;
    NSMutableArray* week;
    BOOL isUserFound;
    NSArray *days;
    NSArray* months;
}

@end

@implementation AccountabilityGoalActionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    days = [NSArray arrayWithObjects:@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday",@"Sunday", nil];
    months = [NSArray arrayWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
    toggleArray = [NSMutableArray new];
    goalListArray = [NSMutableArray new];
    goalTempOrder = [NSMutableArray new];
    activeGoalArray = [NSMutableArray new];
    expRowNumber = -1;
    isShowExpGoal = false;
    isArranging = false;
    saveButton.hidden = true;
    
    customAddView.hidden = true;
    activeDayIndex = 0;
    selectedColor = [UIColor colorWithRed:(50/255.0f) green:(205/255.0f) blue:(184/255.0f) alpha:1.0f];
    grayColor = [UIColor colorWithRed:(88/255.0f) green:(88/255.0f) blue:(88/255.0f) alpha:1.0f];
    
    [defaults setBool:YES forKey:@"isGoalExpanded"];
    [defaults setBool:YES forKey:@"isActionExpanded"];//31 aug feedback
    [self registerForKeyboardNotifications];
    
    helpVideoCount = 0;
    helpVideos = [[NSArray alloc]initWithObjects:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8",@"https://player.vimeo.com/external/125750377.m3u8?s=2bce1b1ce005b50c1098506cc28934b892d87145", nil];
    
    visionVideoView.hidden = true;
    myGoalVideoView.hidden = true;
    myActionsVideoView.hidden = true;
    actionArray = [[NSArray alloc]init];
    valuesArray = [[NSArray alloc]init];
    totalVisionDict = [[NSMutableDictionary alloc] init];
    visionMutableDict = [[NSMutableDictionary alloc] init]; //ah ln1
    
    shouldSetupRem = YES;    //ah ln
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"VisionGoalActionHeaderView" bundle:nil];
    [myGoalTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"VisionGoalActionHeaderView"];
    myGoalTableView.estimatedRowHeight = 50;
    myGoalTableView.rowHeight = 50;//UITableViewAutomaticDimension;
    
    myGoalTableView.estimatedSectionHeaderHeight = 50;
    myGoalTableView.sectionHeaderHeight = 50;//UITableViewAutomaticDimension;
    
    visionLabelView.hidden = true;
    
    //    myGoalTableView.hidden = true;
    //    myActionsTableView.hidden = true;
    //    myValuesTableView.hidden = true;
    myGoalAddNew.hidden = YES;
    myActionsAddNew.hidden = YES;
    //    myValuesAddNew.hidden = YES;
    [myGoalButton setSelected:YES];
    [myActionsButton setSelected:YES];
    //    [myValuesButton setSelected:YES];
    visionImageView.hidden = YES;
    visionEditButton.hidden = true;
    [myVisionBoardButton setSelected:YES];
    [reArrangeButton setTitleColor:selectedColor forState:UIControlStateNormal];
    reArrangeButton.layer.borderColor = selectedColor.CGColor;
    reArrangeButton.layer.borderWidth = 1;
    selectedHeader = [NSMutableArray new];
    selectedRow = [NSMutableArray new];
    [self calcDateIndex];
    [self setUpHeader];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    goalNameTextField.text = @"";
//    [myGoalTableView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"OtherSelectedGoalHeader"]]) {
        selectedHeader = [[defaults objectForKey:@"OtherSelectedGoalHeader"]mutableCopy];
    }else{
        selectedHeader = [NSMutableArray new];
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"OtherSelectedActionRow"]]) {
        selectedRow = [[defaults objectForKey:@"OtherSelectedActionRow"]mutableCopy];
    }else{
        selectedRow = [NSMutableArray new];
    }
   
    NSLog(@"before change: \n%@\n%@",selectedHeader,selectedRow);
    
    self->customAddView.hidden = true;
    [self->goalTempOrder removeAllObjects];
    self->isArranging = false;
    self->moveFrom = -1;
    self->moveTo = -1;
    self->saveButton.hidden = true;
    [self->reArrangeButton setTitle:@"RE-ARRANGE GOALS" forState:UIControlStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [myGoalTableView removeObserver:self forKeyPath:@"contentSize"];
    [defaults setObject:selectedHeader forKey:@"OtherSelectedGoalHeader"];
    [defaults setObject:selectedRow forKey:@"OtherSelectedActionRow"];
    //    [defaults removeObjectForKey:@"selectedGoalHeader"];
    //    [defaults removeObjectForKey:@"selectedActionRow"];
    NSLog(@"after change: \n%@\n%@",selectedHeader,selectedRow);
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //    goalListArray = [NSArray new];
    //    actionArray = [NSArray new];
    //    valuesArray = [NSArray new];
    
    //    [self getDataWithApi:@"GetVisionBoardAPI"];
    [self getDataWithApi:@"GetGoalListAPI"];
    
    if ([defaults boolForKey:@"isGoalExpanded"]) {
        [myGoalButton setSelected:NO];
        myGoalAddNew.hidden = NO;
    } else {
        [myGoalButton setSelected:YES];
        myGoalAddNew.hidden = YES;
    }
    
    if ([defaults boolForKey:@"isActionExpanded"]) {
        [myActionsButton setSelected:NO];
        myActionsAddNew.hidden = NO;
    } else {
        [myActionsButton setSelected:YES];
        myActionsAddNew.hidden = YES;
    }
}

-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    myActionsTableHeightConstraint.constant = myActionsTableView.contentSize.height;
    myValuesTableHeightConstraint.constant = myValuesTableView.contentSize.height;
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if (object == myGoalTableView) {
//        myGoalTableHeightConstraint.constant = myGoalTableView.contentSize.height;
//    }
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
- (IBAction)calenderTapped:(id)sender {
}
- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)headerHelpTapped:(id)sender {
}
- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)expandCollapseButtonTapped:(UIButton*)sender {
    switch ([sender tag]) {
        case 101:
            //            if (visionImageView.isHidden && visionLabelView.isHidden) {
            if ( totalVisionDict.count>0) {
                if (myVisionBoardButton.isSelected) {
                    visionImageView.hidden = NO;
                    visionEditButton.hidden = NO;
                    visionVideoView.hidden = YES;
                    visionAddNew.hidden = true;
                    [myVisionBoardButton setSelected:NO];
                } else {
                    visionImageView.hidden = YES;
                    visionEditButton.hidden = YES;
                    visionVideoView.hidden = YES;
                    visionAddNew.hidden = true;
                    [myVisionBoardButton setSelected:YES];
                }
            } else {
                if (myVisionBoardButton.isSelected) {
                    visionImageView.hidden = YES;
                    visionEditButton.hidden = YES;
                    visionVideoView.hidden = YES;
                    visionAddNew.hidden = false;
                    [myVisionBoardButton setSelected:NO];
                } else {
                    visionImageView.hidden = YES;
                    visionEditButton.hidden = YES;
                    visionVideoView.hidden = YES;
                    visionAddNew.hidden = true;
                    [myVisionBoardButton setSelected:YES];
                }
            }
            //            if (visionImageView.isHidden) {
            //                if (totalVisionDict.count>0) {
            //                    visionAddNew.hidden = true;
            //                    visionImageView.hidden = NO;
            //                    visionEditButton.hidden = NO;
            //                } else {
            //                    visionAddNew.hidden = false;
            //                    visionImageView.hidden = YES;
            //                    visionEditButton.hidden = YES;
            //                }
            ////                visionLabelView.hidden = NO;
            ////                [sender setSelected:NO];
            //                [myVisionBoardButton setSelected:NO];
            //            } else {
            //                visionImageView.hidden = YES;
            ////                visionLabelView.hidden = YES;
            //                visionVideoView.hidden = YES;
            ////                [sender setSelected:YES];
            //                [myVisionBoardButton setSelected:YES];
            //            }
            break;
            
        case 102:
            if (myGoalTableView.isHidden || myGoalButton.isSelected) {
                myGoalTableView.hidden = NO;
                myGoalAddNew.hidden = NO;
                //                [sender setSelected:NO];
                [myGoalButton setSelected:NO];
                [defaults setBool:YES forKey:@"isGoalExpanded"];
                if ([myGoalTableView numberOfSections] > 1) {
                    //do nothing
                } else {
                    [myGoalTableView reloadData];
                }
            } else {
                myGoalTableView.hidden = YES;
                myGoalAddNew.hidden = YES;
                myGoalVideoView.hidden = YES;
                //                [sender setSelected:YES];
                [myGoalButton setSelected:YES];
                [defaults setBool:NO forKey:@"isGoalExpanded"];
            }
            break;
            
        case 103:
            if (myActionsTableView.isHidden || myActionsButton.isSelected) {
                myActionsTableView.hidden = NO;
                myActionsAddNew.hidden = NO;
                //                [sender setSelected:NO];
                [myActionsButton setSelected:NO];
                [defaults setBool:YES forKey:@"isActionExpanded"];
                if ([myActionsTableView numberOfRowsInSection:0] > 1) {
                    //do nothing
                } else {
                    [myActionsTableView reloadData];
                }
            } else {
                myActionsTableView.hidden = YES;
                myActionsAddNew.hidden = YES;
                myActionsVideoView.hidden = YES;
                //                [sender setSelected:YES];
                [myActionsButton setSelected:YES];
                [defaults setBool:NO forKey:@"isActionExpanded"];
            }
            break;
            
        case 104:
            if (myValuesTableView.isHidden) {
                myValuesTableView.hidden = NO;
                myValuesAddNew.hidden = NO;
                //                [sender setSelected:NO];
                [myValuesButton setSelected:NO];
                //                [mainScroll scrollRectToVisible:myValuesTableView.frame animated:YES];
                //                if ([myValuesTableView numberOfRowsInSection:1] > 1) {
                //                    //do nothing
                //                } else {
                //                    [myValuesTableView reloadData];
                //                }
            } else {
                myValuesTableView.hidden = YES;
                myValuesAddNew.hidden = YES;
                //                [sender setSelected:YES];
                [myValuesButton setSelected:YES];
            }
            break;
            
        default:
            break;
    }
}
- (IBAction)helpButtonTapped:(UIButton*)sender {
    switch ([sender tag]) {
        case 1:
            if (visionVideoView.isHidden) {
                visionVideoView.hidden = false;
                [self playVideoWithUrlStr:[helpVideos objectAtIndex:helpVideoCount] InsideView:visionVideoView];
                //                [self playVideoWithUrlStr:@"https://player.vimeo.com/external/125750379.m3u8?s=c85a3928071e47c744698cf66662e8543adcf3f8" InsideView:visionVideoView];   //ahv
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:[videoPlayer currentItem]];
                
            } else {
                [videoPlayer pause];
                visionVideoView.hidden = true;
            }
            break;
            
        case 2:
            if (myGoalVideoView.isHidden) {
                myGoalVideoView.hidden = false;
                [self playVideoWithUrlStr:@"https://player.vimeo.com/video/76979871" InsideView:myGoalVideoView];
            } else {
                [videoPlayer pause];
                myGoalVideoView.hidden = true;
            }
            break;
            
        case 3:
            if (myActionsVideoView.isHidden) {
                myActionsVideoView.hidden = false;
                [self playVideoWithUrlStr:@"https://player.vimeo.com/video/76979871" InsideView:myActionsVideoView];
            } else {
                [videoPlayer pause];
                myActionsVideoView.hidden = true;
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)addButtonTapped:(UIButton*)sender {
    [self.view endEditing:YES];
    NSLog(@"t %ld",(long)[sender tag]);
    switch ([sender tag]) {//999 for view
        case 999:
        {
            customAddView.hidden = !customAddView.isHidden;
            break;
        }
        case 1001:
        {
            //goal
            if (goalNameTextField.text.length == 0) {
                break;
            }
            AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
            controller.valuesArray = valuesArray;
            controller.setNewGoal = true; //gami_badge_popup
            controller.goalName = goalNameTextField.text;
            
            [self.navigationController pushViewController:controller animated:YES];
            //        [self presentViewController:controller animated:YES completion:nil];
            break;
        }
            
        case 1002:
        {
            //actions
            AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
            controller.goalListArray = [goalListArray mutableCopy];//id
            controller.selectedGoal = [goalListArray objectAtIndex:[[sender accessibilityHint]intValue]];
            controller.isNewAction =true; //gami_badge_popup
            [self.navigationController pushViewController:controller animated:YES];
            //        [self presentViewController:controller animated:YES completion:nil];
            break;
        }
            
        case 1003:
        {
            //vision board
//            AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionBoard"];
//            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
            
        default:
            break;
    }
}
- (IBAction)myValuesAddButtonTapped:(id)sender {
    if (myValuesTextField.text.length > 0) {
        [activeTextField resignFirstResponder];
        [self saveNewValueApi:myValuesTextField.text];
    } else {
        [Utility msg:@"Value is Required!" title:@"Error!" controller:self haveToPop:NO];
    }
}
- (IBAction)upArrowTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self upDownArrowApiForId:[btn.accessibilityHint intValue] Value:2];
}
- (IBAction)downArrowTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self upDownArrowApiForId:[btn.accessibilityHint intValue] Value:1];
}
-(IBAction)valuesDeleteButtonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [self deleteGoalValueFromId:[btn.accessibilityHint intValue]];
}
-(IBAction)visionEditButtonTapped:(id)sender {  //ah ac1
//    AddVisionBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddVisionBoard"];
//    controller.visionBoardDict = totalVisionDict;
//    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)sectionTapped:(UIButton*)sender {
    AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
    controller.valuesArray = valuesArray;
    controller.selectedGoalDict = [goalListArray objectAtIndex:[sender tag]];
    controller.buddyDict = _buddiesDict;
    [self.navigationController pushViewController:controller animated:YES];
    //        [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)editGoalPressed:(UIButton *)sender{
    AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
    controller.valuesArray = valuesArray;
    controller.selectedGoalDict = [goalListArray objectAtIndex:[sender tag]];
    controller.editMode = true;
    [self.navigationController pushViewController:controller animated:YES];
    //        [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)expandCollapseHeader:(UIButton *)sender{
    if ([selectedHeader containsObject:[NSNumber numberWithInteger:sender.tag]]) {
        [selectedHeader removeObject:[NSNumber numberWithInteger:sender.tag]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self beginswith[c] %@",[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        NSArray *filteredArray = [selectedRow filteredArrayUsingPredicate:predicate];
        if (![Utility isEmptyCheck:filteredArray]) {
            [selectedRow removeObjectsInArray:filteredArray];
        }
    }else{
        [selectedHeader addObject:[NSNumber numberWithInteger:sender.tag]];
    }
    
    [myGoalTableView reloadData];
}
-(IBAction)expandCollapseRow:(UIButton *)sender{
    NSString *modRow = [NSString stringWithFormat:@"%@-%ld",sender.accessibilityHint,(long)sender.tag];
    if ([selectedRow containsObject:modRow]) {
        [selectedRow removeObject:modRow];
    }else{
        [selectedRow addObject:modRow];
    }
    [myGoalTableView reloadData];
}
-(IBAction)toggleAction:(UIButton *)sender{
    return;
//    if ((int)sender.tag != activeDayIndex) {
//        return;
//    }
//    sender.selected = !sender.isSelected;
//    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:[sender.accessibilityHint intValue]],@"ReminderID", nil];
//    if([toggleArray containsObject:dict]){
//        [toggleArray removeObject:dict];
//    }else{
//        [toggleArray addObject:dict];
//    }
//    if (toggleArray.count>0) {
//        saveButton.hidden = false;
//    }else{
//        saveButton.hidden = true;
//    }
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    if (isArranging) {
        NSMutableArray *tempArray = [NSMutableArray new];
        for (int i = 0; i<activeGoalArray.count; i++) {
            NSMutableDictionary *temp = [NSMutableDictionary new];
            [temp setObject:[[activeGoalArray objectAtIndex:i] objectForKey:@"id"] forKey:@"GoalId"];
            [temp setObject:[NSNumber numberWithInt:i] forKey:@"GoalOrder"];
            [tempArray addObject:temp];
        }
        [self setGoalsOrderAPI:tempArray];
        return;
    }
    if (![Utility isEmptyCheck:toggleArray]) {
        [self changeActionReminder:@"ChangeActionReminderStatusListAPI"];
    }
}
- (IBAction)reArrangeGoalPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([Utility isEmptyCheck:goalListArray] || [Utility isEmptyCheck:activeGoalArray]) {
        return;
    }
    if (goalListArray.count < 2) {
        return;
    }
    if (activeGoalArray.count < 2) {
        return;
    }
    customAddView.hidden = true;
    isArranging = !isArranging;
    moveFrom = -1;
    moveTo = -1;
    if (isArranging) {
        isShowExpGoal = false;
        [goalTempOrder removeAllObjects];
        [reArrangeButton setTitle:@"CANCEL SWAP" forState:UIControlStateNormal];
        [myGoalTableView reloadData];
    }else{
        if (![Utility isEmptyCheck:goalTempOrder]) {
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Save Changes"
                                                  message:@"Your changes will be lost if you don’t save them."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           self->isArranging = true;
                                           [self saveButtonPressed:nil];
                                       }];
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Don't Save"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               self->isArranging = false;
                                               [self->goalTempOrder removeAllObjects];
                                               [self->reArrangeButton setTitle:@"RE-ARRANGE GOALS" forState:UIControlStateNormal];
                                               self->saveButton.hidden = true;
                                               [self->myGoalTableView reloadData];
                                           }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [reArrangeButton setTitle:@"RE-ARRANGE GOALS" forState:UIControlStateNormal];
            saveButton.hidden = true;
            [myGoalTableView reloadData];
        }
    }
    
}
- (IBAction)alarmButtonPressed:(UIButton *)sender {
    NSArray *goalDetailsArr = [[goalListArray objectAtIndex:[sender.accessibilityHint intValue]] objectForKey:@"GoalActionDetails"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %@)", [[goalDetailsArr objectAtIndex:sender.tag] objectForKey:@"Id"]];
    NSMutableDictionary *resultDict = [NSMutableDictionary new];
    NSArray *filteredSessionCategoryArray = [actionArray filteredArrayUsingPredicate:predicate];
    if (![Utility isEmptyCheck:filteredSessionCategoryArray]) {
        resultDict = [[filteredSessionCategoryArray objectAtIndex:0]mutableCopy];//GoalId
        [resultDict setObject:[[goalListArray objectAtIndex:[sender.accessibilityHint intValue]] objectForKey:@"id"] forKey:@"GoalId"];
        NSLog(@"%@", resultDict);
    }
    if (!sender.isSelected) {
        SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
        if ([resultDict objectForKey:@"FrequencyId"] != nil){
            [resultDict setObject:[NSNumber numberWithBool:true] forKey:@"PushNotification"];
            controller.defaultSettingsDict = resultDict;
        }
        controller.reminderDelegate = self;
        //gami_badge_popup
        //        if (isFirstTimeReminderSet) {
        //            controller.isFirstTime = isFirstTimeReminderSet;
        //            isFirstTimeReminderSet = false;
        //        }//gami_badge_popup
        
        controller.view.backgroundColor = [UIColor clearColor];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        //        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
        //        [resultDict setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:nil
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Edit Reminder"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       SetReminderViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SetReminder"];
                                       if ([resultDict objectForKey:@"FrequencyId"] != nil)
                                           controller.defaultSettingsDict = resultDict;
                                       controller.reminderDelegate = self;
                                       controller.view.backgroundColor = [UIColor clearColor];
                                       controller.modalPresentationStyle = UIModalPresentationCustom;
                                       [self presentViewController:controller animated:YES completion:nil];
                                   }];
        UIAlertAction *turnOff = [UIAlertAction
                                  actionWithTitle:@"Turn Off Reminder"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      
                                      [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
                                      [resultDict removeObjectForKey:@"FrequencyId"];
                                      [self updateActionReminder:resultDict];
                                      //                                      [self prepareReminderView];
                                  }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:turnOff];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
}
- (IBAction)viewHistoryPressed:(UIButton *)sender {
    [self tableView:myGoalTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:[sender.accessibilityHint intValue]]];
}
-(IBAction)expGoalPressed:(UIButton *)sender{
    isShowExpGoal = !isShowExpGoal;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->myGoalTableView reloadData];
    });
}
-(IBAction)moveFromPressed:(UIButton *)sender{
    moveFrom = (int)sender.tag;
    moveTo = -1;
    [myGoalTableView reloadData];
}
-(IBAction)moveToPressed:(UIButton *)sender{
    if (moveFrom == (int)sender.tag) {
        return;
    }
    moveTo = (int)sender.tag;
    if (![goalTempOrder containsObject:[NSNumber numberWithInt:moveFrom]]) {
        [goalTempOrder addObject:[NSNumber numberWithInt:moveFrom]];
    }
    if (![goalTempOrder containsObject:[NSNumber numberWithInt:moveTo]]) {
        [goalTempOrder addObject:[NSNumber numberWithInt:moveTo]];
    }
    
    saveButton.hidden = false;
    [goalListArray exchangeObjectAtIndex:moveFrom withObjectAtIndex:moveTo];
    [activeGoalArray exchangeObjectAtIndex:moveFrom withObjectAtIndex:moveTo];
    moveFrom = -1;
    moveTo = -1;
    [myGoalTableView reloadData];
}
//-(IBAction)messageButtonPressed:(id)sender{
//        if(![Utility isUserLoggedInToChatSdk]){
//            [Utility msg:@"Authentication error while creating chat thread." title:@"" controller:self haveToPop:NO];
//            return;
//        }
//        
//        if(![Utility isEmptyCheck:_buddiesDict] && ![Utility isEmptyCheck:_buddiesDict[@"Email"]]){
//            
//            NSString *email = _buddiesDict[@"Email"];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (self->contentView) {
//                    [self->contentView removeFromSuperview];
//                }
//                
//                self->contentView = [Utility activityIndicatorView:self];
//                
//            });
//            
//            isUserFound = false;
//            
//            [NM.search usersForIndexes:@[bUserEmailKey] withValue:email limit: 1 userAdded: ^(id<PUser> user) {
//                
//                // Make sure we run this on the main thread
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    if (user != Nil && user != NM.currentUser) {
//                        // Only display a user if they have a name set
//                        self->isUserFound = true;
//                        [NM.core createThreadWithUsers:@[user] threadCreated:^(NSError * error, id<PThread> thread) {
//                            
//                            dispatch_async(dispatch_get_main_queue(),^ {
//                                
//                                if (self->contentView) {
//                                    [self->contentView removeFromSuperview];
//                                }
//                            });
//                            
//                            if(!error){
//                                
//                                UIViewController * chatViewController = [[BInterfaceManager sharedManager].a chatViewControllerWithThread:thread];
//                                [self.navigationController pushViewController:chatViewController animated:YES];
//                            }else{
//                                [Utility msg:@"Unable to create chat thread.Try Again.." title:@"" controller:self haveToPop:NO];
//                            }
//                            
//                            
//                        }];
//                    }else{
//                        
//                        dispatch_async(dispatch_get_main_queue(),^ {
//                            
//                            if (self->contentView) {
//                                [self->contentView removeFromSuperview];
//                            }
//                            if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                        });
//                    }
//                    
//                    
//                });
//                
//            }].thenOnMain(^id(id success) {
//                
//                dispatch_async(dispatch_get_main_queue(),^ {
//                    
//                    if (self->contentView) {
//                        [self->contentView removeFromSuperview];
//                    }
//                    if(!self->isUserFound) [Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                });
//                
//                return Nil;
//            }, ^id(NSError * error) {
//                
//                dispatch_async(dispatch_get_main_queue(),^ {
//                    
//                    if (self->contentView) {
//                        [self->contentView removeFromSuperview];
//                    }
//                    if(!self->isUserFound)[Utility msg:ChatCreationError title:@"" controller:self haveToPop:NO];
//                });
//                
//                return error;
//            });
//            
//        }
//}
#pragma mark -APICall
-(void)getDataWithApi:(NSString *)apiName {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->customAddView.hidden = true;
            if (!self->contentView || ![self->contentView isDescendantOfView:self.view]) {
                //                [contentView removeFromSuperview];
                self->contentView = [Utility activityIndicatorView:self];
            }
            //            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[_buddiesDict objectForKey:@"FriendUserId"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   //                                                                 if (contentView) {
                                                                   //                                                                     [contentView removeFromSuperview];
                                                                   //                                                                 }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       
                                                                       if ([apiName caseInsensitiveCompare:@"GetVisionBoardAPI"] == NSOrderedSame) {
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                               NSDictionary *visionDict = [responseDictionary objectForKey:@"Details"];
                                                                               self->visionMutableDict = [visionDict mutableCopy];  //ah ln1
                                                                               [self setUpVisionBoardFromDict:visionDict];
                                                                               
                                                                               if (self->shouldSetupRem) {
                                                                                   [self setUpReminderFor:@"Vision"];    //ah ln1
                                                                               }
                                                                           } else {
                                                                               [self setUpVisionBoardFromDict:nil];
                                                                           }
                                                                           [self getDataWithApi:@"GetGoalListAPI"];
                                                                       }else if ([apiName caseInsensitiveCompare:@"GetGoalListAPI"] == NSOrderedSame) {
                                                                           if (self->contentView) {
                                                                               [self->contentView removeFromSuperview];
                                                                           }
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                               //                                                                             NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
                                                                               self->goalListArray = [[responseDictionary objectForKey:@"Details"]mutableCopy];
                                                                               if (![Utility isEmptyCheck:self->goalListArray]) {
                                                                                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Buddy_Privacy == %@ or Buddy_Privacy == %@)",[NSNull null],[NSNumber numberWithBool:false]];
                                                                                   self->goalListArray = [[self->goalListArray filteredArrayUsingPredicate:predicate]mutableCopy];
                                                                               }
                                                                               if (![Utility isEmptyCheck:self->goalListArray]) {
                                                                                   self->goalListArray = [[self->goalListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"GoalOrder" ascending:YES]]]mutableCopy];
                                                                                   self->activeGoalArray = [self->goalListArray mutableCopy];
                                                                                   NSArray *expFilteredArray = [self->goalListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"IsExpired == 1"]];
                                                                                   if (![Utility isEmptyCheck:expFilteredArray]) {
                                                                                       [self->goalListArray removeObjectsInArray:expFilteredArray];
                                                                                       self->activeGoalArray = [self->goalListArray mutableCopy];
                                                                                       
                                                                                       self->expRowNumber = self->activeGoalArray.count;
                                                                                       [self->goalListArray addObjectsFromArray:expFilteredArray];
                                                                                   } else {
                                                                                       self->expRowNumber = -1;
                                                                                   }
                                                                                   if (![Utility isEmptyCheck:self->activeGoalArray]) {
                                                                                       NSMutableArray *tempAction = [NSMutableArray new];
                                                                                       for (NSDictionary *temp in self->activeGoalArray) {
                                                                                           //GoalActionDetails
                                                                                           NSArray *action = [temp objectForKey:@"GoalActionDetails"];
                                                                                           if (![Utility isEmptyCheck:action]) {
                                                                                               [tempAction addObjectsFromArray:action];
                                                                                           }
                                                                                       }
                                                                                       self->actionArray = [[NSArray alloc]initWithArray:tempAction];
                                                                                   }
//                                                                                   [self setUpReminderFor:@"Action"];
                                                                                   if (![Utility isEmptyCheck:self->goalListArray]) {
                                                                                       NSMutableArray *tempAction = [NSMutableArray new];
                                                                                       for (NSDictionary *temp in self->goalListArray) {
                                                                                           //GoalActionDetails
                                                                                           NSArray *action = [temp objectForKey:@"GoalActionDetails"];
                                                                                           if (![Utility isEmptyCheck:action]) {
                                                                                               [tempAction addObjectsFromArray:action];
                                                                                           }
                                                                                       }
                                                                                       self->actionArray = [[NSArray alloc]initWithArray:tempAction];
                                                                                   }
                                                                               }
                                                                               
                                                                               if (![Utility isEmptyCheck:self->goalListArray]) {
                                                                                   [self->myGoalTableView reloadData];
                                                                                   self->myGoalTableView.hidden = false;
                                                                                   
//                                                                                   if (self->shouldSetupRem) {
//                                                                                       [self setUpReminderFor:@"Goal"];    //ah ln
//                                                                                   }
                                                                               } else {
                                                                                   self->myGoalTableView.hidden = true;
                                                                               }
                                                                           }
                                                                           //                                                                         [self getDataWithApi:@"GetActionListAPI"];
                                                                       }else if ([apiName caseInsensitiveCompare:@"GetActionListAPI"] == NSOrderedSame) {
                                                                           if (self->contentView) {
                                                                               [self->contentView removeFromSuperview];
                                                                           }
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                               self->actionArray = [responseDictionary objectForKey:@"Details"];
                                                                               [self->myGoalTableView reloadData];
                                                                               //                                                                             if (self->actionArray.count > 0) {
                                                                               //                                                                                 [self->myActionsTableView reloadData];
                                                                               //                                                                                 self->myActionsTableView.hidden = false;
                                                                               //
                                                                               //                                                                                 if (self->shouldSetupRem) {
                                                                               //                                                                                     self->shouldSetupRem = NO;
                                                                               //                                                                                     [self setUpReminderFor:@"Action"];    //ah ln1
                                                                               //                                                                                 }
                                                                               //                                                                             } else {
                                                                               //                                                                                 self->myActionsTableView.hidden = true;
                                                                               //                                                                             }
                                                                           }
                                                                           //                                                                         [self getDataWithApi:@"GetGoalValueListAPI"];        //hide values (feedback)
                                                                       } else if ([apiName caseInsensitiveCompare:@"GetGoalValueListAPI"] == NSOrderedSame) {
                                                                           //                                                                         if (self->contentView) {
                                                                           //                                                                             [self->contentView removeFromSuperview];
                                                                           //                                                                         }
                                                                           
                                                                           if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                               self->valuesArray = [responseDictionary objectForKey:@"Details"];
                                                                               if (self->valuesArray.count > 0) {
                                                                                   [self->myValuesTableView reloadData];
                                                                                   self->myValuesTableView.hidden = false;
                                                                                   
                                                                               } else {
                                                                                   self->myValuesTableView.hidden = true;
                                                                               }
                                                                           }
                                                                       }
                                                                       
                                                                       if (self->goalListArray.count == 0 && self.isfromLocalNotification) {
                                                                           self.isfromLocalNotification=false;
                                                                           //goal
                                                                           AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
                                                                           controller.valuesArray = self->valuesArray;
                                                                           [self.navigationController pushViewController:controller animated:YES];
                                                                           //        [self presentViewController:controller animated:YES completion:nil];
                                                                       }
                                                                       //add_new_new
                                                                       if (self->_isFromCreateAction) {
                                                                           if (![Utility isEmptyCheck:self->goalListArray] && self->goalListArray.count>0) {
                                                                               self->_isFromCreateAction =false;
                                                                               AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
                                                                               controller.goalListArray = [self->goalListArray mutableCopy];
                                                                               [self.navigationController pushViewController:controller animated:YES];
                                                                               //        [self presentViewController:controller animated:YES completion:nil];
                                                                           }
                                                                       }else if (self->_isFromSetGoal){
                                                                           if (![Utility isEmptyCheck:self->valuesArray] && self->valuesArray.count>0) {
                                                                               self->_isFromSetGoal =false;
                                                                               AddGoalsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddGoals"];
                                                                               controller.valuesArray = self->valuesArray;
                                                                               [self.navigationController pushViewController:controller animated:YES];
                                                                               //        [self presentViewController:controller animated:YES completion:nil];
                                                                           }
                                                                       }
                                                                       //add_new_new
                                                                       
                                                                       //                                                                         [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                       //                                                                         return;
                                                                       //                                                                     }
                                                                       
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

-(void) upDownArrowApiForId:(int)goalValueId Value:(int)upDownValue {
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
        [mainDict setObject:[NSNumber numberWithInt:goalValueId] forKey:@"GoalValueId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSString *apiName = @"";
        if (upDownValue == 1) {
            apiName = @"ChangeGoalValueRankDownAPI";
        } else if (upDownValue == 2) {
            apiName = @"ChangeGoalValueRankUpAPI";
        }
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:apiName append:@"" forAction:@"POST"];
        
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
                                                                           [self getDataWithApi:@"GetGoalValueListAPI"];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

-(void) deleteGoalValueFromId:(int) goalValueId {
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
        [mainDict setObject:[NSNumber numberWithInt:goalValueId] forKey:@"GoalValueId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteGoalValueAPI" append:@"" forAction:@"POST"];
        
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
                                                                           [self getDataWithApi:@"GetGoalValueListAPI"];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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

-(void) saveNewValueApi:(NSString *)newValue {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];     //2017-03-06T10:38:18.7877+00:00
        NSString *currentDateStr = [formatter stringFromDate:currentDate];
        
        NSMutableDictionary *modelDict=[[NSMutableDictionary alloc]init];
        [modelDict setObject:[NSNumber numberWithInt:0] forKey:@"id"];
        [modelDict setObject:newValue forKey:@"value"];
        [modelDict setObject:[NSNumber numberWithInt:0] forKey:@"rank"];
        [modelDict setObject:currentDateStr forKey:@"CreatedAt"];
        [modelDict setObject:[defaults objectForKey:@"UserID"] forKey:@"CreatedBy"];
        [modelDict setObject:[NSNumber numberWithBool:false] forKey:@"IsDeleted"];
        [modelDict setObject:[NSNumber numberWithBool:true] forKey:@"Status"];
        [modelDict setObject:[NSArray new] forKey:@"GoalValuesMaps"];
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:modelDict forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateGoalValueAPI" append:@"" forAction:@"POST"];
        
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
                                                                           self->myValuesTextField.text = @"";
                                                                           [self getDataWithApi:@"GetGoalValueListAPI"];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
- (void)changeActionReminder:(NSString *)api {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        //[mainDict setObject:[NSNumber numberWithInteger:[[[actionHistoryArray objectAtIndex:sender.tag] objectForKey:@"goal_mindset_reminder_master_id"] integerValue]] forKey:@"ReminderID"];
        
        [mainDict setObject:toggleArray forKey:@"ChangeList"]; //add_su_new
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
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
                                                                         self->saveButton.hidden = true;
                                                                         [self->toggleArray removeAllObjects];
                                                                         [self getDataWithApi:@"GetGoalListAPI"];
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
//SetGoalsOrderAPI
-(void) setGoalsOrderAPI:(NSArray *)goalArray{
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
        //        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcSessionId"];
        [mainDict setObject:goalArray forKey:@"GoalOrderList"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetGoalsOrderAPI" append:@"" forAction:@"POST"];
        
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
                                                                           [self->goalTempOrder removeAllObjects];
                                                                           self->isArranging = false;
                                                                           self->moveFrom = -1;
                                                                           self->moveTo = -1;
                                                                           self->saveButton.hidden = true;
                                                                           [self->reArrangeButton setTitle:@"RE-ARRANGE GOALS" forState:UIControlStateNormal];
                                                                           [self getDataWithApi:@"GetGoalListAPI"];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void) updateActionReminder:(NSMutableDictionary *)result{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        if ([result objectForKey:@"FrequencyId"] == nil) {
            [result setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [result setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [result setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt1"];
            [result setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt2"];
            [result setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [result setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [result setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [result setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [result setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        [result removeObjectForKey:@"GoalIdTemp"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:result forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddUpdateActionAPI" append:@"" forAction:@"POST"];
        
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
                                                                           [self getDataWithApi:@"GetGoalListAPI"];
                                                                       }else{
                                                                           [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
#pragma mark - Private Method
-(void) setUpVisionBoardFromDict:(NSDictionary *)visionDict {
    if (![Utility isEmptyCheck:visionDict] && visionDict.count > 0) {
        
        NSString *string = ![Utility isEmptyCheck:[visionDict objectForKey:@"OnThisDateIwillLook"]] ? [visionDict objectForKey:@"OnThisDateIwillLook"] : @"";   //ah 23.6
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
        attributedString = [[Utility htmlParseWithString:string] mutableCopy];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        
        visionLabel.attributedText = attributedString;
        if (![Utility isEmptyCheck:[visionDict objectForKey:@"UploadVisionBoardImg"]]) {
            //            [visionImageView sd_setImageWithURL:[NSURL URLWithString:[visionDict objectForKey:@"UploadVisionBoardImg"]] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageProgressiveDownload];
            [visionImageView sd_setImageWithURL:[NSURL URLWithString:[visionDict objectForKey:@"UploadVisionBoardImg"]] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                    CGFloat imageViewHeight = image.size.height/image.size.width * screenWidth;
                    //                NSLog(@"ih %f iw %f",image.size.height,image.size.width);
                    if (imageViewHeight > 0) {
                        self->visionImageViewHeightConstraint.constant = imageViewHeight;
                    }
                }
                
            }];
        } else {
            visionImageView.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
        }
        visionAddNew.hidden = true;
        //        visionImageView.hidden = false;
        //        visionLabelView.hidden = false;
        visionEditButton.hidden = false;
        
        if (myVisionBoardButton.isSelected) {
            visionImageView.hidden = true;
        }else{
            visionImageView.hidden = false;
        }
        
        [totalVisionDict addEntriesFromDictionary:visionDict];  //ah ac1
    } else {
        visionImageView.hidden = true;
        //        visionLabelView.hidden = true;
        visionEditButton.hidden = true;
        visionAddNew.hidden = true;
        if (myVisionBoardButton.isSelected) {
            visionAddNew.hidden = true;
        }else{
            visionAddNew.hidden = false;
        }
    }
}

-(void) playVideoWithUrlStr:(NSString *)urlStr InsideView:(UIView *)playerView {
    //    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    //    NSURL *videoUrl = [NSURL URLWithString:urlStr];
    //    AVPlayer* player = [AVPlayer playerWithURL:videoUrl];
    //    [player play];
    //    playerViewController.player = player;
    //    playerViewController.delegate = self;
    //    playerViewController.showsPlaybackControls = true;
    //    [self addChildViewController:playerViewController];
    //    [playerViewController didMoveToParentViewController:self];
    //    playerViewController.view.frame = playerView.bounds;
    //    [playerView addSubview:playerViewController.view];
    
    //    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
    //    NSURL *videoUrl = [NSURL URLWithString:urlStr];
    //    NSError *_error = nil;
    //    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &_error];
    //
    //    AVPlayer* player = [[AVPlayer alloc]initWithURL:videoUrl];
    //
    //    //                player = [AVPlayer playerWithURL:videoUrl];
    //    playerViewController.player = player;
    //    playerViewController.delegate = self;
    //    playerViewController.showsPlaybackControls = YES;
    //    [self addChildViewController:playerViewController];
    //    [playerViewController didMoveToParentViewController:self];
    //    playerViewController.view.frame = playerView.bounds;
    //    [playerView addSubview:playerViewController.view];
    //    [player play];
    //    cell.playerController = playerViewController;
    //    [cell.playerController.player play];
    //    urlStr = @"https://player.vimeo.com/external/140502161.m3u8?s=3c3437b869f2e19cc4b88d651a05db7a3c9bd662";
    
    if (playerController.player || videoPlayer) {
        [playerController.player pause];
        [videoPlayer pause];
        videoPlayer = nil;
        [playerController removeFromParentViewController];
    }
    
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    NSURL *videoURL = [NSURL URLWithString:urlStr];
    
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
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    helpVideoCount++;
    if (helpVideoCount < helpVideos.count) {
        [self playVideoWithUrlStr:[helpVideos objectAtIndex:helpVideoCount] InsideView:visionVideoView];
    } else {
        [videoPlayer pause];
    }
}
- (void) setUpReminderFor:(NSString *) section {            //ah ln1
    //    if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
    
    if ([section caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *req in requests) {
            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
            if ([pushTo caseInsensitiveCompare:@"Goal"] == NSOrderedSame) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
        
        for (int i = 0; i < goalListArray.count; i++) {
            NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[goalListArray objectAtIndex:i]];
            if ([[dict objectForKey:@"PushNotification"] boolValue]) {
                
                NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                [extraData setObject:dict forKey:@"selectedGoalDict"];
                [extraData setObject:valuesArray forKey:@"valuesArray"];
                
                [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:extraData FromController:(NSString *)@"Goal" Title:[dict objectForKey:@"Name"] Type:@"Goal" Id:[[dict objectForKey:@"id"] intValue]];
            }
        }
    } else if ([section caseInsensitiveCompare:@"Action"] == NSOrderedSame) {
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *req in requests) {
            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
            if ([pushTo caseInsensitiveCompare:@"Action"] == NSOrderedSame) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
        
        if (![Utility isEmptyCheck:actionArray]) {
            for (int i = 0; i < actionArray.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[actionArray objectAtIndex:i]];
                [dict removeObjectForKey:@"goal_mindset_reminder_master_Details"];
                if ([[dict objectForKey:@"PushNotification"] boolValue]) {
                    
                    NSMutableDictionary *extraData = [[NSMutableDictionary alloc] init];
                    [extraData setObject:dict forKey:@"selectedActionDict"];
                    [extraData setObject:[NSArray new] forKey:@"GoalListArray"];
                    
                    [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:extraData FromController:@"Action" Title:[dict objectForKey:@"Name"] Type:@"Action" Id:[[dict objectForKey:@"Id"] intValue]];
                }
            }
        }
        
    } else if ([section caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
        NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *req in requests) {
            NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
            if ([pushTo caseInsensitiveCompare:@"Vision"] == NSOrderedSame) {
                [[UIApplication sharedApplication] cancelLocalNotification:req];
            }
        }
        if ([[visionMutableDict objectForKey:@"PushNotification"] boolValue])
            [SetReminderViewController setOldLocalNotificationFromDictionary:visionMutableDict ExtraData:[NSMutableDictionary new] FromController:@"Vision" Title:@"MBHQ" Type:@"Vision" Id:0];
    }
}
-(void)calcDateIndex{
    NSDate* today = [NSDate date];
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
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
    NSDate *weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];//firstDate
    //
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    //    // [formatter setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
    //
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:date];
    //
    //    //create date on week start
    //    componentsToSubtract = [[NSDateComponents alloc] init];
    //    [componentsToSubtract setDay:(0 - ([comps weekday] - 2))];
    //    NSDate *weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
    //add 7 days
    week = [NSMutableArray arrayWithCapacity:7];
    for (int i=0; i<7; i++) {
        dailyDateformatter.dateFormat = @"yyyy-MM-dd";
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [gregorian dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:[dailyDateformatter stringFromDate:nextDate ]];
        // shabbir
        NSDate* today = [NSDate date];
        dailyDateformatter.dateFormat = @"yyyy-MM-dd";
        NSString *tempDate = [dailyDateformatter stringFromDate:nextDate];
        NSString *sToday = [dailyDateformatter stringFromDate:today];
        if([tempDate isEqualToString:sToday]){
            activeDayIndex = i;
        }
        
    }
}
-(void)setUpHeader{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"my "];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"EyeCatchingPro" size:35] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"BUDDIES"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    [headerButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    if (![Utility isEmptyCheck:_buddiesDict]) {
        if (![Utility isEmptyCheck:[_buddiesDict objectForKey:@"ProfilePic"]]) {
        NSString *imageUrl= [@"" stringByAppendingFormat:@"%@",[_buddiesDict objectForKey:@"ProfilePic"]];
        [buddiesImg sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                  [NSCharacterSet URLQueryAllowedCharacterSet]]]
                           placeholderImage:[UIImage imageNamed:@"lb_avatar.png"]
                                    options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                        });
                                    }];
        }else{
            buddiesImg.image = [UIImage imageNamed:@"lb_avatar.png"];
        }
        
        if (![Utility isEmptyCheck:[_buddiesDict objectForKey:@"Name"]]) {
            buddiesLabel.text = [_buddiesDict objectForKey:@"Name"];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == myGoalTableView) {
        //        if (![defaults boolForKey:@"isGoalExpanded"] && goalListArray.count > 0)
        //            return 1;
        //        else
        //        return goalListArray.count;
        if (isArranging) {
            return activeGoalArray.count;
        }else if (isShowExpGoal) {
            return goalListArray.count;
        }else{
            //            return goalListArray.count;
            if(expRowNumber != -1){
                return activeGoalArray.count+1;
            }else{
                return activeGoalArray.count;
            }
        }
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == myGoalTableView) {
        NSInteger row = 0;
        NSInteger add = 0;
        if (![Utility isEmptyCheck:goalListArray]) {
            if (isArranging) {
                return row;
            }
            NSArray *goalDetailsArr = [[goalListArray objectAtIndex:section] objectForKey:@"GoalActionDetails"];
            
//            NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
//            [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
//            NSString *startDateStr = [Utility getDateOnly:[[goalListArray objectAtIndex:section] objectForKey:@"CreatedAt"]];
//            NSString *dateStr = [Utility getDateOnly:[[goalListArray objectAtIndex:section] objectForKey:@"DueDate"]];
            
//            if ([[dailyDateformatter dateFromString:startDateStr] isEarlierThanOrEqualTo:[NSDate date]] && [[NSDate date] isEarlierThanOrEqualTo:[dailyDateformatter dateFromString:dateStr]]) {
//                //active
//                add = 1;
//            }else{
//                //expired
//                add = 0;
//            }
            if ([selectedHeader containsObject:[NSNumber numberWithInt:[[[goalListArray objectAtIndex:section] objectForKey:@"id"]intValue]]]){
                if (isShowExpGoal) {
                    row = goalDetailsArr.count + add;
                } else {
                    if(expRowNumber == -1){
                        row = goalDetailsArr.count + add;
                    } else if (section < expRowNumber) {
                        row = goalDetailsArr.count + add;
                    } else {
                        row = 0;
                    }
                }
            } else {
                row = 0;
            }
            
        }
        return row;
    } else if (tableView == myActionsTableView) {
        if (![defaults boolForKey:@"isActionExpanded"] && actionArray.count > 0)
            return 1;
        else
            return actionArray.count;
    } else if (tableView == myValuesTableView) {
        //        if (isNew && valuesArray.count > 0)
        //            return 1;
        //        else
        return valuesArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    if (tableView == myGoalTableView) {
        return 1;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    if (tableView == myGoalTableView) {
        return 65;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == myGoalTableView) {
        return UITableViewAutomaticDimension;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    VisionGoalActionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"VisionGoalActionHeaderView"];
    
    if (tableView == myGoalTableView) {
        if (isArranging) {
            sectionHeaderView.swapView.hidden = false;
            if (moveFrom == -1) {
                sectionHeaderView.moveFromButton.hidden = false;
                sectionHeaderView.moveToButton.hidden = true;
            }else if (moveTo == -1) {
                sectionHeaderView.moveFromButton.hidden = true;
                sectionHeaderView.moveToButton.hidden = false;
                if (moveFrom == section) {
                    sectionHeaderView.moveToButton.hidden = true;
                }
            }else{
                sectionHeaderView.moveFromButton.hidden = true;
                sectionHeaderView.moveToButton.hidden = true;
            }
            if([goalTempOrder containsObject:[NSNumber numberWithInteger:section]]){
                [sectionHeaderView.swapView setBackgroundColor:[UIColor colorWithRed:(50/255.0f) green:(205/255.0f) blue:(184/255.0f) alpha:0.7f]];
            }else{
                [sectionHeaderView.swapView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
            }
        }else{
            [sectionHeaderView.swapView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.7f]];
            sectionHeaderView.swapView.hidden = true;
            sectionHeaderView.moveFromButton.hidden = true;
            sectionHeaderView.moveToButton.hidden = true;
        }
        
        sectionHeaderView.goalView.hidden = false;
        if (expRowNumber == section) {
            NSString *txt = @"";
            if (isShowExpGoal) {
                txt = @"HIDE EXPIRED GOALS";
            } else {
                txt = @"VIEW EXPIRED GOALS";
            }
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:txt];
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:17.0],
                                       NSForegroundColorAttributeName : [Utility colorWithHexString:@"32CDB8"],
                                       NSUnderlineStyleAttributeName : [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            [sectionHeaderView.expiredGoalButton setAttributedTitle:text forState:UIControlStateNormal];
            sectionHeaderView.expiredGoalButton.hidden = false;
            
            if (isShowExpGoal) {
                sectionHeaderView.goalView.hidden = false;
            } else {
                sectionHeaderView.goalView.hidden = true;
            }
        } else {
            sectionHeaderView.expiredGoalButton.hidden = true;
        }
        
        sectionHeaderView.moveFromButton.tag = section;
        sectionHeaderView.moveToButton.tag = section;
        [sectionHeaderView.moveFromButton addTarget:self action:@selector(moveFromPressed:) forControlEvents:UIControlEventTouchUpInside];
        [sectionHeaderView.moveToButton addTarget:self action:@selector(moveToPressed:) forControlEvents:UIControlEventTouchUpInside];
        sectionHeaderView.goalHeaderLabel.text = [[[goalListArray objectAtIndex:section] objectForKey:@"Name"] uppercaseString];
        [sectionHeaderView.goalHeaderLabel setTextColor:selectedColor];
        [sectionHeaderView.goalHeaderImageView sd_setImageWithURL:[NSURL URLWithString:[[goalListArray objectAtIndex:section] objectForKey:@"Picture"]] placeholderImage:[UIImage imageNamed:@"you_have_got.png"] options:SDWebImageScaleDownLargeImages];
        sectionHeaderView.goalHeaderImageView.layer.cornerRadius = sectionHeaderView.goalHeaderImageView.frame.size.height/2;
        sectionHeaderView.goalHeaderImageView.layer.masksToBounds = YES;
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        NSString *startDateStr = [[goalListArray objectAtIndex:section] objectForKey:@"CreatedAt"];
        NSArray *dateArr = [startDateStr componentsSeparatedByString:@"T"];
        startDateStr = [dateArr objectAtIndex:0];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *dateStr = [[goalListArray objectAtIndex:section] objectForKey:@"DueDate"];
        dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateComponents *components;
        NSInteger days;
        NSInteger totalDays;
        sectionHeaderView.editGoalButton.userInteractionEnabled = true;
        [sectionHeaderView.editGoalButton setBackgroundColor:[UIColor clearColor]];
        if ([[dailyDateformatter dateFromString:startDateStr] isEarlierThanOrEqualTo:[NSDate date]] && [[NSDate date] isEarlierThanOrEqualTo:[dailyDateformatter dateFromString:dateStr]]) {
            components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [NSDate date] options: 0];
        } else {
            components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [dailyDateformatter dateFromString:dateStr] options: 0];
            [sectionHeaderView.goalHeaderLabel setTextColor:grayColor];
            sectionHeaderView.editGoalButton.userInteractionEnabled = false;
            [sectionHeaderView.editGoalButton setBackgroundColor:[UIColor whiteColor]];
        }
        sectionHeaderView.goalHeaderLabel.textColor = [Utility colorWithHexString:@"32CDB8"];

        days = [components day];
        
        components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [dailyDateformatter dateFromString:startDateStr] toDate: [dailyDateformatter dateFromString:dateStr] options: 0];
        totalDays = [components day];
        
        if ([[dailyDateformatter dateFromString:startDateStr] isSameDay:[dailyDateformatter dateFromString:dateStr]]) {
            if ([[dailyDateformatter dateFromString:startDateStr] isSameDay:[NSDate date]]) {
                days = 0;
            }else{
                days = 1;
            }
            totalDays = 1;
        }
        float currProgress = 0.0;
        if (totalDays != 0) {
            currProgress = (float)days / totalDays;
        }
        if (currProgress > 1.0) {
            currProgress = 1.0;
        }
        //--
        sectionHeaderView.progressBar.progressTintColor = [Utility colorWithHexString:@"32CDB8"];
        sectionHeaderView.progressBar.trackTintColor = [Utility colorWithHexString:@"e6e7e8"];
        sectionHeaderView.progressBar.stripesColor = [Utility colorWithHexString:@"32CDB8"];
        //--
        
        sectionHeaderView.progressBar.type = YLProgressBarTypeFlat;
        sectionHeaderView.progressBar.progress = currProgress;
        int progressInt = currProgress*100.0;
        sectionHeaderView.progressLabel.text = [NSString stringWithFormat:@"%@%%",[Utility customRoundNumber:(float)progressInt]];
        
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        [dailyDateformatter setDateFormat:@"dd/MM/yyyy"];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"ACHIEVE BY %@",[[dailyDateformatter stringFromDate:dailyDate] uppercaseString]]];
        NSRange foundRange = [text.mutableString rangeOfString:@"ACHIEVE BY"];
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:16.0],
                                   NSForegroundColorAttributeName : [UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f]
                                   
                                   };
        [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
        [text addAttributes:@{
                              NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:16.0]
                              
                              }
                      range:foundRange];
        
        [sectionHeaderView.goalDateButton setAttributedTitle:text forState:UIControlStateNormal];
        
        if ([selectedHeader containsObject:[NSNumber numberWithInt:[[[goalListArray objectAtIndex:section] objectForKey:@"id"]intValue]]]){
            [sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"accountability_up_arr.png"] forState:UIControlStateNormal];
            //[sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"arrup_big_grn.png"] forState:UIControlStateNormal];
        } else {
            [sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"accountability_down_arr.png"] forState:UIControlStateNormal];
           // [sectionHeaderView.expandCollapseButton setImage:[UIImage imageNamed:@"arrdwn_big_grn.png"] forState:UIControlStateNormal];
        }
        if (![Utility isEmptyCheck:[[goalListArray objectAtIndex:section] objectForKey:@"GoalActionDetails"]]) {
            sectionHeaderView.expandCollapseButton.hidden = false;
        } else {
            sectionHeaderView.expandCollapseButton.hidden = true;
        }
        [sectionHeaderView.expiredGoalButton addTarget:self action:@selector(expGoalPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        sectionHeaderView.goalHeaderSelectionButton.tag = section;
        [sectionHeaderView.goalHeaderSelectionButton addTarget:self action:@selector(sectionTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        sectionHeaderView.editGoalButton.tag = section;
        [sectionHeaderView.editGoalButton addTarget:self action:@selector(editGoalPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        sectionHeaderView.expandCollapseButton.tag = [[[goalListArray objectAtIndex:section] objectForKey:@"id"]intValue];//section;
        [sectionHeaderView.expandCollapseButton addTarget:self action:@selector(expandCollapseHeader:) forControlEvents:UIControlEventTouchUpInside];
        sectionHeaderView.editView.hidden = true;
    }
    
    return  sectionHeaderView;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (tableView == myGoalTableView) {
        UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
        [myView setBackgroundColor:[UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f]];
        
        return myView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"VisionGoalActionTableViewCell";
    VisionGoalActionTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[VisionGoalActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == myGoalTableView) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        NSArray *goalDetailsArr = [[goalListArray objectAtIndex:indexPath.section] objectForKey:@"GoalActionDetails"];
        if (![Utility isEmptyCheck:goalDetailsArr] && indexPath.row < goalDetailsArr.count) {
            //data
            //            NSArray *goalDetailsArr = [[goalListArray objectAtIndex:indexPath.section] objectForKey:@"GoalActionDetails"];
            cell.goalLabel.text = [[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Name"] uppercaseString];
            cell.goalLabel.textColor = [UIColor colorWithRed:88/255.0f green:88/255.0f blue:88/255.0f alpha:1.0f];
            UIImage *placeholderImage = [UIImage new];
            if (![[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"LastReminderStatus"] boolValue]) {
                placeholderImage = [UIImage imageNamed:@"ok_uncheck.png"];
            } else {
                placeholderImage = [UIImage imageNamed:@"ok.png"];
            }
            if (![Utility isEmptyCheck:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]]) {
                [cell.goalImageView sd_setImageWithURL:[NSURL URLWithString:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]] placeholderImage:placeholderImage options:SDWebImageScaleDownLargeImages];
            } else {
                cell.goalImageView.image = placeholderImage;
            }
            cell.goalImageView.layer.cornerRadius = cell.goalImageView.frame.size.height/2;
            cell.goalImageView.layer.masksToBounds = YES;
            
            [cell.expCollRowButton addTarget:self action:@selector(expandCollapseRow:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.nameView.hidden = false;
            cell.actionAddView.hidden = true;
            cell.arrowView.hidden = false;
            
            NSString *modRow = [NSString stringWithFormat:@"%d-%d",[[[goalListArray objectAtIndex:indexPath.section] objectForKey:@"id"]intValue],[[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Id"]intValue]];
            if ([selectedRow containsObject:modRow]){//if (indexPath.row == selectedRow) {
                cell.tempHistoryView.hidden = false;
                [cell.expCollRowButton setImage:[UIImage imageNamed:@"accountability_up_arr.png"] forState:UIControlStateNormal];
                //[cell.expCollRowButton setImage:[UIImage imageNamed:@"arrup_big_grn.png"] forState:UIControlStateNormal];
            }else{
                cell.tempHistoryView.hidden = true;
                [cell.expCollRowButton setImage:[UIImage imageNamed:@"accountability_down_arr.png"] forState:UIControlStateNormal];
                //[cell.expCollRowButton setImage:[UIImage imageNamed:@"arrdwn_big_grn.png"] forState:UIControlStateNormal];
            }
            
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [Utility getDateOnly:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"CreatedAt"]];
            NSString *dueDate = [Utility getDateOnly:[[goalListArray objectAtIndex:indexPath.section] objectForKey:@"DueDate"]];
            NSDateComponents *components;
            if ([[df dateFromString:dateStr] isEarlierThanOrEqualTo:[NSDate date]] && [[NSDate date] isEarlierThanOrEqualTo:[df dateFromString:dueDate]]) {
                //active
                cell.expCollRowButton.hidden = false;
                components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:dateStr] toDate: [NSDate date] options: 0];
            } else {
                //expired
                cell.expCollRowButton.hidden = true;
                components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: [df dateFromString:dateStr] toDate: [df dateFromString:dueDate] options: 0];
            }
//            NSUInteger totalDays = [components day]+1;
//            NSUInteger days = 0;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %@)", [[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Id"]];
            NSArray *filteredSessionCategoryArray = [actionArray filteredArrayUsingPredicate:predicate];
            if (![Utility isEmptyCheck:filteredSessionCategoryArray]) {
                NSDictionary *actionDict = [filteredSessionCategoryArray objectAtIndex:0];
                if (![Utility isEmptyCheck:[actionDict objectForKey:@"PushNotification"]] && ![Utility isEmptyCheck:[actionDict objectForKey:@"Email"]] && ([[actionDict objectForKey:@"PushNotification"] boolValue] || [[actionDict objectForKey:@"Email"] boolValue])) {
                    cell.reminderOnOffButton.selected = true;
                } else {
                    cell.reminderOnOffButton.selected = false;
                    cell.expCollRowButton.hidden = true;
                    cell.tempHistoryView.hidden = true;
                }
                NSArray *history = [actionDict objectForKey:@"goal_mindset_reminder_master_Details"];
                int total = 0;
                int remTotal = 0;
                int frequencyId = ![Utility isEmptyCheck:[actionDict objectForKey:@"FrequencyId"]]?[[actionDict objectForKey:@"FrequencyId"]intValue]:1;
                if (frequencyId == 3 || frequencyId == 4) {//weekly and fortnightly
                    for (int i=0; i<7; i++) {
                        UIButton *tickButton = cell.tickCollectionButton[i];
                        tickButton.tag = i;
                        tickButton.selected = false;//[[currHistory objectForKey:@"is_action"] boolValue]
                        BOOL isShow = [[actionDict objectForKey:[days objectAtIndex:i]] boolValue];
                        if (isShow) {
                            remTotal++;
                            tickButton.hidden = false;
                        }else{
                            tickButton.hidden = true;
                        }
                    }
                } else if (frequencyId == 5) {// monthly
                    for (int i=0; i<7; i++) {
                        UIButton *tickButton = cell.tickCollectionButton[i];
                        tickButton.tag = i;
                        tickButton.selected = false;//[[currHistory objectForKey:@"is_action"] boolValue]
                        int mDay = [[actionDict objectForKey:@"MonthReminder"] intValue];
                        BOOL isShow = false;
                        if (![Utility isEmptyCheck:history]) {
                            formatter.dateFormat = @"yyyy-MM-dd";
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reminder_datetime_string >= %@) AND (reminder_datetime_string <= %@)", [week objectAtIndex:0], [formatter stringFromDate:[NSDate date]]];
                            history = [history filteredArrayUsingPredicate:predicate];
                            for (NSDictionary *temp in history) {
                                if ([[week objectAtIndex:i] isEqualToString:[temp objectForKey:@"reminder_datetime_string"]]) {
                                    NSDate *mDate = [formatter dateFromString:[temp objectForKey:@"reminder_datetime_string"]];
                                    NSInteger dayComp = mDate.day;
                                    if (dayComp == mDay) {
                                        isShow = true;
                                        break;
                                    }
                                } else {
                                    isShow = false;
                                }
                            }
                        }
                        if (isShow) {
                            remTotal++;
                            tickButton.hidden = false;
                        }else{
                            tickButton.hidden = true;
                        }
                    }
                } else if (frequencyId == 6) {// yearly
                    for (int i=0; i<7; i++) {
                        UIButton *tickButton = cell.tickCollectionButton[i];
                        tickButton.tag = i;
                        tickButton.selected = false;//[[currHistory objectForKey:@"is_action"] boolValue]
                        int mDay = [[actionDict objectForKey:@"MonthReminder"] intValue];
                        BOOL isShow = false;
                        if (![Utility isEmptyCheck:history]) {
                            formatter.dateFormat = @"yyyy-MM-dd";
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reminder_datetime_string >= %@) AND (reminder_datetime_string <= %@)", [week objectAtIndex:0], [formatter stringFromDate:[NSDate date]]];
                            history = [history filteredArrayUsingPredicate:predicate];
                            for (NSDictionary *temp in history) {
                                if ([[week objectAtIndex:i] isEqualToString:[temp objectForKey:@"reminder_datetime_string"]]) {
                                    NSDate *mDate = [formatter dateFromString:[temp objectForKey:@"reminder_datetime_string"]];
                                    NSInteger dayComp = mDate.day;
                                    NSInteger monthComp = mDate.month;
                                    if (dayComp == mDay && [[actionDict objectForKey:[months objectAtIndex: monthComp-1]]boolValue]) {
                                        isShow = true;
                                        break;
                                    }
                                } else {
                                    isShow = false;
                                }
                            }
                        }
                        if (isShow) {
                            remTotal++;
                            tickButton.hidden = false;
                        }else{
                            tickButton.hidden = true;
                        }
                    }
                } else {// daily and twice d
                    remTotal = 7;
                    for (int i=0; i<7; i++) {
                        UIButton *tickButton = cell.tickCollectionButton[i];
                        tickButton.tag = i;
                        tickButton.selected = false;//[[currHistory objectForKey:@"is_action"] boolValue]
                        tickButton.hidden = false;
                    }
                }
                if (![Utility isEmptyCheck:history]) {
                    formatter.dateFormat = @"yyyy-MM-dd";
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(reminder_datetime_string >= %@) AND (reminder_datetime_string <= %@)", [week objectAtIndex:0], [formatter stringFromDate:[NSDate date]]];
                    history = [history filteredArrayUsingPredicate:predicate];//current week history
                    
                    for (int i=0; i<7; i++) {
                        BOOL empty = true;
                        NSDictionary *currHistory = [NSDictionary new];
                        for (NSDictionary *temp in history) {
                            if ([[week objectAtIndex:i] isEqualToString:[temp objectForKey:@"reminder_datetime_string"]]) {
                                empty = false;
                                currHistory = temp;
                                break;
                            } else {
                                empty = true;
                            }
                        }
                        UIButton *tickButton = cell.tickCollectionButton[i];
                        //                        tickButton.accessibilityHint = [NSString stringWithFormat:@"%d",i];//date
                        [tickButton addTarget:self action:@selector(toggleAction:) forControlEvents:UIControlEventTouchUpInside];
                        BOOL isAction = ![Utility isEmptyCheck:[currHistory objectForKey:@"is_action"]]?[[currHistory objectForKey:@"is_action"] boolValue]:false;
                        if (isAction) {
                            total++;
                        }
                        if (empty) {
                            tickButton.tag = i;
                            tickButton.accessibilityHint = [currHistory objectForKey:@"goal_mindset_reminder_master_id"];
                            tickButton.selected = isAction;//[[currHistory objectForKey:@"is_action"] boolValue]
                        } else {
                            tickButton.tag = i;
                            tickButton.accessibilityHint = [currHistory objectForKey:@"goal_mindset_reminder_master_id"];
                            tickButton.selected = isAction;
                        }
                    }
                }
                
                cell.completedLabel.text = [NSString stringWithFormat:@"%d OF %d",total,remTotal];
            }
            
            for (int i=0; i<7; i++) {
                UIView *dayView = cell.dayCollectionView[i];
                if (i == activeDayIndex) {
                    dayView.alpha = 1.0;
                } else {
                    dayView.alpha = 0.4;
                }
            }
            
            //            cell.completedLabel.text = [NSString stringWithFormat:@"%lu OF %lu",(unsigned long)days,(unsigned long)totalDays];
            [cell.viewHistoryButton addTarget:self action:@selector(viewHistoryPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.viewHistoryButton.tag = indexPath.row;
            cell.viewHistoryButton.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            cell.expCollRowButton.tag = [[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Id"]intValue];
            cell.expCollRowButton.accessibilityHint = [NSString stringWithFormat:@"%d",[[[goalListArray objectAtIndex:indexPath.section] objectForKey:@"id"]intValue]];
            cell.reminderOnOffButton.tag = indexPath.row;
            cell.reminderOnOffButton.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        } else {
            //add button
            cell.nameView.hidden = true;
            cell.tempHistoryView.hidden = true;
            cell.actionAddView.hidden = false;
            cell.arrowView.hidden = true;
        }
        
        [cell.actionAddButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.actionAddButton.tag = 1002;
        cell.actionAddButton.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        
        //        NSArray *goalDetailsArr = [[goalListArray objectAtIndex:indexPath.section] objectForKey:@"GoalActionDetails"];
        //        cell.goalLabel.text = [[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Name"] uppercaseString];
        //        UIImage *placeholderImage = [UIImage new];
        //        if (![[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"LastReminderStatus"] boolValue]) {
        //            placeholderImage = [UIImage imageNamed:@"ok_uncheck.png"];
        //        } else {
        //            placeholderImage = [UIImage imageNamed:@"ok.png"];
        //        }
        //        if (![Utility isEmptyCheck:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]]) {
        //            [cell.goalImageView sd_setImageWithURL:[NSURL URLWithString:[[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Picture"]] placeholderImage:placeholderImage options:SDWebImageScaleDownLargeImages];
        //        } else {
        //            cell.goalImageView.image = placeholderImage;
        //        }
        //        cell.goalImageView.layer.cornerRadius = cell.goalImageView.frame.size.height/2;
        //        cell.goalImageView.layer.masksToBounds = YES;
    } else if (tableView == myActionsTableView) {
        cell.actionsTitleLabel.text = [[[actionArray objectAtIndex:indexPath.row] objectForKey:@"Name"] uppercaseString];
        NSArray *actionSubArray = [[actionArray objectAtIndex:indexPath.row] objectForKey:@"GoalDetails"];
        if (![Utility isEmptyCheck:actionSubArray]) {
            cell.actionsSubTitleLabel.text = [[[actionSubArray objectAtIndex:0] objectForKey:@"Name"] uppercaseString];
        } else {
            cell.actionsSubTitleLabel.text = @"";
            
        }
        
        UIImage *placeholderImage = [UIImage new];
        if (![[[actionArray objectAtIndex:indexPath.row] objectForKey:@"LastReminderStatus"] boolValue]) {       //ah ux2
            placeholderImage = [UIImage imageNamed:@"ok_uncheck.png"];
        } else {
            placeholderImage = [UIImage imageNamed:@"ok.png"];
        }
        if (![Utility isEmptyCheck:[[actionArray objectAtIndex:indexPath.row] objectForKey:@"Picture"]]) {
            [cell.actionsImageView sd_setImageWithURL:[NSURL URLWithString:[[actionArray objectAtIndex:indexPath.row] objectForKey:@"Picture"]] placeholderImage:placeholderImage options:SDWebImageScaleDownLargeImages];
        } else {
            cell.actionsImageView.image = placeholderImage;
        }
        cell.actionsImageView.layer.cornerRadius = cell.actionsImageView.frame.size.height/2;
        cell.actionsImageView.layer.masksToBounds = YES;
    } else if (tableView == myValuesTableView) {
        cell.valuesLabel.text = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"value"] uppercaseString];
        switch (indexPath.row) {
            case 0:
                headerFirstLabel.text = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"value"] uppercaseString];
                break;
                
            case 1:
                headerSecondLabel.text = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"value"] uppercaseString];
                break;
                
            case 2:
                headerThirdLabel.text = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"value"] uppercaseString];
                break;
                
            default:
                break;
        }
        
        cell.valuesUpArrow.hidden = false;
        cell.valuesDownArrow.hidden = false;
        if (indexPath.row == 0) {
            cell.valuesUpArrow.hidden = true;
        } else if (indexPath.row == valuesArray.count - 1) {
            cell.valuesDownArrow.hidden = true;
        }
        
        [cell.valuesUpArrow addTarget:self
                               action:@selector(upArrowTapped:)
                     forControlEvents:UIControlEventTouchUpInside];
        cell.valuesUpArrow.accessibilityHint = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"id"] stringValue];
        
        [cell.valuesDownArrow addTarget:self
                                 action:@selector(downArrowTapped:)
                       forControlEvents:UIControlEventTouchUpInside];
        cell.valuesDownArrow.accessibilityHint = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"id"] stringValue];
        
        [cell.valuesDeleteButton addTarget:self
                                    action:@selector(valuesDeleteButtonTapped:)
                          forControlEvents:UIControlEventTouchUpInside];
        cell.valuesDeleteButton.accessibilityHint = [[[valuesArray objectAtIndex:indexPath.row] objectForKey:@"id"] stringValue];
        
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == myGoalTableView) {
        //goal
        NSArray *goalDetailsArr = [[goalListArray objectAtIndex:indexPath.section] objectForKey:@"GoalActionDetails"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %@)", [[goalDetailsArr objectAtIndex:indexPath.row] objectForKey:@"Id"]];
        NSArray *filteredSessionCategoryArray = [actionArray filteredArrayUsingPredicate:predicate];
        NSDictionary *selectedDict = [[NSDictionary alloc]init];
        if (filteredSessionCategoryArray.count > 0) {
            selectedDict = [filteredSessionCategoryArray objectAtIndex:0];
            
        }
        
        AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
        controller.goalListArray = [goalListArray mutableCopy];
        //        controller.selectedGoal = [goalListArray objectAtIndex:indexPath.section];
        controller.actionSelectedDict = [selectedDict mutableCopy];
        controller.buddyDict = _buddiesDict;
        [self.navigationController pushViewController:controller animated:YES];
        //        [self presentViewController:controller animated:YES completion:nil];
        
    } else if (tableView == myActionsTableView) {
        //action
        AddActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddAction"];
        controller.goalListArray = [goalListArray mutableCopy];
        controller.actionSelectedDict = [actionArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
        //        [self presentViewController:controller animated:YES completion:nil];
    }
}

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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
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

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    // Store the data
    //    if (activeTextField == emailTextField) {
    //        [passwordTextField becomeFirstResponder];
    //    }
    //    else if (activeTextField == passwordTextField){
    //        //[self loginButtonPress:nil];
    //        [textField resignFirstResponder];
    //    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
}

#pragma mark - ReminderDelegate
-(void) reminderSettingsValue:(NSMutableDictionary *)reminderDict {
    //    isChanged = YES;
    //    [Utility startFlashingbutton:saveButton];
    //    [Utility startFlashingbutton:doneButton];
    //    savedReminderDict = reminderDict;   //ah ln1
    [reminderDict setObject:[NSNumber numberWithBool:YES] forKey:@"HasReminder"];
    //    [resultDict addEntriesFromDictionary:reminderDict];
    [self updateActionReminder:reminderDict];
}
-(void) cancelReminder {
    //    if ([resultDict objectForKey:@"FrequencyId"] != nil) {
    //
    //    } else {
    //        [setReminderSwitch setOn:NO];
    //        [resultDict setObject:[NSNumber numberWithBool:NO] forKey:@"HasReminder"];
    //        [resultDict removeObjectForKey:@"FrequencyId"];
    //    }
    //    [self updateActionReminder:];
}
@end
