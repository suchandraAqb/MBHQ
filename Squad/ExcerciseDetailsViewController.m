//
//  ExcerciseDetailsViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//
@import AVFoundation;
@import AVKit;

#import "ExcerciseDetailsViewController.h"
#import "MasterMenuViewController.h"
#import "ExcerciseTitleViewController.h"
#import "IndividulaTableViewCell.h"
#import "Utility.h"
#import "footerView.h"
#import "ViewScoreTableCell.h"//,,,change new1
#import "LeaderBoardDetailsViewController.h"
#import "ExcerciseDetailsShareViewController.h"
#import "ExcerciseDetailsCollectionViewCell.h"
#import "ExerciseDetailsViewController.h"
#import "ExerciseDetailsVideoViewController.h"
#import "ChallengePreviousActivityViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ProgressBarViewController.h"

static CGFloat ipadExtraFontSize = 4.0;


//static CGFloat expandedHeight1 = 222.0;
//static CGFloat contractedHeight1 = 44.0;
//static CGFloat expandedHeightIpad1 = 352.0;
//static CGFloat contractedHeightIpad1 = 52.0;
#define colorMacro(_name_)((UIColor *)[util colorWithHexString:(NSString *)(_name_)])
#define fontMacro(_name_, _size_) ((UIFont *)[UIFont fontWithName:(NSString *)(_name_) size:(CGFloat)(_size_)])
#define SCORE_TABLE_HEIGHT 326 //AmitY 3-Nov-2016
#define SCORE_TABLE_CONTENT_VIEW_HEIGHT 38 //AmitY 3-Nov-2016

@interface ExcerciseDetailsViewController ()
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UITableView *table;
    
    IBOutlet NSLayoutConstraint *instructionHeaderLabelConstant;
    IBOutlet NSLayoutConstraint *scrollingHeaderLabelConstant;
    IBOutlet NSLayoutConstraint *variationsHeaderLabelConstant;
    
    IBOutlet UILabel *instructionLabel;
    IBOutlet UIView *instructionView;
    IBOutlet NSLayoutConstraint *instructionLabelHeightConstant;
    
    IBOutlet UIView *scroingView;
    IBOutlet UILabel *scroingLabel;
    IBOutlet NSLayoutConstraint *scrollingLabelHeightconstant;
    
    IBOutlet UIView *variationView;
    IBOutlet UILabel *variationslabel;
    IBOutlet NSLayoutConstraint *variationLabelHeightConstant;
    
    IBOutlet UIButton *startButton;
    IBOutlet UIButton *resetButton;
    IBOutlet UILabel *timerLabel;
    
    IBOutlet UITextField *pbTextField;
    IBOutlet UILabel *equipmentLabel;
    
    NSTimer *timer;
    NSTimeInterval interval;
    
    NSMutableArray *selectedRowIndexArray;
    NSInteger counter;
    NSMutableArray *selectedArray;
    NSMutableArray *videoArray;
    AVPlayerViewController *playerViewController;
    NSMutableArray *pbArray;
    
    AVPlayerViewController *playerView;
    NSInteger indexOfExpandedCell;
    NSInteger sectionOfExpandedCell;
    BOOL shouldCellBeExpanded ;
    Utility *util;
    AVPlayer *player;
    UITextField *activeTextField;
    
    //,,,change new1
    UIView *contentView;
    IBOutlet UITableView *scoreTable;
    NSMutableArray *scoreArray;
    UIPickerView *timePicker;
    //,,,change new1
    
    //,,,change new2
    IBOutlet NSLayoutConstraint *tableHeightConstraints;
    IBOutlet NSLayoutConstraint *scoreTableHeightConstraints;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UIView *datePickerView;
    IBOutlet UIBarButtonItem *datePickerCancelButton;
    IBOutlet UIBarButtonItem *datePickerDoneButton;
     UIImagePickerController *imagePicker;
    IBOutlet UIButton *shareButton;
    //,,,change new2
    
    //AmitY 3-Nov-2016
    BOOL willCountHidden;
    BOOL willTimeHidden;
    BOOL willRepsHidden;
    NSString *unitName;
    NSString *repsUnitName;
    BOOL isvideoupload;
    int lastOne;
    int firstOne;
    //End
    
    //add_su_1_com
    IBOutlet UICollectionView *excerciseCollection;
    IBOutlet NSLayoutConstraint *collectionViewHeightConstant;
    IBOutlet UIView *excerciseLabelView;
    IBOutlet NSLayoutConstraint *excerciseLabelHeightConstatnt;
    BOOL isChanged;
    
    IBOutlet UITextView *instructionscoringTextView;
    IBOutlet UIButton *instructionButton;
    IBOutlet UIButton *scroingButton;
    IBOutlet UILabel *exName;
    IBOutlet NSLayoutConstraint *instructionScroingViewHeightConstant;
    IBOutlet UIButton *readMoreButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *previousActivityButton;
    IBOutlet UIButton *viewleaderBoardButton;
    IBOutlet UIView *readMoreUndelineView;
    IBOutlet UIButton *dateButton;
    IBOutlet UITextView *videolinkTextView;
    IBOutlet UITextField *countTextField;
    IBOutlet UITextField *repsTextField;
    IBOutlet UIButton *timeButton;
    IBOutlet UILabel *countLabel;
    IBOutlet UILabel *repsLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIStackView *stack;
    IBOutlet UIView *countView;
    IBOutlet UIView *repsView;
    IBOutlet UIView *timeView;
    IBOutlet UIView *dateView;
    IBOutlet UIView *countTextFieldView;
    IBOutlet UIView *repsTextFieldView;
    IBOutlet UIView *timeTextFiledView;
    IBOutlet UIView *videoLinkView;
    IBOutlet NSLayoutConstraint *readMoreHeightConstant;
    IBOutlet UILabel *videoLabel;
    NSDate *selectedDate;
    NSString *mediaUrl;
    UITextView *activeTextView;
    BOOL isStart;
    IBOutlet UIButton *stopButton;
    BOOL isExerciseIsSession;

}
@end
@implementation ExcerciseDetailsViewController
@synthesize excerciseDetailsDict,buttontag,indexValue,mainFinishSquadWowButtonTag;

#pragma mark - IBAction

-(IBAction)logoButtonPressed:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
- (IBAction)videoPlayButtonPressed:(UIButton*)sender {
    NSLog(@"%@",scoreArray[sender.tag]);
    NSDictionary *dict = scoreArray[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        if (![Utility isEmptyCheck:[dict objectForKey:@"VideoFileName"]]) {
            NSString *videoUrl = [BASEVIDEOURL stringByAppendingString:[dict objectForKey:@"VideoFileName"]];
            NSURL *videoURL = [NSURL URLWithString:videoUrl];
            AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
            controller.player = [[AVPlayer alloc]initWithURL:videoURL];
            [self presentViewController:controller animated:YES completion:nil];
            controller.view.frame = self.view.frame;
            [controller.player play];
        }else{
        
        }
    }
}

-(IBAction)previousActivityButtonPressed:(id)sender{
    ChallengePreviousActivityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChallengePreviousActivity"];
    controller.excerciseDetailsDict = excerciseDetailsDict;
    [self.navigationController pushViewController:controller animated:NO];
}
-(IBAction)instructionScroingButtonPressed:(id)sender{
    instructionScroingViewHeightConstant.constant = 57;
    readMoreButton.hidden = false;
    readMoreUndelineView.hidden = false;
    readMoreHeightConstant.constant = 25;
    if (sender == instructionButton) {
        instructionButton.selected = true;
        scroingButton.selected = false;
    }else{
        instructionButton.selected = false;
        scroingButton.selected = true;
    }
    [self testJson];
}

