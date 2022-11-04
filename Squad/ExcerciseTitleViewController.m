//
//  ExcerciseTitleViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 16/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "ExcerciseTitleViewController.h"
#import "ExcerciseTitleTableViewCell.h"
#import "ExcerciseDetailsViewController.h"
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "ExcerciseFinisherTableViewCell.h"
#import "ChallengeSectionHeader.h"
#import "ChallengeFooter.h"
#import "LeaderBoardDetailsViewController.h"
#import "ExcerciseTitleAllViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString *SectionHeaderViewIdentifier = @"ChallengeSectionHeader";
static NSString *SectionFooterViewIdentifier = @"ChallengeFooter";

@interface ExcerciseTitleViewController ()
{
    IBOutlet UITableView *excerciseTable;
    NSMutableArray *titleArray;
    NSArray * sortedArray;
    UIView *contentView;
    NSArray *finisherListArray;
    NSDictionary *finisherLevelCheckDict;
    NSMutableArray  *arrayForBool;
    IBOutlet UIButton *fullBodyButton;
    IBOutlet UIButton *coreButton;
    IBOutlet UIButton *lowerBodyButton;
    IBOutlet UIButton *upperBodyButton;
    NSArray *individualLeaderBoardArray;
    IBOutlet UILabel *typename;
    IBOutlet UIView *finisherCatagoryView;
    IBOutlet NSLayoutConstraint *finisherCatagoryHeaight;
}
@end

@implementation ExcerciseTitleViewController
@synthesize buttontag,mainFinishSquadWowButtonTag;

#pragma mark - IBAction

-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)topLevelAllButtonPressed:(id)sender{
    if (sender == fullBodyButton ) {
        buttontag = @"0";
    }else  if (sender == coreButton) {
        buttontag = @"1";
    }else  if (sender == lowerBodyButton) {
        buttontag = @"2";
    }else  if (sender == upperBodyButton) {
        buttontag = @"";
    }

    [self webserviceCallForGetFinisherListByTypeId];
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    finisherListArray = [[NSArray alloc]init];
    arrayForBool=[[NSMutableArray alloc]init];
    individualLeaderBoardArray = [[NSArray alloc]init];
    excerciseTable.estimatedSectionHeaderHeight = 50;
    excerciseTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    excerciseTable.estimatedRowHeight = 71;
    excerciseTable.rowHeight = UITableViewAutomaticDimension;

    if ([mainFinishSquadWowButtonTag isEqualToString:@"squad"]) {
        typename.text = @"ELITE";
        finisherCatagoryView.hidden = true;
        finisherCatagoryHeaight.constant = 0;
    }
    else if ([mainFinishSquadWowButtonTag isEqualToString:@"wow"]){
        typename.text = @"WOW";
        finisherCatagoryView.hidden = true;
        finisherCatagoryHeaight.constant = 0;
    }else{
        typename.text = @"FINISHER";
        finisherCatagoryView.hidden = false;
        finisherCatagoryHeaight.constant = 50;
    }
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ChallengeSectionHeader" bundle:nil];
    [excerciseTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    UINib *sectionFooterNib = [UINib nibWithNibName:@"ChallengeFooter" bundle:nil];
    [excerciseTable registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:SectionFooterViewIdentifier];}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self webserviceCallForGetFinisherListByTypeId];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

#pragma mark - Private Function

