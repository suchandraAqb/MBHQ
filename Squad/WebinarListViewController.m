//
//  WebinarListViewController.m
//  The Life
//
//  Created by AQB SOLUTIONS on 04/04/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "WebinarListViewController.h"
#import "WebinarListTableViewCell.h"
#import "WebinarSelectedViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utility.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PodcastViewController.h"
#import "AppDelegate.h"
#import "WebinarListTagTableViewCell.h"
#import "WebinarListDurationTableViewCell.h"
#import "WebinarDetailsEntryViewController.h"
#import "CircleProgressBar.h"
#import "MeditationRewardViewController.h"
@import Photos;

@interface WebinarListViewController (){
    IBOutlet UITableView *webinarListTable;
    IBOutlet UIImageView *headerBg;
    IBOutlet UIButton *filterButton;
    
    IBOutlet UILabel *nodataLabel;
    IBOutlet UITextField *searchTextField;
    IBOutlet UILabel *noDataLabelForTable;
    
    IBOutlet UIView *landingView;
    IBOutletCollection(UIButton) NSArray *landingButtons;
    IBOutlet UIButton *powerUpButton;
    
    IBOutlet UIView *landingView2;
    IBOutlet UIView *landingView3;
    IBOutlet UIView *landingView4;
    IBOutlet UIView *landingView5;
    
    
    
    IBOutlet UIView *filterView;
    
    IBOutlet UITableView *tagFilterTable;
    IBOutlet UITableView *durationFilterTable;
    
    IBOutlet UIButton *favFilterButton;
    IBOutlet UIButton *showResultButton;
    IBOutlet UIButton *removeFilterButton;
    
    IBOutlet UIView *walkThroughView;
    IBOutlet UIButton *walkThroughOkButton;
    IBOutlet UIButton *walkThroughLaterButton;
    IBOutlet UIButton *walkThroughDontShowButton;
    
    IBOutlet UIView *editDelView;
    IBOutlet UIView *editDelSubView;
    IBOutlet UIButton *yesButton;
    IBOutlet UIButton *noButton;
    
    
    IBOutlet UIView *descriptionSubview;
    IBOutlet UIView *descriptionView;
    IBOutlet UIImageView *webinarImage;
    IBOutlet UILabel *webinarNameLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *webinarTypeLabel;
    IBOutlet UITextView *descriptionText;
    IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;
    IBOutlet UIButton *startButton;
    IBOutlet UILabel *webinarLevelLabel;
    IBOutlet NSLayoutConstraint *descriptionSubViewHeightConstraint;
    IBOutlet CircleProgressBar *circleProgresBar;
    IBOutlet UIView *progressView;
    IBOutlet UILabel *progessBarTextLabel;
    IBOutlet UIView *progressSubView;
    
    IBOutlet UIButton *findMyLevelButton;
    
    
    
    UIToolbar *toolBar;

    AVPlayer *player;

    NSMutableArray *webinarList;
    NSMutableArray *webinarMasterList;
    
    NSMutableArray *webinarListForSearch;
    UIView *contentView;
    NSArray *filterArray;
    int count;
    BOOL isFromWebinarListApi;
    BOOL isDownloading;
    BOOL isFirstLoad;
    NSMutableDictionary *backgroundDownloadDict;
    NSMutableDictionary *indexPathAndTaskDict;
    
    NSDictionary *parentSelectedDict;
    NSDictionary *subSelectedDict;
    
    NSMutableArray *tagsArray;
    NSArray *eventTagList;
    NSMutableArray *durationListArray;
    
    UIRefreshControl *refreshControl;
    NSMutableArray *selectedTagArray;
    NSMutableArray *selectedDurationArray;
    
    NSMutableArray *levelListArray;
    NSMutableArray *selectedLevelArray;
    
    BOOL isSelectedFavFilter;
    NSString *backButtonIdentifier;
    int eventID;
    BOOL showShopping;
    NSString *shopUrl;
    NSURLSessionDownloadTask *eventDownloadTask;
    NSDictionary *webinarsData;
}

@end

@implementation WebinarListViewController
@synthesize selectedFilterDict,isNotFromHome,isFromCourse,isFromDetails;

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        headerBg.image = [UIImage imageNamed:@"header-4s.png"];
    }else{
        headerBg.image = [UIImage imageNamed:@"header.png"];
    }
    
    isFirstLoad = true;
    count = 1;
    webinarList = [[NSMutableArray alloc]init];
    webinarListForSearch=[[NSMutableArray alloc]init];
    webinarMasterList= [[NSMutableArray alloc]init];
    tagsArray=[[NSMutableArray alloc]init];
    durationListArray=[[NSMutableArray alloc]init];
    selectedTagArray=[[NSMutableArray alloc]init];
    selectedDurationArray=[[NSMutableArray alloc]init];
    levelListArray=[[NSMutableArray alloc]init];
    selectedLevelArray=[[NSMutableArray alloc]init];
    
    
    
    filterArray = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"Key",@"Remove Filter",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"GetEventTagListApiCall",@"Key",@"Tags",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"DurationFilter",@"Key",@"Duration",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"Key",@"Favourites",@"Value",nil], nil];
    
//  filterArray = [[NSArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"Key",@"Remove Filter",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"GetEventTypeListApiCall",@"Key",@"Event Type",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"GetArchiveYearsApiCall",@"Key",@"Date",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"GetPresenterListApiCall",@"Key",@"Presenter",@"Value",nil],[[NSDictionary alloc]initWithObjectsAndKeys:@"GetEventTagListApiCall",@"Key",@"Tags",@"Value",nil], nil];
    
    
    //level
    NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 1"],@"LevelString",[NSNumber numberWithInt:1],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 2"],@"LevelString",[NSNumber numberWithInt:2],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 3"],@"LevelString",[NSNumber numberWithInt:3],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 4"],@"LevelString",[NSNumber numberWithInt:4],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 5"],@"LevelString",[NSNumber numberWithInt:5],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 6"],@"LevelString",[NSNumber numberWithInt:6],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"Level 7"],@"LevelString",[NSNumber numberWithInt:7],@"Level", nil];
    [self->levelListArray addObject:durationDict];
    
    
    
    //[self addFooter];
    isFromWebinarListApi = YES;
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquat"];
    sessionConfiguration.allowsCellularAccess = YES;

    self.session = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                 delegate:self
                                            delegateQueue:nil];
    NSLog(@"%@",self.session);
//    if (isNotFromHome) {
//        filterButton.hidden = true;
//    }
    
//      NSURLSessionConfiguration *sessionConfiguration1 = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquatWebinarDetails11"];
//      sessionConfiguration.allowsCellularAccess = YES;
//
//      self.session1 = [NSURLSession sessionWithConfiguration:sessionConfiguration1
//                                                   delegate:self
//                                              delegateQueue:nil];

    
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
    
    
    for (UIButton *btn in landingButtons) {
        btn.clipsToBounds=YES;
        if (btn.tag==3) {
            btn.backgroundColor=UIColor.whiteColor;
//            btn.layer.borderWidth = 1;
//            btn.layer.borderColor=[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
//            btn.layer.cornerRadius=btn.frame.size.height/2;
        }else{
            btn.backgroundColor=squadMainColor;
            btn.layer.cornerRadius=btn.frame.size.height/2;
        }
    }
    
    powerUpButton.backgroundColor=squadMainColor;
    powerUpButton.layer.cornerRadius=powerUpButton.frame.size.height/2;
    
//    landingView.hidden=false;
//    landingView2.hidden=true;
//    landingView3.hidden=true;
//    landingView4.hidden=true;
//    landingView5.hidden=true;
    filterView.hidden=true;
    
    
    //Description popup setup-------------
    startButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
    startButton.clipsToBounds = YES;
    startButton.layer.borderWidth = 1.2;
    startButton.layer.cornerRadius = startButton.frame.size.height/2.0;
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startButton setTitle:@"START" forState:UIControlStateNormal];
    [startButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
    descriptionSubview.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
    descriptionSubview.layer.borderWidth=1;
    descriptionSubview.layer.cornerRadius=15;
    descriptionSubview.clipsToBounds=YES;
    descriptionSubview.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
    
    //Description popup setup
    
    //[self offlineMeditationList];
    
    //pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        webinarListTable.refreshControl = refreshControl;
    } else {
        [webinarListTable addSubview:refreshControl];
    }
    
    showResultButton.layer.cornerRadius=15;
    showResultButton.layer.masksToBounds=true;
    
    removeFilterButton.layer.borderColor = squadMainColor.CGColor;
    removeFilterButton.layer.borderWidth = 1;
    removeFilterButton.layer.cornerRadius=15;
    removeFilterButton.layer.masksToBounds=true;
    
    walkThroughOkButton.layer.cornerRadius=15;
    walkThroughOkButton.layer.masksToBounds=true;
    walkThroughLaterButton.layer.cornerRadius=15;
    walkThroughLaterButton.layer.masksToBounds=true;
    walkThroughDontShowButton.layer.cornerRadius=15;
    walkThroughDontShowButton.layer.masksToBounds=true;
    
    editDelSubView.layer.cornerRadius = 15;
    editDelSubView.layer.masksToBounds = YES;
    yesButton.layer.cornerRadius = 15;
    yesButton.layer.masksToBounds =YES;
    noButton.layer.cornerRadius = 15;
    noButton.layer.masksToBounds = YES;
    
//    favFilterButton.selected=false;
    isSelectedFavFilter=false;
    
    findMyLevelButton.layer.borderColor = [UIColor blackColor].CGColor;
    findMyLevelButton.layer.borderWidth = 1;
    findMyLevelButton.layer.cornerRadius=10;
    findMyLevelButton.layer.masksToBounds=true;

    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"reloadWebinarList" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
              
            dispatch_async(dispatch_get_main_queue(),^ {
                       if([Utility reachable]){
                           [self getWebinarList];
                       }else{
                           [self offlineMeditationList];
                       }
       });
               
       }];// AY 06032018
    
    
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeMeditation"]] || ![defaults boolForKey:@"isFirstTimeMeditation"]) {
//        walkThroughView.hidden=false;
//    }else{
//        walkThroughView.hidden=true;
//    }
    
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"MeditationWalkthroughShownDate"]]) {
        walkThroughView.hidden=false;
        [defaults setObject:[NSDate date] forKey:@"MeditationWalkthroughShownDate"];
    }else if (![Utility isEmptyCheck:[defaults objectForKey:@"MeditationWalkthroughShownDate"]]){
        NSDate *lastShownDate=[defaults objectForKey:@"MeditationWalkthroughShownDate"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *lastShownDateString = [formatter stringFromDate:lastShownDate];
        NSString *todayDateStr=[formatter stringFromDate:[NSDate date]];
        
        lastShownDate=[formatter dateFromString:lastShownDateString];
        NSDate *todayDate=[formatter dateFromString:todayDateStr];
        if ([todayDate compare:lastShownDate] == NSOrderedDescending) {
            if ([Utility isEmptyCheck:[defaults objectForKey:@"DontShowMeditationPopupAgain"]] ||  ![defaults boolForKey:@"DontShowMeditationPopupAgain"]) {
                walkThroughView.hidden=false;
                [defaults setObject:[NSDate date] forKey:@"MeditationWalkthroughShownDate"];
            }else{
                walkThroughView.hidden=true;
            }
        }else{
            walkThroughView.hidden=true;
        }
    }
    
    
    
//    [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
//        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
//        controller.delegateMasterMenu=self;
//        self.slidingViewController.underLeftViewController  = controller;
//    }
    
//    if(self.slidingViewController.panGesture){
////        [self.view addGestureRecognizer:self.slidingViewController.panGesture];
//    }
    
    //Gesture Recognizer
   [self->circleProgresBar setProgress:0 animated:YES];
   self->progressView.hidden = true;
    progressSubView.layer.cornerRadius =15;
    progressSubView.layer.masksToBounds = YES;
    progressSubView.layer.backgroundColor = [Utility colorWithHexString:@"f5f5f5"].CGColor;
    [self->circleProgresBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
        return [@"" stringByAppendingFormat:@"%@%%",@"0"];
                                } : nil)];
    
    if (![Utility reachable]) {
           UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPressForOffline:)];
           longPress.minimumPressDuration = 1.0;
           [webinarListTable addGestureRecognizer:longPress];
    }else{
           UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
           lpgr.minimumPressDuration = 2.0; //seconds
           [webinarListTable addGestureRecognizer:lpgr];
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        backgroundDownloadDict = [[NSMutableDictionary alloc]init];
        indexPathAndTaskDict = [[NSMutableDictionary alloc]init];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"indexPathAndTaskDict"]]) {
            indexPathAndTaskDict = [[defaults objectForKey:@"indexPathAndTaskDict"] mutableCopy];
        }
    }];
    descriptionView.hidden = true;
    filterView.hidden=true;
    
    
    
