  //
//  EditCircuitViewController.m
//  Squad
//
//  Created by AQB SOLUTIONS on 24/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "EditCircuitViewController.h"
#import "EditSessionExerciseView.h"
#import "Utility.h"
#import "IndividualExerciseViewController.h"
#import "EditExerciseSessionViewController.h"
#import "CircuitListViewController.h"

@interface EditCircuitViewController () {
    IBOutlet UIStackView *mainStackView;
    IBOutlet UITextField *titleTextField;
    IBOutlet UITextView *instructionTextView;
    IBOutlet UITextView *tipsTextView;
    IBOutlet UIButton *bodyTypeButton;
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UIButton *addExerciseButton;   //ah 2.5
    
    EditSessionExerciseView *exerciseView;
    
    NSMutableDictionary *circuitDict;
    
    int sequenceCount;
    NSMutableArray *exerciseArray;
    NSMutableArray *bodyTypeArray;
    
    UITextField *activeTextField;
    UITextView *activeTextView;
    
    UIView *contentView;
    UIToolbar* numberToolbar;

    NSMutableDictionary *submitDict;
    BOOL isNewAdded;

    NSArray *repsUnitArray;
    NSArray *restUnitArray;
    
    NSMutableArray *addOptionsArray;
    NSMutableArray *supersetOptionsArray;
    NSArray *exerciseListArray;

    NSString *supersetSetValue;
    
    int newSupersetSet;
}

@end

@implementation EditCircuitViewController
//ah ce(replace)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleTextField.text = @"";
    [titleTextField setAccessibilityHint:@"CircuitTitle"];
    [instructionTextView setAccessibilityHint:@"CircuitInstruction"];
    [tipsTextView setAccessibilityHint:@"CircuitTip"];

    sequenceCount = 0;
    submitDict = [[NSMutableDictionary alloc] init];
    bodyTypeArray = [[NSMutableArray alloc] init];
    isNewAdded = NO;
    supersetSetValue = @"";
    
    newSupersetSet = 0;

    if (_isNewCkt) {
        addExerciseButton.hidden = false;
    } else {
        addExerciseButton.hidden = true;
    }
    
    bodyTypeArray = [@[
                       @{
                           @"id" : @1,
                           @"name" : @"FullBody"
                           },
                       @{
                           @"id" : @3,
                           @"name" : @"UpperBody"
                           },
                       @{
                           @"id" : @2,
                           @"name" : @"LowerBody"
                           },
                       @{
                           @"id" : @4,
                           @"name" : @"Core"
                           }
                       ] mutableCopy];
    
    numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone  target:self action:@selector(doneWithFirstResponder)],nil];
    [numberToolbar sizeToFit];
    tipsTextView.inputAccessoryView = numberToolbar;
    instructionTextView.inputAccessoryView = numberToolbar;
    
    [self registerForKeyboardNotifications];
    
    [self getCircuitDetailsFor:@"FirstTime" Sequence:0];

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //ah ux2
    addOptionsArray = [@[
                        /* @{
                             @"Name" : @"Add new exercise above",
                             @"LocalId" : @1
                             },*/
                         @{
                             @"Name" : @"Add new exercise below",
                             @"LocalId" : @3
                             },
                         ] mutableCopy];
    
    supersetOptionsArray = [@[
                              @{
                                  @"Name" : @"Super Set with above exercise",
                                  @"LocalId" : @1
                                  },
                              @{
                                  @"Name" : @"Super Set with below exercise",
                                  @"LocalId" : @2
                                  }
                              ] mutableCopy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(IBAction)homeButtonPressed:(UIButton*)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(IBAction)doneButtonTapped:(id)sender {    //ah 5.5
    if (![Utility isEmptyCheck:_fromController] && [_fromController caseInsensitiveCompare:@"list"] == NSOrderedSame) {
        
        //Local_catch
        if ([_editCktDelegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [_editCktDelegate didCheckAnyChange:true];
        }
        //Local_catch
        
//        CircuitListViewController *controller = (CircuitListViewController*)self.presentingViewController.presentingViewController;       
//        
////        if ([controller isKindOfClass:[CircuitListViewController class]]) {
////            [controller circuitOrMyCircuitListButtonPressed:controller.mycircuitButton];
////        }
//        [_editCircuitDelegate doneCircuitEdit];
//        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
//            [_editCircuitDelegate doneCircuitEdit];
//        }];
        
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];

    } else if (![Utility isEmptyCheck:_fromController] && [_fromController caseInsensitiveCompare:@"editList"] == NSOrderedSame) {   //ah 5.5
        //Local_catch
        if ([_editCktDelegate respondsToSelector:@selector(didCheckAnyChange:)]) {
            [_editCktDelegate didCheckAnyChange:true];
        }
         //Local_catch
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self doneEditing];
    }
}

-(IBAction)backButtonPressed:(id)sender{
    //Local_catch
    if ([_editCktDelegate respondsToSelector:@selector(didCheckAnyChange:)]) {
        [_editCktDelegate didCheckAnyChange:false];
    }
    //Local_catch
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)bodyTypeButtonTapped:(UIButton *)sender {
    int selectedIndex = -1;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(id == %d)",sender.tag];
    NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count > 0) {
        NSDictionary *dict1 = [filteredArray objectAtIndex:0];
        selectedIndex = (int)[bodyTypeArray indexOfObject:dict1];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = bodyTypeArray;
        controller.mainKey = @"name";
        controller.apiType = @"BodyType";
        controller.selectedIndex = selectedIndex;
        controller.sender = sender;
        controller.delegate = self;
        controller.shouldScrollToIndexpath = YES;
        [self presentViewController:controller animated:YES completion:nil];
    });
}

-(IBAction)exerciseNameButtonTapped:(UIButton *)sender {
    if (![Utility isEmptyCheck:exerciseListArray]) {
        int selectedIndex = -1;
        for (int i = 0; i < exerciseListArray.count; i++) {
            int eid = [[[exerciseListArray objectAtIndex:i] objectForKey:@"ExerciseId"] intValue];
            if (eid == [sender tag]) {
                selectedIndex = i;
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.dropdownDataArray = exerciseListArray;
            controller.mainKey = @"ExerciseName";
            controller.apiType = @"ExerciseName";
            controller.selectedIndex = selectedIndex;
            controller.sender = sender;
            controller.delegate = self;
            controller.shouldScrollToIndexpath = NO;    //ah 8.5
            [self presentViewController:controller animated:YES completion:nil];
        });
        
    } else {
        [self getExerciseListWithSender:sender SelectedIndex:sender.tag];
    }
}
-(IBAction)repUnitButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [activeTextView resignFirstResponder];
        [activeTextField resignFirstResponder];
        
        if (![Utility isEmptyCheck:repsUnitArray]) {
            int selectedIndex = -1;
            for (int i = 0; i < repsUnitArray.count; i++) {
                int eid = [[[repsUnitArray objectAtIndex:i] objectForKey:@"Id"] intValue];
                int repUnitID = (int)sender.tag;
                if (eid == repUnitID) {
                    selectedIndex = i;
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                controller.modalPresentationStyle = UIModalPresentationCustom;
                controller.dropdownDataArray = repsUnitArray;
                controller.mainKey = @"RepsUnitType";
                controller.apiType = @"RepsUnit";
                controller.selectedIndex = selectedIndex;
                controller.sender = sender;
                controller.delegate = self;
                controller.shouldScrollToIndexpath = NO;    //ah 8.5
                [self presentViewController:controller animated:YES completion:nil];
            });
            
        } else {
            [self getRepUnitWithSender:sender];
        }
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)restUnitButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [activeTextView resignFirstResponder];
        [activeTextField resignFirstResponder];
        
        if (![Utility isEmptyCheck:restUnitArray]) {
            int selectedIndex = -1;
            for (int i = 0; i < restUnitArray.count; i++) {
                int eid = [[[restUnitArray objectAtIndex:i] objectForKey:@"Id"] intValue];
                int repUnitID = (int)sender.tag;
                if (eid == repUnitID) {
                    selectedIndex = i;
                    break;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                controller.modalPresentationStyle = UIModalPresentationCustom;
                controller.dropdownDataArray = restUnitArray;
                controller.mainKey = @"RestUnitType";
                controller.apiType = @"RestUnit";
                controller.selectedIndex = selectedIndex;
                controller.sender = sender;
                controller.delegate = self;
                controller.shouldScrollToIndexpath = YES;
                [self presentViewController:controller animated:YES completion:nil];
            });
            
        } else {
            [self getRestUnitWithSender:sender];
        }
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)exerciseViewButtonTapped:(UIButton*)sender {
    IndividualExerciseViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"IndividualExercise"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.exerciseId = (int)[sender tag];
    [self presentViewController:controller animated:YES completion:nil];
}
-(IBAction)upArrowButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [activeTextView resignFirstResponder];
        [activeTextField resignFirstResponder];
        
        if (sender.tag > 0) {
            NSInteger sequenceNo = sender.tag;
            [self getCircuitDetailsFor:@"UpArrow" Sequence:sequenceNo];
        } else {
            [Utility msg:@"Already at the top position" title:@"Error!" controller:self haveToPop:NO];
        }
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}

-(IBAction)downArrowButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [activeTextView resignFirstResponder];
        [activeTextField resignFirstResponder];
        
        if (sender.tag < exerciseArray.count-1) {
            NSInteger sequenceNo = sender.tag;
            [self getCircuitDetailsFor:@"DownArrow" Sequence:sequenceNo];
        } else {
            [Utility msg:@"Already at the bottom position" title:@"Error!" controller:self haveToPop:NO];
        }
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}

-(IBAction)addButtonTapped:(UIButton *)sender {
    //        [self getExerciseDetailsFor:@"AddNew" WithSequence:sender.tag];
    if (!isNewAdded) {
        [activeTextView resignFirstResponder];
        [activeTextField resignFirstResponder];
        
        int selectedIndex = -1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
            controller.modalPresentationStyle = UIModalPresentationCustom;
            controller.dropdownDataArray = addOptionsArray;
            controller.mainKey = @"Name";
            controller.apiType = @"AddNew";
            controller.selectedIndex = selectedIndex;
            controller.sender = sender;
            controller.delegate = self;
            controller.shouldScrollToIndexpath = YES;
            [self presentViewController:controller animated:YES completion:nil];
        });
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}

