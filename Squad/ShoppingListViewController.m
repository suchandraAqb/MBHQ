//
//  ShoppingListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "Utility.h"
#import "ShoppingListTableViewCell.h"
#import "ShoppingList.h"
#import "OtherShoppingTableViewCell.h"
#import "AddShoppingTableViewCell.h"
#import "CustomNutritionPlanListViewController.h"

static NSString *SectionHeaderViewIdentifierForShoppingList = @"ShoppingList";
static NSString *SectionHeaderViewIdentifier = @"OtherShoppingList";

@interface ShoppingListViewController ()
{
    IBOutlet UITableView *shoppingtable;
    IBOutlet UITableView *addShoppingTable;
    IBOutlet UITableView *otherShoppingTable;
    UIView *contentView;
    NSString *thisWeekMondayString;
    NSDate *thisWeekMonday;

    NSMutableArray *shoppingListArray;
    NSMutableArray *totalcategory;
    IBOutlet UIButton *filterButton;
    int shoppingPref;
    int selectedCategory;
    IBOutlet NSLayoutConstraint *otherShoppingHeaderHeightConstraints;
    IBOutlet NSLayoutConstraint *shoppingtableHeightConstraints;
    IBOutlet NSLayoutConstraint *addShoppingTableHeightConstraints;
    IBOutlet NSLayoutConstraint *otherShoppingTableHeightConstraints;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UILabel *weekDateLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *prevButton;
    IBOutlet UIView *countDownView;
    IBOutlet UILabel *counyDownMsg;
    IBOutlet UILabel *countDownLabel;
    IBOutlet UIButton *serveButton;
    IBOutlet UIButton *saveAllButton;
    NSTimer *countDownTimer;
    
    NSMutableArray *otherListArray;
    UIView *activeTextField;
    NSString *valueString;
    BOOL value;
    NSMutableArray *addshoppingArray;
    NSMutableArray *catagoryarray;
    NSDate *joiningDate;
    int apiCount;
    UIToolbar *toolBar;
    BOOL haveToCallGenerateMeal;
    BOOL isSaved;
    
    NSArray *filterArray;//ss15
    NSString *filtervalue;
    NSMutableArray *saveAll;

    BOOL isChanged;//add_new_7/8/17
    NSDictionary *selectedServe;
    
    __weak IBOutlet UIButton *addToListButton;
    
    __weak IBOutlet UIButton *headerButton;
    __weak IBOutlet UIButton *plusButton;
    __weak IBOutlet UIButton *minusButton;
    
    BOOL isShowCompleted;
    BOOL isShowUntracked;
    
    __weak IBOutlet UIButton *showCompletedButton;
    __weak IBOutlet UIButton *showIngredientButton;
    
    NSArray *initialOtherListArray;
    NSArray *initialShoppingListArray;
    NSString *programName;//SetProgram_In
    NSString *weekNumber;//SetProgram_In
    NSString *UserProgramIdStr;//Today_SetProgram_In
    NSString *ProgramIdStr;//Today_SetProgram_In
    
    NSArray *mealNameList;
    IBOutlet UIView *mealNameView;
    IBOutlet UITableView *mealNameTable;
    
}
@end

@implementation ShoppingListViewController
@synthesize isCustom,weekdate,delegate;
#pragma mark - IBAction

- (IBAction)showCompletedButtonPressed:(UIButton *)sender {
    
    isShowCompleted = !isShowCompleted;
    if(isShowCompleted){
        [sender setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
        [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
        [showCompletedButton setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
    }
    
     dispatch_async(dispatch_get_main_queue(), ^{
       
        [self->shoppingtable reloadData];
        [self->otherShoppingTable reloadData];
     });
}


- (IBAction)showIngredientsButtonPressed:(UIButton *)sender {
    isShowUntracked = !isShowUntracked;
    if(isShowUntracked){
        [sender setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
        [showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"SHOW UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
        [showIngredientButton setTitle:@"SHOW UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [shoppingtable reloadData];
        [otherShoppingTable reloadData];
    });
}


- (IBAction)serveDecreseButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUInteger currentIndex = [serveArray indexOfObject:selectedServe];
        
        if((int)(currentIndex-2) < 0){
            minusButton.enabled = false;
            minusButton.alpha = 0.5;
        }
        
        plusButton.enabled = true;
        plusButton.alpha = 1.0;
        
        selectedServe = serveArray[currentIndex-1];
       
            [serveButton setTitle:selectedServe[@"value"] forState:UIControlStateNormal];
            [shoppingtable reloadData];
            [otherShoppingTable reloadData];
    });
}

- (IBAction)serveIncreaseButtonPressed:(UIButton *)sender {
   dispatch_async(dispatch_get_main_queue(), ^{
    NSUInteger currentIndex = [serveArray indexOfObject:selectedServe];
    
    if(currentIndex+2 >9){
        plusButton.enabled = false;
        plusButton.alpha = 0.5;
    }
    
    minusButton.enabled = true;
    minusButton.alpha = 1.0;
    
    selectedServe = serveArray[currentIndex+1];
    
        [serveButton setTitle:selectedServe[@"value"] forState:UIControlStateNormal];
        [shoppingtable reloadData];
        [otherShoppingTable reloadData];
    });
}

-(IBAction)serveDropdownButtonPressed:(id)sender{
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = serveArray;
    controller.mainKey = @"value";
    controller.apiType = @"Serve";
    if (![Utility isEmptyCheck:selectedServe]) {
        controller.selectedIndex = (int)[serveArray indexOfObject:selectedServe];
    }else{
        controller.selectedIndex = -1;
    }
    controller.delegate = self;
    controller.sender = sender;
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)keyBoardDoneButtonClicked:(id)sender{
    [self.view endEditing:true];
}
-(IBAction)homeButtonPressed:(UIButton*)sender{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            isChanged = false;
            saveAll = [[NSMutableArray alloc]init];
             [self changeSaveButton:YES];
            if(([Utility isSubscribedUser] && [Utility isOfflineMode]) || [Utility isSquadLiteUser] || [Utility isSquadFreeUser]) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                BOOL isAllTaskCompleted = [defaults boolForKey:@"CompletedStartupChecklist"];
                if (!isAllTaskCompleted ){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
//                    TodayHomeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"TodayHome"];
                    GratitudeListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"GratitudeListView"];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }
        }
    }];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}

-(IBAction)backButtonPressed:(id)sender{
   // [self.navigationController popViewControllerAnimated:YES];
    //add_new_7/8/17
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            isChanged = false;
            saveAll = [[NSMutableArray alloc]init];
             [self changeSaveButton:YES];
            [self.navigationController  popViewControllerAnimated:YES];
        }
    }];
}

-(IBAction)saveButtonPressed:(UIButton*)sender{
    if ([self formValidation]) {
        isChanged =false; //add_new_7/8/17
        [self webServiceCall_AddSquadShoppingList:addshoppingArray];
    }
}

-(IBAction)prevButtonPressed:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            isShowCompleted = true;
            isShowUntracked = true;
            [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
            [showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
            isChanged = false;
            saveAll = [[NSMutableArray alloc]init];
             [self changeSaveButton:YES];
            NSTimeInterval prevsevenDay = -7*24*60*60;
            weekdate = [weekdate
                        dateByAddingTimeInterval:prevsevenDay];
            NSLog(@"Prev-%@",weekdate);
            apiCount =0;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            thisWeekMondayString = [formatter stringFromDate:weekdate];
            if (![Utility isEmptyCheck:thisWeekMondayString]) {
                haveToCallGenerateMeal = YES;
                if (isCustom) {
                    [self getSquadCustomShoppingListSettings];
                }else{
                    [self getShoppinglistDataWithSettings];
                }
            }
            //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //        [formatter setDateFormat:@"dd-MM-yyyy"];
            //        NSString *prevDatestring= [formatter stringFromDate:weekdate];
            //        weekDateLabel.text = [@"Week - " stringByAppendingFormat:@"%@",prevDatestring ];
        }
    }];

}



-(IBAction)nextButtonPressed:(id)sender{
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            isShowCompleted = true;
            isShowUntracked = true;
            [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
            [showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
            isChanged = false;
            saveAll = [[NSMutableArray alloc]init];
            [self changeSaveButton:YES];
            NSTimeInterval nextSevenDay = 7*24*60*60;
            weekdate = [weekdate
                        dateByAddingTimeInterval:nextSevenDay];
            NSLog(@"Next-%@",weekdate);
            apiCount =0;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            thisWeekMondayString = [formatter stringFromDate:weekdate];
            
            if (![Utility isEmptyCheck:thisWeekMondayString]) {
                haveToCallGenerateMeal = YES;
                if (isCustom) {
                    [self getSquadCustomShoppingListSettings];
                }else{
                    [self getShoppinglistDataWithSettings];
                }
            }
        }
    }];
    
}

