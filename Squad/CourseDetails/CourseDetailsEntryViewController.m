//
//  CourseDetailsEntryViewController.m
//  Squad
//
//  Created by Admin on 28/07/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "CourseDetailsEntryViewController.h"

@interface CourseDetailsEntryViewController (){
    
    IBOutlet UIImageView *courseImage;
    
    IBOutlet UILabel *courseNameLabel;
    IBOutlet UIImageView *authorImage;
    IBOutlet UILabel *authorDescriptionLabel;
    IBOutlet UILabel *authorNameLabel;
    IBOutlet UITextView *authorDescriptionTextView;
    IBOutlet NSLayoutConstraint *authorDescriptionTextViewHeightConstraint;
    
    IBOutlet UITextView *descriptionTextView;
    IBOutlet NSLayoutConstraint *descriptionTextViewHeightConstraint;
    IBOutlet UIView *liveInfoMainView;
    IBOutlet UIView *amountMainView;
    
    
    
    
    IBOutlet UIButton *loadMoreButton;
    IBOutlet UILabel *buyNowLabel;
    IBOutlet UILabel *amountLabel;
    IBOutlet UIButton *actionButton;
    
    IBOutlet UIStackView *amountStackView;
    
    IBOutlet UIView *courseStartAlertView;
    
    IBOutlet UIButton *courseStartTodayButton;
    IBOutlet UIButton *courseStartNextMondayButton;
    
    IBOutlet UIStackView *liveInfoStackView;
    IBOutlet UILabel *startDateLabel;
    IBOutlet UILabel *enrollEndDateLabel;
    IBOutlet UILabel *webinarLinkLabel;
    IBOutlet UIButton *webinarLinkClickHereButton;
    
    IBOutlet UILabel *passwordLabel;
    
    IBOutlet UILabel *forumLinkLabel;
    IBOutlet UIButton *forumClickHereButton;
    IBOutlet UIButton *fbForumClickHereButton;
    IBOutlet UIButton *mbhqForumClickHereButton;
    
    IBOutlet UIView *liveLinkView;
    IBOutlet UIView *passwordView;
    IBOutlet UILabel *weeklyWebinarLabel;
    IBOutlet UILabel *forumTitleLabel;
    IBOutlet UIView *forumView;
    IBOutlet UIView *fbForumView;
    IBOutlet UIView *mbhqForumView;
    IBOutlet UILabel *fbForumTitleLabel;
    IBOutlet UILabel *mbhqForumTitleLabel;
    IBOutlet UILabel *discountLabel;
    
    
    UIView *contentView;
    
}

@end

@implementation CourseDetailsEntryViewController
@synthesize courseData,originVC;

#pragma mark -ViewLifeCycle -

- (void)viewDidLoad {
    [super viewDidLoad];
    actionButton.layer.cornerRadius=10;
    actionButton.clipsToBounds=YES;
//    actionButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
//    actionButton.layer.borderWidth = 1.2;
    
           
    authorImage.layer.cornerRadius=10;
    authorImage.clipsToBounds=YES;
    
    courseImage.layer.cornerRadius=10;
    courseImage.clipsToBounds=YES;
        

    
    courseStartAlertView.hidden=true;
    NSDate *dateMonday=[Utility nextMondayDate];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *str= [df stringFromDate:dateMonday];
    courseStartNextMondayButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    courseStartNextMondayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [courseStartNextMondayButton setTitle:[@"" stringByAppendingFormat:@"Monday\n%@\n(recommended)",str] forState:UIControlStateNormal];
    courseStartTodayButton.layer.cornerRadius=15;
    courseStartTodayButton.clipsToBounds=YES;
    courseStartNextMondayButton.layer.cornerRadius=15;
    courseStartNextMondayButton.clipsToBounds=YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self prepareView];
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
        [self goToCommunityView:[courseData objectForKey:@"MbhqForumUrl"]];
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
        redirectUrl = [redirectUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
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

- (IBAction)courseStartDayButtonPressed:(UIButton *)sender {
    courseStartAlertView.hidden=true;
    if (sender.tag==0) {
        [self addCourseApiCall:courseData forDate:[NSDate date]];
    }else if (sender.tag==1){
        [self addCourseApiCall:courseData forDate:[Utility nextMondayDate]];
    }
}

-(IBAction)crossButtonPressed:(id)sender{
    courseStartAlertView.hidden=true;
}


- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)loadMoreButtonPressed:(UIButton *)sender {
}

