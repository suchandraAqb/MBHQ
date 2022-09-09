//
//  SelectCountyCityViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 02/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SelectCountyCityViewController.h"
#import "PreSignUpViewController.h"
#import "ConnectViewController.h"


@interface SelectCountyCityViewController (){
    IBOutlet UIButton *countryButton;
    IBOutlet UIButton *stateButton;
    IBOutlet UIButton *cityButton;
    IBOutlet UIButton *suburbButton;
    IBOutlet UIButton *saveButton;
    
    IBOutlet UIView *stateContainer;
    IBOutlet UIView *cityContainer;
    IBOutlet UIView *suburbContainer;
    
    int apiCount;
    UIView *contentView;
    NSArray *countryArray;
    NSArray *stateArray;
    NSArray *cityArray;
    NSArray *suburbArray;
    NSDictionary *selectedCountry;
    NSString *selectedState;
    NSDictionary *selectedCity;
    NSDictionary *selectedSuburb;
    
    NSDictionary *savedCountryCity;

}

@end

@implementation SelectCountyCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    apiCount = 0;
    savedCountryCity=[defaults dictionaryForKey:@"UserCountryCity"];
    [self getCountry];
}
#pragma mark -IBAction
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)countryButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:countryArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = countryArray;
        controller.mainKey = @"CountryName";
        controller.apiType = @"Country";
        if (![Utility isEmptyCheck:selectedCountry]) {
            controller.selectedIndex = (int)[countryArray indexOfObject:selectedCountry];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)stateButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:stateArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = stateArray;
        controller.apiType = @"State";
        if (![Utility isEmptyCheck:selectedState]) {
            controller.selectedIndex = (int)[stateArray indexOfObject:selectedState];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];

    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)cityButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:cityArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = cityArray;
        controller.mainKey = @"SquadCityName";
        controller.apiType = @"City";
        if (![Utility isEmptyCheck:selectedCity]) {
            controller.selectedIndex = (int)[cityArray indexOfObject:selectedCity];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)suburbButtonPressed:(UIButton *)sender {
    if (![Utility isEmptyCheck:suburbArray]) {
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = suburbArray;
        controller.mainKey = @"SquatSuburbName";
        controller.apiType = @"Suburb";
        if (![Utility isEmptyCheck:selectedSuburb]) {
            controller.selectedIndex = (int)[suburbArray indexOfObject:selectedSuburb];
        }else{
            controller.selectedIndex = -1;
        }
        controller.delegate = self;
        controller.sender = sender;
        [self presentViewController:controller animated:YES completion:nil];
    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}
- (IBAction)saveButtonPressed:(UIButton *)sender {
    if(![Utility isEmptyCheck:countryArray]){
        if (![Utility isEmptyCheck:selectedCountry]) {
            
            [defaults setObject:[Utility replaceDictionaryNullValue:selectedCountry] forKey:@"SelectedCountry"];
        }else{
            [Utility msg:@"Please select Country" title:@"Error !" controller:self haveToPop:NO];
            return;
        }
//        if(![Utility isEmptyCheck:stateArray]){
//            if (![Utility isEmptyCheck:selectedState]) {
//                [defaults setObject:selectedState forKey:@"SelectedState"];
//            }else{
//                [Utility msg:@"Please select State" title:@"Error !" controller:self haveToPop:NO];
//                return;
//            }
//        }
        if(![Utility isEmptyCheck:cityArray]){
            if (![Utility isEmptyCheck:selectedCity]) {
                
                [defaults setObject:[Utility replaceDictionaryNullValue:selectedCity] forKey:@"SelectedCity"];
            }else{
                [Utility msg:@"Please select City" title:@"Error !" controller:self haveToPop:NO];
                return;
            }
        }
        if (![Utility isEmptyCheck:selectedSuburb]) {
            [defaults setObject:[Utility replaceDictionaryNullValue:selectedSuburb] forKey:@"SelectedSuburb"];
        }else{
            [Utility msg:@"Please select Suburb" title:@"Error !" controller:self haveToPop:NO];
            return;
        }

        if ([_fromController caseInsensitiveCompare:@"connect"] == NSOrderedSame) {
            //connect       //ah ux
            [self updateParticipantSuburbApiCall];
            
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            PreSignUpViewController *controller=[storyboard instantiateViewControllerWithIdentifier:@"PreSignUp"];
            [self.navigationController pushViewController:controller animated:YES];
        }

    }else{
        [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
        return;
    }
}

#pragma mark -End
#pragma mark -Private Method
-(NSArray *)deleteBlankElement:(NSArray *)dataArra type:(NSString *)type{
    NSMutableArray *tempArray =dataArra.mutableCopy;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, [NSNumber numberWithInteger:-1]];
    NSArray *filteredSessionCategoryArray = [tempArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        for (NSDictionary *dict in filteredSessionCategoryArray) {
            [tempArray removeObject:dict];
        }
    }
    return tempArray;

}
-(void)updateParticipantSuburbApiCall{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:selectedSuburb[@"SquatSuburbId"] forKey:@"SuburbId"];
        NSLog(@"%@",savedCountryCity);
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateParticipantSuburbApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"Response Data:%@",responseString);
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if ([[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             ConnectViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Connect"];
                                                                             [self.navigationController pushViewController:controller animated:YES];
                                                                         }else{
                                                                             [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops! " controller:self haveToPop:NO];
                                                                             return;
                                                                         }
                                                                     }else{
                                                                         [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}
-(void)getCountry{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadCountriesApiCall" append:@"" forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"CountryName"  ascending:YES];
                                                                         countryArray=[responseArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         countryArray = [self deleteBlankElement:countryArray type:@"CountryID"];
                                                                         if (![Utility isEmptyCheck:savedCountryCity] && ![Utility isEmptyCheck:countryArray]) {
                                                                             NSDictionary *tempSelectedCountry = [Utility getDictByValue:countryArray value:savedCountryCity[@"CountryId"] type:@"CountryID"];
                                                                             if (![Utility isEmptyCheck:tempSelectedCountry] && tempSelectedCountry[@"CountryID"] != [NSNumber numberWithInteger:-1]) {
                                                                                 selectedCountry =tempSelectedCountry;
                                                                                 [countryButton setTitle:[selectedCountry objectForKey:@"CountryName"] forState:UIControlStateNormal];
                                                                                 [self getCity];

                                                                             }else{
                                                                                 selectedCountry = nil;
                                                                             }
                                                                         }else{
                                                                             selectedCountry = nil;
                                                                         }
                                                                         saveButton.hidden= false;
                                                                         countryButton.enabled = true;
                                                                     }else{
                                                                         countryButton.enabled = false;
                                                                         saveButton.hidden = true;
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)getState{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *appendingString = @"";
        if (![Utility isEmptyCheck:selectedCountry]) {
            appendingString =[NSString stringWithFormat:@"?countryId=%@",selectedCountry[@"CountryID"]];
        }else{
            [Utility msg:@"Please select Country." title:@"Oops! " controller:self haveToPop:NO];
            return;
        }
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadStatesApiCall" append:appendingString forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if ([responseArray isKindOfClass:NSArray.class]&&![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         stateArray = [responseArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                                                                         stateContainer.hidden= false;
                                                                         cityContainer.hidden = true;
                                                                         suburbContainer.hidden =true;
                                                                     }else{
                                                                         stateContainer.hidden= true;
                                                                         cityContainer.hidden = true;
                                                                         suburbContainer.hidden =true;
                                                                         [self getCity];
                                                                         //[Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
                                                                         //return;
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

-(void)getCity{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *appendingString = @"";
        if (![Utility isEmptyCheck:selectedCountry]) {
            appendingString =[NSString stringWithFormat:@"?countryId=%@&state=%@",selectedCountry[@"CountryID"],![Utility isEmptyCheck:selectedState] ?selectedState : @""];
        }else{
            [Utility msg:@"Please select Country & State." title:@"Oops! " controller:self haveToPop:NO];
            return;
        }
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadCitiesApiCall" append:appendingString forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if ([responseArray isKindOfClass:NSArray.class]&&![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"SquadCityName"  ascending:YES];
                                                                         cityArray=[responseArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         [self deleteBlankElement:cityArray type:@"SquadCityId"];
                                                                         cityContainer.hidden= false;
                                                                         if (![Utility isEmptyCheck:savedCountryCity] && ![Utility isEmptyCheck:cityArray]) {
                                                                             NSDictionary *tempSelectedCity = [Utility getDictByValue:cityArray value:savedCountryCity[@"CityId"] type:@"SquadCityId"];
                                                                             if (![Utility isEmptyCheck:tempSelectedCity]) {
                                                                                 selectedCity =tempSelectedCity;
                                                                                 [cityButton setTitle:[selectedCity objectForKey:@"SquadCityName"] forState:UIControlStateNormal];
                                                                                 [self getSuburb];
                                                                                 
                                                                             }else{
                                                                                 selectedCity = nil;
                                                                             }
                                                                         }else{
                                                                             selectedCity = nil;
                                                                         }
                                                                     }else{
                                                                         cityContainer.hidden = true;
                                                                         suburbContainer.hidden =true;
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
-(void)getSuburb{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSString *appendingString = @"";
        if (![Utility isEmptyCheck:selectedCity]) {
            appendingString =[NSString stringWithFormat:@"?cityId=%@",selectedCity[@"SquadCityId"]];
        }else{
            [Utility msg:@"Please select City." title:@"Oops! " controller:self haveToPop:NO];
            return;
        }
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetSquadCitySuburbsApiCall" append:appendingString forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 apiCount--;
                                                                 if (apiCount == 0 && contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if ([responseArray isKindOfClass:NSArray.class]&&![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseArray] && responseArray.count > 0) {
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"SquatSuburbName"  ascending:YES];
                                                                         suburbArray=[responseArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         suburbContainer.hidden= false;
                                                                         if (![Utility isEmptyCheck:savedCountryCity] && ![Utility isEmptyCheck:suburbArray]) {
                                                                             NSDictionary *tempSelectedSuburb = [Utility getDictByValue:suburbArray value:savedCountryCity[@"SubrubId"] type:@"SquatSuburbId"];
                                                                             if (![Utility isEmptyCheck:tempSelectedSuburb]) {
                                                                                 selectedSuburb =tempSelectedSuburb;
                                                                                 [suburbButton setTitle:[selectedSuburb objectForKey:@"SquatSuburbName"] forState:UIControlStateNormal];
                                                                                 
                                                                             }else{
                                                                                 selectedSuburb = nil;
                                                                             }
                                                                         }else{
                                                                             selectedSuburb = nil;
                                                                         }
                                                                         NSDictionary *dict = suburbArray[0];
                                                                         if ([Utility isEmptyCheck:dict[@"SquatSuburbName"]] && suburbArray.count == 1) {
                                                                             selectedSuburb = dict;
                                                                             [suburbButton setTitle:@"" forState:UIControlStateNormal];
                                                                             suburbContainer.hidden = true;
                                                                         }else{
                                                                             NSMutableArray *tempArray =suburbArray.mutableCopy;
                                                                             NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",@"SquatSuburbName", @""];
                                                                             NSArray *filteredSessionCategoryArray = [tempArray filteredArrayUsingPredicate:predicate];
                                                                             if (filteredSessionCategoryArray.count > 0) {
                                                                                 for (NSDictionary *dict in filteredSessionCategoryArray) {
                                                                                     [tempArray removeObject:dict];
                                                                                 }
                                                                             }
                                                                             suburbArray= tempArray;
                                                                         }
                                                                     }else{
                                                                         suburbContainer.hidden = true;
                                                                         [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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
#pragma mark -End
#pragma mark -DropdownViewDelegate
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type caseInsensitiveCompare:@"State"] == NSOrderedSame) {
        selectedCity = nil;
        selectedSuburb=nil;
        cityContainer.hidden = true;
        suburbContainer.hidden = true;
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        [cityButton setTitle:@"" forState:UIControlStateNormal];
        [suburbButton setTitle:@"" forState:UIControlStateNormal];

        selectedState = selectedValue;
        [self getCity];

    }
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"Country"] == NSOrderedSame) {
        selectedState = nil;
        selectedCity = nil;
        selectedSuburb=nil;
        stateContainer.hidden = true;
        cityContainer.hidden = true;
        suburbContainer.hidden = true;
        [sender setTitle:[selectedData objectForKey:@"CountryName"] forState:UIControlStateNormal];
        [stateButton setTitle:@"" forState:UIControlStateNormal];
        [cityButton setTitle:@"" forState:UIControlStateNormal];
        [suburbButton setTitle:@"" forState:UIControlStateNormal];
        selectedCountry = selectedData;
        [self getState];
    }else if ([type caseInsensitiveCompare:@"City"] == NSOrderedSame) {
        selectedSuburb=nil;
        suburbContainer.hidden = true;
        [sender setTitle:[selectedData objectForKey:@"SquadCityName"] forState:UIControlStateNormal];
        [suburbButton setTitle:@"" forState:UIControlStateNormal];
        selectedCity = selectedData;
        [self getSuburb];
    }else if ([type caseInsensitiveCompare:@"Suburb"] == NSOrderedSame) {
        [sender setTitle:[selectedData objectForKey:@"SquatSuburbName"] forState:UIControlStateNormal];
        selectedSuburb = selectedData;
    }
}
#pragma mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