-(IBAction)removeButtonTapped:(UIButton *)sender {
    //    if (!isNewAdded) {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Comfirm Delete"
                                          message:@"Do you really want to delete?"
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Delete"
                               style:UIAlertActionStyleDestructive
                               handler:^(UIAlertAction *action)
                               {
                                   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Id == %d)",(int)sender.tag];
                                   NSDictionary *dict;
                                   NSMutableArray *arr = [[NSMutableArray alloc]init];
                                   NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                                   
                                   if ([sender.accessibilityHint caseInsensitiveCompare:@"Circuit"] == NSOrderedSame) {
                                       NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedCircuits"] filteredArrayUsingPredicate:predicate];
                                       if (filteredSessionCategoryArray.count > 0) {
                                           dict = [filteredSessionCategoryArray objectAtIndex:0];
                                           
                                           [arr addObjectsFromArray:[submitDict objectForKey:@"EditedCircuits"]];
                                           [arr removeObject:dict];
                                           [arr1 addObject:dict];
                                           [submitDict setObject:arr forKey:@"EditedCircuits"];
                                           [submitDict setObject:arr1 forKey:@"RemovedCircuits"];
                                           
                                           [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedCircuits"];
                                           [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedExercises"];
                                       } else {
                                           filteredSessionCategoryArray = [[submitDict objectForKey:@"AddedCircuits"] filteredArrayUsingPredicate:predicate];
                                           if (filteredSessionCategoryArray.count > 0) {
                                               dict = [filteredSessionCategoryArray objectAtIndex:0];
                                               
                                               [arr addObjectsFromArray:[submitDict objectForKey:@"AddedCircuits"]];
                                               [arr removeObject:dict];
                                               [arr1 addObject:dict];
                                               [submitDict setObject:arr forKey:@"AddedCircuits"];
                                               [submitDict setObject:arr1 forKey:@"RemovedCircuits"];
                                               
                                               [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedCircuits"];
                                               [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedExercises"];
                                           } else {
                                               [Utility msg:@"Something went wrong!" title:@"Oops!" controller:self haveToPop:NO];
                                           }
                                       }
                                       
                                       
                                       [self saveDataWithRefresh:YES];
                                   } else if ([sender.accessibilityHint caseInsensitiveCompare:@"Exercise"] == NSOrderedSame) {
                                       NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
                                       if (filteredSessionCategoryArray.count > 0) {
                                           dict = [filteredSessionCategoryArray objectAtIndex:0];
                                           
                                           [arr addObjectsFromArray:[submitDict objectForKey:@"EditedExercises"]];
                                           [arr removeObject:dict];
                                           [arr1 addObject:dict];
                                           [submitDict setObject:arr forKey:@"EditedExercises"];
                                           [submitDict setObject:arr1 forKey:@"RemovedExercises"];
                                           
                                           [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedExercises"];
                                           [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedCircuits"];
                                       } else {
                                           filteredSessionCategoryArray = [[submitDict objectForKey:@"AddedExercises"] filteredArrayUsingPredicate:predicate];
                                           if (filteredSessionCategoryArray.count > 0) {
                                               dict = [filteredSessionCategoryArray objectAtIndex:0];
                                               
                                               [arr addObjectsFromArray:[submitDict objectForKey:@"AddedExercises"]];
                                               [arr removeObject:dict];
                                               [arr1 addObject:dict];
                                               [submitDict setObject:arr forKey:@"AddedExercises"];
                                               [submitDict setObject:arr1 forKey:@"RemovedExercises"];
                                               
                                               [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedExercises"];
                                               [self setupSequences:[sender.accessibilityValue intValue] AfterDelete:@"EditedCircuits"];
                                           } else {
                                               [Utility msg:@"Something went wrong!" title:@"Oops!" controller:self haveToPop:NO];
                                           }
                                       }
                                       
                                       
                                       [self saveDataWithRefresh:YES];
                                   }else if ([sender.accessibilityHint caseInsensitiveCompare:@"SuperSetExercise"] == NSOrderedSame) {  //ah 2.5
                                       predicate = [NSPredicate predicateWithFormat:@"(SequenceNo == %d)",(int)sender.tag];
                                       NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
                                       if (filteredSessionCategoryArray.count > 0) {
                                           [arr addObjectsFromArray:[submitDict objectForKey:@"EditedExercises"]];
                                           
                                           for (int i = 0; i < filteredSessionCategoryArray.count; i++) {
                                               dict = [filteredSessionCategoryArray objectAtIndex:i];
                                               
                                               [arr removeObject:dict];
                                               [arr1 addObject:dict];
                                               [submitDict setObject:arr forKey:@"EditedExercises"];
                                               [submitDict setObject:arr1 forKey:@"RemovedExercises"];
                                           }
                                           
                                           [self setupSequences:(int)sender.tag AfterDelete:@"EditedExercises"];
                                           [self setupSequences:(int)sender.tag AfterDelete:@"EditedCircuits"];
                                       } else {
                                           filteredSessionCategoryArray = [[submitDict objectForKey:@"AddedExercises"] filteredArrayUsingPredicate:predicate];
                                           if (filteredSessionCategoryArray.count > 0) {
                                               [arr addObjectsFromArray:[submitDict objectForKey:@"AddedExercises"]];
                                               
                                               for (int i = 0; i < filteredSessionCategoryArray.count; i++) {
                                                   dict = [filteredSessionCategoryArray objectAtIndex:i];
                                                   
                                                   [arr removeObject:dict];
                                                   [arr1 addObject:dict];
                                                   [submitDict setObject:arr forKey:@"AddedExercises"];
                                                   [submitDict setObject:arr1 forKey:@"RemovedExercises"];
                                               }
                                               
                                               [self setupSequences:(int)sender.tag AfterDelete:@"EditedExercises"];
                                               [self setupSequences:(int)sender.tag AfterDelete:@"EditedCircuits"];
                                           } else {
                                               [Utility msg:@"Something went wrong!" title:@"Oops!" controller:self haveToPop:NO];
                                           }
                                       }
                                       
                                       
                                       [self saveDataWithRefresh:YES];
                                   }
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
    //    } else {
    //        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    //    }
    
}
-(IBAction)addSupersetButtonTapped:(id)sender {
    int selectedIndex = -1;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = supersetOptionsArray;
        controller.mainKey = @"Name";
        controller.apiType = @"AddSuperset";
        controller.selectedIndex = selectedIndex;
        controller.sender = sender;
        controller.delegate = self;
        controller.shouldScrollToIndexpath = NO;
        [self presentViewController:controller animated:YES completion:nil];
    });
}
-(IBAction)supersetUpButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [self getCircuitDetailsFor:@"SupersetUp" Sequence:sender.tag];
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)supersetDownButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        [self getCircuitDetailsFor:@"SupersetDown" Sequence:sender.tag];
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)cktEditButtonTapped:(UIButton*)sender {
    if (!isNewAdded) {
        //        [self getCircuitWithID:[sender tag] Purpose:@"Edit"];
        EditCircuitViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditCircuit"];
        controller.cktID = (int)[sender tag];
        controller.exSessionId = (int)_exSessionId;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)createCircuitButtonTapped:(id)sender {
    if (!isNewAdded) {
        
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}

//-(IBAction)addExerciseButtonTapped:(id)sender {
//    if (!isNewAdded) {
//        addButtonsStackView.hidden = true;
//        
//        NSInteger sequence = 0;
//        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
//        [dict setObject:@"--Select--" forKey:@"Name"];
//        [dict setObject:@"Reps" forKey:@"RepsUnitText"];
//        [dict setObject:[NSNumber numberWithInt:1] forKey:@"RepsUnit"];
//        [dict setObject:@"Seconds" forKey:@"RestUnitText"];
//        [dict setObject:[NSNumber numberWithInt:2] forKey:@"RestUnitId"];
//        [dict setObject:@"" forKey:@"ExerciseRepGoal"];
//        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetCount"];
//        [dict setObject:@"" forKey:@"RestComment"];
//        [dict setObject:[NSNumber numberWithInt:0] forKey:@"IsSuperSet"];
//        [dict setObject:[NSArray new] forKey:@"Tips"];
//        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCircuit"];
//        
//        [exerciseArray insertObject:dict atIndex:sequence];
//        
//        [self setupViewForAddNewWithDict:dict Sequence:(int)sequence SeqNo:(int)sequence];
//    } else {
//        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
//    }
//}
//
//-(IBAction)addCircuitButtonTapped:(id)sender {
//    if (!isNewAdded) {
//        addButtonsStackView.hidden = true;
//        
//        NSInteger sequence = 0;
//        
//        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//        [dict setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
//        [dict setObject:@"--Select--" forKey:@"Name"];
//        [dict setObject:@"Reps" forKey:@"RepsUnitText"];
//        [dict setObject:[NSNumber numberWithInt:1] forKey:@"RepsUnit"];
//        [dict setObject:@"Seconds" forKey:@"RestUnitText"];
//        [dict setObject:[NSNumber numberWithInt:2] forKey:@"RestUnitId"];
//        [dict setObject:@"" forKey:@"ExerciseRepGoal"];
//        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetCount"];
//        [dict setObject:@"" forKey:@"RestComment"];
//        [dict setObject:[NSNumber numberWithInt:0] forKey:@"IsSuperSet"];
//        [dict setObject:[NSArray new] forKey:@"Tips"];
//        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsCircuit"];
//        
//        [dataArray insertObject:dict atIndex:sequence];
//        
//        [self setupViewForAddNewWithDict:dict Sequence:(int)sequence SeqNo:(int)sequence];
//    } else {
//        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
//    }
//}
-(IBAction)supersetUndoButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        //change others sequence
        NSPredicate *newOthersPredicate = [NSPredicate predicateWithFormat:@"SequenceNo > %d",(int)sender.tag];
        
        NSArray *newOthersFilteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:newOthersPredicate];
        if (newOthersFilteredSessionCategoryArray.count > 0) {
            for (int i = 0; i < newOthersFilteredSessionCategoryArray.count; i++) {
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[newOthersFilteredSessionCategoryArray objectAtIndex:i]];
                
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
                [arr removeObject:dict];
                
                int seq = [[dict objectForKey:@"SequenceNo"] intValue];
                [dict setObject:[NSNumber numberWithInteger:seq+1] forKey:@"SequenceNo"];
                
                [arr addObject:dict];
                [submitDict setObject:arr forKey:@"EditedExercises"];
            }
        }
        
        
        //change self seq and issuperSet
        NSPredicate *newPredicate1 = [NSPredicate predicateWithFormat:@"IsSuperSet == %d",[sender.accessibilityHint intValue]];
        NSPredicate *newPredicate2 = [NSPredicate predicateWithFormat:@"SequenceNo == %d",(int)sender.tag];
        NSPredicate *newPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[newPredicate1, newPredicate2]];
        
        NSArray *newFilteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:newPredicate];
        if (newFilteredSessionCategoryArray.count > 0) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[newFilteredSessionCategoryArray objectAtIndex:0]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
            [arr removeObject:dict];
            
            int seq = [[dict objectForKey:@"SequenceNo"] intValue];
            if ([sender.accessibilityHint intValue] > 1) {  //ah 9.5
                [dict setObject:[NSNumber numberWithInteger:seq+1] forKey:@"SequenceNo"];
            }
            
            [dict setObject:[NSNumber numberWithInteger:0] forKey:@"IsSuperSet"];
            
            [arr addObject:dict];
            [submitDict setObject:arr forKey:@"EditedExercises"];
        }
        
        
        //change others below within superSet
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"IsSuperSet > %d",[sender.accessibilityHint intValue]];
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SequenceNo == %d",(int)sender.tag];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
        
        NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
        if (filteredSessionCategoryArray.count > 0) {
            for (int i = 0; i < filteredSessionCategoryArray.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[filteredSessionCategoryArray objectAtIndex:i]];
                
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
                [arr removeObject:dict];
                
                int isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue];
                
                [dict setObject:[NSNumber numberWithInteger:isSuperSet-1] forKey:@"IsSuperSet"];
                
                if ([sender.accessibilityHint intValue] == 1) { //ah 9.5
                    int seq = [[dict objectForKey:@"SequenceNo"] intValue];
                    [dict setObject:[NSNumber numberWithInteger:seq+1] forKey:@"SequenceNo"];
                }
                
                [arr addObject:dict];
                [submitDict setObject:arr forKey:@"EditedExercises"];
            }
        }
        
        
        //change isSuperset to 0 if only 1 superSet is left
        NSPredicate *supersetPredicate = [NSPredicate predicateWithFormat:@"SequenceNo == %d",(int)sender.tag];
        
        NSArray *filteredSupersetArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:supersetPredicate];
        if (filteredSupersetArray.count == 1) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[filteredSupersetArray objectAtIndex:0]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
            [arr removeObject:dict];
            
            [dict setObject:[NSNumber numberWithInteger:0] forKey:@"IsSuperSet"];
            
            [arr addObject:dict];
            [submitDict setObject:arr forKey:@"EditedExercises"];
        }
        
        [self saveDataWithRefresh:YES];
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)supersetRemoveButtonTapped:(UIButton *)sender {
    if (!isNewAdded) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Comfirm Delete"
                                              message:@"Do you really want to delete?"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Delete"
                                   style:UIAlertActionStyleDestructive
                                   handler:^(UIAlertAction *action) {
                                       
                                       NSPredicate *deletePredicate1 = [NSPredicate predicateWithFormat:@"IsSuperSet == %d",[sender.accessibilityHint intValue]];
                                       NSPredicate *deletePredicate2 = [NSPredicate predicateWithFormat:@"SequenceNo == %d",(int)sender.tag];
                                       NSPredicate *deletePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[deletePredicate1, deletePredicate2]];
                                       
                                       NSArray *filteredSessionCategoryArrayDelete = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:deletePredicate];
                                       if (filteredSessionCategoryArrayDelete.count > 0) {
                                           NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[filteredSessionCategoryArrayDelete objectAtIndex:0]];
                                           
                                           NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
                                           [arr removeObject:dict];
                                           
                                           NSMutableArray *arr1 = [[NSMutableArray alloc] init];
                                           [arr1 addObject:dict];
                                           
                                           [submitDict setObject:arr forKey:@"EditedExercises"];
                                           [submitDict setObject:arr1 forKey:@"RemovedExercises"];
                                       }
                                       
                                       
                                       NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"IsSuperSet > %d",[sender.accessibilityHint intValue]];
                                       NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SequenceNo == %d",(int)sender.tag];
                                       NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
                                       
                                       NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
                                       if (filteredSessionCategoryArray.count > 0) {
                                           for (int i = 0; i < filteredSessionCategoryArray.count; i++) {
                                               NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[filteredSessionCategoryArray objectAtIndex:i]];
                                               
                                               NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
                                               [arr removeObject:dict];
                                               
                                               int isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue];
                                               
                                               [dict setObject:[NSNumber numberWithInteger:isSuperSet-1] forKey:@"IsSuperSet"];
                                               
                                               [arr addObject:dict];
                                               [submitDict setObject:arr forKey:@"EditedExercises"];
                                           }
                                       }
                                       
                                       [self saveDataWithRefresh:YES];
                                       
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
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
-(IBAction)addExerciseButtonTapped:(id)sender { //ah 5.5
    if (!isNewAdded) {
        addExerciseButton.hidden = true;
        
        NSInteger sequence = 0;
        int seqNo = 0;
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
        [dict setObject:@"--Select--" forKey:@"Name"];
        [dict setObject:@"" forKey:@"RepsUnitText"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"RepsUnit"];
        [dict setObject:@"" forKey:@"RestUnitText"];
        [dict setObject:[NSNumber numberWithInt:2] forKey:@"RestUnitId"];
        [dict setObject:@"" forKey:@"ExerciseRepGoal"];
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetCount"];
        [dict setObject:@"" forKey:@"RestComment"];
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"IsSuperSet"];
        [dict setObject:[NSArray new] forKey:@"Tips"];
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCircuit"];
        
        [exerciseArray insertObject:dict atIndex:sequence];
        
        [self setupViewForAddNewWithDict:dict Sequence:(int)sequence SeqNo:seqNo];
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
    }
}
#pragma mark - APICall
-(void)getCircuitDetailsFor:(NSString *)purpose Sequence:(NSInteger)sequence {
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
        [mainDict setObject:[NSNumber numberWithInt:_cktID] forKey:@"CircuitId"];
        [mainDict setObject:[NSNumber numberWithInt:_exSessionId] forKey:@"ExerciseSessionId"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetCircuitDetails" append:@""forAction:@"POST"];
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
                                                                         if ([purpose caseInsensitiveCompare:@"FirstTime"] == NSOrderedSame) {
                                                                             NSDictionary *cktDetails = [responseDict objectForKey:@"CircuitDetails"];
                                                                             
                                                                             titleTextField.text = [cktDetails objectForKey:@"CircuitName"];
                                                                             
                                                                             instructionTextView.text = (![Utility isEmptyCheck:[cktDetails objectForKey:@"Instructions"]] && [[cktDetails objectForKey:@"Instructions"] isKindOfClass:[NSArray class]]) ? [[cktDetails objectForKey:@"Instructions"] objectAtIndex:0] : @"";
                                                                             
                                                                             tipsTextView.text = (![Utility isEmptyCheck:[cktDetails objectForKey:@"Tips"]] && [[cktDetails objectForKey:@"Tips"] isKindOfClass:[NSArray class]]) ? [[cktDetails objectForKey:@"Tips"] objectAtIndex:0] : @"";
                                                                             
                                                                             
                                                                             if ([[cktDetails objectForKey:@"FullBody"] boolValue]) {
                                                                                 [bodyTypeButton setTitle:@"FullBody" forState:UIControlStateNormal];
                                                                                 
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == 'FullBody')"];
                                                                                 NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
                                                                                 if (filteredArray.count > 0) {
                                                                                     NSDictionary *dict1 = [filteredArray objectAtIndex:0];
                                                                                     [bodyTypeButton setTag:[[dict1 objectForKey:@"id"] integerValue]];
                                                                                 }
                                                                             } else if ([[cktDetails objectForKey:@"UpperBody"] boolValue]) {
                                                                                 [bodyTypeButton setTitle:@"UpperBody" forState:UIControlStateNormal];
                                                                                 
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == 'UpperBody')"];
                                                                                 NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
                                                                                 if (filteredArray.count > 0) {
                                                                                     NSDictionary *dict1 = [filteredArray objectAtIndex:0];
                                                                                     [bodyTypeButton setTag:[[dict1 objectForKey:@"id"] integerValue]];
                                                                                 }
                                                                             } else if ([[cktDetails objectForKey:@"LowerBody"] boolValue]) {
                                                                                 [bodyTypeButton setTitle:@"LowerBody" forState:UIControlStateNormal];
                                                                                 
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == 'LowerBody')"];
                                                                                 NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
                                                                                 if (filteredArray.count > 0) {
                                                                                     NSDictionary *dict1 = [filteredArray objectAtIndex:0];
                                                                                     [bodyTypeButton setTag:[[dict1 objectForKey:@"id"] integerValue]];
                                                                                 }
                                                                             } else if ([[cktDetails objectForKey:@"Core"] boolValue]) {
                                                                                 [bodyTypeButton setTitle:@"Core" forState:UIControlStateNormal];
                                                                                 
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == 'Core')"];
                                                                                 NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
                                                                                 if (filteredArray.count > 0) {
                                                                                     NSDictionary *dict1 = [filteredArray objectAtIndex:0];
                                                                                     [bodyTypeButton setTag:[[dict1 objectForKey:@"id"] integerValue]];
                                                                                 }
                                                                             } else {
                                                                                 [bodyTypeButton setTitle:@"--" forState:UIControlStateNormal];
                                                                                 
                                                                             }
                                                                             
                                                                             [exerciseArray removeAllObjects];
                                                                             exerciseArray = [[NSMutableArray alloc] initWithArray:[cktDetails objectForKey:@"CircuitExercises"]];
                                                                             if ([Utility isEmptyCheck:exerciseArray]) {
                                                                                 addExerciseButton.hidden = false;  //ah 22.5
                                                                             }
                                                                             [self prepareViewForFirstTime:YES ShouldRefresh:NO];
                                                                         } else if ([purpose caseInsensitiveCompare:@"UpArrow"] == NSOrderedSame || [purpose caseInsensitiveCompare:@"DownArrow"] == NSOrderedSame) {
                                                                             [exerciseArray removeAllObjects];
                                                                             exerciseArray = [NSMutableArray arrayWithArray:[[responseDict objectForKey:@"CircuitDetails"] objectForKey:@"CircuitExercises"]];
                                                                             [self setupViewForUpDownArrowActionWithSequence:sequence Option:purpose];
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
-(void)getExerciseListWithSender:(UIButton *)sender SelectedIndex:(NSInteger)exID {
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
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetExercisesApiCall" append:@""forAction:@"POST"];
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
                                                                         exerciseListArray = [responseDict objectForKey:@"Exercises"];
                                                                         int selectedIndex = -1;
                                                                         for (int i = 0; i < exerciseListArray.count; i++) {
                                                                             int eid = [[[exerciseListArray objectAtIndex:i] objectForKey:@"ExerciseId"] intValue];
                                                                             if (eid == exID) {
                                                                                 selectedIndex = i;
                                                                             }
                                                                         }
                                                                         
                                                                         DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                                                                         controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                         controller.dropdownDataArray = exerciseListArray;
                                                                         controller.mainKey = @"ExerciseName";
                                                                         controller.apiType = @"ExerciseName";
                                                                         controller.selectedIndex = selectedIndex;
                                                                         controller.sender = sender;
                                                                         controller.delegate = self;
                                                                         controller.shouldScrollToIndexpath = YES;
                                                                         [self presentViewController:controller animated:YES completion:nil];
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
- (void) getRepUnitWithSender:(UIButton *)sender {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetRepsUnits" append:@""forAction:@"GET"];
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
                                                                         repsUnitArray = [responseDict objectForKey:@"obj"];
                                                                         
                                                                         NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"SequenceNo"  ascending:YES];
                                                                         repsUnitArray = [repsUnitArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
                                                                         
                                                                         int selectedIndex = -1;
                                                                         for (int i = 0; i < repsUnitArray.count; i++) {
                                                                             int eid = [[[repsUnitArray objectAtIndex:i] objectForKey:@"Id"] intValue];
                                                                             int repUnitID = (int)sender.tag;
                                                                             if (eid == repUnitID) {
                                                                                 selectedIndex = i;
                                                                             }
                                                                         }
                                                                         
                                                                         DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                                                                         controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                         controller.dropdownDataArray = repsUnitArray;
                                                                         controller.mainKey = @"RepsUnitType";
                                                                         controller.apiType = @"RepsUnit";
                                                                         controller.selectedIndex = selectedIndex;
                                                                         controller.sender = sender;
                                                                         controller.delegate = self;
                                                                         controller.shouldScrollToIndexpath = NO;
                                                                         [self presentViewController:controller animated:YES completion:nil];
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
- (void) getRestUnitWithSender:(UIButton *)sender {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetRestUnits" append:@""forAction:@"GET"];
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
                                                                         restUnitArray = [responseDict objectForKey:@"obj"];
                                                                         
                                                                         int selectedIndex = -1;
                                                                         for (int i = 0; i < restUnitArray.count; i++) {
                                                                             int eid = [[[restUnitArray objectAtIndex:i] objectForKey:@"Id"] intValue];
                                                                             int repUnitID = (int)sender.tag;
                                                                             if (eid == repUnitID) {
                                                                                 selectedIndex = i;
                                                                             }
                                                                         }
                                                                         
                                                                         DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
                                                                         controller.modalPresentationStyle = UIModalPresentationCustom;
                                                                         controller.dropdownDataArray = restUnitArray;
                                                                         controller.mainKey = @"RestUnitType";
                                                                         controller.apiType = @"RestUnit";
                                                                         controller.selectedIndex = selectedIndex;
                                                                         controller.sender = sender;
                                                                         controller.delegate = self;
                                                                         controller.shouldScrollToIndexpath = NO;
                                                                         [self presentViewController:controller animated:YES completion:nil];
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

- (void) doneEditing {
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
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[NSNumber numberWithInt:_cktID] forKey:@"CircuitId"];
        [mainDict setObject:[NSNumber numberWithInt:_oldCktID] forKey:@"OldCircuitId"];
        [mainDict setObject:[NSNumber numberWithInt:_sequence] forKey:@"SequenceNumber"];
        [mainDict setObject:[NSNumber numberWithInt:_exSessionId] forKey:@"ExerciseSessionId"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"ReplaceCircuitInExerciseSessionExercise" append:@""forAction:@"POST"];
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

                                                                      /*   EditExerciseSessionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditExerciseSession"];
                                                                             controller.exSessionId = [[responseDict objectForKey:@"ExerciseSessionId"] intValue];
                                   */
                                                                              //controller.dt = _dt;
                                                                                                                                                  
                                                                         if (_isNewCkt) {
                                                                             
                                                                             EditExerciseSessionViewController *controller = (EditExerciseSessionViewController*)self.presentingViewController.presentingViewController;
                                                                             
                                                                             if ([controller isKindOfClass:[EditExerciseSessionViewController class]]) {
                                                                                 controller.exSessionId = [[responseDict objectForKey:@"ExerciseSessionId"] intValue];  //ah 3.5
                                                                                 
                                                                                 [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                                                                                     [controller getExerciseDetailsFor:@"FirstTime" WithSequence:0];
                                                                                 }];
                                                                             }
                                                                             
                                                                          /*   [   self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:^{
                                                                                   [controller getExerciseDetailsFor:@"FirstTime" WithSequence:0];
                                                                             
                                                                                 
                                                                             }];*/
                                                                             
                                                                         } else {
                                                                             [_editCktDelegate doneEditingWithSessionID:[[responseDict objectForKey:@"ExerciseSessionId"] intValue]];
                                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                                             
                                                                            /* EditExerciseSessionViewController *controller = (EditExerciseSessionViewController*)self.presentingViewController;
                                                                             if ([controller isKindOfClass:[EditExerciseSessionViewController class]]) {
                                                                                 controller.exSessionId = [[responseDict objectForKey:@"ExerciseSessionId"] intValue];  //ah 3.5
                                                                                 
                                                                                 [self dismissViewControllerAnimated:YES completion:^{
                                                                                     [controller getExerciseDetailsFor:@"FirstTime" WithSequence:0];
                                                                                 }];
                                                                             } else {
                                                                                 UINavigationController *navController = (UINavigationController*)self.presentingViewController;
                                                                                 NSLog(@"asd %@",navController.viewControllers);
                                                                                 for (EditExerciseSessionViewController *controller in navController.viewControllers) {
                                                                                     if (controller.exSessionId) {
                                                                                         controller.exSessionId = [[responseDict objectForKey:@"ExerciseSessionId"] intValue];  //ah 3.5
                                                                                         
                                                                                         [self dismissViewControllerAnimated:YES completion:^{
                                                                                             [controller getExerciseDetailsFor:@"FirstTime" WithSequence:0];
                                                                                         }];
                                                                                     }
                                                                                 }
                                                                             }*/
                                                                         }
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

- (void) saveDataWithRefresh:(BOOL) shouldRefresh {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        //        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        //        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        //        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:submitDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"EditCircuitExercise" append:@""forAction:@"POST"];
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
                                                                         _cktID = [[responseDict objectForKey:@"CircuitId"] intValue];
                                                                         [submitDict setObject:[NSNumber numberWithInteger:_cktID] forKey:@"ExerciseSessionId"];
                                                                         [Utility showToastInsideView:self.view WithMessage:@"Saved Successfully"];
                                                                         isNewAdded = NO;
                                                                         NSLog(@"new id %d",[[responseDict objectForKey:@"CircuitId"] intValue]);
                                                                         
                                                                         if (shouldRefresh) {
                                                                             [self getCircuitDetailsFor:@"FirstTime" Sequence:0];
                                                                         }
                                                                     } else{
                                                                         if ([[responseDict objectForKey:@"ErrorMessage"] containsString:@"please give it a new and unique name"]) {
                                                                             [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];     //ah 9.5
                                                                         }
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
#pragma mark - Private Method
- (void) prepareViewForFirstTime:(BOOL)isFirstTime ShouldRefresh:(BOOL)shouldRefresh {
    submitDict = [@{
                    @"Userid" : [defaults objectForKey:@"ABBBCOnlineUserId"],
                    @"CircuitId" : [NSNumber numberWithInteger:_cktID],
                    @"CircuitTitle" : titleTextField.text,
                    @"CircuitTips" : [NSArray new],
                    @"CircuitInstructions" : [NSArray new],
                    @"Tip" : tipsTextView.text,
                    @"Instruction" : instructionTextView.text,
                    @"OverView" : @"",
                    @"BodyType" : [NSNumber numberWithInteger:bodyTypeButton.tag],
                    @"SequenceNo" : [NSNumber numberWithInteger:0],
                    @"AddedExercises" : [NSArray new],
                    @"RemovedExercises" : [NSArray new],
                    @"EditedExercises" : [NSArray new],
                    @"Key" : AccessKey_ABBBC,
                    @"UserSessionID": [defaults objectForKey:@"ABBBCOnlineUserSessionId"]
                    } mutableCopy];

    [mainStackView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    sequenceCount = 0;

    for (int i = 0; i < exerciseArray.count; i++) {
        NSDictionary *dict = [exerciseArray objectAtIndex:i];
        
        if ([[dict objectForKey:@"IsSuperSet"] intValue] < 2) {
            sequenceCount++;
        }
        
        NSArray *exerciseViews = [[NSBundle mainBundle] loadNibNamed:@"EditSessionExerciseView" owner:self options:nil];
        exerciseView = [exerciseViews objectAtIndex:0];
        
        exerciseView.exerciseNumberLabel.text = [NSString stringWithFormat:@"%d",sequenceCount];
        
        [exerciseView.exerciseNameButton setTitle:[dict objectForKey:@"ExerciseName"] forState:UIControlStateNormal];
        [exerciseView.exerciseNameButton addTarget:self action:@selector(exerciseNameButtonTapped:)
                                  forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseNameButton setTag:[[dict objectForKey:@"ExerciseId"] integerValue]];
        
        [exerciseView.repUnitButton setTitle:(![Utility isEmptyCheck:[dict objectForKey:@"RepsUnitText"]]) ? [dict objectForKey:@"RepsUnitText"] : @"" forState:UIControlStateNormal];
        [exerciseView.repUnitButton addTarget:self action:@selector(repUnitButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.repUnitButton setTag:[[dict objectForKey:@"RepsUnit"] integerValue]];
        
        [exerciseView.restUnitButton setTitle:(![Utility isEmptyCheck:[dict objectForKey:@"RestUnitText"]]) ? [dict objectForKey:@"RestUnitText"] : @"" forState:UIControlStateNormal];
        [exerciseView.restUnitButton addTarget:self action:@selector(restUnitButtonTapped:)
                              forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.restUnitButton setTag:[[dict objectForKey:@"RestUnitId"] integerValue]];
        
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"RepGoal"]]) {
            if ([[dict objectForKey:@"RepGoal"] isKindOfClass:[NSString class]]) {
                exerciseView.repGoalTextField.text = [dict objectForKey:@"RepGoal"];
            } else {
                exerciseView.repGoalTextField.text = [[dict objectForKey:@"RepGoal"] stringValue];
            }
        } else {
            exerciseView.repGoalTextField.text = @"";
            [exerciseView.repUnitButton setTitle:@"--" forState:UIControlStateNormal];
            [exerciseView.repUnitButton setTag:9];
        }
        [exerciseView.repGoalTextField setTag:i];
        [exerciseView.repGoalTextField setAccessibilityHint:@"ExerciseRepGoal"];
        exerciseView.repGoalTextField.delegate = self;
        exerciseView.repGoalTextField.inputAccessoryView = numberToolbar;

        
        exerciseView.setTextField.text = (![Utility isEmptyCheck:[dict objectForKey:@"SetCount"]]) ? [[dict objectForKey:@"SetCount"] stringValue] : @"";
        [exerciseView.setTextField setTag:i];
        [exerciseView.setTextField setAccessibilityHint:@"ExerciseSetCount"];
        exerciseView.setTextField.delegate = self;
        exerciseView.setTextField.inputAccessoryView = numberToolbar;

        
        if (![Utility isEmptyCheck:[dict objectForKey:@"RestComment"]]) {
            if ([[dict objectForKey:@"RestComment"] isKindOfClass:[NSString class]]) {
                exerciseView.restTextField.text = [dict objectForKey:@"RestComment"];
            } else {
                exerciseView.restTextField.text = [[dict objectForKey:@"RestComment"] stringValue];
            }
        } else {
            exerciseView.restTextField.text =  @"";
            [exerciseView.restUnitButton setTitle:@"--" forState:UIControlStateNormal];     //ah 5.52
            [exerciseView.restUnitButton setTag:5];
        }
        [exerciseView.restTextField setTag:i];
        [exerciseView.restTextField setAccessibilityHint:@"ExerciseRest"];
        exerciseView.restTextField.delegate = self;
        exerciseView.restTextField.inputAccessoryView = numberToolbar;

        
        exerciseView.exerciseTipsTextView.text = (![Utility isEmptyCheck:[dict objectForKey:@"CircuitExerciseTips"]]) ? [dict objectForKey:@"CircuitExerciseTips"] : @"";
        exerciseView.exerciseTipsTextView.inputAccessoryView = numberToolbar;
        [exerciseView.exerciseTipsTextView setTag:i];
        [exerciseView.exerciseTipsTextView setAccessibilityHint:@"ExerciseTips"];
        exerciseView.exerciseTipsTextView.delegate = self;
        
        
        [exerciseView.exerciseViewButton addTarget:self action:@selector(exerciseViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseViewButton setTag:[[dict objectForKey:@"ExerciseId"] integerValue]];
        
        
        [exerciseView.exerciseUpArrow addTarget:self action:@selector(upArrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseUpArrow setTag:i];
        
        
        [exerciseView.exerciseDownArrow addTarget:self action:@selector(downArrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseDownArrow setTag:i];
        
        
        [exerciseView.exerciseAddButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseAddButton setTag:i];
        
        
        [exerciseView.exerciseRemoveButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        if ([[dict objectForKey:@"IsSuperSet"] intValue] > 0) {
            [exerciseView.exerciseRemoveButton setTag:[[dict objectForKey:@"SequenceNo"] integerValue]];
            [exerciseView.exerciseRemoveButton setAccessibilityHint:@"SuperSetExercise"];
        } else {
            [exerciseView.exerciseRemoveButton setTag:[[dict objectForKey:@"ExerciseId"] integerValue]];
            [exerciseView.exerciseRemoveButton setAccessibilityHint:@"Exercise"];
            [exerciseView.exerciseRemoveButton setAccessibilityValue:[[dict objectForKey:@"SequenceNo"] stringValue]];
        }

        
        [exerciseView.exerciseAddSupersetButton addTarget:self action:@selector(addSupersetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseAddSupersetButton setTag:sequenceCount-1];  //change new
        [exerciseView.exerciseAddSupersetButton setAccessibilityHint:[[dict objectForKey:@"SuperSetPosition"] stringValue]];
        
        
        [exerciseView.supersetUpButton addTarget:self action:@selector(supersetUpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.supersetUpButton setTag:i];
        
        
        [exerciseView.supersetDownButton addTarget:self action:@selector(supersetDownButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.supersetDownButton setTag:i];
        
        
        [exerciseView.supersetUndoButton addTarget:self action:@selector(supersetUndoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.supersetUndoButton setTag:sequenceCount-1];
        [exerciseView.supersetUndoButton setAccessibilityHint:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"IsSuperSet"] intValue]]];
        
        
        [exerciseView.supersetDeleteButton addTarget:self action:@selector(supersetRemoveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.supersetDeleteButton setTag:sequenceCount-1];
        [exerciseView.supersetDeleteButton setAccessibilityHint:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"IsSuperSet"] intValue]]];
        
        
        [exerciseView setTag:i];
        [exerciseView setAccessibilityHint:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"SequenceNo"] intValue]]];
        [exerciseView setAccessibilityValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"IsSuperSet"] intValue]]];
        
        
        if ([[dict objectForKey:@"IsSuperSet"] intValue] > 0) {
            exerciseView.exerciseAddRemoveView.hidden = true;
            exerciseView.exerciseUpArrow.hidden = true;
            exerciseView.exerciseDownArrow.hidden = true;
            exerciseView.exerciseAddSupersetButton.hidden = true;
            exerciseView.exerciseSupersetView.hidden = false;
            
            if ([[dict objectForKey:@"SuperSetPosition"] intValue] == -1) {
                //top
                exerciseView.exerciseUpArrow.hidden = false;
                exerciseView.exerciseDownArrow.hidden = false;
                exerciseView.exerciseAddSupersetButton.hidden = false;
                
                exerciseView.editExerciseSuperviewTopConstraint.constant = 5;
                exerciseView.editExerciseSuperviewBottomConstraint.constant = 0;
                exerciseView.supersetUpButton.hidden = true;
                
                supersetSetValue = exerciseView.setTextField.text;

            } else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 0) {
                //middle
                exerciseView.editExerciseSuperviewTopConstraint.constant = 0;
                exerciseView.editExerciseSuperviewBottomConstraint.constant = 0;
                
                exerciseView.setTextField.userInteractionEnabled = NO;
                exerciseView.exerciseNumberView.hidden = true;
                
                exerciseView.setTextField.text = supersetSetValue;

            }   else if ([[dict objectForKey:@"SuperSetPosition"] intValue] == 1) {
                //bottom
                exerciseView.exerciseAddRemoveView.hidden = false;
                
                exerciseView.editExerciseSuperviewTopConstraint.constant = 0;
                exerciseView.editExerciseSuperviewBottomConstraint.constant = 5;
                
                exerciseView.setTextField.userInteractionEnabled = NO;
                exerciseView.exerciseNumberView.hidden = true;
                exerciseView.supersetDownButton.hidden = true;
                
                exerciseView.setTextField.text = supersetSetValue;
                supersetSetValue = @"";
            }
        } else {
            exerciseView.exerciseAddRemoveView.hidden = false;
            exerciseView.exerciseUpArrow.hidden = false;
            exerciseView.exerciseDownArrow.hidden = false;
            exerciseView.exerciseAddSupersetButton.hidden = false;
            exerciseView.exerciseSupersetView.hidden = true;
            exerciseView.supersetUpButton.hidden = false;
            exerciseView.setTextField.userInteractionEnabled = YES;
            exerciseView.exerciseNumberView.hidden = false;
            exerciseView.supersetDownButton.hidden = false;
            exerciseView.editExerciseSuperviewTopConstraint.constant = 5;
            exerciseView.editExerciseSuperviewBottomConstraint.constant = 5;
        }
        
        
        [mainStackView addArrangedSubview:exerciseView];
        
        //setup edit dict
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        
        [newDict setObject:[dict objectForKey:@"ExerciseId"] forKey:@"Id"];
        [newDict setObject:[dict objectForKey:@"RestComment"] forKey:@"RestComment"];
        [newDict setObject:exerciseView.setTextField.text forKey:@"SetCount"];
        [newDict setObject:[NSNumber numberWithInt:sequenceCount-1] forKey:@"SequenceNo"];
        [newDict setObject:exerciseView.repGoalTextField.text forKey:@"RepGoal"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"OneFromGroup"];
        [newDict setObject:[dict objectForKey:@"IsSuperSet"] forKey:@"IsSuperSet"];
        [newDict setObject:(![Utility isEmptyCheck:[dict objectForKey:@"RepsUnit"]]) ? [dict objectForKey:@"RepsUnit"] : @"" forKey:@"RepUnit"];
        [newDict setObject:(![Utility isEmptyCheck:[dict objectForKey:@"RestUnitId"]]) ? [dict objectForKey:@"RestUnitId"] : @"" forKey:@"RestUnit"];
        if (![Utility isEmptyCheck:exerciseView.exerciseTipsTextView.text]) {
            [newDict setObject:exerciseView.exerciseTipsTextView.text forKey:@"CircuitExerciseTip"];
        } else {
            [newDict setObject:@"" forKey:@"CircuitExerciseTip"];
        }
        
        //            [newDict setObject:@"" forKey:@"NewExerciseId"];
        
        [arr addObject:newDict];
        
        [submitDict setObject:arr forKey:@"EditedExercises"];
        
        //end setup edit dict
    }
    
    if (!isFirstTime) {
        if (shouldRefresh) {
            [self saveDataWithRefresh:YES];
        } else {
            [self saveDataWithRefresh:NO];
        }
    }
}

