//
//  BucketListNewViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 17/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "BucketListNewViewController.h"
#import "BucketListNewTableViewCell.h"
#import "BucketListNewAddEditViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CustomNutritionPlanListInnerCollectionViewCell.h"
@interface BucketListNewViewController (){
    IBOutlet UILabel *headerFirstLabel;
    IBOutlet UILabel *headerSecondLabel;
    IBOutlet UILabel *headerThirdLabel;
    
    IBOutlet UIStackView *BucketListStackView;
    IBOutlet UIView *videoView;
    IBOutlet UITableView *tableView;
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UICollectionView *dateCollection;
    IBOutlet UIButton *bucketListButton;
    IBOutlet UITextView *infoText;
    IBOutlet UIView *infoview;
    IBOutlet UIView *viewFilter;
    IBOutlet UIButton *showresults;
    IBOutlet UIButton *clearAllButton;
    IBOutletCollection(UIButton) NSArray*sortButtonArray;
    IBOutletCollection(UIButton) NSArray*filterButtonArray;
    IBOutlet UILabel *gameOnlabel;
    IBOutletCollection(UIButton) NSArray *infoButtonArray;
    IBOutlet UIButton *manualButton;
    IBOutlet UIButton *addedButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *filterButton;
    IBOutlet UIView *addButtonShowView;
    IBOutlet UIView *editDelView;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *delButton;
    IBOutlet UIView *editDelSubView;
    IBOutletCollection(UIButton) NSArray*timeLinefilterButtonArray;

    AVPlayer *videoPlayer;
    AVPlayerViewController *playerController;
    NSMutableArray *BucketListArray;
    UIView *contentView;
    BOOL isExpand;
    NSArray *helpVideos;
    int helpVideoCount;
    
    BOOL shouldSetupRem;    //ah ln
    
    BOOL isOnlyToday;
    NSDate *beginningOfWeek;
    NSDate *endOfWeek;
    NSDate *selectedDate;
    NSArray *selectedAray;
    NSArray *mainBucketListArr;
    BOOL isReload;
    NSArray *filterTagArr;
    UIRefreshControl *refreshControl;
    NSMutableDictionary *bucketData;
    NSArray *statusArr;
    NSArray *timeLineArr;
}

@end

@implementation BucketListNewViewController
@synthesize goalValueArray;

#pragma mark - IBAction
- (IBAction)addBucketListButtonPressed:(id)sender {
    NotesViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotesView"];
    controller.notesDelegate = self;
    controller.fromStr = @"BucketList";
    [self.navigationController pushViewController:controller animated:YES];
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

-(IBAction)helpButtonTapped:(id)sender{
    if (!isExpand) {
        isExpand = true;
        [BucketListStackView addArrangedSubview:videoView];
        [self playVideoWithUrlStr:[helpVideos objectAtIndex:helpVideoCount] InsideView:videoView];
//        [self playVideoWithUrlStr:@"https://player.vimeo.com/external/144428216.m3u8?s=43e9888e6d53f400a149335e79716b07d9edeb90" InsideView:videoView];    //ahv
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[videoPlayer currentItem]];
    } else {
        [BucketListStackView removeArrangedSubview:videoView];
        [videoView removeFromSuperview];
        isExpand = false;
        [videoPlayer pause];
        if (playerController.player || videoPlayer) {
            [playerController.player pause];
            [videoPlayer pause];
            videoPlayer = nil;
            [playerController removeFromParentViewController];
        }
    }
    
}

