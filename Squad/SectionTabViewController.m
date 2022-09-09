//
//  SectionTabViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 06/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "SectionTabViewController.h"
#import "AddVisionBoardViewController.h"
#import "HabitHackerListViewController.h"
#import "HabitHackerFirstViewController.h"
#import "MeditationRewardViewController.h"
@interface SectionTabViewController (){
    IBOutlet UICollectionView *tabCollection;
    IBOutlet UIButton *leftDot;
    IBOutlet UIButton *rightDot;
    IBOutlet UIView *legendView;
    UIView *contentView;
    NSArray *navArray;
    int currentPosition;
    NSString *sectionName;
    NSString *str;
    BOOL fromMenu;
}

@end


@implementation SectionTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentPosition = 0;
    sectionName = @"";
    [tabCollection setScrollEnabled:false];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //TODO: set viewwillappear and TableDidSelect for tab customisation.
    legendView.hidden = true;
    //arr = @[@"GOALS",@"ACTIONS",@"HABIT SWAP",@"VISION",@"CHALLENGES",@"BUCKET LIST", @"AFFIRMATIONS", @"VISION"];

    UIViewController *controller = self.parentViewController;
    //Goal[Achievement]
    
    if ([controller isKindOfClass:[HabitHackerListViewController class]]) {//HabitHackerListViewController
        currentPosition = 0;
        sectionName = @"Achieve";
    }else if ([controller isKindOfClass:[AddVisionBoardViewController class]]) {
//        currentPosition = 1;
//        sectionName = @"Achieve";
    }  else if ([controller isKindOfClass:[BucketListNewViewController class]]) {
        currentPosition = 1;
        sectionName = @"Achieve";
    }
    /*
    else if ([controller isKindOfClass:[VisionGoalActionViewController class]]) {
        currentPosition = 3;
        sectionName = @"Achieve";
    }else if ([controller isKindOfClass:[PersonalChallengeViewController class]]) {
        currentPosition = 4;
        sectionName = @"Achieve";
    }else if ([controller isKindOfClass:[AccountabilityBuddyHomeViewController class]]) {
        currentPosition = 5;
        sectionName = @"Achieve";
    } else if ([controller isKindOfClass:[BucketListNewViewController class]]) {
        currentPosition = 6;
        sectionName = @"Achieve";
    }
    else if ([controller isKindOfClass:[BucketListNewViewController class]]) {
        currentPosition = 7;
        sectionName = @"Achieve";
    }
*/
    //Appreciate
    else if ([controller isKindOfClass:[GratitudeListViewController class]]) {
        currentPosition = 0;
        sectionName = @"Appreciate";
    }
//    else if ([controller isKindOfClass:[AchievementsViewController class]]) {
//        currentPosition = 1;
//        sectionName = @"Appreciate";
//    }
    ////////RU***
    else if ([controller isKindOfClass:[AchievementsViewController class]]) {
        currentPosition = 1;
        sectionName = @"Appreciate";
    }
    else if ([controller isKindOfClass:[WebinarListViewController class]]) {
        currentPosition = 2;
        sectionName = @"Appreciate";
    }else if ([controller isKindOfClass:[QuoteGalleryViewController class]]) {
//        currentPosition = 3;
//        sectionName = @"Appreciate";
    }
    
   //Learn
    else if ([controller isKindOfClass:[CoursesListViewController class]]) {
        currentPosition = 0;
        sectionName = @"Learn";
    }
    else if ([controller isKindOfClass:[QuestionnaireHomeViewController class]]) {
        currentPosition = 1;
        sectionName = @"Learn";
    }
   // Courses
    else if ([controller isKindOfClass:[CommunityViewController class]]) {
        currentPosition = 0;
        sectionName = @"Community";
    }
