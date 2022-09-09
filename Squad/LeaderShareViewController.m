//
//  LeaderShareViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 10/11/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "LeaderShareViewController.h"
#import "Utility.h"
#import "LeaderShareTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LeaderShareViewController ()
{
    IBOutlet UIImageView *finisherImageView;
    IBOutlet UIButton *detailsFinisherName;
    IBOutlet UIButton *detailsFavouriteButton;
    IBOutlet UITableView *leaderShareTable;
    IBOutlet UIView *shareView;
    IBOutlet NSLayoutConstraint *shareViewHeightConstant;
    IBOutlet NSLayoutConstraint *shareTableViewHeightConstant;
}
@end

@implementation LeaderShareViewController
@synthesize leaderShareDict;
#pragma mark - IBAction

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonPressed:(id)sender {
    UIGraphicsBeginImageContext(shareView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [shareView.layer renderInContext:context];
    //    [self.view.layer renderInContext:context];
    //UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
}

#pragma mark - End

#pragma mark - Private Function

-(void)setupView{
    
    if (![Utility isEmptyCheck:leaderShareDict]) {
        
        NSString *finisherTypeNameString = [@"" stringByAppendingFormat:@"%@",[leaderShareDict objectForKey:@"LederboardType"]];
        if ([finisherTypeNameString isEqualToString:@"FINISHER"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBfinisher_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad WOW"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBwow_iconleader.png"];
            
        }else if ([finisherTypeNameString isEqualToString:@"Squad Elite"])  {
            finisherImageView.image = [UIImage imageNamed:@"LBsquad_iconleader.png"];
        }
        
        NSString *tempString  = [@"" stringByAppendingFormat:@"%@\nStage:%@-%@",[leaderShareDict objectForKey:@"FinisherName"],[leaderShareDict objectForKey:@"Lavel"],[leaderShareDict objectForKey:@"FinisherTypeName"]];
         detailsFinisherName.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [detailsFinisherName setTitle:tempString forState:UIControlStateNormal];
    }
    if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"IsFavourite"]]) {
        NSString *favouriteString = [@"" stringByAppendingFormat:@"%@",[leaderShareDict objectForKey:@"IsFavourite"]];
        if ([favouriteString isEqualToString:@"1"]) {
            [detailsFavouriteButton setImage:[UIImage imageNamed:@"lb_star_active.png"] forState:UIControlStateNormal];
        }
        else{
            [detailsFavouriteButton setImage:[UIImage imageNamed:@"lb_star.png"] forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark - End

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    leaderShareTable.rowHeight = UITableViewAutomaticDimension;
    leaderShareTable.estimatedRowHeight = 60;
    NSLog(@"%@",leaderShareDict);
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void) updateViewConstraints{
    [super updateViewConstraints];
    NSArray *userDetailArray = [leaderShareDict objectForKey:@"Userdetail"];
    if (![Utility isEmptyCheck:userDetailArray]) {
        shareTableViewHeightConstant.constant = userDetailArray.count*60;
        shareViewHeightConstant.constant =50+userDetailArray.count*60;
    }
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - TableViewDataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *userDetailsArray = [leaderShareDict objectForKey:@"Userdetail"];
    return userDetailsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"LeaderShareTableViewCell";
    LeaderShareTableViewCell *cell;
    cell=[leaderShareTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LeaderShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.userInteractionEnabled =false;
    if (![Utility isEmptyCheck:leaderShareDict]) {
        cell.indexLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row+1];
        
        NSArray *userDetailArray = [leaderShareDict objectForKey:@"Userdetail"];
        NSDictionary *userDetaildict = [userDetailArray objectAtIndex:indexPath.row];
        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"UserID"]]) {
            NSString *loginUserIdString = [@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"UserID"]];
            NSString *userIdString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"UserID"]];
            if ([loginUserIdString isEqualToString:userIdString]) {
                cell.selectedImage.image = [UIImage imageNamed:@"section_bg.png"];
            }
            else{
                cell.selectedImage.image = [UIImage imageNamed:@""];
            }
        }
        
        NSString *lastNameFirstCharacter=[[userDetaildict objectForKey:@"LastName"] substringToIndex:1];//LastName last chatacter fetch
        
        NSString *userName = [@"" stringByAppendingFormat:@"%@ %@",[userDetaildict objectForKey:@"FirstName"],lastNameFirstCharacter];
        cell.detailsUserNameString.text =userName;

        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Picturepath"]]) {
            cell.detailsImageView.layer.cornerRadius = cell.detailsImageView.frame.size.width/2;
            cell.detailsImageView.clipsToBounds = YES;
            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@/%@",BASEURL,[userDetaildict objectForKey:@"Picturepath"]];
            [cell.detailsImageView sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                            [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                     placeholderImage:[UIImage imageNamed:@"lb_avatar.png"]
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                            }];
        }else{
            cell.detailsImageView.image = [UIImage imageNamed:@"lb_avatar.png"];
        }
        
        if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Status"]]) {
            NSString *statusString = [@"" stringByAppendingFormat:@"%@",[userDetaildict objectForKey:@"Status"]];
            if ([statusString isEqualToString:@"0"]) {
                cell.detailsStatusImageView.image = [UIImage imageNamed:@""];
            }else{
                cell.detailsStatusImageView.image = [UIImage imageNamed:@"lb_complete.png"];
            }
        }
        
        NSString *detailString =@"";
        if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"NumberOrder"]]) {
            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Score"]]) {
                detailString = [detailString stringByAppendingFormat:@"%@",[leaderShareDict objectForKey:@"UnitName"]];
                detailString = [detailString stringByAppendingFormat:@" %@",[userDetaildict objectForKey:@"Score"]];
                NSLog(@"%@",detailString);
            }
        }
        if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"TimeOrder"]]) {
            
            if (![Utility isEmptyCheck:[userDetaildict objectForKey:@"Timetaken"]]) {
                NSArray* timeTakenArray = [[userDetaildict objectForKey:@"Timetaken"] componentsSeparatedByString: @":"];
                NSString* hourString = [timeTakenArray objectAtIndex: 0];//hour
                NSString *minString = [timeTakenArray objectAtIndex:1];//min
                NSString *secString = [timeTakenArray objectAtIndex:2];//sec
                if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"NumberOrder"]]) {
                    detailString = [detailString stringByAppendingFormat:@"    Time:"];
                }
                else{
                    detailString = [detailString stringByAppendingFormat:@"Time:"];///remove space if numberorder is null
                }
                if (![Utility isEmptyCheck:hourString] && ![hourString isEqualToString:@"00"]) {
                    detailString = [detailString stringByAppendingFormat:@"%@ hour ",hourString];
                }if (![Utility isEmptyCheck:minString] && ![minString isEqualToString:@"00"]) {
                    detailString = [detailString stringByAppendingFormat:@"%@ min ",minString];
                }if (![Utility isEmptyCheck:secString] && ![secString isEqualToString:@"00"] ) {
                    detailString = [detailString stringByAppendingFormat:@"%@ sec ",secString];
                }
            }
        }
        
        if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"NumberResp"]]) {
            if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"RespUnitname"]]) {
                
                if (![Utility isEmptyCheck:[leaderShareDict objectForKey:@"TimeOrder"]]) {
                    detailString = [detailString stringByAppendingFormat:@"    %@",[leaderShareDict objectForKey:@"RespUnitname"]];
                }
                else{
                    detailString = [detailString stringByAppendingFormat:@"%@",[leaderShareDict objectForKey:@"RespUnitname"]];
                }
                detailString = [detailString stringByAppendingFormat:@" %@",[userDetaildict objectForKey:@"RespCount"]];
            }
        }
        
        if ([Utility isEmptyCheck:[leaderShareDict objectForKey:@"NumberOrder"]] && [Utility isEmptyCheck:[leaderShareDict objectForKey:@"TimeOrder"]] && [Utility isEmptyCheck:[leaderShareDict objectForKey:@"NumberResp"]]) {
            cell.detailsHeightConstraint.constant = 0.0f;
        }
        NSLog(@"detailString--%@",detailString);
        cell.commonString.text = detailString;
    }
     [self.view setNeedsUpdateConstraints];
     return cell;
}

#pragma mark - End


@end