-(IBAction)readMoreButtonPressed:(id)sender{
    readMoreButton.hidden = true;
    readMoreUndelineView.hidden = true;
    readMoreHeightConstant.constant = 0;
    if (instructionButton.selected) {
        if(![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Instruction"]]){
            NSString *instructionString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Instruction"]];
            //****Instruction Level****//
            instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", instructionscoringTextView.font.fontName, instructionscoringTextView.font.pointSize,[Utility hexStringFromColor:instructionscoringTextView.textColor], instructionString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            NSString *instructionStr = strAttributed.string;
            CGSize instruction = [self findHeightForText:instructionStr havingWidth:instructionscoringTextView.layer.bounds.size.width andFont:[UIFont fontWithName:@"Oswald-ExtraLight" size:14]];
//            strheight =[self getMaxHeight:instructionStr font:[UIFont fontWithName:@"Oswald-ExtraLight" size:14]];
                instructionScroingViewHeightConstant.constant = instruction.height;
        }
    }else{
        if(![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Scoring"]]){

            NSString *scroingString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Scoring"]];
            //****Scroing Level****//
            
            scroingString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", instructionscoringTextView.font.fontName, instructionscoringTextView.font.pointSize,[Utility hexStringFromColor:instructionscoringTextView.textColor], scroingString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[scroingString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            NSString *scoringStr = strAttributed.string;
            CGSize scoring = [self findHeightForText:scoringStr havingWidth:instructionscoringTextView.layer.bounds.size.width andFont:[UIFont fontWithName:@"Oswald-ExtraLight" size:14]];
           // strheight =[self getMaxHeight:scoringStr font:[UIFont fontWithName:@"Oswald-ExtraLight" size:14]];
                instructionScroingViewHeightConstant.constant = scoring.height;
        }
    }
}
-(void)individualLeaderBoardButtonPressed{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[excerciseDetailsDict objectForKey:@"FinisherID"] forKey:@"FinisherID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IndividualLeaderBoard" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *individualLeaderDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:individualLeaderDict]) {
                                                                         LeaderBoardDetailsViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoardDetails"];
                                                                         controller.leaderBoardDetailsDict = individualLeaderDict;
                                                                         //add_su_1_com
                                                                         if ([[individualLeaderDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Battle"]) {
                                                                             controller.isbattle=true;
                                                                         }else{
                                                                             controller.isbattle=false;
                                                                         }
                                                                         [self.navigationController pushViewController:controller animated:YES];
                                                                     }
                                                                     else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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
- (IBAction)startPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    
    
    if(self->isExerciseIsSession){
        if(videoArray.count>0){
            NSDictionary *circuitDict = [videoArray firstObject];
            
            if(![Utility isEmptyCheck:circuitDict]){
                if(![Utility isEmptyCheck:circuitDict[@"ExerciseId"]] && [Utility isEmptyCheck:circuitDict[@"ExerciseVideo"]]){
                    int exSessionId = [circuitDict[@"ExerciseId"] intValue];
                    [self moveToExerciseDetails:exSessionId];
                }
            }
        }
    }else{
        isStart = true;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(timerFired:)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    
    
}
-(IBAction)stopButtonPressed:(id)sender{
    if (timer) {
        [timer invalidate];
        timer = nil;
        [stopButton setImage:[UIImage imageNamed:@"start1_challenge.png"] forState:UIControlStateNormal];
    }else{
        if (isStart) {
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(timerFired:)
                                                   userInfo:nil
                                                    repeats:YES];
            [stopButton setImage:[UIImage imageNamed:@"stop_challenge.png"] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)resetPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [UIView transitionWithView:startButton
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                    }
                    completion:^(BOOL finished){
                        self->startButton.hidden = false;
                        self->timerLabel.hidden = true;
                        self->timerLabel.text = @"";
                        self->isStart = false;
                        self->interval =0;
                        [self->stopButton setImage:[UIImage imageNamed:@"stop_challenge.png"] forState:UIControlStateNormal];
                    }
     ];
}

- (IBAction)backButtonPressed:(id)sender {
    [activeTextField resignFirstResponder];
    [self.view endEditing:YES];
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)menuButtonPressed:(id)sender {
    [activeTextField resignFirstResponder];
    
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}


- (IBAction)sessionCompleteButtonPressed:(id)sender {
    BOOL check = false;
    for (int i =0;i< selectedArray.count;i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc ]initWithDictionary:[selectedArray objectAtIndex:i]];
        if ([[dict objectForKey:@"FinisherName"] isEqualToString:[excerciseDetailsDict objectForKey:@"FinisherName"]]) {
            int number = [[dict valueForKey:@"count"]intValue];
            number = number+1;
            [dict setObject:[NSNumber numberWithInt:number] forKey:@"count"];
            [selectedArray removeObjectAtIndex:i];
            [selectedArray insertObject:dict atIndex:i];
            check = true;
            break;
        }
    }
    if (!check) {
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc]init];
        [newDict setObject:[excerciseDetailsDict objectForKey:@"FinisherName"] forKey:@"FinisherName"];
        [newDict setObject:[NSNumber numberWithInt:1] forKey:@"count"];
        [selectedArray addObject:newDict];
    }
    [defaults setObject:selectedArray forKey:@"selectedArray"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)expandButtonPressed:(UIButton*)sender {
    [activeTextField resignFirstResponder];
    
    if (indexOfExpandedCell > -1 && shouldCellBeExpanded) {
        shouldCellBeExpanded = NO;
        [table beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        [table reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath,nil ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [table endUpdates];
        if (indexOfExpandedCell !=[sender tag] ) {
            shouldCellBeExpanded = YES;
            indexOfExpandedCell = [sender tag];
            [table beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            [table reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath,nil ] withRowAnimation:UITableViewRowAnimationAutomatic];
            [table endUpdates];
        }
    }else{
        shouldCellBeExpanded = YES;
        indexOfExpandedCell = [sender tag];
        [table beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [table reloadRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath,nil ] withRowAnimation:UITableViewRowAnimationAutomatic];
        [table endUpdates];
    }
}

//,,,change new2
- (IBAction)leaderBoradButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    [self individualLeaderBoardButtonPressed];
}

- (IBAction)addScroreButtonPressed:(UIButton *)sender {
    isChanged = true;
    [activeTextField resignFirstResponder];
    
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:@"" forKey:@"Id"];
    [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
    [dict setObject:@"" forKey:@"FinisherIdFK"];
    [dict setObject:@"" forKey:@"FinisherName"];
    [dict setObject:@"" forKey:@"TaskDate"];
    [dict setObject:@"" forKey:@"Count"];
    [dict setObject:@"" forKey:@"TaskTime"];
    [dict setObject:@"" forKey:@"VideoFileName"];
    [dict setObject:@"" forKey:@"FileExerciseVideo"];
    [dict setObject:@"" forKey:@"VideoLink"];
    [dict setObject:@"" forKey:@"RespCount"];
    [dict setObject:@"0" forKey:@"Status"];
    [dict setObject:@"add" forKey:@"viewStatus"];
    
    if (scoreArray.count==0) {
        scoreArray=[[NSMutableArray alloc]init];
    }
    [scoreArray addObject:dict];
    [self.view setNeedsUpdateConstraints];
    [scoreTable reloadData];
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    isChanged = false;
    [activeTextField resignFirstResponder];
    
    scoreArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    [dict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
    [dict setObject:@"" forKey:@"FinisherIdFK"];
    [dict setObject:[excerciseDetailsDict objectForKey:@"FinisherName"] forKey:@"FinisherName"];
    [dict setObject:@"" forKey:@"FileExerciseVideo"];
    
    NSString *videoLinkStr = ![Utility isEmptyCheck:videolinkTextView.text] && ![videolinkTextView.text isEqualToString:@"Enter Video URL"] ? videolinkTextView.text : @"";
    [dict setObject:videoLinkStr forKey:@"VideoLink"];
    NSString *countStr = ![Utility isEmptyCheck:countTextField.text] ? countTextField.text : @"";
    [dict setObject:countStr forKey:@"Count"];
    NSString *repsCountStr = ![Utility isEmptyCheck:repsTextField.text] ? repsTextField.text : @"";
    [dict setObject:repsCountStr forKey:@"RepsCount"];
    NSString *mediaUrlStr = ![Utility isEmptyCheck:mediaUrl] ? mediaUrl: @"";
    [dict setObject:mediaUrlStr forKey:@"MobilePath"];
    [dict setObject:mediaUrlStr forKey:@"VideoFileName"];
    [dict setObject:@"0" forKey:@"Status"];
    if (![Utility isEmptyCheck:timeButton.titleLabel.text] && ![timeButton.titleLabel.text isEqualToString:@"Enter Time"]) {
        NSString *currentTimeStr = timeButton.titleLabel.text;
        [dict setObject:currentTimeStr forKey:@"TaskTime"];
    }
    if (![Utility isEmptyCheck:selectedDate] && ![dateButton.titleLabel.text isEqualToString:@"Enter Date"]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *currentDateStr = [dateFormatter stringFromDate:selectedDate];
        [dict setObject:currentDateStr forKey:@"TaskDate"];
    }
    [scoreArray addObject:dict];
    
    if ([self formValidation]) {
//        NSMutableArray *saveScoreArray = [[NSMutableArray alloc] initWithArray:scoreArray copyItems:YES];
//
//        NSString* filter = @"%K CONTAINS[cd] %@ || %K CONTAINS[cd] %@";
//        NSArray* args = @[@"viewStatus", @"add", @"viewStatus", @"edit"];
//        NSPredicate* predicate = [NSPredicate predicateWithFormat:filter argumentArray:args];
//
//        NSMutableArray *filteredArray = [[saveScoreArray filteredArrayUsingPredicate:predicate] mutableCopy];
//
//        for (NSMutableDictionary *filterDict in filteredArray) {
//            NSMutableDictionary *dict =[filterDict mutableCopy];
//            NSInteger Aindex = [saveScoreArray indexOfObject:dict];
//            [dict removeObjectForKey:@"viewStatus"];
//            [saveScoreArray replaceObjectAtIndex:Aindex withObject:dict];
//        }
//
//        NSLog(@"saveScoreArray...... %@",saveScoreArray);
        [self webserviceCall_SaveScoreBoard];
    }
}

- (IBAction)dateButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    
//    datePickerView.hidden=NO;
//    datePicker.hidden=NO;
//    timePicker.hidden=YES;
//
//    datePicker.tag=sender.tag;
//    //datePickerDoneButton.tag=sender.tag;
//    datePickerDoneButton.accessibilityHint=@"TaskDate";
//
//    NSMutableDictionary *dict=[[scoreArray objectAtIndex:sender.tag] mutableCopy];
//    NSString *tastDate=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskDate"]];
//    NSDate *dateFromString = [self convertDateFromString:tastDate];
//    [datePicker setDate:dateFromString];
    
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedDate = selectedDate;
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)timeButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    datePickerView.hidden=NO;
    datePicker.hidden=YES;
    timePicker.hidden=NO;
    
    //timePicker.tag=sender.tag;
    //datePickerDoneButton.tag=sender.tag;
    //datePickerDoneButton.accessibilityHint=@"TaskTime";
   
}

