//
//  FoodPrepViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 05/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FoodPrepViewController.h"
#import "FoodPrepTableViewCell.h"
#import "FoodPrepShoppingListViewController.h"

@interface FoodPrepViewController (){
    UIView *contentView;
    IBOutlet UITableView *foodPrepTable;
    IBOutlet UILabel *noDataLabel;
    NSArray *foodPrepList;
    int apiCount;
    BOOL isChanged;
    BOOL isFirstTime;
}
@end

@implementation FoodPrepViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    apiCount = 0;
    noDataLabel.hidden = true;
    NSString *msgStr = [@"" stringByAppendingFormat:@"Hi  %@\n\nThis is the Squad Food Prep Helper. It will allow you to\n1) Search for the exact type of meals you want to make ( IE low carb, high protein ) \n2) Add the amount of meals you want to prep for the week \n3) And immediately make a shopping list for you \n\nAll in Seconds! \nHappy Food Prepping \U0001F642",[[defaults objectForKey:@"FirstName"] uppercaseString]];
    self->noDataLabel.text = msgStr;
    foodPrepTable.hidden = true;
    foodPrepList = [[NSArray alloc]init];
    isChanged = true;
    isFirstTime =true;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    if (!isChanged) {
        return;
    }
    if (isFirstTime) {
        isChanged = false;
        isFirstTime = false;
    }
    [self getWeeklyFoodPrep];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
#pragma mark -IB Action
- (IBAction)addFoodButtonPressed:(UIButton *)sender {
    FoodPrepAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepAddEdit"];
    controller.isEdit = NO;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)foodPrepPressed:(UIButton *)sender {
    FoodPrepShoppingListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepShop"];
    controller.delegate = self;
    controller.foodPrepId = [foodPrepList objectAtIndex:sender.tag][@"Id"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    
    NSDictionary *dict = [foodPrepList objectAtIndex:sender.tag];
    [self GetSquadUserWeeklyFoodPrepMealListWithId:dict[@"Id"]];
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert!"
                                  message:@"Do you want to delete this Food Prep ?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"Yes"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             NSDictionary *dict = [self->foodPrepList objectAtIndex:sender.tag];
                             [self deleteFoodPrep:dict[@"Id"]];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"No"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -End
#pragma mark -Private Methods
-(void)getWeeklyFoodPrep{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
//                                                                             UIAlertController *alertController = [UIAlertController
//                                                                                                                   alertControllerWithTitle:@""
//                                                                                                                   message:msgStr
//                                                                                                                   preferredStyle:UIAlertControllerStyleAlert];
//                                                                             UIAlertAction *okAction = [UIAlertAction
//                                                                                                            actionWithTitle:@"Ok"
//                                                                                                            style:UIAlertActionStyleDefault
//                                                                                                            handler:^(UIAlertAction *action)
//                                                                                                            {
//                                                                                                                [self.navigationController popViewControllerAnimated:YES];
//                                                                                                            }];
//
//                                                                             [alertController addAction:okAction];
                                                                         if (![Utility isEmptyCheck:responseDict[@"GetSquadUserWeeklyFoodPrepList"]]) {
                                                                             self->foodPrepList = responseDict[@"GetSquadUserWeeklyFoodPrepList"];
                                                                             if (self->foodPrepList.count>0) {
                                                                                 [self->foodPrepTable reloadData];
                                                                                 self->noDataLabel.hidden = true;
                                                                                 self->foodPrepTable.hidden = false;
                                                                             }else{
                                                                                 self->foodPrepTable.hidden = true;
                                                                                 self->noDataLabel.hidden = false;
                                                                             }
                                                                         } else {
                                                                             self->foodPrepTable.hidden = true;
                                                                             self->noDataLabel.hidden = false;
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
-(void)deleteFoodPrep:(NSNumber *)foodPerpId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
//        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:foodPerpId forKey:@"FoodPerpId"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"DeleteFoodPrepList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         [self getWeeklyFoodPrep];
//
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

-(void)GetSquadUserWeeklyFoodPrepMealListWithId:(NSNumber *)foodPrepId{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:foodPrepId forKey:@"FoodPerpId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserWeeklyFoodPrep" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"GetSquadUserWeeklyFoodPrepList"]]){
                                                                             
                                                                             FoodPrepAddEditViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepAddEdit"];
                                                                             controller.isEdit = YES;
                                                                             controller.mealNameArray = responseDict[@"GetSquadUserWeeklyFoodPrepList"];
                                                                             controller.delegate = self;
                                                                             [self.navigationController pushViewController:controller animated:YES];
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
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        [delegate didCheckAnyChangeForFoodPrep:isChanged];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -End
#pragma mark -TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return foodPrepList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FoodPrepTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepTableViewCell"];
    NSDictionary *dict = foodPrepList[indexPath.row];
    NSString *foodPrepName = dict[@"FoodPrepName"];
    cell.foodPrepNameLabel.text =  [NSString stringWithFormat:@"%@",foodPrepName];
    cell.viewFoodPrepButton.tag = indexPath.row;
    cell.deleteButton.tag = indexPath.row;
    cell.editButton.tag = indexPath.row;
    
    return cell;
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark - FoodPrepAddEditViewDelegate
-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
