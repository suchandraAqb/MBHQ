//
//  RoundListViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 06/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "RoundListViewController.h"
//#import "ExerciseVideoViewController.h"
//#import "DBManager.h"
#import "TimerViewController.h"
#import "TableViewCell.h"
#import "Utility.h"
#import "SettingsViewController.h"

@interface RoundListViewController (){
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIView *topLeftBgView;
    IBOutlet UIView *topRightBgView;
    IBOutlet UIView *middleLeftBgView;
    IBOutlet UIView *middleRightBgView;
    IBOutlet UIView *bottomLeftBgView;
    IBOutlet UIView *bottomRightBgView;
    __weak IBOutlet UIView *bottomBgView;
    IBOutlet NSLayoutConstraint *topLeftBgViewHeightConstraint;
    //    IBOutlet NSLayoutConstraint *topLeftBgViewWidthConstraint;
    //    IBOutlet NSLayoutConstraint *bottomRightBgViewBottomConstraint;
    __weak IBOutlet UIView *upperView;
    
    
    IBOutlet UILabel *stationCountlabel;
    IBOutlet UILabel *roundsCountlabel;
    IBOutlet UILabel *roundPrepLabel;
    IBOutlet UILabel *onLabel;
    IBOutlet UILabel *offLabel;
    IBOutlet UILabel *roundOptionLabel;
    IBOutlet UIButton *roundPrepButton;
    IBOutlet UIButton *onButton;
    IBOutlet UIButton *offButton;
    IBOutlet UITableView *roundEditTableView;
    IBOutlet NSLayoutConstraint *roundEditTableHeightConstraint;
    IBOutlet UIView *scrollContainerView;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UITableView *stationEditTableView;
    IBOutlet NSLayoutConstraint *stationEditTableHeightConstraint;
    
    IBOutlet UILabel *sessionNameLabel;
    IBOutlet UILabel *selectedCircuitLabel;
    
    IBOutlet UIButton *saveButton;
    BOOL isHighAlpha;
    //    NSLayoutConstraint *roundTableBottomConstraint;
    //    NSLayoutConstraint *bottomRightBgViewBottomConstraint;
    //    NSLayoutConstraint *stationTableBottomConstraint;
    
//    DBManager *dbManager;
    //    NSArray *dataArray;
    NSMutableDictionary *dataDict;
    int numberOfRowsInSection;
    NSString *roundOptionPickerValue;
    NSMutableArray *totalRoundEditArray;
    NSMutableDictionary *totalStationEditDict;
    NSInteger clickedIndexpathRow;
    NSInteger clickedIndexpathSection;
    NSArray *dataArray;
    NSMutableDictionary *exerciseDict;
    //    UIToolbar *numberToolbar;
    AVPlayer *videoPlayer;
    NSArray *circuitArray;
    int selectedCircuit;
    NSMutableDictionary *countDict;
    int roundCountDiff;
    
    __weak IBOutlet UIButton *volumeButton;
    __weak IBOutlet UIButton *voiceOverButton;
    __weak IBOutlet UIButton *bellButton;
    __weak IBOutlet UIButton *musicButton;
//    BOOL showMusicAlert;
}
//@property (strong, nonatomic) NSLayoutConstraint *roundTableBottomConstraint;
//@property (strong, nonatomic) NSLayoutConstraint *bottomRightBgViewBottomConstraint;
//@property (strong, nonatomic) NSLayoutConstraint *stationTableBottomConstraint;
@end

@implementation RoundListViewController
@synthesize sessionID,fromController,modeID,prepTime,sessionName;//,roundTableBottomConstraint,bottomRightBgViewBottomConstraint,stationTableBottomConstraint;
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    NSLog(@"%u",arc4random_uniform(3));
    // Do any additional setup after loading the view.
    //    NSLog(@"sid %d",sessionID);
    //////
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"End of Round.wav"];
     
     NSLog(@"AUDIO PATH-%@",writableDBPath);*/
    /////
    
//    dbManager = [[DBManager alloc]init];
//    showMusicAlert = true;
    dataDict = [[NSMutableDictionary alloc]init];
    dataArray = [[NSArray alloc]init];
    numberOfRowsInSection = 0;
    clickedIndexpathRow = clickedIndexpathSection = -1;
    roundOptionPickerValue = @"DEFAULT";
    totalRoundEditArray = [[NSMutableArray alloc]init];
    totalStationEditDict = [[NSMutableDictionary alloc]init];
    exerciseDict = [[NSMutableDictionary alloc]init];
    countDict = [[NSMutableDictionary alloc]init];
    isHighAlpha = YES;
    
    selectedCircuit = 0;
    roundCountDiff = 0;
    
    fromController = @"home";
    //    modeID = @"3";
    
    //    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    //    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    //    numberToolbar.items = [NSArray arrayWithObjects:
    //                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    //    [numberToolbar sizeToFit];
    //    stationCountTextField.inputAccessoryView = numberToolbar;
    //    stationCountTextField.inputAccessoryView = numberToolbar;
    roundPrepButton.layer.borderWidth = 1;
    roundPrepButton.layer.borderColor = [UIColor colorWithRed:(228/255.0) green:(39/255.0) blue:(160/255.0) alpha:1.0].CGColor;
    musicButton.layer.borderWidth = 1;
    musicButton.layer.borderColor = [UIColor colorWithRed:(228/255.0) green:(39/255.0) blue:(160/255.0) alpha:1.0].CGColor;
    
//    [topLeftBgView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.8]];
//    [topRightBgView setBackgroundColor:[UIColor colorWithRed:(239/255.0) green:(0/255.0) blue:(172/255.0) alpha:0.8]];
//    [middleLeftBgView setBackgroundColor:[UIColor colorWithRed:(109/255.0) green:(112/255.0) blue:(117/255.0) alpha:0.9]];
//    [middleRightBgView setBackgroundColor:[UIColor colorWithRed:(110/255.0) green:(115/255.0) blue:(119/255.0) alpha:0.8]];
//    [bottomLeftBgView setBackgroundColor:[UIColor colorWithRed:(191/255.0) green:(149/255.0) blue:(211/255.0) alpha:0.8]];
//    [bottomRightBgView setBackgroundColor:[UIColor colorWithRed:(118/255.0) green:(148/255.0) blue:(230/255.0) alpha:0.8]];
    
    if ([fromController isEqualToString:@"session"] && sessionID > 0 && _idDict.count == 0) {
//        [topLeftBgView setBackgroundColor:[UIColor colorWithRed:(239/255.0) green:(0/255.0) blue:(172/255.0) alpha:0.8]];
//        [topRightBgView setBackgroundColor:[UIColor colorWithRed:(191/255.0) green:(149/255.0) blue:(211/255.0) alpha:0.8]];
//        [middleLeftBgView setBackgroundColor:[UIColor colorWithRed:(109/255.0) green:(112/255.0) blue:(117/255.0) alpha:0.9]];
//        [middleRightBgView setBackgroundColor:[UIColor colorWithRed:(112/255.0) green:(153/255.0) blue:(253/255.0) alpha:0.8]];
//        [bottomLeftBgView setBackgroundColor:[UIColor colorWithRed:(191/255.0) green:(149/255.0) blue:(211/255.0) alpha:0.8]];
//        [bottomRightBgView setBackgroundColor:[UIColor colorWithRed:(118/255.0) green:(148/255.0) blue:(230/255.0) alpha:0.8]];
        
//        [self getData];
        sessionNameLabel.text = sessionName;
    }
    
//    CGFloat viewHeight = upperVIew.bounds.size.height / 3;
//    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width / 2;
//    topLeftBgViewHeightConstraint.constant = viewHeight;
//    topLeftBgViewWidthConstraint.constant = viewWidth;
//    [self.view setNeedsUpdateConstraints];
    
    // if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame ) {
    //        for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {
    //            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime", nil];
    //            [totalRoundEditArray addObject:dict];
    //        }
    // } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
    //        for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {   ////
    //
    //            NSMutableArray *stationArray = [[NSMutableArray alloc]init];
    //            for (int j = 0; j < [stationCountlabel.text intValue]; j++) {    ////
    //                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime",@"0",@"reps", nil];
    //                [stationArray addObject:dict];
    //            }
    //            NSString *roundKey = [NSString stringWithFormat:@"round%d",i];
    //            [totalStationEditDict setObject:stationArray forKey:roundKey];
    //        }
    
    //}
    //    NSLog(@"tst %@",totalStationEditDict);
    //    [scrollContainerView removeFromSuperview];
    
    //    if ([fromController isEqualToString:@"home"]) {
//    bottomRightBgViewBottomConstraint = [NSLayoutConstraint
//                                         constraintWithItem:roundEditTableView
//                                         attribute:NSLayoutAttributeBottom
//                                         relatedBy:NSLayoutRelationEqual
//                                         toItem:mainScroll
//                                         attribute:NSLayoutAttributeBottom
//                                         multiplier:1.0f
//                                         constant:0.f];
//
//    [mainScroll addConstraint:bottomRightBgViewBottomConstraint];
    [mainScroll setNeedsUpdateConstraints];
    //    }
    
    //    stationEditTableView.rowHeight = UITableViewAutomaticDimension;
    //    stationEditTableView.estimatedRowHeight = 80.0;
    if ([defaults objectForKey:@"timerSettings"] && ![[defaults objectForKey:@"timerSettings"] isEqual:[NSNull null]]) {
        NSMutableDictionary *defDict = [[NSMutableDictionary alloc]init];
        [defDict addEntriesFromDictionary:[defaults objectForKey:@"timerSettings"]];
        //        NSLog(@"de %@",defDict);
        if ([[defDict objectForKey:@"mode"] caseInsensitiveCompare:@"defaults"] == NSOrderedSame) {
            roundsCountlabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"roundsCount"];
            stationCountlabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"stationCount"];
            onLabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"onTime"];
            offLabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"offTime"];
            roundPrepLabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"roundPrepTime"];
            roundOptionLabel.text = @"DEFAULT";
            roundOptionPickerValue = @"DEFAULT";
            
            bottomLeftBgView.hidden = false;
            bottomRightBgView.hidden = false;
            bottomBgView.hidden = false;
            roundEditTableView.hidden = true;
            stationEditTableView.hidden = true;
