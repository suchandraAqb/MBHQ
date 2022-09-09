//
//  LeaderBoardDetailsViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/10/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "LeaderBoardDetailsViewController.h"
#import "LeaderBoardDetailsTableViewCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ExcerciseDetailsViewController.h"
#import "ExcerciseDetailsShareViewController.h"


@interface LeaderBoardDetailsViewController ()
{
    IBOutlet UIButton *shareButton;
    IBOutlet UIButton *favouriteButton;
    IBOutlet UITableView *leaderBoardDetailsTable;
    IBOutlet UIButton *finisherNameButton;
    IBOutlet UIView *shareView;
    IBOutlet UIView *favShareView;
    IBOutlet UIView *noDataView;
    IBOutlet UILabel *noDataLabel;
    
    IBOutlet UIImageView *finisherImageView;
    IBOutlet UILabel *finisherNameLabel;
    IBOutlet UIButton *filterButton;
    UIView *contentView;
    
    NSMutableArray *userDetailsArray;
    NSArray *finisherArray;
    NSString *leaderBoardName;
    BOOL islocationSuburb;
    NSDictionary *leaderBattleDict;
    
    
}
@end

@implementation LeaderBoardDetailsViewController
@synthesize leaderBoardDetailsDict,isbattle;

#pragma mark - IBAction