//    else if ([controller isKindOfClass:[CoursesListViewController class]]) {
//        currentPosition = 1;
//        sectionName = @"Courses";
//    }else if ([controller isKindOfClass:[WebinarListViewController class]]) {
//        currentPosition = 2;
//        sectionName = @"Courses";
//    }else if ([controller isKindOfClass:[PersonalChallengeViewController class]]) {
//        currentPosition = 3;
//        sectionName = @"Courses";
//    }
    
    //Reward
     else if ([controller isKindOfClass:[GamificationViewController class]]) {
         currentPosition = 0;
         sectionName = @"Reward";
     }
     else if ([controller isKindOfClass:[MeditationRewardViewController class]]) {
         currentPosition = 1;
         sectionName = @"Reward";
     }
    
    
    navArray = [self makeArray];
    [tabCollection reloadData];
    
    [tabCollection addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    
    if([sectionName isEqualToString:@"Achieve"] || [sectionName isEqualToString:@"Appreciate"] || [sectionName isEqualToString:@"Learn"] || [sectionName isEqualToString:@"Reward"]){
        leftDot.hidden = true;
        rightDot.hidden = true;
    }else{
        leftDot.hidden = false;
        rightDot.hidden = false;
    }
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tabFooterNavigation:) name:@"tabFooterNavigation" object:nil];
}
-(void)viewDidLayoutSubviews{
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    UIViewController *controller = self.parentViewController;
//
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
//    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
//    [controller.view addGestureRecognizer:swipeLeft];
//
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(didSwipe:)];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [controller.view addGestureRecognizer:swipeRight];
    
    
    tabCollection.hidden = true;
    [tabCollection setContentOffset:CGPointZero animated:YES];
    tabCollection.hidden = false;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    @try {
        [tabCollection removeObserver:self forKeyPath:@"contentSize"];
    } @catch (NSException *exception) {
        //
    }
//    @try {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tabFooterNavigation" object:nil];
//    } @catch (NSException *exception) {
//        //
//    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if(object == tabCollection){
        CGFloat totalWidth = tabCollection.contentSize.width;
        CGFloat xOffset = tabCollection.contentOffset.x;
        if (xOffset > 0) {
            leftDot.hidden = false;
        }else{
            leftDot.hidden = true;
        }
        if (totalWidth - xOffset - tabCollection.frame.size.width > 0) {
            rightDot.hidden = false;
        }else{
            rightDot.hidden = true;
        }
        
    }
     UIViewController *controller = self.parentViewController;
    if([controller isKindOfClass:[VisionGoalActionViewController class]]){
        leftDot.hidden = true;
    }
    
    if([sectionName isEqualToString:@"Achieve"] || [sectionName isEqualToString:@"Appreciate"]|| [sectionName isEqualToString:@"Learn"] || [sectionName isEqualToString:@"Reward"]){
        leftDot.hidden = true;
        rightDot.hidden = true;
    }else{
        leftDot.hidden = false;
        rightDot.hidden = false;
    }
}
- (void)didSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
        return;
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (currentPosition == navArray.count-1) {
            return;
        }
        [self collectionView:tabCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPosition+1 inSection:0]];
    } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if (currentPosition == 0) {
            return;
        }
        [self collectionView:tabCollection didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:currentPosition-1 inSection:0]];
    }
}
#pragma mark - IBAction -
-(IBAction)headerFooterPressed:(UIButton *)sender{
//    float cellWidth = tabCollection.visibleCells[0].bounds.size.width * tabCollection.visibleCells.count;
//
    float cellWidth = tabCollection.bounds.size.width;

    @try {
        if (sender.tag == 0) {//header
            float contentOffset = (float)(floor(tabCollection.contentOffset.x - cellWidth));
            [self moveCollectionViewToFrame:contentOffset];
        } else if (sender.tag == 1) {//footer
            float contentOffset = (float)(floor(tabCollection.contentOffset.x + cellWidth));
            [self moveCollectionViewToFrame:contentOffset];
        }
        [tabCollection reloadData];
    } @catch (NSException *exception) {
//        NSLog(@"%@",exception.debugDescription);
    }
}