- (IBAction)nextPressed:(id)sender {
    if (isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = 5*24*60*60;
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}
-(IBAction)crossView:(id)sender{
    viewFilter.hidden = true;
}
- (IBAction)PrevPressed:(id)sender {
    if (isOnlyToday) {
        return;
    }
    NSTimeInterval sevenDays = -5*24*60*60;
    beginningOfWeek = [beginningOfWeek dateByAddingTimeInterval:sevenDays];
    endOfWeek = [endOfWeek dateByAddingTimeInterval:sevenDays];
    [self getSelectedWeek];
}
-(IBAction)filterButtnPressed:(id)sender{
    viewFilter.hidden = false;
}
-(IBAction)infoButtonPressed:(id)sender{
    infoview.hidden = false;
}
-(IBAction)crossButtonPressed:(id)sender{
    infoview.hidden = true;
}
-(IBAction)notificationButtonPressed:(UIButton*)sender{
//    bucketData = [[NSMutableDictionary alloc]init];
//    bucketData = [[BucketListArray objectAtIndex:sender.tag]mutableCopy];
//    [self->bucketData setObject:[NSNumber numberWithBool:false]  forKey:@"PushNotification"];
//    [self->bucketData setObject:[NSNumber numberWithBool:false] forKey:@"Email"];
//    [self saveDataMultiPart];
    NSDictionary *dict = [BucketListArray objectAtIndex:sender.tag];
    if ([Utility isEmptyCheck:dict]) {
        return;
    }
     BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
      controller.bucketData = [dict mutableCopy];
      controller.isFromNotificaton = YES;
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)tickuntickButtonPressed:(UIButton*)sender{
  

//    for (UIButton *btn in sortButtonArray) {
//        if (btn.tag == sender.tag) {
//            btn.selected = true;
//        }else{
//            btn.selected = false;
//        }
//    }
}
-(IBAction)showResult:(id)sender{
    NSMutableArray *arr = [NSMutableArray new] ;
    if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
        [BucketListArray removeAllObjects];
    }
    BOOL isCheck =false;
    int value = 0;
    for(UIButton *button in timeLinefilterButtonArray){
        if (button.selected) {
            isCheck = true;
            if (button.tag == 1 && button.selected) {
                value = 1;
            }else if (button.tag == 2 && button.selected){
                value = 5;
            }
            [defaults setBool:true forKey:@"timeLineTick"];
        }
    }
    if (!isCheck) {
        [defaults setBool:false forKey:@"timeLineTick"];

    }
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    if (![Utility isEmptyCheck:mainBucketListArr]) {
        arr = [defaults objectForKey:@"bucketListFilterStatus"];
        
        if (arr.count==3) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketActive];
            NSArray *filterArr = [mainBucketListArr filteredArrayUsingPredicate:predicate];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketHidden];
            NSArray *filterArr1 = [mainBucketListArr filteredArrayUsingPredicate:predicate1];
            
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketCompleted];
            NSArray *filterArr2= [mainBucketListArr filteredArrayUsingPredicate:predicate2];
                      
            if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
                [BucketListArray removeAllObjects];
            }
            filterButton.selected = true;
            [BucketListArray addObjectsFromArray:filterArr];
            [BucketListArray addObjectsFromArray:filterArr1];
            [BucketListArray addObjectsFromArray:filterArr2];
            
            if ([defaults boolForKey:@"timeLineTick"] && value>0) {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i = 0; i<BucketListArray.count; i++) {
                  NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                   NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                   if (splitArr.count>0) {
                        dateStr = splitArr[0];
                       }
                     NSDate *year = [formatter dateFromString:dateStr];
                     if ([year compare:[[NSDate date]dateByAddingYears:value]]==NSOrderedAscending) {
                        [arr addObject:[BucketListArray objectAtIndex:i]];
                     }
                }
                BucketListArray = [arr mutableCopy];
            }
        }else if (arr.count == 2){
            NSPredicate *predicate;
            NSArray *filterArr;
            NSArray *filterArr1;
                NSString *str  = arr[0];
                if ([str isEqualToString:@"1"]) {
                    predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketActive];
                }else if ([str isEqualToString:@"2"]){
                    predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketHidden];
                }else{
                    predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketCompleted];
                }
                filterArr= [mainBucketListArr filteredArrayUsingPredicate:predicate];
       
                NSPredicate *predicate1;
                NSString *str1  = arr[1];
                if ([str1 isEqualToString:@"1"]) {
                   predicate1 = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketActive];
                }else if ([str1 isEqualToString:@"2"]){
                   predicate1 = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketHidden];
                }else{
                   predicate1 = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketCompleted];
                }
                filterArr1= [mainBucketListArr filteredArrayUsingPredicate:predicate1];
            
                if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
                    [BucketListArray removeAllObjects];
                }
                filterButton.selected = true;
                [BucketListArray addObjectsFromArray:filterArr];
                [BucketListArray addObjectsFromArray:filterArr1];
                if ([defaults boolForKey:@"timeLineTick"] && value>0) {
                     NSMutableArray *arr = [[NSMutableArray alloc]init];
                         for (int i = 0; i<BucketListArray.count; i++) {
                           NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                            NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                            if (splitArr.count>0) {
                                 dateStr = splitArr[0];
                                }
                              NSDate *year = [formatter dateFromString:dateStr];
                              if ([year compare:[[NSDate date]dateByAddingYears:value]]==NSOrderedAscending) {
                                 [arr addObject:[BucketListArray objectAtIndex:i]];
                              }
                         }
                        BucketListArray = [arr mutableCopy];

                     }
        }else if(arr.count == 1){
            NSPredicate *predicate;
            NSArray *filterArr;
            NSString *str  = arr[0];
             if ([str isEqualToString:@"1"]) {
                  predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketActive];
              }else if ([str isEqualToString:@"2"]){
                  predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketHidden];
              }else{
                  predicate = [NSPredicate predicateWithFormat:@"(BucketStatus == %d)",BucketCompleted];
             }
            if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
                [BucketListArray removeAllObjects];
            }
            filterButton.selected = true;
            filterArr = [mainBucketListArr filteredArrayUsingPredicate:predicate];
            [BucketListArray addObjectsFromArray:filterArr];
            if ([defaults boolForKey:@"timeLineTick"] && value>0) {
                NSMutableArray *arr = [[NSMutableArray alloc]init];
                for (int i = 0; i<BucketListArray.count; i++) {
                  NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                   NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                   if (splitArr.count>0) {
                        dateStr = splitArr[0];
                       }
                     NSDate *year = [formatter dateFromString:dateStr];
                     if ([year compare:[[NSDate date]dateByAddingYears:value]]==NSOrderedAscending) {
                        [arr addObject:[BucketListArray objectAtIndex:i]];
                     }
                }
                BucketListArray = [arr mutableCopy];

            }
            

        }else{
            if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
                   [BucketListArray removeAllObjects];
               }
                BucketListArray = [mainBucketListArr mutableCopy];
                if ([defaults boolForKey:@"timeLineTick"] && value>0) {
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    for (int i = 0; i<BucketListArray.count; i++) {
                        NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                        NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                        if (splitArr.count>0) {
                            dateStr = splitArr[0];
                       }
                     NSDate *year = [formatter dateFromString:dateStr];
                     if ([year compare:[[NSDate date]dateByAddingYears:value]]==NSOrderedAscending) {
                        [arr addObject:[BucketListArray objectAtIndex:i]];
                     }
                }
                BucketListArray = [arr mutableCopy];
                filterButton.selected = true;
                }else{
                    if (addedButton.selected || manualButton.selected) {
                        filterButton.selected = true;
                    }else{
                        filterButton.selected = false;
                    }
                }
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"SortFilter"]]) {
            if ([[defaults objectForKey:@"SortFilter"]isEqualToString:@"Manual"]) {
                 [self sortTickUntickButtonsPressed:manualButton];
            }else if ([[defaults objectForKey:@"SortFilter"]isEqualToString:@"DueDate"]){
                [self sortTickUntickButtonsPressed:addedButton];
            }
        }else{
          
        }
        if(![Utility isEmptyCheck:[defaults objectForKey:@"bucketListFilterStatus"]]){
            statusArr = [BucketListArray mutableCopy];
        }else{
        }
       
        viewFilter.hidden = true;
        [tableView reloadData];
    }
}

