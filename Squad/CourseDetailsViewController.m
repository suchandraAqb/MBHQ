//
//  CourseDetailsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 23/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CourseDetailsViewController.h"
#import "AchieveListHeaderView.h"
#import "CourseDetailsTableViewCell.h"
#import "YLProgressBar.h"
#import "HelpVideoPlayerViewController.h"
#import "CourseNotificationControlViewController.h"

@interface CourseDetailsViewController (){
    IBOutlet UITableView *table;
    NSArray *courseDetailDataArray;
    NSMutableDictionary *selectedSectionDict;
    
    
    IBOutlet UILabel *courseName;
    
    IBOutlet YLProgressBar *progressBar;
    IBOutlet UILabel *progressLabel;
    
    IBOutlet UIView *descriptionView;
    IBOutlet UITextView *descriptionText;
    IBOutlet UIButton *okButton;
    
    IBOutlet UIButton *notificationButton;

    IBOutlet UIButton *linkButton;
    IBOutlet UIView *linkView;
    IBOutlet UIView *linkViewInner;
    IBOutlet UILabel *liveStartDateLabel;
    IBOutlet UILabel *liveEndDateLabel;

    
    IBOutlet UILabel *liveLinkLabel;
    IBOutlet UILabel *forumLinkLabel;
    IBOutlet UILabel *passwordLabel;
    
    IBOutlet UIButton *copyLinkButton;
    IBOutlet UIButton *forumClickHereButton;
    IBOutlet UIButton *fbForumClickHereButton;
    IBOutlet UIButton *mbhqForumClickHereButton;
    IBOutlet UIButton *liveLinkClickHereButton;
    
    IBOutlet UILabel *weeklyWebinarLabel;
    IBOutlet UILabel *forumTitleLabel;
    IBOutlet UIView *forumView;
    IBOutlet UIView *fbForumView;
    IBOutlet UIView *mbhqForumView;
    IBOutlet UILabel *fbForumTitleLabel;
    IBOutlet UILabel *mbhqForumTitleLabel;
    
    
    
    
    
    
    UIView *contentView;
    int apiCount;
    
    NSArray *courseList;
    IBOutlet UIButton *helpbutton;
    IBOutlet UIButton *resetButton;
    NSString *runByStr;
    int myWeekNo;
    
    BOOL messageNotification;
    BOOL semoinarNotification;
    BOOL isLoadController;
    BOOL isReload;
}

@end
static NSString *AchieveListHeaderViewIdentifier = @"AchieveListHeaderView";

@implementation CourseDetailsViewController
@synthesize courseData,isfirstTime,isFromMenu,courseDetailsDelegate;