-(IBAction)cancelButtonPressed:(id)sender{
    
    //addShoppingTableHeightConstraints.constant = 0;
    [addshoppingArray removeAllObjects];
    [self.view setNeedsUpdateConstraints];
//    isSaved=true;
    isChanged = false;//add_new_7/8/17
    [addShoppingTable reloadData];
    
}

-(IBAction)addShoppingButtonPressed:(id)sender{
        [activeTextField resignFirstResponder];
    
        if(addShoppingTable.isHidden){
            addShoppingTable.hidden = false;
        }
    
        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
        [dict setObject:@"" forKey:@"Category"];
        [dict setObject:@"" forKey:@"Name"];
        [dict setObject:@"" forKey:@"ItemQuantity"];
    
        if (addshoppingArray.count==0) {
            addshoppingArray=[[NSMutableArray alloc]init];
            [addshoppingArray addObject:dict];
        }
        [self.view setNeedsUpdateConstraints];
        isSaved=true;
        [addShoppingTable reloadData];
}

-(IBAction)itemButtonPressed:(UIButton*)sender{
    /*CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:shoppingtable];
    NSIndexPath *indexPath = [shoppingtable indexPathForRowAtPoint:buttonPosition];
    ShoppingListTableViewCell *cell = (ShoppingListTableViewCell *)[shoppingtable cellForRowAtIndexPath:indexPath];
    if([sender isEqual:cell.purchasedButton] ){
        cell.purchasedButton.selected = !cell.purchasedButton.isSelected;
    }else if([sender isEqual:cell.alreadyhaveItButton] ){
        cell.alreadyhaveItButton.selected = !cell.alreadyhaveItButton.isSelected;
    }*/
    
    NSString *sectionIndexString = [@"" stringByAppendingFormat:@"%@",sender.accessibilityHint];
    NSArray *SectionDetails = [sectionIndexString componentsSeparatedByString: @"-"];
    NSString *sectionString = [SectionDetails objectAtIndex:0];
    NSString *buttonIndexString =[SectionDetails objectAtIndex:1];
    int sectionIndex = [sectionString intValue];
    NSDictionary *dict =shoppingListArray[sectionIndex];
    NSArray *shoppingData = [dict objectForKey:@"shoppingData"];
    
    if(!isShowCompleted){
        shoppingData = [shoppingData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
    }
    
    int valueIndex = (int)sender.tag;
    dispatch_async(dispatch_get_main_queue(), ^{
        
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sectionIndex];
                ShoppingListTableViewCell *cell = (ShoppingListTableViewCell *)[shoppingtable cellForRowAtIndexPath:indexPath];
        
        
                if([sender isEqual:cell.purchasedButton] ){
                    cell.purchasedButton.selected = !cell.purchasedButton.isSelected;
                    
                    if(cell.purchasedButton.isSelected){
                        cell.ingredientName.alpha = 0.3;
                        cell.quantityLabel.alpha = 0.3;
                    }else{
                        cell.ingredientName.alpha = 1.0;
                        cell.quantityLabel.alpha = 1.0;
                    }
                    
                }else if([sender isEqual:cell.alreadyhaveItButton] ){
                    cell.alreadyhaveItButton.selected = !cell.alreadyhaveItButton.isSelected;
                }
   
                NSDictionary *updateDict = [[shoppingData objectAtIndex:valueIndex]mutableCopy];
                if ([buttonIndexString isEqualToString:@"1"]) {
                    valueString =@"P";
                    if (cell.purchasedButton.selected) {
                        value =true;
                    }else{
                        value=false;
                    }
                    
                }else if ([buttonIndexString isEqualToString:@"2"]) {
                    valueString=@"A";
                    if (cell.alreadyhaveItButton.selected) {
                        value =true;
                    }else{
                        value=false;
                    }
                }
                 NSArray *filteredarray = [saveAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ShoppingId == %@) AND (PurOrAlr == %@)", [updateDict objectForKey:@"Id"],valueString]];
                if (filteredarray.count >0) {
                    [saveAll removeObject:filteredarray[0]];
                }else{
                    NSMutableDictionary *mainDict = [[NSMutableDictionary alloc]init];
                    [mainDict setObject:[updateDict objectForKey:@"Id"] forKey:@"ShoppingId"];
                    [mainDict setObject:valueString forKey:@"PurOrAlr"];
                    [mainDict setObject:[NSNumber numberWithBool:value] forKey:@"PurOrAlrValue"];
                    [mainDict setValue:[NSNumber numberWithBool:cell.purchasedButton.isSelected] forKey:@"isSelected"];
                    [saveAll addObject:mainDict];
                }
        
        
            if (![Utility isEmptyCheck:saveAll]) {//add_new_8/8/17
                isChanged = true;
                [self changeSaveButton:NO];
            }else{
                isChanged = false;
                [self changeSaveButton:YES];
            }
        
        });
    
    
    //[self webserviceCall_UpdateSquadShopping:valueString with:value with:updateDict];
}
-(IBAction)otherDelete:(UIButton*)sender{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Alert"
                                          message:@"Do you want to delete this item from shopping list?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *customShopping = [UIAlertAction
                                     actionWithTitle:@"Ok"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *action)
                                     {
                                         NSString *sectionIndexString = [@"" stringByAppendingFormat:@"%@",sender.accessibilityHint];
                                         NSArray *SectionDetails = [sectionIndexString componentsSeparatedByString: @"-"];
                                         NSString *sectionString = [SectionDetails objectAtIndex:0];
                                         
                                         int sectionIndex = [sectionString intValue];
                                         NSDictionary *dict =otherListArray[sectionIndex];
                                         NSArray *shoppingData = [dict objectForKey:@"shoppingData"];
                                         int valueIndex = (int)sender.tag;
                                         NSDictionary *delDict = [shoppingData objectAtIndex:valueIndex];
                                         [self webserviceCall_RemoveSquadShoppingItem:delDict];
                                     }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:customShopping];
    [self presentViewController:alertController animated:YES completion:nil];
    
   
}

-(IBAction)otherPurchaseButton:(UIButton*)sender{
   /* CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:otherShoppingTable];
    NSIndexPath *indexPath = [otherShoppingTable indexPathForRowAtPoint:buttonPosition];
    OtherShoppingTableViewCell *cell = (OtherShoppingTableViewCell *)[otherShoppingTable cellForRowAtIndexPath:indexPath];
    if([sender isEqual:cell.purchaseButton] ){
        cell.purchaseButton.selected = !cell.purchaseButton.isSelected;
    }*/
    NSString *sectionIndexString = [@"" stringByAppendingFormat:@"%@",sender.accessibilityHint];
    NSArray *SectionDetails = [sectionIndexString componentsSeparatedByString: @"-"];
    NSString *sectionString = [SectionDetails objectAtIndex:0];
    NSString *buttonIndexString =[SectionDetails objectAtIndex:1];
    int sectionIndex = [sectionString intValue];
    NSDictionary *dict =otherListArray[sectionIndex];
    NSArray *shoppingData = [dict objectForKey:@"shoppingData"];
    
    if(!isShowCompleted){
        shoppingData = [shoppingData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
    }
    
    int valueIndex = (int)sender.tag;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:sectionIndex];
        OtherShoppingTableViewCell *cell = (OtherShoppingTableViewCell *)[otherShoppingTable cellForRowAtIndexPath:indexPath];
        
        if([sender isEqual:cell.purchaseButton] ){
            cell.purchaseButton.selected = !cell.purchaseButton.isSelected;
            
            if(cell.purchaseButton.isSelected){
                cell.otherItemName.alpha = 0.3;
                cell.quantityLabel.alpha = 0.3;
            }else{
                cell.otherItemName.alpha = 1.0;
                cell.quantityLabel.alpha = 1.0;
            }
            
        }
        
        NSDictionary *updateDict = [[shoppingData objectAtIndex:valueIndex]mutableCopy];
        if ([buttonIndexString isEqualToString:@"1"]) {
            valueString =@"P";
            if (cell.purchaseButton.selected) {
                value =true;
            }else{
                value=false;
            }
        }
        
        [self webserviceCall_UpdateSquadShopping:valueString with:value with:updateDict];
        
    });
    
    
}
-(IBAction)selectCategoryButtonPressed:(UIButton*)sender{
    /*
    PopoverViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Popover"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.settingIndex =1;
    controller.selectedIndex =selectedCategory;
    controller.tableDataArray = catagoryarray;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
     */
    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"]; //ss15
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = catagoryarray;
    controller.mainKey = nil;
    controller.apiType = nil;
    if (selectedCategory>=0) {
        controller.selectedIndex =selectedCategory;
    }else{
        controller.selectedIndex =-1;
    }
    controller.sender = sender;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];

    
}
-(IBAction)FilterButtonPressed:(id)sender{
    /*
    NSArray *filterArray = [[NSArray alloc]initWithObjects:@"All",@"Got it",@"Still to get",nil];
    PopoverViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Popover"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.selectedIndex =shoppingPref;
    controller.settingIndex =0;
    controller.tableDataArray = filterArray;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
     */
    
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"]; //ss15
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = filterArray;
    controller.mainKey = nil;
    controller.apiType = nil;
    if (![Utility isEmptyCheck:filtervalue]) {
        controller.selectedIndex = (int)[filterArray indexOfObject:filtervalue];
    }else{
        controller.selectedIndex = 2;
    }
    controller.sender = sender;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];

}
- (IBAction)saveButtonTapped:(id)sender {
    isChanged =false; //add_new_8/8/17
    [self webserviceCall_UpdateSquadShoppingList];
}