-(void)doneWithFirstResponder{
    [self.view endEditing:YES];
}

-(void) setupViewForUpDownArrowActionWithSequence:(NSInteger)sequence Option:(NSString *)option{
    if ([option caseInsensitiveCompare:@"UpArrow"] == NSOrderedSame) {
        if (sequence > 0) {
            [exerciseArray exchangeObjectAtIndex:sequence withObjectAtIndex:sequence-1];
            [self prepareViewForFirstTime:NO ShouldRefresh:NO];
        } else {
            [Utility msg:@"Already at the top position" title:@"Error!" controller:self haveToPop:NO];
        }
    } else if ([option caseInsensitiveCompare:@"DownArrow"] == NSOrderedSame) {
        if (sequence < exerciseArray.count-1) {
            [exerciseArray exchangeObjectAtIndex:sequence withObjectAtIndex:sequence+1];
            [self prepareViewForFirstTime:NO ShouldRefresh:NO];
        } else {
            [Utility msg:@"Already at the bottom position" title:@"Error!" controller:self haveToPop:NO];
        }
    }
}

-(void) setupViewForAddNewWithDict:(NSMutableDictionary *)dict Sequence:(int)sequence SeqNo:(int)seqNo {
    isNewAdded = YES;
    
    NSArray *exerciseViews = [[NSBundle mainBundle] loadNibNamed:@"EditSessionExerciseView" owner:self options:nil];
        exerciseView = [exerciseViews objectAtIndex:0];
        
        exerciseView.exerciseNumberLabel.text = [NSString stringWithFormat:@"%d",seqNo+1];
        
        [exerciseView.exerciseNameButton setTitle:[dict objectForKey:@"Name"] forState:UIControlStateNormal];
        [exerciseView.exerciseNameButton addTarget:self action:@selector(exerciseNameButtonTapped:)
                                  forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseNameButton setTag:[[dict objectForKey:@"Id"] integerValue]];
        
        [exerciseView.repUnitButton setTitle:(![Utility isEmptyCheck:[dict objectForKey:@"RepsUnitText"]]) ? [dict objectForKey:@"RepsUnitText"] : @"" forState:UIControlStateNormal];
        [exerciseView.repUnitButton addTarget:self action:@selector(repUnitButtonTapped:)
                             forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.repUnitButton setTag:[[dict objectForKey:@"RepsUnit"] integerValue]];
        
        [exerciseView.restUnitButton setTitle:(![Utility isEmptyCheck:[dict objectForKey:@"RestUnitText"]]) ? [dict objectForKey:@"RestUnitText"] : @"" forState:UIControlStateNormal];
        [exerciseView.restUnitButton addTarget:self action:@selector(restUnitButtonTapped:)
                              forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.restUnitButton setTag:[[dict objectForKey:@"RestUnitId"] integerValue]];
        
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"ExerciseRepGoal"]]) {
            if ([[dict objectForKey:@"ExerciseRepGoal"] isKindOfClass:[NSString class]]) {
                exerciseView.repGoalTextField.text = [dict objectForKey:@"ExerciseRepGoal"];
            } else {
                exerciseView.repGoalTextField.text = [[dict objectForKey:@"ExerciseRepGoal"] stringValue];
            }
        } else {
            exerciseView.repGoalTextField.text = @"";
            [exerciseView.repUnitButton setTitle:@"--" forState:UIControlStateNormal];
            [exerciseView.repUnitButton setTag:9];
        }
        [exerciseView.repGoalTextField setTag:sequence];
        [exerciseView.repGoalTextField setAccessibilityHint:@"ExerciseRepGoal"];
        exerciseView.repGoalTextField.delegate = self;
        
        
        exerciseView.setTextField.text = (![Utility isEmptyCheck:[dict objectForKey:@"SetCount"]]) ? [[dict objectForKey:@"SetCount"] stringValue] : @"";
        [exerciseView.setTextField setTag:sequence];
        [exerciseView.setTextField setAccessibilityHint:@"ExerciseSetCount"];
        exerciseView.setTextField.delegate = self;
        
        
        if (![Utility isEmptyCheck:[dict objectForKey:@"RestComment"]]) {
            if ([[dict objectForKey:@"RestComment"] isKindOfClass:[NSString class]]) {
                exerciseView.restTextField.text = [dict objectForKey:@"RestComment"];
            } else {
                exerciseView.restTextField.text = [[dict objectForKey:@"RestComment"] stringValue];
            }
        } else {
            exerciseView.restTextField.text =  @"";
            [exerciseView.restUnitButton setTitle:@"--" forState:UIControlStateNormal];
            [exerciseView.restUnitButton setTag:5];
        }
        [exerciseView.restTextField setTag:sequence];
        [exerciseView.restTextField setAccessibilityHint:@"ExerciseRest"];
        exerciseView.restTextField.delegate = self;
        
        
        exerciseView.exerciseTipsTextView.text = (![Utility isEmptyCheck:[dict objectForKey:@"Tips"]] && [[dict objectForKey:@"Tips"] isKindOfClass:[NSArray class]]) ? [[dict objectForKey:@"Tips"] objectAtIndex:0] : @"";
        exerciseView.exerciseTipsTextView.inputAccessoryView = numberToolbar;
        [exerciseView.exerciseTipsTextView setTag:sequence];
        [exerciseView.exerciseTipsTextView setAccessibilityHint:@"ExerciseTips"];
        exerciseView.exerciseTipsTextView.delegate = self;
        
        
        [exerciseView.exerciseViewButton addTarget:self action:@selector(exerciseViewButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseViewButton setTag:[[dict objectForKey:@"Id"] integerValue]];
        
        
        [exerciseView.exerciseUpArrow addTarget:self action:@selector(upArrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseUpArrow setTag:sequence];
        
        
        [exerciseView.exerciseDownArrow addTarget:self action:@selector(downArrowButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseDownArrow setTag:sequence];
        
        
        [exerciseView.exerciseAddButton addTarget:self action:@selector(addButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [exerciseView.exerciseAddButton setTag:sequence];
        
        
        [exerciseView.exerciseRemoveButton addTarget:self action:@selector(removeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    if ([[dict objectForKey:@"IsSuperSet"] intValue] > 0) {
        [exerciseView.exerciseRemoveButton setTag:[[dict objectForKey:@"SequenceNo"] integerValue]];
        [exerciseView.exerciseRemoveButton setAccessibilityHint:@"SuperSetExercise"];
    } else {
        [exerciseView.exerciseRemoveButton setTag:[[dict objectForKey:@"ExerciseId"] integerValue]];
        [exerciseView.exerciseRemoveButton setAccessibilityHint:@"Exercise"];
        [exerciseView.exerciseRemoveButton setAccessibilityValue:[[dict objectForKey:@"SequenceNo"] stringValue]];
    }
    
    
        exerciseView.exerciseSupersetView.hidden = true;
        
        
        [exerciseView setTag:seqNo];
        [exerciseView setAccessibilityHint:@"NewAdded"];
        
        [mainStackView insertArrangedSubview:exerciseView atIndex:sequence];
        
        //setup edit dict
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
        
        [newDict setObject:[dict objectForKey:@"Id"] forKey:@"Id"];
        [newDict setObject:[dict objectForKey:@"RestComment"] forKey:@"RestComment"];
        [newDict setObject:exerciseView.setTextField.text forKey:@"SetCount"];
        [newDict setObject:[NSNumber numberWithInteger:seqNo] forKey:@"SequenceNo"];
        [newDict setObject:exerciseView.repGoalTextField.text forKey:@"RepGoal"];
        [newDict setObject:[NSNumber numberWithBool:false] forKey:@"OneFromGroup"];
        [newDict setObject:[dict objectForKey:@"IsSuperSet"] forKey:@"IsSuperSet"];
        [newDict setObject:(![Utility isEmptyCheck:[dict objectForKey:@"RepsUnit"]]) ? [dict objectForKey:@"RepsUnit"] : @"" forKey:@"RepUnit"];
        [newDict setObject:(![Utility isEmptyCheck:[dict objectForKey:@"RestUnitId"]]) ? [dict objectForKey:@"RestUnitId"] : @"" forKey:@"RestUnit"];
        if (![Utility isEmptyCheck:exerciseView.exerciseTipsTextView.text]) {
            [newDict setObject:exerciseView.exerciseTipsTextView.text forKey:@"CircuitExerciseTip"];
        } else {
            [newDict setObject:@"" forKey:@"CircuitExerciseTip"];
        }
        
        //            [newDict setObject:@"" forKey:@"NewExerciseId"];
        
        [arr addObject:newDict];
        
        [submitDict setObject:arr forKey:@"AddedExercises"];
        
        NSMutableArray *newEditArr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
        int newSqCount = -1;
        for (int i = 0; i < newEditArr.count; i++) {
            NSMutableDictionary *newEditDict = [[NSMutableDictionary alloc]initWithDictionary:[newEditArr objectAtIndex:i]];
            if (seqNo <= [[newEditDict objectForKey:@"SequenceNo"] intValue]) {
                newSqCount = [[newEditDict objectForKey:@"SequenceNo"] intValue];
                [newEditDict setObject:[NSNumber numberWithInt:newSqCount+1] forKey:@"SequenceNo"];
                
                [newEditArr removeObjectAtIndex:i];
                [newEditArr insertObject:newEditDict atIndex:i];
            }
        }
        [submitDict setObject:newEditArr forKey:@"EditedExercises"];
        
        //end setup edit dict
    
}
-(UIView *)parents:(UIView *)class_name Subview:(UIButton *)subview{
    UIView *s = subview.superview;
    while (![s isKindOfClass:[class_name class]]) {
        if (s.superview) {
            s = s.superview;
        } else {
            return nil;
        }
    }
    return s;
}
-(NSDictionary *)getDictByValue:(NSArray *)filterArray value:(id)value type:(NSString *)type{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",type, value];
    NSArray *filteredSessionCategoryArray = [filterArray filteredArrayUsingPredicate:predicate];
    if (filteredSessionCategoryArray.count > 0) {
        NSDictionary *dict = [filteredSessionCategoryArray objectAtIndex:0];
        return dict;
    }
    return  nil;
}
-(void) setupCircuitDict:(NSDictionary *)dict AtSequence:(NSInteger) sequence{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedCircuits"]];
    
    for (int i = 0; i < arr.count; i++) {
        if ([[[arr objectAtIndex:i] objectForKey:@"SequenceNo"] integerValue] == sequence) {
            NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
            
            [newDict addEntriesFromDictionary:[arr objectAtIndex:i]];
            
            [newDict setObject:[dict objectForKey:@"CircuitId"] forKey:@"Id"];
            //            [newDict setObject:[dict objectForKey:@"RestComment"] forKey:@"RestComment"];
            [newDict setObject:@"" forKey:@"CircuitRepeat"];
            [newDict setObject:[NSNumber numberWithInteger:sequence] forKey:@"SequenceNo"];
            //            [newDict setObject:@"" forKey:@"NewCircuitId"];
            
            [arr removeObjectAtIndex:i];
            [arr insertObject:newDict atIndex:i];
        }
    }
    
    [submitDict setObject:arr forKey:@"EditedCircuits"];
    [self saveDataWithRefresh:NO];
}
-(void) setupExerciseDict:(NSDictionary *)dict ForKey:(NSString *)dictKeyStr OrText:(NSString *)textStr MainKey:(NSString *)mainKeyStr AtSequence:(NSInteger) sequence IsSuperSet:(NSInteger)isSuperSet {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
    
    for (int i = 0; i < arr.count; i++) {
        if (isSuperSet > 0) {
            if ([[[arr objectAtIndex:i] objectForKey:@"SequenceNo"] integerValue] == sequence && [[[arr objectAtIndex:i] objectForKey:@"IsSuperSet"] integerValue] == isSuperSet) {
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                
                [newDict addEntriesFromDictionary:[arr objectAtIndex:i]];
                
                if (![Utility isEmptyCheck:dict]) {
                    [newDict setObject:[dict objectForKey:dictKeyStr] forKey:mainKeyStr];
                } else if (![Utility isEmptyCheck:textStr]) {
                    [newDict setObject:textStr forKey:mainKeyStr];
                } else {
                    [newDict setObject:@"" forKey:mainKeyStr];
                }
                
                [arr removeObjectAtIndex:i];
                [arr insertObject:newDict atIndex:i];
            }
        } else {
            if ([[[arr objectAtIndex:i] objectForKey:@"SequenceNo"] integerValue] == sequence) {
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                
                [newDict addEntriesFromDictionary:[arr objectAtIndex:i]];
                
                if (![Utility isEmptyCheck:dict]) {
                    [newDict setObject:[dict objectForKey:dictKeyStr] forKey:mainKeyStr];
                } else if (![Utility isEmptyCheck:textStr]) {
                    [newDict setObject:textStr forKey:mainKeyStr];
                } else {
                    [newDict setObject:@"" forKey:mainKeyStr];
                }
                
                [arr removeObjectAtIndex:i];
                [arr insertObject:newDict atIndex:i];
            }
        }
        
    }
    
    [submitDict setObject:arr forKey:@"EditedExercises"];
    if ([mainKeyStr caseInsensitiveCompare:@"SetCount"] == NSOrderedSame) { //ah 8.5
        [self saveDataWithRefresh:YES];
    } else {
        [self saveDataWithRefresh:NO];
    }
}

-(int) setupDictForAddSupersetAboveSelfWithSequence:(NSInteger)sequence AndNewSequence:(NSInteger)newSequence IsSuperSet:(int)isSuperSet{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SequenceNo == %d)",(int)sequence];
    NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
    int newIsSuperSet = isSuperSet;
    if (filteredSessionCategoryArray.count > 0) {
        for (int i = 0; i < filteredSessionCategoryArray.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[filteredSessionCategoryArray objectAtIndex:i]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
            [arr removeObject:dict];
            
            [dict setObject:[NSNumber numberWithInteger:newSequence] forKey:@"SequenceNo"];
            
            [dict setObject:[NSNumber numberWithInteger:newIsSuperSet] forKey:@"IsSuperSet"];
            
            [dict setObject:[NSNumber numberWithInt:newSupersetSet] forKey:@"SetCount"];    //ah 15.51

            [arr addObject:dict];
            [submitDict setObject:arr forKey:@"EditedExercises"];
            
            newIsSuperSet++;
        }
        
        //                            [self saveDataWithRefresh:YES];
        return newIsSuperSet-1;
    } else {
        return 0;
    }
    return 0;
}

-(int) setupDictForAddSupersetAbovePrevWithSequence:(NSInteger)sequence AndNewSequence:(NSInteger)newSequence {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SequenceNo == %d)",(int)sequence];
    NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (filteredSessionCategoryArray.count > 0) {
        dict = [filteredSessionCategoryArray objectAtIndex:0];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
        
        int isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue];
        if ([[dict objectForKey:@"IsSuperSet"] intValue] == 0) {
            [arr removeObject:dict];
            isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue]+1;
            [dict setObject:[NSNumber numberWithInteger:isSuperSet] forKey:@"IsSuperSet"];
            newSupersetSet = [[dict objectForKey:@"SetCount"] intValue];    //ah 15.51

            [arr addObject:dict];
            [submitDict setObject:arr forKey:@"EditedExercises"];
        } else {
            NSArray *sortedArray = [self findHeighestIsSupersetFromArray:arr];
            isSuperSet = [[[sortedArray objectAtIndex:sortedArray.count-1] objectForKey:@"IsSuperSet"] intValue];
        }
        
        //                            [self saveDataWithRefresh:YES];
        return isSuperSet;
    } else {
        return 0;
    }
    return 0;
}
-(int) setupDictForAddSupersetBelowNextWithSequence:(NSInteger)sequence AndNewSequence:(NSInteger)newSequence IsSuperSet:(int)isSuperSet{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SequenceNo == %d)",(int)sequence];
    NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (filteredSessionCategoryArray.count > 0) {
        dict = [filteredSessionCategoryArray objectAtIndex:0];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
        [arr removeObject:dict];
        
        [dict setObject:[NSNumber numberWithInteger:newSequence] forKey:@"SequenceNo"];
        
        [dict setObject:[NSNumber numberWithInteger:isSuperSet] forKey:@"IsSuperSet"];
        
        [dict setObject:[NSNumber numberWithInt:newSupersetSet] forKey:@"SetCount"];     //ah 15.51

        [arr addObject:dict];
        [submitDict setObject:arr forKey:@"EditedExercises"];
        //                            [self saveDataWithRefresh:YES];
        return isSuperSet;
    } else {
        return 0;
    }
    return 0;
}

-(int) setupDictForAddSupersetBelowSelfWithSequence:(NSInteger)sequence AndNewSequence:(NSInteger)newSequence {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(SequenceNo == %d)",(int)sequence];
    NSArray *filteredSessionCategoryArray = [[submitDict objectForKey:@"EditedExercises"] filteredArrayUsingPredicate:predicate];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (filteredSessionCategoryArray.count > 0) {
        dict = [filteredSessionCategoryArray objectAtIndex:0];
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"EditedExercises"]];
        
        int isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue];
        if ([[dict objectForKey:@"IsSuperSet"] intValue] == 0) {    //ah se(replace full controller)
            [arr removeObject:dict];
            isSuperSet = [[dict objectForKey:@"IsSuperSet"] intValue]+1;
            [dict setObject:[NSNumber numberWithInteger:isSuperSet] forKey:@"IsSuperSet"];
            newSupersetSet = [[dict objectForKey:@"SetCount"] intValue];    //ah 15.51

            [arr addObject:dict];
            [submitDict setObject:arr forKey:@"EditedExercises"];
        } else {
            NSArray *sortedArray = [self findHeighestIsSupersetFromArray:arr];
            isSuperSet = [[[sortedArray objectAtIndex:sortedArray.count-1] objectForKey:@"IsSuperSet"] intValue];
        }
        
        //                            [self saveDataWithRefresh:YES];
        return isSuperSet;
    } else {
        return 0;
    }
    return 0;
}
-(NSArray *) findHeighestIsSupersetFromArray:(NSArray *)editedExerciseArray {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"IsSuperSet" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [editedExerciseArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}
- (void) setupSequences:(int)newSeq AfterDelete:(NSString *)cktExStr {
    //ah 8.51
    NSMutableArray *newEditArr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:cktExStr]];
    int newSqCount = -1;
    for (int i = 0; i < newEditArr.count; i++) {
        NSMutableDictionary *newEditDict = [[NSMutableDictionary alloc]initWithDictionary:[newEditArr objectAtIndex:i]];
        if (newSeq < [[newEditDict objectForKey:@"SequenceNo"] intValue]) {
            newSqCount = [[newEditDict objectForKey:@"SequenceNo"] intValue];
            [newEditDict setObject:[NSNumber numberWithInt:newSqCount-1] forKey:@"SequenceNo"];
            
            [newEditArr removeObjectAtIndex:i];
            [newEditArr insertObject:newEditDict atIndex:i];
        }
    }
    [submitDict setObject:newEditArr forKey:cktExStr];
}
#pragma mark - DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)selectedData sender:(UIButton *)sender {
    //new added
    UIView *selectedSuperView1;
    
    if (![Utility isEmptyCheck:selectedData]) {     //ah 2.5
        if ([type caseInsensitiveCompare:@"CircuitName"] == NSOrderedSame) {
            selectedSuperView1 = sender.superview.superview;
        } else if ([type caseInsensitiveCompare:@"ExerciseName"] == NSOrderedSame) {
            selectedSuperView1 = sender.superview.superview;
        }
        
        if ([selectedSuperView1 isKindOfClass:[EditSessionExerciseView class]] && [selectedSuperView1.accessibilityHint caseInsensitiveCompare:@"NewAdded"] == NSOrderedSame) {
            if ([type caseInsensitiveCompare:@"ExerciseName"] == NSOrderedSame) {
                [sender setTitle:[selectedData objectForKey:@"ExerciseName"] forState:UIControlStateNormal];
                [sender setTag:[[selectedData objectForKey:@"ExerciseId"] integerValue]];
                
                EditSessionExerciseView *selectedExerciseView = (EditSessionExerciseView *)sender.superview.superview;
                [selectedExerciseView.exerciseViewButton setTag:[[selectedData objectForKey:@"ExerciseId"] integerValue]];
                
                //setup dict
                NSInteger sequence = selectedExerciseView.tag;
                
                NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[submitDict objectForKey:@"AddedExercises"]];
                NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
                
                [newDict addEntriesFromDictionary:[arr objectAtIndex:0]];
                
                [newDict setObject:[selectedData objectForKey:@"ExerciseId"] forKey:@"Id"];
                [newDict setObject:[NSNumber numberWithInteger:sequence] forKey:@"SequenceNo"];
                
                [arr removeObjectAtIndex:0];
                [arr insertObject:newDict atIndex:0];
                
                [submitDict setObject:arr forKey:@"AddedExercises"];
                [self saveDataWithRefresh:YES];
            }
        } else {
            
            //normal
            if (!isNewAdded) {
                if (![Utility isEmptyCheck:selectedData]) {
                    if ([type caseInsensitiveCompare:@"ExerciseName"] == NSOrderedSame) {
                        [sender setTitle:[selectedData objectForKey:@"ExerciseName"] forState:UIControlStateNormal];
                        [sender setTag:[[selectedData objectForKey:@"ExerciseId"] integerValue]];
                        
                        EditSessionExerciseView *selectedExerciseView = (EditSessionExerciseView *)sender.superview.superview;
                        [selectedExerciseView.exerciseViewButton setTag:[[selectedData objectForKey:@"ExerciseId"] integerValue]];
                        
                        //setup dict
                        NSInteger sequence = [selectedExerciseView.accessibilityHint integerValue];
                        NSInteger IsSuperSet = [selectedExerciseView.accessibilityValue integerValue];
                        [self setupExerciseDict:selectedData ForKey:@"ExerciseId" OrText:nil MainKey:@"Id" AtSequence:sequence IsSuperSet:IsSuperSet];
                    } else if ([type caseInsensitiveCompare:@"RepsUnit"] == NSOrderedSame) {
                        [sender setTitle:[selectedData objectForKey:@"RepsUnitType"] forState:UIControlStateNormal];
                        [sender setTag:[[selectedData objectForKey:@"Id"] integerValue]];
                        
                        EditSessionExerciseView *selectedExerciseView = (EditSessionExerciseView *)sender.superview.superview.superview;
                        //setup dict
                        NSInteger sequence = [selectedExerciseView.accessibilityHint integerValue];
                        NSInteger IsSuperSet = [selectedExerciseView.accessibilityValue integerValue];
                        [self setupExerciseDict:selectedData ForKey:@"Id" OrText:nil MainKey:@"RepUnit" AtSequence:sequence IsSuperSet:IsSuperSet];
                    } else if ([type caseInsensitiveCompare:@"RestUnit"] == NSOrderedSame) {
                        [sender setTitle:[selectedData objectForKey:@"RestUnitType"] forState:UIControlStateNormal];
                        [sender setTag:[[selectedData objectForKey:@"Id"] integerValue]];
                        
                        EditSessionExerciseView *selectedExerciseView = (EditSessionExerciseView *)sender.superview.superview.superview;
                        //setup dict
                        NSInteger sequence = [selectedExerciseView.accessibilityHint integerValue];
                        NSInteger IsSuperSet = [selectedExerciseView.accessibilityValue integerValue];
                        [self setupExerciseDict:selectedData ForKey:@"Id" OrText:nil MainKey:@"RestUnit" AtSequence:sequence IsSuperSet:IsSuperSet];
                    } else if ([type caseInsensitiveCompare:@"AddNew"] == NSOrderedSame) {
                        NSInteger sequence = sender.tag;    //this is index (i) of exerciseArray    //ah 5.5
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:[NSNumber numberWithInteger:0] forKey:@"Id"];
                        [dict setObject:@"--Select--" forKey:@"Name"];
                        [dict setObject:@"" forKey:@"RepsUnitText"];
                        [dict setObject:[NSNumber numberWithInt:1] forKey:@"RepsUnit"];
                        [dict setObject:@"" forKey:@"RestUnitText"];
                        [dict setObject:[NSNumber numberWithInt:2] forKey:@"RestUnitId"];
                        [dict setObject:@"" forKey:@"ExerciseRepGoal"];
                        [dict setObject:[NSNumber numberWithInt:1] forKey:@"SetCount"];
                        [dict setObject:@"" forKey:@"RestComment"];
                        [dict setObject:[NSNumber numberWithInt:0] forKey:@"IsSuperSet"];
                        [dict setObject:[NSArray new] forKey:@"Tips"];
                        
                        int seqNo = -1;
                        
                        if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Add new exercise above"] == NSOrderedSame) {
                            if ([[[exerciseArray objectAtIndex:sequence] objectForKey:@"IsSuperSet"] intValue] > 1) {
                                int i = (int)sequence;
                                while (i >= 0) {
                                    if ([[[exerciseArray objectAtIndex:i] objectForKey:@"IsSuperSet"] intValue] == 1) {
                                        sequence = i;
                                        break;
                                    }
                                    i--;
                                }
                            }
                            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCircuit"];
                            seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue];
                            [exerciseArray insertObject:dict atIndex:sequence];
                        } else if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Add new circuit above"] == NSOrderedSame) {
                            if ([[[exerciseArray objectAtIndex:sequence] objectForKey:@"IsSuperSet"] intValue] > 1) {
                                int i = (int)sequence;
                                while (i >= 0) {
                                    if ([[[exerciseArray objectAtIndex:i] objectForKey:@"IsSuperSet"] intValue] == 1) {
                                        sequence = i;
                                        break;
                                    }
                                    i--;
                                }
                            }
                            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsCircuit"];
                            seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue];
                            [exerciseArray insertObject:dict atIndex:sequence];
                        } else if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Add new exercise below"] == NSOrderedSame) {
                            [dict setObject:[NSNumber numberWithBool:NO] forKey:@"IsCircuit"];
                            if (sequence + 1 < exerciseArray.count) {
                                seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue]+1;
                                
                                [exerciseArray insertObject:dict atIndex:sequence+1];
                                sequence = sequence+1;
                            } else {
                                seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue]+1;
                                
                                [exerciseArray addObject:dict];
                                sequence = sequence+1;  //ah 8.5
                            }
                        } else if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Add new circuit below"] == NSOrderedSame) {
                            [dict setObject:[NSNumber numberWithBool:YES] forKey:@"IsCircuit"];
                            if (sequence + 1 < exerciseArray.count) {
                                seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue]+1;
                                
                                [exerciseArray insertObject:dict atIndex:sequence+1];
                                sequence = sequence+1;
                            } else {
                                seqNo = [[[exerciseArray objectAtIndex:sequence] objectForKey:@"SequenceNo"] intValue]+1;
                                
                                [exerciseArray addObject:dict];
                                sequence = sequence+1;  //ah 8.5
                            }
                        }
                        
                        [self setupViewForAddNewWithDict:dict Sequence:(int)sequence SeqNo:seqNo];
                    } else if ([type caseInsensitiveCompare:@"AddSuperset"] == NSOrderedSame) {
                        NSInteger sequence = sender.tag;
                        //                    NSInteger superSetPosition = [sender.accessibilityHint integerValue];
                        //                    EditSessionExerciseView *selectedExerciseView = (EditSessionExerciseView *)sender.superview.superview;
                        
                        
                        if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Super Set with above exercise"] == NSOrderedSame) {
                            //prev
                            int isSuperset = 0;
                            isSuperset = [self setupDictForAddSupersetAbovePrevWithSequence:sequence-1 AndNewSequence:sequence-1];
                            
                            //self
                            if (isSuperset > 0) {
                                isSuperset = [self setupDictForAddSupersetAboveSelfWithSequence:sequence AndNewSequence:sequence-1 IsSuperSet:isSuperset+1];
                                if (isSuperset > 0) {
                                    [self saveDataWithRefresh:YES];
                                }
                            } else {
                                [Utility msg:@"No exercise above" title:@"Oops!" controller:self haveToPop:NO];
                            }
                            
                        } else if ([[selectedData objectForKey:@"Name"] caseInsensitiveCompare:@"Super Set with below exercise"] == NSOrderedSame) {
                            //self
                            int isSuperset = 0;
                            isSuperset = [self setupDictForAddSupersetBelowSelfWithSequence:sequence AndNewSequence:sequence];
                            
                            //next find heightest issuperset then add1
                            if (isSuperset > 0) {
                                isSuperset = [self setupDictForAddSupersetBelowNextWithSequence:sequence+1 AndNewSequence:sequence IsSuperSet:isSuperset+1];
                                if (isSuperset > 0) {
                                    [self saveDataWithRefresh:YES];
                                } else {
                                    [Utility msg:@"No exercise below" title:@"Oops!" controller:self haveToPop:NO];
                                }
                            }
                        }
                        
                        //                    [self setupViewForAddNewWithDict:dict Sequence:(int)sequence];
                    } else if ([type caseInsensitiveCompare:@"BodyType"] == NSOrderedSame) {
                        [bodyTypeButton setTitle:[selectedData objectForKey:@"name"] forState:UIControlStateNormal];
                        
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name == %@)",[selectedData objectForKey:@"name"]];
                        NSArray *filteredArray = [bodyTypeArray filteredArrayUsingPredicate:predicate];
                        if (filteredArray.count > 0) {
                            NSDictionary *dict1 = [filteredArray objectAtIndex:0];
                            [bodyTypeButton setTag:[[dict1 objectForKey:@"id"] integerValue]];
                            [submitDict setObject:[NSNumber numberWithInteger:[[dict1 objectForKey:@"id"] integerValue]] forKey:@"BodyType"];
                            [self saveDataWithRefresh:NO];
                        }
                    }
                }
            } else {
                [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
            }
        }
    }
}
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
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    CGRect aRect = mainScroll.frame;
    float x;
    if (activeTextField !=nil) {
//        x=aRect.size.height-activeTextField.frame.origin.y-activeTextField.frame.size.height;
//        aRect.size.height -= kbSize.height;
//        if (x < kbSize.height) {
//            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
//            [mainScroll setContentOffset:scrollPoint animated:YES];
//        }
    } else if (activeTextView !=nil) {
        x=aRect.size.height-activeTextView.superview.superview.frame.origin.y-activeTextView.frame.size.height;
        aRect.size.height -= kbSize.height;
        if (x < kbSize.height) {
            CGPoint scrollPoint = CGPointMake(0.0, kbSize.height+5-x);
            [mainScroll setContentOffset:scrollPoint animated:YES];
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
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseRepGoal"] == NSOrderedSame && isNewAdded) {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
        [textField resignFirstResponder];
    } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseSetCount"] == NSOrderedSame && isNewAdded) {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
        [textField resignFirstResponder];
    } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseRest"] == NSOrderedSame && isNewAdded) {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
        [textField resignFirstResponder];
    } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseSetCount"] == NSOrderedSame && isNewAdded) {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
        [textField resignFirstResponder];
    } else {
        [activeTextView resignFirstResponder];
        activeTextField = textField;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeTextField = nil;
    [textField resignFirstResponder];

    if (textField.text.length > 0) {
        if ([textField.accessibilityHint caseInsensitiveCompare:@"CircuitTitle"] == NSOrderedSame) {
            [submitDict setObject:textField.text forKey:@"CircuitTitle"];
        } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseRepGoal"] == NSOrderedSame) {
            [self setupExerciseDict:nil ForKey:nil OrText:textField.text MainKey:@"RepGoal" AtSequence:textField.tag IsSuperSet:0];
        } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseSetCount"] == NSOrderedSame) {
            [self setupExerciseDict:nil ForKey:nil OrText:textField.text MainKey:@"SetCount" AtSequence:textField.tag IsSuperSet:0];
        } else if ([textField.accessibilityHint caseInsensitiveCompare:@"ExerciseRest"] == NSOrderedSame) {
            [self setupExerciseDict:nil ForKey:nil OrText:textField.text MainKey:@"RestComment" AtSequence:textField.tag IsSuperSet:0];//[[dataArray objectAtIndex:textField.tag] objectForKey:@"RestUnitId"] @"RestUnit"CircuitExerciseTip
        }
    }
    [self saveDataWithRefresh:NO];
}
#pragma mark - textView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (!isNewAdded) {
        activeTextView=textView;
    } else {
        [Utility msg:@"Hey, an exercise box was just added for you. You seem to have missed to select exercise there. Once you select  an exercise there, you can add another one to the session." title:@"Oops!" controller:self haveToPop:NO];
        [textView resignFirstResponder];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
    [textView resignFirstResponder];

    if (textView.text.length > 0 && !isNewAdded) {
        if ([textView.accessibilityHint caseInsensitiveCompare:@"ExerciseTips"] == NSOrderedSame) {
            [self setupExerciseDict:nil ForKey:nil OrText:textView.text MainKey:@"CircuitExerciseTip" AtSequence:textView.tag IsSuperSet:0];
        } else if ([textView.accessibilityHint caseInsensitiveCompare:@"CircuitInstruction"] == NSOrderedSame) {
            [submitDict setObject:instructionTextView.text forKey:@"Instruction"];
        } else if ([textView.accessibilityHint caseInsensitiveCompare:@"CircuitTip"] == NSOrderedSame) {
            [submitDict setObject:tipsTextView.text forKey:@"Tip"];
        }
        [self saveDataWithRefresh:NO];
    }
}
@end