- (void)moveCollectionViewToFrame:(CGFloat)contentOffset{
    CGRect frame = CGRectMake(contentOffset, tabCollection.contentOffset.y, tabCollection.frame.size.width, tabCollection.frame.size.height);
    [tabCollection scrollRectToVisible:frame animated:NO];
}
- (IBAction)legendButtonPressed:(UIButton *)sender {
    LegendViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Legend"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self.parentViewController presentViewController:controller animated:YES completion:nil];
}
#pragma mark - End
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGRect screenRect = [[UIScreen mainScreen] bounds];//;/tabCollection.frame
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 2;
    return CGSizeMake(cellWidth,45.0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0,0,0,0);
}
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return navArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SectionCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SectionCollectionViewCell alloc]init];
    }
    if (![Utility isEmptyCheck:navArray] && navArray.count > indexPath.row) {
        cell.nameLabel.text = [@"" stringByAppendingFormat:@"%@", [navArray objectAtIndex:indexPath.row]];
      
        if (currentPosition == indexPath.row) {
            cell.nameLabel.textColor = [Utility colorWithHexString:mbhqBaseColor];//255
            cell.nameLabel.backgroundColor = [UIColor whiteColor];
            cell.nameLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:14];
        } else {
            cell.nameLabel.textColor = [UIColor blackColor];//245
            cell.nameLabel.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            cell.nameLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:14];
        }
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //TODO: handle tab click.
//    if ([Utility checkForFirstDailyWorkout:self.parentViewController]) {
//        return;
//    }
    if (currentPosition == indexPath.row) {
        return;
    }
    fromMenu = false;
    [self didTabSelect:indexPath.row parent:self.parentViewController];
    
}

#pragma mark - Private Function -
-(NSArray *)makeArray{
    NSArray *arr;
    if ([sectionName caseInsensitiveCompare:@"Achieve"] == NSOrderedSame) {
        [defaults setObject:[NSNumber numberWithInteger:currentPosition] forKey:@"AchievePosition"];
        //arr = @[@"GOALS",@"ACTIONS",@"HABIT SWAP",@"VISION",@"CHALLENGES",@"BUCKET LIST", @"AFFIRMATIONS", @"VISION"];
           arr = @[@"HABIT LIST",@"BUCKET LIST"];
              //arr = @[@"HABIT HACKER",@"FUTURE YOU",@"BUCKET LIST"];
        //@[@"HABIT SWAP",@"GOALS",@"VISION",@"ACTIONS",@"CHALLENGES",@"ACCOUNTABILITY BUDDIES", @"BUCKET LIST", @"AFFIRMATIONS"]
        
    } else if ([sectionName caseInsensitiveCompare:@"Appreciate"] == NSOrderedSame) {
        [defaults setObject:[NSNumber numberWithInteger:currentPosition] forKey:@"AppreciatePosition"];
        arr = @[@"GRATITUDE", @"EQ JOURNAL"];//@[@"GRATITUDE", @"GROWTH"]; //@[@"GRATITUDE", @"GROWTH", @"MEDITATIONS"];
//        arr = @[@"GRATITUDE", @"GROWTH", @"MEDITATIONS",@"QUOTE\nGALLERY"];
    } else if ([sectionName caseInsensitiveCompare:@"Learn"] == NSOrderedSame) {
        [defaults setObject:[NSNumber numberWithInteger:currentPosition] forKey:@"LearnPosition"];
        arr = @[@"COURSES", @"TESTS"];
//        arr = @[@"PROGRAMS", @"TESTS"];
//        arr = @[@"COURSES", @"QUESTIONNAIRES"];
    } else if ([sectionName caseInsensitiveCompare:@"Community"] == NSOrderedSame) {
        [defaults setObject:[NSNumber numberWithInteger:currentPosition] forKey:@"CommunityPosition"];
        arr = @[@"Community"];
    }else if ([sectionName caseInsensitiveCompare:@"Reward"] == NSOrderedSame) {
        [defaults setObject:[NSNumber numberWithInteger:currentPosition] forKey:@"RewardPosition"];
        arr = @[@"GRATITUDE", @"MEDITATION"];
//        arr = @[@"PROGRAMS", @"TESTS"];
//        arr = @[@"COURSES", @"QUESTIONNAIRES"];
    }
    
    return arr;
}
-(BOOL)haveToPushViewController:(UIViewController *)myController parent:(UIViewController *)parent{
    BOOL push = true;
    NSArray *controllers = parent.navigationController.viewControllers;
    NSMutableArray *tempControllers = [NSMutableArray new];
    NSMutableArray *uniqueController = [NSMutableArray new];
    for (UIViewController *controller in [controllers reverseObjectEnumerator]) {
        NSString *stringVC = NSStringFromClass([controller class]);
        if (![tempControllers containsObject:stringVC]) {
            [tempControllers addObject:stringVC];
            [uniqueController addObject:controller];
        }
    }
    controllers = [[uniqueController reverseObjectEnumerator] allObjects];
    parent.navigationController.viewControllers = controllers;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[myController class]]) {
            push = false;
            NSArray *poppedViewController = [parent.navigationController popToViewController:controller animated:YES];
            NSMutableArray *customNav = [controller.navigationController.viewControllers mutableCopy];
//            [customNav addObjectsFromArray:poppedViewController];
            for (UIViewController *view in poppedViewController) {
                [customNav insertObject:view atIndex:(customNav.count - 1)];
            }
            controller.navigationController.viewControllers = customNav;
            break;
        }
    }
    return push;
}
#pragma mark - End