-(IBAction)clearAllButtonPressed:(id)sender{
    if(![Utility isEmptyCheck:filterTagArr]){
       [defaults removeObjectForKey:@"bucketListFilterStatus"];
    }
    if(![Utility isEmptyCheck:timeLineArr]){
        [defaults removeObjectForKey:@"bucketListTimeLineFilterStatus"];
    }
    [defaults setBool:false forKey:@"timeLineTick"];
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"SortFilter"]]) {
        [defaults removeObjectForKey:@"SortFilter"];
    }
    filterButton.selected = false;
    for(UIButton *button in filterButtonArray){
        button.selected=false;
    }
    for(UIButton *button in sortButtonArray){
        button.selected=false;
    }
    for(UIButton *button in timeLinefilterButtonArray){
           button.selected=false;
       }
    if (![Utility isEmptyCheck:BucketListArray] && BucketListArray.count>0) {
        [BucketListArray removeAllObjects];
    }
    manualButton.selected=false;
    addedButton.selected = false;
    [tableView setEditing:false];
    saveButton.hidden = true;
    BucketListArray=[mainBucketListArr mutableCopy];
    viewFilter.hidden = true;
    [tableView reloadData];
}
-(IBAction)sortTickUntickButtonsPressed:(UIButton*)sender{
    filterButton.selected = true;
    if (sender==manualButton) {
        addedButton.selected=false;
        sender.selected = true;
        viewFilter.hidden = true;
        saveButton.hidden = false;
        [Utility startFlashingbuttonForManualSort:saveButton];
        [tableView setEditing:true];
        [tableView reloadData];
    }else if (sender==addedButton){
        manualButton.selected=false;
        sender.selected = true;
        viewFilter.hidden = true;
        saveButton.hidden = true;
        [tableView setEditing:false];
//        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"CreatedAtString" ascending:YES];
        NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"CompletionDate" ascending:YES];
        NSArray *sorted = [BucketListArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        BucketListArray = [sorted mutableCopy];
        [tableView reloadData];
    }
    if (sender == manualButton) {
        [defaults setObject:@"Manual" forKey:@"SortFilter"];
    }else if(sender == addedButton){
        [defaults setObject:@"DueDate" forKey:@"SortFilter"];
    }
    [tableView setContentOffset:CGPointZero animated:YES];

}
-(IBAction)tickuntickFilterButtonPressed:(UIButton*)sender{
    if (sender.selected) {
            sender.selected = false;
        }else{
            sender.selected = true;
        }
    
    NSMutableArray *arr = [NSMutableArray new];
    BOOL isCheck = false;
    for(UIButton *button in filterButtonArray){
        if (button.selected == true) {
            isCheck = true;
            [arr addObject:[@""  stringByAppendingFormat:@"%ld", (long)button.tag]];
            filterTagArr = [arr mutableCopy];
        }
    }
        if(![Utility isEmptyCheck:filterTagArr] && isCheck){
           [defaults setObject:filterTagArr forKey:@"bucketListFilterStatus"];
        }else{
           [defaults removeObjectForKey:@"bucketListFilterStatus"];
        }
//    for (UIButton *btn in filterButtonArray) {
//           if (btn.tag == sender.tag) {
//               btn.selected = true;
//           }else{
//               btn.selected = false;
//           }
//       }
}
-(IBAction)tickuntickTimelineFilterButtonPressed:(UIButton*)sender{
   filterButton.selected = true;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    for(UIButton *button in timeLinefilterButtonArray){
        if (button.tag == sender.tag) {
                button.selected = true;
                if (button.tag == 1) {
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    if (![Utility isEmptyCheck:[defaults objectForKey:@"bucketListFilterStatus"]]) {
                        BucketListArray = [statusArr mutableCopy];
                    }else{
                        BucketListArray = [mainBucketListArr mutableCopy];
                    }
                    for (int i = 0; i<BucketListArray.count; i++) {
                         NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                         NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                         if (splitArr.count>0) {
                             dateStr = splitArr[0];
                         }
                         NSDate *year = [formatter dateFromString:dateStr];
                        if ([year compare:[[NSDate date]dateByAddingYears:1]]==NSOrderedAscending) {
                             [arr addObject:[BucketListArray objectAtIndex:i]];
                        }
                    }
                    BucketListArray = [arr mutableCopy];
                }else if (button.tag == 2){
                    NSMutableArray *arr = [[NSMutableArray alloc]init];
                    if (![Utility isEmptyCheck:[defaults objectForKey:@"bucketListFilterStatus"]]) {
                           BucketListArray = [statusArr mutableCopy];
                    }else{
                           BucketListArray = [mainBucketListArr mutableCopy];
                    }
                    for (int i = 0; i<BucketListArray.count; i++) {
                         NSString *dateStr =[[BucketListArray objectAtIndex:i]objectForKey:@"CompletionDate"];
                         NSArray *splitArr = [dateStr componentsSeparatedByString:@"T"];
                          if (splitArr.count>0) {
                             dateStr = splitArr[0];
                         }
                         NSDate *year = [formatter dateFromString:dateStr];
                        if ([year compare:[[NSDate date]dateByAddingYears:5]]==NSOrderedAscending) {
                             [arr addObject:[BucketListArray objectAtIndex:i]];
                        }
                    }
                    BucketListArray = [arr mutableCopy];
                }else{
                    [self showResult:0];
//                    if (![Utility isEmptyCheck:[defaults objectForKey:@"bucketListFilterStatus"]]) {
//                        BucketListArray = [statusArr mutableCopy];
//                    }else{
//                        BucketListArray = [mainBucketListArr mutableCopy];
//                    }
            }
        }else{
            button.selected = false;
        }
        viewFilter.hidden = true;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for(UIButton *button in timeLinefilterButtonArray){
           if (button.tag == sender.tag) {
               [arr addObject:[@"" stringByAppendingFormat:@"%ld",button.tag]];
               timeLineArr = [arr mutableCopy];
           }
        }
        if(![Utility isEmptyCheck:timeLineArr]){
                  [defaults setObject:timeLineArr forKey:@"bucketListTimeLineFilterStatus"];
              }else{
                  [defaults removeObjectForKey:@"bucketListTimeLineFilterStatus"];
              }
        [tableView reloadData];
    }
}
-(IBAction)reorderSaveButtonPressed:(id)sender{
    NSArray *array = [BucketListArray valueForKey:@"id"];
    [Utility stopFlashingbuttonForManual:saveButton];
     tableView.editing = false;
        self->saveButton.hidden = true;
        if (![Utility isEmptyCheck:array]) {
        [self webSerViceCall_UpdateBucketListManualOrder:array];
    }
}
-(IBAction)editDelCrossPressed:(id)sender{
    editDelView.hidden = true;
}
-(IBAction)editPressed:(UIButton*)sender{
       editDelView.hidden = true;
       if ([Utility isEmptyCheck:BucketListArray[sender.tag]]) {
              return;
        }
          NSDictionary *dict = BucketListArray[sender.tag];
          BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
          controller.bucketData = [dict mutableCopy];
          [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)deleteButtonPressed:(UIButton*)sender{
        editDelView.hidden = true;
        if ([Utility isEmptyCheck:BucketListArray[sender.tag]]) {
          return;
        }
        NSDictionary *habitDict = BucketListArray[sender.tag];

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert!"
                                      message:@"Do you want to delete ?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* delete = [UIAlertAction
                             actionWithTitle:@"DELETE"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                [self delete:habitDict];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [alert addAction:delete];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - Private Method
-(void)prepareFilterViewOnload{
    if(![Utility isEmptyCheck:[defaults objectForKey:@"bucketListFilterStatus"]]){
        filterTagArr = [defaults objectForKey:@"bucketListFilterStatus"];
        
        for(UIButton *button in filterButtonArray){
            NSString *tagStr = [@"" stringByAppendingFormat:@"%ld",button.tag];
            if([filterTagArr containsObject:tagStr]){
                button.selected = true;
            }
        }
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"bucketListTimeLineFilterStatus"]]) {
        timeLineArr = [defaults objectForKey:@"bucketListTimeLineFilterStatus"];
        for (UIButton *button in timeLinefilterButtonArray) {
            NSString *tagStr = [@"" stringByAppendingFormat:@"%ld",button.tag];
            if ([timeLineArr containsObject:tagStr]) {
                button.selected = true;
            }
        }
        
    }
    if (![Utility isEmptyCheck:[defaults objectForKey:@"SortFilter"]]) {
        if ([[defaults objectForKey:@"SortFilter"]isEqualToString:@"Manual"]) {
            manualButton.selected = true;
            addedButton.selected = false;
        }else if ([[defaults objectForKey:@"SortFilter"]isEqualToString:@"DueDate"]){
            manualButton.selected = false;
            addedButton.selected = true;
        }
    }else{
        manualButton.selected = false;
        addedButton.selected = false;
    }
}

