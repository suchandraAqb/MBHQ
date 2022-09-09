//
//  AppreciateViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 26/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//
#import "Utility.h"
#import "AppreciateViewController.h"
#import "MyDiaryListViewController.h"
#import "GratitudeViewController.h"
#import "AchievementsViewController.h"
#import "WebinarListViewController.h"
#import "PodcastViewController.h"
#import "MindFullNessTableViewCell.h"
#import "MeditationTableViewCell.h"
#import "WebinarSelectedViewController.h"
#import "QuoteGalleryViewController.h"
@interface AppreciateViewController (){
    UIView *contentView;
    NSArray *goalValueArray;
    
    //Chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    NSMutableArray *webinarList;
    NSMutableArray *meditationList;
    NSDictionary *selectedFilterDict;
    NSDictionary *meditationDict;
    IBOutlet UITableView *mindfulnessTable;
    IBOutlet UITableView *meditationTable;
    int apiCount;
    IBOutlet UIView *headerContainerView;
    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end

@implementation AppreciateViewController
@synthesize fromTodayPage;

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
//    blankView.hidden = false;
    
    [self getGoalValueListApiCall];
}

//chayan
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
}
-(void) viewDidAppear:(BOOL)animated {  //ah ux
    [super viewDidAppear:YES];
    
//    if(!_redirectBackToTodayPage){
//        if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAppreciate"] boolValue]) {
//            [self animateHelp];
//        }
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"Appreciate"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"Appreciate"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"Appreciate"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//    }
    
    apiCount= 0;
    selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:59],@"TagID",@"Mindfulness",@"EventTagName", nil];
    meditationDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:33],@"TagID",@"Meditation",@"EventTagName", nil];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getWebinarList]; //mind
            [self getWebinarListForMeditation];
          });
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - End

#pragma mark - Private Method

//chayan
-(void) animateHelp {   //ah ux
    [UIView animateWithDuration:1.5 animations:^{
        helpButton.alpha = 0.2;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.5 animations:^{
            helpButton.alpha = 1;
        } completion:^(BOOL finished) {
            UIViewController *vc = [self.navigationController visibleViewController];
            if (vc == self)
                [self animateHelp];
        }];
    }];
}

- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" : @"Click here for tools and tips to get the most out of the APPRECIATE section.",
                          @"isCustomFrame" : @true,
                          @"isFromHeader" :@true,
                          @"frame" : headerContainerView
                          },
                      ] mutableCopy];
    
    int multiplierX = 1;
    for (int i = 0; i < overlayViews.count; i++) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:overlayViews[i]];
        if ([[dict objectForKey:@"isCustomFrame"] boolValue]) {
            CGRect newFrame = headerContainerView.frame;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            newFrame.origin.x = (screenWidth/2.0)*multiplierX;//(screenWidth/5.0) +
            NSLog(@"%f",newFrame.origin.x);
            newFrame.size.width = (screenWidth/2.0);
            [dict setObject:[NSValue valueWithCGRect:newFrame] forKey:@"frame"];
            [overlayViews replaceObjectAtIndex:i withObject:dict];
            multiplierX++;
        }
    }
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}
//- (void)showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the APPRECIATE section."
//                              ];
//    for (int i = 0;i<actionButtons.count;i++) {
//        UIButton *button =actionButtons[i];
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//        [dict setObject:button forKey:@"view"];
//        [dict setObject:@NO forKey:@"onTop"];
//        [dict setObject:messageArray[i] forKey:@"insText"];
//        [dict setObject:@YES forKey:@"isCustomFrame"];
//        NSLog(@"%@",NSStringFromCGRect([self.view convertRect:button.frame fromView:button.superview]));
//        CGRect tempRect=[self.view convertRect:button.frame fromView:button.superview];
//        //        tempRect.cen
//        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y-tempRect.size.height/2, tempRect.size.width, tempRect.size.height);
//        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
//        [overlayViews addObject:dict];
//    }
//    [Utility initializeInstructionAt:self OnViews:overlayViews];
//}

