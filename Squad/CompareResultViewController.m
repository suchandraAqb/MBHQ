//
//  CompareResultViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 20/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "CompareResultViewController.h"
#import "CompareResultTableViewCell.h"
#import "AddDetailsViewController.h"

@interface CompareResultViewController (){
    
    IBOutletCollection(UIView) NSArray *topTabBarButtonContainer;
    IBOutletCollection(UIButton) NSArray *topTabBarButton;
    IBOutletCollection(UIView) NSArray *topTabBarBottomIndicator;
    IBOutlet UITableView *table;

    
    NSMutableArray *compareResultData;
    NSString *type;
    NSArray *compareResultKeyArray;
    UIView *contentView;
    
    int pageNumber;
}

@end

@implementation CompareResultViewController
@synthesize selectedIndex;

#pragma mark - ViewLife Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    table.estimatedRowHeight = 185;
    table.rowHeight = UITableViewAutomaticDimension;
    
    if(!_isFromLatestResult){
        selectedIndex = 0;
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    pageNumber = 0;
    compareResultData = [[NSMutableArray alloc]init];
    [self filter:selectedIndex];

}
#pragma mark - End

#pragma mark - Private Methods
-(void)filter:(int)index{
    for (int i=0; i <topTabBarButtonContainer.count; i++) {
        UIView *bgview= topTabBarButtonContainer[i];
        UIView *indicatorview= topTabBarBottomIndicator[i];
        
        if(i==index){
            bgview.backgroundColor = [Utility colorWithHexString:@"b7187f"];
            indicatorview.backgroundColor = [Utility colorWithHexString:@"93b2eb"];

        }else{
            bgview.backgroundColor = [Utility colorWithHexString:@"ff42aa"];
            indicatorview.backgroundColor = [UIColor clearColor];

        }
    }
    NSString *apiString = @"";
    
    NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
    [mainDict setObject:AccessKey forKey:@"Key"];
    [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserId"];
    [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
    [mainDict setObject:[defaults objectForKey:@"UnitPreference"] forKey:@"UnitPreference"];
    [mainDict setObject:[NSNumber numberWithInt:pageNumber] forKey:@"PageIndex"];


    
    if (index==0) {
        compareResultKeyArray = @[@{
                                      @"key":@"BodyWeight",
                                      @"value":@"Weight"
                                    },@{
                                      @"key":@"BodyFatPercentage",
                                      @"value":@"Body Fat %"
                                    },@{
                                      @"key":@"BodyFatKgs",
                                      @"value":@"Body Fat"
                                      },@{
                                      @"key":@"MuscleKg",
                                      @"value":@"Lean Muscle"
                                    }];
        
        
        apiString = @"GetBodyCompositionWeightApiCall";
    }else if (index==1) {
        compareResultKeyArray = @[@{
                                      @"key":@"Chest",
                                      @"value":@"Chest"
                                      },@{
                                      @"key":@"Stomach",
                                      @"value":@"Stomach"
                                      },@{
                                      @"key":@"Hips",
                                      @"value":@"Hips"
                                      },@{
                                      @"key":@"Leg",
                                      @"value":@"Leg"
                                      },@{
                                      @"key":@"Arm",
                                      @"value":@"Arm"
                                      },@{
                                      @"key":@"Total",
                                      @"value":@"Total"
                                      }];
        
        
        apiString = @"GetBodyMeasurementsApiCall";
    }else if (index==2) {
        compareResultKeyArray = @[@{
                                      @"key":@"Brand",
                                      @"value":@"Brand"
                                      },@{
                                      @"key":@"PantSize",
                                      @"value":@"Size"
                                      },@{
                                      @"key":@"Feel",
                                      @"value":@"How do they feel?"
                                      }];
        apiString = @"BodyRefrencesTopDetailApiCall";
    }else if (index==3) {
        compareResultKeyArray = @[@{
                                      @"key":@"Brand",
                                      @"value":@"Brand"
                                      },@{
                                      @"key":@"PantSize",
                                      @"value":@"Size"
                                      },@{
                                      @"key":@"Feel",
                                      @"value":@"How do they feel?"
                                      }];
        compareResultKeyArray = @[@{
                                      @"key":@"Brand",
                                      @"value":@"Brand"
                                      },@{
                                      @"key":@"PantSize",
                                      @"value":@"Size"
                                      },@{
                                      @"key":@"Feel",
                                      @"value":@"How do they feel?"
                                      }];

        apiString = @"BodyRefrencesPantDetailApiCall";
        
    }
    type = apiString;
    [self getCompareResultData:mainDict api:apiString];

}
-(void)deleteCompareData:(NSNumber *)deleteId api:(NSString *)api deleteType:(NSString *)deleteType{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:deleteId forKey:@"DataId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] &&[[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                         [Utility msg:[deleteType stringByAppendingString:@" Data deleted successfully" ] title:@"Success" controller:self haveToPop:YES];
                                                                     }else{
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void) getCompareResultData:(NSMutableDictionary *)mainDict api:(NSString *)api {
    if (Utility.reachable) {
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:api append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] &&[[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         NSArray *tempArray;
                                                                         if ([api isEqualToString:@"GetBodyCompositionWeightApiCall"] || [api isEqualToString:@"GetBodyMeasurementsApiCall"]) {
                                                                             tempArray = responseDictionary[@"BodyCompositionWeight"];
                                                                         }else{
                                                                             tempArray = responseDictionary[@"BodyClothModel"];
                                                                         }
                                                                         if (tempArray.count > 0) {
                                                                             [compareResultData addObjectsFromArray:tempArray];
                                                                             [table reloadData];
                                                                         }
                                                                     }else{
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
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}



#pragma mark - End

#pragma mark - IBAction
- (IBAction)editButtonPressed:(UIButton *)sender {
    AddDetailsViewController *controller=[self.storyboard instantiateViewControllerWithIdentifier:@"AddDetailsView"];
    if (selectedIndex == 0) {
        controller.dataDict = [compareResultData[(int)sender.tag] mutableCopy];
        controller.type= @"Body Weight Composition";
        controller.selectedFields = @[@"BodyWeight",@"BodyFatPercentage",@"BodyFatKgs",@"MuscleKg"];
    }else if (selectedIndex == 1) {
        controller.type = @"Body Measurement Composition";
        controller.dataDict = [compareResultData[(int)sender.tag] mutableCopy];
        controller.selectedFields = @[@"Chest",@"Stomach",@"Hips",@"Leg",@"Arm",@"Total"];
        
    }else if (selectedIndex == 2) {
        controller.type = @"Refrence Top";
        controller.dataDict = [compareResultData[(int)sender.tag] mutableCopy];
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }else if (selectedIndex == 3) {
        controller.type = @"Refrence Pant Composition";
        controller.dataDict = [compareResultData[(int)sender.tag] mutableCopy];
        controller.selectedFields= @[@"Brand",@"PantSize",@"Feel"];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    NSString *warning =@"";
    NSString *api = @"";
    NSNumber *deleteId;
    NSDictionary *dict = compareResultData[sender.tag];
    if (![Utility isEmptyCheck:dict]) {
        if ([type isEqualToString:@"GetBodyCompositionWeightApiCall"]) {
            warning = @"Body Weight Composition";
            api = @"DeleteBodyCompositionApiCall";
            deleteId = dict[@"BodyCompositionId"];
            
        }else if ([type isEqualToString:@"GetBodyMeasurementsApiCall"]) {
            warning = @"Body Measurement Composition";
            api = @"DeleteBodyCompositionApiCall";
            deleteId = dict[@"BodyCompositionId"];
            
        }else if ([type isEqualToString:@"BodyRefrencesTopDetailApiCall"]) {
            warning = @"Refrence Top";
            api = @"DeleteRefrenceApiCall";
            deleteId = dict[@"ReferenceClothDataId"];
        }else if ([type isEqualToString:@"BodyRefrencesPantDetailApiCall"]) {
            warning = @"Refrence Pant Composition";
            api = @"DeleteRefrenceApiCall";
            deleteId = dict[@"ReferenceClothDataId"];
        }
       NSString  *warningTotalString = [warning stringByAppendingString:@" will be Deleted ! Are you really sure?"];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Delete confirmation"
                                      message:warningTotalString
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Confirm"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self deleteCompareData:deleteId api:api deleteType:warning];
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"No"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                     
                                 }];
        [alert addAction:cancel];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
;
    }

}

- (IBAction)compareButtonPressed:(UIButton *)sender {
    pageNumber = 0;
    compareResultData = [[NSMutableArray alloc]init];
    [table reloadData];
    selectedIndex = (int)sender.tag;
    [self filter:selectedIndex];

}
- (IBAction)menuTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

- (IBAction)logoTapped:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}

- (IBAction)backTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - End
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return compareResultData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = @"CompareResultTableViewCell";
    CompareResultTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CompareResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *dataDict = [compareResultData objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dataDict]) {
        NSString *dateString = dataDict[@"DateAdded"];
        if (![Utility isEmptyCheck:dateString] && dateString.length > 10) {
            dateString = [dateString substringToIndex:10];
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"yyyy-MM-dd";
            NSDate *date = [formatter dateFromString:dateString];
            formatter.dateFormat = @"dd/MM/yyyy";
            if (date) {
                cell.compareDateLabel.text = [formatter stringFromDate:date];
            }
        }
        if ([type isEqualToString:@"BodyRefrencesPantDetailApiCall"] || [type isEqualToString:@"BodyRefrencesTopDetailApiCall"]) {
            //[cell.compareMainStackView removeArrangedSubview:cell.compareLowerSubStackView];
            //[cell.compareLowerSubStackView removeFromSuperview];
            cell.compareLowerSubStackView.hidden = true;

        }else{
           // [cell.compareMainStackView addArrangedSubview:cell.compareLowerSubStackView];
            cell.compareLowerSubStackView.hidden = false;
        }
        for (int i=0; i< compareResultKeyArray.count; i++) {
            UILabel *titleLabel = cell.compareTitleLable[i];
            UILabel *valueLabel = cell.compareValueLable[i];
            NSDictionary *dict = compareResultKeyArray[i];
            titleLabel.text = dict[@"value"];
            if (![Utility isEmptyCheck:dataDict[dict[@"key"]]]) {
                if ([dict[@"key"] isEqualToString:@"Feel"]) {
                    valueLabel.text = [@"" stringByAppendingFormat:@"%@",feelType[dataDict[dict[@"key"]]]];
                }else{
                    valueLabel.text = [@"" stringByAppendingFormat:@"%@",dataDict[dict[@"key"]]];
                }
            }else{
                valueLabel.text = @"---";
            }
        }
    
    }
    cell.mainContainerView.layer.masksToBounds = NO;
    cell.mainContainerView.layer.shadowColor = [Utility colorWithHexString:@"#2e312d"].CGColor;
    cell.mainContainerView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    cell.mainContainerView.layer.shadowOpacity = 0.4f;
    cell.mainContainerView.layer.shadowRadius = 5;
    cell.mainContainerView.layer.cornerRadius = 10;
    
    cell.compareEdit.tag = indexPath.row;
    cell.compareDelete.tag = indexPath.row;
    [cell.compareEdit addTarget:self action:@selector(editButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
    [cell.compareDelete addTarget:self action:@selector(deleteButtonPressed:)forControlEvents:UIControlEventTouchUpInside];
    

    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(compareResultData.count>0){
        if(indexPath.row == compareResultData.count-1){
            pageNumber=pageNumber+1;
            [self filter:selectedIndex];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