#pragma mark - View Lifecycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isLoadController = YES;
    isReload = false;
    courseName.text = ![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]] ? [courseData objectForKey:@"CourseName"] :@"";
    selectedSectionDict = [[NSMutableDictionary alloc]init];;
    
    table.sectionFooterHeight = CGFLOAT_MIN;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"AchieveListHeaderView" bundle:nil];
    [table registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:AchieveListHeaderViewIdentifier];
    table.estimatedRowHeight = 50;
    table.rowHeight = UITableViewAutomaticDimension;
    
    table.sectionHeaderHeight = UITableViewAutomaticDimension;
    table.estimatedSectionHeaderHeight = 42;
    if (isfirstTime) {
//        [self updateCourseStatus_WebcellCall];
       // CourseName
        if ([courseDetailsDelegate respondsToSelector:@selector(didCheckAnyChangeForCourseList:)]) {
           isReload = true;
           [courseDetailsDelegate didCheckAnyChangeForCourseList:isReload];
        }
        NSString *txt = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Welcome to %@ \nLet's get started immediately \nPlease watch and 'tick off' each seminar to work your way through the course. \nNew seminars are released as you go", [courseData objectForKey:@"CourseName"]]];
//        [Utility msg:txt title:@"Success" controller:self haveToPop:NO];
        
//        NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[txt dataUsingEncoding:NSUTF8StringEncoding]
//                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
//                                                                  documentAttributes:nil error:nil];
        
        descriptionText.textContainer.lineFragmentPadding = 0;
        descriptionText.textContainerInset = UIEdgeInsetsZero;
//        descriptionText.attributedText =strAttributed;
        descriptionText.text=txt;
        descriptionView.hidden = false;
        okButton.layer.cornerRadius=okButton.frame.size.height/2;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
    }else{
        descriptionView.hidden = true;
    }
    
    //----------------------------
    linkViewInner.layer.cornerRadius=15;
    linkViewInner.clipsToBounds=YES;
    linkView.hidden=true;
    BOOL isLive=[[courseData objectForKey:@"IsLiveCourse"] boolValue];
    if (isLive) {
        linkButton.hidden=false;
        notificationButton.hidden=true;
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"OfficialStartDate"]]){
            NSString *sdate = courseData[@"OfficialStartDate"];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [df dateFromString:sdate];
            [df setDateFormat:@"EEEE, MMMM d, yyyy"];
            liveStartDateLabel.text=[NSString stringWithFormat:@"%@",[df stringFromDate:date]];
        }else{
            liveStartDateLabel.text=@"";
        }
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarDay"]] && ![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarTime"]]){
            weeklyWebinarLabel.text=[NSString stringWithFormat:@"Every %@ at %@ AEST",[courseData objectForKey:@"LiveWebinarDay"],[courseData objectForKey:@"LiveWebinarTime"]];
        }else{
            weeklyWebinarLabel.text=@"";
        }
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"EnrollmentEndDate"]]){
            liveEndDateLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"EnrollmentEndDate"]];
        }else{
            liveEndDateLabel.text=@"";
        }
        
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarUrl"]]){
//            liveLinkLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"LiveWebinarUrl"]];
//        }else{
//            liveLinkLabel.text=@"";
//        }
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarPassword"]]){
            passwordLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"LiveWebinarPassword"]];
        }else{
            passwordLabel.text=@"";
        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"OtherForumUrl"]]){
//            forumLinkLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"OtherForumUrl"]];
//        }else{
//            forumLinkLabel.text=@"";
//        }
        
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]]){
            forumView.hidden=false;
            if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]]){
                forumTitleLabel.text=[NSString stringWithFormat:@"%@ Forum",[courseData objectForKey:@"CourseName"]];
            }else{
                forumTitleLabel.text=@"Forum";
            }
        }else{
            forumView.hidden=true;
        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"FBForumUrl"]]){
//            fbForumView.hidden=false;
//            if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]]){
//                fbForumTitleLabel.text=[NSString stringWithFormat:@"%@ FBForum",[courseData objectForKey:@"CourseName"]];
//            }else{
//                fbForumTitleLabel.text=@"FBForum";
//            }
//        }else{
//            fbForumView.hidden=true;
//        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"MbhqForumUrl"]]){
//            mbhqForumView.hidden=false;
//            if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]]){
//                mbhqForumTitleLabel.text=[NSString stringWithFormat:@"%@ MBHQForum",[courseData objectForKey:@"CourseName"]];
//            }else{
//                mbhqForumTitleLabel.text=@"FBForum";
//            }
//        }else{
//            mbhqForumView.hidden=true;
//        }
        
        
//        liveLinkClickHereButton.layer.cornerRadius=15;
//        liveLinkClickHereButton.layer.borderWidth=1;
//        liveLinkClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [liveLinkClickHereButton setBackgroundColor:[UIColor whiteColor]];
//        [liveLinkClickHereButton setBackgroundColor:[UIColor colorWithRed:0.0 / 255.0 green:212.0 / 255.0 blue:187.0 / 255.0 alpha:1.0]];
        
//        forumClickHereButton.layer.cornerRadius=15;
//        forumClickHereButton.layer.borderWidth=1;
//        forumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [forumClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
//        fbForumClickHereButton.layer.cornerRadius=15;
//        fbForumClickHereButton.layer.borderWidth=1;
//        fbForumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [fbForumClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
//        mbhqForumClickHereButton.layer.cornerRadius=15;
//        mbhqForumClickHereButton.layer.borderWidth=1;
//        mbhqForumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [mbhqForumClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
        
        //------------------------------------------------------------------------
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstTimeLiveProgram"]]) {
            NSDictionary *dict=[defaults objectForKey:@"FirstTimeLiveProgram"];
            NSMutableArray *arr=[[dict objectForKey:@"Data"] mutableCopy];
            if ([arr containsObject:courseData[@"UserSquadCourseId"]]) {
                linkView.hidden=true;
            }else{
                [arr addObject:courseData[@"UserSquadCourseId"]];
                NSDictionary *mdict=[[NSDictionary alloc] initWithObjectsAndKeys:arr,@"Data", nil];
                [defaults setObject:mdict forKey:@"FirstTimeLiveProgram"];
                linkView.hidden=false;
            }
        }else{
            NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:courseData[@"UserSquadCourseId"], nil];
            NSDictionary *mdict=[[NSDictionary alloc] initWithObjectsAndKeys:arr,@"Data", nil];
            [defaults setObject:mdict forKey:@"FirstTimeLiveProgram"];
            linkView.hidden=false;
        }
    }else{
        linkButton.hidden=true;
        notificationButton.hidden=false;
    }
    
    //--------------------------
    
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    apiCount= 0;
    
    //chayan 18/9/2017
    if (isFromMenu) {
        helpbutton.hidden=NO;
        resetButton.hidden=NO;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getCourseListApiCall];
        });
    }else{
        if (!isLoadController) {
            return;
        }
        isLoadController = false;
        helpbutton.hidden=YES;
        resetButton.hidden=YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getCourseDetailApiCall];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark - IBAction

