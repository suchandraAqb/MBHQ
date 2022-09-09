//
//  ContentManagementViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 28/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ContentManagementViewController.h"
#import "TableViewCell.h"
#import "DownloadedSessionTableViewCell.h"
#import "ExerciseDetailsViewController.h"

@interface ContentManagementViewController (){
    IBOutlet UIView *headerContainerView;
    NSMutableArray *filesArray;
    
    
    __weak IBOutlet UIButton *headerButton;
    __weak IBOutlet UIView *itemsView;
    __weak IBOutlet UITableView *itemsTable;
    __weak IBOutlet UILabel *noItemsLabel;
    BOOL isDownloadedSessionList;
}

@end

@implementation ContentManagementViewController
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    itemsTable.allowsMultipleSelectionDuringEditing = NO;
    
    
    noItemsLabel.text = @"Content Not  Found";
    [headerButton setTitle:@"CONTENT MANAGEMENT" forState:UIControlStateNormal];
    if(filesArray.count>0){
        noItemsLabel.hidden = true;
    }else{
        noItemsLabel.hidden = false;
    }
    itemsView.hidden = false;
    
    // Added For Showing Downloaded Session Only AY 26032018
    UIButton *btn = [[UIButton alloc]init];
    [btn setTag:4];
    [self directoryButtonPressed:btn];
    //End
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backButtonPressed:) name:@"backButtonPressed" object:nil];// AY 28022018
    
    /*NSLog(@"Images: %@",[self getFilesFromDocumentDirectory:@[@"png",@"jpg",@"jpeg"]]);
    NSLog(@"Sounds: %@",[self getFilesFromDocumentDirectory:@[@"wav",@"mp3"]]);
    NSLog(@"Videos: %@",[self getFilesFromDocumentDirectory:@[@"mp4"]]);*/
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];//AY 28022018
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - IBAction
- (IBAction)directoryButtonPressed:(UIButton *)sender {
    //1: Images 2:Videos 3:Audios
    isDownloadedSessionList = false;
    if(sender.tag == 1){
        filesArray = [[self getFilesFromDocumentDirectory:@[@"png",@"jpg",@"jpeg"]] mutableCopy];
        [itemsTable reloadData];
        
        noItemsLabel.text = @"No Images found.";
        [headerButton setTitle:@"IMAGES" forState:UIControlStateNormal];
        if(filesArray.count>0){
            noItemsLabel.hidden = true;
        }else{
            noItemsLabel.hidden = false;
        }
    }else if(sender.tag == 2){
        filesArray = [[self getFilesFromDocumentDirectory:@[@"mp4"]] mutableCopy];
        [itemsTable reloadData];
        
        noItemsLabel.text = @"No Videos found.";
        [headerButton setTitle:@"VIDEOS" forState:UIControlStateNormal];
        if(filesArray.count>0){
            noItemsLabel.hidden = true;
        }else{
            noItemsLabel.hidden = false;
        }
    }else if(sender.tag == 3){
        filesArray = [[self getFilesFromDocumentDirectory:@[@"wav",@"mp3"]] mutableCopy];
        [itemsTable reloadData];
        
        noItemsLabel.text = @"No Audios found.";
        [headerButton setTitle:@"AUDIOS" forState:UIControlStateNormal];
        if(filesArray.count>0){
            noItemsLabel.hidden = true;
        }else{
            noItemsLabel.hidden = false;
        }
    }else if(sender.tag == 4){
        isDownloadedSessionList = true;
        filesArray = [[self getDownloadedSessions] mutableCopy];
        [itemsTable reloadData];
        
        noItemsLabel.text = @"No Downloaded Session Found";
        [headerButton setTitle:@"DOWNLOADED SESSIONS" forState:UIControlStateNormal];
        if(filesArray.count>0){
            noItemsLabel.hidden = true;
        }else{
            noItemsLabel.hidden = false;
        }
    }
    itemsView.hidden = false;
    
    if(filesArray.count>0 && sender.tag != 4){
        [self prepareInstruction];
    }
}

