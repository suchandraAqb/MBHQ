//
//  CircuitDetailsViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 14/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CircuitDetailsViewController.h"
#import "CircuitDetailsTableViewCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IndividualExerciseViewController.h"
#import "AdvanceSearchViewController.h"
@interface CircuitDetailsViewController (){
    IBOutlet UIButton *circuitName;
    IBOutlet UITableView *table;
    IBOutlet UITextField *searchTextField;
    NSArray *exerciseArray;
    BOOL isImageShown;
    UIView *contentView;
    int selectedIndex;
    AVPlayer *player;
    NSDictionary *circuitDetailDictionary;
    
}


@end

@implementation CircuitDetailsViewController
@synthesize circuitDict;
#pragma -mark ViewLifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isImageShown  = true;
    table.estimatedRowHeight = 70;
    table.rowHeight = UITableViewAutomaticDimension;
    [self getCircuitDetails];
    selectedIndex = -1;
    NSString *circuitNameString = [circuitDict objectForKey:@"CircuitName"];
    if (![Utility isEmptyCheck:circuitNameString]) {
        [circuitName setTitle:circuitNameString forState:UIControlStateNormal];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [searchTextField resignFirstResponder];
}
#pragma -mark End
#pragma mark -APICall

-(void)getCircuitDetails{
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
        [mainDict setObject:[circuitDict objectForKey:@"CircuitId"] forKey:@"CircuitId"];
        [mainDict setObject:[circuitDict objectForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCircuitDetailsApiCall" append:@""forAction:@"POST"];
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
                                                                         circuitDetailDictionary = [responseDict objectForKey:@"CircuitDetails"];
                                                                         if (![Utility isEmptyCheck:circuitDetailDictionary ]) {
                                                                             NSString *circuitNameString = [circuitDetailDictionary objectForKey:@"CircuitName"];
                                                                             if (![Utility isEmptyCheck:circuitNameString]) {
                                                                                 [circuitName setTitle:circuitNameString forState:UIControlStateNormal];
                                                                             }
                                                                             exerciseArray = [circuitDetailDictionary objectForKey:@"CircuitExercises"];
                                                                             [table reloadData];

                                                                         }
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
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {  //ah se
    if (!_isModal) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)previous:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sender.accessibilityHint.integerValue];
    CircuitDetailsTableViewCell * cell = (CircuitDetailsTableViewCell *) [table cellForRowAtIndexPath:indexPath];
    [cell.playerController.player pause];
    [UIView transitionWithView:cell.playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        
                    }
                    completion:^(BOOL finished){
                        cell.nextButton.hidden = NO;
                        cell.previousButton.hidden = NO;
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
    CircuitDetailsTableViewCell * cell = (CircuitDetailsTableViewCell *) [table cellForRowAtIndexPath:indexPath];
    [cell.playerController.player pause];
    [UIView transitionWithView:cell.playerContainer
                      duration:0.8
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    }
                    completion:^(BOOL finished){
                        cell.previousButton.hidden = NO;
                        cell.nextButton.hidden = NO;
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
#pragma mark -End
#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return exerciseArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"CircuitDetailsTableViewCell";
    CircuitDetailsTableViewCell *cell = (CircuitDetailsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[CircuitDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [exerciseArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.exerciseName.text= ![Utility isEmptyCheck:[dict objectForKey:@"ExerciseName"]] ? [dict objectForKey:@"ExerciseName"]:@"";
        cell.exerciseNumber.text= ![Utility isEmptyCheck:[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"SequenceNo"]]] ? [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"SequenceNo"]]:@"";
        
        
        
        
        
        NSString *reps = [@"" stringByAppendingFormat:@"%d",[[dict valueForKey:@"RepGoal"] intValue]];
        if (![Utility isEmptyCheck:reps]) {
            if (![Utility isEmptyCheck:[dict objectForKey:@"RepsUnitText"]]) {
                if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps"] == NSOrderedSame) {
                    cell.reps.attributedText = [Utility getStringWithHeader:@"Reps : " headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:[NSString stringWithFormat:@"%@",reps] bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
                    cell.reps.hidden = false;
                    
                } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Reps Each Side"] == NSOrderedSame) {
                    cell.reps.attributedText = [Utility getStringWithHeader:@"Reps each side" headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:[NSString stringWithFormat:@"%@",reps] bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
                    cell.reps.hidden = false;
                    
                } else if ([[dict objectForKey:@"RepsUnitText"] caseInsensitiveCompare:@"Seconds Each Side"] == NSOrderedSame) {
                    cell.reps.attributedText = [Utility getStringWithHeader:@"Secs each side : " headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:[NSString stringWithFormat:@"%@",reps] bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
                    cell.reps.hidden = false;
                    //ah 1.2
                } else {
                    cell.reps.attributedText = [Utility getStringWithHeader:@"Secs : " headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:[NSString stringWithFormat:@"%@",reps] bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
                    cell.reps.hidden = false;
                }
            }else{
                cell.reps.attributedText = [Utility getStringWithHeader:@"Secs : " headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:[NSString stringWithFormat:@"%@",reps] bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
                cell.reps.hidden = false;
            }

            
            
        }else{
            cell.reps.text = @"";
            cell.reps.hidden = true;
        }
        NSString *sets = [@"" stringByAppendingFormat:@"%d",[[dict valueForKey:@"SetCount"] intValue]];
        if (![Utility isEmptyCheck:sets]) {
            cell.sets.attributedText = [Utility getStringWithHeader:@"Sets : " headerFont:[UIFont fontWithName:@"Raleway-Medium" size:12] headerColor:[Utility colorWithHexString:@"616161"] bodyString:sets bodyFont:[UIFont fontWithName:@"Raleway-Light" size:12] BodyColor:[Utility colorWithHexString:@"616161"]];
            cell.sets.hidden = false;
        }else{
            cell.sets.text = @"";
            cell.sets.hidden = true;
        }

        [cell.expandCollapse addTarget:self
                                action:@selector(cellExpandCollapse:)
                      forControlEvents:UIControlEventTouchUpInside];
        if (selectedIndex == indexPath.row && ![[dict objectForKey:@"LabelOnly"] boolValue]) {
            // cell.stackView.arrangedSubviews.lastObject.hidden = NO;
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
            NSArray *equipments = [dict objectForKey:@"Equipments"];
            if (![Utility isEmptyCheck:equipments] && equipments.count > 0) {
                cell.equipmentRequired.text = [@"\u2022  " stringByAppendingString:[equipments componentsJoinedByString:@"\n\u2022  "]];
                cell.equipmentRequiredStackView.hidden = false;
                
            }else{
                cell.equipmentRequiredStackView.hidden = true;
            }
            for (UIView *view in cell.equipmentBasedAlternativesButtonStackView.arrangedSubviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [cell.equipmentBasedAlternativesButtonStackView removeArrangedSubview:view] ;
                    [view removeFromSuperview];
                }
            }
            NSArray *substituteEquipments = [dict objectForKey:@"SubstituteExercises"];
            if (substituteEquipments.count > 0) {
                for (int i=0; i<substituteEquipments.count; i++) {
                    NSDictionary *substituteExercisesDict = [substituteEquipments objectAtIndex:i];
                    if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]]) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (![Utility isEmptyCheck:[substituteExercisesDict objectForKey:@"SubstituteExerciseId"]]) {
                            [button addTarget:self
                                       action:@selector(substituteExercisesButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
                            button.tag =[[substituteExercisesDict objectForKey:@"SubstituteExerciseId"] integerValue];
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        }else{
                            
                            [button setTitle:[@"  \u2022  " stringByAppendingString:[substituteExercisesDict objectForKey:@"SubstituteExerciseName"]] forState:UIControlStateNormal];
                            
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                        [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];
                        
                    }
                }
                cell.equipmentBasedAlternativesStackView.hidden = false;
                
            }else{
                cell.equipmentBasedAlternativesStackView.hidden = true;
                /*UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                 [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                 [button setTitle:@"N/A" forState:UIControlStateNormal];
                 
                 button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                 
                 button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                 [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                 [cell.equipmentBasedAlternativesButtonStackView addArrangedSubview:button];*/
            }
            
            for (UIView *view in cell.bodyWeightAlertnativesButtonStackView.arrangedSubviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [cell.bodyWeightAlertnativesButtonStackView removeArrangedSubview:view] ;
                    [view removeFromSuperview];
                }
            }
            NSArray *AltBodyWeightExercises = [dict objectForKey:@"AltBodyWeightExercises"];
            if (![Utility isEmptyCheck:AltBodyWeightExercises] && AltBodyWeightExercises.count > 0) {
                for (int i=0; i<AltBodyWeightExercises.count; i++) {
                    NSDictionary *altBodyWeightExercisesDict = [AltBodyWeightExercises objectAtIndex:i];
                    if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]]) {
                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                        if (![Utility isEmptyCheck:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"]]) {
                            [button addTarget:self
                                       action:@selector(substituteExercisesButtonPressed:)
                             forControlEvents:UIControlEventTouchUpInside];
                            NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid),NSForegroundColorAttributeName:[UIColor blueColor]}];
                            [button setAttributedTitle:titleString forState:UIControlStateNormal];
                            button.tag =[[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseId"] integerValue];
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        }else{
                            
                            [button setTitle:[@"  \u2022  " stringByAppendingString:[altBodyWeightExercisesDict objectForKey:@"BodyWeightAltExerciseName"]] forState:UIControlStateNormal];
                            
                            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                            
                            button.titleLabel.font =[UIFont fontWithName:@"Roboto-Light" size:15];
                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                        [cell.bodyWeightAlertnativesButtonStackView addArrangedSubview:button];
                        
                    }
                }
                cell.bodyWeightAlertnativesStackView.hidden = false;
            }else{
                cell.bodyWeightAlertnativesStackView.hidden = true;
            }
            NSArray *imageArray =![Utility isEmptyCheck:[dict objectForKey:@"PhotoList"]] ? [dict objectForKey:@"PhotoList"]:[[NSArray alloc]init];
            

            [player pause];
            player = nil;
            if (cell.playerController.player) {
                [cell.playerController.player pause];
                [cell.playerController removeFromParentViewController];
            }
            NSString *videoId = [dict objectForKey:@"PublicUrl"];
            if ((![Utility isEmptyCheck:imageArray] && imageArray.count > 0 && ![Utility isEmptyCheck:[imageArray objectAtIndex:0]]) ||(![Utility isEmptyCheck:videoId])) {
                if (imageArray.count > 0) {
                    NSString *imageString = [imageArray objectAtIndex:0];
                    [cell.exImage sd_setImageWithURL:[NSURL URLWithString:imageString]
                                    placeholderImage:[UIImage imageNamed:@"EXERCISE-picture-coming.jpg"] options:SDWebImageScaleDownLargeImages];
                }
                 if (![Utility isEmptyCheck:videoId]) {
                    cell.playerContainer.hidden =false;
                    cell.playerView.hidden =false;

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
                    cell.playerView.hidden =true;
                }
                if ([Utility isEmptyCheck:imageArray] || imageArray.count == 0 || [Utility isEmptyCheck:[imageArray objectAtIndex:0]]) {
                    cell.exImage.hidden = true;
                    cell.previousButton.hidden = true;
                    cell.playerView.hidden = false;
                    cell.nextButton.hidden = true;
                }else if([Utility isEmptyCheck:videoId]){
                    cell.exImage.hidden = false;
                    cell.previousButton.hidden = true;
                    cell.playerView.hidden = true;
                    cell.nextButton.hidden = true;

                }else{
                    cell.exImage.hidden = true;
                    cell.previousButton.hidden = NO;
                    cell.playerView.hidden = false;
                    cell.nextButton.hidden = NO;
                }
                
            }else{
                cell.playerContainer.hidden =true;
            }
           
            cell.nextButton.tag = indexPath.row;
            cell.nextButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section ];
            cell.previousButton.tag = indexPath.row;
            cell.previousButton.accessibilityHint = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.section ];
            
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
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[exerciseArray objectAtIndex:indexPath.row]);
    
}

#pragma -mark End


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