- (IBAction)forumLinkButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:[courseData objectForKey:@"OtherForumUrl"]]){
        NSString *redirectUrl = [courseData objectForKey:@"OtherForumUrl"];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }else if (![Utility isEmptyCheck:[courseData objectForKey:@"FBForumUrl"]]){
        NSString *redirectUrlStr = [courseData objectForKey:@"FBForumUrl"];
        NSString *fbAppUrlStr =[redirectUrlStr stringByReplacingOccurrencesOfString:@"https://www.facebook.com/groups" withString:@"fb://profile"];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:fbAppUrlStr]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:fbAppUrlStr] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrlStr] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }else if (![Utility isEmptyCheck:[courseData objectForKey:@"MbhqForumUrl"]]){
        [self goToCommunityView:[courseData objectForKey:@"MbhqForumUrl"]];;
    }
}

- (IBAction)fbForumLinkButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:[courseData objectForKey:@"FBForumUrl"]]){
        NSString *redirectUrl = [courseData objectForKey:@"FBForumUrl"];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }
}

- (IBAction)mbhqForumLinkButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:[courseData objectForKey:@"MbhqForumUrl"]]){
//        [self goToCommunityView];
    }
}


- (IBAction)liveLinkButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarUrl"]]){
        NSString *redirectUrl = [courseData objectForKey:@"LiveWebinarUrl"];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"Opened");
                }
            }];
        }
    }
}