//    if (isFromWebinarListApi) {
//        [self getWebinarList];
//    }else{
//        [self getEventDetailsByType];
//    }
    noDataLabelForTable.hidden=true;
    
    if (![Utility isEmptyCheck:self->webinarList]) {
        [self->webinarListTable reloadData];
        
        if (self->_isLoadTagBreath || self->_isLoadTagMorning || self->_isLoadTagPower){
            UIButton *btn = [UIButton new];
            if(self->_isLoadTagBreath){
                self->_isLoadTagBreath = false;
                btn.tag = 0;
            }else if(self->_isLoadTagMorning){
                self->_isLoadTagMorning = false;
                btn.tag = 1;
            }else{
                self->_isLoadTagPower = false;
                btn.tag = 2;
            }
            
            [self landingButtonPressed:btn];
            
        }
        
    }
    
    if([Utility reachable]){
        if (isFromDetails) {
            landingView.hidden=true;
            isFromDetails=false;
        }else{
            landingView.hidden=false;
        }
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
    }else{
        landingView.hidden=true;
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
    }
    
    
//    if (isFromCourse) {
//        landingView.hidden=false;
//        landingView2.hidden=true;
//    }
    
    
    if ([Utility reachable]) {
        if ([defaults boolForKey:@"IsExpired"]) {
            [self getWebinarList];
        }else if ([Utility isEmptyCheck:webinarMasterList] || isFirstLoad || [Utility isEmptyCheck:webinarList]) {
            isFirstLoad = false;
            noDataLabelForTable.text=@"No data found.";
            [self fetchDataFromTable];
        }
    }else{
        [self offlineMeditationList];
    }

    
//    if ([Utility isEmptyCheck:webinarMasterList] || isFirstLoad || [Utility isEmptyCheck:webinarList]) {
//        isFirstLoad = false;
//        if([Utility reachable]){
//            noDataLabelForTable.text=@"No data found.";
//            [self getWebinarList];
//        }else{
//            [self offlineMeditationList];
//        }
//    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [defaults setObject:self->indexPathAndTaskDict forKey:@"indexPathAndTaskDict"];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}


#pragma mark -End










#pragma mark - IBAction

- (IBAction)findMyLevelButtonPressed:(UIButton *)sender {
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:TEST_LEVEL_URL]]){
    NSString *detailsStr = [@"" stringByAppendingFormat:@"%@/members?token=%@",TEST_LEVEL_URL,[defaults valueForKey:@"LoginToken"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:detailsStr] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
    }
}


- (IBAction)startButtonPressed:(UIButton *)sender {
    [self meditationActionButtonPressed:startButton];
}

- (IBAction)backL2:(UIButton *)sender {
    landingView2.hidden=true;
    landingView.hidden=false;
}

- (IBAction)backL3:(UIButton *)sender {
    landingView3.hidden=true;
    landingView.hidden=false;
}

- (IBAction)backL4:(UIButton *)sender {
    landingView4.hidden=true;
    landingView.hidden=false;
}

- (IBAction)backL5:(UIButton *)sender {
    landingView5.hidden=true;
    landingView.hidden=false;
}

- (IBAction)walkThroughDontShowButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected=true;
        [defaults setObject:[NSNumber numberWithBool:true] forKey:@"DontShowMeditationPopupAgain"];
    }else{
        sender.selected=false;
        [defaults removeObjectForKey:@"DontShowMeditationPopupAgain"];
    }
//    [self walkThroughCrossButtonPressed:sender];
}

- (IBAction)walkThroughCrossButtonPressed:(UIButton *)sender {
    walkThroughView.hidden=true;
    if ([Utility reachable]) {
        UIButton *btn;
        btn.tag=0;
        [self landingButtonPressed:btn];
    }
}

- (IBAction)walkThroughLaterButtonPressed:(UIButton *)sender {
    walkThroughView.hidden=true;
    if ([Utility reachable]) {
        UIButton *btn;
        btn.tag=0;
        [self landingButtonPressed:btn];
    }
    
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:TEST_LEVEL_URL]]){
    NSString *detailsStr = [@"" stringByAppendingFormat:@"%@/members?token=%@",TEST_LEVEL_URL,[defaults valueForKey:@"LoginToken"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:detailsStr] options:@{} completionHandler:^(BOOL success) {
        if(success){
            NSLog(@"Opened");
            }
        }];
    }
}


- (IBAction)filterCheckUncheckPressed:(UIButton *)sender {
    if ([sender.accessibilityHint isEqualToString:@"Tag"]) {
        if (sender.isSelected) {
            sender.selected=false;
            if (![Utility isEmptyCheck:eventTagList]) {
                NSDictionary *tagData = [eventTagList objectAtIndex:sender.tag];
                if (![Utility isEmptyCheck:selectedTagArray]) {
                    if ([selectedTagArray containsObject:tagData]) {
                        [selectedTagArray removeObject:tagData];
                    }
                }
            }
        }else{
           sender.selected=true;
            if (![Utility isEmptyCheck:eventTagList]) {
                NSDictionary *tagData = [eventTagList objectAtIndex:sender.tag];
                [selectedTagArray addObject:tagData];
            }
        }
    }else if ([sender.accessibilityHint isEqualToString:@"Duration"]){
        if (sender.isSelected) {
            sender.selected=false;
            if (![Utility isEmptyCheck:durationListArray]) {
                NSDictionary *durationData = [durationListArray objectAtIndex:sender.tag];
                if (![Utility isEmptyCheck:selectedDurationArray]) {
                    if ([selectedDurationArray containsObject:durationData]) {
                        [selectedDurationArray removeObject:durationData];
                    }
                }
            }
        }else{
           sender.selected=true;
            if (![Utility isEmptyCheck:durationListArray]) {
                NSDictionary *tagData = [durationListArray objectAtIndex:sender.tag];
                [selectedDurationArray addObject:tagData];
            }
        }
    }else if ([sender.accessibilityHint isEqualToString:@"Level"]){
        if (sender.isSelected) {
            sender.selected=false;
            if (![Utility isEmptyCheck:levelListArray]) {
                NSDictionary *levelData = [levelListArray objectAtIndex:sender.tag];
                if (![Utility isEmptyCheck:selectedLevelArray]) {
                    if ([selectedLevelArray containsObject:levelData]) {
                        [selectedLevelArray removeObject:levelData];
                    }
                }
            }
        }else{
           sender.selected=true;
            if (![Utility isEmptyCheck:levelListArray]) {
                NSDictionary *tagData = [levelListArray objectAtIndex:sender.tag];
                [selectedLevelArray addObject:tagData];
            }
        }
    }else{
        sender.selected=!sender.selected;
        isSelectedFavFilter=!isSelectedFavFilter;
        
    }
}



/*
 if (![Utility isEmptyCheck:eventTagList]) {
         NSDictionary *tagData = [eventTagList objectAtIndex:indexPath.row];
         NSString *tagString = [tagData valueForKey:@"Description"];
         if (![Utility isEmptyCheck:tagString]) {
             cell.tagNameLabel.text = tagString;
         }
         if (![Utility isEmptyCheck:selectedTagArray]) {
             if ([selectedTagArray containsObject:tagData]) {
                 cell.checkUncheckButton.selected=true;
             }else{
                cell.checkUncheckButton.selected=false;
             }
         }else{
             cell.checkUncheckButton.selected=false;
         }
         
         cell.checkUncheckButton.tag=indexPath.row;
         cell.checkUncheckButton.accessibilityHint=@"Tag";
     }
     return cell;
     
 }else{
     NSString *CellIdentifier =@"WebinarListDurationTableViewCell";
     WebinarListDurationTableViewCell *cell = (WebinarListDurationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     // Configure the cell...
     if (cell == nil) {
         cell = [[WebinarListDurationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     if (![Utility isEmptyCheck:durationListArray]) {
         NSDictionary *durationData = [durationListArray objectAtIndex:indexPath.row];
         NSString *durationString = [durationData valueForKey:@"DurationString"];
         if (![Utility isEmptyCheck:durationString]) {
             cell.durationLabel.text = durationString;
         }
         if (![Utility isEmptyCheck:selectedDurationArray]) {
             if ([selectedDurationArray containsObject:durationData]) {
                 cell.checkUncheckButton.selected=true;
             }else{
                cell.checkUncheckButton.selected=false;
             }
         }else{
             cell.checkUncheckButton.selected=false;
         }
         
         cell.checkUncheckButton.tag=indexPath.row;
         cell.checkUncheckButton.accessibilityHint=@"Duration";
     }
     return cell;
 
 */