//pull to refresh
- (void)refreshTable {
    [refreshControl endRefreshing];
    [self webServicecallForGetReverseBucketListApiCall];
}


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
-(void)webSerViceCall_UpdateBucketListManualOrder:(NSArray*)bucketIds{
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
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:bucketIds forKey:@"BucketListIds"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateBucketListManualOrder" append:@""forAction:@"POST"];
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
                                                                         [self clearAllButtonPressed:nil];
                                                                         [self webServicecallForGetReverseBucketListApiCall];
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

-(void)webServicecallForGetReverseBucketListApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
             if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeBucket"]] || ![defaults boolForKey:@"isFirstTimeBucket"]) {
                  [defaults setObject:[NSNumber numberWithBool:true] forKey:@"isFirstTimeBucket"];
                  [self->contentView removeFromSuperview];
             }else{
                 if (self->contentView) {
                     [self->contentView removeFromSuperview];
                 }
                 self->contentView = [Utility activityIndicatorView:self];
             }
            
        });
        NSURLSession *achieveSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[NSNumber numberWithInt:1] forKey:@"OrderBy"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetBucketListApiCall" append:@"" forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[achieveSession dataTaskWithRequest:request
                                                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                               dispatch_async(dispatch_get_main_queue(),^ {
                                                                   if (self->contentView) {
                                                                       [self->contentView removeFromSuperview];
                                                                   }
                                                                   if(error == nil)
                                                                   {
                                                                       NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                       self->mainBucketListArr = [responseDictionary objectForKey:@"Details"];
//                                                                       BucketListArray = [responseDictionary objectForKey:@"Details"];
                                                                       if (![Utility isEmptyCheck:self->mainBucketListArr] && self->mainBucketListArr.count>0) {
                                                                           self->addButtonShowView.hidden = true;
                                                                           self->tableView.hidden = false;
                                                                           [self filterDate];

                                                                           if (self->shouldSetupRem) {
                                                                               self->shouldSetupRem = NO;
                                                                               [self setUpReminder];    //ah ln
                                                                           }
                                                                           
                                                                           [self showResult:0];
                                                                       }else{
                                                                           self->BucketListArray = [[NSMutableArray alloc]init];
                                                                           self->addButtonShowView.hidden = false;
                                                                           self->tableView.hidden = true;
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
-(void) saveDataMultiPart {
    if (Utility.reachable) {        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:bucketData forKey:@"model"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddUpdateBucketApiCallWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        //controller.chosenImage=selectedImage;
        controller.chosenImage=nil;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)delete:(NSDictionary*)bucketData{
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
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[bucketData valueForKey:@"id"] forKey:@"BucketID"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteBucketApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         UIAlertController *alertController = [UIAlertController
                                                                                                               alertControllerWithTitle:@"Success"
                                                                                                               message:@"Deleted Successfully. "
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                                         UIAlertAction *okAction = [UIAlertAction
                                                                                                    actionWithTitle:@"OK"
                                                                                                    style:UIAlertActionStyleDefault
                                                                                                    handler:^(UIAlertAction *action)
                                                                                                    {
                                                                                                        self->shouldSetupRem = YES;
                                                                                                        [self webServicecallForGetReverseBucketListApiCall];
                                                                                                    }];
                                                                         [alertController addAction:okAction];
                                                                         [self presentViewController:alertController animated:YES completion:nil];
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
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
            return;
        });
        
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
        if ([pushTo caseInsensitiveCompare:@"BucketList"] == NSOrderedSame) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:req];
            
        }
    }
    
    for (int i = 0; i < BucketListArray.count; i++) {
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[BucketListArray objectAtIndex:i]];
        if ([[dict objectForKey:@"PushNotification"] boolValue]) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"id"]] && ![Utility isEmptyCheck:[dict objectForKey:@"FrequencyId"]]) {
                 [SetReminderViewController setOldLocalNotificationFromDictionary:[dict mutableCopy] ExtraData:[dict mutableCopy] FromController:(NSString *)@"BucketList" Title:[dict objectForKey:@"Name"] Type:@"BucketList" Id:[[dict objectForKey:@"id"] intValue]];
            }
        }
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
    [dateCollection reloadData];
}
-(void)filterDate{
    if(selectedDate){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *dateString = [formatter stringFromDate:selectedDate];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"CreatedAtString =  %@",dateString];
        BucketListArray = [mainBucketListArr filteredArrayUsingPredicate:predicate];
        BucketListArray = [mainBucketListArr mutableCopy];
        [self->tableView reloadData];
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
    shouldSetupRem = YES;   //ah ln

    [self prepareFilterViewOnload];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"MoveToBucketEdit" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if (![Utility isEmptyCheck:notification.userInfo]) {
                    BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
                         controller.bucketData = [notification.userInfo mutableCopy];
                         [self.navigationController pushViewController:controller animated:YES];
                  }
              });
                 
       
       }];
    isReload=true;
    infoview.hidden = true;
    viewFilter.hidden = true;
    BucketListArray = [[NSMutableArray alloc]init];
    saveButton.hidden = true;
    addButtonShowView.hidden = true;
