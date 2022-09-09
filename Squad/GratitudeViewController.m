//
//  GratitudeViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 10/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "GratitudeViewController.h"
#import "GratitudeTableViewCell.h"
#import "GratitudeAddEditViewController.h"
#import "GratitudeDateCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomNutritionPlanListInnerCollectionViewCell.h"
#import "GratitudeListViewController.h"

@interface GratitudeViewController ()
{
    IBOutlet UIButton *headerCalenderButton;
    IBOutlet UIButton *headerHelpButton;
    IBOutlet UILabel *headerFirstLabel;
    IBOutlet UILabel *headerSecondLabel;
    IBOutlet UILabel *headerThirdLabel;
    
    IBOutlet UIStackView *gratitudestackView;
    IBOutlet UIView *videoView;
    IBOutlet UITableView *tableView;
    AVPlayer *videoPlayer;
    AVPlayerViewController *playerController;
    NSArray *gratitudeListArray;
    UIView *contentView;
    BOOL isExpand;
    NSArray *helpVideos;
    int helpVideoCount;
    BOOL shouldSetupRem;  //ah ln
    
    //Ru
    IBOutlet UICollectionView *dateCollection;
    NSArray *selectedAray;
    NSDate *selectedDate;
    IBOutlet UILabel *noDataLabel;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    NSDate *beginningOfWeek;
    NSDate *endOfWeek;
    IBOutlet UIButton *gratitudeListButton;
    NSArray *masterGratitudeList;
    NSString *selectedState;
}
@end

@implementation GratitudeViewController
@synthesize goalValueArray,exerciseSessionType,dailyWorkoutLists,delegate;

#pragma mark - IBAction
- (IBAction)addGratitudeButtonPressed:(UIButton*)sender
{
   dispatch_async(dispatch_get_main_queue(), ^{
//        NotesViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
//        controller.notesDelegate = self;
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        [self presentViewController:controller animated:NO completion:nil];
       
//           GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
////           controller.isEdit = true;
//           controller.isNewGratitude = true;
//           controller.gratitudeDelegate = self;
//           [self.navigationController pushViewController:controller animated:YES];
       
       DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
       controller.modalPresentationStyle = UIModalPresentationCustom;
       controller.dropdownDataArray = growthOptionArr;
       controller.apiType = @"Growth";
       if (![Utility isEmptyCheck:self->selectedState]) {
           controller.selectedIndex = (int)[growthOptionArr indexOfObject:self->selectedState];
       }else{
           controller.selectedIndex = -1;
       }
       controller.delegate = self;
       controller.sender = sender;
       [self presentViewController:controller animated:YES completion:nil];
       
   });

    
}
- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//Ru
- (IBAction)gratitudeListTapped:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    GratitudeListViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GratitudeListView"];
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Private Method

-(void)sizeHeaderToFit{
    UIView *headerView = tableView.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    tableView.tableHeaderView = headerView;
}
-(void) playVideoWithUrlStr:(NSString *)urlStr InsideView:(UIView *)playerView {
    if (playerController.player || videoPlayer) {
        [playerController.player pause];
        [videoPlayer pause];
        videoPlayer = nil;
        [playerController removeFromParentViewController];
    }
    NSURL *videoURL = [NSURL URLWithString:urlStr];
    
    [[AVAudioSession sharedInstance]
                setCategory: AVAudioSessionCategoryPlayback
                      error: nil];
    
    // create an AVPlayer
    videoPlayer = [AVPlayer playerWithURL:videoURL];
    // create a player view controller
    playerController = [[AVPlayerViewController alloc]init];
    playerController.player = videoPlayer;
    playerController.showsPlaybackControls = true;
    [videoPlayer play];
    
    // show the view controller
    [self addChildViewController:playerController];
    [playerView addSubview:playerController.view];
    playerController.view.frame = playerView.bounds;
}

