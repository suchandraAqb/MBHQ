//
//  CircuitListViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 10/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CircuitListViewController.h"
#import "CircuitListTableViewCell.h"
#import "AdvanceSearchForCircuitListViewController.h"
#import "CircuitDetailsViewController.h"

@interface CircuitListViewController (){
//    IBOutlet UIButton *mycircuitButton;   //ah 4.5
    IBOutlet UIButton *circuitListButton;

    IBOutlet UITableView *table;
    IBOutlet UIImageView *buttonBg;
    IBOutlet UITextField *searchTextField;
    NSArray *circuitListArray;
    UIView *contentView;
    
    IBOutlet UIButton *allButton;
    IBOutlet UIButton *hiitButton;
    IBOutlet UIButton *pilatesButton;
    IBOutlet UIButton *yogaButton;
    IBOutlet UIButton *cardoButton;
    IBOutlet UIButton *weightButton;
    
    NSMutableDictionary *defaultFilterDictionary;
    BOOL isAllSelect;
    
    BOOL isFirstTime;   //ah 5.5
    BOOL isChanged;
}

@end

@implementation CircuitListViewController

@synthesize mycircuitButton;    //ah 4.5

#pragma -mark APICall
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchCircuitsApiCall" append:@""forAction:@"POST"];
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
                                                                         circuitListArray = [responseDict objectForKey:@"Circuits"];
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
-(void)getCircuitList:(NSString *)searchText with:(NSDictionary*)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSString *mode=@"";
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        if (![Utility isEmptyCheck:searchText]) {
            [mainDict setObject:searchText forKey:@"SearchText"];
        }
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        
         if (circuitListButton.selected) {
             mode=@"custom";
         }else{
             mode=@"myCircuit";
         }
        [mainDict setObject:mode forKey:@"Mode"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCircuitListApiCall" append:@"" forAction:@"POST"];
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
                                                                         circuitListArray = [responseDict objectForKey:@"Circuits"];
                                                                         if (circuitListArray.count > 0) {
                                                                             NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"CircuitName"  ascending:YES];
                                                                             circuitListArray=[circuitListArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
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
- (void) deleteCircuitWithID:(int)cktID {
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
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:cktID] forKey:@"CircuitId"];
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"IsDeleted"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadUpdateCircuitForIsDeleted" append:@"" forAction:@"POST"];
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
                                                                         [Utility msg:@"Delete Successful" title:@"Success" controller:self haveToPop:NO];
                                                                         [self getCircuitList:nil with:defaultFilterDictionary];
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
#pragma -mark End

#pragma -mark IBAction

-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{ //add1
    if([sender isEqual:allButton] ){
        allButton.selected = !allButton.isSelected;
    }else if([sender isEqual:hiitButton] ){
        hiitButton.selected = !hiitButton.isSelected;
        allButton.selected =false;
    }else if([sender isEqual:pilatesButton] ){
        pilatesButton.selected = !pilatesButton.isSelected;
        allButton.selected =false;
    }else if([sender isEqual:yogaButton] ){
        yogaButton.selected = !yogaButton.isSelected;
        allButton.selected =false;
    }else if([sender isEqual:cardoButton] ){
        cardoButton.selected = !cardoButton.isSelected;
        allButton.selected =false;
    }else if([sender isEqual:weightButton] ){
        weightButton.selected = !weightButton.isSelected;
        allButton.selected =false;
    }
    [self sessionListCheck];
}

-(IBAction)AdvanceSearchButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        AdvanceSearchForCircuitListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearchForCircuitList"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });

}
-(IBAction)circuitEditButtonPressed:(UIButton *)sender{ //ah 4.5
    EditCircuitViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCircuit"];
    controller.cktID = [[[circuitListArray objectAtIndex:sender.tag] objectForKey:@"CircuitId"] intValue];
    controller.exSessionId = -1;
    controller.isNewCkt = NO;   //ah 2.5
    controller.oldCktID = -1;
    controller.sequence = -1;
    controller.editCktDelegate =self;//Local_catch
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSString *dateDt = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"EEEE dd MMM yyyy"];
    
    controller.dt = dateDt;
    controller.fromController = @"editList";
    
    isFirstTime = NO;
    
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)circuitDetailsButtonPressed:(UIButton*)sender{
    CircuitDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CircuitDetails"];
    controller.circuitDict =[circuitListArray objectAtIndex:[sender tag]];
    [self.navigationController pushViewController:controller animated:YES];
}
-(IBAction)circuitOrMyCircuitListButtonPressed:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] && (sender == mycircuitButton)){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (sender == circuitListButton) {
        circuitListButton.selected = true;
        mycircuitButton.selected = false;
      //  [defaultFilterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];//add1

        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
    }else{
        mycircuitButton.selected = true;
        circuitListButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar_flip.png"];
        //[defaultFilterDictionary setObject:[NSNumber numberWithInt:4] forKey:@"Category"];
    }
    
    hiitButton.selected=true;
    pilatesButton.selected=true;
    yogaButton.selected=true;
    cardoButton.selected=true;
    weightButton.selected=false;
    allButton.selected=false;
    
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Hiit"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Cardio"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Pilates"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Yoga"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Weight"];
    
    [self getCircuitList:searchTextField.text with:defaultFilterDictionary];
    
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)createNewButtonTapped:(id)sender {
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    CreateCircuitViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateCircuit"];    //ah 4.5
    controller.createCircuitDelegate = self; //Local_catch
    controller.exSessionId = 0;
    controller.dt = @"";
    controller.fromController = @"list";
    isFirstTime = NO;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)cktDeleteButtonTapped:(UIButton*)sender {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you want to delete this circuit?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   [self deleteCircuitWithID:[[[circuitListArray objectAtIndex:[sender tag]] objectForKey:@"CircuitId"] intValue]];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma -mark End

#pragma mark - Private Function

-(void)sessionListCheck{
    isAllSelect =true;
    
    if (allButton.selected) {
        hiitButton.selected=true;
        pilatesButton.selected=true;
        yogaButton.selected=true;
        cardoButton.selected=true;
        weightButton.selected=true;
        allButton.selected=true;

        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Hiit"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Weight"];
    }else{
        if (hiitButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Hiit"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Hiit"];
        }
        if (pilatesButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Pilates"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Pilates"];
        }
        if (yogaButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Yoga"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Yoga"];
        }
        if (cardoButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Cardio"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Cardio"];
        }
        if (weightButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Weight"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Weight"];
        }
        if (isAllSelect) {
            allButton.selected=true;
        }
    }
    [self getCircuitList:nil with:defaultFilterDictionary];
}