- (IBAction)videoButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Upload Video"
                                  message:@"Select an option"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.accessibilityHint=[@"" stringByAppendingFormat:@"%d",(int)sender.tag];
    
    UIAlertAction* gallery = [UIAlertAction actionWithTitle:@"Browse Gallery" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        
                                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                        
                                                        imagePicker.mediaTypes=[[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,nil];
                                                        
                                                        [self presentViewController:imagePicker animated:NO completion:NULL];
                                                        
                                                    }];
    
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Open Camera" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                                       {
                                                           
                                                           imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                           
                                                           NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                                                           NSArray *videoMediaTypesOnly = [mediaTypes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SELF contains %@)", @"movie"]];
                                                           
                                                           if ([videoMediaTypesOnly count] == 0)		//Is movie output possible?
                                                           {
                                                               NSLog(@"Sorry but your device does not support video recording");
                                                               //                                                                [util msg:@"Your device does not support video recording" title:@"Alert"];
                                                               
                                                               [Utility msg:@"Your device does not support video recording." title:@"Alert" controller:self haveToPop:NO];
                                                           }else{
                                                               
                                                               imagePicker.mediaTypes = videoMediaTypesOnly;
                                                               imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
                                                               //imagePicker.videoMaximumDuration = 180;			//Specify in seconds (600 is default)
                                                               [self presentViewController:imagePicker animated:NO completion:NULL];
                                                           }
                                                       }else{
                                                           //[util msg:@"Camera Not Available" title:@"Alert"];
                                                           
                                                           [Utility msg:@"Camera Not Available" title:@"Alert" controller:self haveToPop:NO];
                                                       }
                                                       
                                                       
                                                   }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:gallery];
    [alert addAction:camera];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)editScoreButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    
    NSMutableDictionary *dict=[[scoreArray objectAtIndex:sender.tag] mutableCopy];
    [dict setObject:@"edit" forKey:@"viewStatus"];
    
    //suchange
    NSString *statusString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"Status"]];
    if ([statusString isEqualToString:@"0"]) {
        [scoreArray replaceObjectAtIndex:sender.tag withObject:dict];
        [scoreTable reloadData];
    }
}

- (IBAction)deleteScoreButtonPressed:(UIButton *)sender {
    [activeTextField resignFirstResponder];
    
    if (scoreArray.count>0) {
        [scoreArray removeObjectAtIndex:sender.tag];
    }
    [scoreTable reloadData];
}

- (IBAction)shareScoreButtonPressed:(UIButton *)sender {
//    NSLog(@"%@",scoreArray[sender.tag]);
    ExcerciseDetailsShareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseDetailsShare"];
    controller.scoreDict =scoreArray[sender.tag];
    controller.excerciseDetailsDict = excerciseDetailsDict;
    controller.mainFinishSquadWowButtonTag =mainFinishSquadWowButtonTag;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)datePickerValueChange:(UIDatePicker *)sender {
    //    NSMutableDictionary *dict=[[scoreArray objectAtIndex:sender.tag] mutableCopy];
    //    NSString *tastDate=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskDate"]];
    //    NSDate *dateFromString = [self convertDateFromString:tastDate];
    //    datePicker.minimumDate = dateFromString;
}

- (IBAction)pickerDonePressed:(UIBarButtonItem *)sender {
    datePickerView.hidden=YES;
    datePicker.hidden=YES;
    timePicker.hidden=YES;
    
//    NSMutableDictionary *dict=[[scoreArray objectAtIndex:sender.tag] mutableCopy];
//    if ([sender.accessibilityHint isEqualToString:@"TaskDate"]) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        NSString *currentDate = [dateFormatter stringFromDate:datePicker.date];
//        [dict setObject:currentDate forKey:@"TaskDate"];
//        [scoreArray replaceObjectAtIndex:sender.tag withObject:dict];
//    }
//    else{
        NSString *currentTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[timePicker selectedRowInComponent:0],(long)[timePicker selectedRowInComponent:1],(long)[timePicker selectedRowInComponent:2]];
        [timeButton setTitle:currentTime forState:UIControlStateNormal];
       // [scoreArray replaceObjectAtIndex:sender.tag withObject:dict];
//    }
//    [scoreTable reloadData];
}

- (IBAction)pickerCancelPressed:(UIBarButtonItem *)sender {
    datePickerView.hidden=YES;
    datePicker.hidden=YES;
    timePicker.hidden=YES;
}
//,,,change new2
#pragma mark - End

#pragma mark - Private Method

- (void)timerFired:(NSTimer *)timer {
    interval  = interval +1;
    long min = (long)interval / 60;    // divide two longs, truncates
    long sec = (long)interval % 60;    // remainder of long divide
    NSString* string = [[NSString alloc] initWithFormat:@"%02ld:%02ld", min, sec];
    [UIView transitionWithView:startButton
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    }
                    completion:^(BOOL finished){
                        startButton.hidden = true;
                        timerLabel.hidden = false;
                        timerLabel.text = string;
                    }
     ];
}

-(float)getMaxHeight:(NSString *)text font:(UIFont*)font {
    UILabel *status = [[UILabel alloc] init];
    status.lineBreakMode = NSLineBreakByTruncatingTail;
    status.numberOfLines = 0;
    status.font = font;
    status.preferredMaxLayoutWidth = status.frame.size.width;
    status.text = text;
    CGSize generalFinePrintTextSize = [status sizeThatFits:CGSizeMake(status.frame.size.width, FLT_MAX)];
    [status setNeedsDisplay];
    float minCheck = 44.00;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        minCheck = 44;
    }
    if (generalFinePrintTextSize.height <= minCheck &&  generalFinePrintTextSize.height > 0) {
        return minCheck;
    }else{
        return generalFinePrintTextSize.height+20;
    }
}
- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 40);
    }
    return size;
}

