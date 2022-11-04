//
//  ExerciseListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 19/01/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "ExerciseListTableViewCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IndividualExerciseViewController.h"
#import "AdvanceSearchViewController.h"
#import "ExcerciseHistoryViewController.h"
#import "SessionHistoryViewController.h"
#import "ExerciseDetailsVideoViewController.h"

@interface ExerciseListViewController (){
    IBOutlet UITableView *table;
    IBOutlet UITextField *searchTextField;
    NSArray *exerciseArray;
    BOOL isImageShown;
    UIView *contentView;
    int selectedIndex;
    AVPlayer *player;
    IBOutlet UIView *exerciseView;
    IBOutlet UIView *searchView;
    IBOutlet UIButton *advanceSearch;
    IBOutlet UILabel *noDataLabel;
}

@end

@implementation ExerciseListViewController
#pragma -mark ViewLifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isImageShown  = true;
    noDataLabel.hidden = true;
    table.estimatedRowHeight = 70; //70
    table.rowHeight = UITableViewAutomaticDimension;
    [self getExerciseList:@""];
    selectedIndex = -1;
    exerciseView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    exerciseView.layer.borderWidth = 2.0;
    searchView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    searchView.layer.borderWidth = 1.12;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [searchTextField resignFirstResponder];
}
#pragma -mark End
#pragma mark -APICall
-(void)advanceSearch:(NSDictionary *)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchExercisesApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         exerciseArray = [responseDict objectForKey:@"Exercises"];
                                                                         [table reloadData];
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
-(void)getExerciseList:(NSString *)searchText{
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
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:searchText forKey:@"SearchText"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetExercisesApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         exerciseArray = [responseDict objectForKey:@"Exercises"];
                                                                         if (![Utility isEmptyCheck:exerciseArray]) {
                                                                             noDataLabel.hidden = true;
                                                                         }else{
                                                                             noDataLabel.hidden = false;
                                                                         }
                                                                         [table reloadData];
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
#pragma mark -End

#pragma mark -IBAction
- (IBAction)substituteExercisesButtonPressed:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.exerciseId = (int)sender.tag;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(void)loadNewScreen:(int)Id{
    
    IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.exerciseId = Id;
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [player pause];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [player pause];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)previous:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.integerValue];
    ExerciseListTableViewCell * cell = (ExerciseListTableViewCell *) [table cellForRowAtIndexPath:indexPath];
    [cell.playerController.player pause];
    [UIView transitionWithView:cell.playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                    }
                    completion:^(BOOL finished){
//                        cell.nextButton.hidden = NO; //chng
//                        cell.previousButton.hidden = NO; //chng
                        if (cell.exImage.hidden) {
                            cell.exImage.hidden = NO;
                            cell.playerView.hidden = YES;
                        }else{
                            cell.exImage.hidden = YES;
                            cell.playerView.hidden = NO;
                        }
                       
                        
                    }
     ];
   
}
- (IBAction)next:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.integerValue];
    ExerciseListTableViewCell * cell = (ExerciseListTableViewCell *) [table cellForRowAtIndexPath:indexPath];
    [cell.playerController.player pause];
    [UIView transitionWithView:cell.playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    }
                    completion:^(BOOL finished){
//                        cell.previousButton.hidden = NO; chng
//                        cell.nextButton.hidden = NO; //chng
                        if (cell.exImage.hidden) {
                            cell.exImage.hidden = NO;
                            cell.playerView.hidden = YES;
                        }else{
                            cell.exImage.hidden = YES;
                            cell.playerView.hidden = NO;
                        }
                        
                    }
     ];

}
- (IBAction)cellExpandCollapse:(UIButton *)sender {
    if (selectedIndex == sender.tag) {
        selectedIndex = -1;
    }else{
        selectedIndex = (int)sender.tag;
    }
    [table reloadData];
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.intValue] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}
- (IBAction)AdvanceSearchButtonPressed:(id)sender {
    //[Utility msg:@"Coming on Feb 20." title:@"Alert" controller:self haveToPop:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
        advanceSearch.selected = true;
        AdvanceSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearch"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
- (IBAction)hideImageButton:(UIButton *)sender {
    if (isImageShown) {
        isImageShown = false;
    }else{
        isImageShown = true;
    }
    [table reloadData];
}
-(IBAction)historyButtonPressed:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        ExcerciseHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        NSDictionary *dict = [exerciseArray objectAtIndex:sender.tag];
        controller.exerciseName = [dict objectForKey:@"ExerciseName"];
        controller.excerciseId =[[dict objectForKey:@"ExerciseId"]intValue];
        [self presentViewController:controller animated:YES completion:nil];
    });
}