-(void)getGoalValueListApiCall{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGoalValueListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         goalValueArray = [responseDictionary objectForKey:@"Details"];
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

-(void)getWebinarList{
    if (Utility.reachable) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    apiCount++;
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
                });

        NSURLSession *loginSession = [NSURLSession sharedSession];

        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:selectedFilterDict];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:3] forKey:@"Count"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ArchivedWebinarsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount --;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 [self.view setNeedsUpdateConstraints];
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         webinarList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];                                                                         if (![Utility isEmptyCheck:webinarList] && ![Utility isEmptyCheck:webinarList]) {
                                                                             if (apiCount == 0) {
                                                                                 [mindfulnessTable reloadData];
                                                                                 [meditationTable reloadData];
                                                                             }
                                                                             
                                                                         }else{
                                                                             webinarList = [[NSMutableArray alloc]init];
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setNeedsUpdateConstraints];
        });
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
}
-(void)getWebinarListForMeditation{
    if (Utility.reachable) {
    
                dispatch_async(dispatch_get_main_queue(), ^{
                    apiCount++;
        //            if (contentView) {
        //                [contentView removeFromSuperview];
        //            }
        //            contentView = [Utility activityIndicatorView:self];
                });
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:meditationDict];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:3] forKey:@"Count"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ArchivedWebinarsApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount --;
                                                                 //                                                                 if (contentView) {
                                                                 //                                                                     [contentView removeFromSuperview];
                                                                 //                                                                 }
                                                                 [self.view setNeedsUpdateConstraints];
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         meditationList = [[NSMutableArray alloc]initWithArray:[responseDict objectForKey:@"Webinars"]];                                                                         if (![Utility isEmptyCheck:meditationList] && ![Utility isEmptyCheck:meditationList]) {
                                                                             if (apiCount == 0) {
                                                                                 [mindfulnessTable reloadData];
                                                                                 [meditationTable reloadData];
                                                                             }
                                                                             
                                                                         }else{
                                                                             meditationList = [[NSMutableArray alloc]init];
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view setNeedsUpdateConstraints];
        });
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        return;
    }
}


#pragma -mark End

#pragma mark - IBAction
-(IBAction)itemButtonPressed:(UIButton *)sender{
    if (sender.tag ==0) {//add on 10.3.17
        GratitudeViewController *controller= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeView"];
        controller.goalValueArray = goalValueArray;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 1){
        AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Achievements"];
        controller.goalValueArray = goalValueArray;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 2){
        MyDiaryListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDiaryList"];
        controller.goalValueArray = goalValueArray;
        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 3){
        WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
        controller.isNotFromHome = YES;
        controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:59],@"TagID",@"Mindfulness",@"EventTagName", nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 4){
        WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
        controller.isNotFromHome = YES;
        controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:33],@"TagID",@"Meditation",@"EventTagName", nil];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(sender.tag == 5){
        QuoteGalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteGalleryView"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//chayan
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)notificationButtonTapped:(id)sender {
    
}
//chayan : questionHelpButtonPressed
- (IBAction)helpButtonPressed:(id)sender {
    
    NSString *urlString=@"https://player.vimeo.com/external/220933321.m3u8?s=dbe73990b8d048743040db27d4e8e29e78144aa3";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeAppreciate"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeAppreciate"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
        
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }
}
-(IBAction)viewAllMindFullNessButtonPressed:(id)sender{
    WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
    controller.isNotFromHome = YES;
    controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:59],@"TagID",@"Mindfulness",@"EventTagName", nil];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)viewAllMeditationButtonPressed:(id)sender{
    WebinarListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarListView"];
    controller.isNotFromHome = YES;
    controller.selectedFilterDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:33],@"TagID",@"Meditation",@"EventTagName", nil];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)quoteGalleryButtonPressed:(id)sender{
    QuoteGalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteGalleryView"];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == mindfulnessTable) {
        return webinarList.count;
    }else
        return meditationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
     if (tableView == mindfulnessTable) {
         NSString *CellIdentifier =@"MindFullNessTableViewCell";
         MindFullNessTableViewCell *cell = (MindFullNessTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         // Configure the cell...
         if (cell == nil) {
             cell = [[MindFullNessTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         cell.mindfullLabel.text = [[webinarList objectAtIndex:indexPath.row]objectForKey:@"EventName"];
         NSLog(@"==%@",cell.mindfullLabel.text);
         tableCell =cell;
     }else{
         NSString *CellIdentifier =@"MeditationTableViewCell";
         MeditationTableViewCell *cell1 = (MeditationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
         // Configure the cell...
         if (cell1 == nil) {
             cell1 = [[MeditationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         cell1.meditationLabel.text = [[meditationList objectAtIndex:indexPath.row]objectForKey:@"EventName"];
       
         tableCell = cell1;
     }
    
    return tableCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        if (contentView) {
//            [contentView removeFromSuperview];
//        }
        //contentView = [Utility activityIndicatorView:self];
    NSDictionary *webinarsData;
    if (tableView == mindfulnessTable) {
       webinarsData = [webinarList objectAtIndex:indexPath.row];
    }else{
       webinarsData = [meditationList objectAtIndex:indexPath.row];
    }
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
                        dispatch_async(dispatch_get_main_queue(), ^{
                            PodcastViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Podcast"];
                            controller.urlString = urlString;
                            [self.navigationController pushViewController:controller animated:YES];
                        });
                    }
                }
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
                controller.webinar = [webinarsData mutableCopy];
                [self.navigationController pushViewController:controller animated:YES];
              });
        }
    
}

@end
