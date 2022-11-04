//
//  ConnectViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 07/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "ConnectViewController.h"
#import "ConnectTableViewCell.h"
#import "ChannelListViewController.h"
#import "FBForumViewController.h"
#import "CalendarViewController.h"
#import "ForumViewController.h"

//chayan : import
#import "Utility.h"


@interface ConnectViewController () {
    IBOutlet UITableView *connectTableView;
    IBOutlet NSLayoutConstraint *connectTableViewHeightConstraint;
    IBOutlet UIView *cityView;
    IBOutlet UIButton *cityButton;      //ah ux
    IBOutlet UIButton *localButton;
    IBOutlet UIView *localView;
    //ah ux
    //Chayan
    IBOutlet UIButton *helpButton;
    IBOutletCollection(UIButton) NSArray *actionButtons;
    IBOutlet UIButton *discoverableButton;
    IBOutlet UILabel *discoverLabel;
    NSMutableArray *listArray;
    int apiCount;
    UIView *contentView;
    
    IBOutlet UIView *headerContainerView;
    IBOutletCollection(UIView) NSArray *viewsNeedToRestrict;

    __weak IBOutlet UIView *blankView;
    BOOL isFirstLoad;
}

@end

@implementation ConnectViewController
@synthesize fromTodayPage;
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;
    // Do any additional setup after loading the view.
    if (fromTodayPage) {
        blankView.hidden = false;
    }else{
        blankView.hidden = true;
    }
//    blankView.hidden = false;
    listArray = [[NSMutableArray alloc]init];
    localView.hidden = true;
    cityView.hidden = true;
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if(!isFirstLoad && _redirectBackToTodayPage){
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    BOOL isLiteUser = [Utility isSquadLiteUser];
    BOOL isFreeUser = [Utility isSquadFreeUser];
    
    for(UIView *view in viewsNeedToRestrict){
        if(isLiteUser || isFreeUser)    {
            
            if([view.accessibilityHint isEqualToString:@"worldforum"]){
                view.alpha = 1.0;
            }else{
                if((isLiteUser || isFreeUser) && ([view.accessibilityHint isEqualToString:@"findafriend"] || [view.accessibilityHint isEqualToString:@"ashyyoutube"] || [view.accessibilityHint isEqualToString:@"messages"])){
                    view.alpha = 1.0;
                }else{
                    view.alpha = 0.5;
                }
            }
            
        }else{
            view.alpha = 1.0;
        }
    }
    
    
    if ([defaults objectForKey:@"Discoverable"] && ![[defaults objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Discoverable"] caseInsensitiveCompare:@"no"] == NSOrderedSame) {
        discoverableButton.selected = false;
        discoverLabel.text = @"Not discoverable";
        
    } else if ([defaults objectForKey:@"Discoverable"] && ![[defaults objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Discoverable"] caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
        discoverableButton.selected = true;
        discoverLabel.text = @"Discoverable";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup

    }
    //ADDFIREBASE
    [FIRAnalytics logEventWithName:@"select_content" parameters:@{@"screen_name":@"Connect"
                                                                  }];
    [self getConnectInfo];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //chayan
    
    [listArray removeAllObjects];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
    [dict1 setObject:@"FIND A SQUAD MEMBER" forKey:@"label"];
    [dict1 setObject:@"mapPoint.png" forKey:@"image"];
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setObject:@"Watch Ashy LIVE" forKey:@"label"];
    [dict2 setObject:@"live.png" forKey:@"image"];
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setObject:@"ASHY's YOUTUBE Channel" forKey:@"label"];
    [dict3 setObject:@"raw.png" forKey:@"image"];
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
    [dict4 setObject:@"Ashy Bines Snapchat" forKey:@"label"];
    [dict4 setObject:@"snapchat.png" forKey:@"image"];
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]init];
    [dict5 setObject:@"Forum List" forKey:@"label"];
    [dict5 setObject:@"forum.png" forKey:@"image"];
    [listArray addObject:dict1];
    [listArray addObject:dict2];
    [listArray addObject:dict3];
    [listArray addObject:dict4];
    [listArray addObject:dict5];

    [connectTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        connectTableViewHeightConstraint.constant = connectTableView.contentSize.height;
    });
    
    
