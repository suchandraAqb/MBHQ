//
//  SessionListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SessionListViewController.h"
#import "SessionListTableViewCell.h"
#import "CreateSessionViewController.h"     //ah 4.5
#import "EditExerciseSessionViewController.h"

@interface SessionListViewController (){
//    IBOutlet UIButton *mySessionButton;     //ah 4.5
    IBOutlet UIButton *sessionListButton;
    IBOutlet UITableView *table;
    IBOutlet UIImageView *buttonBg;
    IBOutlet UITextField *searchTextField;
    NSMutableArray *sessionListArray;
    NSArray *fetchListArray;
    UIView *contentView;
    NSMutableDictionary *defaultFilterDictionary;
    
    IBOutlet UIButton *allButton;
    IBOutlet UIButton *hiitButton;
    IBOutlet UIButton *pilatesButton;
    IBOutlet UIButton *yogaButton;
    IBOutlet UIButton *cardoButton;
    IBOutlet UIButton *weightButton;
    IBOutlet UIView *typeView;
    IBOutlet UIButton *viewButton;
    IBOutlet UILabel *nodataLabel;
    IBOutlet UIButton *advanceSearchButton;
    IBOutlet UIButton *myfavButton;
    
    __weak IBOutlet UILabel *sessionListHeader;
    NSMutableArray *predicateList;
    NSMutableArray *myFavArray;
    IBOutlet UIView *searchView;
    BOOL isAllSelect;
    int apiCount;//add5
    NSMutableArray *favouriteArray;//add5
    BOOL isFirstTime;   //ah 5.5
    BOOL isFromDone;//add_new
    int pageNumber;
    NSArray *typeArr;
    int selectedIndex;
    BOOL ismyfav;
    BOOL isChanged;
    
    __weak IBOutlet UIView *lodeMoreView;
    NSDictionary *currentSavedFilter;
    
    __weak IBOutlet UIView *animationView;
    __weak IBOutlet UIImageView *animationImage;
    __weak IBOutlet UILabel *msgLabel;
}

@end

@implementation SessionListViewController
@synthesize mySessionButton,delegate;    //ah 4.5

#pragma -mark APICall
-(void)advanceSearch:(NSDictionary *)dict{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            //self->contentView = [Utility activityIndicatorView:self];
            
            self->animationView.hidden = false;
            [self.view bringSubviewToFront:self->animationView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:dict];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithBool:false] forKey:@"OnlyAbbbcOnline"];
        [mainDict setObject:[NSNumber numberWithBool:true] forKey:@"OnlySquad"];
        [mainDict setObject:[NSNumber numberWithInt:pageNumber] forKey:@"PageIndex"];