- (IBAction)copyLinkButton:(UIButton *)sender {
    if (sender.tag==0) {
        [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarUrl"]] ? [courseData objectForKey:@"LiveWebinarUrl"] : @"";
        [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
    }else if (sender.tag==1){
        [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:passwordLabel.text] ? passwordLabel.text : @"";
        [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
    }else if (sender.tag==2){
        [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[courseData objectForKey:@"OtherForumUrl"]] ? [courseData objectForKey:@"OtherForumUrl"] : @"";
        [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
    }else if (sender.tag==3){
        [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[courseData objectForKey:@"FBForumUrl"]] ? [courseData objectForKey:@"FBForumUrl"] : @"";
        [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
    }else if (sender.tag==4){
        [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[courseData objectForKey:@"MbhqForumUrl"]] ? [courseData objectForKey:@"MbhqForumUrl"] : @"";
        [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
    }
    
}





- (IBAction)closeLinkView:(UIButton *)sender {
    linkView.hidden=true;
}

- (IBAction)linkButtonPressed:(UIButton *)sender {
    linkView.hidden=! linkView.hidden;
}

-(IBAction)crossButtonPressed:(id)sender{
    descriptionView.hidden = true;
}

- (IBAction)notificationButtonPressed:(UIButton *)sender {
    
    CourseNotificationControlViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseNotificationControlView"];
    controller.view.backgroundColor = [UIColor clearColor];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.courseDetailsDict=[courseData mutableCopy];
    controller.messageNotification=messageNotification;
    controller.seminarNotification=semoinarNotification;
    controller.course_notification_delegate=self;
    [self presentViewController:controller animated:YES completion:nil];
}

//chayan 18/9/2017
- (IBAction)helpButtonPressed:(id)sender {
    NSString *urlString=@"https://player.vimeo.com/external/234300535.m3u8?s=ce8a737e8d0fbae45fc51161df702079be8186e1";
    HelpVideoPlayerViewController *helpVideoPlayerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpVideoPlayerView"];
    helpVideoPlayerViewController.modalPresentationStyle = UIModalPresentationCustom;
    helpVideoPlayerViewController.videoURLString = urlString;
    [self presentViewController:helpVideoPlayerViewController animated:YES completion:nil];
}

//chayan 19/9/2017
- (IBAction)resetButtonPressed:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning !" message:@"This is the RESET challenge button. If you reset your challenge all the tasks you have done will be cleared. Do you want to start the challenge again and have you history erased?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self ResetWeekChallengeApiCall];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO, I want to keep going" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}


- (IBAction)addButtonPressed:(UIButton *)sender {
}

- (IBAction)sectionExpandCollapse:(UIButton *)sender {
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:sender.tag]]boolValue]) {
        [selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:sender.tag]];
    }else{
        [selectedSectionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:sender.tag]];
    }
    
    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [self->table reloadData];
            [self->table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sender.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }];
    
}
- (IBAction)articleNameButtonPressed:(UIButton *)sender {
    NSDictionary *articleDict = [courseDetailDataArray objectAtIndex:sender.accessibilityHint.integerValue];
    NSArray *articleArray =[articleDict valueForKey:@"article"];
    if (![Utility isEmptyCheck:articleArray] && articleArray.count > 0){
        NSDictionary *articleData = [articleArray objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:articleData]) {
            CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
            controller.courseId = [courseData valueForKey:@"CourseId"];
            controller.articleId = [articleData objectForKey:@"ArticleId"];
            controller.imageUrl=[courseData objectForKey:@"ImageUrl2"];
            controller.courseArticleDelegate = self;
            //Ru
            controller.autherStr = [articleData objectForKey:@"AuthorName"];
            if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
                controller.taskId = [articleData objectForKey:@"RelatedTask"][@"TaskId"];
            }
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
- (IBAction)articleActionButtonPressed:(UIButton *)sender {
    NSDictionary *articleDict = [courseDetailDataArray objectAtIndex:sender.accessibilityHint.integerValue];
    NSArray *articleArray =[articleDict valueForKey:@"article"];
    if (![Utility isEmptyCheck:articleArray] && articleArray.count > 0){
        NSDictionary *articleData = [articleArray objectAtIndex:sender.tag];
        if (![Utility isEmptyCheck:articleData]) {
            CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
            controller.courseId = [self->courseData valueForKey:@"CourseId"];
            controller.articleId = [articleData objectForKey:@"ArticleId"];
            controller.imageUrl=[self->courseData objectForKey:@"ImageUrl2"];
            controller.autherStr = [articleData objectForKey:@"AuthorName"];
            controller.courseArticleDelegate = self;
            if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
                controller.taskId = [articleData objectForKey:@"RelatedTask"][@"TaskId"];
            }
            [self.navigationController pushViewController:controller animated:YES];
            
            /*
            if (![Utility isEmptyCheck:[articleData objectForKey:@"IsRead"]] && [[articleData objectForKey:@"IsRead"] boolValue]) {
                [self saveDataIsRead:articleData isArticleRead:true];
            }else{
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"To complete this task, please click on the name and follow directions to 'tick it off'" // This article has already task ! would you like to Tick it ? //AY 29032018
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Confirm"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         NSLog(@"Resolving UIAlert Action for tapping OK Button");
                                         CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
                                         controller.courseId = [self->courseData valueForKey:@"CourseId"];
                                         controller.articleId = [articleData objectForKey:@"ArticleId"];
                                         controller.autherStr = [articleData objectForKey:@"AuthorName"];
                                         if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
                                             controller.taskId = [articleData objectForKey:@"RelatedTask"][@"TaskId"];
                                         }
                                         [self.navigationController pushViewController:controller animated:YES];
                                         
                                     }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"No"
                                         style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * action)
                                         {
                                             NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                             
                                         }];
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
             */
        }
    }
}
- (IBAction)backButtonPressed:(UIButton *)sender
{
    if ([courseDetailsDelegate respondsToSelector:@selector(didCheckAnyChangeForCourseList:)]) {
        [courseDetailsDelegate didCheckAnyChangeForCourseList:isReload];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - End


#pragma mark - PrivateMethod

-(void)goToCommunityView:(NSString *)urlStr{
    if (![Utility reachable]) {
          [Utility msg:@"The MindbodyHQ forum is not available in aeroplane mode. Please turn your internet back on to access the forum" title:@"Oops! " controller:self haveToPop:NO];
          return;
      }
    if(![defaults boolForKey:@"CompletedStartupChecklist"]){
        [self incompleStartTaskAlert];
        return;
    }
    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
        return;
    }
    UIViewController *visibleController = self.parentViewController;
    if ([visibleController isKindOfClass:[CommunityViewController class]]) {
        return;
    }
    CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];
//    NSString *s=[NSString stringWithFormat:@"%@?token=%@",urlStr,[defaults valueForKey:@"UserSessionID"]];
    controller.isFromCourse=true;
    controller.liveForumUrlStr=urlStr;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)incompleStartTaskAlert{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"Please complete top 4 getting started task to access this functionality."
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
//                                   [self homeButtonTapped:0];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


// getWeekChallengeCourseData
-(void)getWeekChallengeCourseData{
    if (![Utility isEmptyCheck:courseList] && courseList.count > 0) {
        for (int i = 0; i< courseList.count ; i++){
            NSDictionary *dict = [courseList objectAtIndex:i];
            if ([[dict objectForKey:@"CourseType"] isEqualToString:@"Week Challenge"] && [[dict objectForKey:@"CourseName"] isEqualToString:@"8 Week Challenge"]){
                if (![dict[@"IsEnroll"] boolValue]) {
                    [self addCourseApiCall:dict];
                }else{
                    courseData=dict;
                    courseName.text = ![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]] ? [courseData objectForKey:@"CourseName"] :@"";
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [self getCourseDetailApiCall];
                    });
                }
                break;
                
            }
        }
    }
}

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

#pragma mark - End


#pragma mark - Api call

-(void)addCourseApiCall:(NSDictionary *)dict{
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
        NSDate *date = [NSDate date];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
        
        [courseDict setObject:[dateFormat stringFromDate:date] forKey:@"CourseStartDate"];
        [mainDict setObject:courseDict forKey:@"Model"];//CourseList
        
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
                                                                         NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                                                         [mdict setObject:[responseDictionary objectForKey:@"NewData"] forKey:@"UserSquadCourseId"];
                                                                         self->courseData=mdict;
                                                                         self->courseName.text = ![Utility isEmptyCheck:[self->courseData objectForKey:@"CourseName"]] ? [self->courseData objectForKey:@"CourseName"] :@"";
                                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                             [self getCourseDetailApiCall];
                                                                         });
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}