-(IBAction)sessionHistoryButtonPressed:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [player pause];
        SessionHistoryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SessionHistoryView"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        NSDictionary *dict = [exerciseArray objectAtIndex:sender.tag];
        controller.exerciseName = [dict objectForKey:@"ExerciseName"];
        controller.excerciseId =[[dict objectForKey:@"ExerciseId"]intValue];
        [self presentViewController:controller animated:YES completion:nil];
    });
}
#pragma mark -End
#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exerciseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"ExerciseListTableViewCell";
    ExerciseListTableViewCell *cell = (ExerciseListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[ExerciseListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [exerciseArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.exerciseName.text= ![Utility isEmptyCheck:[dict objectForKey:@"ExerciseName"]] ? [dict objectForKey:@"ExerciseName"]:@"";
        
        NSArray *imageSmallArray =![Utility isEmptyCheck:[dict objectForKey:@"PhotosSmallPath"]] ? [dict objectForKey:@"PhotosSmallPath"]:[[NSArray alloc]init];
        if (imageSmallArray.count > 0) {
            NSString *imageString = [imageSmallArray objectAtIndex:0];
            [cell.exerciseImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
                cell.exerciseImage.image = [[UIImage alloc] initWithData:imageData];
            }];
//            [cell.exerciseImage sd_setImageWithURL:[NSURL URLWithString:imageString]
//                                  placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageRefreshCached];
        }
        NSArray *imageArray =![Utility isEmptyCheck:[dict objectForKey:@"Photos"]] ? [dict objectForKey:@"Photos"]:[[NSArray alloc]init];
        if (imageArray.count > 0) {
            NSString *imageString = [imageArray objectAtIndex:0];
            [cell.exImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
                cell.exImage.image = [[UIImage alloc] initWithData:imageData];
            }];
//            [cell.exImage sd_setImageWithURL:[NSURL URLWithString:imageString]
//                                  placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageRefreshCached];
        }
//        NSLog(@"ex name %@",[dict objectForKey:@"ExerciseId"]);
        cell.exerciseImage.layer.borderWidth = 0.5f;
        cell.exerciseImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.exerciseImage.layer.cornerRadius = 2.0f;
        if (isImageShown) {
            cell.exerciseImageWidthConstraint.constant = 74;
            cell.exerciseTableViewHeightConstraint.constant = 54;
        }else{
            cell.exerciseImageWidthConstraint.constant = 0;
            cell.exerciseTableViewHeightConstraint.constant = 23;
            
            
        }
        [cell.expandCollapse addTarget:self
                                action:@selector(cellExpandCollapse:)
                      forControlEvents:UIControlEventTouchUpInside];
        if (selectedIndex == indexPath.row && ![[dict objectForKey:@"LabelOnly"] boolValue]) {
            // cell.stackView.arrangedSubviews.lastObject.hidden = NO;
            [(ExerciseListTableViewCell*)cell setUpView:dict];
            [cell.stackView insertArrangedSubview:cell.detailView atIndex:1];
            NSArray *instructions = [dict objectForKey:@"Instructions"];
            if (![Utility isEmptyCheck:instructions] && instructions.count > 0) {
                cell.instruction.text = [@"" stringByAppendingFormat:@"%@",[instructions componentsJoinedByString:@"\n"]];
                cell.instructionStackView.hidden = false;

            }else{
                cell.instruction.text = @"";
                cell.instructionStackView.hidden = true;
            }
            NSArray *tips = [dict objectForKey:@"Tips"];
            if (![Utility isEmptyCheck:tips] && tips.count > 0) {
                cell.tips.attributedText  = [Utility getStringWithHeader:@"Tips : \n" headerFont:[UIFont fontWithName:@"Raleway-Medium" size:13] headerColor:[UIColor blackColor] bodyString:[@"" stringByAppendingFormat:@"\u2022  %@",[tips componentsJoinedByString:@"\n\u2022  "] ] bodyFont:[UIFont fontWithName:@"Raleway" size:13] BodyColor:[UIColor blackColor]];
                cell.tipsStackView.hidden = false;

            }else{
                cell.tips.text = @"";
                cell.tipsStackView.hidden = true;
            }
            
            cell.delegate = self;
//            NSArray *equipments = [dict objectForKey:@"Equipments"];
//            if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
//                cell.equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
//                cell.equipmentRequiredStackView.hidden = false;
//
//            }else{
//                cell.equipmentRequiredStackView.hidden = true;
//            }
//            for (UIView *view in cell.equipmentBasedAlternativesButtonStackView.arrangedSubviews) {
//                if ([view isKindOfClass:[UIButton class]]) {
//                    [cell.equipmentBasedAlternativesButtonStackView removeArrangedSubview:view] ;
//                    [view removeFromSuperview];
//                }
//            }
//            NSArray *substituteEquipments = [dict objectForKey:@"SubstituteExercises"];
//            if (substituteEquipments.count > 0) {
//                for (int i=0; i<substituteEquipments.count; i++) {
//                    NSDictionary *substituteExercisesDict = [substituteEquipments objectAtIndex:i];
//                    if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]]) {
//                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                        if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseId"]]) {
//                            [button addTarget:self
//                                       action:@selector(substituteExercisesButtonPressed:)
//                             forControlEvents:UIControlEventTouchUpInside];
//                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
//                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
//                            button.tag =[[substituteExercisesDict objectForKey:@"SubstituteExerciseId"] integerValue];
//                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
//                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                        }else{
//
//                            [button setTitle:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] forState:UIControlStateNormal];
//
//                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
//                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                        }
//                        [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];
//
//                    }
//                }
//                cell.equipmentBasedAlternativesStackView.hidden = false;
//
//            }else{
//                cell.equipmentBasedAlternativesStackView.hidden = true;
//                /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                 [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                 [button setTitle:@"N/A" forState:UIControlStateNormal];
//
//                 button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//                 button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
//                 [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                 [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];*/
//            }
//
//            for (UIView *view in cell.bodyWeightAlertnativesButtonStackView.arrangedSubviews) {
//                if ([view isKindOfClass:[UIButton class]]) {
//                    [cell.bodyWeightAlertnativesButtonStackView removeArrangedSubview:view] ;
//                    [view removeFromSuperview];
//                }
//            }
//            NSArray *AltBodyWeightExercises = [dict objectForKey:@"AltBodyWeightExercises"];
//            if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
//                for (int i=0; i<AltBodyWeightExercises.count; i++) {
//                    NSDictionary *altBodyWeightExercisesDict = [AltBodyWeightExercises objectAtIndex:i];
//                    if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]]) {
//                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                        if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"]]) {
//                            [button addTarget:self
//                                       action:@selector(substituteExercisesButtonPressed:)
//                             forControlEvents:UIControlEventTouchUpInside];
//                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
//                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
//                            button.tag =[[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"] integerValue];
//                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
//                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                        }else{
//
//                            [button setTitle:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] forState:UIControlStateNormal];
//
//                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//
//                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
//                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                        }
//                        [cell.bodyWeightAlertnativesButtonStackView addArrangedSubview:button];
//
//                    }
//                }
//                cell.bodyWeightAlertnativesStackView.hidden = false;
//            }else{
//                cell.bodyWeightAlertnativesStackView.hidden = true;
//            }
            [player pause];
            player = nil;
            if (cell.playerController.player) {
                [cell.playerController.player pause];
                [cell.playerController removeFromParentViewController];
            }
            
            NSString *videoId = [dict objectForKey:@"PublicUrl"];
            
            if (![Utility isEmptyCheck:videoId]) {
                cell.playerContainer.hidden =false;
                
                AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc]init];
                NSURL *videoUrl = [NSURL URLWithString:videoId];
                player = [AVPlayer playerWithURL:videoUrl];
                [player play];
                playerViewController.player = player;
                playerViewController.delegate = self;
                playerViewController.showsPlaybackControls = YES;
                [self addChildViewController:playerViewController];
                [playerViewController didMoveToParentViewController:self];
                playerViewController.view.frame = cell.playerView.bounds;
                [cell.playerView addSubview:playerViewController.view];
                cell.playerController = playerViewController;
            }else{
                cell.playerContainer.hidden =true;
            }
            cell.nextButton.tag = indexPath.row;
            cell.nextButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section ];
            cell.previousButton.tag = indexPath.row;
            cell.previousButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section ];
            cell.exImage.hidden = true;
