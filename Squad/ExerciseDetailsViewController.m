//
//  ExerciseDetailsViewController.m
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 30/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import "ExerciseDetailsViewController.h"
#import "ExerciseDetailHeaderView.h"
#import "ExerciseDetailsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ExerciseVideoViewController.h"
#import "IndividualExerciseViewController.h"
#import "SettingsViewController.h"
#import "WeightRecordSheetViewController.h"
#import "ExerciseDetailsVideoViewController.h"
#import "ExerciseCollectionViewCell.h"
#import "ExerciseFooterView.h"
#import "SettingsViewController.h"


static NSString *SectionHeaderViewIdentifier = @"ExerciseDetailHeaderView";
static NSString *SectionFooterViewIdentifier = @"ExerciseFooterView";
@interface ExerciseDetailsViewController (){
    IBOutlet UIView *header;
    
    IBOutlet UILabel *sessionOverview;
    
    //ah ux(add labels in storyboard)
    IBOutlet UILabel *sessionTypeLabel;
    IBOutlet UILabel *sessionDurationLabel;
    IBOutlet UILabel *BodyAreaLabel;

    //ah ux3(storyboard)
    IBOutlet UILabel *equipmentReqLabel;

    IBOutlet UITableView *table;
    IBOutlet UIButton *saveButton;
    NSArray *exerciseDetailsArray;
    int selectedIndex;
    AVPlayer *player;
    
    UIView *contentView;
    NSMutableArray *exerciseListArray;  //arnab 17 all
    IBOutlet UIPickerView *listPickerView;
    UIToolbar *toolbar;
    IBOutlet UIVisualEffectView *blurVisulaEffectView;
    IBOutlet UIView *pickerSuperView;
    
    IBOutlet UIButton *playButton;
    
    IBOutlet NSLayoutConstraint *overviewHeightConstraint;  //ah ux1(storyboard)
    IBOutlet NSLayoutConstraint *durationHeightConstraint;  //ah ux1(storyboard)
    IBOutletCollection(UIButton) NSArray *actionButtons;

    NSMutableDictionary *editExerciseDict;
    NSMutableDictionary *editSessionDictionary;
    NSDictionary *exerciseDetailsDict;
    NSMutableArray *cktListArray;
    NSString *editCktOrExPicker;
    int selectedSection ;
    int selectedInfo;
    ExerciseDetailHeaderView *selectedHeaderView;
    IBOutlet UIButton *weightRecordButton; //AY 23102017
    IBOutlet UIButton *weightRecordBottomButton;
    IBOutlet UIButton *menuButton;
    
    IBOutlet NSLayoutConstraint *tableViewHeightConstant;
    IBOutlet UICollectionView *collection;
    IBOutlet NSLayoutConstraint *collectionHeightConstant;
    IBOutlet UIView *colletionView;
    NSMutableArray *uniqueequipmentsArray;
    IBOutlet UILabel *dayLabel;
    NSDate *weekstart;
    IBOutlet NSLayoutConstraint *colletionLableHeightConstant;
    IBOutlet UITextView *instructionTextView;
    IBOutlet UIButton *gymButton;
    IBOutlet UIButton *homeButton;
    IBOutlet UIScrollView *scroll;
    IBOutlet NSLayoutConstraint *editSessionHeightConstant;
    IBOutlet UIView *editSessionView;
    BOOL isLeft;
    IBOutlet UIButton *favButton; //18may2018
    IBOutlet UILabel *nickNameLabel;
    int sessionFlowId; // Added to Identify Timer and Follow Along Sessions.
    int timerSessionTime;
    IBOutlet UIButton *timerImageButton;
    IBOutlet UILabel *timeLabel;
    
    //04/07/18
    __weak IBOutlet UIButton *addTodayButton;
    __weak IBOutlet UIButton *addOtherButton;
    NSMutableArray *addDayArray;
    BOOL isAddedToCustomSession;
    BOOL isShowCustomWeightAlert;
    IBOutlet UIButton *sessionOverViewButton;
}

@end

@implementation ExerciseDetailsViewController
@synthesize exerciseData,fromWhere,exerciseSessionType,workoutTypeId,weekDate,isExDetails,completeSessionId,delegate,isChanged;
#pragma mark - View Life Cycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
   // NSLog(@"%@\n%@\n%@",weekDate,exerciseData,exerciseSessionType);
    [super viewDidLoad];
    [defaults setBool:false forKey:@"PlaylistSet"];
    isShowCustomWeightAlert = true;
    selectedSection = -1;
    selectedIndex = -1;
    
    table.estimatedSectionHeaderHeight = UITableViewAutomaticDimension;
    table.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    exerciseListArray = [[NSMutableArray alloc]init];
    editExerciseDict = [[NSMutableDictionary alloc]init];
    cktListArray = [[NSMutableArray alloc]init];
    editCktOrExPicker = @"";
    selectedInfo = -1;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ExerciseDetailHeaderView" bundle:nil];
    [table registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    UINib *sectionFooterNib = [UINib nibWithNibName:@"ExerciseFooterView" bundle:nil];
    [table registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:SectionFooterViewIdentifier];
    
    table.estimatedRowHeight = 100;
    table.rowHeight = UITableViewAutomaticDimension;
    
    table.sectionHeaderHeight = UITableViewAutomaticDimension;
    table.estimatedSectionHeaderHeight = 60;
    
    
    
    
    
    
    uniqueequipmentsArray = [[NSMutableArray alloc]init];
    
//    table.sectionFooterHeight = UITableViewAutomaticDimension;
//    table.estimatedSectionFooterHeight = 40;
    
    if([[exerciseSessionType lowercaseString] isEqualToString:@"weights"] && ![Utility isEmptyCheck:weekDate]){
        weightRecordButton.hidden = false;
        weightRecordBottomButton.hidden = false;
        
        if ([fromWhere isEqualToString:@"customSession"] && isShowCustomWeightAlert) {
            isShowCustomWeightAlert = false;
            [self showCustomWeightAlert];
        }
    }else{
        weightRecordButton.hidden = true;
        weightRecordBottomButton.hidden = true;
       
    }
    
    NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    if (![fromWhere isEqualToString:@"customSession"]) { //Feedback_work
        NSDate *dailyDate = [dailyDateformatter dateFromString:weekDate];
        [dailyDateformatter setDateFormat:@"EEEE"];
        if (![Utility isEmptyCheck:dailyDate]) {
            dayLabel.text = [NSString stringWithFormat:@"%@",[dailyDateformatter stringFromDate:dailyDate]];
        }
    }else{
        NSDate *customDate = [dailyDateformatter dateFromString:_sessionDate];
        [dailyDateformatter setDateFormat:@"EEEE"];
        if (![Utility isEmptyCheck:customDate]) {
            dayLabel.text = [NSString stringWithFormat:@"%@",[dailyDateformatter stringFromDate:customDate]];
        }
    } //Feedback_work
    
//    weightRecordButton.layer.borderColor = [Utility colorWithHexString:@"F427AB"].CGColor;//AY 01112017
//    weightRecordButton.layer.borderWidth=2.0; //AY 01112017
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
        NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
        if (![insArray containsObject:@"TrainSessionVideo"]) {
            //[self helpButtonPressed:helpButton];
            [self showInstructionOverlays];
            [insArray addObject:@"TrainSessionVideo"];
            [defaults setObject:insArray forKey:@"InstructionOverlays"];
        }
    }else {
        //[self helpButtonPressed:helpButton];
        [self showInstructionOverlays];
        NSMutableArray *insArray = [[NSMutableArray alloc] init];
        [insArray addObject:@"TrainSessionVideo"];
        [defaults setObject:insArray forKey:@"InstructionOverlays"];
    }
    
    addTodayButton.layer.borderWidth = 1;
    addTodayButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    addOtherButton.layer.borderWidth = 1;
    addOtherButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    
    sessionOverViewButton.layer.borderWidth = 1;
    sessionOverViewButton.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    
    [self getExerciseDetails];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];

    if ([defaults boolForKey:@"PlaylistSet"]) {
        [defaults setBool:false forKey:@"PlaylistSet"];
        ExerciseVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseVideo"];
        controller.mainDataArray = exerciseDetailsArray;
        controller.sessionDate = _sessionDate;
        controller.weekDate = weekDate; //AY 07112017
        if (![fromWhere isEqualToString:@"DailyWorkout"]) {
            controller.isFromCustom=true;  //AY 02112017
        }
        controller.sessionName = [exerciseDetailsDict objectForKey:@"SessionTitle"]; //ah 2.2
        controller.workoutType = [exerciseDetailsDict objectForKey:@"WorkoutType"];  //ah 9.5
        controller.exSessionId = _exSessionId;//AY 02112017
        controller.workoutTypeId=workoutTypeId;//AY 02112017
        controller.completeSessionId=completeSessionId;//AY 05012018
        [self.navigationController pushViewController:controller animated:YES];
    }
    //    exerciseListArray = [@[@"Sit-Up",@"Crunch-Bicycle",@"Push-Up",@"Squat",@"Dead Lift"] mutableCopy];
     isLeft = true;
    if (isExDetails) { //add_su_1_com
        [menuButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }else{
        [menuButton setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    }
    [self animateButton];   //ah ux
    [self setUpInstructionView];
    [table addObserver:self forKeyPath:@"contentSize" options:0 context:NULL]; //add_add
    [collection addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [table reloadData];
}
- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    selectedSection = -1;
    selectedIndex = -1;
    [player pause];
    player = nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    [table removeObserver:self forKeyPath:@"contentSize"]; //add_add
    [collection removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}

#pragma mark - End

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == table) {
        tableViewHeightConstant.constant=table.contentSize.height;
    }else if (object == collection){
        collectionHeightConstant.constant = collection.contentSize.height;
    }
}
#pragma mark -Private Method

-(void)sizeHeaderToFit{
    UIView *headerView = table.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    table.tableHeaderView = headerView;
}

-(void)setUpInstructionView{
    if(_isHome){
        gymButton.selected = false;
        homeButton.selected = true;
    }else{
        gymButton.selected = true;
        homeButton.selected = false;
    }
    NSString *strTextView = @"TOP TIPS:\n1.Swipe left on exercises to change\n2.Click on exercise to view video\n3.Click “My Weights” to record your weights\n4.Click “My Music” to set your playlist";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
     paragraphStyle.alignment= NSTextAlignmentCenter;
    
    NSRange rangeBold = [strTextView rangeOfString:@"TOP TIPS:"];
    NSDictionary *dictBoldText =  @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Oswald-regular" size:20],
                                    NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                                    NSParagraphStyleAttributeName:paragraphStyle
                                    };
    
    NSRange rangeBold1 = [strTextView rangeOfString:@"My Weights"];
    NSDictionary *dictBoldText1 = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Oswald-regular" size:15],
                                    NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                                    NSParagraphStyleAttributeName:paragraphStyle
                                    };
    
    NSRange rangeBold2 = [strTextView rangeOfString:@"My Music"];
    NSDictionary *dictBoldText2 = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Oswald-regular" size:15],
                                    NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                                    NSParagraphStyleAttributeName:paragraphStyle
                                    };
    
    NSDictionary *attrDict1 = @{
                                NSFontAttributeName : [UIFont fontWithName:@"Oswald-ExtraLight" size:15.0],
                                NSForegroundColorAttributeName : [Utility colorWithHexString:@"58595B"],
                                NSParagraphStyleAttributeName:paragraphStyle
                                };
    
    NSMutableAttributedString *mutAttrTextViewString = [[NSMutableAttributedString alloc] initWithString:strTextView attributes:attrDict1];
    [mutAttrTextViewString setAttributes:dictBoldText range:rangeBold];
    [mutAttrTextViewString setAttributes:dictBoldText1 range:rangeBold1];
    [mutAttrTextViewString setAttributes:dictBoldText2 range:rangeBold2];
    
    instructionTextView.textColor = [Utility colorWithHexString:@"58595B"];
    [instructionTextView setAttributedText:mutAttrTextViewString];
    
    //NSLog (@"Font families: %@", [UIFont familyNames]);
}
-(IBAction)openPicker:(id)sender ForEditing:(NSString *)editCktOrEx{
    //    selectedButton= sender;
    if ([editCktOrEx isEqualToString:@"ckt"]) {
        editCktOrExPicker = @"ckt";
        if (cktListArray.count > 0) {
            pickerSuperView.hidden = YES;
            [toolbar removeFromSuperview];
            
            //[self showPicker];
            //    listPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, screenHeight/2 - 35, screenWidth, screenHeight/2 + 35)];
            listPickerView.dataSource = self;
            listPickerView.delegate = self;
            listPickerView.showsSelectionIndicator = YES;
            
            [UIView transitionWithView:blurVisulaEffectView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                blurVisulaEffectView.hidden = NO;
                            }
                            completion:NULL];
            [UIView transitionWithView:pickerSuperView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                pickerSuperView.hidden = NO;
                            }
                            completion:NULL];
            
            listPickerView.backgroundColor = [UIColor clearColor];
        }else
            [self getExerciseList]; //[self getCktList];
    } else if ([editCktOrEx isEqualToString:@"ex"]){
        editCktOrExPicker = @"ex";
        if (exerciseListArray.count > 0) {
            pickerSuperView.hidden = YES;
            [toolbar removeFromSuperview];
            
            //[self showPicker];
            //    listPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, screenHeight/2 - 35, screenWidth, screenHeight/2 + 35)];
            listPickerView.dataSource = self;
            listPickerView.delegate = self;
            listPickerView.showsSelectionIndicator = YES;
            
            [UIView transitionWithView:blurVisulaEffectView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                blurVisulaEffectView.hidden = NO;
                            }
                            completion:NULL];
            [UIView transitionWithView:pickerSuperView
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                pickerSuperView.hidden = NO;
                            }
                            completion:NULL];
            
            listPickerView.backgroundColor = [UIColor clearColor];
        }else
            [self getExerciseList];
    }
    
}