//    if(!_redirectBackToTodayPage){
//        if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeConnect"] boolValue]) {
//            [self animateHelp];
//        }
//        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
//            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
//            if (![insArray containsObject:@"Connect"]) {
//                //[self helpButtonPressed:helpButton];
//                [self showInstructionOverlays];
//                [insArray addObject:@"Connect"];
//                [defaults setObject:insArray forKey:@"InstructionOverlays"];
//            }
//        }else {
//            //[self helpButtonPressed:helpButton];
//            [self showInstructionOverlays];
//            NSMutableArray *insArray = [[NSMutableArray alloc] init];
//            [insArray addObject:@"Connect"];
//            [defaults setObject:insArray forKey:@"InstructionOverlays"];
//        }
//    }
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    blankView.hidden = true;
    fromTodayPage = false;
    isFirstLoad = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Datasource & Delegate

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//
//    return listArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{ //add_discover
//    NSString *CellIdentifier =@"ConnectTableViewCell";
//    ConnectTableViewCell *cell = (ConnectTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    // Configure the cell...
//    if (cell == nil) {
//        cell = [[ConnectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    cell.listImageView.image = [UIImage imageNamed:[[listArray objectAtIndex:indexPath.row] objectForKey:@"image"]];
//    cell.listLabel.text= [[listArray objectAtIndex:indexPath.row] objectForKey:@"label"];
//
//    if (indexPath.row == 0) {
//        cell.listLabel.textColor = [Utility colorWithHexString:@"F427AB"];
//        cell.discoveablelabel.hidden = false;
//
//        if ([defaults objectForKey:@"Discoverable"] && ![[defaults objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Discoverable"] caseInsensitiveCompare:@"no"] == NSOrderedSame) {
//            cell.discoverableButton.selected = false;
//            cell.discoveablelabel.text = @"Not discoverable";
//
//        } else if ([defaults objectForKey:@"Discoverable"] && ![[defaults objectForKey:@"Discoverable"] isEqual:[NSNull null]] && [[defaults objectForKey:@"Discoverable"] caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
//             cell.discoverableButton.selected = true;
//            cell.discoveablelabel.text = @"Discoverable";
//        }
//    }else{
//        cell.discoverableButton.hidden = true;
//        cell.discoveablelabel.hidden = true;
//    }
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    //faf
//    if (indexPath.row == 0) {
//      // [Utility msg:@"Coming on March 20." title:@"Alert" controller:self haveToPop:NO];
//
//    } else if (indexPath.row == 1) {
//
//
//    }else if (indexPath.row == 2) {
//
//    }else if (indexPath.row == 3) {
//
//    }else if (indexPath.row == 4) {
//        //chayan
//        ForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Forum"];
//        [self.navigationController pushViewController:controller animated:YES];
//
//    }
//}
//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
//#pragma mark - End -

