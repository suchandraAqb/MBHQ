//
//  MealAddViewController.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 12/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealTypeViewController.h"
#import "MealMatchTableViewCell.h"
#import "MealAddFooterView.h"
#import "AddRecipeViewController.h"
#import "AddEditIngredientViewController.h"


@interface MealTypeViewController (){
    
    IBOutlet UITableView *mealTypeTable;
    IBOutlet NSLayoutConstraint *mealTypeTableHeight;
    UIView *contentView;
    int apiCount;
    BOOL isChanged;
}

@end

@implementation MealTypeViewController
@synthesize mealTypeArray,currentDate,mealCategory,delegate;

#pragma mark -View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(staticMealTypeSelected:) name:@"staticMealTypeSelected" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mealTypeTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [mealTypeTable reloadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(staticMealTypeSelected:) name:@"staticMealTypeSelected" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [mealTypeTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"staticMealTypeSelected" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -End

#pragma mark -IBAction
- (IBAction)backButtonPressed:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealType:)]) {
        [delegate didCheckAnyChangeForMealType:isChanged];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
   [self.navigationController popViewControllerAnimated:YES];
}
    
#pragma mark -End

#pragma mark - Private Function
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealType:)]) {
            [delegate didCheckAnyChangeForMealType:isChanged];
        }
        [self backButtonPressed:nil];
    }
}

#pragma mark - End

#pragma mark -Tableview Delegate and Datasource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; //mealTypeArray.count
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return UITableViewAutomaticDimension;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(mealTypeArray.count == 0){
        return 1;
    }
    
    return mealTypeArray.count; //mealTypeArray.count
    
}
    
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
        // Removes extra padding in Grouped style
    
    return 350.0;
    
    
}
    
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    MealAddFooterView *sectionFooterView = [[[NSBundle mainBundle] loadNibNamed:@"MealAddFooterView" owner:self options:nil] objectAtIndex:0];
    
    if(mealTypeArray.count == 0){
        sectionFooterView.chooseFromLabel.hidden = true;
    }else{
        sectionFooterView.chooseFromLabel.hidden = false;
    }
    
    return sectionFooterView;
    
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *CellIdentifier =@"MealMatchTableViewCell";
    MealMatchTableViewCell *cell;
    
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MealMatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(mealTypeArray.count == 0){
        cell.myMealTypeView.hidden = true;
    }else{
        cell.myMealTypeView.hidden = false;
    }
    
    NSDictionary *mealDict;
    if (mealTypeArray.count > 0 && mealTypeArray.count >indexPath.row) {
        mealDict = mealTypeArray[indexPath.row];
    }
    
    
    if (![Utility isEmptyCheck:mealDict]){
        NSDictionary *mealDetails = mealDict[@"MealDetails"];
        if (![Utility isEmptyCheck:mealDetails]) {
            cell.planMealView.hidden = false;
            cell.myMealName.text =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
        }else{
            cell.myMealName.text = @"";
        }
    }
    
    cell.myMealTypeView.layer.cornerRadius = 5.0 ;
    cell.myMealTypeView.clipsToBounds =  YES;
    
    
    return cell;
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Row Selected");
    
    NSDictionary *mealDict;
    if (mealTypeArray.count > 0 && mealTypeArray.count >indexPath.row) {
        mealDict = mealTypeArray[indexPath.row];
    }
    
    NSString *mealTypeName = @"";
    
    if (![Utility isEmptyCheck:mealDict]){
        NSDictionary *mealDetails = mealDict[@"MealDetails"];
        if (![Utility isEmptyCheck:mealDetails]) {
            
            mealTypeName =![Utility isEmptyCheck:mealDetails[@"MealName"]] ? mealDetails[@"MealName"] :@"";
        }
        
//        [self getSquadMealList:3 mealName:mealDetails isStatic:false];
        MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        temp[0] = mealDetails;
        controller.currentDate = currentDate;
        controller.isAdd = true;
        controller.isStatic = false;
        controller.mealTypeData = 3;
        controller.mealDetails = mealDetails;
        controller.delegate = self;
        controller.mealListArray = [temp mutableCopy];//responseDict[@"SquadUserActualMealList"];
        //                                                                             controller.mealCategory = mealCategory;
        [self.navigationController pushViewController:controller animated:true];
    }
    
    
   
}
#pragma mark - End

#pragma mark -Table View Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == mealTypeTable) {
        mealTypeTableHeight.constant=mealTypeTable.contentSize.height;
    }
}
#pragma mark -End