-(void)pickerdonePressed{
    //    selectedRow = [listPickerView selectedRowInComponent:0];
    //    if (selectedRow > 0) {
    //        [selectedButton setTitleColor:[UIColor colorWithRed:(0.0/255) green:(176.0/255) blue:(61.0/255) alpha:1.0] forState:UIControlStateNormal];
    //        [selectedButton setTitle:[[[listArray objectAtIndex:selectedRow] objectForKey:@"label"] capitalizedString] forState:UIControlStateNormal];
    //        [selectedButton setAccessibilityHint:[[listArray objectAtIndex:selectedRow] objectForKey:@"value"]];
    //    } else {
    //        [selectedButton setTitle:@"" forState:UIControlStateNormal];
    //        [selectedButton setAccessibilityHint:@""];
    //    }
    //    [listPickerView removeFromSuperview];
    //    [toolbar removeFromSuperview];
    //    [listArray removeAllObjects];
    //    listPickerView.hidden = YES;
}
-(void)pickerCancelTapped{
    //    [listPickerView removeFromSuperview];
    //    [toolbar removeFromSuperview];
    //    [listArray removeAllObjects];
    //    listPickerView.hidden = YES;
}
-(void) showAlert {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ExerciseVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseVideo"];
    controller.mainDataArray = exerciseDetailsArray;
    controller.sessionDate = _sessionDate;
    controller.weekDate = weekDate; //AY 07112017
    if ([fromWhere isEqualToString:@"customSession"]) {
        controller.isFromCustom=true;  //AY 02112017
    }
    controller.sessionName = [exerciseDetailsDict objectForKey:@"SessionTitle"]; //ah 2.2
    controller.workoutType = [exerciseDetailsDict objectForKey:@"WorkoutType"];  //ah 9.5
    controller.exSessionId = _exSessionId;//AY 02112017
    controller.workoutTypeId=workoutTypeId;//AY 02112017
    controller.completeSessionId=completeSessionId;//AY 05012018
    controller.sessionFlowId = sessionFlowId;
    controller.sessionDuration = timerSessionTime;
    controller.followAlongSessiondata = exerciseDetailsDict;
    controller.isAddedToCustomSession = isAddedToCustomSession;
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Set Playlist"
                                          message:@"Do you want to set a playlist?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [defaults setObject:nil forKey:@"mediaItemCollection"];
                                       [defaults setObject:nil forKey:@"selectedSpotifyCollectionUri"];
                                       [defaults synchronize];
                                       controller.currentPage = -1;
                                       [self.navigationController pushViewController:controller animated:YES];
                                       [appDelegate.FBWAudioPlayer pause];
                                       appDelegate.FBWAudioPlayer = nil;
                                   }];
    UIAlertAction *previousAction = [UIAlertAction
                                   actionWithTitle:@"Same as last session"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       controller.currentPage = 0;
                                       [self.navigationController pushViewController:controller animated:YES];
                                       [appDelegate.FBWAudioPlayer pause];
                                       appDelegate.FBWAudioPlayer = nil;
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No music"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           controller.currentPage = 0;
                                           [defaults setObject:nil forKey:@"mediaItemCollection"];
                                           [defaults setObject:nil forKey:@"selectedSpotifyCollectionUri"];
                                           [defaults synchronize];
                                           [self.navigationController pushViewController:controller animated:YES];
                                           [appDelegate.FBWAudioPlayer pause];
                                           appDelegate.FBWAudioPlayer = nil;
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:previousAction];
        [alertController addAction:cancelAction];
    
        [self presentViewController:alertController animated:YES completion:nil];
}

-(void)showCustomWeightAlert {
    
    if([defaults boolForKey:@"dontShowWeightAlert"]) return;
    
    NSString *msgStr = @"This is a custom weights session and has been designed to get you results based on your goals, available equipment and time.\n\nThe sessions will be similar for 4-6 weeks in a row so you can IMPROVE. These are called training blocks.\n\nDon't forget to click 'my weights' and record your reps and weights so you can remember your progress and make it harder each week by lifting more or doing a few more reps.";
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Info\n\n"
                                          message:msgStr
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"GOT IT"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Dont show me again."
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [defaults setBool:true forKey:@"dontShowWeightAlert"];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void) animateButton {   //ah ux2
    [UIView animateWithDuration:0.5 animations:^{
        self->playButton.alpha = 0.1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self->playButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateButton];
        }];
    }];
}
- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    NSArray *messageArray = @[
                              @"Tap here to play the session."
                              ];
    for (int i = 0;i<actionButtons.count;i++) {
        UIButton *button =actionButtons[i];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:button forKey:@"view"];
        [dict setObject:@NO forKey:@"onTop"];
        [dict setObject:messageArray[i] forKey:@"insText"];
        [dict setObject:@YES forKey:@"isCustomFrame"];
        NSLog(@"%@",NSStringFromCGRect([self.view convertRect:button.frame fromView:button.superview]));
        CGRect tempRect=[self.view convertRect:button.frame fromView:button.superview];
        //        tempRect.cen
        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-tempRect.size.height/2, tempRect.size.width, tempRect.size.height);
        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
        [overlayViews addObject:dict];
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}

-(void)setupExerciseView{
    
    sessionFlowId = [exerciseDetailsDict[@"SessionFlowId"] intValue];
    
    
    if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER || sessionFlowId == FOLLOWALONG){
        editSessionHeightConstant.constant = 0;
        editSessionView.hidden = true;
    }else if (![fromWhere isEqualToString:@"DailyWorkout"]) {
        editSessionHeightConstant.constant = 30;
        editSessionView.hidden = false;
    }else{
        editSessionHeightConstant.constant = 0;
        editSessionView.hidden = true;
    }
    
    if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
        timerImageButton.hidden = false;
        
        if (![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"Time"]] && [[exerciseDetailsDict objectForKey:@"Time"] intValue] > 0) {
            timeLabel.text = [NSString stringWithFormat:@"%@ mins",[exerciseDetailsDict objectForKey:@"Time"]];
            timeLabel.hidden = false;
            timerSessionTime = [[exerciseDetailsDict objectForKey:@"Time"] intValue];
        }else{
            timeLabel.hidden = true;
        }
        
    }else{
        timerImageButton.hidden = true;
        timeLabel.hidden = true;
    }
    
    nickNameLabel.text = ![Utility isEmptyCheck:exerciseDetailsDict[@"SessionNickName"]]?exerciseDetailsDict[@"SessionNickName"]:@"";
    if (nickNameLabel.text.length == 0) {
        nickNameLabel.text = ![Utility isEmptyCheck:exerciseDetailsDict[@"SessionTitle"]]?exerciseDetailsDict[@"SessionTitle"]:@"";
    }
    NSArray *overViewArray = [exerciseDetailsDict objectForKey:@"SessionOverview"];
    
    if(![Utility isEmptyCheck:exerciseDetailsDict[@"WorkoutType"]]){
        
        exerciseSessionType = exerciseDetailsDict[@"WorkoutType"];
        if([[exerciseSessionType lowercaseString] isEqualToString:@"weights"] && ![Utility isEmptyCheck:weekDate]){
            weightRecordButton.hidden = false;
            weightRecordBottomButton.hidden = false;
            if ([fromWhere isEqualToString:@"customSession"] && isShowCustomWeightAlert) {
                isShowCustomWeightAlert = false;
                [self showCustomWeightAlert];
            }
        }else{
            weightRecordButton.hidden = true;
            weightRecordBottomButton.hidden = true;
        }
    } //AY 01112017
    
    if (![Utility isEmptyCheck:overViewArray] && overViewArray.count > 0 ) {
        sessionOverview.text = [[exerciseDetailsDict objectForKey:@"SessionOverview"] componentsJoinedByString:@"\n"];;
        overviewHeightConstraint.constant = 0;
        
        sessionOverViewButton.hidden = false;
    }else{     //ah ux
        //                                                                             [header removeFromSuperview];
        //                                                                             table.tableHeaderView = nil;
        overviewHeightConstraint.constant = 0;     //ah ux1
        sessionOverViewButton.hidden = true;
    }
    
    //ah ux
    if (![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"WorkoutType"]]) {
        sessionTypeLabel.text = [NSString stringWithFormat:@"%@",[exerciseDetailsDict objectForKey:@"WorkoutType"]];
    }
    if (![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"Duration"]] && [[exerciseDetailsDict objectForKey:@"Duration"] intValue] > 0) {
        sessionDurationLabel.text = [NSString stringWithFormat:@"%@ mins",[exerciseDetailsDict objectForKey:@"Duration"]];
    } else {
        durationHeightConstraint.constant = 0;     //ah ux1
    }
    
    if (![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"BodyArea"]]) {
        BodyAreaLabel.text = [NSString stringWithFormat:@"%@",[exerciseDetailsDict objectForKey:@"BodyArea"]];
    } else {
        
    }
    //end
    
    //18may2018
    if (![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"IsFavourite"]]) {
        if ([[exerciseDetailsDict objectForKey:@"IsFavourite"]boolValue]) {
            favButton.selected = true;
        }else{
            favButton.selected = false;
        }
    } //18may2018
    
    //ah ux3
    NSMutableArray *equipmentsArray = [[NSMutableArray alloc] init];
    
    NSArray *cktArr = ![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"Exercises"]] ? [exerciseDetailsDict objectForKey:@"Exercises"] : [NSArray new];
    for (int i = 0; i < cktArr.count; i++) {
        if (![Utility isEmptyCheck:[[cktArr objectAtIndex:i] objectForKey:@"Equipments"]]) {
            
            //add
            NSMutableDictionary *equipDict = [[NSMutableDictionary alloc]init];
            
//            [equipDict setObject:[[cktArr objectAtIndex:i] objectForKey:@"Equipments"] forKey:@"equipments"];
//            [equipDict setObject:[@""stringByAppendingFormat:@"%d",i] forKey:@"section"];
//            [equipDict setObject:[cktArr objectAtIndex:i] forKey:@"row"];
            
            NSArray *arr=[[cktArr objectAtIndex:i]objectForKey:@"Equipments"];
            for (int k= 0; k<arr.count; k++) {
                [equipDict setObject:[arr objectAtIndex:k] forKey:@"equipments"];
                [equipDict setObject:[@""stringByAppendingFormat:@"%d",i] forKey:@"section"];
                [equipDict setObject:[@""stringByAppendingFormat:@"%d",i] forKey:@"row"];
            }
            
            [equipmentsArray addObject:equipDict];
            //===
            
            //                                                                                 [equipmentsArray addObjectsFromArray:[[cktArr objectAtIndex:i] objectForKey:@"Equipments"]];
        }
        NSArray *exArr = ![Utility isEmptyCheck:[[cktArr objectAtIndex:i] objectForKey:@"CircuitExercises"]] ? [[cktArr objectAtIndex:i] objectForKey:@"CircuitExercises"] : [NSArray new];
        for (int j = 0; j < exArr.count; j++) {
            if (![Utility isEmptyCheck:[[exArr objectAtIndex:j] objectForKey:@"Equipments"]]) {
                
                //add
                NSMutableDictionary *equipDict = [[NSMutableDictionary alloc]init];
                
                NSArray *arr=[[exArr objectAtIndex:j]objectForKey:@"Equipments"];
                for (int k= 0; k<arr.count; k++) {
                    [equipDict setObject:[arr objectAtIndex:k] forKey:@"equipments"];
                    [equipDict setObject:[@""stringByAppendingFormat:@"%d",i] forKey:@"section"];
                    [equipDict setObject:[@""stringByAppendingFormat:@"%d",j] forKey:@"row"];
                }
                
                //                                                                                     [equipDict setObject:[[exArr objectAtIndex:j]objectForKey:@"Equipments"] forKey:@"equipments"];
                //                                                                                     [equipDict setObject:[@""stringByAppendingFormat:@"%d",i] forKey:@"section"];
                //                                                                                     [equipDict setObject:[@""stringByAppendingFormat:@"%d",j] forKey:@"row"];
                
                [equipmentsArray addObject:equipDict];
                //===
                //                                                                                     [equipmentsArray addObjectsFromArray:[[exArr objectAtIndex:j] objectForKey:@"Equipments"]];
            }
        }
    }
    NSArray *equipArr = [equipmentsArray valueForKeyPath:@"@distinctUnionOfObjects.equipments"];
    uniqueequipmentsArray = [[NSMutableArray alloc]init];

    for (int i =0; i<equipArr.count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(equipments == %@)",equipArr[i] ];
        NSArray *filteredArray = [equipmentsArray filteredArrayUsingPredicate:predicate];
        
        [uniqueequipmentsArray addObject:[filteredArray objectAtIndex:0]];
    }
    //                                                                         uniqueequipmentsArray = [equipmentsArray valueForKeyPath:@"@distinctUnionOfObjects.equipments"];
    NSLog(@"==%@",uniqueequipmentsArray);
    
    if (![Utility isEmptyCheck:uniqueequipmentsArray] && uniqueequipmentsArray.count > 0) {
        [collection reloadData];
        colletionView.hidden = false;
        colletionLableHeightConstant.constant = 28;
        //                                                                             equipmentReqLabel.text = @"Equipment Required:\n";
        //                                                                             equipmentReqLabel.text = [equipmentReqLabel.text stringByAppendingFormat:@"\u2022 %@", [uniqueequipmentsArray componentsJoinedByString:@"\n\u2022"]];
    } else {
        //                                                                             equipmentReqLabel.text = @"No Equipment Required";
        collectionHeightConstant.constant = 0;
        colletionLableHeightConstant.constant = 0;
        colletionView.hidden = true;
    }
    //end
    
    
    if (![Utility isEmptyCheck:exerciseDetailsDict] && exerciseDetailsDict.count > 0) {
        exerciseDetailsArray = [exerciseDetailsDict objectForKey:@"Exercises"];
        
    }else{
        exerciseDetailsArray = [[NSArray alloc]init];
    }
    //////saugata///////
    NSMutableArray *superSetPositionArray = [[NSMutableArray alloc]initWithArray:exerciseDetailsArray];
    NSMutableArray *tempCircuitSupersetArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < superSetPositionArray.count; i++) {
        NSMutableDictionary *supersetDict = [[superSetPositionArray objectAtIndex:i] mutableCopy];
        if ([[supersetDict objectForKey:@"IsSuperSet"] intValue] > 0) {
            [tempCircuitSupersetArray addObject:[[NSDictionary alloc]initWithObjectsAndKeys:supersetDict,@"value",[NSNumber numberWithInteger:i],@"key", nil]];
            
        }
    }
    
    if (tempCircuitSupersetArray.count > 0) {
        NSMutableArray *cSSGrpArray = [[NSMutableArray alloc]init];
        
        NSMutableArray *ctemp = [[NSMutableArray alloc]init];
        for (int k=0; k<tempCircuitSupersetArray.count; k++) {
            NSDictionary *cSupersetKeyValueDict =[tempCircuitSupersetArray objectAtIndex:k];
            NSMutableDictionary *cDataDict = [[cSupersetKeyValueDict objectForKey:@"value"] mutableCopy];
            switch ([[cDataDict objectForKey:@"SuperSetPosition"] intValue]) {
                case -1:
                    ctemp = [[NSMutableArray alloc]init];
                    [ctemp addObject:cSupersetKeyValueDict];
                    break;
                    
                case 0:
                    [ctemp addObject:cSupersetKeyValueDict];
                    break;
                    
                case 1:
                {
                    [ctemp addObject:cSupersetKeyValueDict];
                    [cSSGrpArray addObject:ctemp];
                    ctemp = [[NSMutableArray alloc]init];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
        for (NSArray *array in cSSGrpArray) {
            if (array.count > 0) {
                int cssCount = floorf(array.count/2);
                NSDictionary *cSupersetKeyValueDict =[array objectAtIndex:cssCount];
                NSMutableDictionary *cDataDict = [[cSupersetKeyValueDict objectForKey:@"value"] mutableCopy];
                [cDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"isMiddle"];
                [superSetPositionArray replaceObjectAtIndex:[[cSupersetKeyValueDict objectForKey:@"key"] intValue] withObject:cDataDict];
            }
        }
    }
    
    if (![Utility isEmptyCheck:superSetPositionArray]) {
        for (int i = 0; i < superSetPositionArray.count; i++) {
            NSMutableDictionary *supersetDict = [[NSMutableDictionary alloc]initWithDictionary:[superSetPositionArray objectAtIndex:i]];
            
            NSMutableArray *exerciseArr ;
            if (![Utility isEmptyCheck:[supersetDict objectForKey:@"CircuitExercises"]] && [[supersetDict objectForKey:@"CircuitExercises"] isKindOfClass:[NSArray class]])
                exerciseArr = [[NSMutableArray alloc]initWithArray:[supersetDict objectForKey:@"CircuitExercises"]];
            NSMutableArray *tempExerciseSupersetArray = [[NSMutableArray alloc]init];
            
            for (int j = 0; j < exerciseArr.count; j++) {
                NSMutableDictionary *exerciseDict = [[NSMutableDictionary alloc]initWithDictionary:[exerciseArr objectAtIndex:j]];
                
                if ([[[exerciseArr objectAtIndex:j] objectForKey:@"IsSuperSet"] intValue] > 0) {
                    [tempExerciseSupersetArray addObject:[[NSDictionary alloc]initWithObjectsAndKeys:exerciseDict,@"value",[NSNumber numberWithInteger:j],@"key", nil]];
                }
            }
            if (tempExerciseSupersetArray.count > 0) {
                NSMutableArray *eSSGrpArray = [[NSMutableArray alloc]init];
                
                NSMutableArray *temp = [[NSMutableArray alloc]init];
                for (int k=0; k<tempExerciseSupersetArray.count; k++) {
                    NSDictionary *eSupersetKeyValueDict =[tempExerciseSupersetArray objectAtIndex:k];
                    NSMutableDictionary *eDataDict = [[eSupersetKeyValueDict objectForKey:@"value"] mutableCopy];
                    switch ([[eDataDict objectForKey:@"SuperSetPosition"] intValue]) {
                        case -1:
                            temp = [[NSMutableArray alloc]init];
                            [temp addObject:eSupersetKeyValueDict];
                            break;
                            
                        case 0:
                            [temp addObject:eSupersetKeyValueDict];
                            break;
                            
                        case 1:
                        {
                            [temp addObject:eSupersetKeyValueDict];
                            [eSSGrpArray addObject:temp];
                            temp = [[NSMutableArray alloc]init];
                            
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                for (NSArray *array in eSSGrpArray) {
                    if (array.count > 0) {
                        int essCount = floorf(array.count/2);
                        NSDictionary *eSupersetKeyValueDict =[array objectAtIndex:essCount];
                        NSMutableDictionary *eDataDict = [[eSupersetKeyValueDict objectForKey:@"value"] mutableCopy];
                        [eDataDict setObject:[NSNumber numberWithBool:YES] forKey:@"isMiddle"];
                        [exerciseArr replaceObjectAtIndex:[[eSupersetKeyValueDict objectForKey:@"key"] intValue] withObject:eDataDict];
                        
                    }
                }
                [supersetDict setObject:exerciseArr forKey:@"CircuitExercises"];
                [superSetPositionArray replaceObjectAtIndex:i withObject:supersetDict];
                
            }
            
            
        }
    }
    exerciseDetailsArray =superSetPositionArray;
    /////saugata///////
    [table reloadData];
    
}

-(void)addUpdateDB{
    if (![Utility isSubscribedUser]){
        return;
    }
    
    if(![fromWhere isEqualToString:@"customSession"] && ![fromWhere isEqualToString:@"DailyWorkout"]) return;
    
   NSString *detailsString = @"";
    
    if(exerciseDetailsDict.count>0){
        NSError *error;
        NSData *detailsData = [NSJSONSerialization dataWithJSONObject:exerciseDetailsDict options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        
        detailsString = [[NSString alloc] initWithData:detailsData encoding:NSUTF8StringEncoding];
    }
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    NSMutableDictionary *saveIdsDict = [[NSMutableDictionary alloc]init];
    [saveIdsDict setObject:[NSNumber numberWithInt:_exSessionId] forKey:@"exSessionId"];
    [saveIdsDict setObject:([fromWhere isEqualToString:@"DailyWorkout"])?[NSNumber numberWithInt:0]:[NSNumber numberWithInt:1] forKey:@"isCustom"];
    [saveIdsDict setObject:([fromWhere isEqualToString:@"DailyWorkout"])?[NSNumber numberWithInt:completeSessionId]:[NSNumber numberWithInt:workoutTypeId] forKey:@"completeId"];
    
    [saveIdsDict setObject:(![Utility isEmptyCheck:weekDate])?weekDate:@"" forKey:@"weekStartDate"];
    [saveIdsDict setObject:(![Utility isEmptyCheck:_sessionDate])?_sessionDate:@"" forKey:@"sessionDate"];
    
    if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]]){
        
        [DBQuery updateExerciseDetails:detailsString sessionId:_exSessionId];
    }else{
        [DBQuery addExerciseDetails:detailsString saveIdsDict:saveIdsDict];
        
    }
}

-(void)getOfflineData{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"exerciseDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"exerciseDetails"]]){
                    NSString *str = arr[0][@"exerciseDetails"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *equipmentList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(equipmentList){
                        exerciseDetailsDict = equipmentList;
                    }
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [self setupExerciseView];
                });
            }else{
                
                arr = [dbObject selectBy:@"exerciseTypeDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"equipmentList",@"equipmentDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]];
                
                if(arr.count>0){
                    
                    if(![Utility isEmptyCheck:arr[0][@"equipmentDetails"]]){
                        NSString *str = arr[0][@"equipmentDetails"];
                        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                        NSArray *detailsArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        
                        if(detailsArray){
                            exerciseDetailsDict = detailsArray[0];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(),^ {
                        [self setupExerciseView];
                    });
                }
            }
            
            [dbObject connectionEnd];
        }
    }else{
        [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:YES];
    }
    
}
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [delegate didCheckAnyChange:isChanged];
        }
        [self backButtonPressed:nil];
    }
}
#pragma mark -End

