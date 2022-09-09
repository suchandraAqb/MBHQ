//
//  LeaderBoardViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "Utility.h"
#import "LeaderBoardDetailsViewController.h"
#import "DetailsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ExcerciseDetailsViewController.h"
#import "LeaderSectionView.h"
#import "LeaderShareViewController.h"
#import "Utility.h"
#import "ChallengeFooter.h"
#import "ExcerciseDetailsShareViewController.h"
static NSString *LeaderSectionHeaderViewIdentifier = @"LeaderSectionHeaderViewIdentifier";
static NSString *SectionFooterViewIdentifier = @"ChallengeFooter";

@interface LeaderBoardViewController ()
{
    IBOutlet UITableView *detailsTableView;
    UIView *contentView;
    NSMutableArray *leaderListArray;
    IBOutlet NSLayoutConstraint *detailsTableViewHeightConstraint;
    IBOutlet NSLayoutConstraint *shareViewheightConstraint;
    NSArray *allArray;
    IBOutlet UIView *noDataView;
    IBOutlet UIView *favShareView;
    IBOutlet UIImageView *finisherImageView;
    Utility *util;
    NSMutableArray *userDetailsArray;
    NSString *leaderBoardName;
    NSArray *finisherArray;;
    NSArray *shareArray;
    int pageNumber;
    IBOutlet UIButton *filterButton;
}
@end

@implementation LeaderBoardViewController