//            [mainScroll removeConstraint:roundTableBottomConstraint];
//            [mainScroll removeConstraint:stationTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            bottomRightBgViewBottomConstraint = [NSLayoutConstraint
//                                                 constraintWithItem:roundEditTableView
//                                                 attribute:NSLayoutAttributeBottom
//                                                 relatedBy:NSLayoutRelationEqual
//                                                 toItem:mainScroll
//                                                 attribute:NSLayoutAttributeBottom
//                                                 multiplier:1.0f
//                                                 constant:0.f];
//
//            [mainScroll addConstraint:bottomRightBgViewBottomConstraint];
        } else if ([[defDict objectForKey:@"mode"] caseInsensitiveCompare:@"round"] == NSOrderedSame) {
            [totalRoundEditArray addObjectsFromArray:[[defDict objectForKey:@"dataDict"] objectForKey:@"round"]];
            numberOfRowsInSection = (int)totalRoundEditArray.count;
            [roundEditTableView reloadData];
            roundsCountlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)totalRoundEditArray.count];
            stationCountlabel.text = [[defDict objectForKey:@"dataDict"] objectForKey:@"station"];
            roundPrepLabel.text = [defDict objectForKey:@"roundPrepTime"];
            roundOptionLabel.text = @"ROUND EDIT";
            roundOptionPickerValue = @"ROUND EDIT";
            
            bottomLeftBgView.hidden = true;
            bottomRightBgView.hidden = true;
            bottomBgView.hidden = true;
            roundEditTableView.hidden = false;
            stationEditTableView.hidden = true;
//            [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//            [mainScroll removeConstraint:stationTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            roundTableBottomConstraint = [NSLayoutConstraint
//                                          constraintWithItem:roundEditTableView
//                                          attribute:NSLayoutAttributeBottom
//                                          relatedBy:NSLayoutRelationEqual
//                                          toItem:mainScroll
//                                          attribute:NSLayoutAttributeBottom
//                                          multiplier:1.0f
//                                          constant:0.f];
//
//            [mainScroll addConstraint:roundTableBottomConstraint];
        } else if ([[defDict objectForKey:@"mode"] caseInsensitiveCompare:@"station"] == NSOrderedSame) {
            [totalStationEditDict addEntriesFromDictionary:[defDict objectForKey:@"dataDict"]];
            NSArray *roundArray = [totalStationEditDict objectForKey:@"round0"];
            numberOfRowsInSection = (int)roundArray.count;
            [stationEditTableView reloadData];
            roundsCountlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)totalStationEditDict.count];
            stationCountlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)roundArray.count];
            roundPrepLabel.text = [defDict objectForKey:@"roundPrepTime"];
            roundOptionLabel.text = @"STATION EDIT";
            roundOptionPickerValue = @"STATION EDIT";
            
            bottomLeftBgView.hidden = true;
            bottomRightBgView.hidden = true;
            bottomBgView.hidden = true;
            roundEditTableView.hidden = true;
            stationEditTableView.hidden = false;
//            [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//            [mainScroll removeConstraint:roundTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            stationTableBottomConstraint = [NSLayoutConstraint
//                                            constraintWithItem:stationEditTableView
//                                            attribute:NSLayoutAttributeBottom
//                                            relatedBy:NSLayoutRelationEqual
//                                            toItem:mainScroll
//                                            attribute:NSLayoutAttributeBottom
//                                            multiplier:1.0f
//                                            constant:0.f];
//
//            [mainScroll addConstraint:stationTableBottomConstraint];
        }
        [mainScroll setNeedsUpdateConstraints];
    } else {
        roundEditTableView.hidden = true;
        stationEditTableView.hidden = true;
        onLabel.text = @"00:30";
        offLabel.text = @"00:05";
        roundPrepLabel.text = @"00:10";
    }
    
    saveButton.hidden = YES;
    saveButton.layer.borderColor = [UIColor whiteColor].CGColor;
    saveButton.layer.borderWidth = 1;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self updateFooter];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];