-(void)webServiceCallForFinisherLevelCheck{ //add_su_1_com
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *loginSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FinisherLevelCheck" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     
                                                                     finisherLevelCheckDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherLevelCheckDict]) {
                                                                         [excerciseTable reloadData];
                                                                     }
                                                                     else{
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)webserviceCallForGetFinisherListByTypeId{ //add_su_1_com
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *loginSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        
        NSError *error;
        int finisherTypeId;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        
        if ([mainFinishSquadWowButtonTag isEqualToString:@"squad"]) {
            [mainDict setObject:@"Squad Elite" forKey:@"LeaderboardType"];
            finisherTypeId = 0;
        }
        else if ([mainFinishSquadWowButtonTag isEqualToString:@"wow"]){
            [mainDict setObject:@"Squad WOW" forKey:@"LeaderboardType"];
            finisherTypeId = 0;
            
        }else{
            [mainDict setObject:@"FINISHER" forKey:@"LeaderboardType"];
            if ([buttontag isEqualToString:@"0"]) {//Full body
                finisherTypeId = 3;
                fullBodyButton.selected = true;
                coreButton.selected = false;
                lowerBodyButton.selected = false;
                upperBodyButton.selected = false;
            } else if ([buttontag isEqualToString:@"1"]){//BOOTY AND LEGS
                finisherTypeId = 2;
                coreButton.selected = true;
                fullBodyButton.selected =false;
                lowerBodyButton.selected = false;
                upperBodyButton.selected = false;
            }else if ([buttontag isEqualToString:@"2"]){//ABS
                finisherTypeId = 1;
                lowerBodyButton.selected = true;
                fullBodyButton.selected = false;
                coreButton.selected = false;
                upperBodyButton.selected = false;
            }else {//UPPER BODY
                finisherTypeId = 4;
                upperBodyButton.selected = true;
                lowerBodyButton.selected = false;
                coreButton.selected = false;
                fullBodyButton.selected = false;
            }
        }
        
        [mainDict setObject:[NSNumber numberWithInteger:finisherTypeId] forKey:@"FinisherTypeId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFinisherListByTypeId" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSArray *responseArray= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseArray] && responseArray.count>0) {
                                                                         finisherListArray =[responseArray objectAtIndex:0];
                                                                         if (![Utility isEmptyCheck:arrayForBool] && arrayForBool.count>0) {
                                                                             [arrayForBool removeAllObjects];
                                                                         }
                                                                         for (int i=0; i<[finisherListArray count]; i++) {
                                                                             [arrayForBool addObject:[NSNumber numberWithBool:NO]];
                                                                         }
                                                                         [self webServiceCallForFinisherLevelCheck];
                                                                         
                                                                     }
                                                                     else{
                                                                         //                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)individualLeaderBoardWebServiceCall:(NSDictionary *)dict with:(NSInteger)index{
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
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"FinisherID"] forKey:@"FinisherID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"IndividualLeaderBoard" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *individualLeaderDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:individualLeaderDict]) {
                                                                         
                                                                         individualLeaderBoardArray = [individualLeaderDict objectForKey:@"Userdetail"];
                                                                         if ([Utility isEmptyCheck:individualLeaderBoardArray]) {
                                                                             [Utility msg:@"No data found" title:@"Alert" controller:self haveToPop:NO];
                                                                         }
                                                                             if ([arrayForBool containsObject:[NSNumber numberWithBool:YES]]) {
                                                                                 NSInteger indexBool = [arrayForBool indexOfObject:[NSNumber numberWithBool:YES]];
                                                                                 if (indexBool != index) {
                                                                                     [arrayForBool replaceObjectAtIndex:indexBool withObject:[NSNumber numberWithBool:NO]];
                                                                                 }
                                                                             }
                                                                             BOOL isExpandable = [[arrayForBool objectAtIndex:index]boolValue];
                                                                             
                                                                             [arrayForBool replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!isExpandable]];
//                                                                             [excerciseTable reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
                                                                             [excerciseTable reloadData];

                                                                     }
                                                                     else{
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)sectionClicked:(UIButton*)sender{
    NSDictionary *finisherStageSpecificDict =[finisherListArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:finisherLevelCheckDict]) {
        ExcerciseDetailsViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseDetails"];
        controller.excerciseDetailsDict = finisherStageSpecificDict;
        controller.mainFinishSquadWowButtonTag = mainFinishSquadWowButtonTag;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)leaderBoardButton:(UIButton*)sender{
    
    NSDictionary *dict = [[finisherListArray objectAtIndex:sender.tag]mutableCopy];
    
    [self individualLeaderBoardWebServiceCall:dict with:sender.tag];
}