-(void)testJson{
        if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"FinisherName"]]) {
            exName.text = [excerciseDetailsDict objectForKey:@"FinisherName"];
        }
    
    if (instructionButton.selected) {
        if(![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Instruction"]]){
            NSString *instructionString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Instruction"]];
            //****Instruction Level****//
            instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", instructionscoringTextView.font.fontName, instructionscoringTextView.font.pointSize,[Utility hexStringFromColor:instructionscoringTextView.textColor], instructionString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            instructionscoringTextView.attributedText = strAttributed;
        }
    }else{
        if(![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Scoring"]]){
            
            NSString *scroingString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Scoring"]];
            //****Scroing Level****//
            
            scroingString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", instructionscoringTextView.font.fontName, instructionscoringTextView.font.pointSize,[Utility hexStringFromColor:instructionscoringTextView.textColor], scroingString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[scroingString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];

            instructionscoringTextView.attributedText = strAttributed;
        }
    }
}

-(CGRect)changeLabelHeight:(CGRect )rect newHeight:(float)newHeight{
    CGRect tempRect =rect;
    tempRect.size.height = newHeight;
    return tempRect;
}

-(NSDate *) convertDateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    if (dateFromString == nil) {
        dateFromString =[NSDate date];
    }
    return dateFromString;
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

-(BOOL)formValidation{
    BOOL isValidated = NO;
    NSDictionary *checkDict = [scoreArray objectAtIndex:0];
    if([Utility isEmptyCheck:[checkDict valueForKey:@"TaskDate"]]){
        [Utility msg:@"Please Enter Score Date" title:@"" controller:self haveToPop:NO];
        return isValidated;
    }
    else if([Utility isEmptyCheck:[checkDict valueForKey:@"Count"]] && !willCountHidden){
        [Utility msg:@"Please Enter Score Count" title:@"" controller:self haveToPop:NO];
        return isValidated;
    }
    else if([Utility isEmptyCheck:[checkDict valueForKey:@"TaskTime"]] && !willTimeHidden){
        [Utility msg:@"Please Enter Score Time" title:@"" controller:self haveToPop:NO];
        return isValidated;
    }
    return YES;
}

-(BOOL)doesString:(NSString *)string containString:(NSString *)containString
{
    if ([string rangeOfString:containString].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

-(void)setup_view{
    shouldCellBeExpanded = NO;
    indexOfExpandedCell = -1;
    sectionOfExpandedCell = -1;
    [self registerForKeyboardNotifications];
    selectedArray = [[defaults objectForKey:@"selectedArray"] mutableCopy];
    if (!selectedArray) {
        selectedArray = [[NSMutableArray alloc]init];
    }
    
    saveButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    saveButton.layer.borderWidth = 1;
    
    previousActivityButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    previousActivityButton.layer.borderWidth = 1;
    
    viewleaderBoardButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    viewleaderBoardButton.layer.borderWidth = 1;
    
    dateView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    dateView.layer.borderWidth = 1.124f;
    
    videoLinkView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    videoLinkView.layer.borderWidth = 1.124f;
    
    
    NSLog(@"excerciseDetailsDict-%@",excerciseDetailsDict);
    
    NSString *numberOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"NumberOrder"]];
    willCountHidden = ([numberOrder isEqualToString:@"(null)"] || [numberOrder isEqualToString:@"<null>"]) ? YES : NO;
    
    NSString *timeOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"TimeOrder"]];
    willTimeHidden = ([timeOrder isEqualToString:@"(null)"] || [timeOrder isEqualToString:@"<null>"]) ? YES : NO;
    
    NSString *repsNumber=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsNumber"]];
    willRepsHidden = ([repsNumber isEqualToString:@"(null)"] || [repsNumber isEqualToString:@"<null>"]) ? YES : NO;
    
    unitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"UnitName"]];
    unitName = (![unitName isEqualToString:@"(null)"] && ![unitName isEqualToString:@"<null>"]) ? unitName : @"";
    
    repsUnitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsUnitName"]];
    repsUnitName = (![repsUnitName isEqualToString:@"(null)"] && ![repsUnitName isEqualToString:@"<null>"]) ? repsUnitName : @"";
    
    
    if (willCountHidden) {
        [stack removeArrangedSubview:countView];
        [countView removeFromSuperview];
    }else{
        countLabel.text = unitName;
        countTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",unitName];
        countTextFieldView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
        countTextFieldView.layer.borderWidth = 1;
    }
    
    if (willRepsHidden) {
        [stack removeArrangedSubview:repsView];
        [repsView removeFromSuperview];
    }else{
        repsLabel.text = repsUnitName;
        repsTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",repsUnitName];
        repsTextFieldView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
        repsTextFieldView.layer.borderWidth = 1;
    }
    
    if (willTimeHidden) {
        [stack removeArrangedSubview:timeView];
        [timeView removeFromSuperview];
    }else{
        timeLabel.text = @"Time";
        [timeButton setTitle:@"Enter Time" forState:UIControlStateNormal];
        timeTextFiledView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
        timeTextFiledView.layer.borderWidth = 1;
    }
    [dateButton setTitle:@"Enter Date" forState:UIControlStateNormal];
    videolinkTextView.text = @"Enter Video URL";
    if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Priority"]]) {
        int prirityValue = [[excerciseDetailsDict objectForKey:@"Priority"]intValue];
        lastOne = prirityValue % 10; //is 3
        firstOne= (prirityValue - lastOne)/10; //is 53-3=50 /10 =5
        NSLog(@"Last-%d",lastOne);
        NSLog(@"First-%d",firstOne);
        
        if (firstOne >0) {
            if (firstOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [stack insertArrangedSubview:countView atIndex:0];
                }
            }else if (firstOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [stack insertArrangedSubview:timeView atIndex:0];
                }
                
            }else if (firstOne == 3){//RespUnitname
                if (!willRepsHidden) {
                    [stack insertArrangedSubview:repsView atIndex:0];
                }
            }
        }
        if (lastOne>0 && firstOne>0){
            if (lastOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [stack insertArrangedSubview:countView atIndex:1];
                    
                }
            }else if (lastOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [stack insertArrangedSubview:timeView atIndex:1];
                }
                
            }else if (lastOne == 3){//RespUnitname
                if (!willRepsHidden) {
                    [stack insertArrangedSubview:repsView atIndex:1];
                }
            }
        }else{
            if (lastOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [stack insertArrangedSubview:countView atIndex:0];
                    
                }
            }else if (lastOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [stack insertArrangedSubview:timeView atIndex:0];
                }
                
            }else if (lastOne == 3){//RespUnitname
                if (!willRepsHidden) {
                    [stack insertArrangedSubview:repsView atIndex:0];
                }
            }
        }
    }
    if (firstOne !=2 && lastOne !=2 && !willTimeHidden) {
        if (firstOne >0 && lastOne>0) {
            [stack insertArrangedSubview:timeView atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [stack insertArrangedSubview:timeView atIndex:1];
        }else if((firstOne<0 && lastOne>0)){
            [stack insertArrangedSubview:timeView atIndex:0];
        }
    }
    if (firstOne !=1 && lastOne !=1 && !willCountHidden) {
        if (firstOne >0 && lastOne>0) {
            [stack insertArrangedSubview:countView atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [stack insertArrangedSubview:countView atIndex:1];
        }else if((firstOne<0 && lastOne>0)){
            [stack insertArrangedSubview:countView atIndex:0];
        }
    }
    
    if (firstOne !=3 && lastOne !=3 && !willRepsHidden) {
        if (firstOne >0 && lastOne>0) {
            [stack insertArrangedSubview:repsView atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [stack insertArrangedSubview:repsView atIndex:1];
        }else if((firstOne<0 && lastOne>0)){
            [stack insertArrangedSubview:repsView atIndex:0];
        }
    }
}


- (void)shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (isChanged) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveButtonPressed:nil];
                                       isChanged = NO;
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}


#pragma mark -WebserviceCall
-(void)webserviceCall_SaveScoreBoard{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;

        NSString *finisherID = [NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"FinisherID"]];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:finisherID forKey:@"FinisherId"];
        
        [mainDict setObject:scoreArray forKey:@"TaskDetail"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        //http://192.168.3.131:61430//api/GetScoreBoard
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveScoreBoard" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSDictionary *finisherDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherDict]) {
                                                                         //NSDictionary *taskDetailsDict =[finisherDict objectForKey:@"TaskDetail"];
                                                                         
                                                                         NSArray *dataArray=[finisherDict objectForKey:@"TaskDetail"];
                                                                         
                                                                         isvideoupload =true;
                                                                         
                                                                         if (![Utility isEmptyCheck:dataArray]) {
                                                                                 NSDictionary *dict = [dataArray objectAtIndex:0];
                                                                                 if (![Utility isEmptyCheck:dict]) {
                                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"MobilePath"]]&& ![[dict objectForKey:@"MobilePath"] isEqualToString:@""]) {
                                                                                         isvideoupload=false;
                                                                                         [self webserviceCall_uploadVideo:dataArray];
                                                                                     }
                                                                                 }
                                                                         }
                                                                         if (isvideoupload) {
                                                                             if (contentView) {
                                                                                 [contentView removeFromSuperview];
                                                                                 [Utility msg:@"Updated Successfully" title:@"Success" controller:self haveToPop:NO];
                                                                                 [dateButton setTitle:@"Enter Date" forState:UIControlStateNormal];
                                                                                  if (!willCountHidden) {
                                                                                      countTextField.text =@"";
                                                                                      countTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",unitName];
                                                                                  }
                                                                                 if (!willRepsHidden) {
                                                                                     repsTextField.text =@"";
                                                                                     repsTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",repsUnitName];
                                                                                 }
                                                                                 if (!willTimeHidden) {
                                                                                      [timeButton setTitle:@"Enter Time" forState:UIControlStateNormal];
                                                                                 }
                                                                                 videolinkTextView.text = @"Enter Video URL";
                                                                                 videoLabel.hidden = true;
                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                                                                             }
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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

-(void)webserviceCall_uploadVideo:(NSArray *)dataArray{
 
    if (Utility.reachable) {
            NSDictionary *dataDict=[dataArray objectAtIndex:0];
            
//            NSString *stringUrl=[@"" stringByAppendingFormat:@"%@",[dataDict objectForKey:@"MobilePath"]];
//            NSURL *fileUrl=[NSURL URLWithString:stringUrl];
        
            ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
            controller.delegate=self;
            controller.apiName=@"UploadExecriseVideo";
            controller.appendString=@"";
            controller.videoDataDict = dataDict;
            controller.isvideo = true;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
}


-(void)webserviceCallForGetScoreBoard{
    if (Utility.reachable) {
        //dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        //});
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSString *finisherID = [NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"FinisherID"]];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:finisherID forKey:@"FinisherId"];

        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        //http://192.168.3.131:61430//api/GetScoreBoard
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetScoreBoard" append:@""forAction:@"POST"];
        
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
                                                                     NSArray *finisherArray= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherArray]) {
                                                                     
                                                                    if (![Utility isEmptyCheck:responseString]) {
                                                                         
                                                                         scoreArray = [finisherArray mutableCopy];
                                                                         
                                                                         if (![Utility isEmptyCheck:scoreArray]) {
                                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                                         [self.view setNeedsUpdateConstraints];
                                                                         [scoreTable reloadData];
                                                                           });
                                                                         }
                                                                     }
                                                                     else{
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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
}//,,,change new1

