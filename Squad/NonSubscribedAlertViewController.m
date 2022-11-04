//
//  NonSubscribedAlertViewController.m
//  Squad
//
//  Created by Admin on 12/10/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "NonSubscribedAlertViewController.h"

@interface NonSubscribedAlertViewController (){
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *updateInstructionLabel;
    IBOutlet UILabel *couponLabel;
    IBOutlet UIButton *updateButton;
    IBOutlet UITableView *courseNameTable;
    IBOutlet NSLayoutConstraint *courseNameTableHeightConstraint;
    IBOutlet UILabel *emailLabel;
    
    
    UIView *contentView;
    NSArray *courseNameListArray;

    
}
@end

@implementation NonSubscribedAlertViewController
@synthesize sectionName;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Utility isEmptyCheck:[defaults objectForKey:@"CourseNameArray"]]) {
        courseNameListArray=[defaults objectForKey:@"CourseNameArray"];
        [self prepaView];
    }else{
        [self getCourseListApiCall];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

-(void) viewDidLayoutSubviews {
    courseNameTableHeightConstraint.constant = courseNameTable.contentSize.height;
}


#pragma mark - End


#pragma mark - IBActions

- (IBAction)crossPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(),^ {
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (IBAction)updateButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [Utility redirectionForUpgrade:self];
        /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SignupWithEmailViewController *signupController=[storyboard instantiateViewControllerWithIdentifier:@"SignupWithEmail"];
           NSDictionary *userData = [defaults objectForKey:@"OnlyProgramMember"];
           if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
               signupController.isFromFb = ![Utility isEmptyCheck:userData[@"IsFbUser"]]?[userData[@"IsFbUser"] boolValue] : NO;
               signupController.fName = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
               signupController.lName = ![Utility isEmptyCheck:userData[@"LastName"]]?userData[@"LastName"] : @"";
               signupController.email = userData[@"Email"];
               if (![Utility isEmptyCheck:userData[@"IsFbUser"]] && [userData[@"IsFbUser"] boolValue]) {
                   signupController.password = ![Utility isEmptyCheck:userData[@"Password"]]?userData[@"Password"] : @"";
               }else{
                   signupController.password =  @"";
               }
               signupController.isFromNonSubscribedUser = YES;
               
           }
         [self->_parent.navigationController pushViewController:signupController animated:YES];
         */
        }];
         

}


#pragma mark - End


#pragma mark - Private methods

-(void)prepaView{
    nameLabel.text=[[NSString stringWithFormat:@"HI %@ !",[defaults objectForKey:@"FirstName"]] uppercaseString];
    
    [courseNameTable reloadData];
    
    if ([sectionName isEqualToString:@"Gratitude"]) {
        updateInstructionLabel.text=@"To use the gratitude and growth journals please update your membership here";
    }else if ([sectionName isEqualToString:@"Meditation"]){
        updateInstructionLabel.text=@"To calm you mind and focus your energy please update your membership here";
    }else if ([sectionName isEqualToString:@"Habit"]){
        updateInstructionLabel.text=@"To use the habit tracker and bucket list please update your membership here";
    }else if ([sectionName isEqualToString:@"Forum"]){
        updateInstructionLabel.text=@"To connect with our community of mindful, conscious and health focused members please update your membership here";
    }else if ([sectionName isEqualToString:@"Course"]){
        updateInstructionLabel.text=@"To use the member only programs please update your membership here";
    }
    
    updateButton.layer.cornerRadius=20;
    updateButton.clipsToBounds=YES;
    
    couponLabel.text=@"Use code: mb10 for 10% off";
    emailLabel.text=[NSString stringWithFormat:@"Use is : %@",[defaults objectForKey:@"Email"]];
      
}

#pragma mark - End

#pragma mark - api call
-(void)getCourseListApiCall
{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCourseListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                        NSArray *rawListProgram = [responseDictionary objectForKey:@"Courses"];
                                                                         NSMutableArray *programArray=[[NSMutableArray alloc] init];
                                                                         
                                                                         NSPredicate *nonLivePredicate = [NSPredicate predicateWithFormat:@"IsLiveCourse == %@",[NSNumber numberWithBool:NO]];
                                                                         NSArray *nonLiveArray = [rawListProgram filteredArrayUsingPredicate:nonLivePredicate];
                                                                         
                                                                         NSPredicate *livePredicate = [NSPredicate predicateWithFormat:@"IsLiveCourse == %@",[NSNumber numberWithBool:YES]];
                                                                         NSArray *liveArray = [rawListProgram filteredArrayUsingPredicate:livePredicate];
                                                                         
                                                                         NSPredicate *subscribedPredicateLive=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:YES]];
                                                                         
                                                                         NSArray *subscribedArrLive=[liveArray filteredArrayUsingPredicate:subscribedPredicateLive];
                                                                         [programArray addObjectsFromArray:subscribedArrLive];
                                                                         
                                                                         NSPredicate *paidPredicate=[NSPredicate predicateWithFormat:@"SubscriptionType == %@",@2];
                                                                         NSArray *paidArr=[nonLiveArray filteredArrayUsingPredicate:paidPredicate];
                                                                         
                                                                         NSPredicate *subscribedPredicate=[NSPredicate predicateWithFormat:@"HasSubscribed == %@",[NSNumber numberWithBool:YES]];
                                                                         NSArray *subscribedPaidArr=[paidArr filteredArrayUsingPredicate:subscribedPredicate];
                                                                         [programArray addObjectsFromArray:subscribedPaidArr];
                                                                         
                                                                         
                                                                        NSMutableArray *courseNameArr=[[NSMutableArray alloc] init];
                                                                        for (NSDictionary *dict in programArray) {
                                                                            if (![Utility isEmptyCheck:dict[@"CourseName"]]) {
                                                                                [courseNameArr addObject:dict[@"CourseName"]];
                                                                            }
                                                                        }
                                                                        if (![Utility isEmptyCheck:courseNameArr] && courseNameArr.count>0) {
                                                                            self->courseNameListArray=courseNameArr;
                                                                        }
                                                                         [self prepaView];
                                                                     }
                                                                     else{
                                                                         [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}

#pragma mark - End



#pragma mark - Tableview datasourse & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return courseNameListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier =@"NonSubscribedAlertTableViewCell";
    NonSubscribedAlertTableViewCell *cell = (NonSubscribedAlertTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NonSubscribedAlertTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *txt=![Utility isEmptyCheck:courseNameListArray[indexPath.row]]?courseNameListArray[indexPath.row]:@"";
    cell.courseName.text=[NSString stringWithFormat:@"%@",txt];
    cell.booletView.layer.cornerRadius=cell.booletView.frame.size.height/2;
    cell.booletView.clipsToBounds=YES;
    return cell;
        
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension; //chayan changed
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
//    return 85;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


#pragma mark - End

@end
