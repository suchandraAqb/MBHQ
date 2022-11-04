//
//  CoursesListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CoursesListViewController.h"
#import "AvailableCourseView.h"
#import "EnrolledCourses.h"
#import "Utility.h"
#import "CourseDetailsViewController.h"
#import "CourseListTableViewCell.h"
#import "CourseAuthorListCell.h"
#import "WebinarListViewController.h"
#import "PodcastViewController.h"
#import "WebinarSelectedViewController.h"
#import "CourseDetailsEntryViewController.h"
#import "CourseArticleDetailsViewController.h"
#import "CourseListTagFilterTableViewCell.h"
#import "CoursePodcastTableViewCell.h"

@interface CoursesListViewController (){
    UIView *contentView;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UIStackView *outerStackView;
    IBOutlet UIStackView *availableCoursesStackView;
    IBOutlet UIStackView * enrolledCoursesStackView;
    NSArray *courseList;
    NSArray *userCourseList;
    
    int apiCount;
    BOOL isFirstLoad;
    int editRow;
    
    //Ru
    IBOutlet UIButton *courseFilterButton;
    IBOutlet UITableView *courseListTable;
    IBOutlet UITableView *authorListTable;
    IBOutlet UIView *viewFilter;
    IBOutlet UIButton *memberTypeExpandBtn;
    IBOutlet UIButton *activeExpandBtn;
    
    IBOutlet UIButton *presenterExpandBtn;
    
    IBOutlet UIButton *selectDateButton;
    IBOutlet UIButton *authorExpandBtn;
    UIButton *SelectedFilterbtn;
    NSDate *selectedDate;
    
    IBOutletCollection(UIView) NSArray *viewMemberTypeOutletCollection;
    IBOutletCollection(UIButton) NSArray *memberTypeOutletCollection;
    
    IBOutletCollection(UIView) NSArray *viewActiveTypeOutletCollection;
    IBOutletCollection(UIButton) NSArray *activeTypeOutletCollection;
    
    IBOutletCollection(UIView) NSArray *viewDateOutletCollection;
    IBOutletCollection(UIButton) NSArray *dateOutletCollection;
    IBOutletCollection(UIView) NSArray *viewPresenterOutletCollection;
    IBOutletCollection(UIButton) NSArray *presenterOutletCollection;
    
    IBOutletCollection(UIView) NSArray *viewAuthorOutletCollection;
    IBOutletCollection(UIButton) NSArray *authorOutletCollection;
    
    IBOutlet UIView *descriptionView;
    IBOutlet UITextView *descriptionText;
    IBOutlet UILabel *nodataLabel;
    
    IBOutlet UITextField *searchTextField;
    UIToolbar *toolBar;
    NSMutableArray *mainListArray;
    NSMutableArray *programArray;
    NSMutableArray *MemberProgramArray;
    NSMutableArray *liveProgramArray;
    NSMutableArray *paidProgramArray;
    NSMutableArray *masterClassProgramArray;
    NSMutableArray *paidMasterClassProgramArray;
    
    NSMutableDictionary *dataDict;
    
    NSMutableArray *tagArray;
    NSMutableArray *selectedTagArray;
    


    IBOutlet UIView *filterView;
    IBOutlet UIButton *allTickButton;
    IBOutlet UIButton *activeTickButton;
    IBOutlet UIButton *availabelTickButton;
    IBOutlet UIButton *completeButton;
    IBOutlet UILabel *noDataLabelForTable;
    
    IBOutlet UIView *courseStartAlertView;
    
    IBOutlet UIButton *courseStartTodayButton;
    IBOutlet UIButton *courseStartNextMondayButton;
    
    IBOutlet UIView *descriptionSubView;
    IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;
    
    IBOutlet UIView *walkThroughView;
    IBOutlet UIButton *walkThroughGotItButton;
    
    
    
    NSArray *selectedArray;
    BOOL isShowAllProgram;
    BOOL isShowAllMemberProgram;
    BOOL isShowAllLiveProgram;
    BOOL isShowAllPaidProgram;
    NSArray *rawList_Program;
    NSDictionary *courseActionDict;
    BOOL isLoadController;
    BOOL moveAfterPurchase;
    
    UIRefreshControl *refreshControl;
    
    IBOutlet NSLayoutConstraint *courseListTableHeightConstraint;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITableView *podcastTable;
    IBOutlet NSLayoutConstraint *podcastTableHeightConstraint;
    
    IBOutlet UITableView *tagFilterTable;
    IBOutlet NSLayoutConstraint *tagFilterTableHeightConstraint;
    
    IBOutlet UIButton *showAllFilterButton;
    IBOutletCollection(UIButton) NSArray *programTypeFilterButtons;
    IBOutlet UIButton *masterclassFilterButton;
    
    IBOutletCollection(UIButton) NSArray *statusFilterButtons;
    IBOutlet UIButton *showResultButton;
    IBOutlet UIButton *clearAllButton;

    
    
    
}

@end

@implementation CoursesListViewController
@synthesize fromSetProgram,courseName;//SetProgram_In


#pragma mark -ViewLifeCycle -
- (void)viewDidLoad {
    [super viewDidLoad];
    viewFilter.hidden = YES;
    filterView.hidden = true;
    isLoadController = YES;
    isShowAllProgram=NO;
    isFirstLoad = YES;
    mainListArray = [[NSMutableArray alloc] init];
    programArray = [[NSMutableArray alloc] init];
    MemberProgramArray = [[NSMutableArray alloc] init];
    liveProgramArray = [[NSMutableArray alloc] init];
    paidProgramArray = [[NSMutableArray alloc] init];
    masterClassProgramArray = [[NSMutableArray alloc] init];
    paidMasterClassProgramArray = [[NSMutableArray alloc] init];
    dataDict=[[NSMutableDictionary alloc] init];
    tagArray=[[NSMutableArray alloc] init];
    selectedTagArray=[[NSMutableArray alloc] init];

    
    selectDateButton.layer.borderColor = [UIColor colorWithRed:229.0 / 255.0 green:36.0 / 255.0 blue:161.0 / 255.0 alpha:1.0].CGColor;
    selectDateButton.clipsToBounds = YES;
    selectDateButton.layer.borderWidth = 1.2;
    selectDateButton.layer.cornerRadius = 10;
    
    showResultButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
    showResultButton.clipsToBounds = YES;
    showResultButton.layer.borderWidth = 1.2;
    showResultButton.layer.cornerRadius = 10;
    
    clearAllButton.layer.borderColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0].CGColor;
    clearAllButton.clipsToBounds = YES;
    clearAllButton.layer.borderWidth = 1.2;
    clearAllButton.layer.cornerRadius = 15;
    
    walkThroughGotItButton.layer.cornerRadius=15;
    walkThroughGotItButton.layer.masksToBounds=true;
    
    memberTypeExpandBtn.selected = true;
    for(UIView *view in viewMemberTypeOutletCollection){
        view.hidden = NO;
    }
    activeExpandBtn.selected = true;
    for(UIView *view in viewActiveTypeOutletCollection){
        view.hidden = NO;
    }
    presenterExpandBtn.selected = true;
    for(UIView *view in viewPresenterOutletCollection){
        view.hidden = NO;
    }
    authorExpandBtn.selected = true;
    for(UIView *view in viewAuthorOutletCollection){
        view.hidden = NO;
    }
    
    courseListTable.estimatedRowHeight = 280;
    courseListTable.rowHeight = UITableViewAutomaticDimension;
    
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
    
    descriptionSubView.layer.cornerRadius=20;
    descriptionSubView.clipsToBounds=YES;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
//    if (@available(iOS 10.0, *)) {
//        courseListTable.refreshControl = refreshControl;
//    } else {
//        [courseListTable addSubview:refreshControl];
//    }
    
    if (@available(iOS 10.0, *)) {
        mainScrollView.refreshControl = refreshControl;
    } else {
        [mainScrollView addSubview:refreshControl];
    }
    
    [courseListTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [podcastTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [tagFilterTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ReloadCourseList" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
           dispatch_async(dispatch_get_main_queue(), ^{
               [self getCourseListApiCall];
           });
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ReloadCourseListAfterPurchase" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
           dispatch_async(dispatch_get_main_queue(), ^{
               self->moveAfterPurchase=true;
               [self getCourseListApiCall];
           });
    }];
    
    
    if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeCourse"]] || ![defaults boolForKey:@"isFirstTimeCourse"]) {
        [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeCourse"];
        walkThroughView.hidden=false;
    }else{
        walkThroughView.hidden=true;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    courseStartAlertView.hidden=true;
    NSDate *dateMonday=[Utility nextMondayDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *str= [df stringFromDate:dateMonday];
    courseStartNextMondayButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    courseStartNextMondayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [courseStartNextMondayButton setTitle:[@"" stringByAppendingFormat:@"Monday\n%@\n(recommended)",str] forState:UIControlStateNormal];
    
    
     
    filterView.hidden=true;
    descriptionView.hidden = true;
    nodataLabel.hidden = true;
    noDataLabelForTable.hidden=true;
    
    if(!isFirstLoad && _isRedirectToSetProgram){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    if (!isLoadController) {
        return;
    }
    isLoadController = false;
    apiCount= 0;
    
    
    
    
    //Gesture Recognizer
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //seconds
    [courseListTable addGestureRecognizer:lpgr];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getCourseListApiCall];
    });
    
}