- (IBAction)showResultButtonPressed:(UIButton *)sender {
    NSArray *tmpArr;
    
    if (![Utility isEmptyCheck:selectedTagArray] && ![Utility isEmptyCheck:webinarMasterList]) {
        NSString *tagPredicateString=@"";
        for (int i=0; i<selectedTagArray.count; i++) {
            NSString *tagName = [[selectedTagArray objectAtIndex:i] objectForKey:@"Description"];
            if (i+1==selectedTagArray.count) {
                tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Tags CONTAINS[c] '%@')",tagName];
            }else{
                tagPredicateString=[tagPredicateString stringByAppendingFormat:@"(Tags CONTAINS[c] '%@') OR ",tagName];
            }
        }
        tmpArr=[webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@",tagPredicateString]]];
        [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
    }else{
        tmpArr=webinarMasterList;
        [filterButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    }
    
    //------ show duration filter accordind to selected tag --
//    NSMutableArray *durationListArray_Temp=[[NSMutableArray alloc] init];
//    if (![Utility isEmptyCheck:tmpArr]){
//        for (NSDictionary *dict in tmpArr) {
//            if (![Utility isEmptyCheck:[dict objectForKey:@"Duration"] ]) {
//                int duration=[[dict objectForKey:@"Duration"] intValue];
//                NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d min",duration],@"DurationString",[NSNumber numberWithInt:duration],@"Duration", nil];
//                [durationListArray_Temp addObject:durationDict];
//            }
//        }
//    }
//    
//    if (![Utility isEmptyCheck:durationListArray_Temp]) {
//        durationListArray = [[[NSOrderedSet orderedSetWithArray:durationListArray_Temp] array] mutableCopy];
//        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Duration" ascending:YES];
//        NSArray *sortDescriptors = @[descriptor];
//        durationListArray = [[durationListArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
//        [tagFilterTable reloadData];
//    }
    //----------------------
    
    if (![Utility isEmptyCheck:selectedDurationArray] && ![Utility isEmptyCheck:tmpArr]) {
        NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Duration" ascending:YES];
        NSArray *sortDescriptors = @[ageDescriptor];
        NSArray *sortedSelectedDurationArray = [selectedDurationArray sortedArrayUsingDescriptors:sortDescriptors];
        
        //-----------------
        NSString *durationPredicateString=@"";
        for (int i=0; i<sortedSelectedDurationArray.count; i++) {
            int duration = [[[sortedSelectedDurationArray objectAtIndex:i] objectForKey:@"Duration"] intValue];
            if (i+1==sortedSelectedDurationArray.count) {
                durationPredicateString=[durationPredicateString stringByAppendingFormat:@"(Duration == %d)",duration];
            }else{
                durationPredicateString=[durationPredicateString stringByAppendingFormat:@"(Duration == %d) OR ",duration];
            }
        }
        tmpArr = [tmpArr filteredArrayUsingPredicate:[NSPredicate
        predicateWithFormat:[NSString stringWithFormat:@"%@",durationPredicateString]]];
        
        //---------------
//        int start=[[[sortedSelectedDurationArray firstObject] objectForKey:@"Duration"] intValue];
//        int end=[[[sortedSelectedDurationArray lastObject] objectForKey:@"Duration"] intValue];
//        tmpArr = [tmpArr filteredArrayUsingPredicate:[NSPredicate
//        predicateWithFormat:@"(Duration <=  %d) AND (Duration >=  %d)", end,start]];
        [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
    }
    
    if (![Utility isEmptyCheck:selectedLevelArray] && ![Utility isEmptyCheck:tmpArr]) {
        NSSortDescriptor *ageDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Level" ascending:YES];
        NSArray *sortDescriptors = @[ageDescriptor];
        NSArray *sortedSelectedLevelArray = [selectedLevelArray sortedArrayUsingDescriptors:sortDescriptors];
        int start=[[[sortedSelectedLevelArray firstObject] objectForKey:@"Level"] intValue];
        int end=[[[sortedSelectedLevelArray lastObject] objectForKey:@"Level"] intValue];
        tmpArr = [tmpArr filteredArrayUsingPredicate:[NSPredicate
        predicateWithFormat:@"(Level <=  %d) AND (Level >=  %d)", end,start]];
        [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
    }
    
    
    
    if (isSelectedFavFilter && ![Utility isEmptyCheck:tmpArr]) {
        tmpArr=[tmpArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Likes==%@)",[NSNumber numberWithBool:YES]]];
        [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
    }
        
    webinarList=[tmpArr mutableCopy];
    webinarListForSearch=[webinarList mutableCopy];
    [webinarListTable reloadData];
    [tagFilterTable reloadData];
    
    filterView.hidden=true;
    
    
}
 - (IBAction)remobeFilterButtonPressed:(UIButton *)sender {
    
    webinarList=[webinarMasterList mutableCopy];
    webinarListForSearch=[webinarMasterList mutableCopy];
    [selectedTagArray removeAllObjects];
    [selectedDurationArray removeAllObjects];
    [selectedLevelArray removeAllObjects];
    isSelectedFavFilter=NO;
    [self showResultButtonPressed:0];
    
//    [webinarListTable reloadData];
//    [tagFilterTable reloadData];
//    [filterButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
//    filterView.hidden=true;
//    landingView.hidden=true;
}





- (IBAction)closeFilterPressed:(UIButton *)sender {
    filterView.hidden=true;
}


- (IBAction)infoPressed:(UIButton *)sender {
//    NSString *urlString=@"https://player.vimeo.com/external/391432653.source.mp4?s=cd7102b01bd86d8ca694bcba98678d483ab80c88&download=1";
    /*
    NSString *urlString=@"https://player.vimeo.com/external/391432653.sd.mp4?s=1405198804056d0157af37e37ae4b9d3bc032db2&profile_id=165&download=1";
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
     */
    MeditationRewardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MeditationReward"];
    [self.navigationController pushViewController:controller animated:YES];
}





- (IBAction)landingButtonPressed:(UIButton *)sender {
    landingView.hidden=true;
    [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
    UIButton *btn;
    
    if (sender.tag==3) {
        backButtonIdentifier=@"v1";
        isSelectedFavFilter=true;
        landingView.hidden=true;
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
        [selectedTagArray removeAllObjects];
        [selectedDurationArray removeAllObjects];
        [selectedLevelArray removeAllObjects];
        [self showResultButtonPressed:btn];
    }else if (sender.tag==0 || sender.tag==1 || sender.tag==2 || sender.tag==16 || sender.tag==17 || sender.tag==18 || sender.tag==19){
        backButtonIdentifier=@"v1";
        isSelectedFavFilter=NO;
        [selectedTagArray removeAllObjects];
        NSString *tagName;
        if (sender.tag==0) {
            tagName=@"Breath Control";
        }else if (sender.tag==1){
            tagName=@"Morning Routine";
        }else if (sender.tag==2){
            tagName=@"Power Naps";
        }else if (sender.tag==17){
            tagName=@"Healing Meditations";
        }else if (sender.tag==18){
            tagName=@"Visualisations";
        }else if (sender.tag==19){
            tagName=@"Guided Meditation";
        }
        
        

        if (![Utility isEmptyCheck:eventTagList] && ![Utility isEmptyCheck:tagName]) {
            NSArray *tmpArr=[eventTagList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Description CONTAINS[c] %@)", tagName]];
            if (![Utility isEmptyCheck:tmpArr]) {
                NSDictionary *dict=[tmpArr objectAtIndex:0];
                [selectedTagArray addObject:dict];
            }
        }
        landingView.hidden=true;
        if (sender.tag==0) {
            landingView2.hidden=false;
            landingView3.hidden=true;
            landingView4.hidden=true;
            landingView5.hidden=true;
        }else if (sender.tag==1){
            if(selectedDurationArray.count>0){
                [selectedDurationArray removeAllObjects];
            }
            landingView2.hidden=true;
            landingView3.hidden=true;
            landingView4.hidden=true;
            landingView5.hidden=true;
            [self showResultButtonPressed:btn];
        }else if (sender.tag==2){
            landingView2.hidden=true;
            landingView3.hidden=false;
            landingView4.hidden=true;
            landingView5.hidden=true;
        }else if (sender.tag==16){
            if(selectedDurationArray.count>0){
                [selectedDurationArray removeAllObjects];
            }
            landingView2.hidden=true;
            landingView3.hidden=true;
            landingView4.hidden=true;
            landingView5.hidden=false;
        }else if (sender.tag==17 || sender.tag==18 || sender.tag==19){
            backButtonIdentifier=@"v5";
            landingView2.hidden=true;
            landingView3.hidden=true;
            landingView4.hidden=true;
            landingView5.hidden=true;
            [self showResultButtonPressed:btn];
        }
    }else if (sender.tag==4 || sender.tag==5 || sender.tag==6 || sender.tag==7){
        backButtonIdentifier=@"v2";
        [selectedDurationArray removeAllObjects];
        int duration=0;
        if (sender.tag==4) {
            duration=5;
        }else if (sender.tag==5){
            duration=10;
        }else if (sender.tag==6){
            duration=20;
        }else if (sender.tag==7){
            duration=30;
        }
        if (![Utility isEmptyCheck:durationListArray]) {
            NSArray *tmpArr=[durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = %d)", duration]];
            if (![Utility isEmptyCheck:tmpArr]) {
                NSDictionary *dict=[tmpArr objectAtIndex:0];
                [selectedDurationArray addObject:dict];
            }
        }
        
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
        [self showResultButtonPressed:btn];
    }else if (sender.tag==8 || sender.tag==9 || sender.tag==20){
        backButtonIdentifier=@"v3";
        [selectedDurationArray removeAllObjects];
        int duration=0;
        if (sender.tag==8) {
            duration=20;
        }else if (sender.tag==9){
            duration=90;
        }
        
        //tag=20->power-up
        if (sender.tag==20) {
            if (![Utility isEmptyCheck:durationListArray]) {
                NSArray *tmpArr=[durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d) OR (Duration = %d)", 2,5,10,11,12,14,15,16,19,21,23,24,30,31,34,40,42,60]];
                if (![Utility isEmptyCheck:tmpArr]) {
                    for (int i=0; i<tmpArr.count; i++) {
                        NSDictionary *dict=[tmpArr objectAtIndex:i];
                        [selectedDurationArray addObject:dict];
                    }
                }
            }
        }else{
            if (![Utility isEmptyCheck:durationListArray]) {
                NSArray *tmpArr=[durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = %d)", duration]];
                if (![Utility isEmptyCheck:tmpArr]) {
                    NSDictionary *dict=[tmpArr objectAtIndex:0];
                    [selectedDurationArray addObject:dict];
                }
            }
        }
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
        [self showResultButtonPressed:btn];
    }else if (sender.tag==10 || sender.tag==11 || sender.tag==12 || sender.tag==13 || sender.tag==14 || sender.tag==15){
        [selectedLevelArray removeAllObjects];
        int level=0;
        if (sender.tag==10) {
            level=0;
        }else if (sender.tag==11){
            level=1;
        }else if (sender.tag==12){
            level=2;
        }else if (sender.tag==13){
            level=3;
        }else if (sender.tag==14){
            level=4;
        }else if (sender.tag==15){
            level=5;
        }
        if (![Utility isEmptyCheck:levelListArray]) {
            NSArray *tmpArr=[levelListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Level = %d)", level]];
            if (![Utility isEmptyCheck:tmpArr]) {
                NSDictionary *dict=[tmpArr objectAtIndex:0];
                [selectedLevelArray addObject:dict];
            }
        }
        
        landingView2.hidden=true;
        landingView3.hidden=true;
        landingView4.hidden=true;
        landingView5.hidden=true;
        [self showResultButtonPressed:btn];
    }
}




- (IBAction)backButtonPressed:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    
    if (![Utility reachable]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"GoToGratitude" object:nil];
    }else{
       if ([backButtonIdentifier isEqualToString:@"v1"]) {
            landingView.hidden=false;
        }else if ([backButtonIdentifier isEqualToString:@"v2"]){
            landingView2.hidden=false;
        }else if ([backButtonIdentifier isEqualToString:@"v3"]){
            landingView3.hidden=false;
        }else if ([backButtonIdentifier isEqualToString:@"v5"]){
            landingView5.hidden=false;
        }else{
            landingView.hidden=false;
        }
    }
}
- (IBAction)podcastButtonPressed:(UIButton *)sender {
    NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
    
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
            if (![Utility isEmptyCheck:urlString]) {
                PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                controller.urlString = urlString;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
    
}
- (IBAction)downloadButtonPressed:(UIButton *)sender {
    NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
    
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];

                if([video_url absoluteString].length < 1) {
                    return;
                }
                NSLog(@"source will be : %@", video_url.absoluteString);
                NSURL *sourceURL = video_url;
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                NSLog(@"fullPathToFile=%@",fullPathToFile);
                if (player) {
                    [player pause];
                    player = nil;
                }
                
                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    NSURL    *fileURL = [NSURL fileURLWithPath:fullPathToFile];
                    player = [AVPlayer playerWithURL:fileURL];
                    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                    [self presentViewController:controller animated:YES completion:nil];
                    controller.view.frame = self.view.frame;
                    controller.player = player;
                    controller.showsPlaybackControls = YES;
                    [player play];
                    return;
                }
                [Utility msg:@"This video have started downloading , will be available for playing locally" title:@"Alert" controller:self haveToPop:NO];

                [UIView animateWithDuration:0.3/1 animations:^{
                    sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/1.5 animations:^{
                            sender.transform = CGAffineTransformIdentity;
                            [sender setBackgroundColor:[UIColor clearColor]];

                        }];
                    }];
                }];
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                    sender.enabled = false;
                    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:webinarListTable];
                    NSIndexPath *indexPath = [webinarListTable indexPathForRowAtPoint:buttonPosition];
                    WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[webinarListTable cellForRowAtIndexPath:indexPath];
                    cell.downloadTask = [self.session downloadTaskWithURL:sourceURL];
                    cell.progress.hidden = false;
                    [backgroundDownloadDict setObject:cell forKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier]];
                    [indexPathAndTaskDict setObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)cell.downloadTask.taskIdentifier] forKey:[@"" stringByAppendingFormat:@"%ld",(long)sender.tag]];

                    [cell.downloadTask resume];
                    }];
//                    NSURLSessionTask *download = [[NSURLSession sharedSession] downloadTaskWithURL:sourceURL completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//                        if(error) {
//                            NSLog(@"error saving: %@", error.localizedDescription);
//                            return;
//                        }
//
//                        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                                [sender setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
//                            }else{
//                                [sender setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
//                            }
//                        });
//
//                    }];
//                    [download resume];
                }else{
                    [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                }
            }
        }
    }
    
}