#pragma mark - API Call -
-(void) getDailyData:(UIViewController *)parent{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:parent];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:parent haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetDailyMealList" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:parent haveToPop:NO];
                                                                         } else {
                                                                             NSMutableArray *responseArray = [NSMutableArray new];
                                                                             [responseArray addObjectsFromArray:[responseDictionary objectForKey:@"List"]];
                                                                             [self mealOfTheDay:responseArray dateListDict:[NSMutableDictionary new]parent:parent];
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:parent haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:parent haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:parent haveToPop:NO];
    }
    
}
-(void) mealOfTheDay:(NSMutableArray *)responseArray dateListDict:(NSMutableDictionary *)dateListDict parent:(UIViewController *)parent{
    for (int i = 0; i < responseArray.count; i++) {
        NSString *dateStr = [[responseArray objectAtIndex:i] objectForKey:@"MealDate"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* components = [calendar components:NSCalendarUnitMonth fromDate:dailyDate]; // Get necessary date components
        
        NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:dailyDate]; // Get necessary date components
        
        
        
        NSInteger monthIndex = [components month]; //gives you month
        
        NSInteger yearIndex = [yearComponents year]; //gives you year
        
        NSString *keyName;
        
        if (monthIndex > 9){
            
            keyName= [@"" stringByAppendingFormat:@"%ld-%ld",yearIndex,monthIndex];
            
        }else{
            
            keyName= [@"" stringByAppendingFormat:@"%ld-0%ld",yearIndex,monthIndex];
            
        }
        
        if (![Utility isEmptyCheck:dateListDict]) {
            
            NSArray *keys = [dateListDict allKeys];
            
            if ([keys containsObject:keyName]) { //[NSNumber numberWithInteger:monthIndex]
                
                NSMutableArray *newArr = [[NSMutableArray alloc]init];
                
                [newArr addObjectsFromArray:[dateListDict objectForKey:keyName]];
                
                [newArr addObject:[responseArray objectAtIndex:i]];
                
                [dateListDict removeObjectForKey:keyName];
                
                [dateListDict setObject:newArr forKey:keyName];
                
            } else {
                
                NSMutableArray *newArr = [[NSMutableArray alloc]init];
                
                [newArr addObject:[responseArray objectAtIndex:i]];
                
                [dateListDict setObject:newArr forKey:keyName];
                
            }
            
        } else {
            
            NSMutableArray *newArr = [[NSMutableArray alloc]init];  //ah ah
            
            [newArr addObject:[responseArray objectAtIndex:i]];
            
            [dateListDict setObject:newArr forKey:keyName];
            
            //            [dateListDict setObject:[responseArray objectAtIndex:i] forKey:monthName];
            
        }
    }
    
    NSArray *keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    for (int i = 0; i < keys.count; i++) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        arr = [dateListDict objectForKey:[keys objectAtIndex:i]];
        for (int j = 0; j < arr.count; j++) {
            if ([[arr objectAtIndex:j] isKindOfClass:[NSDictionary class]]) {
                [arr1 addObject:[arr objectAtIndex:j]];
            }
            NSLog(@"j %d",j);
        }
        [dateListDict removeObjectForKey:[keys objectAtIndex:i]];
        [dateListDict setObject:arr1 forKey:[keys objectAtIndex:i]];
    }
    NSLog(@"dla %@",dateListDict);
    
    keys = [dateListDict allKeys];
    //    [[keys mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    keys = [keys sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortDescriptor]];
    
    NSArray *arr = [dateListDict objectForKey:[keys objectAtIndex:0]];//section
    NSDictionary *dateDict = [arr objectAtIndex:0];//rew
    if (![Utility isEmptyCheck:dateDict]) {
        NSLog(@"%@",dateDict);
        NSString *dateStr = [dateDict objectForKey:@"MealDate"];
        NSArray *dateArr = [dateStr componentsSeparatedByString:@"T"];
        dateStr = [dateArr objectAtIndex:0];
        
        NSDateFormatter *dailyDateformatter = [[NSDateFormatter alloc]init];
        [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dailyDate = [dailyDateformatter dateFromString:dateStr];
        [dailyDateformatter setDateFormat:@"dd MM yyyy"];
        //    endDateLabel.text = [dailyDateformatter stringFromDate:endDate];      2017-01-18T08:28:50.7138494+00:00
        
        NSString *suffix = @"";
        if (![dailyDate isEqual:[NSNull null]]) {
            suffix = [Utility daySuffixForDate:dailyDate];
        }
        
        [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"DailyGoodnessDetail",@"mealId":[dateDict objectForKey:@"MealId"],@"dateString":[dailyDateformatter stringFromDate:dailyDate],@"fromController":@"Meal",@"showTab":@true}];
//        DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
//        controller.mealId = [dateDict objectForKey:@"MealId"];
//        controller.dateString = [dailyDateformatter stringFromDate:dailyDate];
//        controller.fromController = @"Meal";    //ah ux
//        controller.showTab = true;
//        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
#pragma mark - End

-(void)didSwipe:(NSInteger)trgtTab parent:(UIViewController *)parent sectionName:(NSString*)sectionName{
    if (!parent) {
        parent = self.parentViewController;
    }
    if ([sectionName caseInsensitiveCompare:@"Achieve"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[HabitHackerListViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"HabitHackerListView"}];
        }

        else if (trgtTab == 1) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[BucketListNewViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"BucketListNew"}];
        }

    } else if ([sectionName caseInsensitiveCompare:@"Appreciate"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if ([Utility reachable]) {
                 if([Utility isSquadFreeUser]){
                   [Utility showAlertAfterSevenDayTrail:parent];
                   return;
               }
               if (![self haveToPushViewController:(UIViewController *)[GratitudeListViewController class]parent:parent]) {
                   return;
               }
               [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"GratitudeListView"}];
            }else{
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[TodayHomeViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"TodayHome"}];
            }

        }
        else if (trgtTab == 1) {
            if ([Utility reachable]) {
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[AchievementsViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"Achievements"}];
            }else{
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[TodayHomeViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"TodayHome"}];
            }
            
        }
        
        else if (trgtTab == 2) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]){
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"WebinarListView",@"TagID":@"33"}];
                return;
            }
            
            if (![self haveToPushViewController:(UIViewController *)[WebinarListViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"WebinarListView",@"TagID":@"33"}];
        }else if (trgtTab == 3) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[QuoteGalleryViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"QuoteGalleryView"}];
        }
    } else if ([sectionName caseInsensitiveCompare:@"Learn"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]){
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CoursesList"}];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[CoursesListViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CoursesList"}];
        }else if (trgtTab == 1) {
            if (![self haveToPushViewController:(UIViewController *)[QuestionnaireHomeViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"QuestionnaireHomeView"}];
        }
    } else if ([sectionName caseInsensitiveCompare:@"Community"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if (![self haveToPushViewController:(UIViewController *)[CommunityViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CommunityView"}];
        }
    }else if ([sectionName caseInsensitiveCompare:@"Reward"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[GamificationViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"GamificationView"}];
        }else if (trgtTab == 1) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[MeditationRewardViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"MeditationReward"}];
        }
    }
}