- (IBAction)actionButtonPressed:(UIButton *)sender {
    
    BOOL isLive=[[courseData objectForKey:@"IsLiveCourse"] boolValue];
    BOOL hasSubscribed=[[courseData objectForKey:@"HasSubscribed"] boolValue];
    int subscriptionType=[[courseData objectForKey:@"SubscriptionType"] intValue];
    
    if ([[courseData objectForKey:@"CourseType"] isEqualToString:@"Masterclass"]) {
        if (subscriptionType==2 && !hasSubscribed){
            if (![Utility isEmptyCheck:[courseData objectForKey:@"PurchaseUrl"]]){
                NSString *purchaseUrl = [courseData objectForKey:@"PurchaseUrl"];
                NSString *redirectUrl=[NSString stringWithFormat:@"%@?checkout[email]=%@&checkout[shipping_address][first_name]=%@&checkout[shipping_address][last_name]=%@",purchaseUrl,[defaults objectForKey:@"Email"],[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]];
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
                    if(success){
                        NSLog(@"Opened");
                        [defaults setObject:[self->courseData objectForKey:@"CourseId"] forKey:@"CourseId"];
                        [self.navigationController popViewControllerAnimated:NO];
                        }
                    }];
                }
            }
        }else{
            CourseArticleDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseArticleDetails"];
            controller.courseId = [courseData valueForKey:@"CourseId"];
            controller.articleId = [courseData objectForKey:@"FirstArticleId"];
            controller.courseArticleDelegate = self;
            controller.autherStr = [courseData objectForKey:@"AuthorName"];
            [self.navigationController pushViewController:controller animated:YES];
        }
        return;
    }
    
    
    if (isLive && !hasSubscribed) {
        if (![Utility isEmptyCheck:[courseData objectForKey:@"PurchaseUrl"]]){
            NSString *purchaseUrl = [courseData objectForKey:@"PurchaseUrl"];
            NSString *redirectUrl=[NSString stringWithFormat:@"%@?checkout[email]=%@&checkout[shipping_address][first_name]=%@&checkout[shipping_address][last_name]=%@",purchaseUrl,[defaults objectForKey:@"Email"],[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]];
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"Opened");
                    [defaults setObject:[self->courseData objectForKey:@"CourseId"] forKey:@"CourseId"];
                    [self.navigationController popViewControllerAnimated:NO];
                    }
                }];
            }
        }
    }