#pragma mark -APICall
-(void)getExerciseDetails{
    //    if (contentView) {
    //        [contentView removeFromSuperview];
    //    }
    //    NSString* filepath = [[NSBundle mainBundle]pathForResource:@"GetWorkoutDetails" ofType:@"json"];
    //    NSData *data = [NSData dataWithContentsOfFile:filepath];
    //    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    //    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
    //        NSDictionary *exerciseDetailsDict =[responseDictionary objectForKey:@"obj"];
    //
    //        if (![Utility isEmptyCheck:exerciseDetailsDict] && exerciseDetailsDict.count > 0) {
    //            exerciseDetailsArray = [exerciseDetailsDict objectForKey:@"Exercises"];
    //        }else{
    //            exerciseDetailsArray = [[NSArray alloc]init];
    //        }
    //        [table reloadData];
    //    }else{
    //        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
    //        return;
    //    }
    //    selectedSection = (int)exerciseDetailsArray.count-1;
    
    
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];//@"3269"
        //NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetWorkoutDetailsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&ExerciseSessionId=%d&personalisedOne=%@",[defaults objectForKey:@"UserID"],_exSessionId,[[exerciseData objectForKey:@"IsPersonalisedSession"] boolValue]? @"true" : @"false"] forAction:@"GET"];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetWorkoutDetailsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&ExerciseSessionId=%d&personalisedOne=%@",[defaults objectForKey:@"ABBBCOnlineUserId"],_exSessionId,[[exerciseData objectForKey:@"IsPersonalisedSession"] boolValue]? @"true" : @"false"] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         exerciseDetailsDict =[responseDictionary objectForKey:@"obj"];
                                                                         [self addUpdateDB];
                                                                         [self setupExerciseView]; //AY 21022018
                                                                         
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self getOfflineData];
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}