// get course list api call added
-(void)ResetWeekChallengeApiCall{
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
        //        [mainDict setObject:[courseData valueForKey:@"UserSquadCourseId"] forKey:@"EnrollCourseId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[courseData valueForKey:@"CourseId"] forKey:@"CourseId"];
        //        [mainDict setObject:[NSNumber numberWithBool:isfirstTime] forKey:@"isfirstTime"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ResetWeekChallengeApiCall" append:@"" forAction:@"POST"];
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
                                                                     NSLog(@"\nresponse str:\n\n%@ ",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                             [self getCourseDetailApiCall];
                                                                         });
                                                                         
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



// get course list api call added
-(void)getCourseListApiCall{
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
                                                                         self->courseList = [responseDictionary objectForKey:@"Courses"];
                                                                         [self getWeekChallengeCourseData];
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


-(void) saveDataIsRead:(NSDictionary *)dict isArticleRead:(BOOL)isArticleRead {
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ArticleId"] forKey:@"ArticleId"];
        [mainDict setObject:[courseData valueForKey:@"CourseId"] forKey:@"CourseId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSString *api;
        if (isArticleRead) {
            api = @"UnreadArticle";
        } else {
            api = @"ArticleRead";
        }
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
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
                                                                         self->isReload = true;
                                                                         [self viewWillAppear:YES];
                                                                         /*if (![Utility isEmptyCheck:[dict objectForKey:@"RelatedTask"]]) {
                                                                          [self updateTask:[dict objectForKey:@"RelatedTask"] isDone:[[responseDict objectForKey:@"IsSuccess"] boolValue]];
                                                                          }*/
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
-(void)updateTask:(NSDictionary *)dict isDone:(BOOL)isDone{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"TaskId"] forKey:@"TaskId"];
        [mainDict setObject:[NSNumber numberWithBool:isDone] forKey:@"IsDone"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateTaskApiCall" append:@"" forAction:@"POST"];
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
                                                                         [self viewWillAppear:YES];
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

-(void)setProgressBarApiCall:(NSNumber *)selectedWeekNumber{
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
        [mainDict setObject:[courseData valueForKey:@"CourseId"] forKey:@"CourseId"];
        [mainDict setObject:selectedWeekNumber forKey:@"WeekNumber"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SetProgressBarApiCall" append:@"" forAction:@"POST"];
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
                                                                         if ([[responseDictionary objectForKey:@"ArticleCount"]intValue] != 0) {
                                                                             self->progressBar.progress = (float) [[responseDictionary objectForKey:@"UserArticleReadCount"]intValue]/(float)[[responseDictionary objectForKey:@"ArticleCount"]intValue];
                                                                             int readCount=[[responseDictionary objectForKey:@"UserArticleReadCount"]intValue];
                                                                             int total=[[responseDictionary objectForKey:@"ArticleCount"]intValue];
                                                                             
                                                                             float progressPercentage=((float)readCount*100.0f)/(float)total;
                                                                             self->progressLabel.text =[@"" stringByAppendingFormat:@"%.0f %%",progressPercentage];
                                                                             
//                                                                             self->progressLabel.text = [@"" stringByAppendingFormat:@"%@/%@",[responseDictionary objectForKey:@"UserArticleReadCount"],[responseDictionary objectForKey:@"ArticleCount"]];
                                                                             
                                                                             //add_su_3/8/17
                                                                             if ([[responseDictionary objectForKey:@"UserArticleReadCount"]intValue] == [[responseDictionary objectForKey:@"ArticleCount"]intValue]) {
                                                                                 
                                                                                 //
                                                                             }
                                                                         }else{
                                                                             self->progressBar.progress = 0;
//                                                                             self->progressLabel.text = @"0/0";
                                                                             self->progressLabel.text = @"0%";
                                                                         }
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
-(void)getCourseDetailApiCall{
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
        [mainDict setObject:[courseData valueForKey:@"UserSquadCourseId"] forKey:@"EnrollCourseId"];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithBool:isfirstTime] forKey:@"isfirstTime"];
        [mainDict setObject:[NSNumber numberWithInt:Seminar] forKey:@"PublishType"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCourseDetailApiCall" append:@"" forAction:@"POST"];
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
                                                                         self->isfirstTime = false;
                                                                         [self setProgressBarApiCall:[responseDictionary objectForKey:@"SelectedWeekNumber"]];
                                                                         
                                                                         self->messageNotification=[[responseDictionary objectForKey:@"MessageNotification"] boolValue];
                                                                         self->semoinarNotification=[[responseDictionary objectForKey:@"SeminarNotification"] boolValue];
                                                                         
                                                                         NSMutableDictionary *temp=[self->courseData mutableCopy];
                                                                         [temp setObject:[responseDictionary objectForKey:@"Status"] forKey:@"Status"];
                                                                         self->courseData=temp;
                                                                         
                                                                         NSArray *articleArray = [responseDictionary objectForKey:@"ArticleFeedDetail"];
                                                                         
                                                                         //RU
                                                                         //Mark: to show RunBy Label
                                                                         self->runByStr = [responseDictionary objectForKey:@"RunBy"];
                                                                         NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
                                                                         NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                                                                         [formatter setDateFormat:@"yyyy-MM-dd"];
                                                                         
                                                                         
                                                                         NSDate* tomorowDate = [[NSDate date] dateByAddingDays:1];
                                                                         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ReleaseDate < %@)",[formatter stringFromDate:tomorowDate]];
                                                                         
                                                                         
//                                                                         if(articleArray.count>0){
//                                                                             articleArray = [articleArray filteredArrayUsingPredicate:predicate];
//                                                                         }
                                                                         if (![Utility isEmptyCheck:articleArray] && articleArray.count > 0) {
                                                                             NSArray *weekNoArray = [articleArray valueForKeyPath:@"@distinctUnionOfObjects.WeekNumber"];
                                                                             
                                                                             NSLog(@"%@", weekNoArray);
                                                                             
                                                                             NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self"
                                                                                                                                          ascending:YES
                                                                                                                                         comparator:^(id obj1, id obj2){
                                                                                                                                             return [(NSString*)[obj1 stringValue] compare:(NSString*)[obj2 stringValue]
                                                                                                                                                                                   options:NSNumericSearch];
                                                                                                                                         }];;
                                                                             NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                                                                             NSMutableArray *sortedArray = [[weekNoArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                                                                             if ([sortedArray containsObject:[NSNumber numberWithInt:-1]]) {
                                                                                 [sortedArray removeObject:[NSNumber numberWithInt:-1]];
                                                                             }
                                                                             if (sortedArray.count > 0) {
                                                                                 for (int i=0; i< sortedArray.count; i++) {
                                                                                     NSArray *filteredarray = [articleArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(WeekNumber == %@)", [sortedArray objectAtIndex:i]]];
                                                                                     if (filteredarray.count > 0) {
                                                                                         [sectionArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredarray,@"article",[sortedArray objectAtIndex:i],@"weekNo", nil]];
                                                                                     }else{
                                                                                         [sectionArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSArray array],@"article",[sortedArray objectAtIndex:i],@"weekNo", nil]];
                                                                                     }
                                                                                 }
                                                                                 self->courseDetailDataArray =sectionArray;
                                                                                 //                                                                                 if (isfromHome) { //change_new_240318
                                                                                 //                                                                                     NSDictionary *articleDict = [courseDetailDataArray objectAtIndex:0];
                                                                                 //                                                                                     isfromHome = false;
                                                                                 //                                                                                     NSArray *articleArray =[articleDict valueForKey:@"article"];
                                                                                 //                                                                                     if (![Utility isEmptyCheck:articleArray] && articleArray.count > 0){
                                                                                 //                                                                                         NSDictionary *articleData = [articleArray objectAtIndex:0];
                                                                                 //                                                                                         if (![Utility isEmptyCheck:articleData]) {
                                                                                 //                                                                                             CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
                                                                                 //                                                                                             controller.courseId = [courseData valueForKey:@"CourseId"];
                                                                                 //                                                                                             controller.articleId = [articleData objectForKey:@"ArticleId"];
                                                                                 //                                                                                             if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
                                                                                 //                                                                                                 controller.taskId = [articleData objectForKey:@"RelatedTask"][@"TaskId"];
                                                                                 //                                                                                             }
                                                                                 //                                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                                 //                                                                                         }
                                                                                 //                                                                                     }
                                                                                 //                                                                                 }//change_new_240318
                                                                                 /*
                                                                                  //change_new
                                                                                  for (int i=0; i <courseDetailDataArray.count; i++) {
                                                                                  NSDictionary *dict = [courseDetailDataArray objectAtIndex:i];
                                                                                  if ([dict objectForKey:@"weekNo"] == [responseDictionary objectForKey:@"SelectedWeekNumber"]) {
                                                                                  */
                                                                                 
                                                                                 for (int i=0; i <self->courseDetailDataArray.count; i++) {
                                                                                     NSDictionary *dict = [self->courseDetailDataArray objectAtIndex:i];
                                                                                     if ([dict objectForKey:@"weekNo"] == [responseDictionary objectForKey:@"SelectedWeekNumber"]) {
                                                                                         
                                                                                         //[selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:i]];
                                                                                         [self->selectedSectionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:i]];
                                                                                     }else{
                                                                                         [self->selectedSectionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:i]];
                                                                                         
                                                                                     }
                                                                                 }
                                                                                 [self->table reloadData];
                                                                             }else{
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                                 return;
                                                                             }
                                                                         }
                                                                         
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


-(void)updateCourseStatus_WebcellCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;

        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[courseData valueForKey:@"CourseId"] forKey:@"CourseId"];
        [mainDict setObject:[NSString stringWithFormat:@"%d",1] forKey:@"Status"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];

        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateCourseStatus" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         
                                                                         NSMutableDictionary *temp=[self->courseData mutableCopy];
                                                                         [temp setObject:[NSString stringWithFormat:@"%d",1] forKey:@"Status"];
                                                                         self->courseData=temp;
                                                                         
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                             });
                                                         }];
        [dataTask resume];

    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