//    else if (isLive && hasSubscribed){
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"OfficialStartDate"]]){
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy-dd-MM"];
//            NSDate *startDate=[formatter dateFromString:[courseData objectForKey:@"OfficialStartDate"]];
//            NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
//            NSDate *currentDate=[formatter dateFromString:currentDateStr];
//
//            if (([currentDate compare:startDate]==NSOrderedSame)|| ([currentDate compare:startDate]==NSOrderedDescending)) {
//                if (![Utility isEmptyCheck:[courseData objectForKey:@"Status"]]){
//                    int status=[[courseData objectForKey:@"Status"] intValue];
//                    if (status==3) {
//                        UIAlertController* alert = [UIAlertController
//                                                    alertControllerWithTitle:@"Alert!"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
//                                                    message:@"Do you want to enroll in this course again?"
//                                                    preferredStyle:UIAlertControllerStyleAlert];
//
//                        UIAlertAction* button0 = [UIAlertAction
//                                                  actionWithTitle:@"Cancel"
//                                                  style:UIAlertActionStyleCancel
//                                                  handler:^(UIAlertAction * action)
//                                                  {
//                                                      //  UIAlertController will automatically dismiss the view
//                                                  }];
//
//                        UIAlertAction* button1 = [UIAlertAction
//                                                  actionWithTitle:@"Yes"
//                                                  style:UIAlertActionStyleDefault
//                                                  handler:^(UIAlertAction * action)
//                                                  {
//                                                    self->courseStartAlertView.hidden=false;
//
//                                                  }];
//
//                        [alert addAction:button0];
//                        [alert addAction:button1];
//                        [self presentViewController:alert animated:YES completion:nil];
//                    }else if (status==0){
//                        courseStartAlertView.hidden=false;
//                    }else{
//                        CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
//                        controller.courseData = courseData;
//                        controller.courseDetailsDelegate=originVC;
//                        [self.navigationController pushViewController:controller animated:YES];
//                    }
//                }
//            }else{
//                [Utility msg:@"Live program has not started yet." title:@"Oops!" controller:self haveToPop:NO];
//            }
//        }
//    }
    else{
//        int subscriptionType=[[courseData objectForKey:@"SubscriptionType"] intValue];
        if ([Utility isOnlyProgramMember] && (subscriptionType==0 || subscriptionType==1)) {
            [Utility showNonSubscribedAlert:self sectionName:@"Course"];
            return;
        }
        
        if (subscriptionType==0 || subscriptionType==1 || (subscriptionType==2 && hasSubscribed) || (isLive && hasSubscribed)) {
            if (![Utility isEmptyCheck:[courseData objectForKey:@"Status"]]){
                int status=[[courseData objectForKey:@"Status"] intValue];
                if (status==3) {
                    UIAlertController* alert = [UIAlertController
                                                alertControllerWithTitle:@"Alert!"      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                                message:@"Do you want to enroll in this course again?"
                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* button0 = [UIAlertAction
                                              actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleCancel
                                              handler:^(UIAlertAction * action)
                                              {
                                                  //  UIAlertController will automatically dismiss the view
                                              }];
                    
                    UIAlertAction* button1 = [UIAlertAction
                                              actionWithTitle:@"Yes"
                                              style:UIAlertActionStyleDefault
                                              handler:^(UIAlertAction * action)
                                              {
                                                self->courseStartAlertView.hidden=false;
                                                  
                                              }];
                    
                    [alert addAction:button0];
                    [alert addAction:button1];
                    [self presentViewController:alert animated:YES completion:nil];
                }else if (status==0){
                    courseStartAlertView.hidden=false;
                }else{
                    CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
                    controller.courseData = courseData;
                    controller.courseDetailsDelegate=originVC;
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }else if (subscriptionType==2 && !hasSubscribed){
            if (![Utility isEmptyCheck:[courseData objectForKey:@"PurchaseUrl"]]){
                NSString *purchaseUrl = [courseData objectForKey:@"PurchaseUrl"];
                NSString *redirectUrl=[NSString stringWithFormat:@"%@?checkout[email]=%@&checkout[shipping_address][first_name]=%@&checkout[shipping_address][last_name]=%@",purchaseUrl,[defaults objectForKey:@"Email"],[defaults objectForKey:@"FirstName"],[defaults objectForKey:@"LastName"]];
                if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:redirectUrl]]){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:redirectUrl] options:@{} completionHandler:^(BOOL success) {
                    if(success){
                        NSLog(@"Opened");
                        [defaults setObject:[self->courseData objectForKey:@"CourseId"] forKey:@"CourseId"];
                        [self.navigationController popViewControllerAnimated:NO];
                        }
                    }];
                }
            }
        }
    }
}

#pragma mark - End

#pragma mark - Private method
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
    
    CommunityViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CommunityView"];
//    NSString *s=[NSString stringWithFormat:@"%@?token=%@",urlStr,[defaults valueForKey:@"UserSessionID"]];
    controller.isFromCourse=true;
    controller.liveForumUrlStr=urlStr;
//    [self.navigationController pushViewController:controller animated:YES];
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