//    tableView.estimatedRowHeight = 44;
//    tableView.rowHeight = UITableViewAutomaticDimension;
    helpVideoCount = 0;
    helpVideos = [[NSArray alloc]initWithObjects:@"https://player.vimeo.com/external/144428216.m3u8?s=43e9888e6d53f400a149335e79716b07d9edeb90",@"https://player.vimeo.com/external/144428217.m3u8?s=4afc9d0ad8b161ae587eb3d67c48d3661f16ebd9", @"https://player.vimeo.com/external/144428219.m3u8?s=46f60cd53e3d6df0d64b5277bf7f290d10f0c2f3", nil];
    
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
    showresults.layer.cornerRadius =15;
    showresults.layer.masksToBounds = YES;
    clearAllButton.layer.cornerRadius = 15;
    clearAllButton.layer.masksToBounds = YES;
    clearAllButton.layer.borderColor = squadMainColor.CGColor;
    clearAllButton.layer.borderWidth = 1;
    bucketListButton.layer.cornerRadius = 15;
    bucketListButton.layer.masksToBounds = YES;
    bucketListButton.layer.borderColor = squadMainColor.CGColor;
    bucketListButton.layer.borderWidth=1;
    for (UIButton *button in infoButtonArray) {
        button.layer.cornerRadius = 15;
        button.layer.masksToBounds = YES;
    }
    [BucketListStackView removeArrangedSubview:videoView];
    [videoView removeFromSuperview];
    isExpand = false;
    tableView.estimatedRowHeight = 65;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    selectedDate = [NSDate date];
    NSTimeInterval sevenDays = -2*24*60*60;
    beginningOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    sevenDays = 2*24*60*60;
    endOfWeek = [selectedDate dateByAddingTimeInterval:sevenDays];
    
    NSLog(@"%d",[defaults boolForKey:@"isFirstTimeBucket"]);

   if ([Utility isEmptyCheck:[defaults objectForKey:@"isFirstTimeBucket"]] || ![defaults boolForKey:@"isFirstTimeBucket"]) {
       [self infoButtonPressed:0];
      
   }
    [self getSelectedWeek];
    [self webServicecallForGetReverseBucketListApiCall];

    gameOnlabel.text = @"GAME ON!\n\n The mbHQ bucket list helps you achieve your dreams and create new habits in the future without over-whelming your habit hacker now";
    
    
    //pull to refresh
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        tableView.refreshControl = refreshControl;
    } else {
        [tableView addSubview:refreshControl];
    }
    editDelView.hidden = true;
    editButton.layer.cornerRadius =15;
    editButton.layer.masksToBounds = YES;
    delButton.layer.cornerRadius = 15;
    delButton.layer.masksToBounds = YES;
    editDelSubView.layer.cornerRadius = 15;
    editDelSubView.layer.masksToBounds =YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0;
    [tableView addGestureRecognizer:longPress];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //Gesture Recognizer
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = 2.0; //seconds
//    [tableView addGestureRecognizer:lpgr];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"IsBucketListReload" object:Nil queue:Nil usingBlock:^(NSNotification * notification) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->shouldSetupRem = YES;   //ah ln
                 [self webServicecallForGetReverseBucketListApiCall];
            });
    }];
    
    [self showResult:0];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(![Utility isEmptyCheck:filterTagArr]){
        [defaults setObject:filterTagArr forKey:@"bucketListFilterStatus"];
    }else{
        [defaults removeObjectForKey:@"bucketListFilterStatus"];
    }
      if(![Utility isEmptyCheck:timeLineArr]){
           [defaults setObject:timeLineArr forKey:@"bucketListTimeLineFilterStatus"];
       }else{
           [defaults removeObjectForKey:@"bucketListTimeLineFilterStatus"];
       }
}