//    NSError *error = nil;
//    @try {
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient withOptions:AVAudioSessionCategoryOptionDuckOthers error:&error];
//        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//        
//    } @catch (NSException *exception) {
//        NSLog(@"Audio Session error %@, %@", exception.reason, exception.userInfo);
//        
//    } @finally {
//        NSLog(@"Audio Session finally");
//    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGFloat viewHeight = upperView.bounds.size.height / 3;
    topLeftBgViewHeightConstraint.constant = viewHeight;
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    saveButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
-(void)viewDidLayoutSubviews {
    //    NSLog(@"th ->> %f",stationEditTableView.contentSize.height);
    CGFloat height = roundEditTableView.contentSize.height;
    roundEditTableHeightConstraint.constant = height;
    [self.view setNeedsUpdateConstraints];
    
    CGFloat height1 = stationEditTableView.contentSize.height;
    stationEditTableHeightConstraint.constant = height1;
    [self.view setNeedsUpdateConstraints];
    //    NSLog(@"tthh ->> %f",stationEditTableHeightConstraint.constant);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Local Notification Observer and delegate

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        [self homeButtonPressed:0];
    }else{
        [self backButtonPressed:0];
    }
    
}
-(IBAction)homeButtonPressed:(UIButton*)sender{
    //    [self.navigationController popToRootViewControllerAnimated:YES];
    //add_new_7/8/17
    [self stopMusic];
    if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
        if (!isAllTaskCompleted ){
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
//            TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
            GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
-(IBAction)backButtonPressed:(id)sender{
    // [self.navigationController popViewControllerAnimated:YES];
    //add_new_7/8/17
    [self stopMusic];
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma mark -End
#pragma mark - FilterDelegate
-(void) updateCustomPickerValue:(NSString *)customPickerValue ofButton:(NSInteger)buttonTag withAccessibilityHint:(NSString *)accessibilityHint{
    //    NSLog(@"customPickerValue %@",customPickerValue);
    saveButton.hidden = NO;
    switch (buttonTag) {
        case 1:
            stationCountlabel.text = customPickerValue;
            if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                if ([fromController isEqualToString:@"session"]) {
                    NSMutableArray *cirArray = [[NSMutableArray alloc]init];
                    NSMutableArray *stnArray = [[NSMutableArray alloc]init];
                    NSString *cirKey = [NSString stringWithFormat:@"circuit%d",selectedCircuit];
                    [cirArray addObjectsFromArray:[totalStationEditDict objectForKey:cirKey]];
                    [totalStationEditDict removeObjectForKey:cirKey];
                    int k = 0;
                    int rcount = 0;
                    //                    int scount = 0;
                    for (int j = 0; j < [roundsCountlabel.text intValue]; j++) {
                        //                        int newStnCount = 1;
                        //                        int roundCount = [[[cirArray objectAtIndex:rc] objectForKey:@"roundCount"] intValue];
                        if (k != 0) {
                            for (int incK = k; incK < cirArray.count - k; incK++) {
                                if (![[[cirArray objectAtIndex:incK - 1] objectForKey:@"roundType"] isEqualToString:[[cirArray objectAtIndex:incK] objectForKey:@"roundType"]] || ![[[cirArray objectAtIndex:incK - 1] objectForKey:@"roundCount"] isEqualToString:[[cirArray objectAtIndex:incK] objectForKey:@"roundCount"]]) {
                                    break;
                                }  else {
                                    k++;
                                }
                            }
                        }
                        if (j > 0 && j < [roundsCountlabel.text intValue]-1) { //[[[cirArray objectAtIndex:k] objectForKey:@"roundType"] isEqualToString:@"tdefault"]
                            rcount++;
                        }
                        NSString *roundType = @"tdefault";
                        if (j == 0) {
                            roundType = @"w";
                        } else if (j == [roundsCountlabel.text intValue]-1) {
                            roundType = @"s";
                        }
                        for (int i = 0; i < [stationCountlabel.text intValue]; i++) {
                            NSDictionary *dict;
                            if (i < cirArray.count/[roundsCountlabel.text intValue]) {
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[cirArray objectAtIndex:k] objectForKey:@"stationID"],@"stationID", [[cirArray objectAtIndex:k] objectForKey:@"circuitID"],@"circuitID", [[cirArray objectAtIndex:k] objectForKey:@"onTime"],@"onTime", [[cirArray objectAtIndex:k] objectForKey:@"offTime"],@"offTime",[[cirArray objectAtIndex:k] objectForKey:@"reps"],@"reps",[NSString stringWithFormat:@"round %02d",rcount],@"roundName",[NSString stringWithFormat:@"%02d",rcount], @"roundCount", [NSString stringWithFormat:@"%02d",i+1], @"stationCount", roundType,@"roundType",[[cirArray objectAtIndex:k] objectForKey:@"isSuperSet"],@"isSuperSet", [[cirArray objectAtIndex:k] objectForKey:@"superSetPosition"],@"superSetPosition",[[cirArray objectAtIndex:k] objectForKey:@"setCount"],@"setCount", nil];  //[[cirArray objectAtIndex:k] objectForKey:@"roundType"]
                                k++;
                            } else {
                                //add @"" in all key
                                //                                k=0;**
                                
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"stationID", [[cirArray objectAtIndex:0] objectForKey:@"circuitID"],@"circuitID", @"00:05",@"onTime", @"00:05",@"offTime",@"0",@"reps",[NSString stringWithFormat:@"round %02d",rcount],@"roundName",[NSString stringWithFormat:@"%02d",rcount], @"roundCount", [NSString stringWithFormat:@"%02d",i+1], @"stationCount", roundType,@"roundType",@"0",@"isSuperSet", @"0",@"superSetPosition",@"1",@"setCount", nil];
                                //                                newStnCount++;
                            }
                            
                            [stnArray addObject:dict];
                        }
                    }
                    [totalStationEditDict setObject:stnArray forKey:cirKey];
                    NSLog(@"tsa %@",totalStationEditDict);
                    
                    numberOfRowsInSection = [customPickerValue intValue];
                    [stationEditTableView reloadData];
                    
                } else {
                    
                    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
                    [mutDict addEntriesFromDictionary:totalStationEditDict];
                    [totalStationEditDict removeAllObjects];
                    numberOfRowsInSection = 0;
                    [stationEditTableView reloadData];
                    for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {   ////
                        
                        NSMutableArray *stationArray = [[NSMutableArray alloc]init];
                        NSString *roundKey = [NSString stringWithFormat:@"round%d",i];
                        NSMutableArray *mutArr = [[NSMutableArray alloc]init];
                        [mutArr addObjectsFromArray:[mutDict objectForKey:roundKey]];
                        for (int j = 0; j < [stationCountlabel.text intValue]; j++) {    ////
                            NSDictionary *dict;
                            if (j < mutArr.count) {
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[mutArr objectAtIndex:j] objectForKey:@"onTime"],@"onTime", [[mutArr objectAtIndex:j] objectForKey:@"offTime"],@"offTime",[[mutArr objectAtIndex:j] objectForKey:@"reps"],@"reps", [[mutArr objectAtIndex:j] objectForKey:@"stationID"],@"stationID", nil];
                            } else {
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime",@"0",@"reps",@"-1",@"stationID", nil];
                            }
                            [stationArray addObject:dict];
                        }
                        [totalStationEditDict setObject:stationArray forKey:roundKey];
                    }
                    numberOfRowsInSection = [customPickerValue intValue];
                    [stationEditTableView reloadData];
                }
            }
            break;
            
        case 2:
            roundsCountlabel.text = customPickerValue;
            if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame ) {
                [totalRoundEditArray removeAllObjects];
                numberOfRowsInSection = 0;
                [roundEditTableView reloadData];
                for (int i = 0; i < [customPickerValue intValue]; i++) {
                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime", nil];
                    [totalRoundEditArray addObject:dict];
                }
                numberOfRowsInSection = [customPickerValue intValue];
                [roundEditTableView reloadData];
            } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                if ([fromController isEqualToString:@"session"]) {
                    NSMutableArray *cirArray = [[NSMutableArray alloc]init];
                    NSMutableArray *stnArray = [[NSMutableArray alloc]init];
                    NSString *cirKey = [NSString stringWithFormat:@"circuit%d",selectedCircuit];
                    [cirArray addObjectsFromArray:[totalStationEditDict objectForKey:cirKey]];
                    [totalStationEditDict removeObjectForKey:cirKey];
                    int k = 0;
                    int rcount = 0;
                    for (int j = 0; j < [roundsCountlabel.text intValue]; j++) {
                        int newStnCount = 1;
                        //                        if (k != 0) {
                        //                            for (int incK = k; incK < cirArray.count - k; incK++) {
                        //                                if (![[[cirArray objectAtIndex:incK - 1] objectForKey:@"roundType"] isEqualToString:[[cirArray objectAtIndex:incK] objectForKey:@"roundType"]] || ![[[cirArray objectAtIndex:incK - 1] objectForKey:@"roundCount"] isEqualToString:[[cirArray objectAtIndex:incK] objectForKey:@"roundCount"]]) {
                        //                                    break;
                        //                                }  else {
                        //                                    k++;
                        //                                }
                        //                            }
                        //                        }
                        if (k < cirArray.count) {
                            if (j > 0 && j < [roundsCountlabel.text intValue]-1) {
                                rcount++;
                            }
                        } else {
                            rcount++;
                        }
                        NSString *roundType = @"tdefault";
                        for (int i = 0; i < [stationCountlabel.text intValue]; i++) {
                            NSDictionary *dict;
                            if (k < cirArray.count) {
                                if (j == 0) {
                                    roundType = @"w";
                                } else if (j == [roundsCountlabel.text intValue]-1) {
                                    roundType = @"s";
                                }
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[cirArray objectAtIndex:k] objectForKey:@"stationID"],@"stationID", [[cirArray objectAtIndex:k] objectForKey:@"circuitID"],@"circuitID", [[cirArray objectAtIndex:k] objectForKey:@"onTime"],@"onTime", [[cirArray objectAtIndex:k] objectForKey:@"offTime"],@"offTime",[[cirArray objectAtIndex:k] objectForKey:@"reps"],@"reps",[NSString stringWithFormat:@"round %02d",[[[cirArray objectAtIndex:k] objectForKey:@"roundCount"] intValue]],@"roundName",[NSString stringWithFormat:@"%02d",rcount], @"roundCount", [[cirArray objectAtIndex:k] objectForKey:@"stationCount"], @"stationCount", roundType, @"roundType", [[cirArray objectAtIndex:k] objectForKey:@"isSuperSet"],@"isSuperSet", [[cirArray objectAtIndex:k] objectForKey:@"superSetPosition"],@"superSetPosition",[[cirArray objectAtIndex:k] objectForKey:@"setCount"],@"setCount", nil];   //[[cirArray objectAtIndex:k] objectForKey:@"roundType"]    [[cirArray objectAtIndex:k] objectForKey:@"roundCount"]
                                k++;
                            } else {
                                //                            add @"" in all key
                                if (j == [roundsCountlabel.text intValue]-1) {
                                    roundType = @"s";
                                }
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"stationID", [[cirArray objectAtIndex:0] objectForKey:@"circuitID"],@"circuitID", @"00:05",@"onTime", @"00:05",@"offTime",@"0",@"reps",[NSString stringWithFormat:@"round %02d",rcount],@"roundName",[NSString stringWithFormat:@"%02d",rcount], @"roundCount", [NSString stringWithFormat:@"%02d",newStnCount], @"stationCount", roundType, @"roundType", @"0",@"isSuperSet", @"0",@"superSetPosition",@"1",@"setCount", nil];
                                newStnCount++;
                            }
                            [stnArray addObject:dict];
                        }
                    }
                    [totalStationEditDict setObject:stnArray forKey:cirKey];
                    NSLog(@"tsa %@",totalStationEditDict);
                    /*NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
                     [mutDict addEntriesFromDictionary:totalStationEditDict];
                     [totalStationEditDict removeAllObjects];
                     numberOfRowsInSection = 0;
                     [stationEditTableView reloadData];
                     
                     int k = 0;
                     
                     int prevRoundId = -1;
                     int newRoundId = -2;
                     
                     
                     for (int i = 0; i < circuitArray.count; i++) {   ////
                     int roundsCount = 0;
                     int stationNo = 0;
                     NSMutableArray *stationArray = [[NSMutableArray alloc]init];
                     //loop round in circuit i
                     int stationsCount = [dbManager fetchStationCountFromCircuitID:[[[circuitArray objectAtIndex:i] objectForKey:@"circuitID"] intValue]];
                     NSString *roundKey = [NSString stringWithFormat:@"circuit%d",i];
                     for (int j = 0; j < stationsCount; j++) {    ////
                     newRoundId = [[[dataArray objectAtIndex:k] objectForKey:@"roundID"] intValue];
                     if (newRoundId != prevRoundId) {
                     roundsCount++;
                     prevRoundId = newRoundId;
                     stationNo = 0;
                     }
                     stationNo++;
                     NSDictionary *dict;
                     if (i < mutDict.count) {
                     dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"stationID"],@"stationID", [[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"circuitID"],@"circuitID", [[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"onTime"],@"onTime", [[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"offTime"],@"offTime",[[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"reps"],@"reps",[NSString stringWithFormat:@"round %02d",roundsCount],@"roundName",[NSString stringWithFormat:@"%02d",roundsCount], @"roundCount", [NSString stringWithFormat:@"%02d",stationNo], @"stationCount", nil];
                     } else {
                     dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"stationID", [[circuitArray objectAtIndex:selectedCircuit] objectForKey:@"circuitID"],@"circuitID", @"00:05",@"onTime", @"00:05",@"offTime",@"0",@"reps",[NSString stringWithFormat:@"round %02d",roundsCount],@"roundName",[NSString stringWithFormat:@"%02d",roundsCount], @"roundCount", [NSString stringWithFormat:@"%02d",stationNo], @"stationCount", nil];
                     }
                     [stationArray addObject:dict];
                     k++;
                     }
                     NSString *circuitKey = [NSString stringWithFormat:@"circuit%d",i];
                     [totalStationEditDict setObject:stationArray forKey:circuitKey];
                     }*/
                    numberOfRowsInSection = [stationCountlabel.text intValue];
                    [stationEditTableView reloadData];
                }else {
                    NSMutableDictionary *mutDict = [[NSMutableDictionary alloc]init];
                    [mutDict addEntriesFromDictionary:totalStationEditDict];
                    [totalStationEditDict removeAllObjects];
                    numberOfRowsInSection = 0;
                    [stationEditTableView reloadData];
                    for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {   ////
                        
                        NSMutableArray *stationArray = [[NSMutableArray alloc]init];
                        NSString *roundKey = [NSString stringWithFormat:@"round%d",i];
                        for (int j = 0; j < [stationCountlabel.text intValue]; j++) {    ////
                            NSDictionary *dict;
                            if (i < mutDict.count) {
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"onTime"],@"onTime", [[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"offTime"],@"offTime",[[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"reps"],@"reps", [[[mutDict objectForKey:roundKey] objectAtIndex:j] objectForKey:@"stationID"],@"stationID", nil];
                            } else {
                                dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime",@"0",@"reps",@"-1",@"stationID", nil];
                            }
                            [stationArray addObject:dict];
                        }
                        
                        [totalStationEditDict setObject:stationArray forKey:roundKey];
                    }
                    numberOfRowsInSection = [stationCountlabel.text intValue];
                    [stationEditTableView reloadData];
                }
                
            }
            break;
            
        case 3:
            roundPrepLabel.text = customPickerValue;
            break;
            
        case 4:
            //            if ([fromController isEqualToString:@"session"]) {
            //                selectedCircuitLabel.text = customPickerValue;
            //                for (int i = 0; i <circuitArray.count; i++) {
            //                    if ([[[circuitArray objectAtIndex:i] objectForKey:@"circuitName"] isEqualToString:customPickerValue]) {
            //                        selectedCircuit = i;
            //                    }
            //                }
            //                countDict = [dbManager fetchCountsFromCircuitId:[[[circuitArray objectAtIndex:selectedCircuit] objectForKey:@"circuitID"] intValue]];
            //
            //                stationCountlabel.text = [NSString stringWithFormat:@"%d",[[countDict objectForKey:@"stationCount"] intValue]/[[countDict objectForKey:@"roundCount"] intValue]];
            //                roundsCountlabel.text = [countDict objectForKey:@"roundCount"];
            //            } else {
            roundOptionPickerValue = customPickerValue;
            roundOptionLabel.text = customPickerValue;
            [self updateConstraintsFromValue:customPickerValue];
            //            }
            break;
            
        case 5:
            onLabel.text = customPickerValue;
            break;
            
        case 6:
            offLabel.text = customPickerValue;
            break;
            
        default:
            if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame ) {
                if (buttonTag > 100 && buttonTag < 1000) {
                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:customPickerValue,@"onTime", [[totalRoundEditArray objectAtIndex:buttonTag - 101] objectForKey:@"offTime"],@"offTime", nil];
                    [totalRoundEditArray replaceObjectAtIndex:buttonTag - 101 withObject:dict];
                } else if (buttonTag > 1000) {
                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[totalRoundEditArray objectAtIndex:buttonTag - 1001] objectForKey:@"onTime"],@"onTime", customPickerValue,@"offTime", nil];
                    [totalRoundEditArray replaceObjectAtIndex:buttonTag - 1001 withObject:dict];
                }
                [roundEditTableView reloadData];
            } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                if (buttonTag > 200 && buttonTag < 2000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",accessibilityHint];
                    if ([fromController isEqualToString:@"session"]) {
                        roundKey = [NSString stringWithFormat:@"circuit%@",accessibilityHint];
                    }
                    NSMutableDictionary *customDict = [[NSMutableDictionary alloc]init];
                    [customDict addEntriesFromDictionary:[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 201]];
                    [customDict removeObjectForKey:@"onTime"];
                    [customDict setObject:customPickerValue forKey:@"onTime"];
                    NSMutableArray *customArray = [[totalStationEditDict objectForKey:roundKey] mutableCopy];
                    [customArray replaceObjectAtIndex:buttonTag - 201 withObject:customDict];
                    [totalStationEditDict setObject:customArray forKey:roundKey];
                } else if (buttonTag > 2000 && buttonTag < 3000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",accessibilityHint];
                    if ([fromController isEqualToString:@"session"]) {
                        roundKey = [NSString stringWithFormat:@"circuit%@",accessibilityHint];
                    }
                    NSMutableDictionary *customDict = [[NSMutableDictionary alloc]init];
                    [customDict addEntriesFromDictionary:[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 2001]];
                    [customDict removeObjectForKey:@"offTime"];
                    [customDict setObject:customPickerValue forKey:@"offTime"];
                    NSMutableArray *customArray = [[totalStationEditDict objectForKey:roundKey] mutableCopy];
                    [customArray replaceObjectAtIndex:buttonTag - 2001 withObject:customDict];
                    [totalStationEditDict setObject:customArray forKey:roundKey];
                } else if (buttonTag > 3000 && buttonTag < 4000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",accessibilityHint];
                    if ([fromController isEqualToString:@"session"]) {
                        roundKey = [NSString stringWithFormat:@"circuit%@",accessibilityHint];
                    }
                    NSMutableDictionary *customDict = [[NSMutableDictionary alloc]init];
                    [customDict addEntriesFromDictionary:[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 3001]];
                    [customDict removeObjectForKey:@"reps"];
                    [customDict setObject:customPickerValue forKey:@"reps"];
                    NSMutableArray *customArray = [[totalStationEditDict objectForKey:roundKey] mutableCopy];
                    [customArray replaceObjectAtIndex:buttonTag - 3001 withObject:customDict];
                    [totalStationEditDict setObject:customArray forKey:roundKey];
                } else if (buttonTag > 6000 && buttonTag < 7000) {
                    [self editExerciseOpenWithTag:buttonTag PickerValue:customPickerValue];
                }
                [stationEditTableView reloadData];
            }
            break;
    }
    
    //[self animateButton];
}
#pragma mark - IBAction
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)pushButtonTapped:(id)sender{
    [self saveButtonTapped:0];
    //    if ([fromController isEqualToString:@"home"]) {
    TimerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimerView"];
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc]init];
    
    if ([roundOptionPickerValue caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
        [dataDict setObject:stationCountlabel.text forKey:@"stationCount"];
        [dataDict setObject:roundsCountlabel.text forKey:@"roundsCount"];
        [dataDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [dataDict setObject:onLabel.text forKey:@"onTime"];
        [dataDict setObject:offLabel.text forKey:@"offTime"];
        controller.dataDict = dataDict;
        //            NSLog(@"de %@",dataDict);
        [saveDict setObject:@"defaults" forKey:@"mode"];
        [saveDict setObject:dataDict forKey:@"dataDict"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    } else if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
        NSMutableDictionary *totalRoundEditDict = [[NSMutableDictionary alloc]init];
        [totalRoundEditDict setObject:totalRoundEditArray forKey:@"round"];
        [totalRoundEditDict setObject:stationCountlabel.text forKey:@"station"];
        controller.roundEditDataDict = totalRoundEditDict;
        controller.roundPrepTime = roundPrepLabel.text;
        //            NSLog(@"re %@",totalRoundEditDict);
        [saveDict setObject:@"round" forKey:@"mode"];
        [saveDict setObject:totalRoundEditDict forKey:@"dataDict"];
        [saveDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        controller.stationEditdataDict = totalStationEditDict;
        controller.roundPrepTime = roundPrepLabel.text;
        //            NSLog(@"se %@",totalStationEditDict);
        [saveDict setObject:@"station" forKey:@"mode"];
        [saveDict setObject:totalStationEditDict forKey:@"dataDict"];
        [saveDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    }
    controller.mode = roundOptionPickerValue;
    //suchandra 4/1/117
    //        [[MPMusicPlayerController systemMusicPlayer] play];
    //
    //    if (showMusicAlert) {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Set Playlist"
                                          message:@"Do you want to set a playlist?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
//                                   [defaults setObject:nil forKey:@"mediaItemCollection"];
//                                   [defaults setObject:nil forKey:@"selectedSpotifyCollectionUri"];
//                                   [defaults synchronize];
                                   SettingsViewController *mController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
                                   mController.delegate = self;
                                   mController.circuitPlaying = true;
                                   [self.navigationController pushViewController:mController animated:YES];
                                   [appDelegate.FBWAudioPlayer pause];
                                   appDelegate.FBWAudioPlayer = nil;
                               }];
    UIAlertAction *previousAction = [UIAlertAction
                                     actionWithTitle:@"Same as last session"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         [self.navigationController pushViewController:controller animated:YES];
                                         [appDelegate.FBWAudioPlayer pause];
                                         appDelegate.FBWAudioPlayer = nil;
                                     }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No music"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self stopMusic];
//                                       [defaults setObject:nil forKey:@"mediaItemCollection"];
//                                       [defaults setObject:nil forKey:@"selectedSpotifyCollectionUri"];
                                       [defaults setBool:false forKey:@"keepCircuitMusicPlaying"];
                                       [defaults synchronize];
                                       [self.navigationController pushViewController:controller animated:YES];
                                       [appDelegate.FBWAudioPlayer pause];
                                       appDelegate.FBWAudioPlayer = nil;
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:previousAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    //    } else {
    //        showMusicAlert = true;
    //        [self.navigationController pushViewController:controller animated:YES];
    //    }
    
    //    }
    /*else if ([fromController isEqualToString:@"session"]) {
     //        if (sessionID < 0) {
     //            BOOL success = NO;
     //            success = [dbManager updateSessionWithSessionId:sessionID WithModeId:1 prepTime:roundPrepLabel.text];
     //            if (success) {
     //                ExerciseVideoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ExerciseVideo"];
     //                [self.navigationController pushViewController:controller animated:YES];
     //            }
     //        } else {
     BOOL success = NO;
     //        int rowID = -1;
     NSMutableArray *rowIdArray = [[NSMutableArray alloc]init];
     NSMutableDictionary *saveDict = [[NSMutableDictionary alloc]init];
     
     if ([roundOptionPickerValue caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
     success = [dbManager updateSessionWithSessionId:sessionID WithModeId:1 prepTime:roundPrepLabel.text idDict:_idDict];
     } else if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
     success = [dbManager updateSessionWithSessionId:sessionID WithModeId:2 prepTime:roundPrepLabel.text idDict:_idDict];
     } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
     success = [dbManager updateSessionWithSessionId:sessionID WithModeId:3 prepTime:roundPrepLabel.text idDict:_idDict];
     }
     
     if (success) {
     [saveDict setObject:roundsCountlabel.text forKey:@"roundCount"];
     [saveDict setObject:stationCountlabel.text forKey:@"stationCount"];
     [saveDict setObject:roundPrepLabel.text forKey:@"prepCont"];
     [saveDict setObject:[NSString stringWithFormat:@"%lu",(unsigned long)totalStationEditDict.count] forKey:@"circuitCount"];
     NSMutableArray *exerciseIdArray = [[NSMutableArray alloc]init];
     for (int i = 0; i < dataArray.count; i++) {
     [exerciseIdArray addObject:[[dataArray objectAtIndex:i] objectForKey:@"exerciseID"]];
     }
     [saveDict setObject:exerciseIdArray forKey:@"exerciseIDs"];
     if ([roundOptionPickerValue caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
     [saveDict setObject:@"1" forKey:@"modeID"];
     [saveDict setObject:onLabel.text forKey:@"onTime"];
     [saveDict setObject:offLabel.text forKey:@"offTime"];
     rowIdArray = [dbManager saveSessionWithSessionId:sessionID SaveDict:saveDict];
     } else if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
     [saveDict setObject:@"2" forKey:@"modeID"];
     [saveDict setObject:totalRoundEditArray forKey:@"roundData"];
     rowIdArray = [dbManager saveSessionWithSessionId:sessionID SaveDict:saveDict];
     } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
     [saveDict setObject:@"3" forKey:@"modeID"];
     [saveDict setObject:totalStationEditDict forKey:@"stationData"];
     rowIdArray = [dbManager saveSessionWithSessionId:sessionID SaveDict:saveDict];
     }
     
     if (rowIdArray.count > 0) {
     ExerciseVideoViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ExerciseVideo"];
     controller.rowIdArray = rowIdArray;
     controller.prepTime = roundPrepLabel.text;
     [self.navigationController pushViewController:controller animated:YES];
     } else {
     
     }
     } else {
     
     }
     
     //}
     }*/
}
-(IBAction)openPickerModalTapped:(UIButton*)sender {
    int buttonTag = (int)[sender tag];
    NSString *prevVal = @"";
    switch (buttonTag) {
        case 1:
            prevVal = stationCountlabel.text;
            break;
        case 2:
            prevVal = roundsCountlabel.text;
            break;
        case 3:
            prevVal = roundPrepLabel.text;
            break;
        case 4:
            prevVal = roundOptionLabel.text;
            break;
        case 5:
            prevVal = onLabel.text;
            break;
        case 6:
            prevVal = offLabel.text;
            break;
        default:
            
            if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame ) {
                if (buttonTag > 100 && buttonTag < 1000) {
                    prevVal = [[totalRoundEditArray objectAtIndex:buttonTag - 101] objectForKey:@"onTime"];
                } else if (buttonTag > 1000) {
                    prevVal = [[totalRoundEditArray objectAtIndex:buttonTag - 1001] objectForKey:@"offTime"];
                }
            } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                if (buttonTag > 200 && buttonTag < 2000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
                    prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 201] objectForKey:@"onTime"];
                } else if (buttonTag > 2000 && buttonTag < 3000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
                    prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 201] objectForKey:@"offTime"];
                } else if (buttonTag > 3000 && buttonTag < 4000) {
                    NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
                    prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 201] objectForKey:@"reps"];
                } else if (buttonTag > 6000 && buttonTag < 7000) {
                    //                    [self editExerciseOpenWithTag:buttonTag PickerValue:customPickerValue];
                }
            }
            
            break;
    }
    
    PickersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Pickers"];
    controller.customPickerDelegate = self;
    controller.buttonTag = [sender tag];
    if ([fromController isEqualToString:@"session"]) {
        controller.circuitArray = circuitArray;
    }
    controller.prevVal = prevVal;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)onOffTimeButtonTapped:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    
    int buttonTag = (int)[sender tag];
    NSString *prevVal = @"";
    
    if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame ) {
        if (buttonTag > 100 && buttonTag < 1000) {
            prevVal = [[totalRoundEditArray objectAtIndex:buttonTag - 101] objectForKey:@"onTime"];
        } else if (buttonTag > 1000) {
            prevVal = [[totalRoundEditArray objectAtIndex:buttonTag - 1001] objectForKey:@"offTime"];
        }
    } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        if (buttonTag > 200 && buttonTag < 2000) {
            NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
            prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 201] objectForKey:@"onTime"];
        } else if (buttonTag > 2000 && buttonTag < 3000) {
            NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
            prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 2001] objectForKey:@"offTime"];
        } else if (buttonTag > 3000 && buttonTag < 4000) {
            NSString *roundKey = [NSString stringWithFormat:@"round%@",[sender accessibilityHint]];
            prevVal = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 3001] objectForKey:@"reps"];
        } else if (buttonTag > 6000 && buttonTag < 7000) {
            //                    [self editExerciseOpenWithTag:buttonTag PickerValue:customPickerValue];
        }
    }
    
    PickersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Pickers"];
    controller.customPickerDelegate = self;
    controller.buttonTag = [sender tag];
    controller.btnAccessibilityHint = button.accessibilityHint;
    controller.prevVal = prevVal;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)toggleButtonTapped:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger buttonTag = [sender tag];
    
    NSString *roundKey = [NSString stringWithFormat:@"round%@",button.accessibilityHint];
    if ([fromController isEqualToString:@"session"]) {
        roundKey = [NSString stringWithFormat:@"circuit%@",button.accessibilityHint];
    }
    NSMutableDictionary *customDict = [[NSMutableDictionary alloc]init];
    [customDict addEntriesFromDictionary:[[totalStationEditDict objectForKey:roundKey] objectAtIndex:buttonTag - 4001]];
    int repsCount = [[customDict objectForKey:@"reps"] intValue];
    if (repsCount == 0) {
        [customDict removeObjectForKey:@"reps"];
        [customDict setObject:@"20" forKey:@"reps"];
    } else {
        [customDict removeObjectForKey:@"reps"];
        [customDict setObject:@"0" forKey:@"reps"];
        [customDict removeObjectForKey:@"onTime"];
        [customDict setObject:onLabel.text forKey:@"onTime"];
        [customDict removeObjectForKey:@"offTime"];
        [customDict setObject:offLabel.text forKey:@"offTime"];
    }
    
    NSMutableArray *customArray = [[totalStationEditDict objectForKey:roundKey] mutableCopy];
    [customArray replaceObjectAtIndex:buttonTag - 4001 withObject:customDict];
    [totalStationEditDict setObject:customArray forKey:roundKey];
    [stationEditTableView reloadData];
    saveButton.hidden = false;
    //[self animateButton];
}