-(void)webServicecallForGetGratitudeListListAPI{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetGratitudeListListAPI" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       
                                                                       self->masterGratitudeList = [responseDictionary objectForKey:@"Details"];
                                                                       if (![Utility isEmptyCheck:self->masterGratitudeList] && self->masterGratitudeList.count>0) {
                                                                           
                                                                           [self filterDataFromDate];
                                                                           
                                                                           if (self->shouldSetupRem) {
                                                                               self->shouldSetupRem = NO;
                                                                               [self setUpReminder];    //ah ln
                                                                           }
                                                                       }else{
                                                                           self->gratitudeListArray = [self->masterGratitudeList mutableCopy];
                                                                           [self->tableView reloadData];
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
- (void)playerItemDidReachEnd:(NSNotification *)notification {
    helpVideoCount++;
    if (helpVideoCount < helpVideos.count) {
        [self playVideoWithUrlStr:[helpVideos objectAtIndex:helpVideoCount] InsideView:videoView];
    } else {
        [videoPlayer pause];
    }
}
- (void) setUpReminder {            //ah ln
    //    if (SYSTEM_VERSION_LESS_THAN(@"10")) {   //ah ln1
    
    NSArray *requests = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *req in requests) {
        NSString *pushTo = [req.userInfo objectForKey:@"pushTo"];
        if ([pushTo caseInsensitiveCompare:@"Gratitude"] == NSOrderedSame) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:req];
            
        }
    }
    for (int i = 0; i < gratitudeListArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[gratitudeListArray objectAtIndex:i]];
        if ([[dict objectForKey:@"PushNotification"] boolValue]) {
            NSDictionary *dict1 = @{@"Id" : [dict objectForKey:@"Id"]};
            [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:[dict1 mutableCopy] FromController:@"Gratitude" Title:[dict objectForKey:@"Name"] Type:@"Gratitude" Id:[[dict objectForKey:@"Id"] intValue]];
        }
    }
}

-(void)filterDataFromDate{
    
    if(selectedDate){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:selectedDate];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CreatedAtString =  %@",dateString];
        gratitudeListArray = [masterGratitudeList filteredArrayUsingPredicate:predicate];
        [self->tableView reloadData];
    }
    
}