#pragma mark - End

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- End

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table{
    return 1;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return BucketListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
       saveButton.hidden = false;
    //    [BucketListArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        NSMutableOrderedSet *orderedSet=[NSMutableOrderedSet orderedSetWithArray:BucketListArray];
        NSInteger fromIndex = sourceIndexPath.row;
        NSInteger toIndex = destinationIndexPath.row;
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:fromIndex];
        [orderedSet moveObjectsAtIndexes:indexes toIndex:toIndex];
        BucketListArray=[[NSMutableArray arrayWithArray:[orderedSet array]] mutableCopy];
        
        [Utility startFlashingbuttonForManualSort:saveButton];
        [tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"BucketListNewTableViewCell";
    BucketListNewTableViewCell *cell;
    cell=[table dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BucketListNewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict = [BucketListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
       /* if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {
            NSString *imageUrlString =[dict objectForKey:@"Picture"];
            [cell.bucketImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
        } else {
            [cell.bucketImage setImage:[UIImage imageNamed:@"place_holder1.png"] forState:UIControlStateNormal];
        }*/
      
        if (![Utility isEmptyCheck:[dict objectForKey:@"PictureDevicePath"]]) {
            NSString *imageUrlString =[dict objectForKey:@"PictureDevicePath"];
            UIImage *selectedImage = [Utility getImageFromDocumentDirectoryWithImageName:imageUrlString];
            
            if(selectedImage){
                [cell.bucketImage setImage:selectedImage forState:UIControlStateNormal];
            }else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {
                NSString *imageUrlString =[dict objectForKey:@"Picture"];
                [cell.bucketImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"bucket_list_placeholder.png"] options:SDWebImageScaleDownLargeImages];
            }else {
                [cell.bucketImage setImage:[UIImage imageNamed:@"bucket_list_placeholder.png"] forState:UIControlStateNormal];
            }
        }else if (![Utility isEmptyCheck:[dict objectForKey:@"Picture"]]) {
            NSString *imageUrlString =[dict objectForKey:@"Picture"];
            [cell.bucketImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
        }
        else {
            [cell.bucketImage setImage:[UIImage imageNamed:@"bucket_list_placeholder.png"] forState:UIControlStateNormal];
        }
        
      
        NSString *dateString=@"";
        NSLog(@"%@",NSStringFromCGRect(cell.bucketImage.frame));
        [cell layoutIfNeeded];
        cell.bucketImage.layer.cornerRadius = 10;
        cell.bucketImage.clipsToBounds = YES;
       // cell.bucketImage.layer.borderWidth=2;
        //cell.bucketImage.layer.borderColor = [UIColor redColor].CGColor;
        NSString *dueDate = [dict objectForKey:@"CompletionDate"];
        if (dueDate.length >=19) {
            dueDate = [dueDate substringToIndex:19];
        }
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:dueDate];
        NSLog(@"%@",date);
        if (date) {
            [dateFormatter setDateFormat:@"dd/MM/YYYY"];
            dateString = [dateFormatter stringFromDate:date];
//            cell.bucketDueDate.text = dateString;
//            cell.bucketDueDate.layer.cornerRadius = cell.bucketDueDate.frame.size.height/2;
//            cell.bucketDueDate.clipsToBounds = YES;
        }else{
            //cell.bucketDueDate.hidden = TRUE;
        }
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"Name"]]) {
            cell.bucketName.text=[dict objectForKey:@"Name"];
        }