- (IBAction)filterButtonPressed:(id)sender {
    if (isbattle) {
        
        NSArray *filterArray = [[NSArray alloc]initWithObjects:@"People Leaderboard",@"Location Leaderboard",@"Suburb Leaderboard",nil];
        PopoverViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Popover"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        int index = [[defaults objectForKey:@"leadertype"] intValue];
        controller.selectedIndex =index;
        controller.tableDataArray = filterArray;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];

        
    }else{
        NSArray *filterArray = [[NSArray alloc]initWithObjects:@"Approved First",@"All",nil];
        PopoverViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Popover"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        int index = [[defaults objectForKey:@"type"] intValue];
        controller.selectedIndex =index;
        controller.tableDataArray = filterArray;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (IBAction)finisherNameButtonPressed:(id)sender {
    [self webServiceCallForGetFinisherDetail];
}

- (IBAction)leaderShareButtonPressed:(UIButton*)sender {
    NSLog(@"%@",userDetailsArray[sender.tag]);
    NSDictionary *dict =userDetailsArray[sender.tag];
    [self webServiceCallForGetFinisherDetailForShare:dict];
}

-(IBAction)shareButtonPressed:(id)sender{
    UIGraphicsBeginImageContext(shareView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shareView.layer renderInContext:context];
    
    //    [self.view.layer renderInContext:context];
    //UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   
}

- (IBAction)favouriteButtonPressed:(id)sender {
    [self webServiceCallForToggleFavoriteList];
}

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - End

#pragma mark - Private Function
-(void)filterfinisherDetails:(NSString*)option{ //add_su_1_com
    userDetailsArray =[[leaderBoardDetailsDict objectForKey:@"Userdetail"]mutableCopy];
    
    if (![Utility isEmptyCheck:userDetailsArray] && userDetailsArray.count>0) {
        NSArray *tempArray= [userDetailsArray mutableCopy];
        [userDetailsArray removeAllObjects];
        
        NSMutableArray *tempScoreArray;
        NSMutableArray *scoreStatusArray;
        
        if ([option isEqualToString:@"0"]) {//approved first
            [scoreStatusArray removeAllObjects];
            [tempScoreArray removeAllObjects];
            userDetailsArray=[tempArray mutableCopy];
            
            for (int i =0; i<userDetailsArray.count; i++) {
                NSDictionary *dict = [[userDetailsArray objectAtIndex:i]mutableCopy];
                NSString *statusString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"Status"]];
                if ([statusString isEqualToString:@"1"]) {
                    [scoreStatusArray addObject:dict];
                }else{
                    [tempScoreArray addObject:dict]; // status = 0
                }
            }
            userDetailsArray  = [scoreStatusArray mutableCopy];
            [userDetailsArray addObjectsFromArray:tempScoreArray];
            NSLog(@"userDetailsArray%@",userDetailsArray);
        }else{
            userDetailsArray  = [tempArray mutableCopy];
        }
        [leaderBoardDetailsTable reloadData];
    }
}
-(void)battleFilterDetails:(NSString*)option{
    if ([option isEqualToString:@"1"]) { //Location
        [self webServiceCallForGetBattleFilterDetails:@"1"];
        
    }else if ([option isEqualToString:@"2"]){ //Suburb
        [self webServiceCallForGetBattleFilterDetails:@"2"];
    }
}
-(void)webServiceCallForGetBattleFilterDetails:(NSString*)option{
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
        NSMutableURLRequest *request;
        
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[leaderBoardDetailsDict objectForKey:@"FinisherID"] forKey:@"FinisherId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        if ([option isEqualToString:@"1"]) {
            request = [Utility getRequest:jsonString api:@"SquadCityLeaderboard" append:@""forAction:@"POST"];
        }else if ([option isEqualToString:@"2"]){
            request = [Utility getRequest:jsonString api:@"SquadSubursLeaderboard" append:@""forAction:@"POST"];
        }
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                   NSDictionary *leaderBoard=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     leaderBattleDict=[leaderBoard objectForKey:@"LeaderBoard"];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:leaderBattleDict] ) {
                                                                         islocationSuburb =true;
                                                                         [leaderBoardDetailsTable reloadData];
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
-(void)webServiceCallForGetFinisherDetailForShare:(NSDictionary*)shareDict{
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
        [mainDict setObject:[leaderBoardDetailsDict objectForKey:@"FinisherID"] forKey:@"FinisherId"];
        
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
                                                                     //                                                                     NSLog(@"finisherDetailsArray--%@",finisherArray);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherArray] ) {
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
-(void)webServiceCallForGetFinisherDetail{
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
        [mainDict setObject:[leaderBoardDetailsDict objectForKey:@"FinisherID"] forKey:@"FinisherId"];
        
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
                                                                     //                                                                     NSLog(@"finisherDetailsArray--%@",finisherArray);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherArray] ) {
                                                                         ExcerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExcerciseDetails"];
                                                                         controller.excerciseDetailsDict = [finisherArray objectAtIndex:0];
                                                                         NSLog(@"%@",leaderBoardName);
                                                                         controller.mainFinishSquadWowButtonTag =leaderBoardName;
                                                                         [self.navigationController pushViewController:controller animated:YES];
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

-(void)webServiceCallForToggleFavoriteList{
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
        NSLog(@"%@",[leaderBoardDetailsDict objectForKey:@"FinisherID"]);
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
                                                                         NSString *toggleString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ToggleFlag"]];
                                                                         if ([toggleString isEqualToString:@"1"]) {
                                                                             favouriteButton.selected = true;
                                                                         }
                                                                         else{
                                                                             favouriteButton.selected =false;
                                                                         }
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
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    leaderBoardDetailsTable.rowHeight = UITableViewAutomaticDimension;
    leaderBoardDetailsTable.estimatedRowHeight = 70;
    userDetailsArray = [[NSMutableArray alloc]init];
    NSLog(@"%@",leaderBoardDetailsDict);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    filterButton.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    filterButton.layer.borderWidth =2;
    
    if (![Utility isEmptyCheck:leaderBoardDetailsDict]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"FinisherTypeName"]]];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:13] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, [attributedString length])];
        
        NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc]initWithString:[@""stringByAppendingFormat:@"\n%@",[leaderBoardDetailsDict objectForKey:@"FinisherName"]]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:17] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"E425A0"] range:NSMakeRange(0, [attributedString2 length])];
        
        [attributedString appendAttributedString:attributedString2];
        
        [finisherNameButton setTitle:@"" forState:UIControlStateNormal];
        finisherNameLabel.attributedText = attributedString;
        
        
        NSString *finisherTypeNameString = [@"" stringByAppendingFormat:@"%@",[leaderBoardDetailsDict objectForKey:@"LederboardType"]];
        if ([finisherTypeNameString isEqualToString:@"FINISHER"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBfinisher_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad WOW"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBwow_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad Elite"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBsquad_iconleader.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Squad Battle"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBsquad_battle.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Squad Collective"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBsquad_collective.png"];
        }else if ([finisherTypeNameString isEqualToString:@"Body Composition"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBsquad_composition.png"];
        }
        
        if (![Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"IsFavourite"]]) {
            if ([[leaderBoardDetailsDict objectForKey:@"IsFavourite"]boolValue]) {
                favouriteButton.selected = true;
            }else{
                favouriteButton.selected = false;
            }
        }
        NSLog(@"leaderBoardDetailsDict-%@",leaderBoardDetailsDict);
        if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Elite"]) {
            leaderBoardName =@"squad";
        }else if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"Squad WOW"]){
            leaderBoardName =@"wow";
        }else if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"FINISHER"]){
            leaderBoardName =@"";
        }else if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Collective"]){
            leaderBoardName =@"collective";
        }else if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"Body Composition"]){
            leaderBoardName =@"composition";
        }else if ([[leaderBoardDetailsDict objectForKey:@"LederboardType"]isEqualToString:@"Squad Battle"]){
            leaderBoardName =@"battle";
        }
        
        if (![Utility isEmptyCheck:[defaults objectForKey:@"leadertype"]]) {
            if (isbattle) {
                if ([[defaults objectForKey:@"leadertype"]isEqualToString:@"0"]) {
                    [self filterfinisherDetails:@"0"];
                }else if([[defaults objectForKey:@"leadertype"]isEqualToString:@"1"]){
                    [self battleFilterDetails:@"1"];
                }else{
                    [self battleFilterDetails:@"2"];
                }
            }
        else{
            [self filterfinisherDetails:@"0"];
            }
        }
    }
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *userDetailArray =[[NSArray alloc]init];
    if (islocationSuburb) {
        userDetailArray = [leaderBattleDict objectForKey:@"CityDataDetail"];
    }else{
        userDetailArray = [leaderBoardDetailsDict objectForKey:@"Userdetail"];
    }
    if (userDetailArray.count>0) {
        leaderBoardDetailsTable.hidden = false;
        favouriteButton.hidden = false;
        shareButton.hidden =false;
        [finisherNameButton setEnabled:YES];
        noDataView.hidden = true;
        favShareView.hidden =false;
    }
    else{
        favouriteButton.hidden = true;
        shareButton.hidden =true;
        [finisherNameButton setEnabled:NO];
        leaderBoardDetailsTable.hidden = true;
        noDataView.hidden =false;
        favShareView.hidden =true;
        noDataLabel.text = @"No Entries Yet";
        noDataLabel.textColor = [UIColor redColor];
    }
    return [userDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"LeaderBoardDetailsTableViewCell";
    LeaderBoardDetailsTableViewCell *cell;
    cell=[leaderBoardDetailsTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LeaderBoardDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *detailString =@"";

    if (![Utility isEmptyCheck:leaderBoardDetailsDict]) {
         cell.indexLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row+1];

        if (islocationSuburb) {
            userDetailsArray = [leaderBattleDict objectForKey:@"CityDataDetail"];
        }else{
            userDetailsArray = [leaderBoardDetailsDict objectForKey:@"Userdetail"];
        }
        NSDictionary *userDetaildict = [userDetailsArray objectAtIndex:indexPath.row];
        
        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"UserID"]]) {
            NSString *loginUserIdString = [@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"UserID"]];
            NSString *userIdString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"UserID"]];
            cell.leaderShareButton.tag=indexPath.row;
            
            if ([loginUserIdString isEqualToString:userIdString]) {
                cell.leaderShareButton.hidden=false;
                cell.selectedImage.image = [UIImage imageNamed:@""];
            }
            else{
                cell.leaderShareButton.hidden=true;
                cell.selectedImage.image = [UIImage imageNamed:@""];
            }
        }else{
                cell.leaderShareButton.hidden=true;
            }
       // NSString *lastNameFirstCharacter=[[userDetaildict objectForKey:@"LastName"] substringToIndex:1];//LastName last chatacter fetch
        if (islocationSuburb) {
            cell.userNameLabel.text=[userDetaildict objectForKey:@"CityName"];
        }else{
            NSString *lastNameFirstCharacter=[userDetaildict objectForKey:@"LastName"];//ah
            
            NSString *userName = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"FirstName"],lastNameFirstCharacter];
            cell.userNameLabel.text =userName;
            
            //cell.citySubLabel.text = [NSString stringWithFormat:@"(%@/%@)",[userDetaildict objectForKey:@"City"],[userDetaildict objectForKey:@"Suburbs"]];  //ah
            
            //add_Today
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
            //add_Today
        }
        
        //ImageAdded
        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Picturepath"]]) {
            cell.userImage.layer.cornerRadius=cell.userImage.frame.size.height/2;
            cell.userImage.layer.masksToBounds = YES;
            cell.userImage.clipsToBounds  = YES;
            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEIMAGE_URL,[userDetaildict objectForKey:@"Picturepath"]];
            
            [cell.userImage sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                        [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                 placeholderImage:[UIImage imageNamed:@"profile_icon.png"] options:SDWebImageScaleDownLargeImages];
            
        }else{
            cell.userImage.image = [UIImage imageNamed:@"profile_icon.png"];
        }
        //---End
        
        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Status"]]) {
            NSString *statusString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"Status"]];
            if ([statusString isEqualToString:@"0"]) {
                cell.statusImageView.image = [UIImage imageNamed:@""];
            }else{
                cell.statusImageView.image = [UIImage imageNamed:@"lb_complete.png"];
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
        cell.commonString.text = detailString;
    
        if ([Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberOrder"]] && [Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"TimeOrder"]] && [Utility isEmptyCheck:[leaderBoardDetailsDict objectForKey:@"NumberResp"]]) {
            cell.commonStringHeightConstraint.constant = 0.0f;
        }
    }
    return cell;
}

#pragma mark - End


#pragma mark - PopoverViewDelegate
- (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option{ //add_su_1_com
    if (isbattle) {
        if ([option isEqualToString:@"0"]) {
            islocationSuburb=false;
            [self dismissViewControllerAnimated:YES completion:nil];
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"People Leaderboard"
                                         message:@""
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* approvedButton = [UIAlertAction
                                             actionWithTitle:@"Approved First"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                 [leaderBoardDetailsTable reloadData];
                                                 [self filterfinisherDetails:@"0"];
                                             }];
            
            UIAlertAction* allButton = [UIAlertAction
                                        actionWithTitle:@"All"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [self filterfinisherDetails:@"1"];
                                        }];
            
            [alert addAction:approvedButton];
            [alert addAction:allButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else{
            NSLog(@"%@",option);
            [self battleFilterDetails:option];
        }
        [defaults setObject:option forKey:@"leadertype"];
    }else{
        if ([option isEqualToString:@"0"]) {
            [self filterfinisherDetails:@"0"];
        }else if ([option isEqualToString:@"1"]){
            [self filterfinisherDetails:@"1"];
        }
        [defaults setObject:option forKey:@"type"];
    }
}
-(void)didCancelOption{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End
@end