-(void)didTabSelect:(NSInteger)trgtTab parent:(UIViewController *)parent{
    if (!parent) {
        parent = self.parentViewController;
    }
    if ([sectionName caseInsensitiveCompare:@"Achieve"] == NSOrderedSame) {
//        @[@"GOALS",@"ACTIONS",@"HABIT SWAP",@"VISION",@"CHALLENGES",@"BUCKET LIST", @"AFFIRMATIONS"]
        if (trgtTab == 0) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[HabitHackerListViewController class]parent:parent]) {
                return;//HabitHackerListViewController
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"HabitHackerListView"}];//HabitHackerListView
        }
//        else if (trgtTab == 1){
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[AddVisionBoardViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"AddVisionBoard"}];
//        }
        else if (trgtTab == 1) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[BucketListNewViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"BucketListNew"}];
        }
//        else if (trgtTab == 3) {
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[VisionGoalActionViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"VisionGoalAction"}];
//        } else if (trgtTab == 4) {
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[PersonalChallengeViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"PersonalChallenge"}];
//        }
//        else if (trgtTab == 5) {
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[AccountabilityBuddyHomeViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"AccountabilityBuddyHomeView"}];
//        }
//        else if (trgtTab == 6) {
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[BucketListNewViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"BucketListNew"}];
//        } else if (trgtTab == 7) {
//            if([Utility isSquadFreeUser]){
//                [Utility showAlertAfterSevenDayTrail:parent];
//                return;
//            }
//            if (![self haveToPushViewController:(UIViewController *)[BucketListNewViewController class]parent:parent]) {
//                return;
//            }
//            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"BucketListNew"}];
//        }
    } else if ([sectionName caseInsensitiveCompare:@"Appreciate"] == NSOrderedSame) {
//              @[@"GRATITUDE", @"ACCOMPLISHMENTS", @"MEDITATIONS"]
        if (trgtTab == 0) {
            if ([Utility reachable]) {
                 if([Utility isSquadFreeUser]){
                   [Utility showAlertAfterSevenDayTrail:parent];
                   return;
               }
               if (![self haveToPushViewController:(UIViewController *)[GratitudeListViewController class]parent:parent]) {
                   return;
               }
               [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"GratitudeListView"}];
            }else{
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[TodayHomeViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"TodayHome"}];
            }
           

        }
        else if (trgtTab == 1) {
            if ([Utility reachable]) {
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[AchievementsViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"Achievements"}];
            }else{
                if([Utility isSquadFreeUser]){
                    [Utility showAlertAfterSevenDayTrail:parent];
                    return;
                }
                if (![self haveToPushViewController:(UIViewController *)[TodayHomeViewController class]parent:parent]) {
                    return;
                }
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"TodayHome"}];
            }
            
        }
        
        else if (trgtTab == 2) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]){
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"WebinarListView",@"TagID":@"33"}];
                return;
            }
            
            if (![self haveToPushViewController:(UIViewController *)[WebinarListViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"WebinarListView",@"TagID":@"33"}];
        }else if (trgtTab == 3) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[QuoteGalleryViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"QuoteGalleryView"}];
        }
    } else if ([sectionName caseInsensitiveCompare:@"Learn"] == NSOrderedSame) {
        //        arr = @[@"ALL", @"PHOTOS", @"MEASURE", @"QUESTIONNAIRE"];
        if (trgtTab == 0) {
            if (![Utility isEmptyCheck:[defaults objectForKey:@"RunningVideoSection"]]){
                [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CoursesList"}];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[CoursesListViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CoursesList"}];
        }else if (trgtTab == 1) {
            if (![self haveToPushViewController:(UIViewController *)[QuestionnaireHomeViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"QuestionnaireHomeView"}];
        }
    } else if ([sectionName caseInsensitiveCompare:@"Community"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if (![self haveToPushViewController:(UIViewController *)[CommunityViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"CommunityView"}];
        }
    }else if ([sectionName caseInsensitiveCompare:@"Reward"] == NSOrderedSame) {
        if (trgtTab == 0) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[GamificationViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"GamificationView"}];
        }else if (trgtTab == 1) {
            if([Utility isSquadFreeUser]){
                [Utility showAlertAfterSevenDayTrail:parent];
                return;
            }
            if (![self haveToPushViewController:(UIViewController *)[MeditationRewardViewController class]parent:parent]) {
                return;
            }
            [CustomNavigation startNavigation:parent fromMenu:fromMenu navDict:@{@"Identifier":@"MeditationReward"}];
        }
    }
    
}
#pragma mark - Footer Notification -
-(void)tabFooterNavigation:(UIViewController *)parent section:(NSString *)section frmMenu:(BOOL)frmMenu{
    NSString *trgtSection = section;
    if (![Utility isEmptyCheck:trgtSection]) {
        currentPosition = -1;
        sectionName = trgtSection;
        int currPos = 0;
        if ([sectionName caseInsensitiveCompare:@"Achieve"] == NSOrderedSame) {
            currPos = [[defaults objectForKey:@"AchievePosition"]intValue];
        } else if ([sectionName caseInsensitiveCompare:@"Appreciate"] == NSOrderedSame) {
            currPos = [[defaults objectForKey:@"AppreciatePosition"]intValue];
        } else if ([sectionName caseInsensitiveCompare:@"Learn"] == NSOrderedSame) {
            currPos = [[defaults objectForKey:@"LearnPosition"]intValue];
        } else if ([sectionName caseInsensitiveCompare:@"Community"] == NSOrderedSame) {
            currPos = [[defaults objectForKey:@"CommunityPosition"]intValue];
        }else if ([sectionName caseInsensitiveCompare:@"Reward"] == NSOrderedSame) {
            currPos = [[defaults objectForKey:@"RewardPosition"]intValue];
        }
        if (currPos<0) {
            currPos = 0;
        }
        fromMenu = frmMenu;
        [self didTabSelect:currPos parent:parent];
    }
}
#pragma mark - End
#pragma mark - Swipe navigation from footer -
-(void)tabSwipeNavigation:(UIViewController *)parent section:(NSString *)section position:(int)position frmMenu:(BOOL)frmMenu{
    NSString *trgtSection = section;
    if (![Utility isEmptyCheck:trgtSection]) {
        currentPosition = -1;
        sectionName = trgtSection;
        int currPos = position;
        if (currPos<0) {
            currPos = 0;
        }
        fromMenu = frmMenu;
        [self didTabSelect:currPos parent:parent];
    }
}
#pragma mark - End
@end