- (IBAction)sessionDeleteButtonPressed:(UIButton *)sender {
    
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Warning"
                                          message:@"Do you want to delete this session?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSDictionary *sesionDetails = filesArray[sender.tag];
                                   NSString *str = sesionDetails[@"exerciseNames"];
                                   NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                                   NSMutableArray *deletedArray = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] mutableCopy];
                                   
                                   int sessionId = [sesionDetails[@"exSessionId"] intValue];
                                   
                                   for(int i = 0;i<filesArray.count;i++){
                                       if(i== sender.tag){
                                           continue;
                                       }
                                       NSString *str = filesArray[i][@"exerciseNames"];
                                       NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
                                       NSArray *compareArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                       
                                       if(deletedArray.count>0 && compareArray.count>0){
                                           [deletedArray removeObjectsInArray:compareArray];
                                       }
                                   }
                                   
                                   [self deleteExerciseDetails:sessionId];
                                   [self deleteFiles:deletedArray];
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {}];
    
    
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
    
    
}

- (IBAction)sessionPlayButtonPressed:(UIButton *)sender {
    
    NSDictionary *sesionDetails = filesArray[sender.tag];
    
    if(![Utility isEmptyCheck:sesionDetails]){
        
        //@"UserId",@"exerciseDetails",@"exSessionId",@"isCustom",@"sessionCompleteId",@"weekStartDate",
        
        int exSessionId = [sesionDetails[@"exSessionId"] intValue];
        BOOL isCustom = [sesionDetails[@"isCustom"] boolValue];
        int sessionCompleteId = [sesionDetails[@"sessionCompleteId"] intValue];
        NSString *weekDate = sesionDetails[@"weekStartDate"];
        NSString *sessionDate = sesionDetails[@"sessionDate"];
        
        
        ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
        
        controller.exSessionId = exSessionId;
        controller.weekDate =  weekDate;
        controller.sessionDate =  sessionDate;
        controller.fromWhere =(isCustom)?@"customSession":@"DailyWorkout";
        controller.workoutTypeId = sessionCompleteId;
        controller.completeSessionId = sessionCompleteId;
        [self.navigationController pushViewController:controller animated:YES];
        
        
//        ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
//        controller.completeSessionId = [[[dataArray objectAtIndex:0] objectForKey:@"ExerciseSessionId"] intValue]; // AY 05012018
//        controller.exSessionId = exSessionID;
//        controller.fromWhere = @"DailyWorkout"; //add_su_2/8/17
//        controller.sessionDate = _dateStr;  //ah 2.2
//        controller.weekDate = _dateStr;  //AY 07112017
//        controller.exerciseSessionType = exerciseSessionType;
        
        
    }
}
#pragma mark - End

#pragma mark - Private Method