- (IBAction)likeDislikeButtonPressed:(UIButton *)sender {
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (contentView) {
//                [contentView removeFromSuperview];
//            }
//            contentView = [Utility activityIndicatorView:self];
//        });
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[webinarsData valueForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleEventLikeApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [Utility isEmptyCheck:[responseDict objectForKey:@"Message"]]) {
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
                                                                         CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->webinarListTable];
                                                                         NSIndexPath *indexPath = [self->webinarListTable indexPathForRowAtPoint:buttonPosition];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"LikeCount"] forKey:@"LikeCount"];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"Likes"] forKey:@"Likes"];
                                                                         [self->webinarList replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                         [self->webinarListTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                         [self getWebinarList];
                                                                         
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
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
- (IBAction)watchListButtonPressed:(UIButton *)sender {
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (Utility.reachable) {
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
        //        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];

        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                if (![[eventItemVideoDetails objectForKey:@"IsWatchListVideo"] boolValue]) {
                    [Utility msg:[@"" stringByAppendingFormat:@"%@ has now been saved to your watchlist. You can find this anytime from the menu.",[webinarsData objectForKey:@"EventName"]] title:@"Alert" controller:self haveToPop:NO];
                }
                NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
                [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"User_id"];
                [mainDict setObject:AccessKey forKey:@"Key"];
                [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
                [mainDict setObject:[eventItemVideoDetails objectForKey:@"EventItemVideoID"] forKey:@"Video_id"];
                
                NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
                if (error) {
                    [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                    return;
                }
                NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                
                NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleWatchlistApiCall" append:@"" forAction:@"POST"];
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
                                                                             if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && ![Utility isEmptyCheck:[responseDict objectForKey:@"ToggleFlag"]]) {
                                                                                 CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:webinarListTable];
                                                                                 NSIndexPath *indexPath = [webinarListTable indexPathForRowAtPoint:buttonPosition];
                                                                                 [eventItemVideoDetails setObject:[responseDict objectForKey:@"ToggleFlag"] forKey:@"IsWatchListVideo"];
                                                                                 [eventItemVideoDetailsArray removeObjectAtIndex:0];
                                                                                 [eventItemVideoDetailsArray insertObject:eventItemVideoDetails atIndex:0];
                                                                                 [webinarsData setObject:eventItemVideoDetailsArray forKey:@"EventItemVideoDetails"];
                                                                                
                                                                                 [webinarList replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                                 NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                                 [webinarListTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                                 
                                                                                 
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
            }
        }else{
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

- (IBAction)filterButton:(UIButton *)sender {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.filterDataArray = self->filterArray;
//        if (![Utility isEmptyCheck:self->parentSelectedDict]) {
//            if ([self->filterArray containsObject:self->parentSelectedDict]) {
//                controller.selectedIndex = (int)[self->filterArray indexOfObject:self->parentSelectedDict];
//            }else{
//                controller.selectedIndex = -1;
//            }
//        }else{
//            controller.selectedIndex = -1;
//        }
//        controller.mainKey = @"Value";
//        controller.delegate = self;
//        [self presentViewController:controller animated:YES completion:nil];
//    });
    
    
    filterView.hidden=false;
    
}


- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToLeftAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)meditationActionButtonPressed:(UIButton *)sender {
    if(!descriptionView.hidden){
        descriptionView.hidden = true;
    }
    webinarsData = [webinarList objectAtIndex:sender.tag];
    NSString *eventType = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventType"] ];
    NSString *eventName = [@"" stringByAppendingFormat:@"%@",webinarsData[@"EventName"] ];

    if (![Utility isEmptyCheck:eventType] && ([eventType isEqualToString:@"14"] || [eventName isEqualToString:@"AshyLive"] || [eventType isEqualToString:@"17"] || [eventName isEqualToString:@"FridayFoodAndNutrition"] || [eventType isEqualToString:@"16"] || [eventName isEqualToString:@"WeeklyWellness"])){
        NSString *urlString = [webinarsData objectForKey:@"FbAppUrl"];
        if (![Utility isEmptyCheck:urlString]) {
            NSURL *url = [NSURL URLWithString:urlString];
            if ([[UIApplication sharedApplication] openURL:url]){
                NSLog(@"well done");
            }else {
                urlString = [webinarsData objectForKey:@"FbUrl"];
                if (![Utility isEmptyCheck:urlString]) {
                    url = [NSURL URLWithString:urlString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }else{
            urlString = [webinarsData objectForKey:@"FbUrl"];
            if (![Utility isEmptyCheck:urlString]) {
                NSURL *url = [NSURL URLWithString:urlString];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }else if(![Utility isEmptyCheck:eventType] && [eventType isEqualToString:@"2"]){
        NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
        if (eventItemVideoDetailsArray.count > 0) {
            NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
            if (![Utility isEmptyCheck:eventItemVideoDetails]) {
                NSString *urlString = [eventItemVideoDetails objectForKey:@"PodcastURL" ];
                if (![Utility isEmptyCheck:urlString]) {
                    PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                    controller.urlString = urlString;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }else{
        NSArray *tmpArr=[webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Likes==%@)",[NSNumber numberWithBool:YES]]];
           dispatch_async(dispatch_get_main_queue(), ^{
               if (![Utility isEmptyCheck:[self->webinarsData objectForKey:@"EventItemVideoDetails"]]) {
//                   NSDictionary *EventItemVideoDetailsDict = [[self->webinarsData objectForKey:@"EventItemVideoDetails"]objectAtIndex:0];
                   WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                         controller.webinar = [self->webinarsData mutableCopy];
                         controller.shopUrl=self->shopUrl;
                         if (tmpArr.count>0) {
                             controller.isShowFavAlert=NO;
                         }else{
                             controller.isShowFavAlert=YES;
                         }
                         controller.isShowShopping = self->showShopping;
                         [self.navigationController pushViewController:controller animated:YES];
               
//               if (![Utility isEmptyCheck:[EventItemVideoDetailsDict objectForKey:@"DownloadURL"]]) {
//                   NSURL *video_url = [NSURL URLWithString:[EventItemVideoDetailsDict objectForKey:@"DownloadURL"]];
//                   NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//                   NSString* documentsDirectory = [paths objectAtIndex:0];
//                   NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
//                   if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
//                       WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
//                       controller.webinar = [self->webinarsData mutableCopy];
//                       if (tmpArr.count>0) {
//                           controller.isShowFavAlert=NO;
//                       }else{
//                           controller.isShowFavAlert=YES;
//                       }
//                       [self.navigationController pushViewController:controller animated:YES];
//                   }else{
//                       self->progessBarTextLabel.text = [@"" stringByAppendingFormat:@"Hey %@ , your meditation is quickly downloading.\n\nPlease get in a comfy position to breathe deeply.\n\nEarphones and a meditation mask will improve your experience.",[defaults objectForKey:@"FirstName"]];
//                       self->progressView.hidden = false;
//                       [self->circleProgresBar setHintTextFont:[UIFont fontWithName:@"Raleway-Bold" size:25]];
//                       [self->circleProgresBar setHintTextColor:[Utility colorWithHexString:mbhqBaseColor]];
//                       [self->circleProgresBar setHintViewBackgroundColor:[UIColor clearColor]];
//                       [self->circleProgresBar setProgressBarProgressColor:[Utility colorWithHexString:mbhqBaseColor]];
//                       [self->circleProgresBar setProgressBarWidth:10.0f];;
//
//                       [self download:self->webinarsData sender:nil];
//                   }
//                  }
               }
           });
    }
}
-(IBAction)crossProgressBar:(id)sender{
    [eventDownloadTask cancel];
    progressView.hidden = true;
}
-(IBAction)crossButtonPressed:(id)sender{
    descriptionView.hidden = true;
}

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)favButtonPressed:(UIButton *)sender {
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSMutableDictionary *webinarsData = [[NSMutableDictionary alloc]initWithDictionary:[webinarList objectAtIndex:sender.tag]];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[webinarsData valueForKey:@"EventItemID"] forKey:@"EventID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:0  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleEventLikeApiCall" append:@"" forAction:@"POST"];
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
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [Utility isEmptyCheck:[responseDict objectForKey:@"Message"]]) {
//                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];
                                                                         CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self->webinarListTable];
                                                                         NSIndexPath *indexPath = [self->webinarListTable indexPathForRowAtPoint:buttonPosition];
                                                                         int indexOfMainList=[self->webinarMasterList indexOfObject:webinarsData];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"LikeCount"] forKey:@"LikeCount"];
                                                                         [webinarsData setObject:[responseDict valueForKey:@"Likes"] forKey:@"Likes"];
                                                                         [self->webinarList replaceObjectAtIndex:sender.tag withObject:webinarsData];
                                                                         self->webinarListForSearch=[self->webinarList mutableCopy];
                                                                         [self->webinarMasterList replaceObjectAtIndex:indexOfMainList withObject:webinarsData];
                                                                         NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
                                                                         [self->webinarListTable reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
                                                                         [self getWebinarList];
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
-(IBAction)deleteDataFromDownloadMeditation:(id)sender{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(EventItemID = %d)",eventID];
    NSArray *arr = [webinarList filteredArrayUsingPredicate:predicate];
    if (![Utility isEmptyCheck:arr] && arr.count>0) {
        NSDictionary *webDict = [arr objectAtIndex:0];
        
        if (![Utility isEmptyCheck:[[webDict objectForKey:@"EventItemVideoDetails"]objectAtIndex:0]]) {
          NSDictionary *EventItemVideoDetails = [[webDict objectForKey:@"EventItemVideoDetails"]objectAtIndex:0];
            if (![Utility isEmptyCheck:[EventItemVideoDetails objectForKey:@"DownloadURL"]]) {
               NSURL *video_url = [NSURL URLWithString:[EventItemVideoDetails objectForKey:@"DownloadURL"]];
               NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
               NSString* documentsDirectory = [paths objectAtIndex:0];
               NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[video_url lastPathComponent]];
               if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                  [[NSFileManager defaultManager] removeItemAtPath:fullPathToFile error:nil];
                   [self deleteDataFromDb];
               }
           }
        }
    }
}
-(IBAction)deleteDataNoFromDownloadMeditation:(id)sender{
    editDelView.hidden = true;
}
#pragma mark - End -

#pragma mark - Privete methods

-(void)deleteDataFromDb{
    int userId = [[defaults objectForKey:@"UserID"] intValue];

    if([DBQuery isRowExist:@"meditationList" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
        
     DAOReader *dbObject = [DAOReader sharedInstance];
     if([dbObject connectionStart] && eventID>0 ){
          BOOL isDel = [dbObject deleteWhen:@"meditationList" whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventID]]];
          if (isDel) {
              editDelView.hidden = true;
              [self offlineMeditationList];
              [Utility msg:@"Data deleted from download meditations" title:@"Alert" controller:self haveToPop:NO];
         }
      }
    }
}
//pull to refresh
- (void)refreshTable {
    [refreshControl endRefreshing];
    [filterButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    selectedFilterDict =[[NSDictionary alloc]init];
    subSelectedDict = [[NSDictionary alloc]init];
    parentSelectedDict=[[NSDictionary alloc]init];
    searchTextField.text = @"";
    [self.view endEditing:YES];
    
    if([Utility reachable]){
        [self getWebinarList];
    }else{
        [self offlineMeditationList];
    }
}




-(void)addFooter{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,webinarListTable.frame.size.width,44)];
    footerView.backgroundColor =  [UIColor clearColor];
    //[footerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    webinarListTable.tableFooterView = footerView;
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    indicator.center = footerView.center;
    [indicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [footerView addSubview:indicator];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:footerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0]];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:indicator
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:footerView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                               
                                                            constant:0]];
}


-(void)addUpdateDB{
    
    if(![Utility isEmptyCheck:eventTagList]){
        
        NSError *error;
        NSData *tagdata = [NSJSONSerialization dataWithJSONObject:eventTagList options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:tagdata encoding:NSUTF8StringEncoding];
       
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"meditationTagList" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
            [DBQuery updateMeditationTagList:detailsString];
         }else{
            [DBQuery addMeditationTagList:detailsString];
        }
        
    }
    

}
-(void)addUpdateDB1{
    if(![Utility isEmptyCheck:webinarsData]){
        
        NSError *error;
        NSData *webinardata = [NSJSONSerialization dataWithJSONObject:webinarsData options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
            return;
        }
        
        NSString *detailsString = [[NSString alloc] initWithData:webinardata encoding:NSUTF8StringEncoding];
        int eventItemId = [[webinarsData objectForKey:@"EventItemID"] intValue];
        int userId = [[defaults objectForKey:@"UserID"] intValue];
        if([DBQuery isRowExist:@"meditationList" condition:[@"" stringByAppendingFormat:@"UserId ='%@' and EventId = '%@'",[NSNumber numberWithInt:userId],[NSNumber numberWithInt:eventItemId]]]){
             [DBQuery updateMeditationDetails:detailsString with:eventItemId];
         }else{
             [DBQuery addMeditationData:detailsString with:eventItemId];
        }
    }
}


-(void)addUpdateDBForWebniarListing:(NSString*)jsonStr{
        BOOL isAdeed = NO;
        NSString *detailsString = jsonStr;
        int userId = [[defaults objectForKey:@"UserID"] intValue];
            if([DBQuery isRowExist:@"webniarListDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
                 [DBQuery updateWebniarList:detailsString];
                [self fetchDataFromTable];
            }else{
                 isAdeed = [DBQuery addWebniarList:detailsString];
            }
            if (isAdeed) {
                  [self fetchDataFromTable];
               }else if (![Utility isEmptyCheck:[defaults objectForKey:@"TableUpdateCheck"]] && ![defaults boolForKey:@"TableUpdateCheck"]) {
                   NSLog(@"--");
                   BOOL isCheck = [DBQuery createTableDB];
                   if (isCheck) {
                       [DBQuery addWebniarList:detailsString];
                       [self fetchDataFromTable];
                   }else{
                       [Utility msg:@"DataBase Not Updated" title:@"" controller:self haveToPop:NO];
                   }
               }
   

}
-(void)fetchDataFromTable{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
      if([DBQuery isRowExist:@"webniarListDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
//          noDataLabelForTable.text=@"No data found.";

         DAOReader *dbObject = [DAOReader sharedInstance];
          if([dbObject connectionStart]){
              NSArray *webniar = [dbObject selectBy:@"webniarListDetails" withColumn:[[NSArray alloc]initWithObjects:@"Details",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]];
               NSString *str = webniar[0][@"Details"];
               NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
               NSDictionary *webniarList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
               NSLog(@"%@",webniarList);
              if ([Utility isEmptyCheck:webniarList]) {
                  return;
              }
              [self updatedata:webniarList];
          }
      }else{
          [self getWebinarList];
      }
}
-(void)updatedata:(NSDictionary*)responseDict{
    if (![Utility isEmptyCheck:[responseDict objectForKey:@"ShowShopNow"]]) {
        if ([[responseDict objectForKey:@"ShowShopNow"]boolValue]) {
            showShopping = [responseDict objectForKey:@"ShowShopNow"];
            shopUrl = [responseDict objectForKey:@"ShoppingURL"];
        }else{
            showShopping = false;
            shopUrl = @"";
        }
    }else{
        showShopping = false;
        shopUrl = @"";
    }
    self->webinarMasterList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];
     self->webinarList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];
     self->webinarListForSearch = [self->webinarList mutableCopy];
     if([Utility isEmptyCheck:self->eventTagList]){
         [self getSubFilterList:@"GetEventTagListApiCall"];
     }
    NSMutableArray *durationListArray_Temp=[[NSMutableArray alloc] init];
      if (![Utility isEmptyCheck:self->webinarList]){
          for (NSDictionary *dict in self->webinarMasterList) {
                 if (![Utility isEmptyCheck:[dict objectForKey:@"Duration"] ]) {
                     int duration=[[dict objectForKey:@"Duration"] intValue];
                     NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d min",duration],@"DurationString",[NSNumber numberWithInt:duration],@"Duration", nil];
                     [durationListArray_Temp addObject:durationDict];
                 }
             }
          
      }
    if (![Utility isEmptyCheck:durationListArray_Temp]) {
        self->durationListArray = [[[NSOrderedSet orderedSetWithArray:durationListArray_Temp] array] mutableCopy];
         NSArray *tmpArr;
         tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 5)"]];
         if ([Utility isEmptyCheck:tmpArr]) {
             NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"5 min"],@"DurationString",[NSNumber numberWithInt:5],@"Duration", nil];
             [self->durationListArray addObject:durationDict];
         }
        tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 10)"]];
         if ([Utility isEmptyCheck:tmpArr]) {
             NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"10 min"],@"DurationString",[NSNumber numberWithInt:10],@"Duration", nil];
             [self->durationListArray addObject:durationDict];
         }
        tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 20)"]];
         if ([Utility isEmptyCheck:tmpArr]) {
             NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"20 min"],@"DurationString",[NSNumber numberWithInt:20],@"Duration", nil];
             [self->durationListArray addObject:durationDict];
         }
        tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 30)"]];
         if ([Utility isEmptyCheck:tmpArr]) {
             NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"30 min"],@"DurationString",[NSNumber numberWithInt:30],@"Duration", nil];
             [self->durationListArray addObject:durationDict];
         }
        tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 90)"]];
         if ([Utility isEmptyCheck:tmpArr]) {
             NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"90 min"],@"DurationString",[NSNumber numberWithInt:90],@"Duration", nil];
             [self->durationListArray addObject:durationDict];
         }
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Duration" ascending:YES];
         NSArray *sortDescriptors = @[descriptor];
         self->durationListArray = [[self->durationListArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
         [self->tagFilterTable reloadData];
       }
       if (![Utility isEmptyCheck:self->webinarList]) {
           [self->webinarListTable reloadData];
           if (self->_isLoadTagBreath || self->_isLoadTagMorning || self->_isLoadTagPower){
                 UIButton *btn = [UIButton new];
                 if(self->_isLoadTagBreath){
                     self->_isLoadTagBreath = false;
                     btn.tag = 0;
                 }else if(self->_isLoadTagMorning){
                     self->_isLoadTagMorning = false;
                     btn.tag = 1;
                 }else{
                     self->_isLoadTagPower = false;
                     btn.tag = 2;
                 }
                 
                 [self landingButtonPressed:btn];
                 
             }
             
             [self showResultButtonPressed:0];
             
         }else{
             self->webinarList = [[NSMutableArray alloc]init];
             self->webinarMasterList = [[NSMutableArray alloc]init];
             self->webinarListForSearch = [self->webinarList mutableCopy];
             
             
             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
             return;
         }
}
-(void)offlineMeditationList{
    landingView.hidden=true;
    landingView2.hidden=true;
    landingView3.hidden=true;
    landingView4.hidden=true;
    landingView5.hidden=true;
    filterView.hidden=true;

    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"meditationList" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
        noDataLabelForTable.text=@"No data found.";

       DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            NSArray *meditations = [dbObject selectBy:@"meditationList" withColumn:[[NSArray alloc]initWithObjects:@"Details",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]];
            
            NSMutableArray *webinarArrNew = [NSMutableArray new];
            if(![Utility isEmptyCheck:meditations]){
                for(int i = 0; i<meditations.count ;i++){
                   NSString *str = meditations[i][@"Details"];
                   NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                   NSDictionary *webinarDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    [webinarArrNew addObject:webinarDict];
                }
            }else{
                noDataLabelForTable.text=@"You have not downloaded a meditation yet. Please restore your internet to download a meditation and be able to play it in aeroplane mode.";
                noDataLabelForTable.hidden=false;
                return;
            }
            
            self->webinarMasterList = [[NSMutableArray alloc]initWithArray:webinarArrNew];
            self->webinarList = [[NSMutableArray alloc]initWithArray:webinarArrNew];
            NSMutableArray *filterArr = [[NSMutableArray alloc]init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Likes == 1)"];
            NSArray *arr = [webinarList filteredArrayUsingPredicate:predicate];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(Likes == 0)"];
            NSArray *arr1 = [webinarList filteredArrayUsingPredicate:predicate1];
            
            [filterArr addObjectsFromArray:arr];
            [filterArr addObjectsFromArray:arr1];
            
            if (![Utility isEmptyCheck:webinarList]) {
                [webinarList removeAllObjects];
            }
            webinarList = [filterArr mutableCopy];
            webinarMasterList = [webinarList mutableCopy];
            NSLog(@"===================================%@",webinarList);
            
            
            self->webinarListForSearch = [self->webinarList mutableCopy];
            if([Utility isEmptyCheck:self->eventTagList]){
                [self offlineMeditationTagList];
            }
            
            
            NSMutableArray *durationListArray_Temp=[[NSMutableArray alloc] init];
            
            if (![Utility isEmptyCheck:self->webinarList]){
               for (NSDictionary *dict in self->webinarMasterList) {
                    if (![Utility isEmptyCheck:[dict objectForKey:@"Duration"] ]) {
                        int duration=[[dict objectForKey:@"Duration"] intValue];
                        NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d min",duration],@"DurationString",[NSNumber numberWithInt:duration],@"Duration", nil];
                        [durationListArray_Temp addObject:durationDict];
                    }
                }
                //durationListArray_Temp = [self->webinarList valueForKeyPath:@"@distinctUnionOfObjects.Duration"];
                
            }
            
            if (![Utility isEmptyCheck:durationListArray_Temp]) {
                self->durationListArray = [[[NSOrderedSet orderedSetWithArray:durationListArray_Temp] array] mutableCopy];
//                [self->durationFilterTable reloadData];
                [self->tagFilterTable reloadData];
            }
            
            
            if (![Utility isEmptyCheck:self->webinarList]) {
                [self->webinarListTable reloadData];
                
                if (self->_isLoadTagBreath || self->_isLoadTagMorning || self->_isLoadTagPower){
                    UIButton *btn = [UIButton new];
                    if(self->_isLoadTagBreath){
                        self->_isLoadTagBreath = false;
                        btn.tag = 0;
                    }else if(self->_isLoadTagMorning){
                        self->_isLoadTagMorning = false;
                        btn.tag = 1;
                    }else{
                        self->_isLoadTagPower = false;
                        btn.tag = 2;
                    }
                    
                    [self landingButtonPressed:btn];
                    
                }
                
                [self remobeFilterButtonPressed:0];
                [self showResultButtonPressed:0];
            }
            
            [dbObject connectionEnd];
        }
    }else{
        noDataLabelForTable.text=@"You have not downloaded a meditation yet. Please restore your internet to download a meditation and be able to play it in aeroplane mode.";
        noDataLabelForTable.hidden=false;
        webinarList = [[NSMutableArray alloc]init];
        webinarListForSearch=[[NSMutableArray alloc]init];
        webinarMasterList= [[NSMutableArray alloc]init];
        [webinarListTable reloadData];
    }
}