#pragma mark - IBAction
- (IBAction)leaderShareButtonPressed:(UIButton*)sender {
    if (![Utility isEmptyCheck:leaderListArray[sender.tag]]) {
        NSDictionary *leaderDict =leaderListArray[sender.tag];
        shareArray = [leaderDict objectForKey:@"Userdetail"];
        if (![Utility isEmptyCheck:shareArray]) {
            NSDictionary *shareDict = [shareArray objectAtIndex:[sender.accessibilityHint intValue]];
            [self webServiceCallForGetFinisherDetailForShare:leaderDict with:shareDict];
        }
    }
}
- (IBAction)finisherNameButtonPressed:(UIButton*)sender {
    NSLog(@"%ld",(long)sender.tag);
    
    LeaderBoardDetailsViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoardDetails"];
    NSDictionary *dict = [leaderListArray objectAtIndex:sender.tag];
    NSLog(@"LeaderDict-%@",dict);
    controller.leaderBoardDetailsDict = dict;
    if ([[dict objectForKey:@"LederboardType"]isEqualToString:@"Squad Battle"]) {
        controller.isbattle=true;
    }else{
        controller.isbattle=false;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)filterButtonPressed:(id)sender {
    NSArray *filterArray = [[NSArray alloc]initWithObjects:@"ALL",@"Finisher" ,@"Squad WOW",@"Squad Elite",nil];
    PopoverViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Popover"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    int index = [[defaults objectForKey:@"type"] intValue];
    controller.selectedIndex =index;
    controller.tableDataArray = filterArray;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)shareButtonPressed:(UIButton*)sender{
    
    LeaderShareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderShare"];
    controller.leaderShareDict =leaderListArray[sender.tag];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
    
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)detailsFavouriteButtonPressed:(UIButton*)sender {
    NSLog(@"%ld",(long)sender.tag);
    [self webServiceCallForToggleFavoriteList:sender.tag];
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)LeaderBoardButtonTapped:(id)sender{
    LeaderBoardViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoard"];
    [self.navigationController pushViewController:controller animated:NO];
}
#pragma mark - End

#pragma mark - Private function
-(void)webServiceCallForGetFinisherDetailForShare:(NSDictionary*)leaderDict with:(NSDictionary*)shareDict{
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
        [mainDict setObject:[leaderDict objectForKey:@"FinisherID"] forKey:@"FinisherId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFinisherDetail" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *finisherDetailsArray =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     finisherArray = [finisherDetailsArray objectAtIndex:0];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherArray]) {
                                                                         if ([[leaderDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Elite"]) {
                                                                             leaderBoardName =@"squad";
                                                                         }else if ([[leaderDict objectForKey:@"LederboardType"]isEqualToString:@"Squad WOW"]){
                                                                             leaderBoardName =@"wow";
                                                                         }else if ([[leaderDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Battle"]){
                                                                             leaderBoardName =@"battle";
                                                                         }else if ([[leaderDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Collective"]){
                                                                             leaderBoardName =@"collective";
                                                                         }
                                                                         else{
                                                                             leaderBoardName=@"";
                                                                         }
                                                                         
                                                                         ExcerciseDetailsShareViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseDetailsShare"];
                                                          
                                                                         controller.scoreDict =shareDict;
                                                                         controller.excerciseDetailsDict = [finisherArray objectAtIndex:0];
                                                                         controller.viewtag=@"LeaderBoard";
                                                                         controller.mainFinishSquadWowButtonTag =leaderBoardName;
                                                                         controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                         [self presentViewController:controller animated:YES completion:nil];
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
-(void)filterfinisherDetails:(NSString*)option{
    if ([option isEqualToString:@"0"]) {   //ALL
        leaderListArray = [allArray mutableCopy];
    }else if ([option isEqualToString:@"1"]){//Finisher
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@ OR FinisherTypeName == %@ OR FinisherTypeName == %@ OR FinisherTypeName == %@",@"UPPER BODY" ,@"ABS",@"BOOTY AND LEGS",@"FULL BODY"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }else if ([option isEqualToString:@"2"]){//Squad WOW
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@ OR FinisherTypeName == %@ OR FinisherTypeName == %@",@"Squad WOW" ,@"Squad WOW Exercise",@"Squad WOW Session"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }else if ([option isEqualToString:@"3"]){//Squad Elite
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@",@"Squad Elite"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }else if ([option isEqualToString:@"4"]){//Squad Battle
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@",@"Squad Battle"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }else if ([option isEqualToString:@"5"]){//Squad Collective
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@",@"Squad Collective"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }else if ([option isEqualToString:@"6"]){//Body Composition
        [leaderListArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FinisherTypeName == %@ OR FinisherTypeName == %@ OR FinisherTypeName == %@ OR FinisherTypeName == %@",@"Body Composition",@"Weight Loss",@"Muscle Gain",@"Body Fat"];
        NSArray *tempArray = [allArray filteredArrayUsingPredicate:predicate];
        leaderListArray = [tempArray mutableCopy];
    }
    [detailsTableView reloadData];
}


-(void)webServiceCallForToggleFavoriteList:(NSInteger)tag{
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
        NSDictionary *leaderBoardDetailsDict = [leaderListArray objectAtIndex:tag];
        [mainDict setObject:[leaderBoardDetailsDict objectForKey:@"FinisherID"] forKey:@"FinisherId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ToggleFavoriteList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     NSLog(@"responseString--%@",responseString);
                                                                     if (![Utility isEmptyCheck:[dict objectForKey:@"ToggleFlag"]] ) {
                                                                         pageNumber = 10;
                                                                         [self webServiceCallGetAllLeaderBoard:[defaults objectForKey:@"type"]];
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

-(void)webServiceCallGetAllLeaderBoard:(NSString*)option{
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"AbbbcSessionId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"AbbbcUserId"];
        [mainDict setObject:[NSNumber numberWithInt:pageNumber] forKey:@"Take"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetAllLeaderBoard" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                                     NSLog(@"LeaderListArray-%@",leaderListArray);
                                                                     if (![Utility isEmptyCheck:responseString]) {
                                                                         leaderListArray= [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]mutableCopy];
                                                                         allArray = [leaderListArray mutableCopy];
                                                                         [self filterfinisherDetails:option];
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
-(void)seeMoreButtonPressed:(UIButton*)sender{
    LeaderBoardDetailsViewController*controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LeaderBoardDetails"];
    NSDictionary *dict = [leaderListArray objectAtIndex:sender.tag];
    NSLog(@"LeaderDict-%@",dict);
    controller.leaderBoardDetailsDict = dict;
    if ([[dict objectForKey:@"LederboardType"]isEqualToString:@"Squad Battle"]) {
        controller.isbattle=true;
    }else{
        controller.isbattle=false;
    }
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    allArray =[[ NSMutableArray alloc]init];
    detailsTableView.estimatedRowHeight = 80;
    detailsTableView.rowHeight = UITableViewAutomaticDimension;

    leaderListArray = [[NSMutableArray alloc]init];
    util = [[Utility alloc]init];
    userDetailsArray = [[NSMutableArray alloc]init];
    UINib *sectionFooterNib = [UINib nibWithNibName:@"ChallengeFooter" bundle:nil];
    [detailsTableView registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:SectionFooterViewIdentifier];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MasterMenuViewController class]]) {
        MasterMenuViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MasterMenuView"];
        controller.delegateMasterMenu=self;
        //        masterMenu=controller;
        self.slidingViewController.underLeftViewController  = controller;
    }
    filterButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    filterButton.layer.borderWidth =2;
    UINib *leaderSectionHeaderNib = [UINib nibWithNibName:@"LeaderSectionView" bundle:nil];
    [detailsTableView registerNib:leaderSectionHeaderNib forHeaderFooterViewReuseIdentifier:LeaderSectionHeaderViewIdentifier];
    pageNumber = 10;
    if (![Utility isEmptyCheck:[defaults objectForKey:@"type"]]) {
        NSLog(@"%@",[defaults objectForKey:@"type"]);
        [self webServiceCallGetAllLeaderBoard:[defaults objectForKey:@"type"]];
    }else{
        [self webServiceCallGetAllLeaderBoard:@"0"];
    }
}

//-(void) updateViewConstraints{
//    [super updateViewConstraints];
//    NSDictionary *leaderBoardDetailsDict = [leaderListArray objectAtIndex:0];
//    NSArray *userDetailArray = [leaderBoardDetailsDict objectForKey:@"Userdetail"];
//    if (![Utility isEmptyCheck:userDetailArray]) {
//        detailsTableViewHeightConstraint.constant = userDetailArray.count*60;
//        shareViewheightConstraint.constant = 50+userDetailArray.count*60;
//    }
//}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return leaderListArray.count;    //count of section
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSDictionary *dict = [leaderListArray objectAtIndex:section];
    if (![Utility isEmptyCheck:[dict objectForKey:@"Userdetail"]]) {
        return 40;
    }else{
        return 0;
    }
    
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LeaderSectionView *leaderSectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:LeaderSectionHeaderViewIdentifier];
    [[leaderSectionHeaderView detailsFinisherName] addTarget:self action:@selector(finisherNameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[leaderSectionHeaderView detailsFavouriteButton] addTarget:self action:@selector(detailsFavouriteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [[leaderSectionHeaderView shareButton] addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (![Utility isEmptyCheck:leaderListArray]) {
        NSDictionary *leaderBoardDetailsDict = [leaderListArray objectAtIndex:section];
        leaderSectionHeaderView.detailsFinisherName.tag = section;
       
        leaderSectionHeaderView.detailsFavouriteButton.tag = section;
        
        leaderSectionHeaderView.shareButton.tag = section;
        
        
        NSString *finisherTypeNameString = [@"" stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"LederboardType"]];
        if ([finisherTypeNameString isEqualToString:@"FINISHER"])  {
            leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBfinisher_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad WOW"])  {
           leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBwow_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad Elite"])  {
            leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBsquad_iconleader.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Squad Battle"])  {
            leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBsquad_battle.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Squad Collective"])  {
            leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBsquad_collective.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Body Composition"])  {
            leaderSectionHeaderView.finisherImageView.image = [UIImage imageNamed:@"LBsquad_composition.png"];
        }
        
        
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"FinisherTypeName"]]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:13] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"FinisherName"]]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:17] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString2 length])];
        
        [attributedString appendAttributedString:attributedString2];
        leaderSectionHeaderView.detailsFinisherLabel.attributedText = attributedString;
//        [leaderSectionHeaderView.detailsFinisherName setAttributedTitle:attributedString forState:UIControlStateNormal];
//        leaderSectionHeaderView.detailsFinisherName.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
//
        
        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"IsFavourite"]]) {
            NSString *favouriteString = [@"" stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"IsFavourite"]];
            if ([favouriteString isEqualToString:@"1"]) {
                leaderSectionHeaderView.detailsFavouriteButton.selected = true;
            }
            else{
                leaderSectionHeaderView.detailsFavouriteButton.selected = false;
            }
        }
    }
    return  leaderSectionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     ChallengeFooter *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionFooterViewIdentifier];
    footerView.tag = section;
    NSDictionary *dict = [leaderListArray objectAtIndex:section];
    if (![Utility isEmptyCheck:[dict objectForKey:@"Userdetail"]]) {
        footerView.seeMoreButton.tag = section;
        [footerView.seeMoreButton addTarget:self action:@selector(seeMoreButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        return footerView;
    }else{
        return nil;
    }
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (![Utility isEmptyCheck:leaderListArray] && leaderListArray.count>0) {
            NSDictionary *leaderBoardDetailsDict = [leaderListArray objectAtIndex:section];
            NSArray *userDetailArray = [leaderBoardDetailsDict objectForKey:@"Userdetail"];
            if ([Utility isEmptyCheck:userDetailArray]) {
                return 0;
            }else if(userDetailArray.count>3){
                return 3;
            }else{
                return userDetailArray.count;
            }
        }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *CellIdentifier = @"DetailsTableViewCell";
        DetailsTableViewCell *cell;
        cell=[detailsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        NSDictionary *leaderBoardDetailsDict = [leaderListArray objectAtIndex:indexPath.section];
    
        if (![Utility isEmptyCheck:leaderBoardDetailsDict]) {
            
            NSArray *userDetailArray = [leaderBoardDetailsDict objectForKey:@"Userdetail"];
            
            if (![Utility isEmptyCheck:userDetailArray]) {
                NSDictionary *userDetaildict = [userDetailArray objectAtIndex:indexPath.row];
                NSString *detailString =@"";
                if (userDetailArray.count>=3) {
                    if (indexPath.row<2) {
                        cell.cellTopView.hidden = false;
                        cell.cellBottomView.hidden = true;
                    }else {
                        cell.cellTopView.hidden = false;
                        cell.cellBottomView.hidden = false;
                    }
                }else if(userDetailArray.count == 2){
                    if (indexPath.row<1) {
                        cell.cellTopView.hidden = false;
                        cell.cellBottomView.hidden = true;
                    }else {
                        cell.cellTopView.hidden = false;
                        cell.cellBottomView.hidden = false;
                    }
                }else{
                    cell.cellTopView.hidden = false;
                    cell.cellBottomView.hidden = false;
                }
               

            if (![Utility isEmptyCheck:userDetaildict]) {
                    
                cell.indexLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row+1];
                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"UserID"]]) {
                    NSString *loginUserIdString = [@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"UserID"]];
                    NSString *userIdString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"UserID"]];
                    cell.leaderShareButton.tag=indexPath.section;
                    cell.leaderShareButton.accessibilityHint=[NSString stringWithFormat:@"%ld",(long)indexPath.row];

                    if ([loginUserIdString isEqualToString:userIdString]) {
                        cell.selectedImage.image = [UIImage imageNamed:@""];
                        cell.leaderShareButton.hidden=false;
                    }
                    else{
                        cell.leaderShareButton.hidden=true;
                        cell.selectedImage.image = [UIImage imageNamed:@""];
                    }
                }else{
                        cell.leaderShareButton.hidden=true;
                }
                //NSString *lastNameFirstCharacter=[[userDetaildict objectForKey:@"LastName"] substringToIndex:1];//LastName last chatacter fetch
                
                NSString *lastNameFirstCharacter=[userDetaildict objectForKey:@"LastName"];//ah
                
                NSString *userName = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"FirstName"],lastNameFirstCharacter];
                cell.detailsUserNameString.text =userName;
                
                //ImageAdded
                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Picturepath"]]) {
                    cell.profileImage.layer.cornerRadius=cell.profileImage.frame.size.height/2;
                    cell.profileImage.layer.masksToBounds = YES;
                    cell.profileImage.clipsToBounds  = YES;
                    NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEIMAGE_URL,[userDetaildict objectForKey:@"Picturepath"]];
                    
                    [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                     [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                              placeholderImage:[UIImage imageNamed:@"profile_icon.png"] options:SDWebImageScaleDownLargeImages];
                    
                }else{
                    cell.profileImage.image = [UIImage imageNamed:@"profile_icon.png"];
                }
                //---End
                
                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"City"]] && ![Utility isEmptyCheck:[userDetaildict objectForKey:@"Suburbs"]]) {
                    
                    cell.citySubLabelHeightConstant.constant=18;
                    cell.citySubLabel.text = [NSString stringWithFormat:@"(%@/%@)",[userDetaildict objectForKey:@"City"],[userDetaildict objectForKey:@"Suburbs"]];
                    
                }else if((![Utility isEmptyCheck:[userDetaildict objectForKey:@"City"]] && [Utility isEmptyCheck:[userDetaildict objectForKey:@"Suburbs"]])){
                    
                    cell.citySubLabelHeightConstant.constant=18;
                    cell.citySubLabel.text = [NSString stringWithFormat:@"(%@)",[userDetaildict objectForKey:@"City"]];
                    
                }else if ([Utility isEmptyCheck:[userDetaildict objectForKey:@"City"]] && ![Utility isEmptyCheck:[userDetaildict objectForKey:@"Suburbs"]]){
                    
                    cell.citySubLabelHeightConstant.constant=18;
                    cell.citySubLabel.text = [NSString stringWithFormat:@"(%@)",[userDetaildict objectForKey:@"Suburbs"]];
                    
                }
                else if ([Utility isEmptyCheck:[userDetaildict objectForKey:@"City"]] && [Utility isEmptyCheck:[userDetaildict objectForKey:@"Suburbs"]]){
                    cell.citySubLabelHeightConstant.constant=0;
                    cell.citySubLabel.text =@"N/A";
                }

                
                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Picturepath"]]) {
                    cell.detailsImageView.layer.cornerRadius = cell.detailsImageView.frame.size.width/2;
                    cell.detailsImageView.clipsToBounds = YES;
                    NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEIMAGE_URL,[userDetaildict objectForKey:@"Picturepath"]];
                    [cell.detailsImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                                    [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                             placeholderImage:[UIImage imageNamed:@"profile_icon.png"]
                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                    }];
                }else{
                    cell.detailsImageView.image = [UIImage imageNamed:@"profile_icon.png"];
                }
                
                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Status"]]) {
                    NSString *statusString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"Status"]];
                    if ([statusString isEqualToString:@"0"]) {
                        cell.detailsStatusImageView.image = [UIImage imageNamed:@""];
                    }else{
                        cell.detailsStatusImageView.image = [UIImage imageNamed:@"lb_complete.png"];
                    }
                }
                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"Priority"]]) {
                    int prirityValue = [[leaderBoardDetailsDict objectForKey:@"Priority"]intValue];
                        if (prirityValue>0) {
                            int lastOne = prirityValue % 10; //is 3
                            int firstOne= (prirityValue - lastOne)/10; //is 53-3=50 /10 =5
                            NSLog(@"Last-%d",lastOne);
                            NSLog(@"First-%d",firstOne);
                            
                            if (firstOne >0) {
                                if (firstOne == 1) {
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Score"]]) {
                                            detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                            detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"Score"]];
                                            NSLog(@"%@",detailString);
                                        }else{
                                            NSString *scoreString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"Score"]];
                                            if ([scoreString isEqualToString:@"(null)"] || ([scoreString isEqualToString:@"<null>"])) {
                                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"UnitName"]]) {
                                                    NSString *scoreValue =@"0";
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                                    detailString = [detailString stringByAppendingFormat:@" : %@",scoreValue];
                                                }
                                            }
                                        }
                                    }

                                }else if (firstOne == 2){
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                        
                                        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Timetaken"]]) {
                                            NSArray* timeTakenArray = [[userDetaildict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
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
                                                detailString = @"";
                                            }else{
                                                detailString = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"Timetaken"],unitKey];
                                            }
                                            }
                                        }

                                }else if (firstOne ==3){
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
                                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"RespUnitname"]]) {
                                            
                                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }
                                            }
                                            else{
                                                if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }else{
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }
                                            }
                                            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"RepsCount"]]) {
                                                detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"RepsCount"]];
                                            }else{
                                                NSString *repsString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"RepsCount"]];
                                                if ([repsString isEqualToString:@"(null)"] || ([repsString isEqualToString:@"<null>"])) {
                                                    NSString *repsValue = @"0";
                                                    detailString = [detailString stringByAppendingFormat:@" : %@",repsValue];
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if (lastOne >0) {
                                if (detailString.length>0) {
                                    detailString =[detailString stringByAppendingString:@"\n"];
                                }
                                if (lastOne == 1) {
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Score"]]) {
                                            detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                            detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"Score"]];
                                            NSLog(@"%@",detailString);
                                        }else{
                                            NSString *scoreString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"Score"]];
                                            if ([scoreString isEqualToString:@"(null)"] || ([scoreString isEqualToString:@"<null>"])) {
                                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"UnitName"]]) {
                                                    NSString *scoreValue =@"0";
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                                    detailString = [detailString stringByAppendingFormat:@" : %@",scoreValue];
                                                }
                                            }
                                        }
                                    }
                                    
                                }else if (lastOne == 2){
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                        
                                        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Timetaken"]]) {
                                            NSArray* timeTakenArray = [[userDetaildict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
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
                                                detailString = @"";
                                            }else{
                                                detailString = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"Timetaken"],unitKey];
                                            }
                                        }
                                    }
                                    
                                }else if (lastOne == 3){
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
                                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"RespUnitname"]]) {
                                            
                                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }
                                            }
                                            else{
                                                if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }else{
                                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                                }
                                            }
                                            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"RepsCount"]]) {
                                                detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"RepsCount"]];
                                            }else{
                                                NSString *repsString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"RepsCount"]];
                                                if ([repsString isEqualToString:@"(null)"] || ([repsString isEqualToString:@"<null>"])) {
                                                    NSString *repsValue = @"0";
                                                    detailString = [detailString stringByAppendingFormat:@" : %@",repsValue];
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                        }else{
                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Score"]]) {
                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                    detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"Score"]];
                                    NSLog(@"%@",detailString);
                                }else{
                                    NSString *scoreString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"Score"]];
                                    if ([scoreString isEqualToString:@"(null)"] || ([scoreString isEqualToString:@"<null>"])) {
                                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"UnitName"]]) {
                                            NSString *scoreValue =@"0";
                                            detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                            detailString = [detailString stringByAppendingFormat:@" : %@",scoreValue];
                                        }
                                    }
                                }
                            }
                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                
                                    if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Timetaken"]]) {
                                        NSArray* timeTakenArray = [[userDetaildict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
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
                                            detailString = @"";
                                        }else{
                                            detailString = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"Timetaken"],unitKey];
                                        }
                                }
                            }
                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"RespUnitname"]]) {
                                    
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                            detailString = [detailString stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                        }
                                    }
                                    else{
                                        if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                            detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                        }else{
                                            detailString = [detailString stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                        }
                                    }
                                    if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"RepsCount"]]) {
                                        detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"RepsCount"]];
                                    }else{
                                        NSString *repsString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"RepsCount"]];
                                        if ([repsString isEqualToString:@"(null)"] || ([repsString isEqualToString:@"<null>"])) {
                                            NSString *repsValue = @"0";
                                            detailString = [detailString stringByAppendingFormat:@" : %@",repsValue];
                                        }
                                    }
                                }
                            }
                        }
                }else{
                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Score"]]) {
                                detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"Score"]];
                                NSLog(@"%@",detailString);
                            }else{
                                NSString *scoreString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"Score"]];
                                if ([scoreString isEqualToString:@"(null)"] || ([scoreString isEqualToString:@"<null>"])) {
                                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"UnitName"]]) {
                                        NSString *scoreValue =@"0";
                                        detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"UnitName"]];
                                        detailString = [detailString stringByAppendingFormat:@" : %@",scoreValue];
                                    }
                                }
                            }
                        }
                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                        
                            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Timetaken"]]) {
                                NSArray* timeTakenArray = [[userDetaildict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
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
                                    detailString = @"";
                                }else{
                                    detailString = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"Timetaken"],unitKey];
                                }
                        }
                    }
                    if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
                        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"RespUnitname"]]) {
                            
                            if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]]) {
                                if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                    detailString = [detailString stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                }
                            }
                            else{
                                if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]]) {
                                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                }else{
                                    detailString = [detailString stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"RespUnitname"]];
                                }
                            }
                            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"RepsCount"]]) {
                                detailString = [detailString stringByAppendingFormat:@" : %@",[userDetaildict objectForKey:@"RepsCount"]];
                            }else{
                                NSString *repsString=[NSString stringWithFormat:@"%@",[userDetaildict objectForKey:@"RepsCount"]];
                                if ([repsString isEqualToString:@"(null)"] || ([repsString isEqualToString:@"<null>"])) {
                                    NSString *repsValue = @"0";
                                    detailString = [detailString stringByAppendingFormat:@" : %@",repsValue];
                                }
                            }
                        }
                    }
                }
                NSLog(@"detailString--%@",detailString);
                cell.detailsCommonString.text = detailString;
                }
            }
            if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]] && [Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]] && [Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
                    cell.detailsHeightConstraint.constant = 0.0f;
                }
            
        }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"DetailsTableViewCell";
    DetailsTableViewCell *cell;
    cell=[detailsTableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.userInteractionEnabled = false;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(leaderListArray.count>0){
        if((indexPath.section == leaderListArray.count-1) && (pageNumber == allArray.count)){
            pageNumber=pageNumber+10;
            [self webServiceCallGetAllLeaderBoard:[defaults objectForKey:@"type"]];
        }
    }
}
#pragma mark - End


#pragma mark - PopoverViewDelegate
- (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option{
    NSLog(@"%@",option);
    [defaults setObject:option forKey:@"type"];
    [self filterfinisherDetails:option];
}
-(void)didCancelOption{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End
@end