//-(void)viewWillDisappear:(BOOL)animated{
//    [courseListTable removeObserver:self forKeyPath:@"contentSize"];
//}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isFirstLoad = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End -


#pragma mark - IBAction -

- (IBAction)showAllFilterButtonPressed:(UIButton *)sender {
    if (!sender.selected) {
        [self clearButtonPressed:0];
    }
}

- (IBAction)programTypeFilterButtonPressed:(UIButton *)sender {
    sender.selected=!sender.isSelected;
    if (![self isAnyFilterSelected]) {
        [self clearButtonPressed:0];
    }else{
        showAllFilterButton.selected=false;
    }
}

- (IBAction)masterClassFilterButtonPressed:(UIButton *)sender {
    sender.selected=!sender.isSelected;
    if (![self isAnyFilterSelected]) {
        [self clearButtonPressed:0];
    }else{
        showAllFilterButton.selected=false;
    }
}

- (IBAction)statusFilterButtonPressed:(UIButton *)sender {
    if (!sender.isSelected) {
        for (UIButton *btn in statusFilterButtons) {
            if (btn==sender) {
                btn.selected=true;
            }else{
                btn.selected=false;
            }
        }
    }
    
    if (![self isAnyFilterSelected]) {
        [self clearButtonPressed:0];
    }else{
        showAllFilterButton.selected=false;
    }
}