#pragma mark - Web service call
-(void)saveDataMultiPart:(NSString*)gratitudeText{
    if (Utility.reachable) {
        NSMutableDictionary *gratitudeData = [[NSMutableDictionary alloc]init];
        
        //        if (![Utility isEmptyCheck:gratitudeTitle.text] && gratitudeTitle.text.length > 0 && ![gratitudeTitle.text isEqualToString:@"Add Gratitude"]) {
        //            [gratitudeData setObject:gratitudeTitle.text forKey:@"Name"];
        //
        //        }else{
        //            [Utility msg:@"Name is required " title:@"Error" controller:self haveToPop:NO];
        //            return;
        //        }
        [gratitudeData setObject:@"" forKey:@"Name"];//Today I am grateful for:
        [gratitudeData setObject:gratitudeText forKey:@"Description"];
        
        if ([gratitudeData objectForKey:@"FrequencyId"] == nil) {
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"FrequencyId"];
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"MonthReminder"];
            [gratitudeData setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt1"];
            [gratitudeData setObject:[NSNumber numberWithInt:12] forKey:@"ReminderAt2"];
            [gratitudeData setObject:[NSNumber numberWithInt:1] forKey:@"ReminderOption"];
            [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"PushNotification"];
            [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
            
            NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
            NSArray* monthArray = [newDateformatter monthSymbols];
            NSArray* dayArray = [newDateformatter weekdaySymbols];
            for (int i = 0; i < monthArray.count; i++) {
                [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[monthArray objectAtIndex:i]];
            }
            for (int i = 0; i < dayArray.count; i++) {
                [gratitudeData setObject:[NSNumber numberWithBool:false] forKey:[dayArray objectAtIndex:i]];
            }
        }
        if (gratitudeData[@"Id"] == nil) {
            [gratitudeData setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        }
        if (gratitudeData[@"CreatedBy"] == nil) {
            [gratitudeData setObject:[defaults valueForKey:@"UserID"] forKey:@"CreatedBy"];
        }
        
        [gratitudeData setObject:@"" forKey:@"UploadPictureImgBase64"];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:gratitudeData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateGratitudeApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

#pragma mark - View Life Cycle

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    tableView.estimatedRowHeight = 65;
    tableView.rowHeight = UITableViewAutomaticDimension;
    helpVideoCount = 0;
    helpVideos = [[NSArray alloc]initWithObjects:@"https://player.vimeo.com/external/129498638.m3u8?s=8df3cba021e575ff0bf0154284a6654eef7f545f",@"https://player.vimeo.com/external/129498642.m3u8?s=eb34fc15f54b168a3b72bc2f2f9da193ce8031ae", @"https://player.vimeo.com/external/129498636.m3u8?s=e13e0c713b94e2aae57a4e2cceda3f1ff39d7cc9", @"https://player.vimeo.com/external/129498634.m3u8?s=66b87a8ad5b82f7cc07f9491b23830078b67533d", @"https://player.vimeo.com/external/129498635.m3u8?s=d26f22c9b3676e0e0d326b0fc2fa9976f606d8e3", nil];
    
    for (int i=0; i<goalValueArray.count;i++ ) {
        NSDictionary *dict = [goalValueArray objectAtIndex:i];
        if (i == 0) {
            headerFirstLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }if (i == 1) {
            headerSecondLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }if (i == 2) {
            headerThirdLabel.text = [[dict objectForKey:@"value"] uppercaseString];
        }
    }
    [gratitudestackView removeArrangedSubview:videoView];
    [videoView removeFromSuperview];
    isExpand = false;
    //Ru
    
    shouldSetupRem = YES;
    selectedDate = [NSDate date];
    NSTimeInterval sevenDays = -2*24*60*60;
    beginningOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    sevenDays = 2*24*60*60;
    endOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
    
    gratitudeListButton.layer.borderColor = [UIColor colorWithRed:20.0 / 255.0 green:227.0 / 255.0 blue:209.0 / 255.0 alpha:1.0].CGColor;
    
    gratitudeListButton.clipsToBounds = YES;
    gratitudeListButton.layer.borderWidth = 1.2;
    gratitudeListButton.layer.cornerRadius = 15;
    
    [self webServicecallForGetGratitudeListListAPI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];+
    if (_isOnlyToday) {
        nextButton.hidden = true;
        prevButton.hidden = true;
    } else {
        [self getSelectedWeek];
    }
   
}

#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- End
//****Ru****Start
#pragma mark - CollectionView Delegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return selectedAray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat w = (CGRectGetWidth(dateCollection.frame))/(float)selectedAray.count;
    CGFloat h = (CGRectGetHeight(dateCollection.frame));
    return CGSizeMake(w,h);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier=@"CustomNutritionPlanListInnerCollectionViewCell";
    CustomNutritionPlanListInnerCollectionViewCell *cell=(CustomNutritionPlanListInnerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.hidden = false;
    
    NSString *sDate = selectedAray[indexPath.row];//dict[@"Date"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *date = [formatter dateFromString:sDate];
    formatter.dateFormat = @"EEE";
    NSString *dayName=[formatter stringFromDate:date].uppercaseString;
    formatter.dateFormat = @"d";
    NSString *dateStr = [formatter stringFromDate:date];
    
    if (date) {
        cell.dayLabel.text = dayName;
        cell.dateLabel.text = dateStr;
        if ([date isSameDay:[NSDate date]]) {
            cell.dayLabel.text = @"Today";
        }
        if ([date isSameDay:selectedDate]) {
            cell.dayLabel.textColor = squadMainColor;
            cell.dateLabel.textColor = squadMainColor;
        } else {
            cell.dayLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
            cell.dateLabel.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1.0];
        }
    }else{
        cell.dayLabel.text = @"";
        cell.dateLabel.text = @"";
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dateString = selectedAray[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        if ([date isSameDay:selectedDate]) {
            return;
        }
    }
    selectedDate = [formatter dateFromString:dateString];
    
    if(masterGratitudeList.count>0){
        [self filterDataFromDate];
    }
    [dateCollection reloadData];
}

- (IBAction)nextPressed:(id)sender {
    if (_isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = 5*24*60*60;
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}

- (IBAction)PrevPressed:(id)sender {
    if (_isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = -5*24*60*60;
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}

-(void)getSelectedWeek{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *df1 = [NSDateFormatter new];
    [df1 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *startDate = [df dateFromString:[df stringFromDate:beginningOfWeek]];
    NSDate *endDate = [df dateFromString:[df stringFromDate:endOfWeek]];
    
    NSMutableArray *dates = [@[startDate] mutableCopy];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    for (int i = 1; i < components.day; ++i) {
        NSDateComponents *newComponents = [NSDateComponents new];
        newComponents.day = i;
        NSDate *date = [gregorianCalendar dateByAddingComponents:newComponents
                                                          toDate:startDate
                                                         options:0];
        [dates addObject:date];
    }
    [dates addObject:endDate];
    NSMutableArray *dArray = [NSMutableArray new];
    for (NSDate *date in dates) {
        [dArray addObject:[df1 stringFromDate:[df dateFromString:[df stringFromDate:date]]]];
    }
    selectedAray = dArray;
    
    [dateCollection reloadData];
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table{
    return 1;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
    if(gratitudeListArray.count>0){
        noDataLabel.hidden = true;
    }else{
        noDataLabel.hidden = false;
    }
    
    return gratitudeListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"GratitudeTableViewCell";
    GratitudeTableViewCell *cell;
    cell=[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GratitudeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [gratitudeListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
//        if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {
//            NSString *imageUrlString =[dict objectForKey:@"Picture"];
//            imageUrlString = [imageUrlString stringByReplacingOccurrencesOfString:@"thumbnails/" withString:@""];
//            [cell.gratitudeImage sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"Picture"]] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
//        } else {
//            cell.gratitudeImage.image = [UIImage imageNamed:@"EXERCISE-picture-coming.jpg"];
//        }
//        NSLog(@"%@",NSStringFromCGRect(cell.gratitudeImage.frame));
//        cell.gratitudeImage.layer.cornerRadius = cell.gratitudeImage.frame.size.height/2;
//        cell.gratitudeImage.clipsToBounds = YES;

        if (![Utility isEmptyCheck:[dict objectForKey:@"Name"]]) {
            
            NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:[dict objectForKey:@"Name"]];
            NSArray *splitArr = [[dict objectForKey:@"Name"] componentsSeparatedByString:@":"];
            NSRange foundRange1 = [text1.mutableString rangeOfString:[splitArr objectAtIndex:0]];
            
            NSDictionary *attrDict1 = @{
                                        NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:19.0],
                                        NSForegroundColorAttributeName : [Utility colorWithHexString:@"41515C"]
                                        
                                        };
            [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
            [text1 addAttributes:@{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:19.0]
                                   
                                   }
                           range:foundRange1];
            cell.gratitudeLabel.attributedText = text1;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [gratitudeListArray objectAtIndex:indexPath.row];
    GratitudeAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GratitudeAddEdit"];
//    controller.isEdit = true;
    controller.gratitudeData = [dict mutableCopy];
    controller.gratitudeDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - GratitudeAddEditDelegate
- (void)didGratitudeBackAction:(BOOL)ischanged{
    [self webServicecallForGetGratitudeListListAPI];
}
#pragma mark - End

#pragma mark - progressbar delegate
- (void)completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
            //            if (self->reminderSwitch.isOn && ![Utility isEmptyCheck:self->savedReminderDict] && [[self->savedReminderDict objectForKey:@"PushNotification"] boolValue]) {
            //
            //                if ([Utility isEmptyCheck:self->gratitudeData]) {
            //                    self->gratitudeData = [[responseDict objectForKey:@"Details"] mutableCopy];
            //                } else {
            //                    [self->gratitudeData setObject:[[responseDict objectForKey:@"Details"] objectForKey:@"Id"] forKey:@"Id"];
            //                }
            //                self->gratitudeData  = [[Utility replaceDictionaryNullValue:self->gratitudeData] mutableCopy];
            //                //if (SYSTEM_VERSION_LESS_THAN(@"10")) {
            //                [SetReminderViewController setOldLocalNotificationFromDictionary:self->savedReminderDict ExtraData:self->gratitudeData FromController:@"Gratitude" Title:self->gratitudeTitle.text Type:@"Gratitude" Id:[[self->gratitudeData objectForKey:@"Id"] intValue]];
            //            }
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:@"Success"
                                                  message:@"Saved Successfully."
                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           //Ru
                                           //                                           if([self->gratitudeDelegate respondsToSelector:@selector(didGratitudeBackAction:)]){
                                           //                                               [self->gratitudeDelegate didGratitudeBackAction:self->isLoad];
                                           //                                           }
                                           
                                           //                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                           [self webServicecallForGetGratitudeListListAPI];
                                       }];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}
- (void) completedWithError:(NSError *)error{
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}


@end