//        if (![Utility isEmptyCheck:mainDict[@"IncludeExerciseTags"]] || ![Utility isEmptyCheck:mainDict[@"ExcludeExerciseTags"]]) {
//            [mainDict setObject:[NSNumber numberWithInt:10000] forKey:@"PageSize"];
//        } else {
//            [mainDict setObject:[NSNumber numberWithInt:20] forKey:@"PageSize"];
//        }
        [mainDict setObject:[NSNumber numberWithInt:20] forKey:@"PageSize"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SearchExerciseSessionsApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if (self->apiCount == 0) {
                                                                     self->animationView.hidden = true;
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSArray *tempArray = [responseDict objectForKey:@"Sessions"];
                                                                         if (![Utility isEmptyCheck:tempArray] && tempArray.count>0) {
                                                                             
                                                                             [self->sessionListArray addObjectsFromArray: tempArray];
                                                                             if (self->apiCount == 0) {
                                                                                 [self->table reloadData];
                                                                             }
                                                                             self->lodeMoreView.hidden = false;
                                                                         }else{
                                                                             if ([Utility isEmptyCheck:self->sessionListArray]) {
                                                                                 
                                                                                 [self->table reloadData];
                                                                                 self->lodeMoreView.hidden = true;
                                                                             }
                                                                         }
                                                                       
                                                                     }
                                                                     else{
                                                                         self->pageNumber = self->pageNumber - 1;//New_chng
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     self->pageNumber = self->pageNumber - 1; //New_chng
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

-(void)webserviceCall_GetFavoriteSessionList{ //add5
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            if (self->animationView.isHidden) {
                self->contentView = [Utility activityIndicatorView:self];
            }
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFavoriteSessionList" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if (self->apiCount == 0) {
                                                                     self->animationView.hidden = true;
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                             self->favouriteArray = [responseDict objectForKey:@"FavoriteSessionList"];
                                                                         if (self->apiCount == 0) {//add_new
                                                                             if (!self->isFromDone) {
                                                                                 if (self->ismyfav) {
                                                                                     NSArray *filterarray = [self->favouriteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavorite == true)"]];
//                                                                                     NSArray *newSessionArray = [sessionListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ExerciseSessionId IN %@", [filterarray valueForKey:@"SessionId"]]];
//                                                                                     if (myFavArray.count>0) {
//                                                                                         [myFavArray removeAllObjects];
//                                                                                     }
                                                                                     self->myFavArray = [filterarray valueForKey:@"WorkoutObject"];
                                                                                     
                                                                                 }
                                                                                     [self->table reloadData];
                                                                                 
                                                                                 
                                                                             }else{
                                                                                 self->pageNumber = 0;
                                                                                 
                                                                                 if(!self->sessionListArray){
                                                                                     self->sessionListArray = [NSMutableArray new];
                                                                                 }else{
                                                                                     [self->sessionListArray removeAllObjects];
                                                                                 }
                                                                                 
                                                                                 [self->table reloadData];
                                                                                 [self advanceSearch:self->defaultFilterDictionary];
                                                                             }//
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

-(void)webserviceCall_CountSessionDone:(NSDictionary*)dict{ //add5
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ExerciseSessionId"] forKey:@"SessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"CountSessionDone" append:@""forAction:@"POST"];
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
                                                                         [self webserviceCall_GetFavoriteSessionList];
                                                                         [self updateSessionlistArray:dict isFromFav:NO isFromDone:YES];
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
-(void)webserviceCall_FavoriteSessionToggle:(NSDictionary*)dict{ //add5
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ExerciseSessionId"] forKey:@"SessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"FavoriteSessionToggle" append:@""forAction:@"POST"];
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
                                                                         [self webserviceCall_GetFavoriteSessionList];
                                                                         [self updateSessionlistArray:dict isFromFav:YES isFromDone:NO];
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

-(void)webserviceCall_SubmitWorkout:(NSDictionary*)dict{ //add5
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[dict objectForKey:@"ExerciseSessionId"] forKey:@"ExerciseSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SubmitWorkout" append:@""forAction:@"POST"];
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
                                                                         [Utility msg:@"Your workout has been submitted and will be reviewed by our team soon." title:@"Success" controller:self haveToPop:NO];
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
-(IBAction)doneButtonPressed:(UIButton*)sender{ //add5
//    isFromDone=true;//add_new
//    advanceSearchButton.selected = false;
    NSDictionary *dict = [sessionListArray objectAtIndex:sender.tag];
    [self webserviceCall_CountSessionDone:dict];
}
-(IBAction)favButtonPressed:(UIButton*)sender{ //add5
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    NSDictionary *dict;
    if (ismyfav) {
        dict = [myFavArray objectAtIndex:sender.tag];
    }else{
        dict = [sessionListArray objectAtIndex:sender.tag];
    }
    [self webserviceCall_FavoriteSessionToggle:dict];
}
-(IBAction)checkUncheckTickPressed:(UIButton*)sender{
//     isFromDone=true;//add_new
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    NSDictionary *dict;
    if (ismyfav) {
        dict = [myFavArray objectAtIndex:sender.tag];
    }else{
        dict = [sessionListArray objectAtIndex:sender.tag];
    }
    [self webserviceCall_CountSessionDone:dict];
}
-(IBAction)myFabouriteButtonPressed:(id)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (ismyfav) {
        ismyfav = false;
        myfavButton.selected = false;
        [myfavButton setBackgroundColor:[UIColor whiteColor]];
//        advanceSearchButton.selected = false;
        
        if ([Utility isEmptyCheck:sessionListArray]) {
            nodataLabel.text = @"NO SESSION FOUND";
            nodataLabel.hidden = false;
            lodeMoreView.hidden = true;
        }else{
            nodataLabel.text=@"";
            nodataLabel.hidden = true;
            lodeMoreView.hidden = false;
        }
    }else{
        lodeMoreView.hidden = true;
//        advanceSearchButton.selected = false;/Users/home/Documents/iphonesource/ABBBC_APS/Squad_Project/Squad_Split/Squad/inactive_heart@2x.png/Users/home/Documents/iphonesource/ABBBC_APS/Squad_Project/Squad_Split/Squad/inactive_heart@3x.png
        myfavButton.selected = true;
        [myfavButton setBackgroundColor:squadMainColor];
        ismyfav = true;
//        NSArray *filterarray = [favouriteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavorite == true)"]];
////        NSArray *newSessionArray = [sessionListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"ExerciseSessionId IN %@", [filterarray valueForKey:@"SessionId"]]];
////        if (myFavArray.count>0) {
////            [myFavArray removeAllObjects];
////        }
//        myFavArray = [filterarray valueForKey:@"WorkoutObject"];
        
        NSArray *workoutDetailsFavArr = [favouriteArray valueForKey:@"WorkoutObject"];
        NSArray *filterarray = [workoutDetailsFavArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsFavourite == true)"]];
        if (![Utility isEmptyCheck:filterarray]) {
            myFavArray = [filterarray mutableCopy];
        }
        
        if ([Utility isEmptyCheck:myFavArray]) {
            nodataLabel.hidden = false;
            nodataLabel.text = @"NO FAVOURITE SESSION FOUND";
        }else{
            nodataLabel.text=@"";
            nodataLabel.hidden = true;
        }
    }
    [table reloadData];

}
-(IBAction)viewButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:true];
        self->myfavButton.selected = false;
        [myfavButton setBackgroundColor:[UIColor whiteColor]];
//        self->advanceSearchButton.selected = false;
        
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = self->typeArr;
        controller.apiType = @"Session";
        if (self->selectedIndex>0) {
            controller.selectedIndex = self->selectedIndex;
        }else{
            controller.selectedIndex = 0;
        }
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });

}
-(IBAction)submitButtonPressed:(UIButton*)sender{ //add5
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:table];
    NSIndexPath *indexPath = [table indexPathForRowAtPoint:buttonPosition];
    SessionListTableViewCell *cell = (SessionListTableViewCell *)[table cellForRowAtIndexPath:indexPath];
    
    NSDictionary *dict = [sessionListArray objectAtIndex:sender.tag];
    
    //add8
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Alert"
                                 message:@"Do you want to submit?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    [cell.submitButton setTitle:@"ReSubmit" forState:UIControlStateNormal];
                                    [self webserviceCall_SubmitWorkout:dict];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                                   [cell.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(IBAction)AdvanceSearchButtonPressed:(id)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
//        self->advanceSearchButton.selected = true;
        self->myfavButton.selected = false;
        [myfavButton setBackgroundColor:[UIColor whiteColor]];
        self->ismyfav = false;
        AdvanceSearchForSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearchForSessionViewController"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.savedFilter = [self->currentSavedFilter mutableCopy];
        controller.delegate = self;
        controller.isFromSessionList = true;
        [self.navigationController pushViewController:controller animated:YES];
//        [self presentViewController:controller animated:YES completion:nil];
    });
}
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
-(IBAction)sessionOrMysessionListButtonPressed:(UIButton *)sender{
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] && (sender ==  mySessionButton)){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    if (sender == sessionListButton) {
        sessionListButton.selected = true;
        mySessionButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
       // [defaultFilterDictionary removeObjectForKey:@"Category"]; chnage1
        [defaultFilterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];//add1
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
        
        hiitButton.selected=true;
        pilatesButton.selected=false;
        yogaButton.selected=false;
        cardoButton.selected=false;
        weightButton.selected=false;
        allButton.selected=false;


    }else{
        
        mySessionButton.selected = true;
        sessionListButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar_flip.png"];
        [defaultFilterDictionary setObject:[NSNumber numberWithInt:4] forKey:@"Category"];
        hiitButton.selected=true;
        pilatesButton.selected=true;
        yogaButton.selected=true;
        cardoButton.selected=true;
        weightButton.selected=false;
        allButton.selected=false;
        
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];

    }
    pageNumber = 0;
    if(!sessionListArray){
        sessionListArray = [NSMutableArray new];
    }else{
        [sessionListArray removeAllObjects];
    }
    [table reloadData];
    [self advanceSearch:defaultFilterDictionary];
    
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
-(IBAction)createNewButtonTapped:(id)sender {   //ah 4.5(no main storyboard)
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    CreateSessionViewController *controller = [[UIStoryboard storyboardWithName:@"TrainDailyWorkoutCustomSession" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateSession"];
    controller.presentingVC = self;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)editSessionButtonTapped:(UIButton *)sender {
    //EditExerciseSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        [Utility showTrailLoginAlert:self ofType:self];
        return;
    }
    EditExerciseSessionViewController *controller = [[UIStoryboard storyboardWithName:@"TrainDailyWorkoutCustomSession" bundle:nil]instantiateViewControllerWithIdentifier:@"EditExerciseSession"];
    controller.exSessionId = (int)sender.tag;
    controller.dt = @"";
    controller.fromController = @"listEdit";
    controller.presentingVC = self;
    
    [self setDefinesPresentationContext:YES];
    [self presentViewController:controller animated:YES completion:nil];
    
    //[self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)loadMorePressed:(UIButton *)sender {
    if (ismyfav == false) {
        if(![Utility isEmptyCheck:sessionListArray] && sessionListArray.count>0){
//            if(indexPath.row == sessionListArray.count-1){
                pageNumber=pageNumber+1;
                [self advanceSearch:defaultFilterDictionary];
//            }
        }
    }
}
#pragma -mark End

#pragma mark - Private function

-(void)sessionListCheck{
    isAllSelect =true;
    
    if (allButton.selected) {
        
        hiitButton.selected=true;
        pilatesButton.selected=true;
        yogaButton.selected=true;
        cardoButton.selected=true;
        weightButton.selected=true;
        allButton.selected=true;
        
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Weights"];
    }else{
        if (hiitButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_HIIT"];
        }
        if (pilatesButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
        }
        if (yogaButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
        }
        if (cardoButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
        }
        if (weightButton.selected) {
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Weights"];
        }else{
            isAllSelect=false;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
        }
        if (isAllSelect) {
            allButton.selected=true;
        }
    }
    pageNumber = 0;
    if(!sessionListArray){
        sessionListArray = [NSMutableArray new];
    }else{
        [sessionListArray removeAllObjects];
    }
    [table reloadData];
    [self advanceSearch:defaultFilterDictionary];
}

-(void)updateSessionlistArray:(NSDictionary *)dict isFromFav:(BOOL)isFav isFromDone:(BOOL)isDone{
    
    NSLog(@"Update Dict:=>%@",dict);
    
    if(![Utility isEmptyCheck:sessionListArray] && ![Utility isEmptyCheck:dict]){
        int sessionId = [dict[@"ExerciseSessionId"] intValue];
        NSArray *filterarray = [sessionListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ExerciseSessionId == %d)", sessionId]];
        if(![Utility isEmptyCheck:filterarray]){
            NSMutableDictionary *sessionDict = [[NSMutableDictionary alloc]initWithDictionary:[filterarray firstObject]];
            NSUInteger index = [sessionListArray indexOfObject:sessionDict];
            
            if(isFav){
                BOOL currentFav = [sessionDict[@"IsFavourite"] boolValue];
                currentFav = !currentFav;
                [sessionDict setObject:[NSNumber numberWithBool:currentFav] forKey:@"IsFavourite"];
            }
            
            if(isDone){
                int currentDone = [sessionDict[@"DoneCount"] intValue];
                currentDone +=1;
                
                [sessionDict setObject:[NSNumber numberWithInt:currentDone] forKey:@"DoneCount"];
            }
            
            [sessionListArray replaceObjectAtIndex:index withObject:sessionDict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->table reloadData];
            });
        }
    }
}