- (IBAction)showResultButtonPressed:(UIButton *)sender {
    filterView.hidden = YES;
    NSArray *tmpArr;
    if (showAllFilterButton.isSelected) {
        isShowAllProgram=YES;
        tmpArr=programArray;
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        isShowAllMemberProgram=YES;
        tmpArr=MemberProgramArray;
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        isShowAllLiveProgram=YES;
        tmpArr=liveProgramArray;
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
        
        isShowAllPaidProgram=YES;
        tmpArr=paidProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
        tmpArr=masterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        
        tmpArr=paidMasterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
        
        [courseListTable reloadData];
        return;
    }else{
        bool programTypeSelectionFlag=false;
        for (UIButton *btn in programTypeFilterButtons) {
            if (btn.tag==0) {
                if (btn.isSelected) {
                    tmpArr=programArray;
                    [dataDict setObject:tmpArr forKey:@"Programs"];
                    programTypeSelectionFlag=true;
                }else{
                    tmpArr=[[NSArray alloc] init];
                    [dataDict setObject:tmpArr forKey:@"Programs"];
                }
            }else if (btn.tag==1){
                if (btn.isSelected) {
                    tmpArr=paidProgramArray;
                    [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
                    programTypeSelectionFlag=true;
                }else{
                    tmpArr=[[NSArray alloc] init];
                    [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
                }
            }else if (btn.tag==2){
                if (btn.isSelected) {
                    tmpArr=liveProgramArray;
                    [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                    programTypeSelectionFlag=true;
                }else{
                    tmpArr=liveProgramArray;
                    [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                }
            }
        }
        
        if (masterclassFilterButton.isSelected) {
            tmpArr=paidMasterClassProgramArray;
            [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
            tmpArr=masterClassProgramArray;
            [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
            programTypeSelectionFlag=true;
        }else{
            tmpArr=[[NSArray alloc] init];
            [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
            [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        }
        
        if (!programTypeSelectionFlag) {
            tmpArr=programArray;
            [dataDict setObject:tmpArr forKey:@"Programs"];
            tmpArr=paidProgramArray;
            [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
            tmpArr=liveProgramArray;
            [dataDict setObject:tmpArr forKey:@"LivePrograms"];
            tmpArr=masterClassProgramArray;
            [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
            tmpArr=paidMasterClassProgramArray;
            [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
        }
        
        
        for (UIButton *btn in statusFilterButtons) {
            if (btn.tag==0 && btn.isSelected) {
                break;
            }else if (btn.tag==1 && btn.isSelected){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 1"];
                tmpArr=[dataDict objectForKey:@"Programs"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"Programs"];
                
                tmpArr=[dataDict objectForKey:@"PaidPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
                
                tmpArr=[dataDict objectForKey:@"LivePrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                
                tmpArr=[dataDict objectForKey:@"MemberPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
                                
                tmpArr=[dataDict objectForKey:@"MasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
                
                tmpArr=[dataDict objectForKey:@"PaidMasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
                
                
                
            }else if (btn.tag==2 && btn.isSelected){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 2"];
                tmpArr=[dataDict objectForKey:@"Programs"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"Programs"];
                
                tmpArr=[dataDict objectForKey:@"PaidPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
                
                tmpArr=[dataDict objectForKey:@"LivePrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                
                tmpArr=[dataDict objectForKey:@"MemberPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
                
                tmpArr=[dataDict objectForKey:@"MasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
                
                tmpArr=[dataDict objectForKey:@"PaidMasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
                
            }else if (btn.tag==3 && btn.isSelected){
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 3"];
                tmpArr=[dataDict objectForKey:@"Programs"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"Programs"];
                
                tmpArr=[dataDict objectForKey:@"PaidPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
                
                tmpArr=[dataDict objectForKey:@"LivePrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                
                tmpArr=[dataDict objectForKey:@"MemberPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
                
                tmpArr=[dataDict objectForKey:@"MasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
                
                tmpArr=[dataDict objectForKey:@"PaidMasterclassPrograms"];
                tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
                [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
                
            }
        }
        
        if (![Utility isEmptyCheck:selectedTagArray] && selectedTagArray.count>0){
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"ANY %K IN %@",@"Tags",selectedTagArray];
            
            tmpArr=[dataDict objectForKey:@"Programs"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"Programs"];
            
            tmpArr=[dataDict objectForKey:@"PaidPrograms"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
            
            tmpArr=[dataDict objectForKey:@"LivePrograms"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"LivePrograms"];
            
            tmpArr=[dataDict objectForKey:@"MemberPrograms"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
            
            tmpArr=[dataDict objectForKey:@"MasterclassPrograms"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
            
            tmpArr=[dataDict objectForKey:@"PaidMasterclassPrograms"];
            tmpArr=[tmpArr filteredArrayUsingPredicate:predicate];
            [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
            
        }
        
        [courseListTable reloadData];
    }
    [podcastTable reloadData];
}

- (IBAction)clearButtonPressed:(UIButton *)sender {
    showAllFilterButton.selected=true;
    for (UIButton *btn in programTypeFilterButtons) {
        btn.selected=false;
    }
    masterclassFilterButton.selected=false;
    for (UIButton *btn in statusFilterButtons) {
        btn.selected=false;
    }
    [selectedTagArray removeAllObjects];
    [tagFilterTable reloadData];
    [self showResultButtonPressed:0];
}


- (IBAction)walkThroughCrossButtonPressed:(UIButton *)sender {
    walkThroughView.hidden=true;
}


- (IBAction)courseStartDayButtonPressed:(UIButton *)sender {
    courseStartAlertView.hidden=true;
    if (sender.tag==0) {
        [self addCourseApiCall:courseActionDict forDate:[NSDate date]];
    }else if (sender.tag==1){
        [self addCourseApiCall:courseActionDict forDate:[Utility nextMondayDate]];
    }
}


- (IBAction)courseNameButtonPressed:(UIButton *)sender {
    CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
    controller.courseData = [courseList objectAtIndex:sender.tag];
    if ([[[courseList objectAtIndex:sender.tag]objectForKey:@"CourseName"]isEqualToString:@"8 Week Challenge"]) {
        controller.isFromMenu = YES;
    }else{
        controller.isFromMenu = NO;
    }
    controller.courseDetailsDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)courseActionButtonPressed:(UIButton *)sender {
    if ([sender.accessibilityHint isEqualToString:@"0"]) {
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
        }else{
            selectedArray=[dataDict objectForKey:@"Programs"];
            courseActionDict=[selectedArray objectAtIndex:sender.tag];
            if (![Utility isEmptyCheck:[courseActionDict objectForKey:@"Status"]]) {
                int status=[[courseActionDict objectForKey:@"Status"] intValue];
                if (status==1) {
                    CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
                    controller.courseData = courseActionDict;
                    controller.courseDetailsDelegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                    return;
                }
            }
            
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }
    }else if ([sender.accessibilityHint isEqualToString:@"1"]){
        if ([Utility isOnlyProgramMember]) {
            selectedArray=[dataDict objectForKey:@"MemberPrograms"];
            courseActionDict=[selectedArray objectAtIndex:sender.tag];
//            [Utility showNonSubscribedAlert:self sectionName:@"Course"];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
            return;
        }
        if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
            [Utility showTrailLoginAlert:self ofType:self];
        }else{
            selectedArray=[dataDict objectForKey:@"MemberPrograms"];
            courseActionDict=[selectedArray objectAtIndex:sender.tag];
            if (![Utility isEmptyCheck:[courseActionDict objectForKey:@"Status"]]) {
                int status=[[courseActionDict objectForKey:@"Status"] intValue];
                if (status==1) {
                    CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
                    controller.courseData = courseActionDict;
                    controller.courseDetailsDelegate = self;
                    [self.navigationController pushViewController:controller animated:YES];
                    return;
                }
            }
            
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }
    }else if ([sender.accessibilityHint isEqualToString:@"2"]){
        selectedArray=[dataDict objectForKey:@"LivePrograms"];
        courseActionDict=[selectedArray objectAtIndex:sender.tag];
        CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
        controller.courseData=courseActionDict;
        controller.originVC=self;
        [self.navigationController pushViewController:controller animated:NO];
    }else if ([sender.accessibilityHint isEqualToString:@"3"]){
        selectedArray=[dataDict objectForKey:@"PaidPrograms"];
        courseActionDict=[selectedArray objectAtIndex:sender.tag];
        CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
        controller.courseData=courseActionDict;
        controller.originVC=self;
        [self.navigationController pushViewController:controller animated:NO];
    }else if ([sender.accessibilityHint isEqualToString:@"4"]){
        selectedArray=[dataDict objectForKey:@"MasterclassPrograms"];
        courseActionDict=[selectedArray objectAtIndex:sender.tag];
        CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
        controller.courseData=courseActionDict;
        controller.originVC=self;
        [self.navigationController pushViewController:controller animated:NO];
    }else if ([sender.accessibilityHint isEqualToString:@"5"]){
        selectedArray=[dataDict objectForKey:@"PaidMasterclassPrograms"];
        courseActionDict=[selectedArray objectAtIndex:sender.tag];
        CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
        controller.courseData=courseActionDict;
        controller.originVC=self;
        [self.navigationController pushViewController:controller animated:NO];
    }else if ([sender.accessibilityHint isEqualToString:@"Podcast"]){
        NSString *redirectUrl = @"https://anchor.fm/mindbodyhq";
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }
}





- (IBAction)viewDetails:(UIButton *)sender {
    CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
    controller.courseData = [userCourseList objectAtIndex:sender.tag];
    controller.courseDetailsDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)courseInfoPressed:(UIButton *)sender type:(NSString *)type
{
    if ([type isEqualToString:@"Program"]) {
        if (![Utility isEmptyCheck:[selectedArray objectAtIndex:sender.tag]]) {
            NSDictionary *dict = [selectedArray objectAtIndex:sender.tag];
            if (![Utility isEmptyCheck:[dict objectForKey:@"CourseInfo"]]) {
                NSString *msg= [dict objectForKey:@"CourseInfo"];
                NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                          documentAttributes:nil error:nil];
                
                descriptionText.textContainer.lineFragmentPadding = 0;
                descriptionText.textContainerInset = UIEdgeInsetsZero;
                descriptionText.attributedText =strAttributed;
                
                CGSize sizeThatShouldFitTheContent = [descriptionText sizeThatFits:descriptionText.frame.size];
                descriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
                [self.view setNeedsUpdateConstraints];
                
                descriptionView.hidden = false;
                nodataLabel.hidden = true;
            }else{
                descriptionText.attributedText = [[NSAttributedString alloc]initWithString:@""];
                descriptionView.hidden = false;
                nodataLabel.hidden= false;
            }
        }
    }
    else if ([type isEqualToString:@"Meditation"]){
        if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]) {
            if ([[defaults objectForKey:@"RunningVideoSection"] isEqualToString:@"Meditation"]) {
                if (![Utility isEmptyCheck:[defaults objectForKey:@"PlayingMeditation"]]) {
                    NSString *webinarstr=[defaults objectForKey:@"PlayingMeditation"];
                    NSData *data = [webinarstr dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                    controller.webinar = [dict mutableCopy];
                    [self.navigationController pushViewController:controller animated:NO];
                }
            }
        }else{
            NSArray *controllers = self.navigationController.viewControllers;
            for(UIViewController *controller in controllers){
                if([controller isKindOfClass:[WebinarListViewController class]]){
                    WebinarListViewController *webinar = (WebinarListViewController *)controller;
                    if (sender.tag == 0){
                        webinar.isLoadTagBreath = false;
                    }else if (sender.tag == 1){
                        webinar.isLoadTagMorning = false;
                    }else{
                        webinar.isLoadTagPower = false;
                    }
                    webinar.isFromCourse=true;
                    [self.navigationController popToViewController:controller animated:NO];
                    break;
                }
            }
            
            WebinarListViewController *webinar = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
            if (sender.tag == 0){
                webinar.isLoadTagBreath = false;
            }else if (sender.tag == 1){
                webinar.isLoadTagMorning = false;
            }else{
                webinar.isLoadTagPower = false;
            }
            webinar.isFromCourse=true;
            [self.navigationController pushViewController:webinar animated:NO];
        }
    }
    
}

- (IBAction)closeView:(UIButton *)sender{
    viewFilter.hidden = YES;
}

-(IBAction)crossButtonPressed:(id)sender{
    descriptionView.hidden = true;
    courseStartAlertView.hidden=true;
}
- (IBAction)memberTypeExpandBtnPresed:(UIButton *)sender
{
    memberTypeExpandBtn.selected = !memberTypeExpandBtn.isSelected;
    [memberTypeExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
    
    if(memberTypeExpandBtn.isSelected){
        [memberTypeExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewMemberTypeOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [memberTypeExpandBtn setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewMemberTypeOutletCollection) {
            btn.hidden = true;
        }
    }
}


-(IBAction)membersOnlyOutletCollectionPressed:(UIButton *)sender {
    //MArk: ShowAll Button selected
    for (UIButton *btn in memberTypeOutletCollection) {
        if (sender==btn)
        {
            //[self clearSelectedDate];
            btn.selected = true;
            // SelectedFilterbtn = btn;
            
        }else{
            btn.selected = false;
            
        }
    }
}


- (IBAction)activeExpandBtnPressed:(UIButton *)sender
{
    activeExpandBtn.selected = !activeExpandBtn.isSelected;

    [activeExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];

    if(activeExpandBtn.isSelected){
        [activeExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewActiveTypeOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [activeExpandBtn setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewActiveTypeOutletCollection) {
            btn.hidden = true;
        }
    }
}

-(IBAction)activeOutletCollectionPressed:(UIButton *)sender {
    //MArk: ShowAll Button selected
    for (UIButton *btn in activeTypeOutletCollection) {
        if (sender==btn)
        {
            //[self clearSelectedDate];
            btn.selected = true;
            // SelectedFilterbtn = btn;
            
        }else{
            btn.selected = false;
            
        }
    }
}

- (IBAction)dateOutletCollectionPressed:(UIButton *)sender
{
    for (UIButton *btn in dateOutletCollection) {
        if (sender==btn)
        {
            [self clearSelectedDate];
            btn.selected = true;
            
        }else{
            btn.selected = false;
            
        }
    }
}


- (IBAction)presenterExpandBtnPressed:(UIButton *)sender
{
    presenterExpandBtn.selected = !presenterExpandBtn.isSelected;
    
    [presenterExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
    
    if(presenterExpandBtn.isSelected){
        [presenterExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewPresenterOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [presenterExpandBtn setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewPresenterOutletCollection) {
            btn.hidden = true;
        }
    }
}
- (IBAction)presenterOutletCollectionPressed:(UIButton *)sender
{
    for (UIButton *btn in presenterOutletCollection) {
        if (sender==btn)
        {
            //[self clearSelectedDate];
            btn.selected = true;
            // SelectedFilterbtn = btn;
            
        }else{
            btn.selected = false;
            
        }
    }
}

- (IBAction)authorExpandBtnPressed:(UIButton *)sender
{
    authorExpandBtn.selected = !authorExpandBtn.isSelected;
    
    [authorExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
    
    if(authorExpandBtn.isSelected){
        [authorExpandBtn setImage:[UIImage imageNamed:@"up_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewAuthorOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [authorExpandBtn setImage:[UIImage imageNamed:@"down_arrow_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewAuthorOutletCollection) {
            btn.hidden = true;
        }
    }
}

//- (IBAction)authorOutletCollectionPressed:(UIButton *)sender
//{
//    for (UIButton *btn in authorOutletCollection) {
//        if (sender==btn)
//        {
//            //[self clearSelectedDate];
//            btn.selected = true;
//            // SelectedFilterbtn = btn;
//
//        }else{
//            btn.selected = false;
//
//        }
//    }
//}
- (IBAction)courseAuthorBtnPressed:(UIButton *)sender
{
    
    editRow = (int)sender.tag;
    CourseAuthorListCell *aCell;
    @try {
        NSIndexPath *mIndex = [NSIndexPath indexPathForRow:editRow inSection:0];
        aCell = (CourseAuthorListCell *)[authorListTable cellForRowAtIndexPath:mIndex];
    } @catch (NSException *exception) {
        
    }
    if (!aCell) {
        aCell = [[CourseAuthorListCell alloc]init];
    }
    
    
    aCell.courseAuthorExpandBtn.selected = !aCell.courseAuthorExpandBtn.isSelected;
    
    [aCell.courseAuthorExpandBtn setImage:[UIImage imageNamed:@"unchecked_New.png"] forState:UIControlStateNormal];
    
    if(aCell.courseAuthorExpandBtn.isSelected){
        [activeExpandBtn setImage:[UIImage imageNamed:@"unchecked_New.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewDateOutletCollection) {
            btn.hidden = false;
        }
    }else{
        [aCell.courseAuthorExpandBtn setImage:[UIImage imageNamed:@"checked_mbHQ.png"] forState:UIControlStateNormal];
        for (UIButton *btn in viewDateOutletCollection) {
            btn.hidden = true;
        }
    }
   
    
}
   

- (IBAction)selectDateButtonPressed:(UIButton *)sender
{
    DatePickerViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePicker"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    if (![Utility isEmptyCheck:selectedDate]) {
        controller.selectedDate = selectedDate;
    }
    controller.datePickerMode = UIDatePickerModeDate;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}



-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
    if (!filterView.isHidden) {
        filterView.hidden=true;
    }
}

- (IBAction)filterButtonPressed:(UIButton *)sender {
//    viewFilter.hidden = NO;
    descriptionView.hidden = true;
    filterView.hidden = false;
}


- (IBAction)filterCrossPressed:(id)sender {
    descriptionView.hidden = true;
    filterView.hidden = true;
}

//chayan - changes
- (IBAction)filterAction:(UIButton *)sender{
    NSArray *tmpArr;
    if (sender.tag == 1) {//ALL
        allTickButton.hidden = false;
        activeTickButton.hidden = true;
        availabelTickButton.hidden = true;
        completeButton.hidden = true;
        
        isShowAllProgram=YES;
        tmpArr=programArray;
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        isShowAllMemberProgram=YES;
        tmpArr=MemberProgramArray;
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        isShowAllLiveProgram=YES;
        tmpArr=liveProgramArray;
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
        
        isShowAllPaidProgram=YES;
        tmpArr=paidProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
    }else if (sender.tag == 2){//Active
        
        isShowAllProgram=YES;
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(IsEnroll == 1) AND (isAllArticleRead == 0)"];
        //for status active
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 1"];
        tmpArr=[programArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        tmpArr=[MemberProgramArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        allTickButton.hidden = true;
        activeTickButton.hidden = false;
        availabelTickButton.hidden = true;
        completeButton.hidden = true;
        
    }else if (sender.tag == 3){//Inactive
        isShowAllProgram=YES;
        //for status paused
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 2"];
        tmpArr=[programArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        tmpArr=[MemberProgramArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        allTickButton.hidden = true;
        activeTickButton.hidden = true;
        availabelTickButton.hidden = false;
        completeButton.hidden = true;
    }else{
        isShowAllProgram=YES;
        
        //for status completed
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Status == 3"];
        tmpArr=[programArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        tmpArr=[MemberProgramArray filteredArrayUsingPredicate:predicate];
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        allTickButton.hidden = true;
        activeTickButton.hidden = true;
        availabelTickButton.hidden = true;
        completeButton.hidden = false;
    }
    filterView.hidden = true;
    searchTextField.text = @"";
    
//    if (![Utility isEmptyCheck:[dataDict objectForKey:@"Programs"]] || ![Utility isEmptyCheck:[dataDict objectForKey:@"Meditations"]] ) {
//        noDataLabelForTable.hidden = true;
//    }else{
//        noDataLabelForTable.hidden = true;
//    }
    
    
    [courseListTable reloadData];
    
}

- (IBAction)seeAllBtnTapped:(UIButton *)sender{
//    if (sender.tag==0) {
//        isShowAllProgram=!isShowAllProgram;
//
//        [dataDict removeObjectForKey:@"Programs"];
//        [dataDict setObject:programArray forKey:@"Programs"];
//        [self loadCourseList];
//    }
}

#pragma mark - End



#pragma mark - Private Function

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    courseListTableHeightConstraint.constant=courseListTable.contentSize.height;
    podcastTableHeightConstraint.constant=podcastTable.contentSize.height;
    tagFilterTableHeightConstraint.constant=tagFilterTable.contentSize.height;
}

- (void)refreshTable {
    [refreshControl endRefreshing];
    [self getCourseListApiCall];
}


-(void) setCourseListData:(NSArray *)rawListProgram{
    [programArray removeAllObjects];
    [MemberProgramArray removeAllObjects];
    [liveProgramArray removeAllObjects];
    [paidProgramArray removeAllObjects];
    [masterClassProgramArray removeAllObjects];
    [paidMasterClassProgramArray removeAllObjects];
    [tagArray removeAllObjects];
    
    
    //set tag array
    
    NSMutableArray *tempTagArray=[[NSMutableArray alloc] init];
    if (![Utility isEmptyCheck:rawListProgram] && rawListProgram.count>0) {
        for (NSDictionary *dict in rawListProgram) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"Tags"]]) {
                NSArray *tmp=[dict objectForKey:@"Tags"];
                [tempTagArray addObjectsFromArray:tmp];
            }
        }
    }
    
    if (![Utility isEmptyCheck:tempTagArray]) {
        tagArray = [[[NSOrderedSet orderedSetWithArray:tempTagArray] array] mutableCopy];
        tagArray = [[tagArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] mutableCopy];
    }
    
    [tagFilterTable reloadData];
    
    
    //commented to implement live,paid,member program. also status key is there to determine in progress, start, paused.
    /*
    NSPredicate *programPredicate = [NSPredicate predicateWithFormat:@"CourseType = %@",@"Program"];
    NSArray *programArrayTemp = [rawListProgram filteredArrayUsingPredicate:programPredicate];
    NSPredicate *inProgressPredicate = [NSPredicate predicateWithFormat:@"(IsEnroll == %@ AND isAllArticleRead == %@)",@1,@0];
    NSArray *inProgressArticle = [programArrayTemp filteredArrayUsingPredicate:inProgressPredicate];
    NSPredicate *otherThanInprogressPredicate = [NSPredicate predicateWithFormat:@"(IsEnroll == %@) OR (IsEnroll == %@ AND isAllArticleRead == %@)",@0,@1,@1];
    NSArray *otherThanInprogressArticle = [programArrayTemp filteredArrayUsingPredicate:otherThanInprogressPredicate];
     */
    
    
    NSPredicate *masterclassPredicate = [NSPredicate predicateWithFormat:@"CourseType == %@",@"Masterclass"];
    NSArray *masterclassArr=[rawListProgram filteredArrayUsingPredicate:masterclassPredicate];
    
    NSPredicate *paidMasterClassPredicate=[NSPredicate predicateWithFormat:@"(SubscriptionType == %@) AND (HasSubscribed == %@)",@2,[NSNumber numberWithBool:NO]];
    NSArray *paidMasterClassArr=[masterclassArr filteredArrayUsingPredicate:paidMasterClassPredicate];
    
    NSPredicate *nonpaidMasterClassPredicate=[NSPredicate predicateWithFormat:@"(SubscriptionType == %@) OR (SubscriptionType == %@) OR ((SubscriptionType == %@) AND (HasSubscribed == %@)) ",@0,@1,@2,[NSNumber numberWithBool:YES]];
    NSArray *nonpaidMasterClassArr=[masterclassArr filteredArrayUsingPredicate:nonpaidMasterClassPredicate];
    
    [masterClassProgramArray addObjectsFromArray:nonpaidMasterClassArr];
    [paidMasterClassProgramArray addObjectsFromArray:paidMasterClassArr];
    
    
    
    NSPredicate *programPredicate = [NSPredicate predicateWithFormat:@"CourseType == %@",@"Program"];
    NSArray *onlyProgramArray=[rawListProgram filteredArrayUsingPredicate:programPredicate];
    
    NSPredicate *nonLivePredicate = [NSPredicate predicateWithFormat:@"IsLiveCourse == %@",[NSNumber numberWithBool:NO]];
    NSArray *nonLiveArray = [onlyProgramArray filteredArrayUsingPredicate:nonLivePredicate];
    
    NSPredicate *livePredicate = [NSPredicate predicateWithFormat:@"IsLiveCourse == %@",[NSNumber numberWithBool:YES]];
    NSArray *liveArray = [onlyProgramArray filteredArrayUsingPredicate:livePredicate];
    
    NSPredicate *memberPredicate=[NSPredicate predicateWithFormat:@"(SubscriptionType == %@) OR (SubscriptionType == %@)",@0,@1];
    NSArray *memberArr=[nonLiveArray filteredArrayUsingPredicate:memberPredicate];
    if ([Utility isOnlyProgramMember]) {
        [MemberProgramArray addObjectsFromArray:memberArr];
    }else{
        [programArray addObjectsFromArray:memberArr];
    }
    
    
    NSPredicate *subscribedPredicateLive=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:YES]];
    NSArray *subscribedArrLive=[liveArray filteredArrayUsingPredicate:subscribedPredicateLive];
    [programArray addObjectsFromArray:subscribedArrLive];
    
    NSPredicate *nonSubscribedPredicateLive=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:NO]];
    NSArray *nonSubscribedArrLive=[liveArray filteredArrayUsingPredicate:nonSubscribedPredicateLive];
    [liveProgramArray addObjectsFromArray:nonSubscribedArrLive];
    
    
    
    
    NSPredicate *paidPredicate=[NSPredicate predicateWithFormat:@"SubscriptionType == %@",@2];
    NSArray *paidArr=[nonLiveArray filteredArrayUsingPredicate:paidPredicate];
    
    NSPredicate *subscribedPredicate=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:YES]];
    NSArray *subscribedPaidArr=[paidArr filteredArrayUsingPredicate:subscribedPredicate];
    [programArray addObjectsFromArray:subscribedPaidArr];
    
    
    NSPredicate *nonSubscribedPredicate=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:NO]];
    NSArray *nonSubscribedPaidArr=[paidArr filteredArrayUsingPredicate:nonSubscribedPredicate];
    [paidProgramArray addObjectsFromArray:nonSubscribedPaidArr];
    
    
    NSMutableArray *courseNameArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dict in programArray) {
        if (![Utility isEmptyCheck:dict[@"CourseName"]]) {
            [courseNameArr addObject:dict[@"CourseName"]];
        }
    }
    if (![Utility isEmptyCheck:courseNameArr] && courseNameArr.count>0) {
        [defaults setObject:courseNameArr forKey:@"CourseNameArray"];
    }
    
    [self clearButtonPressed:0];
    
    //SubscriptionType
//        UIButton *btn = [[UIButton alloc]init];
//        btn.tag = 1;
//        [self filterAction:btn];
    
    
    if (moveAfterPurchase) {
        moveAfterPurchase=false;
        NSPredicate *p = [NSPredicate predicateWithFormat:@"CourseId == %d",[[defaults objectForKey:@"CourseId"] intValue]];
        NSArray *tmp = [rawListProgram filteredArrayUsingPredicate:p];
        if (![Utility isEmptyCheck:tmp] && tmp.count>0) {
            courseActionDict=[tmp objectAtIndex:0];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }
        return;
    }
    
    [self loadCourseList];
}




-(void)loadCourseList{
    //SetProgram_In
    if (fromSetProgram) {
        fromSetProgram = false;
        if (![Utility isEmptyCheck:courseList]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(CourseName == %@)",courseName];
            NSArray *filteredCourseArray = [courseList filteredArrayUsingPredicate:predicate];
            CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
            controller.courseData = [filteredCourseArray objectAtIndex:0];
            controller.courseDetailsDelegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }//SetProgram_In
    
    [self->courseListTable reloadData];
    
}

-(BOOL)isAnyFilterSelected{
    BOOL isselected=false;
    for (UIButton *btn in programTypeFilterButtons) {
        if (btn.isSelected) {
            return true;
        }
    }
    
    if (masterclassFilterButton.isSelected) {
        return true;
    }
    
    for (UIButton *btn in statusFilterButtons) {
        if (btn.isSelected) {
            return true;
        }
    }
    
    if (![Utility isEmptyCheck:selectedTagArray]) {
        return true;
    }
    
    
    return isselected;
}

#pragma mark - End





#pragma mark - api call
-(void)getCourseListApiCall
{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCourseListApiCall" append:@"" forAction:@"POST"];
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
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                        self->rawList_Program = [responseDictionary objectForKey:@"Courses"];
                                                                        
                                                                        [self setCourseListData:self->rawList_Program];
                                                                         
                                                                         
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}


-(void)addCourseApiCall:(NSDictionary *)dict forDate:(NSDate *)startDate{
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
        NSMutableDictionary *courseDict = [[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSDate *date = startDate;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        [courseDict setObject:[dateFormat stringFromDate:date] forKey:@"CourseStartDate"];
        [mainDict setObject:courseDict forKey:@"CourseList"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddCourseApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 [self->contentView removeFromSuperview];
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
                                                                         NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                                                         [mdict setObject:[responseDictionary objectForKey:@"NewData"] forKey:@"UserSquadCourseId"];
                                                                         controller.courseDetailsDelegate = self;
                                                                         controller.courseData = mdict;
                                                                         controller.isfirstTime = true;
                                                                         
                                                                         [self.navigationController pushViewController:controller animated:YES];
                                                                     }
                                                                     else{
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}
//Ru
#pragma mark - End




#pragma  mark -DatePickerViewControllerDelegate
-(void)didSelectDate:(NSDate *)date{
    NSLog(@"%@",date);
    if (date) {
        SelectedFilterbtn = nil;
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        selectedDate = date;
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];// MMM d yyyy
        NSString *dateString = [dateFormatter stringFromDate:date];
        // [dateLabel setText:[NSString stringWithFormat:@"Date: %@",dateString]];
        //[selectDateButton setText:[NSString stringWithFormat:@"Date: %@",dateString]];
        [selectDateButton setTitle:dateString forState:UIControlStateNormal];
        
        [self dateOutletCollectionPressed:nil];
    }
}

-(void)clearSelectedDate{
    selectedDate = nil;
    [selectDateButton setTitle:@"SELECT DATE" forState:UIControlStateNormal];
}


#pragma mark - End -


#pragma mark -TableView Datasource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == courseListTable) {
        return 6;
    }
    else{
       return 1;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == courseListTable){
        if (section==0) {
            NSArray *arr =[dataDict objectForKey:@"Programs"];
            return arr.count;
        }
        if (section==1) {
            NSArray *arr =[dataDict objectForKey:@"MemberPrograms"];
            return arr.count;
        }
        if (section==2) {
            NSArray *arr =[dataDict objectForKey:@"LivePrograms"];
            return arr.count;
        }
        if (section==3) {
            NSArray *arr =[dataDict objectForKey:@"PaidPrograms"];
            return arr.count;
        }
        if (section==4) {
            NSArray *arr =[dataDict objectForKey:@"MasterclassPrograms"];
            return arr.count;
        }
        if (section==5) {
            NSArray *arr =[dataDict objectForKey:@"PaidMasterclassPrograms"];
            return arr.count;
        }
//       return courseList.count;
       return 10;
    }else if (tableView==podcastTable){
        return 1;
    }else if (tableView==tagFilterTable){
        return tagArray.count;
    }else{
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tablecell;
    if (tableView == courseListTable)
    {
            NSString *CellIdentifier =@"CourseListTableViewCell";
            
            CourseListTableViewCell *cell = (CourseListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            // Configure the cell...
            if (cell == nil) {
                cell = [[CourseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        
        NSDictionary *dict;
        if (indexPath.section==0) {
            dict = [[dataDict objectForKey:@"Programs"] objectAtIndex:indexPath.row];
            cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
            cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
            cell.courseModuleLabel.text = @"";
            cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
            cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
            
                        
            //Mark -Images Upload
            cell.courseListImage.clipsToBounds = YES;
//            cell.courseListImage.layer.cornerRadius = 15;
            if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];//ImageURL
                urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }
            else{
                cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
            cell.checkButton.hidden = YES;
            cell.courseActionButton.hidden = NO;
//            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
            cell.courseActionButton.clipsToBounds = YES;
//            cell.courseActionButton.layer.borderWidth = 1.2;
            cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
            [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //course action button according to status.
            if (![Utility isEmptyCheck:[dict objectForKey:@"Status"]]) {
                int status=[[dict objectForKey:@"Status"] intValue];
                if (status==1) {
                    [cell.courseActionButton setTitle:@"IN PROGRESS" forState:UIControlStateNormal];
                    cell.courseActionButton.backgroundColor = [UIColor whiteColor];
                }else if (status==2){
                    [cell.courseActionButton setTitle:@"PAUSED" forState:UIControlStateNormal];
                    [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                }else if (status==3){
                    [cell.courseActionButton setTitle:@"COMPLETED" forState:UIControlStateNormal];
                    [cell.courseActionButton setTitleColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                    [cell.courseActionButton setBackgroundColor:[UIColor lightGrayColor]];
                    cell.courseActionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                }else{
                    [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];//START
                    [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                }
            }
                        //Mark - Info Button
                        if (![Utility isEmptyCheck:[dict objectForKey:@"CourseInfo"]]) {
                            cell.courseInfoButton.hidden = YES;
                        } else {
                            cell.courseInfoButton.hidden = YES;
                        }
                        //Mark- Subscription Members
                        cell.courseLockButton.hidden = YES;
        }
        if (indexPath.section==1) {
            dict = [[dataDict objectForKey:@"MemberPrograms"] objectAtIndex:indexPath.row];
            cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
            cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
            cell.courseModuleLabel.text = @"";
            cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
            cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
                        
            //Mark -Images Upload
            cell.courseListImage.clipsToBounds = YES;
            cell.courseListImage.layer.cornerRadius = 15;
            if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];
                urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }
            else{
                cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
            cell.checkButton.hidden = YES;
            cell.courseActionButton.hidden = NO;
//            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
            cell.courseActionButton.clipsToBounds = YES;
//            cell.courseActionButton.layer.borderWidth = 1.2;
            cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
            [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            //course action button according to status.
            if ([Utility isOnlyProgramMember]){
                [cell.courseActionButton setTitle:@"JOIN" forState:UIControlStateNormal];
                [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
            }else{
                if (![Utility isEmptyCheck:[dict objectForKey:@"Status"]]) {
                    int status=[[dict objectForKey:@"Status"] intValue];
                    if (status==1) {
                        [cell.courseActionButton setTitle:@"IN PROGRESS" forState:UIControlStateNormal];
                        cell.courseActionButton.backgroundColor = [UIColor whiteColor];
                    }else if (status==2){
                        [cell.courseActionButton setTitle:@"PAUSED" forState:UIControlStateNormal];
                        [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                    }else if (status==3){
                        [cell.courseActionButton setTitle:@"COMPLETED" forState:UIControlStateNormal];
                        [cell.courseActionButton setTitleColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                        [cell.courseActionButton setBackgroundColor:[UIColor lightGrayColor]];
                        cell.courseActionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                    }else{
                        [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];//START
                        [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                    }
                }
            }
            
                        //Mark - Info Button
                        if (![Utility isEmptyCheck:[dict objectForKey:@"CourseInfo"]]) {
                            cell.courseInfoButton.hidden = YES;
                        } else {
                            cell.courseInfoButton.hidden = YES;
                        }
                        //Mark- Subscription Members
                        cell.courseLockButton.hidden = YES;
        }
        if (indexPath.section==2) {
            dict = [[dataDict objectForKey:@"LivePrograms"] objectAtIndex:indexPath.row];
            cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
            cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
            cell.courseModuleLabel.text = @"";
            cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
            cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
                        
            //Mark -Images Upload
            cell.courseListImage.clipsToBounds = YES;
            cell.courseListImage.layer.cornerRadius = 15;
            if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];
                urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }
            else{
                cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
            cell.courseLockButton.hidden = YES;
            cell.checkButton.hidden = YES;
            cell.courseActionButton.hidden = NO;
//            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
            cell.courseActionButton.clipsToBounds = YES;
//            cell.courseActionButton.layer.borderWidth = 1.2;
            cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
            [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];
            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
        }
        if (indexPath.section==3) {
            dict = [[dataDict objectForKey:@"PaidPrograms"] objectAtIndex:indexPath.row];
            cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
            cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
            cell.courseModuleLabel.text = @"";
            cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
            cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
                        
            //Mark -Images Upload
            cell.courseListImage.clipsToBounds = YES;
            cell.courseListImage.layer.cornerRadius = 15;
            if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];
                urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }
            else{
                cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
            cell.courseLockButton.hidden = YES;
            cell.checkButton.hidden = YES;
            cell.courseActionButton.hidden = NO;
//            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
            cell.courseActionButton.clipsToBounds = YES;
//            cell.courseActionButton.layer.borderWidth = 1.2;
            cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
            [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];
            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
        }
        
        if (indexPath.section==4) {
                    dict = [[dataDict objectForKey:@"MasterclassPrograms"] objectAtIndex:indexPath.row];
                    cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
                    cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
                    cell.courseModuleLabel.text = @"";
                    cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
                    cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
                    
                                
                    //Mark -Images Upload
                    cell.courseListImage.clipsToBounds = YES;
        //            cell.courseListImage.layer.cornerRadius = 15;
                    if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                        NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];//ImageURL
                        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                    }
                    else{
                        cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
                    }
                    cell.checkButton.hidden = YES;
                    cell.courseActionButton.hidden = NO;
        //            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
                    cell.courseActionButton.clipsToBounds = YES;
        //            cell.courseActionButton.layer.borderWidth = 1.2;
                    cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
                    [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    //course action button according to status.
                    if (![Utility isEmptyCheck:[dict objectForKey:@"Status"]]) {
                        int status=[[dict objectForKey:@"Status"] intValue];
                        if (status==1) {
                            [cell.courseActionButton setTitle:@"IN PROGRESS" forState:UIControlStateNormal];
                            cell.courseActionButton.backgroundColor = [UIColor whiteColor];
                        }else if (status==2){
                            [cell.courseActionButton setTitle:@"PAUSED" forState:UIControlStateNormal];
                            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                        }else if (status==3){
                            [cell.courseActionButton setTitle:@"COMPLETED" forState:UIControlStateNormal];
                            [cell.courseActionButton setTitleColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                            [cell.courseActionButton setBackgroundColor:[UIColor lightGrayColor]];
                            cell.courseActionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                        }else{
                            [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];//START
                            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                        }
                    }
                                //Mark - Info Button
                                if (![Utility isEmptyCheck:[dict objectForKey:@"CourseInfo"]]) {
                                    cell.courseInfoButton.hidden = YES;
                                } else {
                                    cell.courseInfoButton.hidden = YES;
                                }
                                //Mark- Subscription Members
                                cell.courseLockButton.hidden = YES;
                }
        if (indexPath.section==5) {
                    dict = [[dataDict objectForKey:@"PaidMasterclassPrograms"] objectAtIndex:indexPath.row];
                    cell.courseName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
                    cell.courseActionName.text = ![Utility isEmptyCheck:[dict objectForKey:@"CourseType"]] ? [dict objectForKey:@"CourseType"] : @"";
                    cell.courseModuleLabel.text = @"";
                    cell.courseModuleLabel.text = [NSString stringWithFormat:@"%@ module",![Utility isEmptyCheck:[dict objectForKey:@"NoOfModules"]] ? [dict objectForKey:@"NoOfModules"] : @""];
                    cell.courseModuleLabel.text = ![Utility isEmptyCheck:[dict objectForKey:@"AuthorName"]] ? [dict objectForKey:@"AuthorName"] : @"";
                    
                                
                    //Mark -Images Upload
                    cell.courseListImage.clipsToBounds = YES;
        //            cell.courseListImage.layer.cornerRadius = 15;
                    if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl2"]]){
                        NSString *urlString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ImageUrl2"]];//ImageURL
                        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                        [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
                    }
                    else{
                        cell.courseListImage.image = [UIImage imageNamed:@"place_holder1.png"];
                    }
                    cell.checkButton.hidden = YES;
                    cell.courseActionButton.hidden = NO;
        //            cell.courseActionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
                    cell.courseActionButton.clipsToBounds = YES;
        //            cell.courseActionButton.layer.borderWidth = 1.2;
                    cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
                    [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    
                    //course action button according to status.
                    if (![Utility isEmptyCheck:[dict objectForKey:@"Status"]]) {
                        int status=[[dict objectForKey:@"Status"] intValue];
                        if (status==1) {
                            [cell.courseActionButton setTitle:@"IN PROGRESS" forState:UIControlStateNormal];
                            cell.courseActionButton.backgroundColor = [UIColor whiteColor];
                        }else if (status==2){
                            [cell.courseActionButton setTitle:@"PAUSED" forState:UIControlStateNormal];
                            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                        }else if (status==3){
                            [cell.courseActionButton setTitle:@"COMPLETED" forState:UIControlStateNormal];
                            [cell.courseActionButton setTitleColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
                            [cell.courseActionButton setBackgroundColor:[UIColor lightGrayColor]];
                            cell.courseActionButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
                        }else{
                            [cell.courseActionButton setTitle:@"LEARN MORE" forState:UIControlStateNormal];//START
                            [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
                        }
                    }
                                //Mark - Info Button
                                if (![Utility isEmptyCheck:[dict objectForKey:@"CourseInfo"]]) {
                                    cell.courseInfoButton.hidden = YES;
                                } else {
                                    cell.courseInfoButton.hidden = YES;
                                }
                                //Mark- Subscription Members
                                cell.courseLockButton.hidden = YES;
                }
        
        
        


            
            cell.courseActionButton.tag = indexPath.row;
            cell.courseActionButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
            cell.courseInfoButton.tag = indexPath.row;
            cell.courseLockButton.tag = indexPath.row;
            cell.courseNameButton.tag = indexPath.row;
            cell.checkButton.tag = indexPath.row;
//            cell.courseModuleLabel.text=@"  ";
        
            cell.mainView.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
            cell.mainView.layer.borderWidth=1;
            cell.mainView.layer.cornerRadius=10;
            cell.mainView.clipsToBounds=YES;
            cell.mainView.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
        
//            cell.courseActionName.hidden=true;
            tablecell = cell;
    }else if (tableView==podcastTable){
        NSString *CellIdentifier =@"CoursePodcastTableViewCell";
        CoursePodcastTableViewCell *cell = (CoursePodcastTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CoursePodcastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.courseName.text = @"MindbodyHQ";
        cell.courseActionName.text = @"";
        cell.courseModuleLabel.text = @"";
        cell.courseModuleLabel.text = @"";
        cell.courseModuleLabel.text = @"Levi Walz";
        cell.courseListImage.clipsToBounds = YES;
        NSString *urlString = @"https://squad-live.s3-ap-southeast-2.amazonaws.com/mbHQ+images/MindbodyPODCAST+for+App.png";//ImageURL2
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [cell.courseListImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
        cell.courseActionButton.hidden = NO;
        cell.courseActionButton.clipsToBounds = YES;
        cell.courseActionButton.layer.cornerRadius = cell.courseActionButton.frame.size.height/2.0;
        [cell.courseActionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cell.courseActionButton setTitle:@"LISTEN NOW" forState:UIControlStateNormal];//START
        [cell.courseActionButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
        cell.courseLockButton.hidden = YES;
        
        cell.courseActionButton.tag = indexPath.row;
        cell.courseActionButton.accessibilityHint=@"Podcast";
                
        cell.mainView.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
        cell.mainView.layer.borderWidth=1;
        cell.mainView.layer.cornerRadius=10;
        cell.mainView.clipsToBounds=YES;
        cell.mainView.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
                
        //            cell.courseActionName.hidden=true;
        tablecell = cell;
    }else if (tableView==tagFilterTable){
        NSString *CellIdentifier =@"CourseListTagFilterTableViewCell";
        
        CourseListTagFilterTableViewCell *cell = (CourseListTagFilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[CourseListTagFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *tagName=[tagArray objectAtIndex:indexPath.row];
        [cell.checkUncheckButton setTitle:tagName forState:UIControlStateNormal];
        if (![Utility isEmptyCheck:selectedTagArray]) {
            if ([selectedTagArray containsObject:tagName]) {
                cell.checkUncheckButton.selected=true;
            }else{
                cell.checkUncheckButton.selected=false;
            }
        }else{
            cell.checkUncheckButton.selected=false;
        }
        
        cell.checkUncheckButton.tag=indexPath.row;
        tablecell=cell;
        
    }else{
        NSString *CellIdentifier =@"CourseAuthorListCell";
        CourseAuthorListCell *cell = (CourseAuthorListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[CourseAuthorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.courseAuthorExpandBtn.tag = indexPath.row;
        [cell.courseAuthorExpandBtn addTarget:self action:@selector(courseAuthorBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        tablecell = cell;
    }
    return tablecell;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension; //chayan changed
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return 85;
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label=[[UILabel alloc] init];
    label.backgroundColor=[UIColor whiteColor];
    
    if (tableView == courseListTable){
        UILabel *customLabel = [[UILabel alloc] init];
        customLabel.backgroundColor=[UIColor whiteColor];
//        customLabel.textColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
        customLabel.textColor = [UIColor blackColor];
        customLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17.0];
//        customLabel.textAlignment=NSTextAlignmentRight;
        if(section == 0){
            NSArray *tmpArr=[dataDict objectForKey:@"Programs"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    MY COURSES";
                label=customLabel;
            }
        }
        
        if(section == 1){
            NSArray *tmpArr=[dataDict objectForKey:@"MemberPrograms"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    MEMBERS ONLY COURSES";
                label=customLabel;
            }
        }
        
        if(section == 2){
            NSArray *tmpArr=[dataDict objectForKey:@"LivePrograms"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    LIVE COURSES";
                label=customLabel;
            }
        }
        
        if(section == 3){
            NSArray *tmpArr=[dataDict objectForKey:@"PaidPrograms"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    PAID COURSES";
                label=customLabel;
            }
        }
        
        if(section == 4){
            NSArray *tmpArr =[dataDict objectForKey:@"MasterclassPrograms"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    MASTERCLASS";
                label=customLabel;
            }
        }
        
        if(section == 5){
            NSArray *tmpArr =[dataDict objectForKey:@"PaidMasterclassPrograms"];
            if (![Utility isEmptyCheck:tmpArr] && tmpArr.count>0) {
                customLabel.text = @"    PAID MASTERCLASS";
                label=customLabel;
            }
        }
    }
    
    return label;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *btn =[[UIButton alloc] init];
    btn.backgroundColor=[UIColor whiteColor];
    
    if (tableView == courseListTable){
        
        UIButton *customButton = [[UIButton alloc] init];
        UILabel *label=[[UILabel alloc] init];
        label.backgroundColor=[UIColor whiteColor];
        
        customButton.backgroundColor=[UIColor whiteColor];
        [customButton setTitle:@"-- All --" forState:UIControlStateNormal];
        [customButton setTitleColor:[UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        customButton.titleLabel.font=[UIFont fontWithName:@"Raleway-Bold" size:17.0];
        [customButton addTarget:self action:@selector(seeAllBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [customButton setTag:section];
        
        UILabel *customLabel = [[UILabel alloc] init];
        customLabel.backgroundColor=[UIColor whiteColor];
        customLabel.textColor = [UIColor grayColor];
        customLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17.0];
        [customLabel setTextAlignment:NSTextAlignmentCenter];
        customLabel.text=@"No Data Found";
        
        if(section == 0){
            NSArray *tmp=[dataDict objectForKey:@"Programs"];
            if (tmp.count>0 && isShowAllProgram==NO) {
                btn=customButton;
                return btn;
            }else{
                UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                l.backgroundColor=[UIColor whiteColor];
                label=l;
                return label;
            }
        }
        
        if(section == 1){
            NSArray *tmp=[dataDict objectForKey:@"MemberPrograms"];
            if (tmp.count>0 && isShowAllMemberProgram==NO) {
                btn=customButton;
                return btn;
            }else{
                UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                l.backgroundColor=[UIColor whiteColor];
                label=l;
                return label;
            }
        }
        
        if(section == 2){
            NSArray *tmp=[dataDict objectForKey:@"LivePrograms"];
            if (tmp.count>0 && isShowAllLiveProgram==NO) {
                btn=customButton;
                return btn;
            }else{
                UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                l.backgroundColor=[UIColor whiteColor];
                label=l;
                return label;
            }
        }
        
        if(section == 3){
            NSArray *tmp=[dataDict objectForKey:@"PaidPrograms"];
            if (tmp.count>0 && isShowAllPaidProgram==NO) {
                btn=customButton;
                return btn;
            }else{
                UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
                l.backgroundColor=[UIColor whiteColor];
                label=l;
                return label;
            }
        }
    }
    return btn;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView==courseListTable) {
            if(section == 0){
                if ([Utility isEmptyCheck:programArray] && programArray.count==0) {
                    return 0;
                }
            }
            if(section == 1){
                if ([Utility isEmptyCheck:MemberProgramArray] && MemberProgramArray.count==0) {
                    return 0;
                }
            }
            if(section == 2){
                if ([Utility isEmptyCheck:liveProgramArray] && liveProgramArray.count==0) {
                    return 0;
                }
            }
            if(section == 3){
                if ([Utility isEmptyCheck:paidProgramArray] && paidProgramArray.count==0) {
                    return 0;
                }
            }
            if(section == 4){
                if ([Utility isEmptyCheck:masterClassProgramArray] && masterClassProgramArray.count==0) {
                    return 0;
                }
            }
            if(section == 5){
                if ([Utility isEmptyCheck:paidMasterClassProgramArray] && paidMasterClassProgramArray.count==0) {
                    return 0;
                }
            }
        
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==courseListTable) {
        if(section == 0){
            NSArray *tmp=[dataDict objectForKey:@"Programs"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
                return 30;
            }
        }
        if(section == 1){
            NSArray *tmp=[dataDict objectForKey:@"MemberPrograms"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
               return 30;
            }
        }
        if(section == 2){
            NSArray *tmp=[dataDict objectForKey:@"LivePrograms"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
                return 30;
            }
        }
        if(section == 3){
            NSArray *tmp=[dataDict objectForKey:@"PaidPrograms"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
                return 30;
            }
        }
        if(section == 4){
            NSArray *tmp=[dataDict objectForKey:@"MasterclassPrograms"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
                return 30;
            }
        }
        if(section == 5){
            NSArray *tmp=[dataDict objectForKey:@"PaidMasterclassPrograms"];
            if ([Utility isEmptyCheck:tmp] && tmp.count==0) {
                return 0;
            }else{
                return 30;
            }
        }
        return 30;
    }
    return 0;
}


//chayan 27/11/2019 --- also change the constraint of the course name stack in storyboard.
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger )section {
//    if(section == 0){
//        NSArray *tmp=[dataDict objectForKey:@"Programs"];
//        if (tmp.count>0) {
//            return UITableViewAutomaticDimension;
//        }
//    }else{
//        NSArray *tmp=[dataDict objectForKey:@"Meditations"];
//        if (tmp.count>0) {
//            return UITableViewAutomaticDimension;
//        }
//    }
//
//
//    return 1.0;
//}
//chayan 27/11/2019
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger )section {
//
//    if(section == 0){
//        NSArray *tmp=[dataDict objectForKey:@"Programs"];
//        if (tmp.count>0 && isShowAllProgram==NO) {
//            return UITableViewAutomaticDimension;
//        }
//    }else{
//        NSArray *tmp=[dataDict objectForKey:@"Meditations"];
//        if (tmp.count>0 && isShowAllMeditation==NO) {
//            return UITableViewAutomaticDimension;
//        }
//    }
//    return 1.0;
//}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == courseListTable){
        if (indexPath.section==0) {
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
                [Utility showTrailLoginAlert:self ofType:self];
            }else{
                selectedArray=[dataDict objectForKey:@"Programs"];
                courseActionDict=[selectedArray objectAtIndex:indexPath.row];
                CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
                controller.courseData=courseActionDict;
                controller.originVC=self;
                [self.navigationController pushViewController:controller animated:NO];
            }
        }else if (indexPath.section==1){
//            if ([Utility isOnlyProgramMember]) {
//                [Utility showNonSubscribedAlert:self sectionName:@"Course"];
//                return;
//            }
            if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]) {
                [Utility showTrailLoginAlert:self ofType:self];
            }else{
                selectedArray=[dataDict objectForKey:@"MemberPrograms"];
                courseActionDict=[selectedArray objectAtIndex:indexPath.row];
                CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
                controller.courseData=courseActionDict;
                controller.originVC=self;
                [self.navigationController pushViewController:controller animated:NO];
            }
        }else if (indexPath.section==2){
            selectedArray=[dataDict objectForKey:@"LivePrograms"];
            courseActionDict=[selectedArray objectAtIndex:indexPath.row];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }else if (indexPath.section==3){
            selectedArray=[dataDict objectForKey:@"PaidPrograms"];
            courseActionDict=[selectedArray objectAtIndex:indexPath.row];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }else if (indexPath.section==4){
            selectedArray=[dataDict objectForKey:@"MasterclassPrograms"];
            courseActionDict=[selectedArray objectAtIndex:indexPath.row];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }else if (indexPath.section==5){
            selectedArray=[dataDict objectForKey:@"PaidMasterclassPrograms"];
            courseActionDict=[selectedArray objectAtIndex:indexPath.row];
            CourseDetailsEntryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetailsEntry"];
            controller.courseData=courseActionDict;
            controller.originVC=self;
            [self.navigationController pushViewController:controller animated:NO];
        }
        
        
        
        /*
        NSString *type;
        if (indexPath.section==0) {
            selectedArray=[dataDict objectForKey:@"Programs"];
            type=@"Program";
        }
        if (indexPath.section==1) {
            //selectedArray=[dataDict objectForKey:@"Meditations"];
            type=@"Meditation";
        }
    UIButton *button = [[UIButton alloc]init];
    button.tag = indexPath.row;
    [self courseInfoPressed:button type:type];
         */
    }else if (tableView==podcastTable){
        NSString *redirectUrl = @"https://anchor.fm/mindbodyhq";
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
        
    }else if (tableView==tagFilterTable){
        CourseListTagFilterTableViewCell *cell = (CourseListTagFilterTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        UIButton *sender=cell.checkUncheckButton;
        if (sender.isSelected) {
            sender.selected=false;
            if (![Utility isEmptyCheck:tagArray]) {
                NSString *tagData = [tagArray objectAtIndex:sender.tag];
                if (![Utility isEmptyCheck:selectedTagArray]) {
                    if ([selectedTagArray containsObject:tagData]) {
                        [selectedTagArray removeObject:tagData];
                    }
                }
            }
        }else{
           sender.selected=true;
            if (![Utility isEmptyCheck:tagArray]) {
                NSString *tagData = [tagArray objectAtIndex:sender.tag];
                [selectedTagArray addObject:tagData];
            }
        }
        if (![self isAnyFilterSelected]) {
            [self showAllFilterButtonPressed:0];
        }else{
            showAllFilterButton.selected=false;
        }
    }
}

#pragma End



#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{
    
    NSLog(@"search for %@", textField.text);
    NSArray *tmpArr;
    if(textField.text.length>0){
        isShowAllProgram=YES;
        tmpArr=[programArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        tmpArr=[MemberProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        tmpArr=[liveProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
        
        tmpArr=[paidProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
        tmpArr=[masterClassProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        
        tmpArr=[paidMasterClassProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
            
    }else{
//        if (programArray.count>3) {
//            tmpArr = [programArray subarrayWithRange:NSMakeRange(0, 3)];
//            isShowAllProgram=NO;
//        }
//        else{
//            tmpArr=programArray;
//            isShowAllProgram=YES;
//        }
        isShowAllProgram=YES;
        tmpArr=programArray;
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        isShowAllMemberProgram=YES;
        tmpArr=MemberProgramArray;
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        
        isShowAllLiveProgram=YES;
        tmpArr=liveProgramArray;
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                
        isShowAllPaidProgram=YES;
        tmpArr=paidProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
        tmpArr=masterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        
        tmpArr=paidMasterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
    }
    
    
//    if (![Utility isEmptyCheck:[dataDict objectForKey:@"Programs"]] ) {
//        noDataLabelForTable.hidden = true;
//    }else{
//        noDataLabelForTable.hidden = true;
//    }
    [courseListTable reloadData];
    
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
        isShowAllProgram=YES;
        tmpArr=[programArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        tmpArr=[MemberProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        tmpArr=[liveProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
        
        tmpArr=[paidProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
        tmpArr=[masterClassProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        
        tmpArr=[paidMasterClassProgramArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CourseName CONTAINS[c] %@)", textField.text]];
        [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
    }else{
//        if (programArray.count>3) {
//            tmpArr = [programArray subarrayWithRange:NSMakeRange(0, 3)];
//            isShowAllProgram=NO;
//        }
//        else{
//            tmpArr=programArray;
//            isShowAllProgram=YES;
//        }
        isShowAllProgram=YES;
        tmpArr=programArray;
        [dataDict setObject:tmpArr forKey:@"Programs"];
        
        isShowAllMemberProgram=YES;
        tmpArr=MemberProgramArray;
        [dataDict setObject:tmpArr forKey:@"MemberPrograms"];
        
        isShowAllLiveProgram=YES;
        tmpArr=liveProgramArray;
        [dataDict setObject:tmpArr forKey:@"LivePrograms"];
                
        isShowAllPaidProgram=YES;
        tmpArr=paidProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidPrograms"];
        
        tmpArr=masterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"MasterclassPrograms"];
        
        tmpArr=paidMasterClassProgramArray;
        [dataDict setObject:tmpArr forKey:@"PaidMasterclassPrograms"];
    }
    
    
//    if (![Utility isEmptyCheck:[dataDict objectForKey:@"Programs"]]) {
//        noDataLabelForTable.hidden = true;
//    }else{
//        noDataLabelForTable.hidden = true;
//    }
    [courseListTable reloadData];
    [textField resignFirstResponder];
}
#pragma mark - End

#pragma mark - CourseDetails Delegate

-(void)didCheckAnyChangeForCourseList:(BOOL)isreload{
    isLoadController = isreload;
}
  #pragma mark - End


#pragma mark - Gesture recognizer delegate
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:courseListTable];
    NSIndexPath *indexPath = [courseListTable indexPathForRowAtPoint:p];
    if (indexPath != nil) {
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
            NSDictionary *dict = [[dataDict objectForKey:@"Programs"] objectAtIndex:indexPath.row];
            [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[dict objectForKey:@"CourseName"]] ? [dict objectForKey:@"CourseName"] : @"";
            [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
        }
    }
}
#pragma mark - End


@end