//add_new_7/8/17
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (isChanged || saveAll.count>0) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self saveButtonPressed:nil];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        response(YES);
    }
}
-(IBAction)crossButtonPressed:(UIButton *)sender{
    mealNameView.hidden = true;
}
#pragma mark - End
- (void) countDownAction {
    dispatch_async(dispatch_get_main_queue(), ^{
        int gameOnCount = [countDownLabel.text intValue];
        gameOnCount--;
        countDownLabel.text = [NSString stringWithFormat:@"%d",gameOnCount];
        if (gameOnCount <= 0) {
            [countDownTimer invalidate];
            countDownView.hidden = true;
        }
    });
}

#pragma mark - Private Function
-(void)changeSaveButton:(BOOL)isReset{
     dispatch_async(dispatch_get_main_queue(), ^{
            if(isReset){
                [saveAllButton setBackgroundImage:[UIImage imageNamed:@"sL_sq.png"] forState:UIControlStateNormal];
                [saveAllButton setBackgroundColor:[UIColor clearColor]];
                saveAllButton.enabled = false;
                [saveAllButton setTitleColor:[Utility colorWithHexString:@"E91A9E"] forState:UIControlStateNormal];
                saveAllButton.alpha = 0.5;
            }else{
                [saveAllButton setBackgroundImage:nil forState:UIControlStateNormal];
                [saveAllButton setBackgroundColor:[Utility colorWithHexString:@"E91A9E"]];
                saveAllButton.enabled = true;
                [saveAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                saveAllButton.alpha = 1.0;
            }
     });
    
}
//03/04/18 shabbir
/////////////
//- (NSString *)getQuantity:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{  //ah 23.5
//    NSString *showquantity = @"";
//    if ([[defaults objectForKey:@"ApplyRounding"]boolValue]) {
//        //do rounding
//        float conversionQuantity = 0.0;
//        if (quantity <= 1) {
//            if ([conversionNumbeType isEqualToString:@"QHW"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
//            }
//            if ([conversionNumbeType isEqualToString:@"HW"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
//            }
//            if ([conversionNumbeType isEqualToString:@"W"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
//            }
//        } else {
//            if ([conversionNumbeType isEqualToString:@"QHW"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
//            }
//            if ([conversionNumbeType isEqualToString:@"HW"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
//            }
//            if ([conversionNumbeType isEqualToString:@"W"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
//            }
//            if ([conversionNumbeType isEqualToString:@"W2.5"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W2.5"];
//            }
//            if ([conversionNumbeType isEqualToString:@"W5"]) {
//                conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W5"];
//            }
//
//        }
//        // ¼ ½ ¾
//        showquantity = [NSString stringWithFormat:@"%g",conversionQuantity];
//        if (conversionQuantity == 0.25) {
//            showquantity = @"¼";
//        }
//        if (conversionQuantity == 0.5) {
//            showquantity = @"½";
//        }
//        if (conversionQuantity == 0.75) {
//            showquantity = @"¾";
//        }
//
//    } else {
//        //dont round, just show as it is
//        showquantity = [NSString stringWithFormat:@"%g",quantity];
//    }
//
//    return showquantity;
//}
//- (float )RoundTripConversionValue:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{
//    float floorValue = 0.0;
//
//    // for QWH round trip calculation
//    if ([conversionNumbeType isEqualToString:@"QHW"])
//    {
//        if (quantity == 0)
//        {
//            quantity = 0.0;
//        }
//        else if (quantity <= 1)
//        {
//            if (quantity <= 0.37)
//            {
//                quantity = 0.25;
//            }
//            else if (quantity > 0.37 && quantity <= 0.62)
//            {
//                quantity = 0.5;
//            }
//            else if (quantity > 0.62 && quantity <= 0.87)
//            {
//                quantity = 0.75;
//            }
//            else
//            {
//                quantity = 1;
//            }
//            if (quantity <= 0)
//            {
//                quantity = 0.25;
//            }
//        }
//
//        else
//        {
//            //2.61
//            floorValue = quantity - floor(quantity); //.61
//            quantity = quantity - floorValue; //2
//            if (floorValue > 0)
//            {
//                if (floorValue <= 0.37)
//                {
//                    quantity = quantity + 0.25;
//                }
//                else if (floorValue > 0.37 && floorValue <= 0.62)
//                {
//                    quantity = quantity + 0.5;
//                }
//                else if (floorValue > 0.62 && floorValue <= 0.87)
//                {
//                    quantity = quantity + 0.75;
//                }
//
//                else //if (floorValue > Convert.ToDecimal(0.87) && floorValue < Convert.ToDecimal(quantity))
//                {
//                    quantity = quantity + 1;
//                }
//            }
//        }
//    }
//
//    // for HW round trip calculation
//    else if ([conversionNumbeType isEqualToString:@"HW"])
//    {
//        if (quantity == 0)
//        {
//            quantity = 0.0;
//        }
//        else if (quantity <= 1)
//        {
//            if(quantity > 0 && quantity <= 0.249)
//            {
//                quantity = 0.0;
//            }
//            else if (quantity > .249 && quantity < 0.75)
//            {
//                quantity = 0.50;
//            }
//            else //if (quantity >= Convert.ToDecimal(0.75))
//            {
//                quantity = 1;
//            }
//        }
//        else
//        {
//            floorValue = quantity - floor(quantity);
//            quantity = quantity - floorValue;
//            if (floorValue > 0)
//            {
//                if(floorValue > 0 && floorValue <= 0.249)
//                {
//                    quantity = quantity + 0.0;
//                }
//                else if (floorValue > 0.249 && floorValue < 0.75)
//                {
//                    quantity = quantity + 0.50;
//                }
//                else //if (floorValue >= Convert.ToDecimal(0.75) && floorValue < quantity)
//                {
//                    quantity = quantity + 1;
//                }
//            }
//        }
//    }
//
//    // for W2.5 round trip calculation
//    else if ([conversionNumbeType isEqualToString:@"W2.5"])
//    {
//        int a = quantity / 2.5;
//        floorValue = quantity - (2.5 * a);
//        //        floorValue = quantity % 2.5;
//        quantity = quantity - floorValue;
//        // quantity = quantity + Convert.ToDecimal(2.50);
//
//        if (floorValue < 1.25)
//        {
//            quantity = quantity + 0.0;
//        }
//        else
//        {
//            quantity = quantity + 2.5;
//        }
//
//        if (quantity <= 0)
//        {
//            quantity = 2.50;
//        }
//
//    }
//
//    // for W5 round trip calculation
//    else if ([conversionNumbeType isEqualToString:@"W5"])
//    {
//        int a = quantity / 5.0;
//        floorValue = quantity - (5.0 * a);
//        //        floorValue = quantity % 5.0;
//        quantity = quantity - floorValue;
//        // quantity = quantity + Convert.ToDecimal(5);
//        if (floorValue < 2.50)
//        {
//            quantity = quantity + 0.0;
//        }
//        else
//        {
//            quantity = quantity + 5.0;
//        }
//        if (quantity <= 0)
//        {
//            quantity = 5.0;
//        }
//    }
//
//    // for W round trip calculation
//    else if ([conversionNumbeType isEqualToString:@"W"])
//    {
//        quantity = [[NSString stringWithFormat:@"%.0f",quantity]floatValue];
//        NSLog(@"%f",quantity);
//    }
//    return quantity;
//}
////
//- (NSString *)UnitNumberType:(float) quantity conversionNumbeType:(NSString *)conversionNumbeType{
//
//    //for Unit_O1 and Unit_U1
//    float conversionQuantity = 0.0;
//
//    if (quantity <= 1)
//    {
//        if ([conversionNumbeType isEqualToString:@"QHW"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
//        }
//        if ([conversionNumbeType isEqualToString:@"HW"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
//        }
//        if ([conversionNumbeType isEqualToString:@"W"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
//        }
//
//    }
//    else
//    {
//        if ([conversionNumbeType isEqualToString:@"QHW"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"QHW"];
//        }
//        if ([conversionNumbeType isEqualToString:@"HW"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"HW"];
//        }
//        if ([conversionNumbeType isEqualToString:@"W"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W"];
//        }
//        if ([conversionNumbeType isEqualToString:@"W2.5"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W2.5"];
//        }
//        if ([conversionNumbeType isEqualToString:@"W5"]) {
//            conversionQuantity = [self RoundTripConversionValue:quantity conversionNumbeType:@"W5"];
//        }
//
//    }
//    NSString *showquantity = [NSString stringWithFormat:@"%g",conversionQuantity];
//    return showquantity;
//}
//
//- (NSString *)ImperialRoundTripConversionValue:(float) quantity{
//    //    float floorValue = 0.0;
//    //
//    //    floorValue = quantity % 0.1;
//    //    quantity = quantity - floorValue;
//    //
//    //    if (floorValue < 0.05)
//    //    {
//    //        quantity = quantity + 0;
//    //    }
//    //    else
//    //    {
//    //        quantity = quantity + 0.1;
//    //    }
//    //
//    //    if (quantity <= 0)
//    //    {
//    //        quantity = 0.1;
//    //    }
//
//    NSString *showquantity = [NSString stringWithFormat:@"%g",quantity];
//    return showquantity;
//}
/////////////
- (NSString *)getQuantity:(CGFloat) quantity {  //ah 25.5
    NSString *showquantity = @"";
    if (quantity < 1)
    {
        if(quantity <= 0){
            showquantity = @"0";
        }else if (quantity <= 0.25){
            showquantity = @"¼";
        }else if (quantity > 0.25 && quantity <= 0.50){
            showquantity = @"½";
        }else if (quantity > 0.50 && quantity <= 0.75){
            showquantity = @"¾";
        }else{
            showquantity = @"1";
        }
    }else{
        //showquantity = [NSString stringWithFormat:@"%d",(int)roundf(quantity)];
        showquantity = [NSString stringWithFormat:@"%g",quantity];
    }
    return showquantity;
}
-(void)updateView{
    //to show or hide previous next button
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        
        if (![Utility isEmptyCheck:programName] && ![Utility isEmptyCheck:weekNumber]) {
            weekDateLabel.text = [@"" stringByAppendingFormat:@"%@ - Week %@",programName,weekNumber];
        }else{
            if ([[formatter stringFromDate:thisWeekMonday] isEqualToString:[formatter stringFromDate:weekdate]]) {
                weekDateLabel.text = @"CURRENT WEEK";
                
                if (isCustom) {
                    [headerButton setTitle:@"CUSTOM SHOP LIST" forState:UIControlStateNormal];
                }else{
                    [headerButton setTitle:@"SHOP LIST" forState:UIControlStateNormal];
                }
            }else{
                weekDateLabel.text = [@"Week - " stringByAppendingFormat:@"%@",[formatter stringFromDate:weekdate] ];
            }
        }
       
        NSTimeInterval sixmonth = 13*24*60*60;
        NSDate *endDate = [thisWeekMonday
                           dateByAddingTimeInterval:sixmonth];
        NSDate *nxtDate = [weekdate dateByAddingTimeInterval:7*24*60*60];
        if ([endDate compare:nxtDate] == NSOrderedDescending || [endDate compare:nxtDate] == NSOrderedSame) {
            nextButton.hidden = false;
        }else{
            nextButton.hidden = true;
        }
        NSDate *prevDate = [weekdate dateByAddingTimeInterval:-7*24*60*60];
        if ([joiningDate compare:prevDate] == NSOrderedAscending || [joiningDate compare:prevDate] == NSOrderedSame) {
            prevButton.hidden = false;
        }else{
            prevButton.hidden = true;
        }
    });
}