//        if (![Utility isEmptyCheck:[dict objectForKey:@"CreatedAtString"]]) {
//            dateString =[dict objectForKey:@"CreatedAtString"];
//            NSArray *arr = [dateString componentsSeparatedByString:@"-"];
//            if (arr.count>0) {
//                dateString = [@"" stringByAppendingFormat:@"%@/%@/%@",[arr objectAtIndex:2],[arr objectAtIndex:1],[arr objectAtIndex:0]];
//            }
//
//        }
        if (![Utility isEmptyCheck:dateString]) {
            NSMutableAttributedString *attributedString;
            if (indexPath.row%2 == 0) {
                attributedString = [[NSMutableAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@"%@\n",[dict objectForKey:@"Name"]]];
                              [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:19] range:NSMakeRange(0, [attributedString length])];
                              [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"363636"] range:NSMakeRange(0, [attributedString length])];
                              
                              NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:dateString];
                              [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:13] range:NSMakeRange(0, [attributedString2 length])];
                              [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"474747"] range:NSMakeRange(0, [attributedString2 length])];
                              [attributedString appendAttributedString:attributedString2];
            }else{
                attributedString = [[NSMutableAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@"%@\n",[dict objectForKey:@"Name"]]];
                              [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:19] range:NSMakeRange(0, [attributedString length])];
                              [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"363636"] range:NSMakeRange(0, [attributedString length])];
                              
                              NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:dateString];
                              [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway" size:13] range:NSMakeRange(0, [attributedString2 length])];
                              [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"474747"] range:NSMakeRange(0, [attributedString2 length])];
                              
                              [attributedString appendAttributedString:attributedString2];
            }

            cell.bucketName.attributedText = attributedString;
        }
       
        
        if((![Utility isEmptyCheck:[dict objectForKey:@"PushNotification"]] && [[dict objectForKey:@"PushNotification"] boolValue]) || (![Utility isEmptyCheck:[dict objectForKey:@"Email"]] && [[dict objectForKey:@"Email"] boolValue])){
            cell.notificationImagebutton.hidden = false;
            if (saveButton.hidden) {
                  cell.notificationImagebutton.hidden = false;
              }else{
                  cell.notificationImagebutton.hidden = true;
             }
        }else{
            cell.notificationImagebutton.hidden = true;
        }
        
       
        cell.notificationImagebutton.tag = indexPath.row;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [BucketListArray objectAtIndex:indexPath.row];