-(void)offlineMeditationTagList{
    int userId = [[defaults objectForKey:@"UserID"] intValue];
    if([DBQuery isRowExist:@"meditationTagList" condition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]]){
       DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            NSArray *todayHabitCoursearr = [dbObject selectBy:@"meditationTagList" withColumn:[[NSArray alloc]initWithObjects:@"ListData",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%@'",[NSNumber numberWithInt:userId]]];
                NSString *str = todayHabitCoursearr[0][@"ListData"];
                NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSArray *tagArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if(![Utility isEmptyCheck:tagArr]){
                    
                    eventTagList = tagArr;
                    [self->tagFilterTable reloadData];
                }
                
                
                [dbObject connectionEnd];
        }
    }
}

-(void)addImageToUILabel{
    NSDictionary *attrDict = @{
    NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:20.0],
    NSForegroundColorAttributeName : [Utility colorWithHexString:@"333333"],
    };
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"mbhq_heart_active.png"];

    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];

    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"Click the "];
    [myString appendAttributedString:attachmentString];
    
    NSAttributedString *subText = [[NSAttributedString alloc]initWithString:@" next to the meditations you love most and they will appear here."];
    [myString appendAttributedString:subText];
    
    [myString addAttributes:attrDict range:NSMakeRange(0,myString.length)];
    

    noDataLabelForTable.attributedText = myString;
}
-(void)download:(NSDictionary *)webinarsData sender:(UIButton *)sender{
    NSMutableArray *eventItemVideoDetailsArray = [[NSMutableArray alloc]initWithArray:[webinarsData valueForKey:@"EventItemVideoDetails"]];
    if (eventItemVideoDetailsArray.count > 0) {
        NSMutableDictionary *eventItemVideoDetails = [[NSMutableDictionary alloc]initWithDictionary:[eventItemVideoDetailsArray objectAtIndex:0]];
        if (![Utility isEmptyCheck:eventItemVideoDetails]) {
            if (![Utility isEmptyCheck:[eventItemVideoDetails objectForKey:@"DownloadURL" ]]) {
                NSURL *video_url = [NSURL URLWithString:[eventItemVideoDetails objectForKey:@"DownloadURL" ]];
                
                if([video_url absoluteString].length < 1) {
                    return;
                }
                NSLog(@"source will be : %@", video_url.absoluteString);
                NSURL *sourceURL = video_url;
                NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* documentsDirectory = [paths objectAtIndex:0];
                NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[sourceURL lastPathComponent]];
                NSLog(@"fullPathToFile=%@",fullPathToFile);

                if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                    [self addUpdateDB1];
                  /*  if (appDelegate.FBWAudioPlayer) {
                        [appDelegate.FBWAudioPlayer pause];
                    }
                    if (playerForDownloadedVideo) {
                        [playerForDownloadedVideo pause];
                        playerForDownloadedVideo = nil;
                    }
                    NSURL    *fileURL = [NSURL fileURLWithPath:fullPathToFile];
                    playerForDownloadedVideo = [AVPlayer playerWithURL:fileURL];
                    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
                    [self presentViewController:controller animated:YES completion:nil];
                    controller.view.frame = self.view.frame;
                    controller.player = playerForDownloadedVideo;
                    controller.showsPlaybackControls = YES;
                    [playerForDownloadedVideo play];*/
                    return;
                }
                /*[Utility msg:@"This video have started downloading , will be available for playing locally" title:@"Alert" controller:self haveToPop:NO];
                [UIView animateWithDuration:0.3/1 animations:^{
                    sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.7, 1.7);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.3/1.5 animations:^{
                        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
                        //[sender setBackgroundColor:[UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:0.1]];
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.3/1.5 animations:^{
                            sender.transform = CGAffineTransformIdentity;
                            [sender setBackgroundColor:[UIColor clearColor]];
                            
                        }];
                    }];
                }];*/
                if(Utility.reachable){
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        sender.enabled = false;
                        self->eventDownloadTask = [self.session1 downloadTaskWithURL:sourceURL];
                        self->progressView.hidden = false;
                        [self->eventDownloadTask resume];
                    }];
                }else{
                   // [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
                }
            }
        }
    }
}
#pragma mark -End