#pragma mark - End

#pragma -mark View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    sessionListButton.selected = false;
    mySessionButton.selected=true;
    
    table.estimatedRowHeight = 60;
    table.rowHeight = UITableViewAutomaticDimension;
    defaultFilterDictionary = [[NSMutableDictionary alloc]init];
    searchView.layer.borderColor = [Utility colorWithHexString:@"929497"].CGColor;
    searchView.layer.borderWidth = 1.12;
    myfavButton.layer.borderColor = squadMainColor.CGColor;
    myfavButton.layer.borderWidth = 1.0f;
    myfavButton.clipsToBounds = YES;
    myfavButton.layer.cornerRadius = 15.0;
    
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    [defaultFilterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    if (![Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"]){
        sessionListButton.selected = true;
        mySessionButton.selected = false;
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar.png"];
        // [defaultFilterDictionary removeObjectForKey:@"Category"]; chnage1
//        [defaultFilterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];//add1
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
        
        hiitButton.selected=true;
        pilatesButton.selected=false;
        yogaButton.selected=false;
        cardoButton.selected=false;
        weightButton.selected=false;
        allButton.selected=false;
    }else{
        buttonBg.image = [UIImage imageNamed:@"sq_tab_bar_flip.png"];

        // [defaultFilterDictionary removeObjectForKey:@"Category"];change1
//        [defaultFilterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];
        
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
        [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Weights"];//false
        
        hiitButton.selected=true;
        pilatesButton.selected=true;
        yogaButton.selected=true;
        cardoButton.selected=true;
        weightButton.selected=false;
        allButton.selected=false;
    }
    [defaultFilterDictionary setObject:@"" forKey:@"Duration"];
    [defaultFilterDictionary setObject:[NSNumber numberWithInt:0] forKey:@"SessionType"];
    myFavArray = [[NSMutableArray alloc]init];
//    favouriteArray = [[NSMutableArray alloc]init];
    typeView.layer.borderColor = squadMainColor.CGColor;
    typeView.layer.borderWidth = 1;
    lodeMoreView.layer.borderColor = squadMainColor.CGColor;
    lodeMoreView.layer.borderWidth = 1;
    lodeMoreView.layer.masksToBounds = YES;
    lodeMoreView.layer.cornerRadius = 15.0;
    isFromDone=false;//add_new
    ismyfav = false;
    typeArr = [[NSArray alloc]initWithObjects:@"ALL",@"HIIT",@"PILATES",@"YOGA",@"CARDO",@"WEIGHT", nil];
    [viewButton setTitle:[@"" stringByAppendingFormat:@"VIEWING : %@",[typeArr objectAtIndex:0]] forState:UIControlStateNormal];
    predicateList = [[NSMutableArray alloc]init];
    apiCount= 0;//add5
    isChanged = true;
    lodeMoreView.hidden = true;
    isFirstTime = true;
    
    if(_isFromAddEditSession){
        sessionListHeader.text = @"SELECT A SESSION";
    }else{
        sessionListHeader.text = @"SESSION LIST";
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Hey %@,\n%@\nHold tight, we're just finding your sessions.",[defaults objectForKey:@"FirstName"],@"Remember, if you still look cute after a workout you haven't worked hard enough!"]];
    NSRange foundRange = [text.mutableString rangeOfString:@"Remember, if you still look cute after a workout you haven't worked hard enough!"];
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Oswald-Light" size:20.0],
                               NSForegroundColorAttributeName : [UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]
                               
                               };
    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
    [text addAttributes:@{
                          NSFontAttributeName : [UIFont fontWithName:@"Oswald-Bold" size:30.0]
                          
                          }
                  range:foundRange];
    
    msgLabel.attributedText = text;
    animationImage.image = [UIImage animatedImageNamed:@"animation-" duration:1.0f];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];

    if (!isChanged) {
        isChanged = YES;
        return;
    }
    if (isFirstTime) {
        isFirstTime = false;
//        self->advanceSearchButton.selected = true;
//        self->myfavButton.selected = false;
//        self->ismyfav = false;
        AdvanceSearchForSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdvanceSearchForSessionViewController"];
        controller.isMySession = _isMySessionSelected;
        controller.delegate = self;
        controller.isFromSessionList = true;
        [self.navigationController pushViewController:controller animated:NO];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//add5
        self->pageNumber = 0;
        if(!self->sessionListArray){
           self->sessionListArray = [NSMutableArray new];
        }else{
            [self->sessionListArray removeAllObjects];
        }
        
        [self advanceSearch:self->defaultFilterDictionary];
        [self webserviceCall_GetFavoriteSessionList];
        
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->table reloadData];
    });
    
    
    nodataLabel.hidden = true;
}// AY 04042018
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    
}
-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
            if (!isAllTaskCompleted ){
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
//                TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
//                GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                AchievementsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Achievements"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:@"Do you want to continue searching ?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self AdvanceSearchButtonPressed:0];
                                                              }];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }];
        [alert addAction:noAction];
        [alert addAction:yesAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
#pragma -mark End



#pragma mark - TableView Datasource & Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (ismyfav) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!self->myFavArray.count){
                self->nodataLabel.hidden = false;
                self->nodataLabel.text = @"NO FAVOURITE SESSION FOUND";
                [self->table setHidden:YES];
            }else{
                self->nodataLabel.hidden = true;
                [self->table setHidden:NO];
            }
        });
        return myFavArray.count;
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!self->sessionListArray.count){
                self->nodataLabel.hidden = false;
                self->nodataLabel.text = @"NO SESSION FOUND";
                [self->table setHidden:YES];
            }else{
                self->nodataLabel.hidden = true;
                [self->table setHidden:NO];
            }
        });
        
        
        
        return sessionListArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"SessionListTableViewCell";
    SessionListTableViewCell *cell = (SessionListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[SessionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.shadowView.layer.masksToBounds = NO;
    cell.shadowView.layer.shadowColor = [Utility colorWithHexString:@"2e312d"].CGColor;
    cell.shadowView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    cell.shadowView.layer.shadowOpacity = 0.4f;
    cell.shadowView.layer.shadowRadius = 5;
    
    cell.doneButton.layer.borderColor = [Utility colorWithHexString:@"004050"].CGColor;
    cell.doneButton.layer.borderWidth=1;
    
    cell.submitButton.layer.borderColor = [Utility colorWithHexString:@"004050"].CGColor;
    cell.submitButton.layer.borderWidth=1;
    
    cell.doneCount.layer.borderColor=[Utility colorWithHexString:@"b8b8b8"].CGColor;
    cell.doneCount.layer.borderWidth=1;
    
    if (mySessionButton.selected) {
        cell.submitButton.hidden=false;
    }else{
        cell.submitButton.hidden=true;
    }
    NSDictionary *dict;
 
    if (ismyfav) {
        if (![Utility isEmptyCheck:myFavArray]) {
            dict = [myFavArray objectAtIndex:indexPath.row];
        }
    }else{
        if (![Utility isEmptyCheck:sessionListArray]) {
            dict = [sessionListArray objectAtIndex:indexPath.row];
        }
    }
    if (![Utility isEmptyCheck:dict]) {
        cell.sessionName.text= ![Utility isEmptyCheck:[dict objectForKey:@"SessionTitle"]] ? [dict objectForKey:@"SessionTitle"]:@"";
        cell.doneButton.tag = indexPath.row;
        cell.favButton.tag=indexPath.row;
        cell.submitButton.tag=indexPath.row;
        cell.checkUncheckTickButton.tag = indexPath.row;
//        int sessionId = [[dict objectForKey:@"ExerciseSessionId"]intValue];
        
        NSString *txt = ![Utility isEmptyCheck:dict[@"Duration"]]?dict[@"Duration"]:@"0";
        cell.sessionTime.text = [NSString stringWithFormat:@"%@ MIN",txt];
        [cell.workoutType setTitle:![Utility isEmptyCheck:dict[@"WorkoutType"]]?[NSString stringWithFormat:@"%@",dict[@"WorkoutType"]]:@"" forState:UIControlStateNormal];
        [cell.bodyType setTitle:![Utility isEmptyCheck:dict[@"BodyArea"]]?[NSString stringWithFormat:@"%@,",dict[@"BodyArea"]]:@"" forState:UIControlStateNormal];
        
        NSString *bodyArea = [@"" stringByAppendingFormat:@"%@",dict[@"BodyArea"]];
        if ([bodyArea isEqualToString:@"LowerBody"]) {
            cell.bodyImage.image = [UIImage imageNamed:@"lower_body.png"];
        } else if ([bodyArea isEqualToString:@"FullBody"]) {
            cell.bodyImage.image = [UIImage imageNamed:@"full_body.png"];
        } else if ([bodyArea isEqualToString:@"UpperBody"]) {
            cell.bodyImage.image = [UIImage imageNamed:@"upper_body.png"];
        } else  {
            cell.bodyImage.image = [UIImage imageNamed:@"full_body.png"];
        }
        
        if (cell.workoutType.currentTitle.length == 0) {
            cell.workoutType.hidden = true;
        }else{
            cell.workoutType.hidden = false;
        }
        if (cell.bodyType.currentTitle.length == 0) {
            cell.bodyType.hidden = true;
        }else{
            cell.bodyType.hidden = false;
        }
        
        if ([[dict objectForKey:@"IsFavourite"]boolValue]) {
            cell.favButton.selected=true;
        }else{
            cell.favButton.selected=false;
        }
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"DoneCount"]]) {
            int sessionCount = [[dict objectForKey:@"DoneCount"]intValue];
            if (sessionCount>0) {
                cell.checkUncheckTickButton.selected = true;
                cell.checkUncheckTickButton.userInteractionEnabled = false;
            }else{
                cell.checkUncheckTickButton.selected = false;
                cell.checkUncheckTickButton.userInteractionEnabled = true;
            }
        }
        
