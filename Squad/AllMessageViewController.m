//
//  AllMessageViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 21/06/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "AllMessageViewController.h"
#import "AllMessageTableViewCell.h"
#import "AllMessageDetailsViewController.h"
@interface AllMessageViewController ()
{
    IBOutlet UITableView *messageTable;
    IBOutlet UIButton *privateMessageButton;
    IBOutlet UILabel *nodataLabel;
    UIView *contentView;
    NSArray *authorMessagesArr;
    NSArray *dataArray;
    BOOL isChanged;
    
}
@end

@implementation AllMessageViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    privateMessageButton.layer.cornerRadius = 15;
    privateMessageButton.layer.masksToBounds = YES;
    messageTable.hidden = true;
    isChanged = true;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!isChanged) {
        return;
    }
    isChanged = false;
    [self webServiceCall_GetUserCourseMessagesByAuthors];
}
#pragma mark  - End

#pragma mark  - IBAction
-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)privateMessagesButtonTapped:(id)sender{
    

    
}
#pragma mark - Webservice call
-(void)webServiceCall_GetUserCourseMessagesByAuthors{
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetUserCourseMessagesByAuthors" append:@""forAction:@"POST"];
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
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          self->dataArray=[responseDict objectForKey:@"CourseAuthorMessages"];
                                                                          
//                                                                          self->authorMessagesArr = [responseDict objectForKey:@"AuthorMessages"];
                                                                          if (self->dataArray.count>0) {
                                                                              self->messageTable.hidden = false;
                                                                              self->nodataLabel.hidden = true;
                                                                              [self->messageTable reloadData];
                                                                          }else{
                                                                              self->messageTable.hidden = true;
                                                                              self->nodataLabel.hidden = false;
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
-(BOOL)isSettingsPage{
    BOOL isSettings = false;
    return false;
    
    if ([self.parentViewController isKindOfClass:[ChooseGoalViewController class]] ||[self.parentViewController isKindOfClass:[DietaryPreferenceViewController class]] ||[self.parentViewController isKindOfClass:[MealFrequencyViewController class]] ||[self.parentViewController isKindOfClass:[MealVarietyViewController class]] ||[self.parentViewController isKindOfClass:[MealPlanViewController class]] ||[self.parentViewController isKindOfClass:[CustomProgramSetupViewController class]] ||[self.parentViewController isKindOfClass:[RateFitnessLevelViewController class]] ||[self.parentViewController isKindOfClass:[PersonalSessionsViewController class]] ||[self.parentViewController isKindOfClass:[MovePersonalSessionViewController class]]) {
        isSettings = true;
    }
    return isSettings;
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert!"
                                          message:@"Are you sure you want to exit?\n\nWe need your goals and preferences to create your custom nutrition and workout program and set up your challenges.\nPlease continue!"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Continue"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   response(NO);
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Exit"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action)
                                   {
                                       response(YES);
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//-(void)incompleStartTaskAlert{
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:@"Alert!"
//                                          message:@"Please complete top 4 getting started task to access this functionality."
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:@"OK"
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   [self logoButtonPressed:0];
//                               }];
//    UIAlertAction *cancelAction = [UIAlertAction
//                                   actionWithTitle:@"Cancel"
//                                   style:UIAlertActionStyleCancel
//                                   handler:^(UIAlertAction *action)
//                                   {
//
//                                   }];
//    [alertController addAction:okAction];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}
#pragma mark - End

#pragma mark - TableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dict=dataArray[section];
    NSArray *arr=[dict objectForKey:@"AuthorMessages"];
    return arr.count;
//    return authorMessagesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMessageTableViewCell"];
    
    NSDictionary *dataDict=dataArray[indexPath.section];
    authorMessagesArr=[dataDict objectForKey:@"AuthorMessages"];
    
        NSDictionary *authorDict = [authorMessagesArr objectAtIndex:indexPath.row];
    cell.readUnreadStatus.layer.cornerRadius = cell.readUnreadStatus.frame.size.height/2;
    cell.readUnreadStatus.layer.masksToBounds = YES;
    
    cell.authorImageButton.layer.cornerRadius = cell.authorImageButton.frame.size.height/2;
    cell.authorImageButton.layer.masksToBounds = YES;
    cell.authorImageButton.layer.borderColor = squadMainColor.CGColor;
    cell.authorImageButton.layer.borderWidth=1;
    
    if (![Utility isEmptyCheck:authorDict]) {
        
        if (![Utility isEmptyCheck:[authorDict objectForKey:@"Photo"]]) {
            [cell.authorImageButton sd_setImageWithURL:[NSURL URLWithString:[authorDict objectForKey:@"Photo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lb_avatar.png"] options:SDWebImageScaleDownLargeImages];
        } else {
            [cell.authorImageButton setImage:[UIImage imageNamed:@"lb_avatar.png"] forState:UIControlStateNormal];
        }
  
        if (![Utility isEmptyCheck:[authorDict objectForKey:@"AuthorName"]]) {
            cell.authorName.text = [authorDict objectForKey:@"AuthorName"];
        }else{
            cell.authorName.text = @"";
        }
//        NSArray *msgArr = [authorDict objectForKey:@"Messages"];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy-MM-dd"];
//        NSDateComponents* comps = [[NSDateComponents alloc]init];
//        comps.day = 1;
//        NSCalendar* calendar = [NSCalendar currentCalendar];
//        NSDate* tomorowDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
//        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(ReleaseDate < %@)",[formatter stringFromDate:tomorowDate]];
//        NSArray *messagesArr = [msgArr filteredArrayUsingPredicate:predicate1];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsRead == NO"];
//        NSArray *messageUnreadCountArr = [messagesArr filteredArrayUsingPredicate:predicate];
//        NSLog(@"%@",messageUnreadCountArr);
        if ([[authorDict objectForKey:@"HasUnreadMessage"]boolValue]) {
            cell.readUnreadStatus.hidden = false;
            cell.authorName.font = [UIFont fontWithName:@"Raleway-Bold" size:17];
        }else{
            cell.readUnreadStatus.hidden = true;
            cell.authorName.font = [UIFont fontWithName:@"Raleway-Medium" size:17];
        }
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UILabel *label=[[UILabel alloc] init];
//    label.backgroundColor=[UIColor whiteColor];
    
    UILabel *customLabel = [[UILabel alloc] init];
    customLabel.backgroundColor=[UIColor whiteColor];
    customLabel.textColor = [UIColor colorWithRed:50.0 / 255.0 green:205.0 / 255.0 blue:184.0 / 255.0 alpha:1.0];
    customLabel.font = [UIFont fontWithName:@"Raleway-Bold" size:17.0];
    NSDictionary *dataDict=dataArray[section];
    customLabel.text=[@"  " stringByAppendingFormat:@"%@",[dataDict objectForKey:@"CourseName"]];
    
    
    
    return customLabel;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Utility isEmptyCheck:[dataArray objectAtIndex:indexPath.section]]) {
        NSDictionary *dataDict=dataArray[indexPath.section];
        authorMessagesArr=[dataDict objectForKey:@"AuthorMessages"];
        
        if (![Utility isEmptyCheck:[authorMessagesArr objectAtIndex:indexPath.row]]) {
            NSDictionary *detailsDict = [authorMessagesArr objectAtIndex:indexPath.row];
            if (![Utility isEmptyCheck:[detailsDict objectForKey:@"Messages"]]) {
                AllMessageDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"AllMessageDetailsView"];
                controller.messageDetailsDict = detailsDict;
                controller.allmessageDelegate = self;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
        
    }
    
    
    
    
}
#pragma mark - End

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
@end