#pragma -mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    circuitListButton.selected = true;
    mycircuitButton.selected=false;
    buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
    defaultFilterDictionary = [[NSMutableDictionary alloc]init];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    // [defaultFilterDictionary removeObjectForKey:@"Category"];change1
    //[defaultFilterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];//add1
    
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Hiit"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Cardio"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Pilates"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"Yoga"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"Weight"];
    
    hiitButton.selected=true;
    pilatesButton.selected=true;
    yogaButton.selected=true;
    cardoButton.selected=true;
    weightButton.selected=false;
    allButton.selected=false;

    isFirstTime = YES;  //ah 5.5
    isChanged = true;
    [self getCircuitList:nil with:defaultFilterDictionary];
}

-(void) viewDidAppear:(BOOL)animated {  //ah 5.5
    [super viewDidAppear:YES];
    if (!isChanged) { //Local_catch
        isChanged = YES;
        return;
    }//Local_catch
    
        if (isFirstTime) {
            //        isFirstTime = NO;
        } else {
            [self circuitOrMyCircuitListButtonPressed:mycircuitButton];
            if (circuitListArray.count > 0) {
                [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:circuitListArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        }
}
#pragma -mark End

#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return circuitListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"CircuitListTableViewCell";
    CircuitListTableViewCell *cell = (CircuitListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[CircuitListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [circuitListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        cell.circuitName.text= ![Utility isEmptyCheck:[dict objectForKey:@"CircuitName"]] ? [dict objectForKey:@"CircuitName"]:@"";
        [cell.circuitDetails setTag:indexPath.row]; //ah 4.5
        [cell.circuitEdit setTag:indexPath.row];
    }
    cell.circuitEdit.tag = indexPath.row;
    cell.circuitDetails.tag = indexPath.row;
    
    if (![Utility isEmptyCheck:[dict objectForKey:@"UserId"]]) {
        cell.deleteButton.hidden = false;
        [cell.deleteButton addTarget:self
                              action:@selector(cktDeleteButtonTapped:)
                    forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row;
    } else {
        cell.deleteButton.hidden = true;
    }
    

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",[circuitListArray objectAtIndex:indexPath.row]);
    CircuitDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CircuitDetails"];
    isChanged = false;//Local_catch
    controller.circuitDict =[circuitListArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma -mark End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchTextField) {
        [textField resignFirstResponder];
        NSString *searchString = textField.text;
        textField.text = @"";
        [self getCircuitList:searchString with:nil];
        
        return NO;
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
- (void) applyForCircuitFilter:(NSDictionary *)data{
    NSLog(@"------------%@",data);
    [self advanceSearch:data];
}
#pragma -mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - EditCircuitDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End

#pragma mark  - CreateCircuitDelegate

-(void)didCheckAnyChangeForCreateCircuit:(BOOL)ischanged{
    isChanged = ischanged;
}
@end