-(NSArray *)getFilesFromDocumentDirectory:(NSArray *)extentions{
    
    NSMutableArray *matches = [[NSMutableArray alloc]init];
    NSFileManager *fManager = [NSFileManager defaultManager];
    NSString *item;
    NSArray *contents = [fManager contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil];
    
    // >>> this section here adds all files with the chosen extension to an array
    for (item in contents){
        
        if ([extentions containsObject:[item pathExtension]]) {
            [matches addObject:item];
        }
    }
    return matches;
    
}
-(void)prepareInstruction{
    //[self showInstructionOverlays];
    if([Utility isSubscribedUser]){
        if (![Utility isEmptyCheck:[defaults objectForKey:@"InstructionOverlays"]]){
            NSMutableArray *insArray = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"InstructionOverlays"]];
            if (![insArray containsObject:@"CONTENTMGMT"]) {
                //[self helpButtonPressed:helpButton];
                [self showInstructionOverlays];
                [insArray addObject:@"CONTENTMGMT"];
                [defaults setObject:insArray forKey:@"InstructionOverlays"];
            }
        }else {
            //[self helpButtonPressed:helpButton];
            [self showInstructionOverlays];
            NSMutableArray *insArray = [[NSMutableArray alloc] init];
            [insArray addObject:@"CONTENTMGMT"];
            [defaults setObject:insArray forKey:@"InstructionOverlays"];
        }
    }
}
-(NSArray *)getDownloadedSessions{
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        NSArray *arr;
        DAOReader *dbObject = [DAOReader sharedInstance];
        if([dbObject connectionStart]){
            
           arr = [dbObject selectBy:@"exerciseDetails" withColumn:[[NSArray alloc]initWithObjects:@"UserId",@"exerciseDetails",@"exSessionId",@"isCustom",@"sessionCompleteId",@"weekStartDate",@"sessionDate",@"exerciseNames",nil] whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exerciseNames != ''",userId]];
            
            [dbObject connectionEnd];
        }
    
    return arr;
}
-(void)deleteExerciseDetails:(int)sessionId{
    
    DAOReader *dbObject = [DAOReader sharedInstance];
    if([dbObject connectionStart]){
        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
        
        [dbObject deleteWhen:@"exerciseDetails" whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and exSessionId = '%d'",userId,sessionId]];
        
        [dbObject connectionEnd];
        
        filesArray = [[self getDownloadedSessions] mutableCopy];
        [itemsTable reloadData];
        
        noItemsLabel.text = @"No Downloaded Session Found";
        if(filesArray.count>0){
            noItemsLabel.hidden = true;
        }else{
            noItemsLabel.hidden = false;
        }
    }
    
}

-(void)deleteFiles:(NSArray *)arr{
    
    for(NSString *itemName in arr){
        
        NSString *videoFile = [@"" stringByAppendingFormat:@"%@.mp4",itemName];
        NSString *mp3File = [@"" stringByAppendingFormat:@"%@.mp3",itemName];
        NSString *wavFile = [@"" stringByAppendingFormat:@"%@.wav",itemName];
        
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:videoFile];
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
        
        fullPathToFile = [documentsDirectory stringByAppendingPathComponent:mp3File];
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
        
        fullPathToFile = [documentsDirectory stringByAppendingPathComponent:wavFile];
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
    }
    
   
    
}

#pragma mark - End
#pragma mark - Local Notification Observer
-(void)backButtonPressed:(NSNotification *)notification{
    
//    if(itemsView.isHidden){
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        itemsView.hidden = true;
//        [headerButton setTitle:@"CONTENT MANAGEMENT" forState:UIControlStateNormal];
//    }
//    if([Utility isSubscribedUser] && [Utility isOfflineMode]){
//            [self.slidingViewController anchorTopViewToLeftAnimated:YES];
//            [self.slidingViewController resetTopViewAnimated:YES];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
   
}
#pragma mark - End

#pragma mark - TableView Datasource & Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return filesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"TableViewCell";
    
    if(isDownloadedSessionList){
        
        CellIdentifier = @"DownloadedSessionTableViewCell";
        DownloadedSessionTableViewCell *cell = (DownloadedSessionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[DownloadedSessionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *str = filesArray[indexPath.row][@"exerciseDetails"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *sessionData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        if(![Utility isEmptyCheck:sessionData]){
            NSString *sessionTitle =@"";
            
            if(![Utility isEmptyCheck:sessionData[@"SessionTitle"]]){
                sessionTitle =sessionData[@"SessionTitle"];
            }
            
            cell.titleLabel.text = sessionTitle;
        }
        
        cell.playButton.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        
        return cell;
        
    }else{
        TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *itemName = filesArray[indexPath.row];
        itemName = [itemName stringByDeletingPathExtension];
        
        cell.itemNameLabel.text = itemName;
        
        //    cell.FaFTimeLabel.text = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"time"];
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    return (isDownloadedSessionList)?NO:YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"Do you want to delete this file?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSString *itemName = filesArray[indexPath.row];
                                       NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                       NSString* documentsDirectory = [paths objectAtIndex:0];
                                       NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:itemName];
                                       [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:fullPathToFile] error:nil];
                                       [filesArray removeObjectAtIndex:indexPath.row];
                                       [itemsTable reloadData];
                                       
                                   }];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {}];
        
        
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        
    }
}


#pragma mark - End

#pragma  mark -Show Instructions
- (void) showInstructionOverlays {
    
    NSMutableArray *overlayViews = [[NSMutableArray alloc] init];
    NSArray *messageArray = @[@"Swipe to delete file from your device."
                              ];
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:headerButton forKey:@"view"];
        [dict setObject:@YES forKey:@"onTop"];
        [dict setObject:messageArray[0] forKey:@"insText"];
        [dict setObject:@YES forKey:@"isCustomFrame"];
        NSLog(@"%@",NSStringFromCGRect([headerButton convertRect:headerButton.bounds toView:headerButton]));
        CGRect tempRect=[self.view convertRect:headerButton.bounds fromView:headerButton];
        
        CGRect rect = CGRectMake(tempRect.origin.x, tempRect.origin.y+tempRect.size.height, tempRect.size.width, tempRect.size.height);
        [dict setObject:[NSValue valueWithCGRect:rect] forKey:@"frame"];
        [overlayViews addObject:dict];
        
    
    
    
    [Utility initializeInstructionAt:self OnViews:overlayViews];
}
#pragma  mark -End
@end