-(void)getExerciseDetails:(int)exSessionId isMoveToSession:(BOOL)isMove{
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];//@"3269"
        //NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetWorkoutDetailsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&ExerciseSessionId=%d&personalisedOne=%@",[defaults objectForKey:@"UserID"],_exSessionId,[[exerciseData objectForKey:@"IsPersonalisedSession"] boolValue]? @"true" : @"false"] forAction:@"GET"];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetWorkoutDetailsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&ExerciseSessionId=%d&personalisedOne=%@",[defaults objectForKey:@"ABBBCOnlineUserId"],exSessionId,@"false"] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         
                                                                         self->isExerciseIsSession = true;
                                                                         self->resetButton.hidden = true;
                                                                         self->stopButton.hidden = true;
                                                                         
                                                                         if(isMove)[self moveToExerciseDetails:exSessionId];
                                                                         
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
        
    
    
}

-(void)moveToExerciseDetails:(int)exerciseSessionId{
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.exSessionId = exerciseSessionId;
    controller.completeSessionId = exerciseSessionId; //AY 04042018
    controller.sessionDate = @"";  //ah 2.2
    controller.fromWhere = @"DailyWorkout";
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)checkIsSession{
    
    if(videoArray.count>0){
        NSDictionary *circuitDict = [videoArray firstObject];
        
        if(![Utility isEmptyCheck:circuitDict]){
            if(![Utility isEmptyCheck:circuitDict[@"ExerciseId"]] && [Utility isEmptyCheck:circuitDict[@"ExerciseVideo"]]){
                int exSessionId = [circuitDict[@"ExerciseId"] intValue];
                [self getExerciseDetails:exSessionId isMoveToSession:NO];
            }
        }
    }
    
    
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    util = [[Utility alloc]init];
    videoArray=[[NSMutableArray alloc]init];
    scoreArray =[[NSMutableArray alloc]init];//,,,change new1
    scoreTable.dataSource=self;
    scoreTable.delegate=self;
    [shareButton setTitle:@"Approved First" forState:UIControlStateNormal];
    datePicker.backgroundColor=[UIColor whiteColor];
    datePickerView.hidden=YES;
    isChanged = false;
    
    if (![Utility isEmptyCheck:excerciseDetailsDict]) { //add_su_1_com
        if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"ExerciseListDetail"]]) {
            videoArray = [excerciseDetailsDict objectForKey:@"ExerciseListDetail"];
            [self checkIsSession];
        }
        
    }
    
    NSString *typeCheck = [[excerciseDetailsDict objectForKey:@"FinisherTypeDetail"]objectForKey:@"TypeName"];
    if (![Utility isEmptyCheck:typeCheck]) {
        if ([typeCheck isEqualToString:@"Squad WOW Session"]) {
            if (![Utility isEmptyCheck:videoArray] && videoArray.count>0) {
                excerciseCollection.hidden = false;
                collectionViewHeightConstant.constant = 50;
                [excerciseCollection reloadData];
            }
            table.tableHeaderView = nil;
            excerciseLabelView.hidden = true;
            excerciseLabelHeightConstatnt.constant = 0;
        }else{
            excerciseCollection.hidden = true;
            collectionViewHeightConstant.constant = 0;
            if (![Utility isEmptyCheck:videoArray] && videoArray.count>0) {
                table.tableHeaderView = table.tableHeaderView;
                excerciseLabelView.hidden = false;
                excerciseLabelHeightConstatnt.constant = 44;
            }else{
                table.tableHeaderView = nil;
                excerciseLabelView.hidden = true;
                excerciseLabelHeightConstatnt.constant = 0;
            }
        }
    }else{
        excerciseCollection.hidden = true;
        collectionViewHeightConstant.constant = 0;
        if (![Utility isEmptyCheck:videoArray] && videoArray.count>0) {
            table.tableHeaderView = table.tableHeaderView;
            excerciseLabelView.hidden = false;
            excerciseLabelHeightConstatnt.constant = 44;
        }else{
            table.tableHeaderView = nil;
            excerciseLabelView.hidden = true;
            excerciseLabelHeightConstatnt.constant = 0;
        }
    }
    instructionButton.selected = true;
    scroingButton.selected = false;
    instructionScroingViewHeightConstant.constant = 57; //
    [self testJson];
    [stack insertArrangedSubview:countView atIndex:0];
    [stack insertArrangedSubview:repsView atIndex:1];
    [stack insertArrangedSubview:timeView atIndex:2];
    [self setup_view];
  //  [self webserviceCallForGetScoreBoard];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self createPickerView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [player pause];
    playerViewController.player = nil;
    [playerViewController willMoveToParentViewController:nil];
    player = nil;
    mediaUrl=nil;
    playerViewController = nil;
    [defaults setObject:nil forKey:@"share"];
    [table removeObserver:self forKeyPath:@"contentSize"]; //add_add

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    table.estimatedRowHeight = 100;
    table.rowHeight = UITableViewAutomaticDimension;
    [table addObserver:self forKeyPath:@"contentSize" options:0 context:NULL]; //add_add

    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
        controller.delegateMasterMenu=self;
        //        masterMenu=controller;
        self.slidingViewController.underLeftViewController  = controller;
    }
    if(![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"FinisherName"]]){
        NSString *charString=[excerciseDetailsDict objectForKey:@"FinisherName"];
        NSArray* myArray = [charString  componentsSeparatedByString:@"("];
        NSString *lastChar=@"";
        if (myArray.count>1) {
            NSString *string = [myArray objectAtIndex:0];
            NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            lastChar = [trimmedString substringFromIndex:[string length] - 2];
        }
        else{
            lastChar = [[myArray objectAtIndex:0] substringFromIndex:[[myArray objectAtIndex:0] length] - 1];
        }
        if ([lastChar isEqualToString:@"*"]) {
            equipmentLabel.hidden=false;
        }
        else{
            equipmentLabel.hidden=true;
        }
    }
    if (![Utility isEmptyCheck:mediaUrl]) {
        videoLabel.hidden = false;
    }else{
        videoLabel.hidden = true;
    }
    [defaults setObject:nil forKey:@"share"];
}
#pragma mark - End

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == table) {
        tableHeightConstraints.constant=table.contentSize.height;
    }
}
#pragma mark - PickerView
-(void)createPickerView{
    // assumes global UIPickerView declared. Move the frame to wherever you want it
    
    timePicker = [[UIPickerView alloc] initWithFrame:datePicker.frame];
    timePicker.dataSource = self;
    timePicker.delegate = self;
    
    UIFont *font=fontMacro(@"Raleway-Medium", 18);
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(datePicker.frame.size.width/3-40, timePicker.frame.size.height / 2 - 15, 40, 30)];
    hourLabel.font=font;
    hourLabel.text = @"hour";
    hourLabel.textAlignment=NSTextAlignmentLeft;
    [timePicker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(datePicker.frame.size.width/3-40 + (timePicker.frame.size.width / 3), timePicker.frame.size.height / 2 - 15, 40, 30)];
    minsLabel.font=font;
    minsLabel.text = @"min";
    minsLabel.textAlignment=NSTextAlignmentLeft;
    [timePicker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(datePicker.frame.size.width/3-40 + ((timePicker.frame.size.width / 3) * 2), timePicker.frame.size.height / 2 - 15, 40, 30)];
    secsLabel.font=font;
    secsLabel.text = @"sec";
    secsLabel.textAlignment=NSTextAlignmentLeft;
    [timePicker addSubview:secsLabel];
    
    [datePickerView addSubview:timePicker];
    datePickerView.hidden=YES;
    datePicker.hidden=YES;
    timePicker.hidden=YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
        return 24;
    else if (component == 2)
        return 59;
    return 60;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, datePicker.frame.size.width/3, 30)];
    columnView.text = [NSString stringWithFormat:@"%02lu", (long) row];
    if (component == 2){
        columnView.text = [NSString stringWithFormat:@"%02lu", (long) row];
    }
    columnView.font=fontMacro(@"Raleway-Medium", 20);
    columnView.textAlignment = NSTextAlignmentCenter;
    return columnView;
}
#pragma mark - End