//            cell.previousButton.hidden = NO; //chng
            cell.playerView.hidden = false;
//            cell.nextButton.hidden = NO; //chng

        }else{
            if (cell.playerController.player) {
                [cell.playerController.player pause];
                cell.playerController.player = nil;
                [cell.playerController removeFromParentViewController];
            }
            
            [cell.stackView removeArrangedSubview:cell.detailView];
            [cell.detailView removeFromSuperview];
            // cell.stackView.arrangedSubviews.lastObject.hidden = YES;
        }
        cell.expandCollapse.tag = indexPath.row;
        cell.historyButton.tag = indexPath.row; //add_new_1
        cell.historyButton.layer.borderColor =[Utility colorWithHexString:@"E425A0"].CGColor;
        cell.historyButton.layer.borderWidth= 1;
        cell.sessionHistoryButton.tag = indexPath.row; //add_new_1
        cell.sessionHistoryButton.layer.borderColor =[Utility colorWithHexString:@"E425A0"].CGColor;
        cell.sessionHistoryButton.layer.borderWidth = 1;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[exerciseArray objectAtIndex:indexPath.row]);
    dispatch_async(dispatch_get_main_queue(), ^{
            advanceSearch.selected = false;
            NSDictionary *dict = [exerciseArray objectAtIndex:indexPath.row];
            ExerciseDetailsVideoViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetailsVideo"];
            controller.circuitDict = dict;
            controller.fromExerciseList = true;
            controller.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:controller animated:YES completion:nil];
        
    });
}

#pragma -mark End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchTextField) {
        [textField resignFirstResponder];
        advanceSearch.selected = false;
        NSString *searchString = textField.text;
        textField.text = @"";
        [self getExerciseList:searchString];
        return YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
#pragma -mark End
#pragma -mark Advance Search Delegate
- (void) applyFilter:(NSDictionary *)data{
    NSLog(@"------------%@",data);
    [self.view endEditing:true];
    [self advanceSearch:data];
}

-(void)dismissFromAdvancesearch{
    advanceSearch.selected = false;
}
#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