-(BOOL)formValidation{
    BOOL isValidated = NO;
    NSString *itemNameString= [[addshoppingArray objectAtIndex:0] objectForKey:@"Name"];
    NSString *itemQuantityStrring = [[addshoppingArray objectAtIndex:0] objectForKey:@"ItemQuantity"];
    NSString *categoryString =[[addshoppingArray objectAtIndex:0] objectForKey:@"Category"];
    if (itemNameString.length < 1){
        [Utility msg:@"Item Name required." title:@"Oops!" controller:self haveToPop:NO];
        return isValidated;
    } else if (itemQuantityStrring.length < 1){
        [Utility msg:@"Item Quantity required." title:@"Oops!" controller:self haveToPop:NO];
        return isValidated;
    }else if (categoryString.length < 1){
        [Utility msg:@"Select Item Category." title:@"Oops!" controller:self haveToPop:NO];
        return isValidated;
    }
    return YES;
}

-(void)startDateCal{
    /*
     //find the start day of week
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
     [calendar setFirstWeekday:2];
     [calendar setTimeZone:[NSTimeZone timeZoneWithName:[defaults objectForKey:@"Timezone"]]];
     NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
     //    NSLog(@"wkwkw %ld",(long)[comps weekday]);
     
     NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
     [componentsToSubtract setDay:(0 - ([comps weekday] - 2))];
     weekstart = [calendar dateByAddingComponents:componentsToSubtract toDate:[NSDate date] options:0];
     //    weekOffset = 2 monday
     
     */
    //???saugata
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today is Sunday, subtract 0 days.)
     */
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:today];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    if ([weekdayComponents weekday] == 1) {
        [componentsToSubtract setDay:-6];
    }else{
        [componentsToSubtract setDay:(0 - ([weekdayComponents weekday] - 2))];
    }
    thisWeekMonday = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    NSLog(@"%@",thisWeekMonday);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (!weekdate) {
        weekdate =thisWeekMonday;
    }
    thisWeekMondayString = [formatter stringFromDate:weekdate];
    
}