-(void)saveEditedExercisesFromButton:(NSString *)buttonName{    //ah31
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:editSessionDictionary options:NSJSONWritingPrettyPrinted  error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLSession *editUrlSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"QuickEditDailySession" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[editUrlSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (contentView) {
                                                                       [contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                           _exSessionId = [[responseDictionary objectForKey:@"ExerciseSessionId"] intValue];
                                                                           [self getExerciseDetails];
                                                                           //                                                                         if ([buttonName isEqualToString:@"save"]) {
                                                                           //                                                                             [Utility msg:@"Saved Successfully." title:@"Success !" controller:self haveToPop:NO];
                                                                           //                                                                             saveButton.hidden = true;
                                                                           //                                                                             playButton.hidden = false;
                                                                           //                                                                         } else {
                                                                           //                                                                             [self showAlert];
                                                                           //                                                                         }
                                                                       }else{
                                                                           
                                                                           [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

-(void)getExerciseList {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];   //ah 17
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:@"" forKey:@"SearchText"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSURLSession *exListUrlSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetExercises" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[exListUrlSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     if (contentView) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [exerciseListArray removeAllObjects];
                                                                             [exerciseListArray addObjectsFromArray:[responseDictionary objectForKey:@"Exercises"]];
                                                                             [self openPicker:self ForEditing:@"ex"];
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

-(void) getCktList {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *exListUrlSession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetCircuits" append:[NSString stringWithFormat:@"%@",[defaults objectForKey:@"ABBBCOnlineUserId"]] forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[exListUrlSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     if (contentView) {
                                                                         [contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [cktListArray removeAllObjects];
                                                                             [cktListArray addObjectsFromArray:[responseDictionary objectForKey:@"obj"]];
                                                                             [self openPicker:self ForEditing:@"ckt"];
                                                                         }else{
                                                                             [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

 //18may2018
-(void)webserviceCall_FavoriteSessionToggle{ //add5
    if (Utility.reachable && ![Utility isOfflineMode]) {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[exerciseDetailsDict objectForKey:@"ExerciseSessionId"] forKey:@"SessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionToggle" append:@""forAction:@"POST"];
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
                                                                            isChanged = true;
                                                                            [self getExerciseDetails];
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneNFavourite:YES];// AY 07032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
} //18may2018

//18may2018
-(void)offlineSessionDoneNFavourite:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
//    int sessionId = [[exerciseDetailsDict objectForKey:@"ExerciseSessionId"]intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString *weekStartDateStr = [formatter stringFromDate:weekstart];
    
     if([DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"exerciseDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]];

            if(arr.count>0){
                NSMutableDictionary *exerciseDetailsMutableDict = [[NSMutableDictionary alloc]init];
                isChanged = true;
                if(![Utility isEmptyCheck:arr[0][@"exerciseDetails"]]){
                    NSString *str = arr[0][@"exerciseDetails"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    exerciseDetailsMutableDict = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]mutableCopy];
                    
                    if (![Utility isEmptyCheck:exerciseDetailsMutableDict]) {
                        BOOL IsFavorite = [exerciseDetailsDict[@"IsFavourite"] boolValue];
                        [exerciseDetailsMutableDict removeObjectForKey:@"IsFavourite"];
                        [exerciseDetailsMutableDict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavourite"];
                    }else{
                        return;
                    }
             
                NSString *exDetailsStr = @"";
                    
                if(![Utility isEmptyCheck:exerciseDetailsMutableDict]){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:exerciseDetailsMutableDict options:NSJSONWritingPrettyPrinted  error:&error];
                    if (error) {
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    exDetailsStr = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:exDetailsStr];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseDetails",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,date, nil];
                    
                    if([dbObject updateWithCondition:@"exerciseDetails" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionId]]){
                        
                        [self getOfflineData];
                    }
                }
                [dbObject connectionEnd];
                }
            }
        }
         if ([fromWhere isEqualToString:@"DailyWorkout"]) {
             [self offlineDailyWorkoutDone:YES];
         }else{
             [self offlineCustomWorkoutDone:YES];
         }
     }
}

-(void)offlineDailyWorkoutDone:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    //    int sessionId = [[exerciseDetailsDict objectForKey:@"ExerciseSessionId"]intValue];
    int sessionId = _exSessionId;
    
    if([DBQuery isRowExist:@"dailyworkout" condition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
        isChanged = true;
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"dailyworkout" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"dailyWorkoutList",@"favSessionList",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]];
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"favSessionList"]]){
                    NSString *str = arr[0][@"favSessionList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionId == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        int sessionCount = [dict[@"SessionCount"]intValue];
                        //                        if(sessionCount>0 && isFav){
                        if(isFav){
                            BOOL IsFavorite = [dict[@"IsFavorite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            sessionCount++;
                            [dict setObject:[NSNumber numberWithInt:sessionCount] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                        
                    }else{
                        if(!isFav){
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                            [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                            [favArray addObject:dict];
                        }else{
                            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                            [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavorite"];
                            [dict setObject:[NSNumber numberWithInt:0] forKey:@"SessionCount"];
                            [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsCountDone"];
                            [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                            [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                            [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavDone"];
                            [favArray addObject:dict];
                        }
                    }
                }else{
                    if(!isFav){
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsFavorite"];
                        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SessionCount"];
                        [dict setObject:[NSNumber numberWithBool:true] forKey:@"isDone"];
                        [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                        [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                        [favArray addObject:dict];
                    }else{
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                        [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavorite"];
                        [dict setObject:[NSNumber numberWithInt:0] forKey:@"SessionCount"];
                        [dict setObject:[NSNumber numberWithBool:false] forKey:@"IsCountDone"];
                        [dict setObject:[NSNumber numberWithInt:userId] forKey:@"UserId"];
                        [dict setObject:[NSNumber numberWithInt:sessionId] forKey:@"SessionId"];
                        [dict setObject:[NSNumber numberWithBool:isFav] forKey:@"IsFavDone"];
                        [favArray addObject:dict];
                    }
                    
                }
                
                if(favArray.count<=0){
                    return;
                }
                NSString *favString = @"";
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])]; //AY 07032018
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"favSessionList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    if([dbObject updateWithCondition:@"dailyworkout" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d'",userId]]){
                        
                        //                        [self getOfflineData];
                    }
                }
                [dbObject connectionEnd];
            }
        }
    }
}

-(void)offlineCustomWorkoutDone:(BOOL)isFav{
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    int sessionId = workoutTypeId;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:weekDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *weekStartDateStr = [formatter stringFromDate:date];
    
    
    if([DBQuery isRowExist:@"customExerciseList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
        isChanged = true;
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"customExerciseList" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseList",@"joiningDate",@"weekStartDate",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]];
            
            if(arr.count>0){
                NSMutableArray *favArray = [[NSMutableArray alloc]init];
                if(![Utility isEmptyCheck:arr[0][@"exerciseList"]]){
                    NSString *str = arr[0][@"exerciseList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    favArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                    
                    NSArray *filterarray = [favArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Id == %d)", sessionId]];
                    if(filterarray.count>0){
                        NSInteger objectIndex= [favArray indexOfObject:filterarray[0]];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:filterarray[0]];
                        BOOL isDone = [dict[@"IsDone"]boolValue];
                        
                        //                        if(isDone && isFav){//18may2018
                        if(isFav){
                            BOOL IsFavorite = [dict[@"IsFavourite"] boolValue];
                            [dict setObject:[NSNumber numberWithBool:!IsFavorite] forKey:@"IsFavourite"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsFavDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }else if(!isFav){
                            [dict setObject:[NSNumber numberWithBool:!isDone] forKey:@"IsDone"];
                            [dict setObject:[NSNumber numberWithBool:true] forKey:@"IsCountDone"];
                            [favArray replaceObjectAtIndex:objectIndex withObject:dict];
                        }
                    }
                }
                
                if(favArray.count<=0){
                    return;
                }
                NSString *favString = @"";
                if(favArray.count>0){
                    NSError *error;
                    NSData *favData = [NSJSONSerialization dataWithJSONObject:favArray options:NSJSONWritingPrettyPrinted  error:&error];
                    
                    if (error) {
                        
                        NSLog(@"Error Favorite Array-%@",error.debugDescription);
                    }
                    
                    favString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
                }
                
                NSMutableString *modifiedExList = [NSMutableString stringWithString:favString];
                [modifiedExList replaceOccurrencesOfString:@"'" withString:@"''" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [modifiedExList length])];
                
                if([dbObject connectionStart]){
                    
                    NSString *date = [NSDate date].description;
                    NSArray *columnArray = [[NSArray alloc]initWithObjects:@"exerciseList",@"isSync",@"lastUpdate",nil];
                    NSArray *valuesArray = [[NSArray alloc]initWithObjects:modifiedExList,[NSNumber numberWithInt:0],date, nil];
                    
                    if([dbObject updateWithCondition:@"customExerciseList" withColumn:columnArray forValue:valuesArray conditionString:[@"" stringByAppendingFormat:@"UserId ='%d' and weekStartDate = '%@'",userId,weekStartDateStr]]){
                        
//                        [self getOfflineData];
                    }
                }
                [dbObject connectionEnd];
            }
        }
    }
}
 //18may2018
//add custom api's
-(void)getWorkoutSessionsFromDate:(NSString *)fromDate today:(BOOL)today{
    
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:fromDate forKey:@"SessionDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetWorkoutSessionsFromDate" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         if (![Utility isEmptyCheck:responseDict[@"WorkoutSessionList"]]) {
                                                                             NSArray *temp = responseDict[@"WorkoutSessionList"];
                                                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ExerciseSessionId == %@)",[self->exerciseDetailsDict objectForKey:@"ExerciseSessionId"]];
                                                                             temp = [temp filteredArrayUsingPredicate:predicate];
                                                                             NSString *myMsg;
                                                                             if (today) {
                                                                                 myMsg = @"You already have this session in your today's custom plan.";
                                                                             } else {
                                                                                 myMsg = @"You already have this session in your selected day custom plan.";
                                                                             }
                                                                             if (temp.count>0) {
                                                                                 //existing
                                                                                 [Utility msg:myMsg title:@"" controller:self haveToPop:NO];
                                                                             } else {
                                                                                 temp = responseDict[@"WorkoutSessionList"];
                                                                                 if (temp.count<2) {
                                                                                     //add
                                                                                     [self addSwapCustomSession:fromDate swap:NO workoutId:@-1];
                                                                                 }else{
                                                                                     //swap
                                                                                     SwapSessionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SwapSessionViewController"];
                                                                                     controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                                     controller.sessionArray = temp;
                                                                                     controller.swapDate = fromDate;
                                                                                     controller.delegate = self;
                                                                                     [self presentViewController:controller animated:YES completion:nil];
                                                                                 }
                                                                             }
                                                                             
                                                                         } else {
                                                                             //add
                                                                             [self addSwapCustomSession:fromDate swap:NO workoutId:@-1];
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneNFavourite:YES];// AY 07032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
    
}
-(void)addSwapCustomSession:(NSString *)fromDate swap:(BOOL)swap workoutId:(NSNumber *)workoutId{
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:fromDate forKey:@"SessionDate"];
        [mainDict setObject:[exerciseDetailsDict objectForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        if (swap) {
            [mainDict setObject:workoutId forKey:@"WorkoutId"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSwapCustomSession" append:@""forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         self->isChanged = true;
                                                                         if (swap) {
                                                                             self->workoutTypeId = [workoutId intValue];
                                                                             [Utility msg:@"Session swaped successfully" title:@"" controller:self haveToPop:NO];
                                                                         } else {
                                                                             self->workoutTypeId = [responseDict[@"NewId"] intValue];
                                                                             [Utility msg:@"Session added successfully" title:@"" controller:self haveToPop:NO];
                                                                         }
                                                                         
                                                                         
                                                                         self->isAddedToCustomSession = true;
                                                                         
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
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self offlineSessionDoneNFavourite:YES];// AY 07032018
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}
-(void) checkStepNumberForSetupWithAPI:(NSString *)apiName sender:(UIButton *)sender{
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
                                                                          int stepNumber = [[responseDict objectForKey:@"StepNumber"] intValue];
                                                                          if (stepNumber == 0) {
                                                                              [self addOrViewSession:sender];
                                                                          }else{
                                                                              
                                                                              UIAlertController * alert = [UIAlertController
                                                                                                           alertControllerWithTitle:@""
                                                                                                           message:@"You have not completed the exercise settings, complete the settings to use this feature. Do you want to complete it now ?"
                                                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                                                              
                                                                              UIAlertAction* ok = [UIAlertAction
                                                                                                   actionWithTitle:@"Yes"
                                                                                                   style:UIAlertActionStyleDefault
                                                                                                   handler:^(UIAlertAction * action) {
                                                                                                       switch ([[responseDict objectForKey:@"StepNumber"] intValue]) {
                                                                                                               
                                                                                                           case -1:
                                                                                                               //api call
                                                                                                               [self checkStepNumberForSetupWithAPI:@"CheckUserProgramStep" sender:sender];
                                                                                                               break;
                                                                                                               
                                                                                                               //                                                                              case 0:
                                                                                                               //                                                                              {
                                                                                                               //                                                                                  [self addOrViewSession:sender];
                                                                                                               //                                                                                  break;
                                                                                                               //                                                                                  ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
                                                                                                               //                                                                                  [self.navigationController pushViewController:controller animated:YES];
                                                                                                               //                                                                                  break;
                                                                                                               //                                                                              }
                                                                                                               
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
                                                                                                   }];
                                                                              
                                                                              UIAlertAction* cancel = [UIAlertAction
                                                                                                       actionWithTitle:@"No"
                                                                                                       style:UIAlertActionStyleCancel
                                                                                                       handler:^(UIAlertAction * action) {
                                                                                                           
                                                                                                       }];
                                                                              
                                                                              [alert addAction:ok];
                                                                              [alert addAction:cancel];
                                                                              
                                                                              [self presentViewController:alert animated:YES completion:nil];
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

#pragma mark - CollectionView DataSource and Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return uniqueequipmentsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ExerciseCollectionViewCell";
    
    ExerciseCollectionViewCell *cell = (ExerciseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.equipmentLabel.text = [[uniqueequipmentsArray objectAtIndex:indexPath.row]objectForKey:@"equipments"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [uniqueequipmentsArray objectAtIndex:indexPath.row];
    int row = [[dict objectForKey:@"row"]intValue];
    int section = [[dict objectForKey:@"section"]intValue];
   
    NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    CGRect myRect = [table rectForRowAtIndexPath:rowIndexPath];
    [table setNeedsLayout];
    [table layoutIfNeeded];
    CGPoint bottomOffset = CGPointMake(table.frame.origin.x+myRect.origin.x, table.frame.origin.y+myRect.origin.y);
//    NSLog(@"%f = %f",bottomOffset.x,bottomOffset.y);
    
    ExerciseDetailsTableViewCell *cell = (ExerciseDetailsTableViewCell *)[table cellForRowAtIndexPath:rowIndexPath];
    cell.mainViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width - 90;
    NSLog(@"%f",[[UIScreen mainScreen] bounds].size.width);
    [cell needsUpdateConstraints];
    [scroll setContentOffset:bottomOffset animated:YES];
}

#pragma mark - End

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (![fromWhere isEqualToString:@"DailyWorkout"]){
//        return 70;
//    }else{
//        return 0;
//    }
//}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ExerciseDetailHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:section];
    if (section == 0) {
        sectionHeaderView.superCircuitName.text = @"WARM UP";
    }else if (section == 1) {
        sectionHeaderView.superCircuitName.text = @"MAIN SESSION";
    }
    else if(section > 1){
        sectionHeaderView.superCircuitName.text = @"";
    }
    NSString *circuitName = [circuitDict objectForKey:@"Name"];
    if (![Utility isEmptyCheck:circuitName]) {
        sectionHeaderView.circuitName.text = circuitName;
    }
    
    sectionHeaderView.circuitReps.text = @"acv";
    sectionHeaderView.circuitReps.hidden = false;
    
    sectionHeaderView.circuitSets.text = @"sdwd sdwd sdwd sdwd sdwd sdwd v sdwdsdwdsdwd sdwdsdwdsdwdsdwdsdwdsdwd";
    sectionHeaderView.circuitSets.hidden = false;
    
    
    sectionHeaderView.circuitNumber.text = [@"" stringByAppendingFormat:@"%ld.",section];
    sectionHeaderView.expandCollapseButton.tag = section;
    [sectionHeaderView.expandCollapseButton addTarget:self
                                               action:@selector(sectionExpandCollapse:)
                                     forControlEvents:UIControlEventTouchUpInside];
    
    //superSet
    if ([[circuitDict objectForKey:@"IsSuperSet"] intValue] >= 1) {
        sectionHeaderView.setMainView.hidden = false;
        sectionHeaderView.setCountLabel.hidden = YES;
        if ([[circuitDict objectForKey:@"SuperSetPosition"] intValue] == -1) {
            //first
            sectionHeaderView.setUpperView.hidden = YES;
            sectionHeaderView.setMiddleView.hidden = NO;
            sectionHeaderView.setLowerView.hidden = NO;
            
            if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
            }else{
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x %@ sets",[[circuitDict objectForKey:@"SetCount"] stringValue]];
            }
            
            sectionHeaderView.setCountLabel.hidden = NO;
            sectionHeaderView.setCountLabel.textColor = [UIColor whiteColor];
        } else if ([[circuitDict objectForKey:@"SuperSetPosition"] intValue] == 0) {
            //middle
            sectionHeaderView.setUpperView.hidden = NO;
            sectionHeaderView.setMiddleView.hidden = YES;
            sectionHeaderView.setLowerView.hidden = NO;
            if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
            }else{
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x %@ sets",[[circuitDict objectForKey:@"SetCount"] stringValue]];
            }
            sectionHeaderView.setCountLabel.hidden = NO;
            sectionHeaderView.setCountLabel.textColor = [UIColor whiteColor];
        } else if ([[circuitDict objectForKey:@"SuperSetPosition"] intValue] == 1) {
            //third
            sectionHeaderView.setUpperView.hidden = NO;
            sectionHeaderView.setMiddleView.hidden = NO;
            sectionHeaderView.setLowerView.hidden = YES;
            if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
            }else{
                sectionHeaderView.setCountLabel.text = [NSString stringWithFormat:@"x %@ sets",[[circuitDict objectForKey:@"SetCount"] stringValue]];
            }
            sectionHeaderView.setCountLabel.hidden = NO;
            sectionHeaderView.setCountLabel.textColor = [UIColor whiteColor];
            
        }
        if ([[circuitDict objectForKey:@"isMiddle"] boolValue]) {
            sectionHeaderView.setCountLabel.textColor = [UIColor grayColor];
        }else{
            sectionHeaderView.setCountLabel.textColor = [UIColor clearColor];
        }
    } else {
        sectionHeaderView.setMainView.hidden = YES;
        sectionHeaderView.setCountLabel.hidden = YES;
    }
    if (![[circuitDict objectForKey:@"IsCircuit"] boolValue]) {
        NSString *reps = [@"" stringByAppendingFormat:@"%d",[[circuitDict valueForKey:@"ExerciseRepGoal"] intValue]];
        if (![Utility isEmptyCheck:reps]) {
            if ([[circuitDict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                sectionHeaderView.repsCountLabel.hidden = false;
                
            } else if ([[circuitDict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                sectionHeaderView.repsCountLabel.hidden = false;
                
            } else if ([[circuitDict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                sectionHeaderView.repsCountLabel.hidden = false;
                //ah 1.2
            } else if ([[circuitDict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Minutes"] == NSOrderedSame) {
                sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" mins" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                sectionHeaderView.repsCountLabel.hidden = false;
                //ah 8.51
            } else {
                sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                sectionHeaderView.repsCountLabel.hidden = false;
            }
            NSString *sets = [@"" stringByAppendingFormat:@"%d",[[circuitDict valueForKey:@"SetCount"] intValue]];
            if (![Utility isEmptyCheck:sets] && [[circuitDict objectForKey:@"IsSuperSet"] intValue] == 0) {
                
                sectionHeaderView.repsCountLabel.hidden = false;
                if (![Utility isEmptyCheck:sectionHeaderView.repsCountLabel.attributedText]) {
                    NSAttributedString *setsAttrString =[Utility getStringWithHeader:[NSString stringWithFormat:@"  X %@",(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER)?@"∞":sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    NSMutableAttributedString* result = [sectionHeaderView.repsCountLabel.attributedText mutableCopy];
                    [result appendAttributedString:setsAttrString];
                    sectionHeaderView.repsCountLabel.attributedText =result;
                    
                }else{
                    sectionHeaderView.repsCountLabel.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                }
                
            }
            
        }else{
            sectionHeaderView.repsCountLabel.text = @"";
            sectionHeaderView.repsCountLabel.hidden = true;
        }
    }else{
        sectionHeaderView.repsCountLabel.text = @"";
        sectionHeaderView.repsCountLabel.hidden = true;
    }
    
    
    
    if (section == selectedSection && selectedIndex== -1) {
        [sectionHeaderView.outerStackView insertArrangedSubview:sectionHeaderView.circuitDetailsView atIndex:sectionHeaderView.outerStackView.arrangedSubviews.count];
        
        if (![[circuitDict objectForKey:@"IsCircuit"] boolValue]) {
            NSArray *instructions = [circuitDict objectForKey:@"Instructions"];
            if (![Utility isEmptyCheck:instructions] && instructions.count > 0) {
                sectionHeaderView.instructionLabel.text = [@"" stringByAppendingFormat:@"%@",[instructions componentsJoinedByString:@"\n"]];
                sectionHeaderView.instructionLabel.font = [UIFont fontWithName:@"Roboto-Light" size:15];
                sectionHeaderView.instructionLabelStackView.hidden = false;
                
            }else{
                sectionHeaderView.instructionLabel.text = @"";
                sectionHeaderView.instructionLabelStackView.hidden = true;
            }
            NSArray *tips = [circuitDict objectForKey:@"Tips"];
            if (![Utility isEmptyCheck:tips] && tips.count > 0) {
                sectionHeaderView.tipsLabel.attributedText  = [Utility getStringWithHeader:@"Tips : \n" headerFont:[UIFont fontWithName:@"Roboto-Regular" size:15] headerColor:[UIColor blackColor] bodyString:[@"" stringByAppendingFormat:@"\u2022  %@",[tips componentsJoinedByString:@"\n\u2022  "] ] bodyFont:[UIFont fontWithName:@"Roboto-Light" size:15] BodyColor:[UIColor blackColor]];
                sectionHeaderView.tipsLabelStackView.hidden = false;
                
            }else{
                sectionHeaderView.tipsLabel.text = @"";
                sectionHeaderView.tipsLabelStackView.hidden = true;
            }
        }else{
            sectionHeaderView.instructionLabel.text = @"";
            sectionHeaderView.tipsLabel.text = @"";
            
            sectionHeaderView.instructionLabelStackView.hidden = true;
            sectionHeaderView.tipsLabelStackView.hidden = true;
        }
        
        
        
        /////////////////////saugata
        NSArray *equipments = [circuitDict objectForKey:@"Equipments"];
        if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
            sectionHeaderView.equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
            sectionHeaderView.equipmentRequiredStackView.hidden = false;
            
        }else{
            sectionHeaderView.equipmentRequiredStackView.hidden = true;
        }
        
        
        //ah 17
        for (UIView *view in sectionHeaderView.equipmentBasedAlternativesButtonStackView.arrangedSubviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [sectionHeaderView.equipmentBasedAlternativesButtonStackView removeArrangedSubview:view] ;
                [view removeFromSuperview];
            }
        }
        NSArray *substituteEquipments = [circuitDict objectForKey:@"SubstituteExercises"];
        if (substituteEquipments.count > 0) {
            for (int i=0; i<substituteEquipments.count; i++) {
                NSDictionary *substituteExercisesDict = [substituteEquipments objectAtIndex:i];
                if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseId"]]) {
                        [button addTarget:self
                                   action:@selector(substituteExercisesButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
                        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                        [button setAttributedTitle:titleString forState:UIControlStateNormal];
                        button.tag =[[substituteExercisesDict objectForKey:@"SubstituteExerciseId"] integerValue];
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }else{
                        
                        [button setTitle:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] forState:UIControlStateNormal];
                        
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    [sectionHeaderView.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];
                    
                }
            }
            sectionHeaderView.equipmentBasedAlternativesStackView.hidden = false;
            
        }else{
            sectionHeaderView.equipmentBasedAlternativesStackView.hidden = true;
        }
        
        for (UIView *view in sectionHeaderView.bodyWeightAlternativesButtonStackView.arrangedSubviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [sectionHeaderView.bodyWeightAlternativesButtonStackView removeArrangedSubview:view] ;
                [view removeFromSuperview];
            }
        }
        NSArray *AltBodyWeightExercises = [circuitDict objectForKey:@"AltBodyWeightExercises"];
        if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
            for (int i=0; i<AltBodyWeightExercises.count; i++) {
                NSDictionary *altBodyWeightExercisesDict = [AltBodyWeightExercises objectAtIndex:i];
                if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"]]) {
                        [button addTarget:self
                                   action:@selector(substituteExercisesButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
                        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                        [button setAttributedTitle:titleString forState:UIControlStateNormal];
                        button.tag =[[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"] integerValue];
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }else{
                        
                        [button setTitle:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] forState:UIControlStateNormal];
                        
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    [sectionHeaderView.bodyWeightAlternativesButtonStackView addArrangedSubview:button];
                    
                }
            }
            sectionHeaderView.bodyWeightAlternativesStackView.hidden = false;
        }else{
            sectionHeaderView.bodyWeightAlternativesStackView.hidden = true;
        }
        
        if (selectedHeaderView.playerController.player) {
            [selectedHeaderView.playerController.player pause];
            [player pause];
            player = nil;
            [selectedHeaderView.playerController removeFromParentViewController];
        }
        if (sectionHeaderView.playerController.player) {
            [sectionHeaderView.playerController.player pause];
            [player pause];
            player = nil;
            [sectionHeaderView.playerController removeFromParentViewController];
        }
        NSString  *videoUrlString = [circuitDict objectForKey:@"VideoUrlPublic"];
        NSArray *photoList = [circuitDict objectForKey:@"PhotoList"];
        
        [sectionHeaderView.circuitDetailsStackView removeArrangedSubview:sectionHeaderView.playerContainer];
        [sectionHeaderView.playerContainer removeFromSuperview];
        if ((![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) || ![Utility isEmptyCheck:videoUrlString]) {
            [sectionHeaderView.circuitDetailsStackView insertArrangedSubview:sectionHeaderView.playerContainer atIndex:3];
            if (![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) {
                [sectionHeaderView.exerciseImageView sd_setImageWithURL:[NSURL URLWithString:[photoList objectAtIndex:0]]
                                                       placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
                sectionHeaderView.exerciseImageView.hidden = false;
                
            }else{
                sectionHeaderView.exerciseImageView.hidden = true;
            }
            
            if (![Utility isEmptyCheck:videoUrlString]) {
                AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
                NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
                player = [AVPlayer playerWithURL:videoUrl];
                //[player play];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = true;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                playerViewController.view.frame = sectionHeaderView.exercisePlayerView.bounds;
                [sectionHeaderView.exercisePlayerView addSubview:playerViewController.view];
                sectionHeaderView.playerController = playerViewController;
                sectionHeaderView.exercisePlayerView.hidden = false;
                
            }else{
                sectionHeaderView.exercisePlayerView.hidden = true;
            }
            [sectionHeaderView.scrollNextButton addTarget:self
                                                   action:@selector(scrollNextButtonTapped1:)
                                         forControlEvents:UIControlEventTouchUpInside];
            [sectionHeaderView.scrollPreviousButton addTarget:self
                                                       action:@selector(scrollPreviousButtonTapped1:)
                                             forControlEvents:UIControlEventTouchUpInside];
            if ([Utility isEmptyCheck:photoList] || photoList.count == 0 || [Utility isEmptyCheck:[photoList objectAtIndex:0]]) {
                sectionHeaderView.exercisePlayerView.hidden = false;
                sectionHeaderView.exerciseImageView.hidden = true;
                sectionHeaderView.scrollNextButton.hidden = YES;
                sectionHeaderView.scrollPreviousButton.hidden = YES;
            }else if([Utility isEmptyCheck:videoUrlString]){
                sectionHeaderView.exercisePlayerView.hidden = true;
                sectionHeaderView.exerciseImageView.hidden = false;
                sectionHeaderView.scrollNextButton.hidden = YES;
                sectionHeaderView.scrollPreviousButton.hidden = YES;
            }else{
                sectionHeaderView.exercisePlayerView.hidden = true;
                sectionHeaderView.exerciseImageView.hidden = false;
                sectionHeaderView.scrollNextButton.hidden = NO;
                sectionHeaderView.scrollPreviousButton.hidden = YES;
            }
            
            selectedHeaderView = sectionHeaderView;
            
        }
        sectionHeaderView.expandCollapseButton.selected = true;
        [sectionHeaderView.dropdownArrowImageView setImage:[UIImage imageNamed:@"dropdown_arrow_top.png"]];
        sectionHeaderView.dropdownWidthConstraint.constant =15;
        sectionHeaderView.dropdownHeightConstraint.constant = 7;
        
    }else{
        if (sectionHeaderView.playerController.player) {
            [sectionHeaderView.playerController.player pause];
            sectionHeaderView.playerController.player = nil;
            [sectionHeaderView.playerController removeFromParentViewController];
        }
        [sectionHeaderView.outerStackView removeArrangedSubview:sectionHeaderView.circuitDetailsView];
        
        [sectionHeaderView.circuitDetailsView removeFromSuperview];
        
        sectionHeaderView.expandCollapseButton.selected = false;
        
        [sectionHeaderView.dropdownArrowImageView setImage:[UIImage imageNamed:@"dropdown_arrow_left.png"]];
        sectionHeaderView.dropdownWidthConstraint.constant = 15;
        sectionHeaderView.dropdownHeightConstraint.constant = 7;
    }
    
    if ([[circuitDict objectForKey:@"IsCircuit"] boolValue]){
        sectionHeaderView.infoButton.hidden = false;
        sectionHeaderView.detailScroll.scrollEnabled = false;
        
    }else{
        sectionHeaderView.infoButton.hidden = true;
        sectionHeaderView.detailScroll.scrollEnabled = true;
    }
    
    
    if ([[circuitDict objectForKey:@"IsCircuit"] boolValue] && selectedInfo == section) {
//        [sectionHeaderView.outerStackView insertArrangedSubview:sectionHeaderView.circuitInstructionTipsContainerStackView atIndex:2];
        [sectionHeaderView.outerStackView addArrangedSubview:sectionHeaderView.circuitInstructionTipsContainerStackView];   //ah 4.5

        NSArray *cktInstructions = [circuitDict objectForKey:@"Instructions"];
        if (![Utility isEmptyCheck:cktInstructions] && cktInstructions.count > 0) {
            sectionHeaderView.circuitInstructionsLabel.text = [@"\u2022  " stringByAppendingString:[cktInstructions componentsJoinedByString:@"\n\u2022  "]];
            [sectionHeaderView.circuitInstructionTipsContainerStackView addArrangedSubview: sectionHeaderView.circuitInstructionsStackView];
        }else{
            [sectionHeaderView.circuitInstructionTipsContainerStackView removeArrangedSubview: sectionHeaderView.circuitInstructionsStackView];
            [sectionHeaderView.circuitInstructionsStackView removeFromSuperview];
            
        }
        NSArray *cktTips = [circuitDict objectForKey:@"Tips"];
        if (![Utility isEmptyCheck:cktTips] && cktTips.count > 0) {
            sectionHeaderView.circuitTipsLabel.text = [@"\u2022  " stringByAppendingString:[cktTips componentsJoinedByString:@"\n\u2022  "]];
            [sectionHeaderView.circuitInstructionTipsContainerStackView addArrangedSubview: sectionHeaderView.circuitTipsStackView];
            
        }else{
            [sectionHeaderView.circuitInstructionTipsContainerStackView removeArrangedSubview: sectionHeaderView.circuitTipsStackView];
            [sectionHeaderView.circuitTipsStackView removeFromSuperview];
        }
        
        
        
        
    }else{
        [sectionHeaderView.outerStackView removeArrangedSubview:sectionHeaderView.circuitInstructionTipsContainerStackView];
        [sectionHeaderView.circuitInstructionTipsContainerStackView removeFromSuperview];
        
    }
    
    
    if ([[circuitDict objectForKey:@"IsCircuit"] boolValue]) {
        NSArray *cktInstructions = [circuitDict objectForKey:@"Instructions"];
        NSArray *cktTips = [circuitDict objectForKey:@"Tips"];
        if ((![Utility isEmptyCheck:cktInstructions] && cktInstructions.count > 0) || (![Utility isEmptyCheck:cktTips] && cktTips.count > 0)) {
            sectionHeaderView.infoButton.hidden = false;
        }else{
            sectionHeaderView.infoButton.hidden = true;
        }
    }
    
    
    
    
    //arnab 17
    sectionHeaderView.leftViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width;
    [sectionHeaderView.headerEditButton addTarget:self
                                           action:@selector(headerEditButtonTapped:)
                                 forControlEvents:UIControlEventTouchUpInside];
    //    sectionHeaderView.detailScroll.delegate = self;
    [sectionHeaderView.headerEditButton setTag:section+10001];
    sectionHeaderView.headerEditButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)section + 10001];
    //end
    
    [sectionHeaderView.infoButton addTarget:self
                                     action:@selector(infoButtonTapped:)
                           forControlEvents:UIControlEventTouchUpInside];
    //    sectionHeaderView.detailScroll.delegate = self;
    [sectionHeaderView.infoButton setTag:section+30001];
    
    return  sectionHeaderView;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (![fromWhere isEqualToString:@"DailyWorkout"]){
//        ExerciseFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionFooterViewIdentifier];
//        sectionFooterView.editSessionButton.tag = section;
//        [sectionFooterView.editSessionButton addTarget:self
//                                                   action:@selector(editSessionButtonPressed:)
//                                         forControlEvents:UIControlEventTouchUpInside];
//        return sectionFooterView;
//    }else{
//        return nil;
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Utility isEmptyCheck:exerciseDetailsArray]) {
        return exerciseDetailsArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:section];
    NSArray *videoDataArray =[circuitDict valueForKey:@"CircuitExercises"];
    if([[circuitDict objectForKey:@"IsCircuit"]boolValue]){
        if (![Utility isEmptyCheck:videoDataArray]) {
            if (section ==0 && selectedSection == -1 && selectedIndex == -1) {
                return 0;
            }else{
                return videoDataArray.count;
                
            }
        }
        return 0;
        
    }else{
        return 0;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"ExerciseDetailsTableViewCell";
    ExerciseDetailsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ExerciseDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:indexPath.section];
    NSArray *videoDataArray =[circuitDict valueForKey:@"CircuitExercises"];
    
    cell.videoButton.tag = indexPath.section;
    cell.videoButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
    
    if (![Utility isEmptyCheck:videoDataArray] && videoDataArray.count > 0) {
        NSDictionary *dict = [videoDataArray objectAtIndex:indexPath.row];
        NSMutableAttributedString *exerciseName = [dict objectForKey:@"ExerciseName"];
//        if (![Utility isEmptyCheck:exerciseName]) {
//            cell.exerciseName.text = exerciseName;
//        }
        //        cell.numberLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
        cell.numberLabel.text = [NSString stringWithFormat:@"%c.",(int)indexPath.row+97];
        NSString *reps =@"";
          if (![Utility isEmptyCheck:exerciseName]) {
              reps = [@"" stringByAppendingFormat:@" %@\n%d",[dict objectForKey:@"ExerciseName"],[[dict valueForKey:@"RepGoal"] intValue]];
          }
        if (![Utility isEmptyCheck:reps]) {
            if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                
                cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                
                cell.reps.hidden = false;
                
            } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" reps each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                cell.reps.hidden = false;
                
            } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs each side" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                cell.reps.hidden = false;
                //ah 1.2
            } else {
                if (![Utility isEmptyCheck:[dict objectForKey:@"RepsUnitText"]]) {
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"RepsUnitText"]] bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    cell.reps.hidden = false;
                }else{
                    cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",reps] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" secs" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                    cell.reps.hidden = false;
                }
            }
            
            
        }else{
            cell.reps.text = @"";
            cell.reps.hidden = true;
        }
        /*NSString *sets = [@"" stringByAppendingFormat:@"%d",[[dict valueForKey:@"SetCount"] intValue]];
         if (![Utility isEmptyCheck:sets]) {
         cell.sets.attributedText = [Utility getStringWithHeader:@"Sets : " headerFont:[UIFont fontWithName:@"Roboto-Regular" size:15] headerColor:[UIColor blackColor] bodyString:sets bodyFont:[UIFont fontWithName:@"Roboto-Light" size:15] BodyColor:[UIColor blackColor]];
         cell.sets.hidden = false;
         }else{
         cell.sets.text = @"";
         cell.sets.hidden = true;
         }*/
        NSString *sets = [@"" stringByAppendingFormat:@"%d",[[dict valueForKey:@"SetCount"] intValue]];
        if (![Utility isEmptyCheck:sets] && [[dict objectForKey:@"IsSuperSet"] intValue] == 0) {
            
            cell.reps.hidden = false;
            if (![Utility isEmptyCheck:cell.reps.attributedText]) {
                NSAttributedString *setsAttrString =[Utility getStringWithHeader:[NSString stringWithFormat:@"  X %@",(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER)?@"∞":sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
                NSMutableAttributedString* result = [cell.reps.attributedText mutableCopy];
                [result appendAttributedString:setsAttrString];
                cell.reps.attributedText =result;
                
            }else{
                cell.reps.attributedText = [Utility getStringWithHeader:[NSString stringWithFormat:@"%@",sets] headerFont:[UIFont fontWithName:@"Roboto-Regular" size:12] headerColor:[UIColor darkGrayColor] bodyString:@" sets" bodyFont:[UIFont fontWithName:@"Roboto-Regular" size:12] BodyColor:[UIColor darkGrayColor]];
            }
            
        }
        
        NSArray *equipments = [dict objectForKey:@"Equipments"];
        if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
            cell.equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
            cell.equipmentRequiredStackView.hidden = false;
            
        }else{
            cell.equipmentRequiredStackView.hidden = true;
        }
        NSArray *tips = [dict objectForKey:@"Tips"];
        if (![Utility isEmptyCheck:tips] && tips.count > 0) {
            cell.exerciseTips.text = [@"\u2022  " stringByAppendingString:[tips componentsJoinedByString:@"\n\u2022  "]];
            cell.exerciseTipsStackView.hidden = false;
            cell.tipsStackView.hidden = true;
            
        }else{
            cell.exerciseTipsStackView.hidden = true;
            cell.tipsStackView.hidden = true;
        }
        
        //ah 17
        for (UIView *view in cell.equipmentBasedAlternativesButtonStackView.arrangedSubviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [cell.equipmentBasedAlternativesButtonStackView removeArrangedSubview:view] ;
                [view removeFromSuperview];
            }
        }
        NSArray *substituteEquipments = [dict objectForKey:@"SubstituteExercises"];
        if (substituteEquipments.count > 0) {
            for (int i=0; i<substituteEquipments.count; i++) {
                NSDictionary *substituteExercisesDict = [substituteEquipments objectAtIndex:i];
                if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseId"]]) {
                        [button addTarget:self
                                   action:@selector(substituteExercisesButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
                        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                        [button setAttributedTitle:titleString forState:UIControlStateNormal];
                        button.tag =[[substituteExercisesDict objectForKey:@"SubstituteExerciseId"] integerValue];
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }else{
                        
                        [button setTitle:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] forState:UIControlStateNormal];
                        
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];
                    
                }
            }
            cell.equipmentBasedAlternativesStackView.hidden = false;
            
        }else{
            cell.equipmentBasedAlternativesStackView.hidden = true;
            /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
             [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [button setTitle:@"N/A" forState:UIControlStateNormal];
             
             button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
             
             button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
             [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];*/
        }
        
        for (UIView *view in cell.bodyWeightAlternativesButtonStackView.arrangedSubviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                [cell.bodyWeightAlternativesButtonStackView removeArrangedSubview:view] ;
                [view removeFromSuperview];
            }
        }
        NSArray *AltBodyWeightExercises = [dict objectForKey:@"AltBodyWeightExercises"];
        if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
            for (int i=0; i<AltBodyWeightExercises.count; i++) {
                NSDictionary *altBodyWeightExercisesDict = [AltBodyWeightExercises objectAtIndex:i];
                if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]]) {
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"]]) {
                        [button addTarget:self
                                   action:@selector(substituteExercisesButtonPressed:)
                         forControlEvents:UIControlEventTouchUpInside];
                        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                        [button setAttributedTitle:titleString forState:UIControlStateNormal];
                        button.tag =[[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"] integerValue];
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }else{
                        
                        [button setTitle:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] forState:UIControlStateNormal];
                        
                        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        
                        button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    [cell.bodyWeightAlternativesButtonStackView addArrangedSubview:button];
                    
                }
            }
            cell.bodyWeightAlternativesStackView.hidden = false;
        }else{
            cell.bodyWeightAlternativesStackView.hidden = true;
        }
        cell.restPeriodStackView.hidden = YES;
        
        
        NSArray *photoList = [dict objectForKey:@"PhotoList"];
        NSString  *videoUrlString = [dict objectForKey:@"VideoUrlPublic"];
        
        [cell.detailContainerStackView removeArrangedSubview:cell.playerContainer];
        [cell.playerContainer removeFromSuperview];
        
        if ((![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) ||(![Utility isEmptyCheck:videoUrlString])) {
            [cell.detailContainerStackView insertArrangedSubview:cell.playerContainer atIndex:2];
            if (![Utility isEmptyCheck:photoList] && photoList.count > 0 && ![Utility isEmptyCheck:[photoList objectAtIndex:0]]) {
                [cell.exerciseImageView sd_setImageWithURL:[NSURL URLWithString:[photoList objectAtIndex:0]]
                                          placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
                cell.exerciseImageView.hidden = false;
                
            }else{
                cell.exerciseImageView.hidden = true;
            }
            if (![Utility isEmptyCheck:videoUrlString]) {
                /*AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
                NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
                player = [AVPlayer playerWithURL:videoUrl];
                [player play];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = true;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                playerViewController.view.frame = cell.exercisePlayerView.bounds;
                [cell.exercisePlayerView addSubview:playerViewController.view];
                cell.playerController = playerViewController;
                cell.exercisePlayerView.hidden = false;
                [player play];*/
//                videoUrlString = @"https://player.vimeo.com/external/140502161.m3u8?s=3c3437b869f2e19cc4b88d651a05db7a3c9bd662";
                
                
               /* cell.exercisePlayerView.hidden = false;

                AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
                NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
                
                NSLog(@"vu %@",videoUrl);
                
                NSError *_error = nil;
                [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &_error];
                NSLog(@"err %@",_error.localizedDescription);
                if(player){
                    player=nil;
                }
                player = [[AVPlayer alloc]initWithURL:videoUrl];
                
//                player = [AVPlayer playerWithURL:videoUrl];
//                [player play];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = YES;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                playerViewController.view.frame = cell.exercisePlayerView.bounds;
                [cell.exercisePlayerView addSubview:playerViewController.view];
                cell.playerController = playerViewController;
                playerViewController=nil;
                player=nil;*/
            }else{
                cell.exercisePlayerView.hidden = true;
            }
            //ah 17
            [cell.scrollNextButton setTag:indexPath.row+10001];
            cell.scrollNextButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section + 10001];
            [cell.scrollNextButton addTarget:self
                                      action:@selector(scrollNextButtonTapped:)
                            forControlEvents:UIControlEventTouchUpInside];

            [cell.scrollPreviousButton setTag:indexPath.row+20001];
            cell.scrollPreviousButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section + 20001];
            [cell.scrollPreviousButton addTarget:self
                                          action:@selector(scrollPreviousButtonTapped:)
                                forControlEvents:UIControlEventTouchUpInside];
            
            if([Utility isEmptyCheck:photoList] || photoList.count == 0 || [Utility isEmptyCheck:[photoList objectAtIndex:0]]){
                cell.exercisePlayerView.hidden = false;
                cell.exerciseImageView.hidden = true;
                cell.scrollNextButton.hidden = YES;
                cell.scrollPreviousButton.hidden = YES;
            }else if([Utility isEmptyCheck:videoUrlString]){
                cell.exercisePlayerView.hidden = true;
                cell.exerciseImageView.hidden = false;
                cell.scrollNextButton.hidden = YES;
                cell.scrollPreviousButton.hidden = YES;
            }else{
                cell.exercisePlayerView.hidden = true;
                cell.exerciseImageView.hidden = false;
                cell.scrollNextButton.hidden = NO;
                cell.scrollPreviousButton.hidden = YES;
            }
//            cell.expandCollapseButton.tag = indexPath.row;
//            cell.expandCollapseButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        }
        
        
        
        //superSet
        if ([[dict objectForKey:@"IsSuperSet"] intValue] >= 1) {
            cell.circuitSuperSetView.hidden = NO;
            cell.setLabel.hidden = YES;
            if ([[dict objectForKey:@"SuperSetPosition"] intValue] == -1) {
                //first
                cell.circuitSuperSetUpperView.hidden = YES;
                cell.circuitSuperSetMiddleView.hidden = NO;
                cell.circuitSuperSetLowerView.hidden = NO;
                
                if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                    cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                }else{
                    cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                }
                
                
                cell.setLabel.hidden = NO;
                cell.setLabel.textColor = [UIColor whiteColor];
                
//                if ([scrollDirection caseInsensitiveCompare:@"down"] == NSOrderedSame)    //ah 27.2
//                    isSsOnce = NO;
                
                cell.cellSeparatorRightView.backgroundColor = [UIColor whiteColor]; //ah 27.2
            } else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 0) {
                //middle
                cell.circuitSuperSetUpperView.hidden = NO;
                cell.circuitSuperSetMiddleView.hidden = YES;
                cell.circuitSuperSetLowerView.hidden = NO;
                if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                    cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                }else{
                   cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                }
                
                cell.setLabel.hidden = NO;
                cell.setLabel.textColor = [UIColor whiteColor];
                
                cell.cellSeparatorRightView.backgroundColor = [UIColor whiteColor]; //ah 27.2
            } else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 1) {
                //third
                cell.circuitSuperSetUpperView.hidden = NO;
                cell.circuitSuperSetMiddleView.hidden = NO;
                cell.circuitSuperSetLowerView.hidden = YES;
                
                if(sessionFlowId == TIMER || sessionFlowId == CIRCUITTIMER){
                    cell.setLabel.text = [NSString stringWithFormat:@"x ∞ sets"];
                }else{
                   cell.setLabel.text = [NSString stringWithFormat:@"x %@ sets",[[dict objectForKey:@"SetCount"] stringValue]];
                }
                
                cell.setLabel.hidden = NO;
                cell.setLabel.textColor = [UIColor whiteColor];
                cell.cellSeparatorRightView.backgroundColor = [UIColor lightGrayColor]; //ah 27.2
            }
            if ([[dict objectForKey:@"isMiddle"] boolValue]) {
                cell.setLabel.textColor = [UIColor grayColor];
            }else{
                cell.setLabel.textColor = [UIColor clearColor];
            }
        } else {
            cell.circuitSuperSetView.hidden = YES;
            cell.setLabel.hidden = YES;
        }
    }
    
//    if (selectedSection == indexPath.section && selectedIndex == indexPath.row) {
//        cell.stackView.arrangedSubviews.lastObject.hidden = NO;
//        cell.expandCollapseButton.selected=YES;
//    }else{
//        cell.stackView.arrangedSubviews.lastObject.hidden = YES;
//        cell.expandCollapseButton.selected=NO;
//    }
   // cell.expandCollapseButton.tag = indexPath.row;
   // cell.expandCollapseButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
    
    //arnab 17
  
    cell.mainViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width - 30;
    [cell.cellEditExerciseButton addTarget:self
                                    action:@selector(cellEditButtonTapped:)
                          forControlEvents:UIControlEventTouchUpInside];
//    [cell.cellEditExerciseButton setTag:indexPath.row+1001];
//    cell.cellEditExerciseButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section + 1001];
    //    cell.cellScrollView.delegate = self;
    
      //EDIT_NEW_ADD
    cell.cellEditExerciseButton.tag = indexPath.row;
    cell.cellEditExerciseButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",(int)indexPath.section];
    
    CGRect frame = cell.cellScrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = 0;
    [cell.cellScrollView scrollRectToVisible:frame animated:NO];
    //end
    
    
//    cell.cellScrollView.scrollEnabled = false;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}
#pragma mark -End

#pragma mark -IBAction
- (IBAction)substituteExercisesButtonPressed:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseId = (int)sender.tag;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(IBAction)musicButtonPressed:(id)sender{
    //if ([Utility isSubscribedUser]) {
        SettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
        [self.navigationController pushViewController:controller animated:YES];
    //}else{
        //[Utility showSubscribedAlert:self];
    //}
    
}
-(IBAction)editSessionButtonPressed:(UIButton*)sender{
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 21022018
    
    if(_isEditSession){
        [self backButtonPressed:0];
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];                                                                         [formatter setDateFormat:@"yyyy-MM-dd"];
    //
    NSDate* sourceDate = [NSDate date];
    
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
    weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    //
    //NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:sender.tag];
    AddCustomSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddCustomSession"];
    controller.sessionID = workoutTypeId;//[[circuitDict objectForKey:@"Id"] intValue];
    controller.exerciseSessionId = _exSessionId;
    controller.weekDate =  [NSString stringWithFormat:@"%@T00:00:00",[formatter stringFromDate:weekstart]];
    controller.AddCustomSessionViewDelegate = self;//Feedback - 28032018
    controller.sessionDate1 = sender.accessibilityHint;
    controller.isFromExerciseDetails = true;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)showMenu:(UIButton*)sender {
    if ([sender.currentImage isEqual:[UIImage imageNamed:@"back.png"]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)cellExpandCollapse:(UIButton *)sender {
    [player pause];
    selectedSection = sender.accessibilityHint.intValue;
    if (selectedIndex == sender.tag) {
        selectedIndex = -1;
    }else{
        selectedIndex = (int)sender.tag;
    }
    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [table reloadData];
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }];
    
}

- (IBAction)sectionExpandCollapse:(UIButton *)sender {
    [player pause];
    selectedIndex = -1;
    if (selectedSection == sender.tag) {
        selectedSection = -1;
    }else{
        selectedSection = (int)sender.tag;
    }
    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
            if (finished) {
                [table reloadData];
                //            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sender.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                CGRect myRect = [table rectForSection:sender.tag];
                CGPoint bottomOffset = CGPointZero;
                if ((sender.tag == 0 && myRect.size.height<=100)|| (sender.tag == exerciseDetailsArray.count-1 && myRect.size.height<=100) ) {
                    bottomOffset = CGPointMake(table.frame.origin.x+myRect.origin.x,(myRect.origin.y + myRect.size.height)+200);
                }else{
                    bottomOffset = CGPointMake(table.frame.origin.x+myRect.origin.x,(myRect.origin.y + myRect.size.height));
                }
                
                NSLog(@"%f - %f",bottomOffset.x,bottomOffset.y);
                [scroll setContentOffset:bottomOffset animated:YES];
            }
    }];
    
}

- (IBAction)backButtonPressed:(id)sender {
    if (_loadForSelected) {
        if ([delegate respondsToSelector:@selector(loadSelectedDate:)]) {
            [delegate loadSelectedDate:true];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)playButtonTapped:(id)sender {    //ah 29.5
    
    if (![Utility isEmptyCheck:exerciseDetailsArray] && exerciseDetailsArray.count > 1) {
        BOOL isEmpty = YES;
        for (int i = 1; i < exerciseDetailsArray.count; i++) {
            NSArray *cktEx = [[exerciseDetailsArray objectAtIndex:i] objectForKey:@"CircuitExercises"];
            if (![Utility isEmptyCheck:cktEx] || ![[[exerciseDetailsArray objectAtIndex:i] objectForKey:@"IsCircuit"] boolValue]) {
                isEmpty = NO;
                break;
            }
        }
        
        if(![Utility isSubscribedUser] && ![Utility reachable]){
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }else if (isEmpty && sessionFlowId != FOLLOWALONG) {
            [Utility msg:@"No exercise found!" title:@"Oops!" controller:self haveToPop:NO];
        }else {
            [self showAlert];
        }
    } else {
        //no exercise
        if (sessionFlowId == FOLLOWALONG) {
            [self showAlert];
            return;
        }
        [Utility msg:@"No exercise found!" title:@"Oops!" controller:self haveToPop:NO];
    }
}
//arnab 17
-(IBAction)headerEditButtonTapped:(UIButton*)sender {
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 21022018
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"acc %@",button.accessibilityHint);
    [editExerciseDict removeAllObjects];
    [editExerciseDict setObject:[NSString stringWithFormat:@"%d",(int)[sender tag] - 10001] forKey:@"cellIndex"];
    [editExerciseDict setObject:[NSString stringWithFormat:@"%d",[button.accessibilityHint intValue] - 10001] forKey:@"sectionIndex"];
    [editExerciseDict setObject:@"section" forKey:@"type"];
    [self openPicker:self ForEditing:@"ckt"];
}
-(IBAction)cellEditButtonTapped:(UIButton*)sender {
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 21022018
    /*
    UIButton *button = (UIButton *)sender;
    NSLog(@"acc %@",button.accessibilityHint);
    [editExerciseDict removeAllObjects];
    [editExerciseDict setObject:[NSString stringWithFormat:@"%d",(int)[sender tag] - 1001] forKey:@"cellIndex"];
    [editExerciseDict setObject:[NSString stringWithFormat:@"%d",[button.accessibilityHint intValue] - 1001] forKey:@"sectionIndex"];
    [editExerciseDict setObject:@"cell" forKey:@"type"];
    [self openPicker:self ForEditing:@"ex"];
    */
    //EDIT_NEW_ADD
    NSArray *mainExerciseDetailsArray = [exerciseDetailsArray mutableCopy];
    int section = [sender.accessibilityHint intValue];
    NSDictionary *circuitDict = [mainExerciseDetailsArray objectAtIndex:section];
    NSArray *videoDataArray =[circuitDict valueForKey:@"CircuitExercises"];
    [editExerciseDict removeAllObjects];
    [editExerciseDict setObject:[@"" stringByAppendingFormat:@"%d",(int)sender.tag] forKey:@"cellIndex"];
    [editExerciseDict setObject:[@"" stringByAppendingFormat:@"%@",sender.accessibilityHint] forKey:@"sectionIndex"];
    
    [editExerciseDict setObject:@"cell" forKey:@"type"];
    if (![Utility isEmptyCheck:videoDataArray] && videoDataArray.count > 0) {
        int value = (int)sender.tag;
        NSDictionary *dict = [videoDataArray objectAtIndex:value];
        ExerciseEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseEditView"];
        controller.circuitDict =dict;
        controller.exercisedelegate=self;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
-(IBAction)closePicker:(id)sender {
    [UIView transitionWithView:blurVisulaEffectView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        blurVisulaEffectView.hidden = YES;
                    }
                    completion:NULL];
    [UIView transitionWithView:pickerSuperView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        pickerSuperView.hidden = YES;
                    }
                    completion:NULL];
}
-(IBAction)pickerDoneTapped:(id)sender with:(NSDictionary*)dict {    //EDIT_NEW_ADD
    NSInteger selectedRow = [listPickerView selectedRowInComponent:0];
    //    NSLog(@"selT %@",[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"ExerciseName"]);
    
    //    if (saveButton.isHidden) {
    //        saveButton.hidden = false;
    //        playButton.hidden = true;
    //    }
    NSMutableArray *editExArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *editExDict = [[NSMutableDictionary alloc]init];
    NSMutableArray *editCktArr = [[NSMutableArray alloc]init];
    NSMutableDictionary *editCktDict = [[NSMutableDictionary alloc]init];
    int newExerciseId = -1;
    int oldExerciseId = [[[exerciseDetailsArray objectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue]] objectForKey:@"Id"] intValue];    //ah30
    if (!editSessionDictionary || editSessionDictionary.count == 0) {
        NSDate *today = [NSDate date];
        NSDateFormatter *currentDateformatter = [[NSDateFormatter alloc]init];
        [currentDateformatter setDateFormat:@"MM/dd/yyyy hh:mm:ss a"];     //1/11/2017 12:00:00 AM
        
        editSessionDictionary = [[NSMutableDictionary alloc]init];
        [editSessionDictionary setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [editSessionDictionary setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [editSessionDictionary setObject:AccessKey_ABBBC forKey:@"Key"];
        [editSessionDictionary setObject:[exerciseDetailsDict objectForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        [editSessionDictionary setObject:[exerciseDetailsDict objectForKey:@"SessionTitle"] forKey:@"SessionTitle"];
        [editSessionDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Personalised"];
        [editSessionDictionary setObject:[currentDateformatter stringFromDate:today] forKey:@"Date"];
        [editSessionDictionary setObject:[[exerciseDetailsArray objectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue]] objectForKey:@"SequenceNo"] forKey:@"SequenceNumber"];
        [editSessionDictionary setObject:[NSNumber numberWithInt:oldExerciseId] forKey:@"OldExerciseId"];
        [editSessionDictionary setObject:[NSNumber numberWithInt:newExerciseId] forKey:@"NewExerciseId"];
    }
    //    take @"EditedExercises" into an array inside if block and then addObject
    
    
    if ([[editExerciseDict objectForKey:@"type"] isEqualToString:@"cell"]) {
        NSMutableArray *exArr = [[NSMutableArray alloc]init];
        exArr = [exerciseDetailsArray mutableCopy];
        
        NSMutableDictionary *exDict = [[NSMutableDictionary alloc]init];
        [exDict addEntriesFromDictionary:[exArr objectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue]]];
        
        NSMutableArray *circuitArr = [[NSMutableArray alloc]init];
        [circuitArr addObjectsFromArray:[exDict objectForKey:@"CircuitExercises"]];
        
        NSMutableDictionary *circuitDict = [[NSMutableDictionary alloc]init];
        [circuitDict addEntriesFromDictionary:[circuitArr objectAtIndex:[[editExerciseDict objectForKey:@"cellIndex"] integerValue]]];
        //        NSLog(@"cd %@",circuitDict);
        
        //edit arr
        //        [editDict addEntriesFromDictionary:circuitDict];
        [editExDict setObject:[circuitDict objectForKey:@"ExerciseId"] forKey:@"Id"];
        [editExDict setObject:@"1" forKey:@"SequenceNo"];
//        [editExDict setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"ExerciseId"] forKey:@"NewExerciseId"]; //EDIT_NEW_ADD
        [editExDict setObject:[dict objectForKey:@"ExerciseId"] forKey:@"NewExerciseId"];  //EDIT_NEW_ADD

        
        [editExArr addObjectsFromArray:[editSessionDictionary objectForKey:@"EditedExercises"]];
        [editExArr addObject:editExDict];
        [editSessionDictionary setObject:editExArr forKey:@"EditedExercises"];
        //end edit
        
//        [circuitDict setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"ExerciseName"] forKey:@"ExerciseName"];
//        [circuitDict setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"ExerciseId"] forKey:@"ExerciseId"]; // AY 12012018
        
        [circuitDict setObject:[dict objectForKey:@"ExerciseName"] forKey:@"ExerciseName"]; //EDIT_NEW_ADD
        [circuitDict setObject:[dict objectForKey:@"ExerciseId"] forKey:@"ExerciseId"]; //EDIT_NEW_ADD
        
        [circuitArr replaceObjectAtIndex:[[editExerciseDict objectForKey:@"cellIndex"] integerValue] withObject:circuitDict];
        
        [exDict setValue:circuitArr forKey:@"CircuitExercises"];
        
        [exArr replaceObjectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue] withObject:exDict];
        
        exerciseDetailsArray = [exArr copy];
        //        NSLog(@"exer %@",exerciseDetailsArray);
        
        [table reloadData];
        [self closePicker:self];
    } else if ([[editExerciseDict objectForKey:@"type"] isEqualToString:@"section"]) {
        /*NSMutableArray *exArr = [[NSMutableArray alloc]init];
         exArr = [exerciseDetailsArray mutableCopy];
         
         NSMutableDictionary *exDict = [[NSMutableDictionary alloc]init];
         [exDict addEntriesFromDictionary:[exArr objectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue]]];
         
         //edit arr
         //        [editDict addEntriesFromDictionary:exDict];
         [editCktDict setObject:[exDict objectForKey:@"Id"] forKey:@"Id"];
         [editCktDict setObject:@"0" forKey:@"SequenceNo"];
         [editCktDict setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"CircuitId"] forKey:@"NewCircuitId"];   //need cktID
         
         [editCktArr addObjectsFromArray:[editSessionDictionary objectForKey:@"EditedCircuits"]];
         [editCktArr addObject:editCktDict];*/
        
        //ah31
        [editSessionDictionary setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"ExerciseId"] forKey:@"NewExerciseId"];
        //        [editSessionDictionary setObject:[[cktListArray objectAtIndex:selectedRow] objectForKey:@"CircuitId"] forKey:@"OldExerciseId"];
        //        [editSessionDictionary setObject:[NSArray new] forKey:@"EditedExercises"];
        //end edit
        
        
        /*  [exDict setObject:[[exerciseListArray objectAtIndex:selectedRow] objectForKey:@"CircuitName"] forKey:@"Name"];
         
         [exArr replaceObjectAtIndex:[[editExerciseDict objectForKey:@"sectionIndex"] integerValue] withObject:exDict];
         
         exerciseDetailsArray = [exArr copy];*/
        
        [self closePicker:self];
        
        [self saveEditedExercisesFromButton:@""];
    }
}
-(IBAction)scrollNextButtonTapped1:(id)sender {
    if (selectedHeaderView) {
        [selectedHeaderView.playerController.player pause];
        
        [UIView transitionWithView:selectedHeaderView.exerciseImageView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                            selectedHeaderView.exerciseImageView.hidden = YES;
                            selectedHeaderView.exercisePlayerView.hidden = NO;
                        }
                        completion:NULL];
        
        selectedHeaderView.scrollNextButton.hidden = YES;
        selectedHeaderView.scrollPreviousButton.hidden = NO;
    }
    
}
-(IBAction)scrollPreviousButtonTapped1:(id)sender {
    if (selectedHeaderView) {
        [selectedHeaderView.playerController.player pause];
        
        [UIView transitionWithView:selectedHeaderView.exerciseImageView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            selectedHeaderView.exerciseImageView.hidden = NO;
                            selectedHeaderView.exercisePlayerView.hidden = YES;
                        }
                        completion:NULL];
        
        selectedHeaderView.scrollNextButton.hidden = NO;
        selectedHeaderView.scrollPreviousButton.hidden = YES;
    }
    
}
-(IBAction)scrollNextButtonTapped:(id)sender {
    UIButton *btn = (UIButton *)sender;
    id superView = [(UIButton*)sender superview];
    while (superView && ![superView isKindOfClass:[UITableViewCell class]]) {
        superView = [superView superview];
    }
    ExerciseDetailsTableViewCell * cell = (ExerciseDetailsTableViewCell *) superView;
    //    cell.detailContainerStackView.arrangedSubviews.lastObject.hidden = YES;
    //    NSLog(@"aa %@",cell.detailContainerStackView.arrangedSubviews);
    [cell.playerController.player pause];
    
    [player pause];
    
    [UIView transitionWithView:cell.exerciseImageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        cell.exerciseImageView.hidden = YES;
                        cell.exercisePlayerView.hidden = NO;
                    }
                    completion:NULL];
    
    cell.scrollNextButton.hidden = YES;
    cell.scrollPreviousButton.hidden = NO;
    