//        NSArray *filterarray = [favouriteArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(SessionId == %d)", sessionId]];
//
//        NSLog(@"%@",filterarray);
//        if (![Utility isEmptyCheck:filterarray]) {
//            NSDictionary *filterDict = [filterarray objectAtIndex:0];
//            if ([[filterDict objectForKey:@"IsFavorite"]boolValue]) {
//                cell.favButton.selected=true;
//            }else{
//                cell.favButton.selected=false;
//            }
//            if (![Utility isEmptyCheck:[filterDict objectForKey:@"SessionCount"]]) {
//                int sessionCount = [[filterDict objectForKey:@"SessionCount"]intValue];
//                if (sessionCount>0) {
//                    cell.checkUncheckTickButton.selected = true;
//                }else{
//                    cell.checkUncheckTickButton.selected = false;
//                }
//            }
//        }else{
//            cell.favButton.selected=false;
//            cell.doneCount.text=@"0";
//            cell.checkUncheckTickButton.selected = false;
//        }
        
        if (mySessionButton.selected){
            if ([[dict objectForKey:@"AllowSubmit"]boolValue]) {//add9
                [cell.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
            }else{
                [cell.submitButton setTitle:@"ReSubmit" forState:UIControlStateNormal];
            }
        }
        [cell.editSessionButton setTag:[[dict objectForKey:@"ExerciseSessionId"] integerValue]];
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![Utility isEmptyCheck:[sessionListArray objectAtIndex:indexPath.row]]) {
        NSDictionary *sessionDictionary;// = [sessionListArray objectAtIndex:indexPath.row];
        if (ismyfav) {
            if (![Utility isEmptyCheck:myFavArray]) {
                sessionDictionary = [myFavArray objectAtIndex:indexPath.row];
            }
        }else{
            if (![Utility isEmptyCheck:sessionListArray]) {
                sessionDictionary = [sessionListArray objectAtIndex:indexPath.row];
            }
        }
        if(_isFromAddEditSession){
            if([delegate respondsToSelector:@selector(didSelectSession:)]){
                [delegate didSelectSession:sessionDictionary];
                [self backButtonPressed:0];
            }
            
        }else{
            ExerciseDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ExerciseDetails"];
            controller.exSessionId = [[sessionDictionary objectForKey:@"ExerciseSessionId"] intValue];
            controller.completeSessionId = [[sessionDictionary objectForKey:@"ExerciseSessionId"] intValue]; //AY 04042018
            controller.sessionDate = @"";  //ah 2.2
            controller.fromWhere = @"DailyWorkout";
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
        
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (ismyfav == false) {
//        if(![Utility isEmptyCheck:sessionListArray] && sessionListArray.count>0){
//            if(indexPath.row == sessionListArray.count-1){
//                pageNumber=pageNumber+1;
//                [self advanceSearch:defaultFilterDictionary];
//            }
//        }
//    }
}
#pragma -mark End
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchTextField) {
        [textField resignFirstResponder];
//        advanceSearchButton.selected = false;
        myfavButton.selected = false;
        [myfavButton setBackgroundColor:[UIColor whiteColor]];
        ismyfav = false;
        NSString *searchString = textField.text;
        textField.text = @"";
        [defaultFilterDictionary setObject:searchString forKey:@"SessionName"];
        pageNumber = 0;
        if(!sessionListArray){
            sessionListArray = [NSMutableArray new];
        }else{
            [sessionListArray removeAllObjects];
        }
        [table reloadData];
        [self advanceSearch:defaultFilterDictionary];
        
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
- (void) applyForSesionFilter:(NSDictionary *)data ischange:(BOOL)ischanged{
    NSLog(@"------------%@",data);
    self->isChanged = ischanged;
    pageNumber = 0;
    if(!sessionListArray){
        sessionListArray = [NSMutableArray new];
    }else{
        [sessionListArray removeAllObjects];
    }
    [table reloadData];
    if (![Utility isEmptyCheck:defaultFilterDictionary]) {
        [defaultFilterDictionary removeAllObjects];
    }
    defaultFilterDictionary = [data mutableCopy];
    currentSavedFilter = data;
    [self advanceSearch:defaultFilterDictionary];
}

-(void)dismissFromAdvanceSearch:(BOOL)ischanged{
    self->isChanged = ischanged;
//    advanceSearchButton.selected = false;
    if ([Utility isEmptyCheck:sessionListArray]) {
        nodataLabel.text = @"NO SESSION FOUND";
        nodataLabel.hidden = false;
    }else{
        nodataLabel.text=@"";
        nodataLabel.hidden = true;
    }
    if ([Utility isEmptyCheck:myFavArray]) {
        nodataLabel.hidden = false;
        nodataLabel.text = @"NO FAVOURITE SESSION FOUND";
    }else{
        nodataLabel.text=@"";
        nodataLabel.hidden = true;
    }
    [table reloadData];
}

-(void)isGotoHome:(BOOL)isBack{
    if(isBack)[self backButtonPressed:0];
}
#pragma -mark End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - Dropdown Deegate
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if ([type isEqualToString:@"Session"]) {
        [viewButton setTitle:[@"" stringByAppendingFormat:@"VIEWING : %@",selectedValue] forState:UIControlStateNormal];
        if (![Utility isEmptyCheck:defaultFilterDictionary]) {
            [defaultFilterDictionary removeObjectForKey:@"SessionName"];
        }
        if ([selectedValue isEqualToString:@"ALL"]) {
            selectedIndex = 0;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Weights"];

        }else if ([selectedValue isEqualToString:@"HIIT"]){
            selectedIndex = 1;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
            
        }else if ([selectedValue isEqualToString:@"PILATES"]){
            selectedIndex= 2;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
        }else if ([selectedValue isEqualToString:@"YOGA"]){
            selectedIndex = 3;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
            
        }else if ([selectedValue isEqualToString:@"CARDO"]){
            selectedIndex = 4;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Weights"];
        }else{
            selectedIndex = 5;
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_HIIT"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Pilates"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Yoga"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:false] forKey:@"SessionType_Cardio"];
            [defaultFilterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SessionType_Weights"];
        }
        pageNumber = 0;
        ismyfav = false;
        if(!sessionListArray){
            sessionListArray = [NSMutableArray new];
        }else{
            [sessionListArray removeAllObjects];
        }
        [table reloadData];
        [self advanceSearch:defaultFilterDictionary];
    }
}
#pragma mark - ExerciseDetailsDelegate
-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
@end