-(void)webserviceCall_UpdateSquadShopping:(NSString*)checkString with:(BOOL)checkvalue with:(NSDictionary*)updateDict{
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
        // [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[updateDict objectForKey:@"Id"] forKey:@"ShoppingId"];
        [mainDict setObject:checkString forKey:@"PurOrAlr"];
        [mainDict setObject:[NSNumber numberWithBool:checkvalue] forKey:@"PurOrAlrValue"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateSquadShopping" append:@""forAction:@"POST"];
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
                                                                         [Utility msg:@"Update Successfully" title:@"Success !" controller:self haveToPop:NO];
                                                                         if (isCustom) {
                                                                             [self getSquadCustomShoppingListSettings];
                                                                         }else{
                                                                             [self getShoppinglistDataWithSettings];
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

-(void)webserviceCall_UpdateSquadShoppingList{
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
        [mainDict setObject:saveAll forKey:@"ShoppingData"];
        [mainDict setObject:[NSNumber numberWithBool:isCustom] forKey:@"IsCustom"];

        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"UpdateSquadShoppingList" append:@""forAction:@"POST"];
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
                                                                         self->saveAll = [[NSMutableArray alloc]init];
                                                                          [self changeSaveButton:YES];
                                                                         [Utility msg:@"Update Successfully" title:@"Success !" controller:self haveToPop:NO];
                                                                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBadgePoint" object:self];//gami_badge_popup_nourish

                                                                         if (isCustom) {
                                                                             [self getSquadCustomShoppingListSettings];
                                                                         }else{
                                                                             [self getShoppinglistDataWithSettings];
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

-(void)webserviceCall_RemoveSquadShoppingItem:(NSDictionary*)delDict{
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
           // [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
            [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
            [mainDict setObject:[delDict objectForKey:@"Id"] forKey:@"ShoppingId"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"RemoveSquadShoppingItem" append:@""forAction:@"POST"];
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
                                                                             [Utility msg:@"Deleted Successfully" title:@"Success !" controller:self haveToPop:NO];
                                                                             [shoppingListArray removeAllObjects];
                                                                             [otherListArray removeAllObjects];
                                                                             if (isCustom) {
                                                                                 [self getSquadCustomShoppingListSettings];
                                                                             }else{
                                                                                 [self getShoppinglistDataWithSettings];
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
-(void)webServiceCall_AddSquadShoppingList:(NSMutableArray*)addArray{
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:thisWeekMondayString forKey:@"WeekStartDate"];
        [mainDict setObject:[[addArray objectAtIndex:0] objectForKey:@"Category"] forKey:@"Category"];
        [mainDict setObject:[[addArray objectAtIndex:0] objectForKey:@"Name"] forKey:@"Name"];
        [mainDict setObject:[[addArray objectAtIndex:0] objectForKey:@"ItemQuantity"] forKey:@"ItemQuantity"];

        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSquadShoppingList" append:@""forAction:@"POST"];
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
                                                                         [Utility msg:@"Saved Successfully" title:@"Success !" controller:self haveToPop:NO];
                                                                         //suadd10
                                                                         isSaved=true;
                                                                         [addshoppingArray removeAllObjects];
                                                                         [self.view setNeedsUpdateConstraints];
                                                                         [addShoppingTable reloadData];
                                                                         [self cancelButtonPressed:0];
                                                                         if (isCustom) {
                                                                             [self getSquadCustomShoppingListSettings];
                                                                         }else{
                                                                             [self getShoppinglistDataWithSettings];
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
-(void)generateSquadUserMealPlans:(NSNumber *)stepNumberForGenerateMeal{//add8
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        if (weekdate) {
            [mainDict setObject:[formatter stringFromDate:weekdate] forKey:@"RunDate"];
        }
        [mainDict setObject:stepNumberForGenerateMeal forKey:@"exerciseStep"];
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
            [self.view bringSubviewToFront:countDownView];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GenerateSquadUserMealPlansApiCall" append:@""forAction:@"POST"];
        
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
                                                                         haveToCallGenerateMeal = NO;
                                                                         if (isCustom) {
                                                                             [self getSquadCustomShoppingListSettings];
                                                                         }else{
                                                                             [self getShoppinglistDataWithSettings];
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
-(void)getSquadCustomShoppingListSettings{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor clearColor];
            [self.view bringSubviewToFront:countDownView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:thisWeekMondayString forKey:@"WeekStartDate"];
        [mainDict setObject:[NSNumber numberWithInt:shoppingPref] forKey:@"ShoppingPref"];
        [mainDict setObject:[defaults objectForKey:@"ApplyRounding"] forKey:@"ApplyRounding"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
             [self changeSaveButton:YES];
            shoppingListArray = [[NSMutableArray alloc]init];
            if (![Utility isEmptyCheck:shoppingListArray]) {
                [shoppingListArray removeAllObjects];
            }
            if (![Utility isEmptyCheck:otherListArray]) {
                [otherListArray removeAllObjects];
            }
        });
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetSquadCustomShoppingListSettingsApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                        
                                                                         [self prepareCustomShoppingListData:responseDict];
                                                                         
                                                                     }else{
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
-(void)getShoppinglistDataWithSettings{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            apiCount++;
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor clearColor];
            [self.view bringSubviewToFront:countDownView];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:thisWeekMondayString forKey:@"WeekStartDate"];
        [mainDict setObject:[NSNumber numberWithInt:shoppingPref] forKey:@"ShoppingPref"];
        [mainDict setObject:[defaults objectForKey:@"ApplyRounding"] forKey:@"ApplyRounding"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            shoppingListArray = [[NSMutableArray alloc]init];
            if (![Utility isEmptyCheck:shoppingListArray]) {
                [shoppingListArray removeAllObjects];
            }
            if (![Utility isEmptyCheck:otherListArray]) {
                [otherListArray removeAllObjects];
            }
        });
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetShoppinglistDataWithSettingsApiCall" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 apiCount--;
                                                                 if (contentView && apiCount == 0) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         [self prepareMyShoppingListData:responseDict];
                                                                         
                                                                     }else{
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

-(void)prepareCustomShoppingListData:(NSDictionary *)responseDict{
    
     if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"]]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:responseDict[@"WeekStartDate"]];
        if (date) {
            joiningDate = date;
            [self updateView];
            NSArray *catagoryTotalArray =[responseDict objectForKey:@"ShoppingIngredient"];
            catagoryarray = [[NSMutableArray alloc]init];
            if (![Utility isEmptyCheck:responseDict[@"ShoppingIngredient"]]) {
                for (int i=0; i<catagoryTotalArray.count; i++) {
                    NSDictionary *dict = [catagoryTotalArray objectAtIndex:i];
                    [catagoryarray addObject:[dict objectForKey:@"IngredientCategory"]];
                }
            }
            NSArray *rawShoppingDataArray = responseDict[@"ShoppingList"];
            if (![Utility isEmptyCheck:rawShoppingDataArray] && rawShoppingDataArray.count > 0) {
                NSArray *uniqueCategory = [rawShoppingDataArray valueForKeyPath:@"@distinctUnionOfObjects.IngredientCategory"];
                NSLog(@"Category-%@",uniqueCategory);
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                uniqueCategory = [uniqueCategory sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                for (NSString *category in uniqueCategory) {
                    
                    NSArray *filteredarray = [rawShoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientCategory == %@)", category]];
                    
                    NSArray *filterPersonalTrueArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:1]]];
                    
                    NSArray *filterPersonalFalseArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:0]]];
                    
                    if (filterPersonalTrueArray.count > 0) {
                        NSArray *filteredNotNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
                        NSArray *filteredNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
                        if (filteredNotNoMeasureArray.count > 0) {
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
                        }else{
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
                        }
                        
                        if (filteredNoMeasureArray.count > 0) {
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category",nil]];
                        }
                        
                    }
                    
                    if (filterPersonalFalseArray.count > 0) {
                        NSArray *filteredNotNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
                        NSArray *filteredNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
                        if (filteredNotNoMeasureArray.count > 0) {
                            [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                        }else{
                            [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                        }
                        
                        
                        if (filteredNoMeasureArray.count > 0) {
                            [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category", nil]];
                            
                        }
                        
                    }
                }
                
                initialOtherListArray = otherListArray;
                initialShoppingListArray = shoppingListArray;
                
                [countDownTimer invalidate];
                countDownView.hidden = true;
            }else{
                [countDownTimer invalidate];
                countDownView.hidden = true;
                UIAlertController *alertController = [UIAlertController
                                                      alertControllerWithTitle:@"Alert"
                                                      message:@"Your Custom Shopping List for this week has not been created yet. Would you like to create one?"
                                                      preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *customShopping = [UIAlertAction
                                                 actionWithTitle:@"Ok"
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action)
                                                 {
                                                     CustomNutritionPlanListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CustomNutritionPlanList"];
                                                     controller.isFromShoppingList = YES;
                                                     controller.weekDate = weekdate;
                                                     [self.navigationController pushViewController:controller animated:YES];
                                                 }];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"Cancel"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   if ([delegate respondsToSelector:@selector(didCheckAnyChangeForShoppingList:)]) {
                                                       [delegate didCheckAnyChangeForShoppingList:NO];
                                                   }
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }];
                [alertController addAction:customShopping];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            
           
            [shoppingtable reloadData];
            [otherShoppingTable reloadData];
        }
    }
    
}

-(void)prepareMyShoppingListData:(NSDictionary *)responseDict{
    
    if(!otherListArray){
        otherListArray =[[NSMutableArray alloc]init];
    }
    
    if(!shoppingListArray){
        shoppingListArray =[[NSMutableArray alloc]init];
    }
    
    if (![Utility isEmptyCheck:responseDict[@"WeekStartDate"]]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:responseDict[@"WeekStartDate"]];
        if (date) {
            joiningDate = date;
            
            //Add_SetProgram
            if (![Utility isEmptyCheck:[responseDict objectForKey:@"ProgramName"]]) {
                programName = [responseDict objectForKey:@"ProgramName"];
            }else{
                programName = @"";
            }
            
            
            if (![Utility isEmptyCheck:[responseDict objectForKey:@"WeekNumber"]]) {
                weekNumber = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"WeekNumber"]];
            }else{
                weekNumber = @"";
            }//Add_SetProgram
            
            if (![Utility isEmptyCheck:[responseDict objectForKey:@"UserProgramId"]]) {
                UserProgramIdStr = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"UserProgramId"]];
            }
            if (![Utility isEmptyCheck:[responseDict objectForKey:@"ProgramId"]]) {
                ProgramIdStr = [@"" stringByAppendingFormat:@"%@",[responseDict objectForKey:@"ProgramId"]];
            }//

            
            [self updateView];
            NSArray *catagoryTotalArray =[responseDict objectForKey:@"ShoppingIngredient"];
            catagoryarray = [[NSMutableArray alloc]init];
            if (![Utility isEmptyCheck:responseDict[@"ShoppingIngredient"]]) {
                for (int i=0; i<catagoryTotalArray.count; i++) {
                    NSDictionary *dict = [catagoryTotalArray objectAtIndex:i];
                    [catagoryarray addObject:[dict objectForKey:@"IngredientCategory"]];
                }
            }
            NSArray *rawShoppingDataArray = responseDict[@"ShoppingList"];
            if (![Utility isEmptyCheck:rawShoppingDataArray] && rawShoppingDataArray.count > 0) {
                NSArray *uniqueCategory = [rawShoppingDataArray valueForKeyPath:@"@distinctUnionOfObjects.IngredientCategory"];
                NSLog(@"Category-%@",uniqueCategory);
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:YES selector:@selector(caseInsensitiveCompare:)];
                
                uniqueCategory = [uniqueCategory sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                
                for (NSString *category in uniqueCategory) {
                    
                    NSArray *filteredarray = [rawShoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientCategory == %@)", category]];
                    
                    NSArray *filterPersonalTrueArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:1]]];
                    
                    NSArray *filterPersonalFalseArray = [filteredarray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPersonal == %@)", [NSNumber numberWithBool:0]]];
                    
                    if (filterPersonalTrueArray.count > 0) {
                        NSArray *filteredNotNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
                        NSArray *filteredNoMeasureArray = [filterPersonalTrueArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
                        if (filteredNotNoMeasureArray.count > 0) {
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
                        }else{
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category",nil]];
                        }
                        
                        if (filteredNoMeasureArray.count > 0) {
                            [otherListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category",nil]];
                        }
                        
                    }
                    
                    if (filterPersonalFalseArray.count > 0) {
                        NSArray *filteredNotNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:0]]];
                        NSArray *filteredNoMeasureArray = [filterPersonalFalseArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsNoMeasure == %@)", [NSNumber numberWithBool:1]]];
                        if (filteredNotNoMeasureArray.count > 0) {
                            [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                        }else{
                             [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNotNoMeasureArray,@"shoppingData",category,@"category", nil]];
                        }
                        
                        if (filteredNoMeasureArray.count > 0) {
                            [shoppingListArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:filteredNoMeasureArray,@"shoppingData",@"No Measure",@"category", nil]];
                        }
                        
                    }
                }
                
                initialOtherListArray = otherListArray;
                initialShoppingListArray = shoppingListArray;
                
                [countDownTimer invalidate];
                countDownView.hidden = true;
            }else{
                if (![Utility isEmptyCheck:[responseDict objectForKey:@"StepNumber"]] && [[responseDict objectForKey:@"StepNumber"] isEqual:@0]) {
                    if (haveToCallGenerateMeal) {
                        [self generateSquadUserMealPlans:[responseDict objectForKey:@"StepNumber"]];
                    }
                }else{
                    [Utility msg:@"Please setup your Meal Plan" title:@"Warning!" controller:self haveToPop:NO];
                    return;
                }
            }
            
            [shoppingtable reloadData];
            [otherShoppingTable reloadData];
        }
    }
    
}

