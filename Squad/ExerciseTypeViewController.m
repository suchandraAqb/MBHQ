//
//  ExerciseTypeViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 02/01/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ExerciseTypeViewController.h"
#import "ExerciseTypeTableViewCell.h"
#import "ExerciseTypeLastTableViewCell.h"
#import "CustomNutritionPlanListInnerCollectionViewCell.h"

@interface ExerciseTypeViewController () {
    
    __weak IBOutlet UITableView *typeTable;
    __weak IBOutlet UILabel *titleName;
    __weak IBOutlet UIImageView *titleIcon;
    
    IBOutlet UIView *bodyWeightView;
    IBOutlet UIView *equipmentView;
    IBOutlet UIView *strapView;
    IBOutlet NSLayoutConstraint *bodyWeightHeightConstraint;
    IBOutlet NSLayoutConstraint *equipmentHeightConstraint;
    IBOutlet NSLayoutConstraint *strapHeightConstraint;
    IBOutlet UIButton *bodyWeightButton;
    IBOutlet UIButton *equipmentButton;
    IBOutlet UIButton *strapButton;
    
    IBOutlet UILabel *durationBwLabel;    //ah ux3(stroeyboard)
    IBOutlet UILabel *durationEqLabel;
    IBOutlet UILabel *durationSsLabel;
    IBOutlet UILabel *equipmentLabel;
    
    IBOutlet UICollectionView *dateCollection;
    IBOutlet UILabel *tryWorkoutLabel;
    IBOutlet UILabel *noDataLabel;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    NSDate *selectedDate;
    NSArray *selectedAray;
    NSDate *beginningOfWeek;
    NSDate *endOfWeek;
    
    UIView *contentView;
    NSMutableArray *dataArray;
    int apiCount;
    
    //Added for Local database
    int detailsDataCount;
    NSMutableArray *detailsDataArray;
    NSMutableArray *exerciseTypeArray;
    BOOL isTurbo;
    BOOL isChanged;
    //End
}

@end

@implementation ExerciseTypeViewController
@synthesize exerciseSessionType,delegate,dailyWorkoutLists;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    tryWorkoutLabel.hidden = true;
    dataArray = [[NSMutableArray alloc]init];
    bodyWeightView.hidden = true;
    equipmentView.hidden = true;
    strapView.hidden = true;
    apiCount = 0;
    isTurbo = false;
    selectedDate = [NSDate date];
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    if (_isOnlyToday) {
        tryWorkoutLabel.hidden = false;
        selectedDate = [df dateFromString:@"2019-04-05"];
    } else {
        selectedDate = [NSDate date];
    }
    
    NSTimeInterval sevenDays = -2*24*60*60;
    beginningOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    sevenDays = 2*24*60*60;
    endOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
//    [self getData]; //ah28
    [self checkForGetApiCall];