#pragma mark - Webservice call
-(void)getEventDetailsByType{
    if (Utility.reachable) {
        isFromWebinarListApi = false;
        if (![Utility isEmptyCheck:selectedFilterDict]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (contentView) {
//                    [contentView removeFromSuperview];
//                }
//                contentView = [Utility activityIndicatorView:self];
//            });
//            if (selectedFilterDict.count > 0) {
//                [filterButton setImage:[UIImage imageNamed:@"selected_Filter.png"] forState:UIControlStateNormal];
//            }else{
//                [filterButton setImage:[UIImage imageNamed:@"webner_filter.png"] forState:UIControlStateNormal];
//            }
            NSURLSession *loginSession = [NSURLSession sharedSession];
            
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:selectedFilterDict];
            [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            [mainDict setObject:[NSNumber numberWithInt:count*10] forKey:@"Count"];

            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventDetailsByTypeApiCall" append:@"" forAction:@"POST"];
            isDownloading = YES;
            NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(), ^{
//                                                                     if (contentView) {
//                                                                         [contentView removeFromSuperview];
//                                                                     }
                                                                     isDownloading = false;
                                                                     [webinarListTable.tableFooterView removeFromSuperview];
                                                                     [self.view setNeedsUpdateConstraints];
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                                 webinarList = [[NSMutableArray alloc]initWithArray:[responseDictionary objectForKey:@"Webinars"]];
                                                                                 self->webinarListForSearch = [self->webinarList mutableCopy];
                                                                                 if (![Utility isEmptyCheck:webinarList] && ![Utility isEmptyCheck:webinarList]) {
                                                                                     [webinarListTable reloadData];
                                                                                     
                                                                                 }else{
                                                                                     webinarList = [[NSMutableArray alloc]init];
                                                                                     self->webinarListForSearch = [self->webinarList mutableCopy];
                                                                                     [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                     return;
                                                                                 }
                                                                             });
                                                                             
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
                isDownloading = false;
                [webinarListTable.tableFooterView removeFromSuperview];
                [self.view setNeedsUpdateConstraints];
//                [filterButton setImage:[UIImage imageNamed:@"webner_filter.png"] forState:UIControlStateNormal];

            });
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
            
        }
        
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            isDownloading = false;
            [webinarListTable.tableFooterView removeFromSuperview];
            [self.view setNeedsUpdateConstraints];
        });
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
        return;
    }
}