#pragma mark - End

#pragma mark - End
#pragma Mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isShowCompleted = true;
    isShowUntracked = true;//false; //shabbir
    [showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
    [showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
    
    mealNameView.hidden = true;
    isChanged=NO; //add_new_7/8/17
    saveAll = [[NSMutableArray alloc]init];
    selectedCategory=-1;
    apiCount = 0;
    totalcategory = [[NSMutableArray alloc]init];
    shoppingListArray=[[NSMutableArray alloc]init];
    otherListArray =[[NSMutableArray alloc]init];
    addshoppingArray=[[NSMutableArray alloc]init];
    catagoryarray = [[NSMutableArray alloc]init];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ShoppingList" bundle:nil];
    [shoppingtable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifierForShoppingList];
    [otherShoppingTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    [filterButton setTitle:@"Still to get" forState:UIControlStateNormal];
    shoppingPref=0;
    shoppingtable.estimatedSectionHeaderHeight = 35;
    shoppingtable.sectionHeaderHeight = UITableViewAutomaticDimension;
    shoppingtable.estimatedRowHeight = 75;
    shoppingtable.rowHeight = UITableViewAutomaticDimension;
    
    mealNameTable.estimatedRowHeight = 40;
    mealNameTable.rowHeight = UITableViewAutomaticDimension;
    mealNameTable.estimatedSectionHeaderHeight = 0;
    mealNameTable.sectionHeaderHeight = 0;
    mealNameTable.estimatedSectionFooterHeight = 0;
    mealNameTable.sectionFooterHeight = 0;
    
    otherShoppingTable.estimatedSectionHeaderHeight = 35;
    otherShoppingTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    otherShoppingTable.estimatedRowHeight = 75;
    otherShoppingTable.rowHeight = UITableViewAutomaticDimension;
    [self registerForKeyboardNotifications];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:self->countDownView];
        if(self->isCustom){
            self->counyDownMsg.text = @"Hold Tight, your CUSTOM SHOPPING LIST is being created";
        }else{
            self->counyDownMsg.text = @"Hold tight, this WEEKS SHOPPING LIST is just being created for you";
        }
        self->countDownView.hidden = false;
        self->countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        
        self->selectedServe = serveArray[0];
        [self->serveButton setTitle:self->selectedServe[@"value"] forState:UIControlStateNormal];
        self->saveAllButton.enabled = false;
        self->minusButton.enabled = false;
        self->minusButton.alpha = 0.5;
        
    });
   
    
  }

-(void)viewWillAppear:(BOOL)animated{
    
    [shoppingtable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [addShoppingTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [otherShoppingTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    haveToCallGenerateMeal = YES;//add8
    filterArray = [[NSArray alloc]initWithObjects:@"All",@"Got it",@"Still to get",nil];//ss15
    isSaved =false;
    [self startDateCal];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         [self changeSaveButton:YES];
        if (![Utility isEmptyCheck:thisWeekMondayString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weekDateLabel.text = @"CURRENT WEEK";
                
                if (isCustom) {
                    [headerButton setTitle:@"CUSTOM SHOP LIST" forState:UIControlStateNormal];
                }else{
                    [headerButton setTitle:@"SHOP LIST" forState:UIControlStateNormal];
                }
            });
        }
        if (isCustom) {
            [self getSquadCustomShoppingListSettings];
        }else{
            [self getShoppinglistDataWithSettings];
        }

    });
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitList:) name:@"backButtonPressed" object:nil];// AY 12032018
}


-(void)viewWillDisappear:(BOOL)animated{
    [shoppingtable removeObserver:self forKeyPath:@"contentSize"];
    [addShoppingTable removeObserver:self forKeyPath:@"contentSize"];
    [otherShoppingTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];//AY 12032018
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == shoppingtable) {
        shoppingtableHeightConstraints.constant=shoppingtable.contentSize.height;
    }else if (object == addShoppingTable){
        addShoppingTableHeightConstraints.constant=addShoppingTable.contentSize.height;
        [mainScroll scrollRectToVisible:addShoppingTable.frame animated:YES];
    }else if (object == otherShoppingTable){
        otherShoppingTableHeightConstraints.constant=otherShoppingTable.contentSize.height;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isCustom) {
            //addShoppingTableHeightConstraints.constant = 0;
            addShoppingTable.hidden = true;
            addToListButton.enabled = false;
            addToListButton.alpha = 0.5;
        }else{
            addShoppingTable.hidden = false;
            addToListButton.enabled = true;
            addToListButton.alpha = 1.0;
        }
    });
}