#pragma mark - Private Method
//add_discover
#pragma mark -APICall
-(void)sendDiscoverableStatus:(BOOL)isDiscoverable {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];//@"3269"
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
        [mainDict setObject:[NSNumber numberWithBool:isDiscoverable] forKey:@"Discoverable"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UserSettings" append:@"" forAction:@"POST"];
        
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
                                                                         NSLog(@"Disc %@",responseDictionary);
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
//
-(void)getConnectInfo{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetConnectInfoApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && responseDict[@"SuccessFlag"]) {
                                                                         NSDictionary *userDetail =responseDict[@"UserDetail"];
                                                                         if (![Utility isEmptyCheck:userDetail]) {
                                                                             [defaults setObject:[userDetail valueForKey:@"FbWorldForumUrl"] forKey:@"FbWorldForumUrl"];
                                                                             [defaults setObject:[userDetail valueForKey:@"FbCityForumUrl"] forKey:@"FbCityForumUrl"];
                                                                             [defaults setObject:[userDetail valueForKey:@"FbSuburbForumUrl"] forKey:@"FbSuburbForumUrl"];
                                                                             [defaults setObject:userDetail forKey:@"UserCountryCity"];
                                                                             [self updateView];

                                                                         }else{
                                                                             NSLog(@"Something is wrong.Please try later.");
                                                                             [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                         
                                                                     }else{
                                                                         [Utility msg:responseDict[@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
-(void)updateView{
    //ah ux
    if (![Utility isEmptyCheck:[defaults dictionaryForKey:@"UserCountryCity"]]) {
        NSDictionary *userDict = [defaults dictionaryForKey:@"UserCountryCity"];
        if ([Utility isEmptyCheck:[userDict objectForKey:@"SubrubName"]] || [Utility isEmptyCheck:[userDict objectForKey:@"SubrubId"]]){
            localButton.hidden = true;
            localView.hidden = true;
            //[cityButton setBackgroundImage:[UIImage imageNamed:@"city_large.png"] forState:UIControlStateNormal];
        }
    }else{
        localView.hidden = true;
        cityView.hidden = true;
    }
    //end
}
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

#pragma mark - End

#pragma mark - IBAction

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

-(IBAction)discoverableButtonPressed:(UIButton*)sender{ //add_discover
    /*if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }*/
    
    if (sender.selected) {
        discoverableButton.selected = false;
        [defaults setObject:@"no" forKey:@"Discoverable"];
        discoverLabel.text = @"Not discoverable";
        [self sendDiscoverableStatus:NO];
    }else{
        discoverableButton.selected = true;
        [defaults setObject:@"yes" forKey:@"Discoverable"];
        discoverLabel.text = @"Discoverable";
        [self sendDiscoverableStatus:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
        
    }
    [defaults synchronize];
   
}

//chayan : questionHelpButtonPressed
- (IBAction)helpButtonPressed:(id)sender {
    
    NSString *urlString=@"https://player.vimeo.com/external/220932517.m3u8?s=dd3882bb52f88673c33ff600b24bfc55684011de";
    
    if ([[[defaults objectForKey:@"firstTimeHelpDict"] valueForKey:@"isFirstTimeConnect"] boolValue]) {
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:YES];
        NSMutableDictionary *dict=[[defaults objectForKey:@"firstTimeHelpDict"] mutableCopy];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isFirstTimeConnect"];
        [defaults setObject:dict forKey:@"firstTimeHelpDict"];
        
        
    }
    else{
        [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
    }

//    //chayan
//    ForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Forum"];
//    [self.navigationController pushViewController:controller animated:YES];

}

-(IBAction)findASquadMemberButtonPressed:(id)sender{
    
    
}
-(IBAction)watchAshyLiveButtonPressed:(id)sender{
    
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    CalendarViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Calendar"];
    controller.isFromAshyLive = true;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)rawRealitySeriesButtonPressed:(id)sender{
    /*if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }*/
    ChannelListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChannelList"];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)ashyBinesSnapChatButtonPressed:(id)sender{
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    NSURL *url = [NSURL URLWithString:@"snapchat://chat/Ashybines1"];
    if ([[UIApplication sharedApplication] openURL:url]){
        NSLog(@"well done");
    }
    else {
        url = [NSURL URLWithString:@"https://snapchat.com/add/Ashybines1:"];
        [[UIApplication sharedApplication] openURL:url];
    }
}
-(IBAction)squadPersonalInterestForum:(id)sender{
    if([Utility isSquadLiteUser]){
        [Utility showSubscribedAlert:self];
        return;
    }else if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    [Utility msg:@"Coming in December 2018" title:@"Alert" controller:self haveToPop:NO];
    /*
    ForumViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Forum"];
    [self.navigationController pushViewController:controller animated:YES];
     */
}

-(IBAction)messagesButtonPressed:(id)sender{
    
    
}

-(IBAction)fbForumButtonPressed:(UIButton *)sender{     //ah ux
    if ([defaults boolForKey:@"isFirstTimeForum"]) {
        [defaults setBool:NO forKey:@"isFirstTimeForum"];
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Please Note"
                                              message:@"If you haven’t already joined your forum, please know it can take up to 48 hours to be approved to your Squad Forum, make sure your request to join the fb group and then wait to be accepted"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self fbForumButtonPressedWithSender:sender];
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self fbForumButtonPressedWithSender:sender];
    }
}
-(void) fbForumButtonPressedWithSender:(UIButton *)sender {     //ah ux
    NSString *urlString = @"";
    if (sender.tag == 0) {
        urlString = [defaults objectForKey:@"FbWorldForumUrl"];//https://www.facebook.com/groups/250625228700325/
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSString *ReferenceEntityId = [df stringFromDate:[NSDate date]];
        NSMutableDictionary *dataDict = [NSMutableDictionary new];
        [dataDict setObject:[NSNumber numberWithInt:2] forKey:@"UserActionId"];
        if(ReferenceEntityId)[dataDict setObject:ReferenceEntityId forKey:@"ReferenceEntityId"];
        [dataDict setObject:@"WorldForum" forKey:@"ReferenceEntityType"];
        
        [Utility addGamificationPointWithData:dataDict];
        
    }else if (sender.tag == 1) {
        urlString = [defaults objectForKey:@"FbCityForumUrl"];
        
    }else if (sender.tag == 3) {
        urlString = [defaults objectForKey:@"FbSuburbForumUrl"];
    }
    if (![Utility isEmptyCheck:urlString]) {
        NSString *substractString =[urlString stringByReplacingOccurrencesOfString:@"https://www.facebook.com/groups" withString:@"fb://profile"];
        NSLog(@"%@\n %@",urlString,substractString);
        NSURL *url = [NSURL URLWithString:substractString];
        if ([[UIApplication sharedApplication] openURL:url]){
            NSLog(@"well done");
        }
        else {
            url = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}

#pragma mark - End
- (void) showInstructionOverlays {
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    overlayViews = [@[@{
                          @"view" : headerContainerView,
                          @"onTop" : @NO,
                          @"insText" :  @"Click here for tools and tips to get the most out of the CONNECT section",
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

//- (void) showInstructionOverlays {
//    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
//    NSArray *messageArray = @[
//                              @"Click here for tools and tips to get the most out of the CONNECT section."
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

#pragma mark - End


#pragma mark - Location Manager Delegate Methods -


@end