//    BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
//    controller.bucketData = [dict mutableCopy];
//    [self.navigationController pushViewController:controller animated:YES];
    
    //song19
    BucketListNewAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketListNewAddEdit"];
    controller.bucketData = [dict mutableCopy];
    [self.navigationController pushViewController:controller animated:YES];
    

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
    
    if(mainBucketListArr.count>0){
        [self filterDate];
    }
    
    [dateCollection reloadData];
}
#pragma mark - Notes Delegate
-(void)reloadData:(BOOL)isreload{
    [self webServicecallForGetReverseBucketListApiCall];
}



//#pragma mark - Gesture recognizer delegate
//-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
//{
//    CGPoint p = [gestureRecognizer locationInView:tableView];
//    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
//    if (indexPath != nil) {
//        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
//            NSDictionary *dict = [BucketListArray objectAtIndex:indexPath.row];
//            [UIPasteboard generalPasteboard].string = ![Utility isEmptyCheck:[dict objectForKey:@"Name"]]? [dict objectForKey:@"Name"] : @"";
//            [Utility showToastInsideView:self.view WithMessage:@"Copied.."];
//        }
//    }
//}
//#pragma mark - End

#pragma mark - LongPressGestureRecognizer Delegate

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
        if (sender.state == UIGestureRecognizerStateEnded) {
            NSLog(@"UIGestureRecognizerStateEnded");
   }
  else if (sender.state == UIGestureRecognizerStateBegan){
            NSLog(@"UIGestureRecognizerStateBegan");
            editDelView.hidden = false;
            CGPoint location = [sender locationInView:tableView];
            NSIndexPath *indexpath= [tableView indexPathForRowAtPoint:location];
            editButton.tag = indexpath.row;
            delButton.tag = indexpath.row;

   }
}
#pragma mark - End
- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
dispatch_async(dispatch_get_main_queue(), ^{
    if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"] boolValue]) {
        self->shouldSetupRem = YES;
        [self webServicecallForGetReverseBucketListApiCall];
    }
    });
}
@end