#pragma mark - UICollectionViewDataSource & Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return videoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ExcerciseDetailsCollectionViewCell";
    ExcerciseDetailsCollectionViewCell *cell = (ExcerciseDetailsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
    cell.sessionLabel.text = [dict objectForKey:@"ExerciseName"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [videoArray objectAtIndex:indexPath.row];
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.exSessionId = [[dict objectForKey:@"ExerciseId"] intValue];
    controller.sessionDate = @"";  //ah 2.2
    controller.isExDetails = true;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - End
#pragma mark - UITableViewDatasource & UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:table]) {
         float cellHeight  = 0.0;
        NSDictionary *videoDataDict = [videoArray objectAtIndex:indexPath.row];
        float height = 0;

        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"ExerciseName"]]) {
            height =[self getMaxHeight:[videoDataDict objectForKey:@"ExerciseName"] font:[UIFont fontWithName:@"Raleway-Bold" size:16]];
        }
        NSString *detailString = @"";
        
        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Reps"]]) {
            detailString = [detailString stringByAppendingFormat:@"REPS = %@    ",[videoDataDict objectForKey:@"Reps"]];
        }
        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Sets"]]) {
            detailString = [detailString stringByAppendingFormat:@"SETS = %@    ",[videoDataDict objectForKey:@"Sets"]];
        }
        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Rest"]]){
            detailString = [detailString stringByAppendingFormat:@"REST = %@    ",[videoDataDict objectForKey:@"Rest"]];
        }

        if (detailString != nil && ![detailString isEqualToString:@""]) {
            cellHeight = cellHeight+[self getMaxHeight:detailString font:[UIFont fontWithName:@"Raleway-Bold" size:12+ipadExtraFontSize]];
        }
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            cellHeight = cellHeight + 14+10+1;
        }else{
            cellHeight = cellHeight + 30+10+1;
        }
        
        if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
            if(shouldCellBeExpanded && [indexPath row] == indexOfExpandedCell) {
                return height+175;
            }
            else{
                return height;
            }
        }
        else
        {
            if(shouldCellBeExpanded && [indexPath row] == indexOfExpandedCell) {
                return height+297;
            }
            else{
                return height;
            }
        }
    }else{
        int count=0;
        if(willCountHidden){
            count++;
        }
        
        if(willRepsHidden){
            count++;
        }
        
        if(willTimeHidden){
            count++;
        }
        
        return SCORE_TABLE_HEIGHT-(SCORE_TABLE_CONTENT_VIEW_HEIGHT*count);
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:table]) {
        return [videoArray count];    //count number of row from counting array hear cataGorry is An Array
    }
    else{
        return scoreArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:table]) {
        NSString *CellIdentifier = @"IndividulaTableViewCell";
        IndividulaTableViewCell *cell;
        cell=[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[IndividulaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *videoDataDict = [videoArray objectAtIndex:indexPath.row];

        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"ExerciseName"]]) {
            
            NSString *detailString = @"";
            if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Reps"]]) {
                detailString = [detailString stringByAppendingFormat:@"REPS = %@    ",[videoDataDict objectForKey:@"Reps"]];
            }
            if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Sets"]]) {
                detailString = [detailString stringByAppendingFormat:@"SETS = %@    ",[videoDataDict objectForKey:@"Sets"]];
            }
            if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"Rest"]]){
                detailString = [detailString stringByAppendingFormat:@"REST = %@    ",[videoDataDict objectForKey:@"Rest"]];
            }
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[videoDataDict objectForKey:@"ExerciseName"]]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-ExtraLight" size:17] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"58595b"] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"\n%@",detailString]];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:11] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"6d6e70"] range:NSMakeRange(0, [attributedString2 length])];
            
            [attributedString appendAttributedString:attributedString2];
            cell.exerciseName.attributedText = attributedString;
        }
        
        if (![Utility isEmptyCheck:[videoDataDict objectForKey:@"exerciseImage"]]) {
            [cell.exerciseImage sd_setImageWithURL:[NSURL URLWithString:[videoDataDict objectForKey:@"exerciseImage"]] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
        }else{
            cell.exerciseImage.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
        }

        [[cell expandButton] setTag:[indexPath row]];
        cell.expandButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row ];
        
        //    NSString *videoId = [videoDataDict objectForKey:@"excerciseurl"];
        NSString *videoId = [videoDataDict objectForKey:@"ExerciseVideo"];//,,,change new1
        if (![Utility isEmptyCheck:videoId]) {
            if ([videoId isEqualToString:@"No Video"]) {
                cell.expandButton.hidden = true;
            }
            else{
                cell.expandButton.hidden = false;
            }
        }
        
        if(shouldCellBeExpanded && [indexPath row] == indexOfExpandedCell)
        {
            if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
                cell.detailsViewHeightConstraint.constant= 175;
            }else{
                cell.detailsViewHeightConstraint.constant= 297;
            }
            
            cell.detailsView.hidden = false;
            if (cell.playerController.player && indexPath.row == indexOfExpandedCell) {
                [playerViewController.player pause];
                return cell;
            }
            [player pause];
            playerViewController.player = nil;
            player = nil;
            playerViewController = [[AVPlayerViewController alloc]init];
            
            
            videoId = [videoId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            videoId = [videoId stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            if (![videoId isEqualToString:@""] && videoId !=nil) {
                NSURL *videoUrl = [NSURL URLWithString:videoId];
                player = [AVPlayer playerWithURL:videoUrl];
                [player play];
                playerViewController = [[AVPlayerViewController alloc]init];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = YES;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                [cell.playerView addSubview:playerViewController.view];
                playerViewController.view.frame = cell.playerView.bounds;
                cell.playerController = playerViewController;
            }else{
                cell.expandButton.hidden = true;
            }
            
        }else{
            cell.detailsViewHeightConstraint.constant= 0;
            cell.detailsView.hidden = true;
            if (indexPath.row == indexOfExpandedCell && playerViewController) {
                [player pause];
                playerViewController.player = nil;
                [playerViewController willMoveToParentViewController:nil];
                player = nil;
                playerViewController = nil;
                cell.playerController = nil;
            }
        }
        [self.view setNeedsUpdateConstraints];//,,,change new2
        return cell;
        
    }else{
        NSString *CellIdentifier = @"ViewScoreTableCell";
        ViewScoreTableCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ViewScoreTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //add on 22/2/17
//        [cell.stackView removeArrangedSubview:cell.countView];
//        [cell.stackView removeArrangedSubview:cell.repsView];
//        [cell.stackView removeArrangedSubview:cell.timeView];

        if(willCountHidden){
            cell.countContainerHeightConstraints.constant=0.0;
            cell.countLabelHeightConstraints.constant=0.0;
            cell.countTextFieldTopConstraints.constant=0.0;
            cell.countTextFieldHeightConstraints.constant=0.0;
            
            cell.countLabel.hidden=true;
            cell.countTextfield.hidden=true;
            
            [cell.stackView removeArrangedSubview:cell.countView];

        }else{
            cell.countLabel.text=unitName;
        }
        
        if(willRepsHidden){
            cell.repsContainerHeightConstraints.constant=0.0;
            cell.repsLabelHeightConstraints.constant=0.0;
            cell.repsTextFieldTopConstraints.constant=0.0;
            cell.repsTextFieldHeightConstraints.constant=0.0;
            cell.repsLabel.hidden=true;
            cell.repstextField.hidden=true;
            
            cell.repsLabel.hidden=true;
            cell.repstextField.hidden=true;

            [cell.stackView removeArrangedSubview:cell.repsView];

        }else{
            
            cell.repsLabel.text=repsUnitName;
        }
        
        if(willTimeHidden){
            cell.timeContainerHeightConstraints.constant=0.0;
            cell.timeLabelHeightConstraints.constant=0.0;
            cell.timeButtonTopConstraints.constant=0.0;
            cell.timeButtonHeightConstraints.constant=0.0;
            
            cell.timeButton.hidden=true;
            cell.timeLabel.hidden=true;

            [cell.stackView removeArrangedSubview:cell.timeView];
        }else{
            cell.timeLabel.hidden=false;
            cell.timeButton.hidden=false;
        }
      
        //End
        
        NSDictionary *dict=[scoreArray objectAtIndex:indexPath.row];
        //add on 22/2/17
        if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Priority"]]) {
            int prirityValue = [[excerciseDetailsDict objectForKey:@"Priority"]intValue];
            lastOne = prirityValue % 10; //is 3
            firstOne= (prirityValue - lastOne)/10; //is 53-3=50 /10 =5
            NSLog(@"Last-%d",lastOne);
            NSLog(@"First-%d",firstOne);
            
            if (firstOne >0) {
                if (firstOne == 1) {//NumberOrder
                    if (!willCountHidden) {
                        [cell.stackView insertArrangedSubview:cell.countView atIndex:0];
                    }
                }else if (firstOne == 2){//TimeOrder
                    if (!willTimeHidden) {
                        [cell.stackView insertArrangedSubview:cell.timeView atIndex:0];
                   }
                    
                }else if (firstOne == 3){//RespUnitname
                    if (!willRepsHidden) {
                        [cell.stackView insertArrangedSubview:cell.repsView atIndex:0];
                    }
                }
            }
            if (lastOne>0 && firstOne>0){
                if (lastOne == 1) {//NumberOrder
                    if (!willCountHidden) {
                        [cell.stackView insertArrangedSubview:cell.countView atIndex:1];

                    }
                }else if (lastOne == 2){//TimeOrder
                    if (!willTimeHidden) {
                         [cell.stackView insertArrangedSubview:cell.timeView atIndex:1];
                    }
                    
                }else if (lastOne == 3){//RespUnitname
                    if (!willRepsHidden) {
                        [cell.stackView insertArrangedSubview:cell.repsView atIndex:1];
                    }
                }
            }else{
                if (lastOne == 1) {//NumberOrder
                    if (!willCountHidden) {
                        [cell.stackView insertArrangedSubview:cell.countView atIndex:0];
                        
                    }
                }else if (lastOne == 2){//TimeOrder
                    if (!willTimeHidden) {
                        [cell.stackView insertArrangedSubview:cell.timeView atIndex:0];
                    }
                    
                }else if (lastOne == 3){//RespUnitname
                    if (!willRepsHidden) {
                        [cell.stackView insertArrangedSubview:cell.repsView atIndex:0];
                    }
                }
            }
        }
        if (firstOne !=2 && lastOne !=2 && !willTimeHidden) {
            if (firstOne >0 && lastOne>0) {
                [cell.stackView insertArrangedSubview:cell.timeView atIndex:2];
            }else if(firstOne>0 && lastOne<0){
                [cell.stackView insertArrangedSubview:cell.timeView atIndex:1];
            }else if((firstOne<0 && lastOne>0)){
                [cell.stackView insertArrangedSubview:cell.timeView atIndex:0];
            }
        }
        if (firstOne !=1 && lastOne !=1 && !willCountHidden) {
            if (firstOne >0 && lastOne>0) {
                [cell.stackView insertArrangedSubview:cell.countView atIndex:2];
            }else if(firstOne>0 && lastOne<0){
                [cell.stackView insertArrangedSubview:cell.countView atIndex:1];
            }else if((firstOne<0 && lastOne>0)){
                [cell.stackView insertArrangedSubview:cell.countView atIndex:0];
            }
        }

        if (firstOne !=3 && lastOne !=3 && !willRepsHidden) {
            if (firstOne >0 && lastOne>0) {
                [cell.stackView insertArrangedSubview:cell.repsView atIndex:2];
            }else if(firstOne>0 && lastOne<0){
                [cell.stackView insertArrangedSubview:cell.repsView atIndex:1];
            }else if((firstOne<0 && lastOne>0)){
                [cell.stackView insertArrangedSubview:cell.repsView atIndex:0];
            }
        }
        
        //Ternary Operator
        //condition ? valueIfTrue : valueIfFalse
        NSString *idString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
        idString = (![idString isEqualToString:@"(null)"] && ![idString isEqualToString:@"<null>"]) ? idString : @"";
        
        NSString *respCountString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"RepsCount"]];
        respCountString = (![respCountString isEqualToString:@"(null)"] && ![respCountString isEqualToString:@"<null>"]) ? respCountString : @"";
        
        cell.repstextField.text=respCountString; ////Added on 27-Oct-2016 //AmitY
        
        NSString *statusString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Status"]];
        statusString = (![statusString isEqualToString:@"(null)"] && ![statusString isEqualToString:@"<null>"]) ? statusString : @"";
        
        NSString *taskDateString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskDate"]] ;
        taskDateString = (![taskDateString isEqualToString:@"(null)"] && ![taskDateString isEqualToString:@"<null>"]) ? taskDateString : @"";
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        NSDate *yourDate = [dateFormatter dateFromString:taskDateString];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        NSString *dateString=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
        dateString = (![dateString isEqualToString:@"(null)"] && ![dateString isEqualToString:@"<null>"]) ? dateString : @"";
        [cell.dateButton setTitle:dateString forState:UIControlStateNormal];
        
        
        NSString *countString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Count"]];
        countString = (![countString isEqualToString:@"(null)"] && ![countString isEqualToString:@"<null>"]) ? countString : @"";
        cell.countTextfield.text=countString;
        
        NSString *taskTimeString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskTime"]];
        taskTimeString = (![taskTimeString isEqualToString:@"(null)"] && ![taskTimeString isEqualToString:@"<null>"]) ? taskTimeString : @"";
        [cell.timeButton setTitle:taskTimeString forState:UIControlStateNormal];

        
        NSString *videoLinkName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"VideoLink"]];
        videoLinkName = (![videoLinkName isEqualToString:@"(null)"] && ![videoLinkName isEqualToString:@"<null>"]) ? videoLinkName : @"";
        cell.videoTextfield.text=videoLinkName;

        NSString *videoFileName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"VideoFileName"]];
        videoFileName = (![videoFileName isEqualToString:@"(null)"] && ![videoFileName isEqualToString:@"<null>"]) ? videoFileName : @"";
        cell.videoNametextField.text=videoFileName;
        
        if ([Utility isEmptyCheck:videoFileName]) {
            cell.videoPlayButton.hidden=true;
        }
        else{
            cell.videoPlayButton.hidden=false;
        }
        
        cell.backgroundCellView.layer.cornerRadius=5.0;
        
        cell.dateButton.tag=indexPath.row;
        cell.dateButton.accessibilityHint=@"dateButton";
        
        cell.calenderButton.tag=indexPath.row;
        cell.calenderButton.accessibilityHint=@"calenderButton";
        
        cell.countTextfield.tag=indexPath.row;
        cell.countTextfield.accessibilityHint=@"countTextfield";
        
        cell.repstextField.tag=indexPath.row;
        cell.repstextField.accessibilityHint=@"repsTextfield";
        
        cell.timeButton.tag=indexPath.row;
        cell.timeButton.accessibilityHint=@"timeButton";
        
        cell.videoTextfield.tag=indexPath.row;
        cell.videoTextfield.accessibilityHint=@"videoTextfield";
        
        cell.videoUploadButton.tag=indexPath.row;
        cell.videoUploadButton.accessibilityHint=@"videoUploadButton";
        
        cell.videoNametextField.tag=indexPath.row;
        cell.videoNametextField.accessibilityHint=@"videoTextfield";
        
        cell.editButton.tag=indexPath.row;
        cell.editButton.accessibilityHint=@"editButton";
        
        cell.deleteButton.tag=indexPath.row;
        cell.deleteButton.accessibilityHint=@"deleteButton";
        
        cell.shareButton.tag=indexPath.row;
        cell.shareButton.accessibilityHint=@"shareButton";
        
        cell.videoPlayButton.tag = indexPath.row;
        cell.videoPlayButton.accessibilityHint = @"videoPlay";
        
        NSString *viewStatus=[NSString stringWithFormat:@"%@",[dict objectForKey:@"viewStatus"]];
        
        if ([viewStatus isEqualToString:@"add"] || [viewStatus isEqualToString:@"edit"]) { //AmitY 3-Nov-2016
            
            if ([viewStatus isEqualToString:@"add"]) {
                cell.editButton.hidden=YES;
                cell.shareButton.hidden=YES;
            }else{
                cell.editButton.hidden=NO;
                cell.shareButton.hidden=NO;
            }
            
            cell.dateLabelHeightConstraints.constant=20;
            if(!willCountHidden){
                cell.countLabelHeightConstraints.constant=20;
            }
            
            if(!willRepsHidden){
            cell.repsLabelHeightConstraints.constant=20;
            }
            
            if(!willTimeHidden){
            cell.timeLabelHeightConstraints.constant=20;
            }
            cell.videoLinkLabelHeightConstraints.constant=20;
            cell.videoNameLabelHeightConstraints.constant=20;
            
            cell.dateButton.userInteractionEnabled=YES;
            cell.calenderButton.hidden=NO;
            cell.countTextfield.userInteractionEnabled=YES;
            cell.repstextField.userInteractionEnabled=YES;
            cell.timeButton.userInteractionEnabled=YES;
            cell.videoTextfield.userInteractionEnabled=YES;
            cell.videoUploadButton.hidden=NO;
            
            [cell.dateButton layoutIfNeeded];
            cell.dateButton.clipsToBounds = YES;
            CALayer *dateBottomBorder = [CALayer layer];
            dateBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            dateBottomBorder.borderWidth = 1.4f;
            dateBottomBorder.frame = CGRectMake(0.0f, cell.dateButton.frame.size.height - 1, cell.dateButton.frame.size.width, 1);
            [cell.dateButton.layer addSublayer:dateBottomBorder];
            
            [cell.countTextfield layoutIfNeeded];
            cell.countTextfield.clipsToBounds = YES;
            CALayer *countBottomBorder = [CALayer layer];
            countBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            countBottomBorder.borderWidth = 1.4f;
            countBottomBorder.frame = CGRectMake(0.0f, cell.countTextfield.frame.size.height - 1, cell.countTextfield.frame.size.width, 1);
            [cell.countTextfield.layer addSublayer:countBottomBorder];
            
            [cell.repstextField layoutIfNeeded];
            cell.repstextField.clipsToBounds = YES;
            CALayer *repsBottomBorder = [CALayer layer];
            repsBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            repsBottomBorder.borderWidth = 1.4f;
            repsBottomBorder.frame = CGRectMake(0.0f, cell.repstextField.frame.size.height - 1, cell.repstextField.frame.size.width, 1);
            [cell.repstextField.layer addSublayer:repsBottomBorder];
            
            [cell.timeButton layoutIfNeeded];
            cell.timeButton.clipsToBounds = YES;
            CALayer *timeBottomBorder = [CALayer layer];
            timeBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            timeBottomBorder.borderWidth = 1.4f;
            timeBottomBorder.frame = CGRectMake(0.0f, cell.timeButton.frame.size.height - 1, cell.timeButton.frame.size.width, 1);
            [cell.timeButton.layer addSublayer:timeBottomBorder];
            
            [cell.videoTextfield layoutIfNeeded];
            cell.videoTextfield.clipsToBounds = YES;
            CALayer *videoBottomBorder = [CALayer layer];
            videoBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            videoBottomBorder.borderWidth = 1.4f;
            videoBottomBorder.frame = CGRectMake(0.0f, cell.videoTextfield.frame.size.height - 1, cell.videoTextfield.frame.size.width, 1);
            [cell.videoTextfield.layer addSublayer:videoBottomBorder];
            
            [cell.videoNametextField layoutIfNeeded];
            cell.videoNametextField.clipsToBounds = YES;
            CALayer *videoNameBottomBorder = [CALayer layer];
            videoNameBottomBorder.borderColor = [[UIColor whiteColor] CGColor];
            videoNameBottomBorder.borderWidth = 1.4f;
            videoNameBottomBorder.frame = CGRectMake(0.0f, cell.videoNametextField.frame.size.height - 1, cell.videoNametextField.frame.size.width, 1);
            [cell.videoNametextField.layer addSublayer:videoNameBottomBorder];
            
        }
        else{
            cell.dateLabelHeightConstraints.constant=cell.dateButton.frame.size.height;
            if(!willCountHidden){
            cell.countLabelHeightConstraints.constant=cell.countTextfield.frame.size.height;
            }
            if(!willRepsHidden){
            cell.repsLabelHeightConstraints.constant=cell.repstextField.frame.size.height;
            }
            if(!willTimeHidden){
            cell.timeLabelHeightConstraints.constant=cell.timeButton.frame.size.height;
            }
            cell.videoLinkLabelHeightConstraints.constant=cell.videoTextfield.frame.size.height;
            cell.videoNameLabelHeightConstraints.constant=cell.videoNametextField.frame.size.height;//AmitY 3-Nov-2016
            
            cell.dateButton.userInteractionEnabled=NO;
            cell.calenderButton.hidden=YES;
            cell.countTextfield.userInteractionEnabled=NO;
            cell.repstextField.userInteractionEnabled=NO;
            cell.timeButton.userInteractionEnabled=NO;
            cell.videoTextfield.userInteractionEnabled=NO;
            cell.videoUploadButton.hidden=YES;
            cell.videoNametextField.userInteractionEnabled=NO;
        }
        [self.view setNeedsUpdateConstraints];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [self->excerciseDetailsDict objectForKey:@"ExerciseListDetail"];
         
         NSDictionary *circuitDict = [arr objectAtIndex:indexPath.row];
         
         if(![Utility isEmptyCheck:circuitDict]){
             
             if(![Utility isEmptyCheck:circuitDict[@"ExerciseVideo"]]){
                 ExerciseDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetailsVideo"];
                 controller.circuitDict = [arr objectAtIndex:indexPath.row];
                 controller.fromChallenge = true;
                 controller.modalPresentationStyle = UIModalPresentationCustom;
                 [self presentViewController:controller animated:YES completion:nil];
             }else if(![Utility isEmptyCheck:circuitDict[@"ExerciseId"]]){
                 int exSessionId = [circuitDict[@"ExerciseId"] intValue];
                 [self getExerciseDetails:exSessionId isMoveToSession:YES];
             }
         }
    });
}