-(void)getWebinarList{
    if (Utility.reachable) {
        noDataLabelForTable.text=@"No data found.";
        isFromWebinarListApi = true;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
//        if (![Utility isEmptyCheck:selectedFilterDict] && selectedFilterDict.count > 0) {
//            [filterButton setImage:[UIImage imageNamed:@"selected_Filter.png"] forState:UIControlStateNormal];
//        }else{
//            [filterButton setImage:[UIImage imageNamed:@"webner_filter.png"] forState:UIControlStateNormal];
//        }
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
//        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:selectedFilterDict];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc] init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:100] forKey:@"Count"];
        [mainDict setObject:WEBINAR_EVENT_TYPE forKey:@"EventType"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        isDownloading = true;
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetEventDetailsBySearchTagLite" append:@"" forAction:@"POST"];//ArchivedWebinarsApiCall
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 self->isDownloading = false;
                                                                 [self->webinarListTable.tableFooterView removeFromSuperview];
                                                                 [self.view setNeedsUpdateConstraints];
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         NSDateFormatter *df = [NSDateFormatter new];
                                                                         [df setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
                                                                         [df setTimeZone:[NSTimeZone systemTimeZone]];
                                                                         NSDate *todayDate=[NSDate date];
                                                                         NSString *todayDtStr=[df stringFromDate:todayDate];
                                                                         NSDate *syncDate=[df dateFromString:todayDtStr];
                                                                         [defaults setObject:todayDate forKey:@"MeditationListSyncDate"];
                                                                         [self addUpdateDBForWebniarListing:responseString];
                                                                         
//                                                                         self->webinarMasterList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];
//                                                                         self->webinarList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];
//                                                                         self->webinarListForSearch = [self->webinarList mutableCopy];
//                                                                         if([Utility isEmptyCheck:self->eventTagList]){
//                                                                             [self getSubFilterList:@"GetEventTagListApiCall"];
//                                                                         }
//
//
//                                                                         NSMutableArray *durationListArray_Temp=[[NSMutableArray alloc] init];
//
//                                                                         if (![Utility isEmptyCheck:self->webinarList]){
//                                                                            for (NSDictionary *dict in self->webinarMasterList) {
//                                                                                 if (![Utility isEmptyCheck:[dict objectForKey:@"Duration"] ]) {
//                                                                                     int duration=[[dict objectForKey:@"Duration"] intValue];
//                                                                                     NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d min",duration],@"DurationString",[NSNumber numberWithInt:duration],@"Duration", nil];
//                                                                                     [durationListArray_Temp addObject:durationDict];
//                                                                                 }
//                                                                             }
//                                                                             //durationListArray_Temp = [self->webinarList valueForKeyPath:@"@distinctUnionOfObjects.Duration"];
//
//                                                                         }
//
//                                                                         if (![Utility isEmptyCheck:durationListArray_Temp]) {
//                                                                             self->durationListArray = [[[NSOrderedSet orderedSetWithArray:durationListArray_Temp] array] mutableCopy];
////                                                                             [self->durationFilterTable reloadData];
//                                                                             NSArray *tmpArr;
//                                                                             tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 5)"]];
//                                                                             if ([Utility isEmptyCheck:tmpArr]) {
//                                                                                 NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"5 min"],@"DurationString",[NSNumber numberWithInt:5],@"Duration", nil];
//                                                                                 [self->durationListArray addObject:durationDict];
//                                                                             }
//
//                                                                             tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 10)"]];
//                                                                             if ([Utility isEmptyCheck:tmpArr]) {
//                                                                                 NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"10 min"],@"DurationString",[NSNumber numberWithInt:10],@"Duration", nil];
//                                                                                 [self->durationListArray addObject:durationDict];
//                                                                             }
//
//                                                                             tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 20)"]];
//                                                                             if ([Utility isEmptyCheck:tmpArr]) {
//                                                                                 NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"20 min"],@"DurationString",[NSNumber numberWithInt:20],@"Duration", nil];
//                                                                                 [self->durationListArray addObject:durationDict];
//                                                                             }
//
//                                                                             tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 30)"]];
//                                                                             if ([Utility isEmptyCheck:tmpArr]) {
//                                                                                 NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"30 min"],@"DurationString",[NSNumber numberWithInt:30],@"Duration", nil];
//                                                                                 [self->durationListArray addObject:durationDict];
//                                                                             }
//
//                                                                             tmpArr=[self->durationListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration = 90)"]];
//                                                                             if ([Utility isEmptyCheck:tmpArr]) {
//                                                                                 NSDictionary *durationDict=[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"90 min"],@"DurationString",[NSNumber numberWithInt:90],@"Duration", nil];
//                                                                                 [self->durationListArray addObject:durationDict];
//                                                                             }
//
//                                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Duration" ascending:YES];
//                                                                             NSArray *sortDescriptors = @[descriptor];
//                                                                             self->durationListArray = [[self->durationListArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
//
//
//
//
//
//                                                                             [self->tagFilterTable reloadData];
//                                                                         }
//
//
//                                                                         if (![Utility isEmptyCheck:self->webinarList]) {
//                                                                             [self->webinarListTable reloadData];
//
//                                                                             if (self->_isLoadTagBreath || self->_isLoadTagMorning || self->_isLoadTagPower){
//                                                                                 UIButton *btn = [UIButton new];
//                                                                                 if(self->_isLoadTagBreath){
//                                                                                     self->_isLoadTagBreath = false;
//                                                                                     btn.tag = 0;
//                                                                                 }else if(self->_isLoadTagMorning){
//                                                                                     self->_isLoadTagMorning = false;
//                                                                                     btn.tag = 1;
//                                                                                 }else{
//                                                                                     self->_isLoadTagPower = false;
//                                                                                     btn.tag = 2;
//                                                                                 }
//
//                                                                                 [self landingButtonPressed:btn];
//
//                                                                             }
//
//                                                                             [self showResultButtonPressed:0];
//
//                                                                         }else{
//                                                                             self->webinarList = [[NSMutableArray alloc]init];
//                                                                             self->webinarMasterList = [[NSMutableArray alloc]init];
//                                                                             self->webinarListForSearch = [self->webinarList mutableCopy];
//
//
//                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
//                                                                             return;
//                                                                         }
                                                                         
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
        dispatch_async(dispatch_get_main_queue(), ^{
            isDownloading = false;
            [webinarListTable.tableFooterView removeFromSuperview];
            [self.view setNeedsUpdateConstraints];
        });
        [self offlineMeditationList];
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
    
}
-(void)getSubFilterList:(NSString *)api{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        contentView = [Utility activityIndicatorView:self];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        //[mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil){
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     if ([api isEqualToString:@"GetEventTypeListApiCall"]) {
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                             NSArray *eventTypeList = [responseDict objectForKey:@"Events"];
                                                                             if (![Utility isEmptyCheck:eventTypeList] && ![Utility isEmptyCheck:eventTypeList]) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
                                                                                     controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                                     controller.filterDataArray = eventTypeList;
                                                                                     if (![Utility isEmptyCheck:subSelectedDict]) {
                                                                                         if ([eventTypeList containsObject:subSelectedDict]) {
                                                                                             controller.selectedIndex = (int)[eventTypeList indexOfObject:subSelectedDict];
                                                                                         }else{
                                                                                             controller.selectedIndex = -1;
                                                                                         }
                                                                                     }else{
                                                                                         controller.selectedIndex = -1;
                                                                                     }
                                                                                     controller.mainKey = @"EventName";
                                                                                     controller.subKey = @"TotalEvents";
                                                                                     controller.delegate = self;
                                                                                     controller.apiType = api;
                                                                                     [self presentViewController:controller animated:YES completion:nil];
                                                                                 });
                                                                                 
                                                                             }else{
                                                                                 eventTypeList = [[NSArray alloc]init];
                                                                                 [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                             
                                                                         }else{
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else if ([api isEqualToString:@"GetArchiveYearsApiCall"]) {
                                                                         NSArray *response= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:response] && ![Utility isEmptyCheck:response]) {
                                                                             NSMutableArray *yearArray = [[NSMutableArray alloc]init];
                                                                             for (NSDictionary *dict in response) {
                                                                                 if (![Utility isEmptyCheck:[dict valueForKey:@"Months"]]) {
                                                                                     for (NSDictionary *monthData in [dict valueForKey:@"Months"]) {
                                                                                         NSMutableDictionary *temp = [[NSMutableDictionary alloc]initWithDictionary:monthData];
                                                                                         [temp setObject:[NSString stringWithFormat:@"%@ - %@",[monthData objectForKey:@"Month"],[monthData objectForKey:@"Year"]] forKey:@"MonthYear"];
                                                                                         [yearArray addObject:temp];
                                                                                     }
                                                                                 }
                                                                             }
                                                                             if (![Utility isEmptyCheck:yearArray] && ![Utility isEmptyCheck:yearArray]) {
                                                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                                                     FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
                                                                                     controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                                     controller.filterDataArray = yearArray;
                                                                                     if (![Utility isEmptyCheck:subSelectedDict]) {
                                                                                         if ([yearArray containsObject:subSelectedDict]) {
                                                                                             controller.selectedIndex = (int)[yearArray indexOfObject:subSelectedDict];
                                                                                         }else{
                                                                                             controller.selectedIndex = -1;
                                                                                         }
                                                                                     }else{
                                                                                         controller.selectedIndex = -1;
                                                                                     }
                                                                                     controller.mainKey = @"MonthYear";
                                                                                     controller.subKey = @"Count";
                                                                                     controller.delegate = self;
                                                                                     controller.apiType = api;
                                                                                     [self presentViewController:controller animated:YES completion:nil];
                                                                                 });
                                                                             }else{
                                                                                 yearArray = [[NSMutableArray alloc]init];
                                                                                 [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                             
                                                                         }else{
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else if ([api isEqualToString:@"GetEventTagListApiCall"]) {
                                                                         NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                             self->eventTagList = [responseDict objectForKey:@"Tags"];
                                                                             if (![Utility isEmptyCheck:self->eventTagList]) {
                                                                                 
                                                                                 NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"EventTagID" ascending:YES];
                                                                                 NSArray *sortDescriptors = @[descriptor];
                                                                                 self->eventTagList = [[self->eventTagList sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                                                                                 
                                                                                 [self->tagFilterTable reloadData];
                                                                                 [self addUpdateDB];
                                                                             }else{
                                                                                 self->eventTagList = [[NSArray alloc]init];
                                                                                 [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                             
                                                                         }else{
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }
                                                                     
                                                                     
                                                                 }else{
                                                                         [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
//        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
    
}

#pragma mark - End




#pragma mark -Scroll view delegete
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height){
//        if (!isDownloading) {
//            [self addFooter];
//            count++;
//            if (isFromWebinarListApi) {
//                [self getWebinarList];
//            }else{
//                [self getEventDetailsByType];
//            }
//        }
//
//    }
}
#pragma mark -End

#pragma mark - TableView Datasource & Delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==webinarListTable) {
        return 1;
    }else if (tableView==tagFilterTable){
        return 4;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==webinarListTable) {
        if (webinarList.count>0) {
            noDataLabelForTable.hidden=true;
        }else{
            noDataLabelForTable.hidden=false;
            if(isSelectedFavFilter){
                [self addImageToUILabel];
            }else{
                noDataLabelForTable.text = @"No Data Found";
            }
        }
        return webinarList.count;
    }else if (tableView==tagFilterTable){
        if (section==0) {
            return eventTagList.count;
        }else if (section==1){
            return durationListArray.count;
        }else if (section==2){
            return levelListArray.count;
        }else{
            return 1;
        }
    }else{
        return 0;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor whiteColor];
    
    if (tableView == tagFilterTable){
        UILabel *customLabel = [[UILabel alloc] init];
        customLabel.backgroundColor=[UIColor whiteColor];
//        customLabel.textColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
        customLabel.textColor = [UIColor blackColor];
        customLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17.0];
        
        if(section == 0){
            customLabel.text = @"  TAGS";
            label=customLabel;
        }else if (section == 1){
            customLabel.text = @"  DURATION";
            label=customLabel;
        }else if (section == 2){
            customLabel.text = @"  LEVEL";
            label=customLabel;
        }else{
            customLabel.text = @"  FAVOURITE";
            label=customLabel;
        }
    }
    
    return label;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==webinarListTable) {
            NSString *CellIdentifier =@"WebinarListTableViewCell";
            WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[WebinarListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            NSDictionary *webinarsData = [webinarList objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:webinarList]) {
                NSString *eventString = [webinarsData valueForKey:@"EventName"];
                if (![Utility isEmptyCheck:eventString]) {
                    cell.listHeadingTextLabel.text = eventString;
                }//@"Photo.png"
                NSString *presenterString =[webinarsData valueForKey:@"PresenterName"];
                NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];
                NSString *imageString =[webinarsData valueForKey:@"ImageUrl"];
                cell.listImageView.layer.cornerRadius = 15;  //cell.listImageView.frame.size.width/2;
                cell.listImageView.clipsToBounds = YES;
                if (![Utility isEmptyCheck:imageString]) {
                    [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                 [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                          placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                }else{
                    if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
                        NSString *s=[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
                                     [NSCharacterSet URLQueryAllowedCharacterSet]];
                        [cell.listImageView sd_setImageWithURL:[NSURL URLWithString:s]
                                              placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                    }else{
                        cell.listImageView.image = [UIImage imageNamed:@"place_holder1.png"];
                    }
                }
                

                
        //        tag
                NSMutableAttributedString *newString =[[NSMutableAttributedString alloc] init];
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"p_tag.png"];
                textAttachment.bounds = CGRectMake(0, -3, textAttachment.image.size.width, textAttachment.image.size.height);
                NSDictionary *attrsDictionary = @{
                                                  NSFontAttributeName : cell.tagView.font,
                                                  NSForegroundColorAttributeName : cell.tagView.textColor

                                                  };
                NSArray *items =[webinarsData valueForKey:@"Tags"];
                for (int i = 0 ; i<items.count; i++) {
                    NSString *itemsName = [items objectAtIndex:i];
                    itemsName = [[itemsName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@" %@   ",itemsName] attributes:attrsDictionary];



                    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];

                    [newString appendAttributedString:attrStringWithImage];
                    [newString appendAttributedString:attributedString];

                }
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                [style setLineSpacing:5];
        [newString addAttribute:NSParagraphStyleAttributeName
                                   value:style
                                   range:NSMakeRange(0, newString.length)];
        cell.tagView.attributedText = newString;
                
                
                //chayan
        //        NSString *tag;
        //        if (![Utility isEmptyCheck:[webinarsData objectForKey:@"Tags"]]) {
        //            tag =[[webinarsData objectForKey:@"Tags"] objectAtIndex:0];
        //        }else{
        //            tag =@"";
        //        }
        //        cell.tagView.text = [NSString stringWithFormat:@"%@",![Utility isEmptyCheck:tag] ? tag : @""];

        }
        cell.meditationActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
        cell.meditationActionButton.clipsToBounds = YES;
        cell.meditationActionButton.layer.borderWidth = 1.2;
        cell.meditationActionButton.layer.cornerRadius = cell.meditationActionButton.frame.size.height/2.0;
        [cell.meditationActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //                [cell.courseActionButton setImage:[UIImage imageNamed:@"play_green.png"] forState:UIControlStateNormal];
        [cell.meditationActionButton setTitle:@"START" forState:UIControlStateNormal];
        [cell.meditationActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
        cell.meditationActionButton.tag=indexPath.row;
        cell.favButton.tag=indexPath.row;
        cell.favButton.selected = [[webinarsData valueForKey:@"Likes"] boolValue];
        if (![Utility isEmptyCheck:[webinarsData objectForKey:@"Duration"]]) {
            cell.timeLabel.text=[NSString stringWithFormat:@"%@ min",[webinarsData objectForKey:@"Duration"]];
        }else{
            cell.timeLabel.text=@"00 min";
        }
        
        cell.webinarTypeLabel.text=[[webinarsData objectForKey:@"Tags"] objectAtIndex:0];
        
        cell.mainView.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
        cell.mainView.layer.borderWidth=1;
        cell.mainView.layer.cornerRadius=10;
        cell.mainView.clipsToBounds=YES;
        cell.mainView.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
        
        
        [cell updateConstraintsIfNeeded];
        return cell;
        
//#############################
    }else{
        NSString *CellIdentifier =@"WebinarListTagTableViewCell";
        WebinarListTagTableViewCell *cell = (WebinarListTagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[WebinarListTagTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (indexPath.section==0) {
            if (![Utility isEmptyCheck:eventTagList]) {
                NSDictionary *tagData = [eventTagList objectAtIndex:indexPath.row];
                NSString *tagString = [tagData valueForKey:@"Description"];
                if (![Utility isEmptyCheck:tagString]) {
                    cell.tagNameLabel.text = tagString;
                }
                if (![Utility isEmptyCheck:selectedTagArray]) {
                    if ([selectedTagArray containsObject:tagData]) {
                        cell.checkUncheckButton.selected=true;
                    }else{
                        cell.checkUncheckButton.selected=false;
                    }
                }else{
                    cell.checkUncheckButton.selected=false;
                }
                
                cell.checkUncheckButton.tag=indexPath.row;
                cell.checkUncheckButton.accessibilityHint=@"Tag";
            }
        }else if (indexPath.section==1){
            if (![Utility isEmptyCheck:durationListArray]) {
                NSDictionary *durationData = [durationListArray objectAtIndex:indexPath.row];
                NSString *durationString = [durationData valueForKey:@"DurationString"];
                if (![Utility isEmptyCheck:durationString]) {
                    cell.tagNameLabel.text = durationString;
                }
                if (![Utility isEmptyCheck:selectedDurationArray]) {
                    if ([selectedDurationArray containsObject:durationData]) {
                        cell.checkUncheckButton.selected=true;
                    }else{
                       cell.checkUncheckButton.selected=false;
                    }
                }else{
                    cell.checkUncheckButton.selected=false;
                }
                
                cell.checkUncheckButton.tag=indexPath.row;
                cell.checkUncheckButton.accessibilityHint=@"Duration";
            }
        }else if (indexPath.section==2){
            if (![Utility isEmptyCheck:levelListArray]) {
                NSDictionary *levelData = [levelListArray objectAtIndex:indexPath.row];
                NSString *levelString = [levelData valueForKey:@"LevelString"];
                if (![Utility isEmptyCheck:levelString]) {
                    cell.tagNameLabel.text = levelString;
                }
                if (![Utility isEmptyCheck:selectedLevelArray]) {
                    if ([selectedLevelArray containsObject:levelData]) {
                        cell.checkUncheckButton.selected=true;
                    }else{
                       cell.checkUncheckButton.selected=false;
                    }
                }else{
                    cell.checkUncheckButton.selected=false;
                }
                
                cell.checkUncheckButton.tag=indexPath.row;
                cell.checkUncheckButton.accessibilityHint=@"Level";
            }
        }else{
            cell.tagNameLabel.text = @"Favourite";
            if (isSelectedFavFilter) {
                cell.checkUncheckButton.selected=true;
            }else{
                cell.checkUncheckButton.selected=false;
            }
            cell.checkUncheckButton.tag=indexPath.row;
            cell.checkUncheckButton.accessibilityHint=@"Fav";
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==webinarListTable) {
        if (![Utility isEmptyCheck:[webinarList objectAtIndex:indexPath.row]]) {
        NSDictionary *webinarsData = [webinarList objectAtIndex:indexPath.row];
            
        NSString *eventString = [webinarsData valueForKey:@"EventName"];
        if (![Utility isEmptyCheck:eventString]) {
            webinarNameLabel.text = eventString;
        }
        
        //image
        NSString *presenterString =[webinarsData valueForKey:@"PresenterName"];
        NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];
        NSString *imageString =[webinarsData valueForKey:@"ImageUrl"];
        webinarImage.layer.cornerRadius = webinarImage.frame.size.width/2;
        webinarImage.clipsToBounds = YES;
        if (![Utility isEmptyCheck:imageString]) {
            [webinarImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                         [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                  placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
        }else{
            if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
                NSString *s=[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
                             [NSCharacterSet URLQueryAllowedCharacterSet]];
                [webinarImage sd_setImageWithURL:[NSURL URLWithString:s]
                                      placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                webinarImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
        }
        //----------
            
        if (![Utility isEmptyCheck:[webinarsData objectForKey:@"Duration"]]) {
            durationLabel.text=[NSString stringWithFormat:@"%@ min",[webinarsData objectForKey:@"Duration"]];
        }else{
            durationLabel.text=@"00 min";
        }
            
        if (![Utility isEmptyCheck:[webinarsData objectForKey:@"Level"]]) {
            webinarLevelLabel.text=[NSString stringWithFormat:@"Level %@",[webinarsData objectForKey:@"Level"]];
        }else{
            webinarLevelLabel.text=@"     ";
        }
        
        webinarTypeLabel.text=[[webinarsData objectForKey:@"Tags"] objectAtIndex:0];
        
        
        
        
        NSString *msg= [webinarsData valueForKey:@"Content"];
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                                 documentAttributes:nil error:nil];
        [strAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:16] range:NSMakeRange(0, [strAttributed length])];
        descriptionText.textContainer.lineFragmentPadding = 0;
        descriptionText.textContainerInset = UIEdgeInsetsZero;
        descriptionText.attributedText=strAttributed;
        
        CGSize sizeThatShouldFitTheContent = [descriptionText sizeThatFits:descriptionText.frame.size];
        descriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
            
        
        startButton.tag=indexPath.row;
        descriptionView.hidden = false;
            
        
            
            
            
            
//            if (![Utility isEmptyCheck:[webinarsData valueForKey:@"Content"]]) {
//                NSString *msg= [webinarsData valueForKey:@"Content"];
//                NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
//                                                                                                   options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
//                                                                                         documentAttributes:nil error:nil];
//                [strAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:16] range:NSMakeRange(0, [strAttributed length])];
//                descriptionText.textContainer.lineFragmentPadding = 0;
//                descriptionText.textContainerInset = UIEdgeInsetsZero;
//                descriptionText.attributedText =strAttributed;
//
//                CGSize sizeThatShouldFitTheContent = [descriptionText sizeThatFits:descriptionText.frame.size];
//                descriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;//descriptionText.contentSize.height;
//                [self.view setNeedsUpdateConstraints];
//
//                descriptionView.hidden = false;
//                nodataLabel.hidden = true;
//            }else{
//                descriptionText.attributedText = [[NSAttributedString alloc]initWithString:@""];
//                descriptionView.hidden = false;
//                nodataLabel.hidden= false;
//            }
        }
    }else{
        WebinarListTagTableViewCell *cell = (WebinarListTagTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self filterCheckUncheckPressed:cell.checkUncheckButton];
    }
}

#pragma mark -end

#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{

    NSLog(@"search for %@", textField.text);
    NSArray *tmpArr;
    if(textField.text.length>0){
        tmpArr=[webinarListForSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EventName CONTAINS[c] %@)", textField.text]];
        webinarList=[tmpArr mutableCopy];
    }else{
        webinarList=[webinarListForSearch mutableCopy];
    }
    if (![Utility isEmptyCheck:webinarList]) {
        noDataLabelForTable.hidden = true;
    }else{
        noDataLabelForTable.hidden = false;
    }
    [webinarListTable reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{

    NSArray *tmpArr;
    if(textField.text.length>0){
        tmpArr=[webinarListForSearch filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EventName CONTAINS[c] %@)", textField.text]];
        webinarList=[tmpArr mutableCopy];
    }else{
        webinarList=[webinarListForSearch mutableCopy];
    }
    if (![Utility isEmptyCheck:webinarList]) {
        noDataLabelForTable.hidden = true;
    }else{
        noDataLabelForTable.hidden = false;
    }
    [webinarListTable reloadData];
    [textField resignFirstResponder];
}
#pragma mark - End



#pragma mark - FilterViewDelegate
-(void)didSelectAnyFilterOption:(NSString *)type data:(NSDictionary *)data{
    if ([Utility isEmptyCheck:type]) {
        parentSelectedDict = data;
        if([[data valueForKey:@"Value"] isEqualToString:@"Remove Filter"]){
            [filterButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
            selectedFilterDict =[[NSDictionary alloc]init];
            subSelectedDict = [[NSDictionary alloc]init];
            count = 1;
            webinarList = [webinarMasterList mutableCopy];
            webinarListForSearch=[webinarList mutableCopy];
            [webinarListTable reloadData];
//            isFromWebinarListApi = YES;
        }else if([[data valueForKey:@"Value"] isEqualToString:@"Tags"]){
          if (![Utility isEmptyCheck:eventTagList]) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
                  controller.modalPresentationStyle = UIModalPresentationCustom;
                  controller.filterDataArray = self->eventTagList;
                  if (![Utility isEmptyCheck:self->subSelectedDict]) {
                      if ([self->eventTagList containsObject:self->subSelectedDict]) {
                          controller.selectedIndex = (int)[self->eventTagList indexOfObject:self->subSelectedDict];
                      }else{
                          controller.selectedIndex = -1;
                      }
                  }else{
                      controller.selectedIndex = -1;
                  }
                  controller.mainKey = @"Description";
                  controller.subKey = @"TotalEvents";
                  controller.delegate = self;
                  controller.apiType = @"GetEventTagListApiCall";
                  [self presentViewController:controller animated:YES completion:nil];
              });
          }
        }else if([[data valueForKey:@"Value"] isEqualToString:@"Duration"]){
          if (![Utility isEmptyCheck:durationListArray]) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
                  controller.modalPresentationStyle = UIModalPresentationCustom;
                  controller.filterDataArray = self->durationListArray;
                  if (![Utility isEmptyCheck:self->subSelectedDict]) {
                      if ([self->durationListArray containsObject:self->subSelectedDict]) {
                          controller.selectedIndex = (int)[self->durationListArray indexOfObject:self->subSelectedDict];
                      }else{
                          controller.selectedIndex = -1;
                      }
                  }else{
                      controller.selectedIndex = -1;
                  }
                  controller.mainKey = @"DurationString";
                  controller.subKey = @"";
                  controller.delegate = self;
                  controller.apiType = @"DurationFilter";
                  [self presentViewController:controller animated:YES completion:nil];
              });
          }
        }else if([[data valueForKey:@"Value"] isEqualToString:@"Favourites"]){
            [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
            NSArray *tmpArr=[webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Likes==%@)",[NSNumber numberWithBool:YES]]];
            webinarList=[tmpArr mutableCopy];
            webinarListForSearch=[webinarList mutableCopy];
            if (![Utility isEmptyCheck:webinarList]) {
                noDataLabelForTable.hidden = true;
            }else{
                noDataLabelForTable.hidden = false;
            }
            [webinarListTable reloadData];
        }
    }else{
        subSelectedDict = data;
        if ([type isEqualToString:@"GetEventTagListApiCall"]) {
            [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
            count = 1;
//            selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[data valueForKey:@"EventTagID"],@"TagID",[data valueForKey:@"Description"],@"EventTagName", nil];
            NSString *tagName=[data valueForKey:@"Description"];
            if(![Utility isEmptyCheck:tagName]){
                NSArray *tmpArr=[webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Tags CONTAINS[c] %@)", tagName]];
                webinarList=[tmpArr mutableCopy];
                webinarListForSearch=[webinarList mutableCopy];
            }else{
//                webinarList=[webinarMasterList mutableCopy];
//                webinarListForSearch=[webinarList mutableCopy];
            }
            
            if (![Utility isEmptyCheck:webinarList]) {
                noDataLabelForTable.hidden = true;
            }else{
                noDataLabelForTable.hidden = false;
            }
            [webinarListTable reloadData];
        }else if ([type isEqualToString:@"DurationFilter"]){
            [filterButton setImage:[UIImage imageNamed:@"settings_active.png"] forState:UIControlStateNormal];
            
            if(![Utility isEmptyCheck:[data valueForKey:@"Duration"]]){
                int duration=[[data valueForKey:@"Duration"] intValue];
                NSArray *tmpArr=[webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Duration==%d)", duration]];
                webinarList=[tmpArr mutableCopy];
                webinarListForSearch=[webinarList mutableCopy];
            }
            if (![Utility isEmptyCheck:webinarList]) {
                noDataLabelForTable.hidden = true;
            }else{
                noDataLabelForTable.hidden = false;
            }
            [webinarListTable reloadData];
        }
    }
    
}

#pragma mark - LongPressGestureRecognizer Delegate

-  (void)handleLongPressForOffline:(UILongPressGestureRecognizer*)sender {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
   }
  else if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan");
            editDelView.hidden = false;
            CGPoint location = [sender locationInView:webinarListTable];
            NSIndexPath *indexpath= [webinarListTable indexPathForRowAtPoint:location];
            NSDictionary *dict = [webinarMasterList objectAtIndex:indexpath.row];
            eventID = [[dict objectForKey:@"EventItemID"]intValue];
   }
}
#pragma mark - End






#pragma mark - End
#pragma mark - NSURLSession Delegate method implementation

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:destinationFilename];
        NSURL *destinationURL = [NSURL fileURLWithPath:fullPathToFile];

        if ([fileManager fileExistsAtPath:[destinationURL path]]) {
            [fileManager removeItemAtURL:destinationURL error:nil];
        }

        BOOL success = [fileManager copyItemAtURL:location
                                            toURL:destinationURL
                                            error:&error];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{

//        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
//        cell.downloadButton.enabled = false;
//        cell.progress.hidden = true;
        if (success) {
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPathToFile]) {
                if ([self->circleProgresBar isAnimating]) {
                    [self->circleProgresBar stopAnimation];
                }
                self->progressView.hidden = true;
                NSArray *tmpArr=[self->webinarMasterList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(Likes==%@)",[NSNumber numberWithBool:YES]]];
                WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                controller.webinar = [self->webinarsData mutableCopy];
                controller.shopUrl=self->shopUrl;
                if (tmpArr.count>0) {
                    controller.isShowFavAlert=NO;
                }else{
                    controller.isShowFavAlert=YES;
                }
                [self.navigationController pushViewController:controller animated:YES];
//                cell.downloadButton.enabled = true;
//                cell.progress.hidden = true;
//                cell.status.text = @"Download finished successfully.";
//                cell.status.hidden = false;
//                [cell.downloadButton setImage:[UIImage imageNamed:@"play_btn.png"] forState:UIControlStateNormal];
            }else{
//                [cell.downloadButton  setImage:[UIImage imageNamed:@"w_download.png"] forState:UIControlStateNormal];
            }
        }
        else{
//            cell.status.text = [error localizedDescription];
//            cell.status.hidden = false;

            NSLog(@"Unable to copy temp file. Error: %@", [error localizedDescription]);
        }
        [backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];
        if ([indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]].count > 0) {
            [indexPathAndTaskDict removeObjectForKey:[[indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]]objectAtIndex:0]];
        }

    }];
}