//    [self getExerciseDetails];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    if (_isOnlyToday) {
        nextButton.hidden = true;
        prevButton.hidden = true;
    } else {
        [self getSelectedWeek];
    }
    [typeTable reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    if (_isOnlyToday) {
        _isOnlyToday = false;
        tryWorkoutLabel.hidden = true;
        selectedDate = [NSDate date];
        NSTimeInterval sevenDays = -2*24*60*60;
        beginningOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
        sevenDays = 2*24*60*60;
        endOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
        [self getSelectedWeek];
        
        NSDictionary *dict;
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
        formatter1.dateFormat = @"yyyy-MM-dd";
        NSString *dateStr = [formatter1 stringFromDate:[NSDate date]];
        
        
        NSString *dateString = [@"" stringByAppendingFormat:@"%@T00:00:00",dateStr];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        
        NSArray *mArray = [dailyWorkoutLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Date == %@",dateString]];
        if ([Utility isEmptyCheck:mArray]) {
            noDataLabel.hidden = false;
            selectedDate = [formatter dateFromString:dateString];
            [dateCollection reloadData];
            typeTable.hidden = true;
            return;
        }else{
            noDataLabel.hidden = true;
            typeTable.hidden = false;
            dict = [mArray objectAtIndex:0];
        }
        int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
        [dateCollection reloadData];
        
        _exSessionID = exSessionID;
        _dateStr = [dict objectForKey:@"Date"];
        _sessionTitle = [dict objectForKey:@"ExerciseSessionTitle"];
        _isPersonalisedSession = [[dict objectForKey:@"IsPersonalised"] boolValue];  //ah ux2
        exerciseSessionType = [dict objectForKey:@"ExerciseSessionType"];//AY 23102017
        
        [self checkForGetApiCall];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//arnab 17

#pragma mark - IBAction
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
-(IBAction)logoTapped:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)buttonTapped:(UIButton*)sender {
    ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
    controller.completeSessionId = [[[dataArray objectAtIndex:0] objectForKey:@"ExerciseSessionId"] intValue]; // AY 05012018
    controller.exSessionId = (int)[sender tag];
    controller.fromWhere = @"DailyWorkout"; //add_su_2/8/17
    controller.sessionDate = _dateStr;  //ah 2.2
    controller.weekDate = _dateStr;  //AY 07112017
    controller.exerciseSessionType = exerciseSessionType;
    controller.delegate =self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)previousPressed:(id)sender {
    if (_isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = -5*24*60*60;
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}
- (IBAction)nextPressed:(id)sender {
    if (_isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = 5*24*60*60;
//    NSDate *tmpCheck;//dailyWorkoutLists//Date = "2019-03-30T00:00:00";
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exerciseTypeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"ir %ld | is %ld",(long)indexPath.row,(long)indexPath.section);
    UITableViewCell *commonCell;
    NSDictionary *dict = [exerciseTypeArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        if ([dict[@"turboCell"] boolValue]) {
            NSString *CellIdentifier = @"ExerciseTypeLastTableViewCell";
            ExerciseTypeLastTableViewCell *cell;
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ExerciseTypeLastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.rightArrow.hidden =isTurbo;
            cell.leftArrow.hidden =!isTurbo;
            cell.typeName.text = dict[@"TypeName"];
            cell.duration.text = !isTurbo ? @"Short and Sharp Turbo Sessions" : @"";
            commonCell = cell;
        }else{
            NSString *CellIdentifier = @"ExerciseTypeTableViewCell";
            ExerciseTypeTableViewCell *cell;
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[ExerciseTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            int equipmentRequired = [dict[@"EquipmentRequired"] intValue];
            if(equipmentRequired % 3 == 2){
                cell.typeName.text = @"BODYWEIGHT";
            }else if(equipmentRequired % 3 == 1){
                cell.typeName.text = @"EQUIPMENT";
            }else if(equipmentRequired % 3 == 0){
                cell.typeName.text = @"SQUAD STRAPS";
            }
            if(equipmentRequired > 3){
//                cell.durationIcon.image = [UIImage imageNamed:@"plane.png"];
                cell.typeName.text = [@"" stringByAppendingFormat:@"TURBO %@",cell.typeName.text];
            }
//            else{
//                cell.durationIcon.image = [UIImage imageNamed:@"clock_t.png"];
//            }
            cell.durationIcon.image = [UIImage imageNamed:@"clock_t.png"];
            cell.duration.text = [NSString stringWithFormat:@"%@ min",dict[@"Duration"]];
            NSArray *equipments = dict[@"Equipments"];
            if(![Utility isEmptyCheck:equipments]){
                cell.equipments.text = [@"" stringByAppendingFormat:@"%@\n",[equipments componentsJoinedByString:@", "]];//FD_Sb
            }else{
                cell.equipments.text = @"";
            }
            
            BOOL fav = [[dict objectForKey:@"IsFavourite"] boolValue];
            cell.favButton.hidden = !fav;
            int bodyType = ![Utility isEmptyCheck:[dict objectForKey:@"ExerciseBodyType"]]?[[dict objectForKey:@"ExerciseBodyType"]intValue]:0;
            NSString *body = @"";
            if(bodyType == LowerBody){
                cell.bodyTypeImage.image = [UIImage imageNamed:@"lower_body.png"];
                body = @"Lower Body";
            }else if(bodyType == FullBody){
                cell.bodyTypeImage.image = [UIImage imageNamed:@"full_body.png"];
                body = @"Full Body";
            }else if(bodyType == UpperBody){
                cell.bodyTypeImage.image = [UIImage imageNamed:@"upper_body.png"];
                body = @"Upper Body";
            }else{
                cell.bodyTypeImage.image = [UIImage imageNamed:@"full_body.png"];
                body = @"Core";
            }
            int sessionType = ![Utility isEmptyCheck:[dict objectForKey:@"ExerciseSessionType"]]?[[dict objectForKey:@"ExerciseSessionType"]intValue]:0;
            NSString *session = @"";
            if(sessionType == Weights){
                session = @"Weights";
            }else if(sessionType == HIIT){
                session = @"HIIT";
            }else if(sessionType == Pilates){
                session = @"Pilates";
            }else if(sessionType == Yoga){
                session = @"Yoga";
            }else if(sessionType == Cardio){
                session = @"Cardio";
            }else if(sessionType == CardioBasedClass){
                session = @"CardioBasedClass";
            }else if(sessionType == ResistanceBasedClass){
                session = @"ResistanceBasedClass";
            }else if(sessionType == Sport){
                session = @"Sport";
            }else if(sessionType == FBW){
                session = @"FBW";
            }
            
            cell.bodyTypeLabel.text = [@"" stringByAppendingFormat:@"%@ %@",body,session];
            
            commonCell = cell;
        }
        
    }

    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [exerciseTypeArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        if ([dict[@"turboCell"] boolValue]) {
            isTurbo = !isTurbo;
            [self setUpType];
        }else{
            
            int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
            
            if([Utility isSubscribedUser] && [Utility isOfflineMode] && ![self isOfflineAvailable:exSessionID]){
                [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
                return;
            }
            
            ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
            controller.completeSessionId = [[[dataArray objectAtIndex:0] objectForKey:@"ExerciseSessionId"] intValue]; // AY 05012018
            controller.exSessionId = exSessionID;
            controller.fromWhere = @"DailyWorkout"; //add_su_2/8/17
            controller.sessionDate = _dateStr;  //ah 2.2
            controller.weekDate = _dateStr;  //AY 07112017
            controller.exerciseSessionType = exerciseSessionType;
            controller.delegate = self;
            controller.loadForSelected = _isOnlyToday;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
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
    if(![Utility isEmptyCheck:dailyWorkoutLists]){
//        NSDictionary *dict = selectedAray[indexPath.row];
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
                if (_isOnlyToday) {
                    cell.hidden = true;
                }
            }
        }else{
            cell.dayLabel.text = @"";
            cell.dateLabel.text = @"";
        }
        
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isOnlyToday) {
        return;
    }
    NSDictionary *dict;
    NSString *dateString = selectedAray[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    
    NSDate *date = [formatter dateFromString:dateString];
    if (date) {
        if ([date isSameDay:selectedDate]) {
            return;
        }
    }
    
    NSArray *mArray = [dailyWorkoutLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Date == %@",dateString]];
    if ([Utility isEmptyCheck:mArray]) {
        noDataLabel.hidden = false;
        selectedDate = [formatter dateFromString:dateString];
        [dateCollection reloadData];
        typeTable.hidden = true;
        return;
    }else{
        noDataLabel.hidden = true;
        typeTable.hidden = false;
        dict = [mArray objectAtIndex:0];
    }
    int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
    
    if([Utility isSubscribedUser] && [Utility isOfflineMode] && ![self isOfflineAvailable:exSessionID]){
        [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
        return;
    }
    
    selectedDate = [formatter dateFromString:dateString];
    [dateCollection reloadData];
    
     _exSessionID = exSessionID;
     _dateStr = [dict objectForKey:@"Date"];
     _sessionTitle = [dict objectForKey:@"ExerciseSessionTitle"];
     _isPersonalisedSession = [[dict objectForKey:@"IsPersonalised"] boolValue];  //ah ux2
     exerciseSessionType = [dict objectForKey:@"ExerciseSessionType"];//AY 23102017
    
    [self checkForGetApiCall];
}

#pragma -mark End
#pragma mark - private Methods
-(void)setUpType{
    exerciseTypeArray = [[NSMutableArray alloc]init];
//    NSPredicate *predicate ;
//    NSPredicate *predicate1;
//    NSString *typeName=@"";
//    if (isTurbo) {
//        titleIcon.image = [UIImage imageNamed:@"w_plane.png"];
//        titleName.text = @"TURBO SESSION OPTIONS";
//        predicate = [NSPredicate predicateWithFormat:@"(EquipmentRequired.intValue > %d)",3 ];
//        predicate1 = [NSPredicate predicateWithFormat:@"(EquipmentRequired.intValue <= %d)",3 ];
//        typeName = @"REGULAR SESSION OPTIONS";
//    }else{
//        titleIcon.image = [UIImage imageNamed:@""];
//        titleName.text = @"SESSION OPTIONS";
//        predicate = [NSPredicate predicateWithFormat:@"(EquipmentRequired.intValue <= %d)",3 ];
//        predicate1 = [NSPredicate predicateWithFormat:@"(EquipmentRequired.intValue > %d)",3 ];
//        typeName = @"TURBO SESSION OPTIONS";
//    }
//    exerciseTypeArray = [[dataArray filteredArrayUsingPredicate:predicate]mutableCopy];
//    if (dataArray.count > 3) {
//        NSArray *turboArray =[dataArray filteredArrayUsingPredicate:predicate1];
//        if(![Utility isEmptyCheck:turboArray]){
//            int totalDuration = 0;
//            for (NSDictionary *dict in turboArray) {
//                if (![Utility isEmptyCheck:dict]) {
//                    totalDuration = totalDuration + [dict[@"Duration"] intValue];
//                }
//            }
//            NSDictionary *tempDict = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:true],@"turboCell",typeName,@"TypeName", nil];
//            [exerciseTypeArray addObject:tempDict];
//        }
//    }
    if (![Utility isEmptyCheck:dataArray] && dataArray.count>0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(EquipmentRequired>3)"];
        NSArray *filteredTurboArray = [dataArray filteredArrayUsingPredicate:predicate];
        if (filteredTurboArray.count>0) {
            for (int i =0; i<filteredTurboArray.count; i++) {
                [exerciseTypeArray addObject:filteredTurboArray[i]];
            }
        }
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(EquipmentRequired<=3)"];
        NSArray *filteredArray = [dataArray filteredArrayUsingPredicate:predicate1];
        if (filteredArray.count>0) {
            for (int j =0; j<filteredArray.count; j++) {
                [exerciseTypeArray addObject:filteredArray[j]];
            }
        }
    }
    
    [typeTable reloadData];
    [dateCollection reloadData];
//    [dateCollection setContentOffset:CGPointMake(dateCollection.contentSize.width-dateCollection.frame.size.width, 0) animated:NO];
}
-(void) getData {
    if (Utility.reachable && ![Utility isOfflineMode]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!contentView || ![contentView isDescendantOfView:self.view]) {
                apiCount++;
                contentView = [Utility activityIndicatorView:self];
            }
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];//@"3269"
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:@"" forKey:@"UserName"];
        [mainDict setObject:_dateStr forKey:@"DailySessionDate"];
        [mainDict setObject:_sessionTitle forKey:@"SessionTitle"];
        [mainDict setObject:[NSString stringWithFormat:@"%d",_exSessionID] forKey:@"ExerciseSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadDailySessionSplit" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         [dataArray removeAllObjects];
                                                                         [dataArray addObjectsFromArray:[responseDictionary objectForKey:@"DailySessionSplitModels"]];
                                                                         [self addUpdateDB];
                                                                         [self setUpType];
                                                                         //[self setupView];
                                                                     } else{
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
        
        if([Utility isSubscribedUser] && [Utility isOfflineMode]){
            [self getOfflineData];
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}

-(void)getExerciseDetailsFor:(int)sessionType WithSessionID:(int)sessionID {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!contentView || ![contentView isDescendantOfView:self.view]) {
                apiCount++;
                contentView = [Utility activityIndicatorView:self];
            }
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];

        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetWorkoutDetailsApiCall" append:[@"?" stringByAppendingFormat:@"userId=%@&ExerciseSessionId=%d&personalisedOne=%@",[defaults objectForKey:@"ABBBCOnlineUserId"],sessionID,_isPersonalisedSession? @"true" : @"false"] forAction:@"GET"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 
                                                                 detailsDataCount--;
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         
                                                                         NSDictionary *exerciseDetailsDict =[responseDictionary objectForKey:@"obj"];
                                                                         
                                                                         if(!detailsDataArray){
                                                                             detailsDataArray = [[NSMutableArray alloc]init];
                                                                         }
                                                                         
                                                                         [detailsDataArray addObject:exerciseDetailsDict];
                                                                         
                                                                         if(detailsDataCount == 0){
                                                                             [self addUpdateDB];
                                                                         }
                                                                         //ah ux3
                                                                         [self setupEquipmentDetails:sessionType exerciseDetails:exerciseDetailsDict]; // AY 21022018
                                                                         
                                                                         
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
        detailsDataCount--;
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}


- (void) setupView {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    for (int i = 0; i < dataArray.count; i++) {
        switch ([[[dataArray objectAtIndex:i] objectForKey:@"EquipmentRequired"] intValue]) {
            case 1:
                equipmentView.hidden = false;
                [equipmentButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                detailsDataCount++;
                [self getExerciseDetailsFor:1 WithSessionID:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                break;
               
            case 2:
                bodyWeightView.hidden = false;
                [bodyWeightButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                detailsDataCount++;
                [self getExerciseDetailsFor:2 WithSessionID:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                break;
                
            case 3:
                strapView.hidden = false;
                [strapButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                detailsDataCount++;
                [self getExerciseDetailsFor:3 WithSessionID:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
                break;
                
            default:
                break;
        }
    }
    int count = (int)dataArray.count;
    if (!bodyWeightView.isHidden) {
        bodyWeightHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
    if (!equipmentView.isHidden) {
        equipmentHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
    if (!strapView.isHidden) {
        strapHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
}

-(void)setupEquipmentDetails:(int)sessionType exerciseDetails:(NSDictionary *)exerciseDetailsDict{
    
    switch (sessionType) {
        case 1:
        {
            durationEqLabel.text = [NSString stringWithFormat:@"Session Duration: %@ mins",[exerciseDetailsDict objectForKey:@"Duration"]];
            
            NSMutableArray *equipmentsArray = [[NSMutableArray alloc] init];
            
            NSArray *cktArr = ![Utility isEmptyCheck:[exerciseDetailsDict objectForKey:@"Exercises"]] ? [exerciseDetailsDict objectForKey:@"Exercises"] : [NSArray new];
            for (int i = 0; i < cktArr.count; i++) {
                if (![Utility isEmptyCheck:[[cktArr objectAtIndex:i] objectForKey:@"Equipments"]]) {
                    [equipmentsArray addObjectsFromArray:[[cktArr objectAtIndex:i] objectForKey:@"Equipments"]];
                }
                NSArray *exArr = ![Utility isEmptyCheck:[[cktArr objectAtIndex:i] objectForKey:@"CircuitExercises"]] ? [[cktArr objectAtIndex:i] objectForKey:@"CircuitExercises"] : [NSArray new];
                for (int j = 0; j < exArr.count; j++) {
                    if (![Utility isEmptyCheck:[[exArr objectAtIndex:j] objectForKey:@"Equipments"]]) {
                        [equipmentsArray addObjectsFromArray:[[exArr objectAtIndex:j] objectForKey:@"Equipments"]];
                    }
                }
            }
            
            NSArray *uniqueequipmentsArray = [equipmentsArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
            
            
            if (![Utility isEmptyCheck:uniqueequipmentsArray] && uniqueequipmentsArray.count > 0) {
                equipmentLabel.text = @"Equipment Required:\n";
                equipmentLabel.text = [equipmentLabel.text stringByAppendingFormat:@"\u2022 %@", [uniqueequipmentsArray componentsJoinedByString:@"\n\u2022"]];
            } else {
                equipmentLabel.text = @"No Equipment Required";
            }
        }
            break;
            
        case 2:
            durationBwLabel.text = [NSString stringWithFormat:@"Session Duration: %@ mins",[exerciseDetailsDict objectForKey:@"Duration"]];
            break;
            
        case 3:
            durationSsLabel.text = [NSString stringWithFormat:@"Session Duration: %@ mins",[exerciseDetailsDict objectForKey:@"Duration"]];
            break;
            
        default:
            break;
    }
    
}
-(void)addUpdateDB{
    if (![Utility isSubscribedUser]){
        return;
    }
    
    NSString *equipmentTypeString = @"";
    NSString *detailsString = @"";
    
    if(dataArray.count>0){
        NSError *error;
        NSData *listData = [NSJSONSerialization dataWithJSONObject:dataArray options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error DailyWorkout-%@",error.debugDescription);
        }
        equipmentTypeString = [[NSString alloc] initWithData:listData encoding:NSUTF8StringEncoding];
    }
    
    if(detailsDataArray.count>0){
        NSError *error;
        NSData *favData = [NSJSONSerialization dataWithJSONObject:detailsDataArray options:NSJSONWritingPrettyPrinted  error:&error];
        
        if (error) {
            
            NSLog(@"Error Favorite Array-%@",error.debugDescription);
        }
        
        detailsString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
    }
    
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    
    if([DBQuery isRowExist:@"exerciseTypeDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionID]]){
        
        [DBQuery updateExerciseTypes:equipmentTypeString details:detailsString sessionId:_exSessionID];
    }else{
        [DBQuery addExerciseTypes:equipmentTypeString details:detailsString sessionId:_exSessionID];
        
    }
}

-(void)getOfflineData{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    if([DBQuery isRowExist:@"exerciseTypeDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionID]]){
        
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
            NSArray *arr = [dbObject selectBy:@"exerciseTypeDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"equipmentList",@"equipmentDetails",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,_exSessionID]];
            
            if(arr.count>0){
                
                if(![Utility isEmptyCheck:arr[0][@"equipmentList"]]){
                    NSString *str = arr[0][@"equipmentList"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *equipmentList = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(equipmentList){
                        if(dataArray) [dataArray removeAllObjects];
                        [dataArray addObjectsFromArray:equipmentList];
                    }
                    
                }
                
                if(![Utility isEmptyCheck:arr[0][@"equipmentDetails"]]){
                    NSString *str = arr[0][@"equipmentDetails"];
                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    NSArray *detailsArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    
                    if(detailsArray){
                        if(detailsDataArray){
                           [detailsDataArray removeAllObjects];
                        }else{
                            detailsDataArray = [[NSMutableArray alloc]init];
                        }
                        [detailsDataArray addObjectsFromArray:detailsArray];
                    }
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(),^ {
                    [self setUpType];
                    //[self setupOfflineView];
                });
            }
            
            [dbObject connectionEnd];
        }
    }else{
        [Utility msg:@"You are in OFFLINE mode and this session hasn't been previously downloaded. Please remove offline mode and download this session while you have access to the internet." title:@"Oops!\n" controller:self haveToPop:NO];
    }
    
}

-(BOOL)isOfflineAvailable:(int)sessionId{
    BOOL isAvailable = false;
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        
        isAvailable = [DBQuery isRowExist:@"exerciseDetails" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,sessionId]];
        
       /* NSString *query = [@"" stringByAppendingFormat:@"select et.equipmentList from exerciseTypeDetails et,dailyworkout dw,exerciseDetails ed where dw.UserId = et.UserId AND ed.UserId = et.UserId AND et.exSessionId = ed.exSessionId AND et.exSessionId = '%d' AND dw.UserId = '%d'",sessionId,userId];
        
        NSArray *arr =[dbObject selectByQuery:[[NSArray alloc]initWithObjects:@"equipmentList",nil] query:query];
        
        if(arr.count>0){
            isAvailable = true;
        }*/
    }
    
    return isAvailable;
    
}// AY 14032018

- (void)setupOfflineView {
    
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    for (int i = 0; i < dataArray.count; i++) {
        
        int equipment = [[[dataArray objectAtIndex:i] objectForKey:@"EquipmentRequired"] intValue];
        
        if(equipment == 1){
            
            equipmentView.hidden = false;
            [equipmentButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
            
            NSArray *filterarray = [detailsDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EquipmentRequired == %d)", 1]];
            NSLog(@"%@",filterarray);
            if (![Utility isEmptyCheck:filterarray]) {
                [self setupEquipmentDetails:1 exerciseDetails:filterarray[0]];
            }
            
        }else if(equipment == 2){
            
            bodyWeightView.hidden = false;
            [bodyWeightButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
            
            NSArray *filterarray = [detailsDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EquipmentRequired == %d)", 2]];
            NSLog(@"%@",filterarray);
            if (![Utility isEmptyCheck:filterarray]) {
                [self setupEquipmentDetails:2 exerciseDetails:filterarray[0]];
            }
            
        }else if(equipment == 3){
            
            strapView.hidden = false;
            [strapButton setTag:[[[dataArray objectAtIndex:i] objectForKey:@"ExerciseSessionId"] intValue]];
            NSArray *filterarray = [detailsDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(EquipmentRequired == %d)", 3]];
            NSLog(@"%@",filterarray);
            if (![Utility isEmptyCheck:filterarray]) {
                [self setupEquipmentDetails:3 exerciseDetails:filterarray[0]];
            }
            
        }
        
        
    }
    int count = (int)dataArray.count;
    if (!bodyWeightView.isHidden) {
        bodyWeightHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
    if (!equipmentView.isHidden) {
        equipmentHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
    if (!strapView.isHidden) {
        strapHeightConstraint.constant = (screenHeight - 109 - 6)/count;
    }
}

-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [delegate didCheckAnyChange:isChanged];
        }
        [self back:nil];
    }
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
    NSTimeInterval sevenDays = 2*24*60*60;
    NSDate *arrEndDate = [[NSDate date] dateByAddingTimeInterval:sevenDays];
    if ([selectedAray containsObject:[df1 stringFromDate:[df dateFromString:[df stringFromDate:arrEndDate]]]]) {
        nextButton.hidden = true;
    } else {
        nextButton.hidden = false;;
    }
    NSArray *mArray = [dailyWorkoutLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Date < %@",[selectedAray objectAtIndex:0]]];
    if (![Utility isEmptyCheck:mArray]) {
        prevButton.hidden = false;
    }else{
        prevButton.hidden = true;
    }
    
    [dateCollection reloadData];
}
-(void)checkForGetApiCall{
    if (![Utility isEmptyCheck:_dateStr] && ![Utility isEmptyCheck:_sessionTitle] && _exSessionID>0) {
        [self getData];
        noDataLabel.hidden = true;
        typeTable.hidden = false;
    } else {
        noDataLabel.hidden = false;
        typeTable.hidden = true;
    }
}
#pragma mark - ExerciseDetailsDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
-(void)loadSelectedDate:(BOOL)isLoad{
    if (isLoad) {
        _isOnlyToday = true;
        tryWorkoutLabel.hidden = false;
        selectedDate = [NSDate date];
        NSDateFormatter *formatter1 = [NSDateFormatter new];
        [formatter1 setDateFormat:@"yyyy-MM-dd"];
        selectedDate = [formatter1 dateFromString:@"2019-04-05"];
        NSTimeInterval sevenDays = -2*24*60*60;
        beginningOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
        sevenDays = 2*24*60*60;
        endOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
        [self getSelectedWeek];
        
        NSDictionary *dict;
        NSString *dateStr = [formatter1 stringFromDate:selectedDate];
        
        NSString *dateString = [@"" stringByAppendingFormat:@"%@T00:00:00",dateStr];;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
        
        NSArray *mArray = [dailyWorkoutLists filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"Date == %@",dateString]];
        if ([Utility isEmptyCheck:mArray]) {
            noDataLabel.hidden = false;
            selectedDate = [formatter dateFromString:dateString];
            [dateCollection reloadData];
            typeTable.hidden = true;
            return;
        }else{
            noDataLabel.hidden = true;
            typeTable.hidden = false;
            dict = [mArray objectAtIndex:0];
        }
        int exSessionID = [[dict objectForKey:@"ExerciseSessionId"] intValue];
        [dateCollection reloadData];
        
        _exSessionID = exSessionID;
        _dateStr = [dict objectForKey:@"Date"];
        _sessionTitle = [dict objectForKey:@"ExerciseSessionTitle"];
        _isPersonalisedSession = [[dict objectForKey:@"IsPersonalised"] boolValue];  //ah ux2
        exerciseSessionType = [dict objectForKey:@"ExerciseSessionType"];//AY 23102017
        
        [self checkForGetApiCall];
    }
}
#pragma mark - End

@end