#pragma mark - End


#pragma mark - TextField Delegate
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = scroll.frame;
    float x;
    if (activeTextView==nil) {
        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [scroll setContentOffset:scrollPoint animated:YES];
        }
    }
    else{
        x=aRect.size.height-activeTextView.superview.frame.origin.y-activeTextView.superview.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [scroll setContentOffset:scrollPoint animated:YES];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    ////,,,change new2
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    ////,,,change new2
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if ([textField isEqual:countTextField]) {
//        [scoreDict setObject:countTextField.text forKey:@"Count"];
//    }else if ([textField isEqual:repsTextField]){
//        [scoreDict setObject:repsTextField.text forKey:@"RepsCount"];
//    }else if ([textField isEqual:videolinkTextField]){
//        [scoreDict setObject:videolinkTextField.text forKey:@"VideoLink"];
//    }
//
//    if (scoreArray.count>0) {
//        NSMutableDictionary *dict=[[scoreArray objectAtIndex:textField.tag] mutableCopy];
//        if ([textField.accessibilityHint isEqualToString:@"countTextfield"]) {
//            [dict setObject:textField.text forKey:@"Count"];
//            [scoreArray replaceObjectAtIndex:textField.tag withObject:dict];
//        }
//        else if ([textField.accessibilityHint isEqualToString:@"repsTextfield"]) {
//            [dict setObject:textField.text forKey:@"RepsCount"];
//            [scoreArray replaceObjectAtIndex:textField.tag withObject:dict];
//        }
//        else if ([textField.accessibilityHint isEqualToString:@"videoTextfield"]){
//            [dict setObject:textField.text forKey:@"VideoFileName"];
//            [dict setObject:textField.text forKey:@"VideoLink"];
//            [scoreArray replaceObjectAtIndex:textField.tag withObject:dict];
//        }
//    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView isEqual:videolinkTextView]) {
        textView.text= @"";
    }
    activeTextView=textView;
    activeTextField=nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    activeTextView=nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"Image Info-%@",info);
    mediaUrl=[@"" stringByAppendingFormat:@"%@",info[UIImagePickerControllerMediaURL]];
    NSURL *media=info[UIImagePickerControllerMediaURL];
    
    NSError *attributesError = nil;
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[media path] error:&attributesError];
    NSString *FileSizeString;
    if (fileAttributes) {
        FileSizeString = [NSByteCountFormatter stringFromByteCount:[fileAttributes fileSize] countStyle:NSByteCountFormatterCountStyleFile];
        NSLog(@"FileSizestring-%@", FileSizeString);
    }
    
    NSArray *sizeArray=[FileSizeString componentsSeparatedByString:@" "];
    NSString *fileSizeUnit =[sizeArray lastObject];
    float actualSize=[[sizeArray firstObject] floatValue];
    
     if(actualSize>50.0 && [fileSizeUnit isEqualToString:@"MB"]){
        imagePicker=nil;
        [picker dismissViewControllerAnimated:NO completion:NULL];
        
        //_add on 6/3/17
        UIAlertController * alert=[UIAlertController
                                   alertControllerWithTitle:@"Alert" message:@"File size exceed limit. please upload to  youtube or vimeo channel and share the link"preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        //
//        [Utility msg:@"File size exceed limit.Please upload video below 50 MB." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
    
    NSLog(@"Picker row Number-%@",picker.accessibilityHint);
   
//    [scoreDict setObject:mediaUrl forKey:@"MobilePath"];
//    [scoreDict setObject:mediaUrl forKey:@"VideoFileName"];
    
    imagePicker=nil;
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:NO completion:NULL];
}
#pragma mark -End