//    [cell.playerController.player play];

    cell.playerController = nil;
    
    NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:[btn.accessibilityHint intValue]-10001];
    NSArray *videoDataArray =[circuitDict valueForKey:@"CircuitExercises"];
//    if (![Utility isEmptyCheck:videoDataArray] && videoDataArray.count > 0)
        NSDictionary *dict = [videoDataArray objectAtIndex:btn.tag-10001];
    NSString  *videoUrlString = [dict objectForKey:@"VideoUrlPublic"];

    if (![Utility isEmptyCheck:videoUrlString]) {
        AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
        NSURL *videoUrl = [NSURL URLWithString:videoUrlString];
        NSError *_error = nil;
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient    error:&_error];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
            
        } @catch (NSException *exception) {
            NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
            
        } @finally {
            NSLog(@"Audio Session finally");
        }

        if(player){
            player=nil;
        }
        player = [[AVPlayer alloc]initWithURL:videoUrl];
        
        //                player = [AVPlayer playerWithURL:videoUrl];
        playerViewController.player = player;
        playerViewController.delegate = self;
        playerViewController.showsPlaybackControls = YES;
        [self addChildViewController:playerViewController];
        [playerViewController didMoveToParentViewController:self];
        playerViewController.view.frame = cell.exercisePlayerView.bounds;
        [cell.exercisePlayerView addSubview:playerViewController.view];
        cell.playerController = playerViewController;
        [cell.playerController.player play];
    }
}
-(IBAction)scrollPreviousButtonTapped:(id)sender {
    [player pause];
    id superView = [(UIButton*)sender superview];
    while (superView && ![superView isKindOfClass:[UITableViewCell class]]) {
        superView = [superView superview];
    }
    ExerciseDetailsTableViewCell * cell = (ExerciseDetailsTableViewCell *) superView;
    [cell.playerController.player pause];
    
    [UIView transitionWithView:cell.exerciseImageView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        cell.exerciseImageView.hidden = NO;
                        cell.exercisePlayerView.hidden = YES;
                    }
                    completion:NULL];
    
    cell.scrollNextButton.hidden = NO;
    cell.scrollPreviousButton.hidden = YES;
}