-(IBAction)editButtonTapped:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    
    clickedIndexpathRow = [sender tag] - 5001;
    clickedIndexpathSection = [button.accessibilityHint intValue];
    
    NSString *roundKey = [NSString stringWithFormat:@"round%ld",(long)clickedIndexpathSection];
    if ([fromController isEqualToString:@"session"]) {
        roundKey = [NSString stringWithFormat:@"circuit%ld",(long)clickedIndexpathSection];
    }
//    int stationId = [[[[totalStationEditDict objectForKey:roundKey] objectAtIndex:clickedIndexpathRow] objectForKey:@"stationID"] intValue];
//    exerciseDict = [dbManager fetchExerciseDetailsWithStationId:stationId];
    [stationEditTableView reloadData];
}

-(IBAction)editExerciseButtonTapped:(UIButton*)sender {
    UIButton *button = (UIButton*)sender;
    
    //    NSLog(@"tag %ld acc %@",[sender tag] - 6001,button.accessibilityHint);
    NSMutableArray *exerciseNameArray = [[NSMutableArray alloc]init];
//    exerciseNameArray = [dbManager fetchExerciseDetailsWithFirstIds:button.accessibilityHint];
    //    NSLog(@"ee %@", exerciseNameArray);
    PickersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Pickers"];
    controller.customPickerDelegate = self;
    controller.buttonTag = [sender tag];
    controller.btnAccessibilityHint = button.accessibilityHint;
    controller.exerciseNameArray = exerciseNameArray;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)saveButtonTapped:(id)sender {
    NSMutableDictionary *saveDict = [[NSMutableDictionary alloc]init];
    if ([roundOptionPickerValue caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
        [dataDict setObject:stationCountlabel.text forKey:@"stationCount"];
        [dataDict setObject:roundsCountlabel.text forKey:@"roundsCount"];
        [dataDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [dataDict setObject:onLabel.text forKey:@"onTime"];
        [dataDict setObject:offLabel.text forKey:@"offTime"];
        [saveDict setObject:@"defaults" forKey:@"mode"];
        [saveDict setObject:dataDict forKey:@"dataDict"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    } else if ([roundOptionPickerValue caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
        NSMutableDictionary *totalRoundEditDict = [[NSMutableDictionary alloc]init];
        [totalRoundEditDict setObject:totalRoundEditArray forKey:@"round"];
        [totalRoundEditDict setObject:stationCountlabel.text forKey:@"station"];
        [saveDict setObject:@"round" forKey:@"mode"];
        [saveDict setObject:totalRoundEditDict forKey:@"dataDict"];
        [saveDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    } else if ([roundOptionPickerValue caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        [saveDict setObject:@"station" forKey:@"mode"];
        [saveDict setObject:totalStationEditDict forKey:@"dataDict"];
        [saveDict setObject:roundPrepLabel.text forKey:@"roundPrepTime"];
        [defaults setObject:saveDict forKey:@"timerSettings"];
    }
    saveButton.hidden = YES;
}
-(IBAction)home:(id)sender{
    //    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
    //        if (shouldPop) {
//    HomePageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomePage"];
//    [self.navigationController pushViewController:controller animated:YES];
    [self stopMusic];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //        }
    //    }];
}
-(IBAction)motivaionButtonTapped:(UIButton *)sender {
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
        [defaults setObject:@"on" forKey:@"Motivation"];
        [defaults synchronize];
        [self startMusic];
        
    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
        [defaults setObject:@"off" forKey:@"Motivation"];
        [defaults synchronize];
        [self stopMusic];
    }
}
-(IBAction)voiceOverButtonTapped:(UIButton *)sender {
    
    /* if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
     [voiceOverButton setImage:[UIImage imageNamed:@"vdo_soundVO.png"] forState:UIControlStateNormal];
     [defaults setObject:@"on" forKey:@"Voice Over"];
     [defaults synchronize];
     } else if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
     [voiceOverButton setImage:[UIImage imageNamed:@"vdo_muteVO.png"] forState:UIControlStateNormal];
     [defaults setObject:@"off" forKey:@"Voice Over"];
     [defaults synchronize];
     }*/
    
    if (sender.isSelected){
        sender.selected = false;
        [defaults setObject:@"on" forKey:@"Voice Over"];
        [defaults synchronize];
        //        if (audioPlayer && !audioPlayer.isPlaying) {
        //            [audioPlayer play];
        //        }
//        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
//            playVoiceOverforYoga = true;
//        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Voice Over"];
        [defaults synchronize];
        //        if (audioPlayer && audioPlayer.isPlaying) {
        //            [audioPlayer pause];
        //        }
//        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
//            playVoiceOverforYoga = false;
//        }
        
    }//AY 11122017
    
    
}
-(IBAction)bellButtonTapped:(UIButton *)sender {
    /*if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
     [bellButton setImage:[UIImage imageNamed:@"vdo_bell.png"] forState:UIControlStateNormal];
     [defaults setObject:@"on" forKey:@"Bell"];
     [defaults synchronize];
     } else if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
     [bellButton setImage:[UIImage imageNamed:@"vdo_no_bell.png"] forState:UIControlStateNormal];
     [defaults setObject:@"off" forKey:@"Bell"];
     [defaults synchronize];
     }*/
    
    if (sender.isSelected){
        sender.selected = false;
        [defaults setObject:@"on" forKey:@"Bell"];
        [defaults synchronize];
        
//        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
//            playBuzzforYoga = true;
//
//        }
        
    }else{
        sender.selected = true;
        [defaults setObject:@"off" forKey:@"Bell"];
        [defaults synchronize];
        
//        if ([_workoutType caseInsensitiveCompare:@"Yoga"] == NSOrderedSame){
//            playBuzzforYoga = false;
//        }
        
    }//AY 11122017
}
-(void)stopMusic{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 1) {
        [[MPMusicPlayerController systemMusicPlayer] pause];
    }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && [SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
        [[SPTAudioStreamingController sharedInstance] setIsPlaying:NO callback:nil];
    }
}
-(void) startMusic {
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame && [[defaults objectForKey:@"Inbetween Rounds"] caseInsensitiveCompare:@"STOPS PLAYING"] != NSOrderedSame) {
        NSLog(@"%ld",(long)[MPMusicPlayerController systemMusicPlayer].currentPlaybackRate);
        if (![Utility isEmptyCheck:[defaults objectForKey:@"mediaItemCollection"]] && [MPMusicPlayerController systemMusicPlayer].currentPlaybackRate == 0) {
            [[MPMusicPlayerController systemMusicPlayer] play];
        }else if(![Utility isEmptyCheck:[defaults objectForKey:@"selectedSpotifyCollectionUri"]] && [[SPTAudioStreamingController sharedInstance] initialized] && ![SPTAudioStreamingController sharedInstance].playbackState.isPlaying){
            NSLog(@"------%@",[SPTAudioStreamingController sharedInstance]);
            [[SPTAudioStreamingController sharedInstance] setIsPlaying:YES callback:nil];
        }
    }
}
- (IBAction)myMusicPressed:(UIButton *)sender {
    SettingsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
    controller.circuitPlaying = true;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private Method
-(void)updateFooter{
    if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"off"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_mute.png"] forState:UIControlStateNormal];
    } else if ([defaults objectForKey:@"Motivation"] && ![[defaults objectForKey:@"Motivation"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Motivation"] caseInsensitiveCompare:@"on"] == NSOrderedSame) {
        [volumeButton setImage:[UIImage imageNamed:@"vdo_sound.png"] forState:UIControlStateNormal];
    }
    
    if ([defaults objectForKey:@"Voice Over"] && ![[defaults objectForKey:@"Voice Over"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Voice Over"] caseInsensitiveCompare:@"off"] == NSOrderedSame){
        voiceOverButton.selected = true;
    }else{
        voiceOverButton.selected = false;
    }
    
    if ([defaults objectForKey:@"Bell"] && ![[defaults objectForKey:@"Bell"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Bell"] caseInsensitiveCompare:@"off"] == NSOrderedSame){
        bellButton.selected = true;
    }else{
        bellButton.selected = false;
    }
}
//-(void)getData{
////    NSString *roundCount = [dbManager fetchRoundCountWithSessionId:sessionID];
//    NSInteger stCount;
////    dataArray = [dbManager fetchSessionDetailsWithSessionId:sessionID];
//    //    NSLog(@"da %@",dataArray);
//    //    exerciseDict = [dbManager fetchExerciseDetailsWithStationId:[dataArray object]];
////    circuitArray = [dbManager fetchCircuitDetailsWithSessionId:sessionID];
//    //    -(NSMutableDictionary *) fetchCountsFromCircuitId:(int)circuitID
////    countDict = [dbManager fetchCountsFromCircuitId:[[[circuitArray objectAtIndex:selectedCircuit] objectForKey:@"circuitID"] intValue]];
//
//    selectedCircuitLabel.text = [[circuitArray objectAtIndex:0] objectForKey:@"circuitName"];
//
//    stationCountlabel.text = [NSString stringWithFormat:@"%d",[[countDict objectForKey:@"stationCount"] intValue]/[[countDict objectForKey:@"roundCount"] intValue]];//[NSString stringWithFormat:@"%lu",dataArray.count/[roundCount intValue]];
//    //    stCount = dataArray.count/[roundCount intValue];
//    roundsCountlabel.text = [countDict objectForKey:@"roundCount"];//roundCount;
//    roundPrepLabel.text = prepTime;
//    onLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"stationOnTime"];
//    offLabel.text = [[dataArray objectAtIndex:0] objectForKey:@"stationOffTime"];
//
//    switch ([modeID intValue]) {
//
//        case 1:
//            roundOptionPickerValue = @"STATION EDIT";
//            roundOptionLabel.text = @"CUSTOM STATIONS";
//            //            [self updateConstraintsFromValue:@"DEFAULT"];
//
//            bottomLeftBgView.hidden = false;
//            bottomRightBgView.hidden = false;
//            roundEditTableView.hidden = true;
//            stationEditTableView.hidden = true;
//            [mainScroll removeConstraint:roundTableBottomConstraint];
//            [mainScroll removeConstraint:stationTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            bottomRightBgViewBottomConstraint = [NSLayoutConstraint
//                                                 constraintWithItem:roundEditTableView
//                                                 attribute:NSLayoutAttributeBottom
//                                                 relatedBy:NSLayoutRelationEqual
//                                                 toItem:mainScroll
//                                                 attribute:NSLayoutAttributeBottom
//                                                 multiplier:1.0f
//                                                 constant:0.f];
//
//            [mainScroll addConstraint:bottomRightBgViewBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            break;
//
//        case 2:
//            roundOptionPickerValue = @"STATION EDIT";
//            roundOptionLabel.text = @"CUSTOM STATIONS";
//            roundEditTableView.hidden = NO;
//
//            for (int i = 0; i < [roundCount intValue]; i++) {
//                if (i == 0 || i == stCount) {
//                    stCount = stCount + i;
//                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[dataArray objectAtIndex:i] objectForKey:@"stationOnTime"],@"onTime", [[dataArray objectAtIndex:i] objectForKey:@"stationOffTime"],@"offTime", nil];
//                    [totalRoundEditArray addObject:dict];
//                }
//            }
//            //            [self updateConstraintsFromValue:@"ROUND EDIT"];
//
//            numberOfRowsInSection = [roundsCountlabel.text intValue];
//            [roundEditTableView reloadData];
//
//            bottomLeftBgView.hidden = true;
//            bottomRightBgView.hidden = true;
//            roundEditTableView.hidden = false;
//            stationEditTableView.hidden = true;
//            [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//            [mainScroll removeConstraint:stationTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            roundTableBottomConstraint = [NSLayoutConstraint
//                                          constraintWithItem:roundEditTableView
//                                          attribute:NSLayoutAttributeBottom
//                                          relatedBy:NSLayoutRelationEqual
//                                          toItem:mainScroll
//                                          attribute:NSLayoutAttributeBottom
//                                          multiplier:1.0f
//                                          constant:0.f];
//
//            [mainScroll addConstraint:roundTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            break;
//
//        case 3:
//            roundOptionPickerValue = @"STATION EDIT";
//            roundOptionLabel.text = @"CUSTOM STATIONS";
//            stationEditTableView.hidden = NO;
//            int k = 0;
//
//            int prevRoundId = -1;
//            int newRoundId = -2;
//
//
//            for (int i = 0; i < circuitArray.count; i++) {   ////
//                int roundsCount = 0;
//                int stationNo = 0;
//                NSMutableArray *stationArray = [[NSMutableArray alloc]init];
//                //loop round in circuit i
////                int stationsCount = [dbManager fetchStationCountFromCircuitID:[[[circuitArray objectAtIndex:i] objectForKey:@"circuitID"] intValue]];
//                for (int j = 0; j < stationsCount; j++) {    ////
//                    newRoundId = [[[dataArray objectAtIndex:k] objectForKey:@"roundID"] intValue];
//                    if (newRoundId != prevRoundId) {
//                        if ([[[dataArray objectAtIndex:k] objectForKey:@"roundType"] isEqualToString:@"tdefault"]) {
//                            roundsCount++;
//                        }
//                        prevRoundId = newRoundId;
//                        stationNo = 0;
//                    }
//                    stationNo++;
//                    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:[[dataArray objectAtIndex:k] objectForKey:@"stationID"],@"stationID", [[dataArray objectAtIndex:k] objectForKey:@"circuitID"],@"circuitID", [[dataArray objectAtIndex:k] objectForKey:@"stationOnTime"],@"onTime", [[dataArray objectAtIndex:k] objectForKey:@"stationOffTime"],@"offTime",[[dataArray objectAtIndex:k] objectForKey:@"stationReps"],@"reps",[NSString stringWithFormat:@"round %02d",roundsCount],@"roundName",[NSString stringWithFormat:@"%02d",roundsCount], @"roundCount", [NSString stringWithFormat:@"%02d",stationNo], @"stationCount", [[dataArray objectAtIndex:k] objectForKey:@"roundType"],@"roundType", [[dataArray objectAtIndex:k] objectForKey:@"isSuperSet"],@"isSuperSet", [[dataArray objectAtIndex:k] objectForKey:@"superSetPosition"],@"superSetPosition",[[dataArray objectAtIndex:k] objectForKey:@"setCount"],@"setCount",nil];
//                    [stationArray addObject:dict];
//                    k++;
//                }
//                NSString *circuitKey = [NSString stringWithFormat:@"circuit%d",i];
//                [totalStationEditDict setObject:stationArray forKey:circuitKey];
//            }
//            //            [self updateConstraintsFromValue:@"STATION EDIT"];
//
//            numberOfRowsInSection = [stationCountlabel.text intValue];
//            [stationEditTableView reloadData];
//
//            bottomLeftBgView.hidden = true;
//            bottomRightBgView.hidden = true;
//            roundEditTableView.hidden = true;
//            stationEditTableView.hidden = false;
//            [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//            [mainScroll removeConstraint:roundTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            stationTableBottomConstraint = [NSLayoutConstraint
//                                            constraintWithItem:stationEditTableView
//                                            attribute:NSLayoutAttributeBottom
//                                            relatedBy:NSLayoutRelationEqual
//                                            toItem:mainScroll
//                                            attribute:NSLayoutAttributeBottom
//                                            multiplier:1.0f
//                                            constant:0.f];
//
//            [mainScroll addConstraint:stationTableBottomConstraint];
//            [mainScroll setNeedsUpdateConstraints];
//            break;
//
//        default:
//            break;
//    }
//}
-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}
-(void)updateConstraintsFromValue:(NSString *)pickerVal {
    if ([pickerVal caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
        bottomLeftBgView.hidden = false;
        bottomRightBgView.hidden = false;
        bottomBgView.hidden = false;
        roundEditTableView.hidden = true;
        stationEditTableView.hidden = true;
//        [mainScroll removeConstraint:roundTableBottomConstraint];
//        [mainScroll removeConstraint:stationTableBottomConstraint];
//        [mainScroll setNeedsUpdateConstraints];
//        bottomRightBgViewBottomConstraint = [NSLayoutConstraint
//                                             constraintWithItem:roundEditTableView
//                                             attribute:NSLayoutAttributeBottom
//                                             relatedBy:NSLayoutRelationEqual
//                                             toItem:mainScroll
//                                             attribute:NSLayoutAttributeBottom
//                                             multiplier:1.0f
//                                             constant:0.f];
//
//        [mainScroll addConstraint:bottomRightBgViewBottomConstraint];
    } else if ([pickerVal caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
        [totalRoundEditArray removeAllObjects];
        numberOfRowsInSection = 0;
        [roundEditTableView reloadData];
        for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime", nil];
            [totalRoundEditArray addObject:dict];
        }
        numberOfRowsInSection = [roundsCountlabel.text intValue];
        [roundEditTableView reloadData];
        
        bottomLeftBgView.hidden = true;
        bottomRightBgView.hidden = true;
        bottomBgView.hidden = true;
        roundEditTableView.hidden = false;
        stationEditTableView.hidden = true;
//        [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//        [mainScroll removeConstraint:stationTableBottomConstraint];
//        [roundEditTableView removeConstraint:roundEditTableHeightConstraint];   //////aa
//        [mainScroll setNeedsUpdateConstraints];
//        roundTableBottomConstraint = [NSLayoutConstraint
//                                      constraintWithItem:roundEditTableView
//                                      attribute:NSLayoutAttributeBottom
//                                      relatedBy:NSLayoutRelationEqual
//                                      toItem:mainScroll
//                                      attribute:NSLayoutAttributeBottom
//                                      multiplier:1.0f
//                                      constant:0.f];
//        roundEditTableHeightConstraint = [NSLayoutConstraint
//                                          constraintWithItem:roundEditTableView
//                                          attribute:NSLayoutAttributeHeight
//                                          relatedBy:0
//                                          toItem:nil
//                                          attribute:NSLayoutAttributeHeight
//                                          multiplier:1.0
//                                          constant:roundEditTableView.contentSize.height];
//        [roundEditTableView addConstraint:roundEditTableHeightConstraint];
//        [mainScroll addConstraint:roundTableBottomConstraint];
    } else if ([pickerVal caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
        [totalStationEditDict removeAllObjects];
        //        numberOfRowsInSection = 0;
        //        [stationEditTableView reloadData];
        NSLog(@"rr %@ - ss %@",roundsCountlabel.text,stationCountlabel.text);
        for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {   ////
            
            NSMutableArray *stationArray = [[NSMutableArray alloc]init];
            for (int j = 0; j < [stationCountlabel.text intValue]; j++) {    ////
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime",@"0",@"reps", nil];
                [stationArray addObject:dict];
            }
            NSString *roundKey = [NSString stringWithFormat:@"round%d",i];
            [totalStationEditDict setObject:stationArray forKey:roundKey];
        }
        numberOfRowsInSection = [stationCountlabel.text intValue];
        [stationEditTableView reloadData];
        
        bottomLeftBgView.hidden = true;
        bottomRightBgView.hidden = true;
        bottomBgView.hidden = true;
        roundEditTableView.hidden = true;
        stationEditTableView.hidden = false;
//        [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
//        [mainScroll removeConstraint:roundTableBottomConstraint];
//        [roundEditTableView removeConstraint:roundEditTableHeightConstraint];/////aaa
//        [mainScroll setNeedsUpdateConstraints];
//        stationTableBottomConstraint = [NSLayoutConstraint
//                                        constraintWithItem:stationEditTableView
//                                        attribute:NSLayoutAttributeBottom
//                                        relatedBy:NSLayoutRelationEqual
//                                        toItem:mainScroll
//                                        attribute:NSLayoutAttributeBottom
//                                        multiplier:1.0f
//                                        constant:0.f];
//
//        [mainScroll addConstraint:stationTableBottomConstraint];
        
        
        
        /*  [totalStationEditDict removeAllObjects];
         numberOfRowsInSection = 0;
         [stationEditTableView reloadData];
         NSLog(@"rr %@ - ss %@",roundsCountlabel.text,stationCountlabel.text);
         for (int i = 0; i < [roundsCountlabel.text intValue]; i++) {   ////
         
         NSMutableArray *stationArray = [[NSMutableArray alloc]init];
         for (int j = 0; j < [stationCountlabel.text intValue]; j++) {    ////
         NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:onLabel.text,@"onTime", offLabel.text,@"offTime",@"0",@"reps", nil];
         [stationArray addObject:dict];
         }
         NSString *roundKey = [NSString stringWithFormat:@"round%d",i];
         [totalStationEditDict setObject:stationArray forKey:roundKey];
         }
         numberOfRowsInSection = [stationCountlabel.text intValue];
         [stationEditTableView reloadData];
         
         bottomLeftBgView.hidden = true;
         bottomRightBgView.hidden = true;
         roundEditTableView.hidden = true;
         stationEditTableView.hidden = false;
         [mainScroll removeConstraint:bottomRightBgViewBottomConstraint];
         [mainScroll removeConstraint:roundTableBottomConstraint];
         [mainScroll setNeedsUpdateConstraints];
         stationTableBottomConstraint = [NSLayoutConstraint
         constraintWithItem:stationEditTableView
         attribute:NSLayoutAttributeBottom
         relatedBy:NSLayoutRelationEqual
         toItem:mainScroll
         attribute:NSLayoutAttributeBottom
         multiplier:1.0f
         constant:0.f];
         
         [mainScroll addConstraint:stationTableBottomConstraint];
         
         //                    CGFloat height1 = stationEditTableView.contentSize.height;
         //                    stationEditTableHeightConstraint.constant = height1;
         //                    [self.view setNeedsUpdateConstraints];
         
         //            [mainScroll setNeedsUpdateConstraints];*/
        
    }
    [mainScroll setNeedsUpdateConstraints];
}

-(void)editExerciseOpenWithTag:(NSInteger)tag PickerValue:(NSString *)pickerVal {
    //    UIButton *button = (UIButton*)sender;
//    NSInteger stationID = tag - 6001;
    
    //    for (int i = 0; i < dataArray.count; i++) {
    //        NSInteger oldStationID = [[[dataArray objectAtIndex:i] objectForKey:@"stationID"] intValue];
    //        if (oldStationID == stationID) {
    //            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //            [dict addEntriesFromDictionary:[dataArray objectAtIndex:i]];
    //            [dict setObject:pickerVal forKey:@"exerciseID"];
    //
    //        }
    //    }
    
//    exerciseDict = [dbManager fetchExerciseDetailsWithExerciseID:pickerVal StationID:stationID];
//    [self getData];
    //    [stationEditTableView reloadData];
}

-(void)playVideoWithName:(NSString *)videoName View:(UIView *)mainView{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *myFile = [mainBundle pathForResource: videoName ofType: @"mp4"];
    //    NSLog(@"Main bundle path: %@", mainBundle);
    //    NSLog(@"myFile path: %@", myFile);
    
    NSURL *videoURL = [NSURL fileURLWithPath:myFile];
    
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    // create an AVPlayer
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
    controller.player = videoPlayer;
    controller.showsPlaybackControls = false;
    
    //loops
    videoPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[videoPlayer currentItem]];
    
    [videoPlayer play];
    
    // show the view controller
    [self addChildViewController:controller];
    [mainView addSubview:controller.view];
    controller.view.frame = mainView.bounds;
    
    //    [self playAudioWithName:[audioNamesArray objectAtIndex:audioCounter]];
}
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *videoPlayerItem = [notification object];
    [videoPlayerItem seekToTime:kCMTimeZero];
}
-(void)animateButton {
    CGFloat alphaVal = 0.0;
    if (!saveButton.isHidden) {
        if (isHighAlpha) {
            alphaVal = 0.2;
            isHighAlpha = NO;
        } else {
            alphaVal = 1.0;
            isHighAlpha = YES;
        }
        
        [UIView animateWithDuration:1.5f animations:^{
            [self->saveButton setAlpha:alphaVal];
        } completion:^(BOOL finished) {
            [self animateButton];
        }];
    }
}
#pragma mark - Table view Delegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == roundEditTableView) {
        return 1;
    } else if (tableView == stationEditTableView) {
        //        return [roundsCountlabel.text intValue];
        if ([fromController isEqualToString:@"session"]) {
            return circuitArray.count;
        } else {
            return [roundsCountlabel.text intValue];
        }
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == roundEditTableView) {
        return totalRoundEditArray.count;
    } else if (tableView == stationEditTableView) {
        if (totalStationEditDict.count > 0) {
            NSString *circuitKey;
            if ([fromController isEqualToString:@"session"]) {
                circuitKey = [NSString stringWithFormat:@"circuit%ld",section];
            } else {
                circuitKey = [NSString stringWithFormat:@"round0"];
            }
            
            NSArray *stationArry = [totalStationEditDict objectForKey:circuitKey];
            NSLog(@"rree %lu",(unsigned long)stationArry.count);
            return stationArry.count;
        } else {
            return 0;
        }
        
    }
    return 0;//numberOfRowsInSection = [roundsCountlabel.text intValue];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    /* Create custom view to display section header... */
    
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont fontWithName:@"Oswald-Light" size:30]];
    //    [label setText:[NSString stringWithFormat:@"ROUND %ld",section+1]];
    if ([fromController isEqualToString:@"session"]) {
        [label setText:[[circuitArray objectAtIndex:section] objectForKey:@"circuitName"]];
    } else {
        [label setText:[NSString stringWithFormat:@"ROUND %ld",section+1]];
    }
    
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [customHeaderView addSubview:label];
    
    
    [customHeaderView addSubview:label];
    
    NSLayoutConstraint *centerYLabel = [NSLayoutConstraint
                                        constraintWithItem:label
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:customHeaderView
                                        attribute:NSLayoutAttributeCenterY
                                        multiplier:1.f
                                        constant:0.f];
    
    NSLayoutConstraint *centerXLabel = [NSLayoutConstraint
                                        constraintWithItem:label
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                        toItem:customHeaderView
                                        attribute:NSLayoutAttributeCenterX
                                        multiplier:1.f
                                        constant:0.f];
    
    [customHeaderView addConstraint:centerYLabel];
    [customHeaderView addConstraint:centerXLabel];
    
    [customHeaderView setBackgroundColor:[UIColor clearColor]]; //your background color...
    return customHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == roundEditTableView) {
        return 0;
    } else if (tableView == stationEditTableView) {
        return 80.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //        NSLog(@"ir1 %ld is1 %ld",(long)indexPath.row,(long)indexPath.section);
    
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (tableView == roundEditTableView) {
        cell.roundEditTableCountLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.roundEditTableOnTime.text = [[totalRoundEditArray objectAtIndex:indexPath.row] objectForKey:@"onTime"];
        cell.roundEditTableOffTime.text = [[totalRoundEditArray objectAtIndex:indexPath.row] objectForKey:@"offTime"];
        if ((int)indexPath.row % 2 == 0) {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(191/255.0) green:(149/255.0) blue:(211/255.0) alpha:0.8]];
        } else {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(118/255.0) green:(148/255.0) blue:(230/255.0) alpha:0.8]];
        }
        [cell.roundEditTableOnButton setTag:indexPath.row+101];
        [cell.roundEditTableOnButton addTarget:self action:@selector(onOffTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.roundEditTableOffButton setTag:indexPath.row+1001];
        [cell.roundEditTableOffButton addTarget:self action:@selector(onOffTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    } else if (tableView == stationEditTableView) {
        cell.stationEditTableRoundCountLabel.text = [NSString stringWithFormat:@"%ld",indexPath.section+1];
        cell.stationEditTableStationCountLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        if ([fromController isEqualToString:@"session"]) {
            NSString *circuitKey = [NSString stringWithFormat:@"circuit%ld",indexPath.section];
            
            cell.stationEditTableRoundCountLabel.text = [[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"roundCount"];
            if (![[[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"roundType"] isEqualToString:@"tdefault"]) {
                roundCountDiff++;
                if ([[[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"roundType"] caseInsensitiveCompare:@"w"] == NSOrderedSame) {
                    cell.stationEditTableRoundName.text = @"WARM UP";
                    cell.stationEditTableRoundCountLabel.hidden = true;
                } else if ([[[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"roundType"] caseInsensitiveCompare:@"s"] == NSOrderedSame) {
                    cell.stationEditTableRoundName.text = @"COOL DOWN";
                    cell.stationEditTableRoundCountLabel.hidden = true;
                }
                //                cell.stationEditTableRoundCountLabel.text = [NSString stringWithFormat:@"%@",[[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"roundType"]];
            } else {
                cell.stationEditTableRoundName.text = @"ROUND";
                cell.stationEditTableRoundCountLabel.hidden = false;
            }
            cell.stationEditTableStationCountLabel.text = [[[totalStationEditDict objectForKey:circuitKey] objectAtIndex:indexPath.row] objectForKey:@"stationCount"];
        }
        [cell.stationEditTableToggleButton addTarget:self action:@selector(toggleButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.stationEditTableToggleButton setTag:indexPath.row+4001];
        [cell.stationEditTableToggleButton setAccessibilityHint:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        
        [cell.stationEditTableEditButton addTarget:self action:@selector(editButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cell.stationEditTableEditButton setTag:indexPath.row+5001];
        [cell.stationEditTableEditButton setAccessibilityHint:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        
        if ((int)indexPath.row % 2 == 0) {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(191/255.0) green:(149/255.0) blue:(211/255.0) alpha:0.8]];
        } else {
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:(118/255.0) green:(148/255.0) blue:(230/255.0) alpha:0.8]];
        }
        
        NSString *roundKey = [NSString stringWithFormat:@"round%ld",indexPath.section];
        if ([fromController isEqualToString:@"session"]) {
            roundKey = [NSString stringWithFormat:@"circuit%ld",indexPath.section];
        }
        int repsCount = [[[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"reps"] intValue];
        if (repsCount == 0) {
            cell.stationEditTableOnTime.text = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"onTime"];
            cell.stationEditTableOffTime.text = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"offTime"];
            
            cell.stationEditTableOnButton.hidden = false;
            [cell.stationEditTableOnButton setTag:indexPath.row+201];
            [cell.stationEditTableOnButton setAccessibilityHint:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [cell.stationEditTableOnButton addTarget:self action:@selector(onOffTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.stationEditTableOffButton setTag:indexPath.row+2001];
            [cell.stationEditTableOffButton setAccessibilityHint:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [cell.stationEditTableOffButton addTarget:self action:@selector(onOffTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.stationEditTableRepsLabel.hidden = true;
            cell.stationEditTableRepsCountLabel.hidden = true;
            cell.onTimeLabel.hidden = false;
            cell.offTimeLabel.hidden = false;
            cell.stationEditTableOnTime.hidden = false;
            cell.stationEditTableOffTime.hidden = false;
            
            [cell.stationEditTableToggleButton setImage:[UIImage imageNamed:@"clock_timer.png"] forState:UIControlStateNormal];
        } else {
            cell.onTimeLabel.hidden = true;
            cell.offTimeLabel.hidden = true;
            cell.stationEditTableOnTime.hidden = true;
            cell.stationEditTableOffTime.hidden = true;
            cell.stationEditTableOnButton.hidden = true;
            [cell.stationEditTableOffButton setTag:indexPath.row+3001];
            [cell.stationEditTableOffButton setAccessibilityHint:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            [cell.stationEditTableOffButton addTarget:self action:@selector(onOffTimeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.stationEditTableRepsLabel.hidden = false;
            cell.stationEditTableRepsCountLabel.hidden = false;
            cell.stationEditTableRepsCountLabel.text = [[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"reps"];
            
            [cell.stationEditTableToggleButton setImage:[UIImage imageNamed:@"reps_icon.png"] forState:UIControlStateNormal];
        }
        
        int stID = [[[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"stationID"] intValue];
        if (stID > 0) {
//            exerciseDict = [dbManager fetchExerciseDetailsWithStationId:[[[[totalStationEditDict objectForKey:roundKey] objectAtIndex:indexPath.row] objectForKey:@"stationID"] intValue]];
        } else {
//            exerciseDict = [dbManager fetchExerciseDetailsFirstIdStr:[NSString stringWithFormat:@"%@,%@,%@",[exerciseDict objectForKey:@"catID"],[exerciseDict objectForKey:@"subCatID"],[exerciseDict objectForKey:@"typeID"]]];
            //            exerciseDict
        }
        
        cell.sessionViewExerciseNameLabel.text = [exerciseDict objectForKey:@"name"];
        
        if (indexPath.row == clickedIndexpathRow && indexPath.section == clickedIndexpathSection) {
            cell.stationBottomViewExerciseNameLabel.text = [exerciseDict objectForKey:@"name"];
            cell.stationBottomViewExerciseDetails.text = [exerciseDict objectForKey:@"details"];
            NSString *imgPath = [exerciseDict objectForKey:@"imagePath"];
            if (imgPath.length > 0) {
                cell.stationBottomViewExerciseImage.image = [UIImage imageNamed:imgPath];
            }
            [cell.stationBottomViewExerciseEdit addTarget:self action:@selector(editExerciseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.stationBottomViewExerciseEdit setTag:[[exerciseDict objectForKey:@"stationID"] intValue] + 6001];
            [cell.stationBottomViewExerciseEdit setAccessibilityHint:[NSString stringWithFormat:@"%@,%@,%@",[exerciseDict objectForKey:@"catID"],[exerciseDict objectForKey:@"subCatID"],[exerciseDict objectForKey:@"typeID"]]];
            [self playVideoWithName:[exerciseDict objectForKey:@"name"] View:cell.stationBottomViewExerciseVideoView];
        }
    }
    [cell layoutIfNeeded];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //        NSLog(@"ir %ld is %ld",(long)indexPath.row,(long)indexPath.section);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    //    NSLog(@"ir %ld is %ld",(long)indexPath.row,(long)indexPath.section);
    if (tableView == stationEditTableView && indexPath.row == clickedIndexpathRow && indexPath.section == clickedIndexpathSection) {
        NSString *CellIdentifier =@"TableViewCell";
        TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        //        CGFloat totalHeight = cell.stationBottomViewExerciseImage.frame.origin.y + cell.stationBottomViewExerciseImage.frame.size.height + cell.stationBottomViewExerciseDetails.intrinsicContentSize.height + 20.0;
        
        return cell.stationEditTableBottomView.frame.size.height+cell.stationEditTableBottomView.frame.origin.y + 10.0;//303.0;
    }
    if (tableView == stationEditTableView) {
        return 90;
    }
    return 80.0;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
#pragma mark - End
#pragma mark -Music delegate
-(void)updateRoundlist{
//    self->showMusicAlert = false;
//    [self pushButtonTapped:0];
    TimerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TimerView"];
    controller.dataDict = dataDict;
    controller.mode = @"DEFAULT";
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End
@end