#pragma mark - End

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == mealNameTable) {
        return 1;
    } else if ([tableView isEqual:shoppingtable]) {
        
        if(initialShoppingListArray && !isShowUntracked){
            
            NSString *category = @"No Measure";
            NSPredicate *filter = [NSPredicate predicateWithFormat:[@"" stringByAppendingFormat:@"(category != '%@')", category]];
            NSArray *filteredArray = [initialShoppingListArray filteredArrayUsingPredicate:filter];
            shoppingListArray = [filteredArray mutableCopy];
            
        }else{
          shoppingListArray = [initialShoppingListArray mutableCopy];
        }
        
        return shoppingListArray.count;
        
    }else if ([tableView isEqual:addShoppingTable]){
         return 1;
    }
    else  {
        
        if(initialOtherListArray && !isShowUntracked){
            NSString *category = @"No Measure";
            NSPredicate *filter = [NSPredicate predicateWithFormat:[@"" stringByAppendingFormat:@"(category != '%@')", category]];
            NSArray *filteredArray = [initialOtherListArray filteredArrayUsingPredicate:filter];
            otherListArray = [filteredArray mutableCopy];
            
        }else{
            otherListArray = [initialOtherListArray mutableCopy];
        }
        
        return otherListArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == mealNameTable) {
        return mealNameList.count;
    } else if ([tableView isEqual:shoppingtable]) {
         NSDictionary *tempDict = [shoppingListArray objectAtIndex:section];
         NSArray *tempArray = [tempDict objectForKey:@"shoppingData"];
         
         if(!isShowCompleted){
             
          tempArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
         }
         
         return tempArray.count ;
     }else if ([tableView isEqual:addShoppingTable]){
         return addshoppingArray.count;
     }
     else{
         NSDictionary *tempDict = [otherListArray objectAtIndex:section];
         NSArray *tempArray = [tempDict objectForKey:@"shoppingData"];
         
         if(!isShowCompleted){
             
             tempArray = [tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]];
         }
         return tempArray.count ;
     }
 }


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == mealNameTable) {
        return nil;
    }
    NSDictionary *tempDict =[[NSDictionary alloc]init];
    ShoppingList *sectionHeaderView;
    if (tableView == shoppingtable) {
         tempDict = [shoppingListArray objectAtIndex:section];
        sectionHeaderView = ( ShoppingList *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifierForShoppingList];
    }else if ([tableView isEqual:addShoppingTable]){
        return nil;
    }else{
         tempDict = [otherListArray objectAtIndex:section];
        sectionHeaderView = ( ShoppingList *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    }
    
    sectionHeaderView.headerLabel.text =[[tempDict objectForKey:@"category"] uppercaseString];
    if ([[tempDict objectForKey:@"category"] isEqualToString:@"No Measure"]) {
        sectionHeaderView.headerLabel.text = @"UNMEASURED";
        sectionHeaderView.headerBg.hidden = true;
        sectionHeaderView.bottomLineView.hidden = false;
        //sectionHeaderView.bottomLineView.backgroundColor = [UIColor lightGrayColor];
        sectionHeaderView.headerLabel.textColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
    }else{
        //sectionHeaderView.bottomLineView.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:39.0f/255.0f blue:171.0f/255.0f alpha:1];
        sectionHeaderView.headerBg.hidden = false;
        sectionHeaderView.bottomLineView.hidden = true;
        sectionHeaderView.headerLabel.textColor = [UIColor whiteColor];
    }
    return sectionHeaderView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    if (tableView == mealNameTable) {
        FoodPrepShoppingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodPrepShoppingListTableViewCell"];
        // Configure the cell...
        if (cell == nil) {
            cell = [[FoodPrepShoppingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FoodPrepShoppingListTableViewCell"];
        }
        if (![Utility isEmptyCheck:mealNameList]) {
            NSString *meal = [@"" stringByAppendingFormat:@"%@",![Utility isEmptyCheck:[mealNameList objectAtIndex:indexPath.row]]?[mealNameList objectAtIndex:indexPath.row]:@""];
            if (![Utility isEmptyCheck:meal]) {
                cell.ingredientName.text = meal;
            }
        }
        
        tableCell = cell;
    } else if (tableView == shoppingtable) {
        NSString *CellIdentifier =@"ShoppingListTableViewCell";
        ShoppingListTableViewCell *cell = (ShoppingListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // Configure the cell...
        if (cell == nil) {
            cell = [[ShoppingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        NSMutableDictionary *dict = [shoppingListArray objectAtIndex:indexPath.section];
        
        if (![Utility isEmptyCheck:dict]) {
            
            NSMutableArray *shoppingDataArray=[[dict objectForKey:@"shoppingData"]mutableCopy];
            if(!isShowCompleted){
                
                shoppingDataArray = [[shoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]] mutableCopy];
            }
            
            
            
            NSMutableDictionary *shoppingDataDict = [[shoppingDataArray objectAtIndex:indexPath.row]mutableCopy];
            
            // NSString *conversionNumString = [@"" stringByAppendingFormat:@"%@",[shoppingDataDict objectForKey:@"ConversionNum"]];
            NSString *conversionUnitString = [shoppingDataDict objectForKey:@"ConversionUnit"];
            NSString *unitMetricString = [shoppingDataDict objectForKey:@"UnitMetric"];
            
            
            float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
            
            //NSLog(@"%@",[defaults objectForKey:@"UnitPreference"]);
            
            NSString *setConditional=@"";
            
            if ([[shoppingDataDict objectForKey:@"IsNoMeasure"]boolValue]) {
                setConditional = @"*";
                cell.ingredientName.text=[shoppingDataDict objectForKey:@"Ingredient"];
                cell.quantityLabel.text= @"";
            }else{
                cell.ingredientName.text=[shoppingDataDict objectForKey:@"Ingredient"];
                int noOfServe = [selectedServe[@"key"] intValue];
                float quantityMetric = [[shoppingDataDict objectForKey:@"QuantityMetric"] floatValue]*noOfServe;
                float quantityImperial = [[shoppingDataDict objectForKey:@"QuantityImperial"] floatValue]*noOfServe;
                if ( conversionNum == 0 || [conversionUnitString isEqualToString:unitMetricString] ){
                    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0) {
                        NSString *detailString =@"";
                        
//                        detailString =[@"" stringByAppendingFormat:@"%g %@",quantityMetric,[shoppingDataDict objectForKey:@"UnitMetric"]];
                        detailString =[@"" stringByAppendingFormat:@"%@ %@",[self getQuantity:quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        if (![[shoppingDataDict objectForKey:@"UnitImperial"] isEqualToString:[shoppingDataDict objectForKey:@"UnitMetric"]]) {
                            detailString = [detailString stringByAppendingFormat:@" (%@ %@)",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        }
                        if (quantityMetric>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text = detailString;
                        
                    }else if([[defaults objectForKey:@"UnitPreference"] intValue] == 1){
//                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                        if (quantityMetric>0) {
                            cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%@",[self getQuantity:quantityMetric]],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        
                    }else{
                        if (quantityImperial>0) {
                            cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%@",[self getQuantity:quantityImperial]],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text=[@"" stringByAppendingFormat:@"%@ %@",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                    }
                }else{
                    if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0) {
                        NSString *detailString =@"";
//                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
//                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        //shabbir 03/04/18
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]] ;//cal]];

                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        if (![[shoppingDataDict objectForKey:@"UnitImperial"] isEqualToString:[shoppingDataDict objectForKey:@"UnitMetric"]]) {
                            detailString = [detailString stringByAppendingFormat:@" or (%@ %@)",[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        }
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text = detailString;
                        
                    }else if(([[defaults objectForKey:@"UnitPreference"] intValue] == 1)){
                        NSString *detailString =@"";
//                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
                        
//                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]];
                        
                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%g",quantityMetric],[shoppingDataDict objectForKey:@"UnitMetric"]];
                        
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text = detailString;
                        
                    }else{
                        NSString *detailString =@"";
//                        float conversionNum = [[shoppingDataDict objectForKey:@"ConversionNum"] floatValue];
//                        CGFloat cal = ((quantityMetric *conversionNum)/100);
                        detailString= [@"" stringByAppendingFormat:@"%@",[self getQuantity:[shoppingDataDict[@"ConvertedQuantity"]floatValue]*noOfServe]];
                        
                        detailString = [detailString stringByAppendingFormat:@" %@ ( %@ %@ )",[shoppingDataDict objectForKey:@"ConversionUnit"],[@"" stringByAppendingFormat:@"%.2f",quantityImperial],[shoppingDataDict objectForKey:@"UnitImperial"]];
                        detailString = [detailString stringByAppendingString:setConditional];
                        if ([shoppingDataDict[@"ConvertedQuantity"]floatValue]>0) {
                            cell.quantityLabel.text = detailString;
                        } else {
                            cell.quantityLabel.text = @"as needed";
                        }
//                        cell.quantityLabel.text = detailString;
                    }
                }
            }
            
           NSArray *filteredarray = [saveAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ShoppingId == %@)", [shoppingDataDict objectForKey:@"Id"]]];
                

            if ([[shoppingDataDict objectForKey:@"IsPurchased"]boolValue] && filteredarray.count == 0) {
                cell.purchasedButton.selected=true;
                cell.ingredientName.alpha = 0.3;
                cell.quantityLabel.alpha = 0.3;
                
            }else if(filteredarray.count>0){
                NSDictionary *filterDict = filteredarray[0];
                cell.purchasedButton.selected=[filterDict[@"isSelected"] boolValue];
                
                if(cell.purchasedButton.isSelected){
                    cell.ingredientName.alpha = 0.3;
                    cell.quantityLabel.alpha = 0.3;
                }else{
                    cell.ingredientName.alpha = 1.0;
                    cell.quantityLabel.alpha = 1.0;
                }
                
            }else{
                cell.purchasedButton.selected=false;
                cell.ingredientName.alpha = 1.0;
                cell.quantityLabel.alpha = 1.0;
            }
            if ([[shoppingDataDict objectForKey:@"IsAlreadyHave"]boolValue]) {
                cell.alreadyhaveItButton.selected=true;
            }
            else{
                cell.alreadyhaveItButton.selected=false;
            }
            
            if(indexPath.row == shoppingDataArray.count-1){
                cell.showCompletedButton.hidden = false;
                cell.showIngredientButton.hidden = false;
                cell.separatorView.hidden=true;
            }else{
                cell.showCompletedButton.hidden = true;
                cell.showIngredientButton.hidden = true;
                cell.separatorView.hidden=false;
            }// AY 12032018
            
            if(isShowCompleted){
                [cell.showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
            }else{
                [cell.showCompletedButton setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
            }
            
            if(isShowUntracked){
                [cell.showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
            }else{
                [cell.showIngredientButton setTitle:@"SHOW UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
            }
            
            
        }
        cell.purchasedButton.tag=indexPath.row;
        cell.purchasedButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld-%@",(long)indexPath.section,@"1"];
        cell.alreadyhaveItButton.tag=indexPath.row;
        cell.alreadyhaveItButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld-%@",(long)indexPath.section,@"2"];
        
        tableCell =cell;
        
    }else if ([tableView isEqual:addShoppingTable]){
             NSString *CellIdentifier =@"AddShoppingTableViewCell";
             AddShoppingTableViewCell *cell = (AddShoppingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             // Configure the cell...
             if (cell == nil) {
                 cell = [[AddShoppingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
            if (isSaved) {
                cell.itemName.text=@"";
                cell.quantity.text=@"";
                selectedCategory=-1;
                isSaved=false;
            
                [addShoppingTable reloadData];
            }else{
                NSLog(@"addshoppingArray%@",addshoppingArray);
                NSMutableDictionary *dict = [addshoppingArray objectAtIndex:0];
                [dict setObject:cell.itemName.text forKey:@"Name"];
                [dict setObject:cell.quantity.text forKey:@"ItemQuantity"];
                
                if (selectedCategory>=0) {
                    [cell.selectCategory setTitle:[catagoryarray objectAtIndex:selectedCategory] forState:UIControlStateNormal] ;
                    [dict setObject:cell.selectCategory.titleLabel.text forKey:@"Category"];
                    
                }else{
                    [cell.selectCategory setTitle: @"Select a Category" forState:UIControlStateNormal];
                }
                NSLog(@"addshoppingArray1%@",addshoppingArray);

            }
                tableCell =cell;
         }else{
             NSString *CellIdentifier =@"OtherShoppingTableViewCell";
             OtherShoppingTableViewCell *othercell = (OtherShoppingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
             // Configure the cell...
             if (othercell == nil) {
                 othercell = [[OtherShoppingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
             }
             NSMutableDictionary *otherDict = [otherListArray objectAtIndex:indexPath.section];
             
             if (![Utility isEmptyCheck:otherDict]) {
                 NSMutableArray *shoppingDataArray=[[otherDict objectForKey:@"shoppingData"]mutableCopy];
                 
                 if(!isShowCompleted){
                     
                     shoppingDataArray = [[shoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]] mutableCopy];
                 }
                 
                 NSMutableDictionary *shoppingDataDict = [[shoppingDataArray objectAtIndex:indexPath.row]mutableCopy];
                 NSArray *filteredarray = [saveAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ShoppingId == %@)", [shoppingDataDict objectForKey:@"Id"]]];
                 
                 
                 if ([[shoppingDataDict objectForKey:@"IsPurchased"]boolValue] && filteredarray.count == 0) {
                     othercell.purchaseButton.selected=true;
                     othercell.otherItemName.alpha = 0.3;
                     othercell.quantityLabel.alpha = 0.3;
                     
                 }else if(filteredarray.count>0){
                     NSDictionary *filterDict = filteredarray[0];
                     othercell.purchaseButton.selected=[filterDict[@"isSelected"] boolValue];
                     
                     if(othercell.purchaseButton.isSelected){
                         othercell.otherItemName.alpha = 0.3;
                         othercell.quantityLabel.alpha = 0.3;
                     }else{
                         othercell.otherItemName.alpha = 1.0;
                         othercell.quantityLabel.alpha = 1.0;
                     }
                     
                 }else{
                     othercell.purchaseButton.selected=false;
                     othercell.otherItemName.alpha = 1.0;
                     othercell.quantityLabel.alpha = 1.0;
                 }
                 
                 othercell.otherItemName.text= [@"" stringByAppendingFormat:@"%@",[shoppingDataDict objectForKey:@"Ingredient"]];
                 othercell.quantityLabel.text= [@"" stringByAppendingFormat:@"%@",[shoppingDataDict objectForKey:@"ItemQuantity"]];
                 
                 
                 if(indexPath.row == shoppingDataArray.count-1){
                    othercell.separatorView.hidden=true;
                     othercell.showCompletedButton.hidden = false;
                     othercell.showIngredientButton.hidden = false;
                 }else{
                    othercell.separatorView.hidden=false;
                     othercell.showCompletedButton.hidden = true;
                     othercell.showIngredientButton.hidden = true;
                 }// AY 12032018
                 
                 if(isShowCompleted){
                     [othercell.showCompletedButton setTitle:@"HIDE COMPLETED" forState:UIControlStateNormal];
                 }else{
                     [othercell.showCompletedButton setTitle:@"SHOW COMPLETED" forState:UIControlStateNormal];
                 }
                 
                 if(isShowUntracked){
                     [othercell.showIngredientButton setTitle:@"HIDE UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
                 }else{
                     [othercell.showIngredientButton setTitle:@"SHOW UNMEASURED INGREDIENTS" forState:UIControlStateNormal];
                 }

             }
             othercell.purchaseButton.tag=indexPath.row;
             othercell.purchaseButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld-%@",(long)indexPath.section,@"1"];
             othercell.delButton.tag=indexPath.row;
             othercell.delButton.accessibilityHint=[@"" stringByAppendingFormat:@"%ld",(long)indexPath.section];
             
             tableCell = othercell;
         }
    
    return tableCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == shoppingtable) {
        if (![Utility isEmptyCheck:shoppingListArray]) {
            NSMutableDictionary *dict = [shoppingListArray objectAtIndex:indexPath.section];
            if (![Utility isEmptyCheck:dict]) {
                NSMutableArray *shoppingDataArray=[[dict objectForKey:@"shoppingData"]mutableCopy];
                if(!isShowCompleted){
                    shoppingDataArray = [[shoppingDataArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IsPurchased == %@)", [NSNumber numberWithBool:isShowCompleted]]] mutableCopy];
                }
                NSMutableDictionary *shoppingDataDict = [[shoppingDataArray objectAtIndex:indexPath.row]mutableCopy];
                if (![Utility isEmptyCheck:shoppingDataDict]) {
                    mealNameList = [shoppingDataDict objectForKey:@"MealList"];
                    if (![Utility isEmptyCheck:mealNameList]) {
                        mealNameView.hidden = false;
                        [mealNameTable reloadData];
                    }
                }
            }
        }
    }
}
#pragma mark - End

-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{ //ss15
    if (sender == filterButton) {
        //NSLog(@"%@",selectedValue);
        if (![Utility isEmptyCheck:selectedValue]) {
            filtervalue = selectedValue;
            [filterButton setTitle:filtervalue forState:UIControlStateNormal];
            shoppingPref = (int)[filterArray indexOfObject:filtervalue];
            if (isCustom) {
                [self getSquadCustomShoppingListSettings];
            }else{
                [self getShoppinglistDataWithSettings];
            }

        }
        
    }else{
        if (![Utility isEmptyCheck:selectedValue]) {
            isChanged=true;   //add_new_7/8/17
            selectedCategory = (int)[catagoryarray indexOfObject:selectedValue];
            isSaved=false;
            [addShoppingTable reloadData];
        }
    }
}
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender{
    if ([type caseInsensitiveCompare:@"Serve"] == NSOrderedSame) {
        [sender setTitle:[selectedData objectForKey:@"value"] forState:UIControlStateNormal];
        selectedServe = selectedData;
        [serveButton setTitle:selectedServe[@"value"] forState:UIControlStateNormal];
        [shoppingtable reloadData];
        [otherShoppingTable reloadData];
    }
}
/*
- (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option{
    NSLog(@"%@",option);
    NSLog(@"settingIndex-%d",settingIndex);
    if (settingIndex == 0) {
        if (![Utility isEmptyCheck:option]) {
            if ([option isEqualToString:@"0"]) {
                [filterButton setTitle:@"All" forState:UIControlStateNormal];
            }else if ([option isEqualToString:@"1"]) {
                [filterButton setTitle:@"Got it" forState:UIControlStateNormal];
            }else if ([option isEqualToString:@"2"]) {
                [filterButton setTitle:@"Still to get" forState:UIControlStateNormal];
            }
            shoppingPref = [option intValue];
            [self getShoppinglistDataWithSettings];
        }

    }else if (settingIndex == 1){
        if (![Utility isEmptyCheck:option]) {
            selectedCategory =[option intValue];
            isSaved=false;
            [addShoppingTable reloadData];
        }

    }
}
-(void)didCancelOption{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */
#pragma mark - End


#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.



- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSInteger orientation=[UIDevice currentDevice].orientation;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        //ios7
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.height, kbSize.width);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    else {
        //iOS 8 specific code here
        if (UIDeviceOrientationIsLandscape(orientation))
        {
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }else if (UIDeviceOrientationIsPortrait(orientation)){
            kbSize=CGSizeMake(kbSize.width, kbSize.height);
        }
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = mainScroll.frame;
        CGRect frame = [mainScroll convertRect:activeTextField.frame fromView:activeTextField.superview];
        aRect.size.height -= kbSize.height;
        CGPoint tempPoint = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height);
        if (!CGRectContainsPoint(aRect,tempPoint) ) {
            [mainScroll scrollRectToVisible:frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
//    if (![Utility isEmptyCheck:textField]) {
//        [addShoppingTable reloadData];
//    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    isChanged = YES; //add_new_7/8/17
    [textField setInputAccessoryView:toolBar];
    activeTextField = textField;
    //[addShoppingTable reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    activeTextField = nil;
    if (![Utility isEmptyCheck:textField.text]) {
        isSaved=false;
        [addShoppingTable reloadData];
    }
}

#pragma mark - End

#pragma mark - Local Notification Observer

-(void)quitList:(NSNotification *)notification{
    
    NSString *text = notification.object;
    
    
    if([text isEqualToString:@"homeButtonPressed"]){
        [self homeButtonPressed:0];
    }else{
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForShoppingList:)]) {
            [delegate didCheckAnyChangeForShoppingList:NO];
        }
        [self backButtonPressed:0];
    }
    
}
#pragma mark - End
@end