-(IBAction)saveTapped:(id)sender {
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 21022018
    
    [self saveEditedExercisesFromButton:@"save"];
}
-(IBAction)infoButtonTapped:(UIButton *)sender {
    if (selectedInfo == sender.tag - 30001) {
        selectedInfo = -1;
    }else{
        selectedInfo = (int)sender.tag - 30001;
    }
    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [table reloadData];
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sender.tag-30001] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }];
}
-(IBAction)videoButtonPressed:(UIButton *)sender{
    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
        return;
    }// AY 20032018

    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *circuitDict = [exerciseDetailsArray objectAtIndex:sender.tag];
        NSArray *videoDataArray =[circuitDict valueForKey:@"CircuitExercises"];
        if (![Utility isEmptyCheck:videoDataArray] && videoDataArray.count > 0) {
            int value = [sender.accessibilityHint intValue];
            NSDictionary *dict = [videoDataArray objectAtIndex:value];
            ExerciseDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetailsVideo"];
            controller.circuitDict = dict;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }
    });
}
- (IBAction)weightRecordButtonPressed:(UIButton *)sender {
    
    if ([Utility isSubscribedUser] && [Utility isOfflineMode]) {
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }// AY 07032018
    
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
    }else{
        WeightRecordSheetViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WeightRecordSheetView"];
        controller.sessionDate = weekDate;
        controller.exSessionId = _exSessionId;
        controller.fromWhere= fromWhere;
        controller.workoutTypeId=workoutTypeId;
        controller.exerciseListArray =  exerciseDetailsArray; //AY 21112017
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(IBAction)favButtonPressed:(id)sender{
    if (![defaults boolForKey:@"IsNonSubscribedUser"] && ![Utility isSubscribedUser] && ![Utility isSquadLiteUser]) {//today__
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    [self webserviceCall_FavoriteSessionToggle];
}
- (IBAction)addCusstomPressed:(UIButton *)sender {
    
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    if ([Utility isSubscribedUser] && [Utility isOfflineMode]) {
        [Utility msg:@"You are in OFFLINE mode. Go Online to access this functionality." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }
    [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup" sender:sender];
    //    if (![Utility isEmptyCheck:[defaults objectForKey:@"CustomExerciseStepNumber"]] && [[defaults objectForKey:@"CustomExerciseStepNumber"]intValue] == 0) {
    //        if (sender == addTodayButton) {
    //            NSDate *currentDate = [NSDate date];
    //            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //            [formatter setDateFormat:@"yyyy-MM-dd"];
    //            [self getWorkoutSessionsFromDate:[formatter stringFromDate:currentDate] today:YES];
    //        } else {
    //            if (!addDayArray) {
    //                addDayArray = [NSMutableArray new];
    //                //create all days
    //                NSDate *currentDate = [NSDate date];
    //                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //                NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
    //                NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    //                if ([weekdayComponents weekday] == 1) {
    //                    [componentsToSubtract setDay:-6];
    //                }else{
    //                    [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    //                }
    //                NSDate *weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
    //                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //                formatter.dateFormat = @"yyyy-MM-dd";
    //                NSArray *customDayArray = @[@"View Custom plan",@"Add in Monday's custom plan",@"Add in Tuesday's custom plan",@"Add in Wednesday's custom plan",@"Add in Thursday's custom plan",@"Add in Friday's custom plan",@"Add in Saturday's custom plan",@"Add in Sunday's custom plan"];
    //                NSMutableDictionary *dict = [NSMutableDictionary new];
    //                [dict setObject:@"0" forKey:@"day"];
    //                [dict setObject:[customDayArray objectAtIndex:0] forKey:@"value"];
    //                [addDayArray addObject:dict];
    //                //add 7 days
    //                NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    //                for (int i=0; i<7; i++) {
    //                    NSMutableDictionary *dict = [NSMutableDictionary new];
    //                    formatter.dateFormat = @"yyyy-MM-dd";
    //                    NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
    //                    compsToAdd.day=i;
    //                    NSDate *nextDate = [gregorian dateByAddingComponents:compsToAdd toDate:weekstart options:0];
    //                    [week addObject:[formatter stringFromDate:nextDate]];
    //                    [dict setObject:[formatter stringFromDate:nextDate] forKey:@"day"];
    //                    [dict setObject:[customDayArray objectAtIndex:i+1] forKey:@"value"];
    //                    [addDayArray addObject:dict];
    //                }
    //
    //            }
    //
    //            DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    //            controller.modalPresentationStyle = UIModalPresentationCustom;
    //            controller.dropdownDataArray = addDayArray;
    //            controller.mainKey = @"value";
    //            controller.apiType = @"dayName";
    //            controller.selectedIndex = -1;
    //            controller.delegate = self;
    //            controller.sender = sender;
    //            [self presentViewController:controller animated:YES completion:nil];
    //        }
    //    }else{
    //
    //        UIAlertController * alert = [UIAlertController
    //                                     alertControllerWithTitle:@""
    //                                     message:@"You have not completed the exercise settings, complete the settings to use this feature. Do you want to complete it now ?"
    //                                     preferredStyle:UIAlertControllerStyleAlert];
    //
    //        UIAlertAction* ok = [UIAlertAction
    //                             actionWithTitle:@"Yes"
    //                             style:UIAlertActionStyleDefault
    //                             handler:^(UIAlertAction * action) {
    //                                 [self checkStepNumberForSetupWithAPI:@"CheckStepNumberForSetup" sender:sender];
    //                             }];
    //
    //        UIAlertAction* cancel = [UIAlertAction
    //                                 actionWithTitle:@"No"
    //                                 style:UIAlertActionStyleCancel
    //                                 handler:^(UIAlertAction * action) {
    //
    //                                 }];
    //
    //        [alert addAction:ok];
    //        [alert addAction:cancel];
    //
    //        [self presentViewController:alert animated:YES completion:nil];
    //    }
    
}
-(void)addOrViewSession:(UIButton *)sender{
    
    
    
    if (sender == addTodayButton) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [self getWorkoutSessionsFromDate:[formatter stringFromDate:currentDate] today:YES];
    } else {
        if (!addDayArray) {
            addDayArray = [NSMutableArray new];
            //create all days
            NSDate *currentDate = [NSDate date];
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:currentDate];
            NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
            if ([weekdayComponents weekday] == 1) {
                [componentsToSubtract setDay:-6];
            }else{
                [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
            }
            NSDate *weekstart = [gregorian dateByAddingComponents:componentsToSubtract toDate:currentDate options:0];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSArray *customDayArray = @[@"View Custom plan",@"Add in Monday's custom plan",@"Add in Tuesday's custom plan",@"Add in Wednesday's custom plan",@"Add in Thursday's custom plan",@"Add in Friday's custom plan",@"Add in Saturday's custom plan",@"Add in Sunday's custom plan"];
            NSMutableDictionary *dict = [NSMutableDictionary new];
            [dict setObject:@"0" forKey:@"day"];
            [dict setObject:[customDayArray objectAtIndex:0] forKey:@"value"];
            [addDayArray addObject:dict];
            //add 7 days
            NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
            for (int i=0; i<7; i++) {
                NSMutableDictionary *dict = [NSMutableDictionary new];
                formatter.dateFormat = @"yyyy-MM-dd";
                NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
                compsToAdd.day=i;
                NSDate *nextDate = [gregorian dateByAddingComponents:compsToAdd toDate:weekstart options:0];
                [week addObject:[formatter stringFromDate:nextDate]];
                [dict setObject:[formatter stringFromDate:nextDate] forKey:@"day"];
                [dict setObject:[customDayArray objectAtIndex:i+1] forKey:@"value"];
                [addDayArray addObject:dict];
            }
            
        }
        
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = addDayArray;
        controller.mainKey = @"value";
        controller.apiType = @"dayName";
        controller.selectedIndex = -1;
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }
}
- (IBAction)sessionOverViewPressed:(UIButton *)sender {
//    [[exerciseDetailsDict objectForKey:@"SessionOverview"] componentsJoinedByString:@"\n"];
    [Utility msg:[[exerciseDetailsDict objectForKey:@"SessionOverview"] componentsJoinedByString:@"<br>"] title:@"Overview\n" controller:self haveToPop:NO];
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PickerView DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([editCktOrExPicker isEqualToString:@"ex"]) {
        return exerciseListArray.count;
    } else if ([editCktOrExPicker isEqualToString:@"ckt"]) {
        return cktListArray.count;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([editCktOrExPicker isEqualToString:@"ex"]) {
        return [[exerciseListArray objectAtIndex:row] objectForKey:@"ExerciseName"];
    } else if ([editCktOrExPicker isEqualToString:@"ckt"]) {
        return [[cktListArray objectAtIndex:row] objectForKey:@"CircuitName"];
    }
    return @"";
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"sel -> %@",listArray[row]);
    //[selectedButton setTitle:[[listArray objectAtIndex:row] valueForKey:@"label"] forState:UIControlStateNormal];
    //    [submitArray setValue:[[listArray objectAtIndex:row] valueForKey:@"value"] forKey:selectedID];
    //    [selectedButton setAttributedTitle:[util htmlParseWithString:[[listArray objectAtIndex:row] valueForKey:@"label"]] forState:UIControlStateNormal];
}
#pragma mark - End

#pragma mark - ExerciseEditDetailsProtocol
//EDIT_NEW_ADD
-(void)selecedExerciseData:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    if (![Utility isEmptyCheck:dict]) {
        [self pickerDoneTapped:nil with:dict];
    }
}
#pragma mark - End
#pragma mark Dropdown View Delegate
-(void)didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender{
    if ([type isEqualToString:@"dayName"]) {
        if ([data[@"day"] isEqualToString:@"0"]) {
            ViewPersonalSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPersonalSession"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self getWorkoutSessionsFromDate:data[@"day"] today:NO];
        }
    }
}
#pragma mark -End
#pragma mark -SwapSessionViewDelegate
-(void)swapSessionPressed:(NSDictionary *)data swapDate:(NSString *)swapDate{
    NSNumber *workoutId = ![Utility isEmptyCheck:data[@"Id"]]?data[@"Id"]:@-1;
    [self addSwapCustomSession:swapDate swap:YES workoutId:workoutId];
}
#pragma mark -End
#pragma mark - AddCustomSessionViewProtocol

-(void)getUpdateSessionId:(int)updateSessionId{ //Feedback - 28032018
    isChanged = true;
    _exSessionId = updateSessionId;
    uniqueequipmentsArray = [[NSMutableArray alloc]init];
    [self getExerciseDetails];
    
}
@end