#pragma mark -Local Notification Selector
-(void)staticMealTypeSelected:(NSNotification *)notification{
    NSLog(@"%@", notification.object);
    
    if ([notification.object isKindOfClass:[NSString class]]){
        
        if ([notification.object isEqualToString:@"Squad Recipe List"]){
//            [self getSquadMealList:1 mealName:nil isStatic:true];
            MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
            
            controller.currentDate = currentDate;
            controller.isAdd = true;
            controller.isStatic = true;
            controller.mealTypeData = 1;
            controller.mealDetails = nil;
            controller.delegate = self;
//            controller.mealListArray = responseDict[@"SquadUserActualMealList"];
//            controller.mealCategory = mealCategory;
            [self.navigationController pushViewController:controller animated:true];
        }else if ([notification.object isEqualToString:@"My Recipe List"]){
//            [self getSquadMealList:2 mealName:nil isStatic:true];
            MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
            
            controller.currentDate = currentDate;
            controller.isAdd = true;
            controller.isStatic = true;
            controller.mealTypeData = 2;
            controller.mealDetails = nil;
            controller.delegate = self;
            //            controller.mealListArray = responseDict[@"SquadUserActualMealList"];
            //            controller.mealCategory = mealCategory;
            [self.navigationController pushViewController:controller animated:true];
        }else if ([notification.object isEqualToString:@"Create a New Recipe"]){
            
            AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
            controller.currentDate = currentDate;
            controller.isFromMealMatch = true;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else if ([notification.object isEqualToString:@"Squad Ingredient List"]){
//            [self getIngredientList:1 mealName:nil isStatic:true];
            MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
            controller.currentDate = currentDate;
            controller.isAdd = true;
            controller.isStatic = true;
            controller.isStaticIngredient = true;
            controller.mealTypeData = 1;
            controller.mealDetails = nil;
            controller.delegate = self;
//            controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
            [self.navigationController pushViewController:controller animated:true];
            
        }else if ([notification.object isEqualToString:@"My Ingredient List"]){
//            [self getIngredientList:2 mealName:nil isStatic:true];
            MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
            controller.currentDate = currentDate;
            controller.isAdd = true;
            controller.isStatic = true;
            controller.isStaticIngredient = true;
            controller.mealTypeData = 2;
            controller.mealDetails = nil;
            controller.delegate = self;
            //            controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
            [self.navigationController pushViewController:controller animated:true];
            
        }else if ([notification.object isEqualToString:@"Add New Ingredient"]){
            AddEditIngredientViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditIngredient"];
            controller.mealType = @"Add Ingredient";
            controller.currentDate = currentDate;
            controller.isFromMealMatch = true;
            [self.navigationController pushViewController:controller animated:YES];
            
        }
        
    }
    
}
#pragma mark -End

-(void)getSquadMealList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            
            contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadUserActualMealList" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"SquadUserActualMealList"]]){
                                                                            
                                                                             
                                                                             MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                             
                                                                             controller.currentDate = currentDate;
                                                                             controller.isAdd = true;
                                                                             controller.isStatic = isStatic;
                                                                             controller.mealTypeData = mealTypeData;
                                                                             controller.mealDetails = mealdetails;
                                                                             controller.mealListArray = [responseDict[@"SquadUserActualMealList"] mutableCopy];
//                                                                             controller.mealCategory = mealCategory;
                                                                             [self.navigationController pushViewController:controller animated:true];
                                                                             
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

-(void)getIngredientList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic{
    
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"IngredientFilter"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            
            contentView = [Utility activityIndicatorView:self];
            //contentView.backgroundColor = [UIColor clearColor];
            
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientsApiCall" append:@""forAction:@"POST"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0){
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSLog(@"%@",responseDict);
                                                                         
                                                                         
                                                                            MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
                                                                             controller.currentDate = currentDate;
                                                                             controller.isAdd = true;
                                                                             controller.isStatic = isStatic;
                                                                             controller.isStaticIngredient = true;
                                                                             controller.mealTypeData = mealTypeData;
                                                                             controller.mealDetails = mealdetails;
                                                                             controller.mealListArray = [[responseDict objectForKey:@"Ingredients"] mutableCopy];
                                                                             [self.navigationController pushViewController:controller animated:true];
                                                                             
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

#pragma mark - End

#pragma mark - MealAddViewDelegate
-(void)didCheckAnyChangeForMealAdd:(BOOL)ischanged with:(BOOL)isFrom{
    isChanged = ischanged;
    if (isFrom) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealType:)]) {
            [delegate didCheckAnyChangeForMealType:isChanged];
        }
    }
}
@end