#pragma mark - End


#pragma mark - Table view data source

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    AchieveListHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AchieveListHeaderViewIdentifier];
    NSDictionary *circuitDict = [courseDetailDataArray objectAtIndex:section];
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        sectionHeaderView.collapseButton.selected = YES;
    }else{
        sectionHeaderView.collapseButton.selected = NO;
    }
    sectionHeaderView.collapseButton.hidden = true;
    sectionHeaderView.collapseButton.tag = section;
    sectionHeaderView.headerBgImage.backgroundColor = [Utility colorWithHexString:@"32cdb8" ];
    sectionHeaderView.headerBgImage.image = nil;
    
    NSString *weekNo = [@"" stringByAppendingFormat:@"%@",[circuitDict objectForKey:@"weekNo"] ];
    NSString *weeklyTheme = @"";
    
    NSArray *articleArray =[circuitDict valueForKey:@"article"];
    
    if(articleArray.count>0){
        NSDictionary *dict = [articleArray firstObject];
        if(![Utility isEmptyCheck:[dict objectForKey:@"WeeklyTheme"]]){
            weeklyTheme = [dict objectForKey:@"WeeklyTheme"];
        }
    }
    
    
    
    
    if (![Utility isEmptyCheck:weekNo]) {
        if ([[circuitDict objectForKey:@"weekNo"] intValue]==0) {
            
            NSString *finalText = @"";
            
            if(weeklyTheme.length > 0){
               finalText = [@"" stringByAppendingFormat:@"GETTING STARTED: PREP ROOM - %@",weeklyTheme];
            }else{
                finalText = @"GETTING STARTED: PREP ROOM";
            }
            
            
            sectionHeaderView.achieveTypeName.text = finalText;
        }
        else if ([[circuitDict objectForKey:@"weekNo"] intValue]>0){
            
            //Mark:**Label with week number display**//Ru
            
            NSString *finalText = @"";
            
            if(weeklyTheme.length > 0){
                if ([runByStr isEqualToString:@"WEEK_FLOW"]) {
                    finalText = [@"" stringByAppendingFormat:@"%@ %@ - %@",@"WEEK",weekNo,weeklyTheme];
                }else{
                    finalText = [@"" stringByAppendingFormat:@"%@ %@ - %@",(![Utility isEmptyCheck:runByStr])?runByStr:@"",weekNo,weeklyTheme];
                }
            }else{
                if ([runByStr isEqualToString:@"WEEK_FLOW"]) {
                    finalText = [@"" stringByAppendingFormat:@"%@ %@",@"WEEk",weekNo ];
                }else{
                    finalText = [@"" stringByAppendingFormat:@"%@ %@",(![Utility isEmptyCheck:runByStr])?runByStr:@"",weekNo ];
                }
                
            }
            
            
            sectionHeaderView.achieveTypeName.text = finalText;
            
            /*// Prev
             if ([[courseData objectForKey:@"CourseType"] isEqualToString:@"Week Challenge"] || [[courseData objectForKey:@"CourseName"] isEqualToString:@"8 Week Challenge"]){
             sectionHeaderView.achieveTypeName.text = [@"" stringByAppendingFormat:@"WEEK %@",weekNo ];
             }
             else{
             sectionHeaderView.achieveTypeName.text = [@"" stringByAppendingFormat:@"LEVEL %@",weekNo ];
             }*/
        }
    }
    
    [sectionHeaderView.collapseButton addTarget:self
                                         action:@selector(sectionExpandCollapse:)
                               forControlEvents:UIControlEventTouchUpInside];
    return  sectionHeaderView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Utility isEmptyCheck:courseDetailDataArray]) {
        return courseDetailDataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *articleDict = [courseDetailDataArray objectAtIndex:section];
    NSArray *articleArray =[articleDict valueForKey:@"article"];
    if (![[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        return 0;
    }else{
        if (![Utility isEmptyCheck:articleArray]) {
            return articleArray.count;
        }
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"CourseDetailsTableViewCell";
    CourseDetailsTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CourseDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *articleDict = [courseDetailDataArray objectAtIndex:indexPath.section];
    NSArray *articleArray =[articleDict valueForKey:@"article"];
    if (![Utility isEmptyCheck:articleArray] && articleArray.count > 0){
        NSDictionary *articleData = [articleArray objectAtIndex:indexPath.row];
        
        NSString *fontName = @"Raleway-Semibold";
        if (![Utility isEmptyCheck:[articleData objectForKey:@"IsRead"]] && [[articleData objectForKey:@"IsRead"] boolValue]) {
            
            if(cell.courseActionButton.hidden)
                cell.courseActionButton.hidden=NO;
            fontName = @"Raleway-Semibold";
            [cell.courseActionButton setImage:[UIImage imageNamed:@"completed_tick.png"] forState:UIControlStateNormal];
        }else{
            if (![Utility isEmptyCheck:[articleData objectForKey:@"RelatedTask"]]) {
                NSLog(@"");
                
                if(cell.courseActionButton.hidden)
                    cell.courseActionButton.hidden=NO;
                
                [cell.courseActionButton setImage:[UIImage imageNamed:@"play_btn_N_grey.png"] forState:UIControlStateNormal];
                
            }
            else{
                [cell.courseActionName setHidden:YES];
//                [cell.courseActionButton setHidden:false];
                cell.courseActionButton.hidden=NO;
                [cell.courseActionButton setImage:[UIImage imageNamed:@"play_btn_N_grey.png"] forState:UIControlStateNormal];
            }
            fontName = @"Raleway-Semibold";
        }
        
        if (![Utility isEmptyCheck:[articleData objectForKey:@"ArticleTitle"]]) {
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [articleData objectForKey:@"ArticleTitle"]]];
            NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"%ld",(long)indexPath.row+1]];
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:fontName size:15.0],
                                       NSForegroundColorAttributeName : [UIColor colorWithRed:(109/255.0f) green:(109/255.0f) blue:(109/255.0f) alpha:1.0f]
                                       
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            [text addAttributes:@{
                                  NSFontAttributeName : [UIFont fontWithName:@"Raleway-Semibold" size:15.0],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:(50/255.0f) green:(205/255.0f) blue:(184/255.0f) alpha:1.0f]
                                  
                                  }
                          range:foundRange];
            
            cell.courseName.attributedText = text;
            
            cell.indexLabel.text = [@"" stringByAppendingFormat:@"%ld",indexPath.row+1];
        }else{
            cell.courseName.text = @"";
        }
        
        if (![Utility isEmptyCheck:[articleData objectForKey:@"SeminarTime"]])
        {
            cell.videoTimingLbl.text = [[articleData objectForKey:@"SeminarTime"] lowercaseString];
            cell.videoTimingImg.hidden = YES;
            cell.videoTimingLbl.hidden = NO;
        }
        else{
            cell.videoTimingLbl.hidden = YES;
            cell.videoTimingImg.hidden = YES;
        }
        
        if (![Utility isEmptyCheck:[articleData objectForKey:@"IsAvailable"]])
        {
            BOOL available=[[articleData objectForKey:@"IsAvailable"] boolValue];
            NSString *dateStr=@"";
            if (![Utility isEmptyCheck:[articleData objectForKey:@"ReleaseDate"]]) {
                
                NSString *releaseDAte =[articleData objectForKey:@"ReleaseDate"];
                NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd' 'hh:mm:ss"];
                NSDateFormatter *df1 = [NSDateFormatter new];
                [df1 setDateFormat:@"EEEE dd MMM yyyy"];
                NSDate *date1=[dateFormatter1 dateFromString:releaseDAte];
                dateStr=[df1 stringFromDate:date1];
                NSInteger currentDay = [date1 day];
                NSString *daySuffix = [@"" stringByAppendingFormat:@"%ld%@",currentDay,[Utility daySuffixForDate:date1]];
                
                dateStr = [dateStr stringByReplacingOccurrencesOfString:[@"" stringByAppendingFormat:@"%ld",currentDay] withString:daySuffix options:NSCaseInsensitiveSearch range:[dateStr rangeOfString:[@"" stringByAppendingFormat:@"%ld",(long)currentDay]]];
                //dateStr=[NSString stringWithFormat:@"%@",dateStr];
            }
            
            if (!available) {
                cell.courseActionButton.userInteractionEnabled=NO;
                cell.courseNameButton.userInteractionEnabled=NO;
                cell.releaseDateLabel.text=dateStr;
                cell.blurView.hidden=false;
                cell.courseName.text = @"";
                cell.courseActionButton.hidden = true;
                
            }else{
                cell.courseActionButton.userInteractionEnabled=YES;
                cell.courseNameButton.userInteractionEnabled=YES;
                cell.releaseDateLabel.text=@"";
                cell.blurView.hidden=true;
            }
        }
        
        
        
        cell.courseNameButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.courseNameButton.tag = indexPath.row;
        cell.courseActionButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
        cell.courseActionButton.tag = indexPath.row;
        
        cell.mainView.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
        cell.mainView.layer.borderWidth=1;
        cell.mainView.layer.cornerRadius=10;
        cell.mainView.clipsToBounds=YES;
        cell.mainView.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark -End






#pragma mark - Course Notification delegate
-(void)resetCourseData:(NSMutableDictionary *)courseDetailsDict isBack:(BOOL)isBack{
    if (isBack) {
        UIButton *btn;
        isReload = true;
        [self backButtonPressed:btn];
    }else{
        if (![Utility isEmptyCheck:courseDetailsDict]) {
            courseData=courseDetailsDict;
        }
        [self getCourseDetailApiCall];
    }
    
    
}

#pragma mark - CourseArticleDelegate
-(void)didCheckAnyChangeForCourseArticle:(BOOL)isreload{
    isLoadController = isreload;
    isReload = isreload;
}

@end
