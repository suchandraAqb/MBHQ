//
//  MyBuddiesListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 29/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "MyBuddiesListViewController.h"
#import "FindMeABuddyListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AccountabilityGoalActionViewController.h"
@interface MyBuddiesListViewController ()
{
    IBOutlet UIButton *headerButton;
    IBOutlet UITableView *myBuddiesTable;
    UIView *contentView;
}
@end

@implementation MyBuddiesListViewController
@synthesize mybuddiesArr;

#pragma Mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareView];
    if (mybuddiesArr.count>0) {
        [myBuddiesTable reloadData];
    }else{
        [self GetbuddyListApiCall];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End
#pragma mark - Web Service Call
-(void) GetbuddyListApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetbuddyList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  if (self->contentView) {
                                                                      [self->contentView removeFromSuperview];
                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      NSLog(@"responseDict: \n %@",responseDict);
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          NSArray *tempArray =[responseDict objectForKey:@"FriendListDetail"];
                                                                          self->mybuddiesArr = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(StatusFromFriend == %d)", 0]];
                                                                          
                                                                          
                                                                          NSLog(@"%@",self->mybuddiesArr);
                                                                          
                                                                          if (self->mybuddiesArr.count>0) {
                                                                              [self->myBuddiesTable reloadData];
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

#pragma mark - Private Function
-(void)prepareView{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"my "];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"EyeCatchingPro" size:35] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
    
    NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"BUDDIES"];
    [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:16] range:NSMakeRange(0, [attributedString2 length])];
    [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
    
    [attributedString appendAttributedString:attributedString2];
    [headerButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}
#pragma mark - End

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return mybuddiesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"FindMeABuddyListTableViewCell";
    FindMeABuddyListTableViewCell *cell = (FindMeABuddyListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[FindMeABuddyListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict =  [mybuddiesArr objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        if (![Utility isEmptyCheck:[dict objectForKey:@"Name"]]) {
            cell.myBuddiesLabel.text = [dict objectForKey:@"Name"];
        }
        cell.buddiesImg.layer.cornerRadius = cell.buddiesImg.frame.size.height/2;
        cell.buddiesImg.layer.masksToBounds = YES;
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"ProfilePic"]]) {
            NSString *imageUrl= [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ProfilePic"]];
            [cell.buddiesImg sd_setImageWithURL:[NSURL URLWithString:[imageUrl stringByAddingPercentEncodingWithAllowedCharacters:
                                                                   [NSCharacterSet URLQueryAllowedCharacterSet]]]
                            placeholderImage:[UIImage imageNamed:@"lb_avatar.png"]
                                     options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                         });
                                     }];
        }else{
            cell.buddiesImg.image = [UIImage imageNamed:@"lb_avatar.png"];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [mybuddiesArr objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        AccountabilityGoalActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AccountabilityGoalActionView"];
        controller.buddiesDict = dict;
        [self.navigationController pushViewController:controller animated:YES];

    }
}

@end