-(void)seeMoreButtonPressed:(UIButton*)sender{
    ExcerciseTitleAllViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseTitleAllView"];
    NSDictionary *finisherStageSpecificDict =[finisherListArray objectAtIndex:sender.tag];
    controller.finisherName  = [@"" stringByAppendingFormat:@"%@",[finisherStageSpecificDict objectForKey:@"FinisherName"]];
    controller.arr = individualLeaderBoardArray;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End

#pragma mark - TableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return finisherListArray.count;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ChallengeSectionHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    NSDictionary *finisherStageSpecificDict =[[finisherListArray objectAtIndex:section]mutableCopy];
    headerView.exerciseNamelabel.text  = [@"" stringByAppendingFormat:@"%@",[finisherStageSpecificDict objectForKey:@"FinisherName"]];
    headerView.sectionButton.tag = section;
    [headerView.sectionButton addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    headerView.leaderBoardButton.tag = section;
    [headerView.leaderBoardButton addTarget:self action:@selector(leaderBoardButton:) forControlEvents:UIControlEventTouchUpInside];
    BOOL isExpandable = [[arrayForBool objectAtIndex:section]boolValue];
    if (isExpandable && individualLeaderBoardArray.count>0) {
        headerView.leaderBoardButton.selected = true;
    }else{
        headerView.leaderBoardButton.selected = false;
    }

    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    BOOL isExpandable = [[arrayForBool objectAtIndex:section]boolValue];
    if (isExpandable && individualLeaderBoardArray.count>0) {
        return 40;
    }else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     ChallengeFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionFooterViewIdentifier];
    footerView.seeMoreButton.tag = section;
    BOOL isExpandable = [[arrayForBool objectAtIndex:section]boolValue];
    if (isExpandable && individualLeaderBoardArray.count>0) {
        [footerView.seeMoreButton addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }else
        return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([[arrayForBool objectAtIndex:section] boolValue]) {
        if ([Utility isEmptyCheck:individualLeaderBoardArray]) {
            return 0;
        }else if(individualLeaderBoardArray.count>3){
            return 3;
        }else{
           return individualLeaderBoardArray.count;
        }
    }
    else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSString *CellIdentifier =@"ExcerciseFinisherTableViewCell";
        ExcerciseFinisherTableViewCell *finisherCell = (ExcerciseFinisherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (finisherCell == nil) {
            finisherCell = [[ExcerciseFinisherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    
        if (![Utility isEmptyCheck:[individualLeaderBoardArray objectAtIndex:indexPath.row]]) {
            NSDictionary *individualLeaderDict =[individualLeaderBoardArray objectAtIndex:indexPath.row];
            if (individualLeaderBoardArray.count>=3) {
                if (indexPath.row<2) {
                    finisherCell.cellTopView.hidden = false;
                    finisherCell.cellBottomView.hidden = true;
                }else {
                    finisherCell.cellTopView.hidden = false;
                    finisherCell.cellBottomView.hidden = false;
                }
            }else if(individualLeaderBoardArray.count == 2){
                if (indexPath.row<1) {
                    finisherCell.cellTopView.hidden = false;
                    finisherCell.cellBottomView.hidden = true;
                }else {
                    finisherCell.cellTopView.hidden = false;
                    finisherCell.cellBottomView.hidden = false;
                }
            }else{
                finisherCell.cellTopView.hidden = false;
                finisherCell.cellBottomView.hidden = false;
            }

            finisherCell.indexlabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row+1];
            finisherCell.exercisenameLabel.text = [@"" stringByAppendingFormat:@"%@ %@",[individualLeaderDict objectForKey:@"FirstName"],[individualLeaderDict objectForKey:@"LastName"]];
            //----ImageAdded
            if (![Utility isEmptyCheck:[individualLeaderDict objectForKey:@"Picturepath"]]) {
                finisherCell.profileImage.layer.cornerRadius=finisherCell.profileImage.frame.size.height/2;
                finisherCell.profileImage.layer.masksToBounds = YES;
                finisherCell.profileImage.clipsToBounds  = YES;
                NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEIMAGE_URL,[individualLeaderDict objectForKey:@"Picturepath"]];
                
                [finisherCell.profileImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                             [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                      placeholderImage:[UIImage imageNamed:@"profile_icon.png"] options:SDWebImageScaleDownLargeImages];
                
            }else{
                finisherCell.profileImage.image = [UIImage imageNamed:@"profile_icon.png"];
            }
            //---End
            
            if (![Utility isEmptyCheck:[individualLeaderDict objectForKey:@"Timetaken"]]) {
                NSArray* timeTakenArray = [[individualLeaderDict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
                NSString *unitKey=@"";
                int hour = [[timeTakenArray objectAtIndex: 0]intValue];//hour
                int min = [[timeTakenArray objectAtIndex:1]intValue];//min
                int sec = [[timeTakenArray objectAtIndex:2]intValue];//sec
                if (hour>0) {
                    unitKey = @"hrs";
                }else if (min>0){
                    unitKey = @"min";
                }else if (sec>0){
                    unitKey = @"sec";
                }
                if (hour == 0 && min == 0 && sec == 0) {
                    finisherCell.timeLabel.text =@"";
                }else{
                    finisherCell.timeLabel.text =[@"" stringByAppendingFormat:@"%@ %@",[individualLeaderDict objectForKey:@"Timetaken"],unitKey];
                }
            }else{
                finisherCell.timeLabel.text =@"";
            }
        }
    [finisherCell setNeedsLayout];
    [finisherCell setNeedsUpdateConstraints];
    return finisherCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - End
@end