-(void)prepareView{
    NSLog(@"%@",courseData);
    
    if (![Utility isEmptyCheck:[courseData objectForKey:@"ImageUrl2"]]){
        NSString *urlString = [@"" stringByAppendingFormat:@"%@",[courseData objectForKey:@"ImageUrl2"]];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [courseImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
    }else{
        courseImage.image = [UIImage imageNamed:@"place_holder1.png"];
    }
    
    
    if (![Utility isEmptyCheck:[courseData objectForKey:@"AuthorImage"]]){
        NSString *urlString = [@"" stringByAppendingFormat:@"%@",[courseData objectForKey:@"AuthorImage"]];
        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [authorImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
    }else{
        authorImage.image = [UIImage imageNamed:@"place_holder1.png"];
    }
    
    courseNameLabel.text = ![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]] ? [[courseData objectForKey:@"CourseName"] uppercaseString] : @"";
    
    
    authorNameLabel.text = ![Utility isEmptyCheck:[courseData objectForKey:@"AuthorName"]] ? [[NSString stringWithFormat:@"Meet %@",[courseData objectForKey:@"AuthorName"]] uppercaseString] : @"";
    
    
//    authorDescriptionLabel.text = ![Utility isEmptyCheck:[courseData objectForKey:@"AuthorDescription"]] ? [courseData objectForKey:@"AuthorDescription"] : @"";
    
    if (![Utility isEmptyCheck:[courseData objectForKey:@"AuthorDescription"]]) {
        NSString *msg= [courseData objectForKey:@"AuthorDescription"];
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                  documentAttributes:nil error:nil];
        [strAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:18] range:NSMakeRange(0, [strAttributed length])];
        authorDescriptionTextView.textContainer.lineFragmentPadding = 0;
        authorDescriptionTextView.textContainerInset = UIEdgeInsetsZero;
        authorDescriptionTextView.attributedText =strAttributed;
        CGSize sizeThatShouldFitTheContent = [authorDescriptionTextView sizeThatFits:authorDescriptionTextView.frame.size];
        authorDescriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
        [self.view setNeedsUpdateConstraints];
    }else{
        authorDescriptionTextView.attributedText = [[NSAttributedString alloc]initWithString:@""];
    }
    
    if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseInfo"]]) {
        NSString *msg= [courseData objectForKey:@"CourseInfo"];
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                  documentAttributes:nil error:nil];
        [strAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:18] range:NSMakeRange(0, [strAttributed length])];
        descriptionTextView.textContainer.lineFragmentPadding = 0;
        descriptionTextView.textContainerInset = UIEdgeInsetsZero;
        descriptionTextView.attributedText =strAttributed;
        CGSize sizeThatShouldFitTheContent = [descriptionTextView sizeThatFits:descriptionTextView.frame.size];
        descriptionTextViewHeightConstraint.constant = sizeThatShouldFitTheContent.height;
        [self.view setNeedsUpdateConstraints];
    }else{
        descriptionTextView.attributedText = [[NSAttributedString alloc]initWithString:@""];
    }
    
    amountLabel.text= ![Utility isEmptyCheck:[courseData objectForKey:@"Price"]] ? [NSString stringWithFormat:@"$ %@",[courseData objectForKey:@"Price"]] : @"";
    
    if (![Utility isEmptyCheck:[courseData objectForKey:@"DiscountCode"]] && ![Utility isEmptyCheck:[courseData objectForKey:@"DiscountPercentage"]]) {
        discountLabel.text=[NSString stringWithFormat:@"Use members-only code: %@ to save %@%% off full price.",[courseData objectForKey:@"DiscountCode"],[courseData objectForKey:@"DiscountPercentage"]];
    }
    
    
    BOOL isLive=[[courseData objectForKey:@"IsLiveCourse"] boolValue];
    BOOL hasSubscribed=[[courseData objectForKey:@"HasSubscribed"] boolValue];
    if (isLive) {
        liveInfoMainView.hidden=false;
        
        if (hasSubscribed) {
            liveLinkView.hidden=false;
            passwordView.hidden=false;
            forumView.hidden=false;
        }else{
            liveLinkView.hidden=true;
            passwordView.hidden=true;
            forumView.hidden=true;
        }
        if (![Utility isEmptyCheck:[courseData objectForKey:@"OfficialStartDate"]]){
            NSString *sdate = courseData[@"OfficialStartDate"];
            NSDateFormatter *df = [NSDateFormatter new];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate *date = [df dateFromString:sdate];
            [df setDateFormat:@"EEEE, MMMM d, yyyy"];
            startDateLabel.text=[NSString stringWithFormat:@"%@",[df stringFromDate:date]];
        }else{
            startDateLabel.text=@"";
        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"EnrollmentEndDate"]]){
//            enrollEndDateLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"EnrollmentEndDate"]];
//        }else{
//            enrollEndDateLabel.text=@"";
//        }
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarDay"]] && ![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarTime"]]){
            weeklyWebinarLabel.text=[NSString stringWithFormat:@"Every %@ at %@ AEST",[courseData objectForKey:@"LiveWebinarDay"],[courseData objectForKey:@"LiveWebinarTime"]];
        }else{
            weeklyWebinarLabel.text=@"";
        }
        
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarPassword"]]){
            passwordLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"LiveWebinarPassword"]];
        }else{
            passwordLabel.text=@"";
        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"LiveWebinarUrl"]]){
//            webinarLinkLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"LiveWebinarUrl"]];
//        }else{
//            webinarLinkLabel.text=@"";
//        }
        
//        if (![Utility isEmptyCheck:[courseData objectForKey:@"OtherForumUrl"]]){
//            forumLinkLabel.text=[NSString stringWithFormat:@"%@",[courseData objectForKey:@"OtherForumUrl"]];
//        }else{
//            forumLinkLabel.text=@"";
//        }
        
        if (![Utility isEmptyCheck:[courseData objectForKey:@"CourseName"]]){
            forumTitleLabel.text=[NSString stringWithFormat:@"%@ Forum",[courseData objectForKey:@"CourseName"]];
        }else{
            forumTitleLabel.text=@"Forum";
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
        
        
        
        
        
//        webinarLinkClickHereButton.layer.cornerRadius=15;
//        webinarLinkClickHereButton.layer.borderWidth=1;
//        webinarLinkClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
        //[webinarLinkClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
//        forumClickHereButton.layer.cornerRadius=15;
//        forumClickHereButton.layer.borderWidth=1;
//        forumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
        //[forumClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
//        fbForumClickHereButton.layer.cornerRadius=15;
//        fbForumClickHereButton.layer.borderWidth=1;
//        fbForumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [fbForumClickHereButton setBackgroundColor:[UIColor whiteColor]];
//
//        mbhqForumClickHereButton.layer.cornerRadius=15;
//        mbhqForumClickHereButton.layer.borderWidth=1;
//        mbhqForumClickHereButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
//        [mbhqForumClickHereButton setBackgroundColor:[UIColor whiteColor]];
        
    }else{
        liveInfoMainView.hidden=true;
    }
    
    
    if (isLive && !hasSubscribed) {
        amountMainView.hidden=false;
        [actionButton setTitle:@"PURCHASE NOW" forState:UIControlStateNormal];
        discountLabel.hidden=false;
    }else{
        int subscriptionType=[[courseData objectForKey:@"SubscriptionType"] intValue];
        if ([Utility isOnlyProgramMember] && (subscriptionType==0 || subscriptionType==1)) {
            amountMainView.hidden=true;
            discountLabel.hidden=true;
            [actionButton setTitle:@"JOIN" forState:UIControlStateNormal];
        }else{
            if (subscriptionType==0 || subscriptionType==1 || (subscriptionType==2 && hasSubscribed) || (isLive && hasSubscribed)) {
                amountMainView.hidden=true;
                discountLabel.hidden=true;
                if (![Utility isEmptyCheck:[courseData objectForKey:@"Status"]]) {
                    int status=[[courseData objectForKey:@"Status"] intValue];
                    if (status==1) {
                        [actionButton setTitle:@"IN PROGRESS" forState:UIControlStateNormal];
                    }else if (status==2){
                        [actionButton setTitle:@"PAUSED" forState:UIControlStateNormal];
                    }else if (status==3){
                        [actionButton setTitle:@"COMPLETED" forState:UIControlStateNormal];
                    }else{
                        [actionButton setTitle:@"START" forState:UIControlStateNormal];
                    }
                }
            }else if (subscriptionType==2 && !hasSubscribed){
                amountMainView.hidden=false;
                discountLabel.hidden=false;
                [actionButton setTitle:@"PURCHASE NOW" forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - End
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
                                                                         [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadCourseList" object:self userInfo: nil];
                                                                         CourseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CourseDetails"];
                                                                         NSMutableDictionary *mdict = [[NSMutableDictionary alloc]initWithDictionary:dict];
                                                                         [mdict setObject:[responseDictionary objectForKey:@"NewData"] forKey:@"UserSquadCourseId"];
                                                                         controller.courseDetailsDelegate = self->originVC;
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
#pragma mark -Api call


#pragma mark - End

@end