#pragma  mark - DatePickerViewControllerDelegate

-(void)didSelectDate:(NSDate *)date{
    isChanged = YES;
    if (date) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        NSDate *dateSelect = [dateFormatter dateFromString:dateString];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        NSString *dateString1=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateSelect]];
        dateString1 = ![Utility isEmptyCheck:dateString1] ? dateString1 : @"";
        [dateButton setTitle:dateString1 forState:UIControlStateNormal];
    }
}
#pragma mark - End
    
#pragma mark progressbar delegate
    
- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

                         NSDictionary *videoFileNameDict = [responseDict objectForKey:@"VideoDetail"];

                             NSString *videouploadSuccessString=[@"" stringByAppendingFormat:@"Score board updated successfully with %@",[videoFileNameDict objectForKey:@"VideoFileName"]];
                             NSLog(@"%@",videouploadSuccessString);
                             mediaUrl = nil;
                             [Utility msg:videouploadSuccessString title:@"Success!" controller:self haveToPop:NO];

                             [dateButton setTitle:@"Enter Date" forState:UIControlStateNormal];
                             if (!willCountHidden) {
                                 countTextField.text =@"";
                                 countTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",unitName];
                             }
                             if (!willRepsHidden) {
                                 repsTextField.text =@"";
                                 repsTextField.placeholder = [@"" stringByAppendingFormat:@"Enter %@",repsUnitName];
                             }
                             if (!willTimeHidden) {
                                 [timeButton setTitle:@"Enter Time" forState:UIControlStateNormal];
                             }
                             videolinkTextView.text = @"Enter Video URL";
                             videoLabel.hidden = true;
                        }else{
                            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                return;
            }
        });
    }
    
    
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}

#pragma Mark - End
@end