-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        cell.downloadButton.enabled = false;
        cell.progress.hidden = true;
        cell.status.hidden = false;
        if (error != nil) {
            cell.status.text = [@"" stringByAppendingFormat:@"Download completed with error: %@",[error localizedDescription]];
            NSLog(@"Download completed with error: %@", [error localizedDescription]);
        }
        else{
            cell.status.text = @"Download finished successfully.";
            NSLog(@"Download finished successfully.");
        }
        [backgroundDownloadDict removeObjectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]];
        if ([indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]].count > 0) {
            [indexPathAndTaskDict removeObjectForKey:[[indexPathAndTaskDict allKeysForObject:[@"" stringByAppendingFormat:@"%lu",(unsigned long)task.taskIdentifier]]objectAtIndex:0]];
        }


    }];
}


-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        WebinarListTableViewCell *cell = (WebinarListTableViewCell *)[backgroundDownloadDict objectForKey:[@"" stringByAppendingFormat:@"%lu",(unsigned long)downloadTask.taskIdentifier]];

        if (totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown) {
            NSLog(@"Unknown transfer size");
            cell.status.text = @"Unknown transfer size";
            cell.status.hidden = false;
            cell.progress.hidden= true;

        }else{
            double downloadProgress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
            cell.progress.progress= downloadProgress;
            cell.status.hidden = false;
            NSLog(@"Download Progress:%@",[@"" stringByAppendingFormat:@"%.0f%%",downloadProgress*100]);
                       dispatch_async(dispatch_get_main_queue(), ^{
                           [self->circleProgresBar setProgress:downloadProgress animated:YES];
                           [self->circleProgresBar setHintTextColor:[Utility colorWithHexString:mbhqBaseColor]];
                           [self->circleProgresBar setHintViewBackgroundColor:[UIColor clearColor]];
                           [self->circleProgresBar setProgressBarProgressColor:[Utility colorWithHexString:mbhqBaseColor]];
                           [self->circleProgresBar setHintTextGenerationBlock:(YES ? ^NSString *(CGFloat progress) {
                               return [@"" stringByAppendingFormat:@"%.0f%%",downloadProgress*100];
                           } : nil)];
                       });
        }
    }];
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Check if all download tasks have been finished.
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        if ([downloadTasks count] == 0) {
            if (appDelegate.backgroundTransferCompletionHandler != nil) {
                // Copy locally the completion handler.
                void(^completionHandler)() = appDelegate.backgroundTransferCompletionHandler;
                
                // Make nil the backgroundTransferCompletionHandler.
                appDelegate.backgroundTransferCompletionHandler = nil;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    // Call the completion handler to tell the system that there are no other background transfers.
                    completionHandler();
                    [defaults removeObjectForKey:@"indexPathAndTaskDict"];

                    // Show a local notification when all downloads are over.
                    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = @"All files have been downloaded!";
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                }];
            }
        }
    }];
}




#pragma mark - Gesture recognizer delegate
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:webinarListTable];
    NSIndexPath *indexPath = [webinarListTable indexPathForRowAtPoint:p];
    if (indexPath != nil) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
            NSDictionary *dict = [webinarList objectAtIndex:indexPath.row];
            [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[dict objectForKey:@"EventName"]]? [dict objectForKey:@"EventName"] : @"";
            [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
        }
    }
}
#pragma mark - End


@end



/*
## old filter delegate
-(void)didSelectAnyFilterOption:(NSString *)type data:(NSDictionary *)data{
    if ([Utility isEmptyCheck:type]) {
        parentSelectedDict = data;
        if([[data valueForKey:@"Value"] isEqualToString:@"Remove Filter"]){
            selectedFilterDict =[[NSDictionary alloc]init];
            subSelectedDict = [[NSDictionary alloc]init];
            count = 1;
            webinarList = [[NSMutableArray alloc]init];
            isFromWebinarListApi = YES;
            [self getWebinarList];
        }else if([[data valueForKey:@"Value"] isEqualToString:@"Presenter"]){
          NSArray *presenterList = [defaults objectForKey:@"PresenterList"];
            dispatch_async(dispatch_get_main_queue(), ^{
                FilterViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Filter"];
                controller.modalPresentationStyle = UIModalPresentationCustom;
                controller.filterDataArray = presenterList;
                if (![Utility isEmptyCheck:subSelectedDict]) {
                    if ([presenterList containsObject:subSelectedDict]) {
                        controller.selectedIndex = (int)[presenterList indexOfObject:subSelectedDict];
                    }else{
                        controller.selectedIndex = -1;
                    }
                }else{
                    controller.selectedIndex = -1;
                }
                controller.mainKey = @"EventName";
                controller.subKey = @"TotalEvents";
                controller.delegate = self;
                controller.apiType = [data valueForKey:@"Key"];
                [self presentViewController:controller animated:YES completion:nil];
            });
        }else{
            count= 1;
            [self getSubFilterList:[data valueForKey:@"Key"]];
        }
    }else{
        subSelectedDict = data;
        if ([type isEqualToString:@"GetEventTypeListApiCall"]) {
            selectedFilterDict =[[NSDictionary alloc]initWithObjectsAndKeys:[data valueForKey:@"EventID"],@"EventTypeID", nil];
            [self getEventDetailsByType];
        }else if([type isEqualToString:@"GetPresenterListApiCall"]){
            count= 1;
            selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[data valueForKey:@"EventID"],@"PresenterID", nil];
            [self getEventDetailsByType];
        }else if([type isEqualToString:@"GetArchiveYearsApiCall"]){
            selectedFilterDict =[[NSDictionary alloc]initWithObjectsAndKeys:[data valueForKey:@"MonthNumber"],@"Month",[data valueForKey:@"Year"],@"Year", nil];
            count = 1;
            [self getWebinarList];
        }else if([type isEqualToString:@"GetEventTagListApiCall"]){
            count = 1;
            selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[data valueForKey:@"EventTagID"],@"TagID",[data valueForKey:@"Description"],@"EventTagName", nil];
            [self getWebinarList];
        }
    }
}

*/


