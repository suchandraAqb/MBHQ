//
//  AdvanceSearchForSessionViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AdvanceSearchForSessionViewController.h"
#import "SessionListViewController.h"
#import "SessionAdvanceSearchHeaderView.h"
#import "SessionAdvSearchTableViewCell.h"

@interface AdvanceSearchForSessionViewController (){
    NSMutableDictionary *filterDictionary;
    NSArray *tagArray;
    UITextField *activeTextField;
    
    IBOutlet UIScrollView *scroll;
    IBOutlet UITextField *searchBySessionNameTextField;
    IBOutlet UIButton *durationButton;

    IBOutlet UIButton *includeTagsButton;
    IBOutlet UIButton *excludeTagsButton;
    
    IBOutlet UIButton *allRadioButton;
    IBOutlet UIButton *abbbcCreatedSessionRadioButton;
    IBOutlet UIButton *personalisedSessionRadioButton;
    IBOutlet UIButton *withEquipmentOrBodyWeightRadioButton;
    IBOutlet UIButton *withEquipmentRadioButton;
    IBOutlet UIButton *bodyWeightOnlyRadioButton;
    
    IBOutlet UIButton *hiitCheckButton;
    IBOutlet UIButton *cardioCheckButton;
    IBOutlet UIButton *pilatesCheckButton;
    IBOutlet UIButton *weightsCheckButton;
    IBOutlet UIButton *yogaCheckButton;

    
    IBOutlet UIButton *coreCheckButton;
    IBOutlet UIButton *fullBodyCheckButton;
    IBOutlet UIButton *upperBodyCheckButton;
    IBOutlet UIButton *lowerBodyCheckButton;
    NSArray *durationArray;
    
    IBOutlet UITableView *inExTable;
    IBOutlet UITableView *filterTable;
    NSMutableArray *inclArray;
    NSMutableArray *exclArray;
    __weak IBOutlet NSLayoutConstraint *inExTableHeight;
    __weak IBOutlet UIView *applyView;
    __weak IBOutlet UIButton *applyButton;
    __weak IBOutlet UIButton *allTypeButton;
    __weak IBOutlet UIButton *allAreaButton;
    __weak IBOutlet UIButton *anyDuration;
    IBOutletCollection(UIButton) NSArray *durationButtonCollection;
    
    __weak IBOutlet UIView *searchView;
    NSMutableArray *tempSearchArray;
    IBOutlet UITextField *searchTextField;
    
    IBOutletCollection(UIButton) NSArray *sessionTypeCollectionButton;
    IBOutletCollection(UIButton) NSArray *favouritesCollectionButton;
    IBOutletCollection(UIButton) NSArray *equipmentButtonCollection;
    UIToolbar *toolBar;
}


@end

@implementation AdvanceSearchForSessionViewController
@synthesize delegate,savedFilter,isMySession;

#pragma -mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    durationArray = @[
                        @{ @"key" : @-1,
                         @"value" : @"--ALL--"
                         },
                        @{ @"key" : @30,
                           @"value" : @"30mins max"
                        },
                        @{ @"key" : @60,
                           @"value" : @"60mins max"
                           },
                        @{ @"key" : @60,
                           @"value" : @"More than 60mins"
                        }
                      ];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *keyBoardDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(keyBoardDoneButtonClicked:)];
    [toolBar setItems:[NSArray arrayWithObject:keyBoardDone]];
    [self registerForKeyboardNotifications];
//    [filterDictionary setObject:@"" forKey:@"CircuitName"];
    
    NSArray *unSortedArray = [NSJSONSerialization JSONObjectWithData:[jsonTags dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
    tagArray = [unSortedArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    filterDictionary = [[NSMutableDictionary alloc]init];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, searchBySessionNameTextField.frame.size.height)];
    searchBySessionNameTextField.leftView = paddingView;
    searchBySessionNameTextField.leftViewMode = UITextFieldViewModeAlways;
    searchBySessionNameTextField.layer.borderWidth = 1;
    searchBySessionNameTextField.layer.borderColor = squadSubColor.CGColor;
    searchBySessionNameTextField.layer.masksToBounds = YES;
    searchBySessionNameTextField.layer.cornerRadius = 10.0;
    applyView.layer.masksToBounds = YES;
    applyView.layer.cornerRadius = 15.0;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, searchTextField.frame.size.height)];
    searchTextField.leftView = paddingView;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    
    inclArray = [NSMutableArray new];
    exclArray = [NSMutableArray new];
    tempSearchArray = [NSMutableArray new];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"SessionAdvanceSearchHeaderView" bundle:nil];
    [inExTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"SessionAdvanceSearchHeaderView"];
    UINib *sectionFooterNib = [UINib nibWithNibName:@"SessionAdvanceSearchHeaderView" bundle:nil];
    [inExTable registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:@"SessionAdvanceSearchHeaderView"];
    inExTable.estimatedRowHeight = 50;
    inExTable.rowHeight = UITableViewAutomaticDimension;
    
    inExTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    inExTable.estimatedSectionHeaderHeight = 50;
    
    inExTable.sectionFooterHeight = 50;
    inExTable.estimatedSectionFooterHeight = 50;
    
    filterTable.estimatedRowHeight = 35;
    filterTable.rowHeight = UITableViewAutomaticDimension;
    filterTable.sectionHeaderHeight = 0;
    filterTable.sectionFooterHeight = 0;
    
    [searchTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
    [self updateView:false];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    [inExTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
    [inExTable removeObserver:self forKeyPath:@"contentSize"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == inExTable) {
        inExTableHeight.constant = inExTable.contentSize.height;
    }
}
#pragma -mark End


#pragma -mark IBAction
- (IBAction)keyBoardDoneButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}
-(void)updateView:(BOOL)isReset{
    if (!isReset && savedFilter.count>0) {
        //saved dict
        //Type
        [[savedFilter objectForKey:@"SessionType_Weights"]intValue]?[self selectButton:weightsCheckButton]:[self deselectButton:weightsCheckButton];
        [[savedFilter objectForKey:@"SessionType_HIIT"]intValue]?[self selectButton:hiitCheckButton]:[self deselectButton:hiitCheckButton];
        [[savedFilter objectForKey:@"SessionType_Pilates"]intValue]?[self selectButton:pilatesCheckButton]:[self deselectButton:pilatesCheckButton];
        [[savedFilter objectForKey:@"SessionType_Cardio"]intValue]?[self selectButton:cardioCheckButton]:[self deselectButton:cardioCheckButton];
        [[savedFilter objectForKey:@"SessionType_Yoga"]intValue]?[self selectButton:yogaCheckButton]:[self deselectButton:yogaCheckButton];
        (hiitCheckButton.isSelected && cardioCheckButton.isSelected && pilatesCheckButton.isSelected && weightsCheckButton.isSelected && yogaCheckButton.isSelected)?[self selectButton:allTypeButton]:[self deselectButton:allTypeButton];
        
        //Area
        [[savedFilter objectForKey:@"Core"]intValue]?[self selectButton:coreCheckButton]:[self deselectButton:coreCheckButton];
        [[savedFilter objectForKey:@"Fullbody"]intValue]?[self selectButton:fullBodyCheckButton]:[self deselectButton:fullBodyCheckButton];
        [[savedFilter objectForKey:@"Upperbody"]intValue]?[self selectButton:upperBodyCheckButton]:[self deselectButton:upperBodyCheckButton];
        [[savedFilter objectForKey:@"Lowerbody"]intValue]?[self selectButton:lowerBodyCheckButton]:[self deselectButton:lowerBodyCheckButton];
        (coreCheckButton.isSelected && fullBodyCheckButton.isSelected && upperBodyCheckButton.isSelected && lowerBodyCheckButton.isSelected)?[self selectButton:allAreaButton]:[self deselectButton:allAreaButton];
        
        //Duration
        int duration = [[savedFilter objectForKey:@"Duration"]intValue];
        if (duration == 0) {
            for (UIButton *btn in durationButtonCollection) {
//                btn.layer.borderWidth = 1;
//                btn.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
                btn.selected = false;
//                [btn setBackgroundColor:[UIColor whiteColor]];
            }
            [self selectButton:anyDuration];
        } else {
            [self deselectButton:anyDuration];
            for (UIButton *btn in durationButtonCollection) {
                [self deselectButton:btn];
            }
            UIButton *button;
            if (duration == 20) {
                button = durationButtonCollection[0];
            }else if (duration == 30){
                button = durationButtonCollection[1];
            }else if (duration == 31){
                button = durationButtonCollection[2];
            }else if (duration == 55){
                button = durationButtonCollection[3];
            }
            [self selectButton:button];
        }
        [inclArray removeAllObjects];
        [exclArray removeAllObjects];
        NSArray *inArray = [savedFilter objectForKey:@"IncludeExerciseTags"];
        NSArray *exArray = [savedFilter objectForKey:@"ExcludeExerciseTags"];
        if (inArray.count>0) {
            [inclArray addObjectsFromArray:inArray];
        }
        if (exArray.count>0) {
            [exclArray addObjectsFromArray:exArray];
        }
        
        for (UIButton *btn in sessionTypeCollectionButton) {
            [self deselectButton:btn];
        }
        int sType = [[savedFilter objectForKey:@"SessionFlowType"]intValue];
        for (UIButton *btn in sessionTypeCollectionButton) {
            if (btn.tag == sType) {
                [self selectButton:btn];
            } else {
                [self deselectButton:btn];
            }
        }
        
        if(![Utility isEmptyCheck:[savedFilter objectForKey:@"SessionName"]]){
            searchBySessionNameTextField.text = [savedFilter objectForKey:@"SessionName"];
        }else{
            searchBySessionNameTextField.text = @"";
        }
        for (UIButton *btn in favouritesCollectionButton) {
            [self deselectButton:btn];
        }
        if(![Utility isEmptyCheck:[savedFilter objectForKey:@"IsFavourite"]]){
            UIButton *btn = favouritesCollectionButton[0];
            [self selectButton:btn];
        }
        if(![Utility isEmptyCheck:[savedFilter objectForKey:@"IsDoneAtLeastOnce"]]){
            UIButton *btn = favouritesCollectionButton[1];
            [self selectButton:btn];
        }
        if(![Utility isEmptyCheck:[savedFilter objectForKey:@"Category"]] && ([[savedFilter objectForKey:@"Category"] intValue]==4)){
            UIButton *btn = favouritesCollectionButton[3];
            [self selectButton:btn];
        }
        if(![Utility isEmptyCheck:[savedFilter objectForKey:@"IsDoneAtLeastOnce"]] && ![Utility isEmptyCheck:[savedFilter objectForKey:@"IsFavourite"]] && ![Utility isEmptyCheck:[savedFilter objectForKey:@"Category"]]){
            UIButton *btn = favouritesCollectionButton[2];
            [self selectButton:btn];
        }
        if([Utility isEmptyCheck:[savedFilter objectForKey:@"IsDoneAtLeastOnce"]] && [Utility isEmptyCheck:[savedFilter objectForKey:@"IsFavourite"]] && [Utility isEmptyCheck:[savedFilter objectForKey:@"Category"]]){
            UIButton *btn = favouritesCollectionButton[2];
            [self selectButton:btn];
        }
        
        
        for (UIButton *btn in equipmentButtonCollection) {
            [self deselectButton:btn];
            if(btn.tag == 2){
                if(![Utility isEmptyCheck:[savedFilter objectForKey:@"EquipmentRequired"]] && [[savedFilter objectForKey:@"EquipmentRequired"]boolValue]){
                    [self selectButton:btn];
                }
            }else if(btn.tag == 0){
                if(![Utility isEmptyCheck:[savedFilter objectForKey:@"BodyWeight"]] && [[savedFilter objectForKey:@"BodyWeight"]boolValue]){
                    [self selectButton:btn];
                }
            }else if(btn.tag == 1){
                if (![Utility isEmptyCheck:[savedFilter objectForKey:@"SquadStrap"]] && [[savedFilter objectForKey:@"SquadStrap"]boolValue]) {
                    [self selectButton:btn];
                }
            }
        }
        if ([Utility isEmptyCheck:[savedFilter objectForKey:@"SquadStrap"]] && [Utility isEmptyCheck:[savedFilter objectForKey:@"BodyWeight"]] && [Utility isEmptyCheck:[savedFilter objectForKey:@"EquipmentRequired"]]) {
            for (UIButton *btn in equipmentButtonCollection) {
                if (btn.tag == 3) {
                    [self selectButton:btn];
                }
            }
        }
        
        filterDictionary = savedFilter;
    }else{
        [filterDictionary removeAllObjects];
        
        [self selectButton:hiitCheckButton];
        [self selectButton:cardioCheckButton];
        [self selectButton:pilatesCheckButton];
        [self selectButton:weightsCheckButton];
        [self selectButton:yogaCheckButton];
        [self selectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_HIIT"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Cardio"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Pilates"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Weights"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Yoga"];
        
        [self selectButton:coreCheckButton];
        [self selectButton:fullBodyCheckButton];
        [self selectButton:upperBodyCheckButton];
        [self selectButton:lowerBodyCheckButton];
        [self selectButton:allAreaButton];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
        
        for (UIButton *btn in durationButtonCollection) {
            [self deselectButton:btn];
        }
        [self selectButton:anyDuration];
        [filterDictionary setObject:@"" forKey:@"Duration"];
        [inclArray removeAllObjects];
        [exclArray removeAllObjects];
        
        for (UIButton *btn in sessionTypeCollectionButton) {
            if (btn.tag == 0) {
                [self selectButton:btn];
            } else {
                [self deselectButton:btn];
            }
        }
        searchBySessionNameTextField.text = @"";
        [filterDictionary removeObjectForKey:@"SessionName"];
        [filterDictionary setObject:[NSNumber numberWithInt:0] forKey:@"SessionType"];
        for (UIButton *btn in favouritesCollectionButton) {
            if (btn.tag == -1) {
                [self selectButton:btn];
            }else{
                [self deselectButton:btn];
            }
        }
        [filterDictionary removeObjectForKey:@"IsFavourite"];
        [filterDictionary removeObjectForKey:@"IsDoneAtLeastOnce"];
        [filterDictionary removeObjectForKey:@"Category"];
        if (isMySession) {
            for (UIButton *btn in favouritesCollectionButton) {
                if (btn.tag == 4) {
                    [self selectButton:btn];
                    [filterDictionary setObject:[NSNumber numberWithInt:4] forKey:@"Category"];
                }else if (btn.tag == -1) {
                    [self deselectButton:btn];
                }
            }
        }
        for (UIButton *btn in equipmentButtonCollection) {
            if (btn.tag == 3) {
                [self selectButton:btn];
            }else{
                [self deselectButton:btn];
            }
        }
        [filterDictionary removeObjectForKey:@"BodyWeight"];
        [filterDictionary removeObjectForKey:@"SquadStrap"];
        [filterDictionary removeObjectForKey:@"EquipmentRequired"];
    }
    
    allRadioButton.selected =true;
    abbbcCreatedSessionRadioButton.selected =false;
    personalisedSessionRadioButton.selected =false;
    
    withEquipmentOrBodyWeightRadioButton.selected =true;
    withEquipmentRadioButton.selected =false;
    bodyWeightOnlyRadioButton.selected =false;
    
    [self setButtons];
    
    searchView.hidden = true;
    [inExTable reloadData];
}
- (IBAction)durationButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = self->durationArray;
        controller.selectedIndex = -1;
        controller.mainKey = @"value";
        controller.apiType = @"duration";
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    });
}

- (IBAction)searchByTagButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view endEditing:YES];
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = self->tagArray;
        controller.selectedIndex = -1;
        controller.mainKey = nil;
        controller.apiType = nil;
        controller.delegate = self;
        controller.sender = sender;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSArray *titleArray = [sender.titleLabel.text componentsSeparatedByString:@", "];
        for (int i =0;i<titleArray.count;i++) {
            NSString *title = [titleArray objectAtIndex:i];
            if ([self->tagArray containsObject:title]) {
                [array addObject:[NSNumber numberWithInteger:[self->tagArray indexOfObject:title]]];
            }
        }
        
        controller.multiSelect = true;
        controller.selectedIndexes=array;
        [self presentViewController:controller animated:YES completion:nil];
    });
    
}
- (IBAction)categoryRadioButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if ([sender isEqual:allRadioButton]) {
        allRadioButton.selected = true;
        abbbcCreatedSessionRadioButton.selected = false;
        personalisedSessionRadioButton.selected = false;
        [filterDictionary removeObjectForKey:@"Category"];
    }else if([sender isEqual:abbbcCreatedSessionRadioButton]){
        allRadioButton.selected = false;
        abbbcCreatedSessionRadioButton.selected = true;
        personalisedSessionRadioButton.selected = false;
        [filterDictionary setObject:[NSNumber numberWithInt:1] forKey:@"Category"];
    }else if([sender isEqual:personalisedSessionRadioButton]){
        allRadioButton.selected = false;
        abbbcCreatedSessionRadioButton.selected = false;
        personalisedSessionRadioButton.selected = true;
        [filterDictionary setObject:[NSNumber numberWithBool:4] forKey:@"Category"];
    }else{
        allRadioButton.selected = false;
        abbbcCreatedSessionRadioButton.selected = false;
        personalisedSessionRadioButton.selected = false;
        [filterDictionary removeObjectForKey:@"Category"];
        
    }
}

- (IBAction)hiitCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
//        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_HIIT"];
    }else{
//        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_HIIT"];
    }
    [self setButtons];
}
- (IBAction)cardioCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Cardio"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Cardio"];
    }
    [self setButtons];
}

- (IBAction)pilatesCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Pilates"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Pilates"];
    }
    [self setButtons];
}

- (IBAction)weightsCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Weights"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Weights"];
    }
    [self setButtons];
}

- (IBAction)yogaCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allTypeButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Yoga"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Yoga"];
    }
    [self setButtons];
}

- (IBAction)coreCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allAreaButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Core"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
    }
    [self setButtons];
}
- (IBAction)fullBodyCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allAreaButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Fullbody"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
    }
    [self setButtons];
}
- (IBAction)upperBodyCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allAreaButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Upperbody"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
    }
    [self setButtons];
}
- (IBAction)lowerBodyCheckButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender.selected) {
        //        sender.selected = false;
        [self deselectButton:sender];
        [self deselectButton:allAreaButton];
        [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Lowerbody"];
    }else{
        //        sender.selected = true;
        [self selectButton:sender];
        [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
    }
    [self setButtons];
}
- (IBAction)backButtonPressed:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:^{
//        if ([self->delegate respondsToSelector:@selector(dismissFromAdvanceSearch)]) {
//            [self->delegate dismissFromAdvanceSearch];
//        }
//    }];
}
-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        
        if(_isFromSessionList){
            if([delegate respondsToSelector:@selector(isGotoHome:)]){
                [self.navigationController popViewControllerAnimated:YES];
                [delegate isGotoHome:true];
                return;
            }
        }
        
        if([delegate respondsToSelector:@selector(dismissFromAdvanceSearch:)]){
            [delegate dismissFromAdvanceSearch:false];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)applyButtonPressed:(UIButton *)sender {
    
    if (searchBySessionNameTextField.text.length>0) {
        [filterDictionary setObject:searchBySessionNameTextField.text forKey:@"SessionName"];
    }else{
        [filterDictionary removeObjectForKey:@"SessionName"];
    }
    
    if ([self->delegate respondsToSelector:@selector(applyForSesionFilter:ischange:)]) {
        [self->delegate applyForSesionFilter:self->filterDictionary ischange:false];
    }
    NSArray *controllers = [self.navigationController viewControllers];
    NSMutableArray *tempControllers = [NSMutableArray new];
    NSMutableArray *uniqueController = [NSMutableArray new];
    for (UIViewController *controller in [controllers reverseObjectEnumerator]) {
        NSString *stringVC = NSStringFromClass([controller class]);
        if (![tempControllers containsObject:stringVC]) {
            [tempControllers addObject:stringVC];
            [uniqueController addObject:controller];
        }
    }
    controllers = [[uniqueController reverseObjectEnumerator] allObjects];
    self.navigationController.viewControllers = controllers;
    for (UIViewController *controller in controllers) {
        if ([controller isKindOfClass:[SessionListViewController class]]) {
            NSArray *poppedViewController = [self.navigationController popToViewController:controller animated:true];
            NSMutableArray *customNav = [controller.navigationController.viewControllers mutableCopy];
            for (UIViewController *view in poppedViewController) {
                [customNav insertObject:view atIndex:(customNav.count - 1)];
            }
            controller.navigationController.viewControllers = customNav;
            break;
        }
    }
    
}
-(IBAction)startTypingPressed:(UIButton *)sender{
    searchTextField.text = @"";
    [searchTextField becomeFirstResponder];
    searchTextField.layer.borderWidth = 1;
    searchTextField.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    searchView.hidden = false;
    searchView.tag = sender.tag;
    tempSearchArray = [tagArray mutableCopy];
    [filterTable reloadData];
}
- (IBAction)allOrAnyButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    if (sender == allTypeButton) {
        if (sender.isSelected) {
            [self deselectButton:allTypeButton];
            [self deselectButton:hiitCheckButton];
            [self deselectButton:cardioCheckButton];
            [self deselectButton:pilatesCheckButton];
            [self deselectButton:weightsCheckButton];
            [self deselectButton:yogaCheckButton];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_HIIT"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Cardio"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Pilates"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Weights"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"SessionType_Yoga"];
        } else {
            [self selectButton:allTypeButton];
            [self selectButton:hiitCheckButton];
            [self selectButton:cardioCheckButton];
            [self selectButton:pilatesCheckButton];
            [self selectButton:weightsCheckButton];
            [self selectButton:yogaCheckButton];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_HIIT"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Cardio"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Pilates"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Weights"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"SessionType_Yoga"];
        }
        [self setButtons];
    } else if (sender == allAreaButton) {
        if (sender.isSelected) {
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Core"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Fullbody"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Upperbody"];
            [filterDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"Lowerbody"];
            [self deselectButton:allAreaButton];
            [self deselectButton:lowerBodyCheckButton];
            [self deselectButton:upperBodyCheckButton];
            [self deselectButton:coreCheckButton];
            [self deselectButton:fullBodyCheckButton];
        } else {
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Core"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Fullbody"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Upperbody"];
            [filterDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"Lowerbody"];
            [self selectButton:allAreaButton];
            [self selectButton:lowerBodyCheckButton];
            [self selectButton:upperBodyCheckButton];
            [self selectButton:coreCheckButton];
            [self selectButton:fullBodyCheckButton];
        }
        [self setButtons];
    }else if (sender == anyDuration) {
        [filterDictionary setObject:@"" forKey:@"Duration"];
        [self selectButton:anyDuration];
        for (UIButton *btn in durationButtonCollection) {
            btn.selected = false;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}
- (IBAction)durationPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    [self deselectButton:anyDuration];
    NSArray *durationArray = @[@20, @30, @31, @55];
    for (UIButton *btn in durationButtonCollection) {
        if (btn == sender) {
            [self selectButton:sender];
            [filterDictionary setObject:durationArray[sender.tag] forKey:@"Duration"];
        }else{
            btn.selected = false;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
}

-(void)deselectButton:(UIButton *)button{
//    button.layer.borderWidth = 1;
//    button.layer.borderColor = [UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f].CGColor;
    button.selected = false;
//    [button setBackgroundColor:[UIColor whiteColor]];
}
-(void)selectButton:(UIButton *)button{
    //applyView.alpha = 1;
    //applyButton.enabled = true;
    button.selected = true;
//    [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0f]];
}
- (IBAction)cancelPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    searchView.hidden = true;
}
- (IBAction)deleteButtonPressed:(UIButton *)sender {
//    NSString *title = @"";
    if ([sender.accessibilityHint isEqualToString:@"0"]) {
        [inclArray removeObjectAtIndex:sender.tag];
        
//        if(inclArray.count>0){
//            title = [inclArray componentsJoinedByString:@","];
//        }
        if (inclArray.count>0) {
            [filterDictionary setObject:inclArray forKey:@"IncludeExerciseTags"];
        }else{
            [filterDictionary removeObjectForKey:@"IncludeExerciseTags"];
        }
    } else {
        [exclArray removeObjectAtIndex:sender.tag];
        
//        if(exclArray.count>0){
//            title = [exclArray componentsJoinedByString:@","];
//        }
        if (exclArray.count>0) {
            [filterDictionary setObject:exclArray forKey:@"ExcludeExerciseTags"];
        }else{
            [filterDictionary removeObjectForKey:@"ExcludeExerciseTags"];
        }
    }
    [inExTable reloadData];
}
- (IBAction)resetButtonPressed:(UIButton *)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Warning"
                                  message:@"This action will reset all your filters. Do you want to continue?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self updateView:true];
                             
                         }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 
                             }];
    
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)setButtons{
    [self.view endEditing:YES];
    BOOL isTrue = true;;
    if (!coreCheckButton.isSelected && !fullBodyCheckButton.isSelected && !upperBodyCheckButton.isSelected && !lowerBodyCheckButton.isSelected && !allAreaButton.isSelected) {
        isTrue = false;
    }
    if (!hiitCheckButton.isSelected && !cardioCheckButton.isSelected && !pilatesCheckButton.isSelected && !weightsCheckButton.isSelected && !yogaCheckButton.isSelected && !allTypeButton.isSelected) {
        isTrue = false;
    }
    if (isTrue) {
        applyView.alpha = 1;
        applyButton.enabled = isTrue;
    } else {
        applyView.alpha = 0.5;
        applyButton.enabled = isTrue;
    }
}
- (IBAction)sessionTypePressed:(UIButton *)sender {
    [self.view endEditing:YES];
    for (UIButton *btn in sessionTypeCollectionButton) {
        [self deselectButton:btn];
    }
    [self selectButton:sender];
    [filterDictionary setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"SessionFlowType"];
    
}
- (IBAction)favouritesButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (sender.isSelected) {
        if (sender.tag == -1) {
            [filterDictionary removeObjectForKey:@"IsFavourite"];
            [filterDictionary removeObjectForKey:@"IsDoneAtLeastOnce"];
            [filterDictionary removeObjectForKey:@"Category"];
            for (UIButton *btn in favouritesCollectionButton) {
                [self deselectButton:btn];
            }
        }else {
            for (UIButton *btn in favouritesCollectionButton) {
                if (btn.tag == -1) {
                    [self deselectButton:btn];
                }
            }
            if (sender.tag == 0) {
                [filterDictionary removeObjectForKey:@"IsDoneAtLeastOnce"];
            }else if (sender.tag == 1) {
                [filterDictionary removeObjectForKey:@"IsFavourite"];
            }else if (sender.tag == 4) {
                [filterDictionary removeObjectForKey:@"Category"];
            }
        }
        
        [self deselectButton:sender];
    } else {
        if (sender.tag == -1) {
            for (UIButton *btn in favouritesCollectionButton) {
                [self selectButton:btn];
            }
            [filterDictionary removeObjectForKey:@"IsFavourite"];
            [filterDictionary removeObjectForKey:@"IsDoneAtLeastOnce"];
            [filterDictionary removeObjectForKey:@"Category"];

        }else if (sender.tag == 0) {
            [filterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"IsDoneAtLeastOnce"];
        }else if (sender.tag == 1) {
            [filterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"IsFavourite"];
        }else if (sender.tag == 4) {
            [filterDictionary setObject:[NSNumber numberWithInt:4] forKey:@"Category"];
        }
        
        [self selectButton:sender];
    }
    
}
- (IBAction)equipmentButtonPressed:(UIButton *)sender {
    [self.view endEditing:YES];
    for (UIButton *btn in equipmentButtonCollection) {
        [self deselectButton:btn];
    }
    for (UIButton *btn in equipmentButtonCollection) {
        if (sender == btn && btn.tag == 0) {
            [filterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"BodyWeight"];
            [filterDictionary removeObjectForKey:@"SquadStrap"];
            [filterDictionary removeObjectForKey:@"EquipmentRequired"];
            break;
        }else if (sender == btn && btn.tag == 1) {
            [filterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"SquadStrap"];
            [filterDictionary removeObjectForKey:@"BodyWeight"];
            [filterDictionary removeObjectForKey:@"EquipmentRequired"];
            break;
        }else if (sender == btn && btn.tag == 2) {
            [filterDictionary setObject:[NSNumber numberWithBool:true] forKey:@"EquipmentRequired"];
            [filterDictionary removeObjectForKey:@"BodyWeight"];
            [filterDictionary removeObjectForKey:@"SquadStrap"];
            break;
        }else if (sender == btn && btn.tag == 3) {
            [filterDictionary removeObjectForKey:@"BodyWeight"];
            [filterDictionary removeObjectForKey:@"SquadStrap"];
            [filterDictionary removeObjectForKey:@"EquipmentRequired"];
            break;
        }
    }
    [self selectButton:sender];
    
}
#pragma -mark End
#pragma -mark TableView DataSource and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == filterTable) {
        return 1;
    }
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == filterTable) {
        return tempSearchArray.count;
    }
    if (section == 0) {
        return inclArray.count;
    } else {
        return exclArray.count;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SessionAdvanceSearchHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SessionAdvanceSearchHeaderView"];
//    [sectionHeaderView.collapseButton addTarget:self action:@selector(sectionExpandCollapse:) forControlEvents:UIControlEventTouchUpInside];
    if (section == 0) {
        sectionHeaderView.headerText.text = @"Include in the session (e.g. Burpees, Sled, etc)";
    } else {
        sectionHeaderView.headerText.text = @"Exclude from the session (e.g. Burpees, Sled, etc)";
    }
    sectionHeaderView.seperatorView.hidden = false;
    sectionHeaderView.headerText.hidden = false;
    sectionHeaderView.footerTypingButton.hidden = true;
    return  sectionHeaderView;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SessionAdvanceSearchHeaderView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SessionAdvanceSearchHeaderView"];
    sectionFooterView.footerTypingButton.tag = section;
    [sectionFooterView.footerTypingButton addTarget:self action:@selector(startTypingPressed:) forControlEvents:UIControlEventTouchUpInside];
    sectionFooterView.footerTypingButton.layer.masksToBounds = YES;
    sectionFooterView.footerTypingButton.layer.cornerRadius = 10.0;
    sectionFooterView.footerTypingButton.layer.borderWidth = 1.0;
    sectionFooterView.footerTypingButton.layer.borderColor = squadSubColor.CGColor;
    sectionFooterView.seperatorView.hidden = true;
    sectionFooterView.headerText.hidden = true;
    sectionFooterView.footerTypingButton.hidden = false;
    return  sectionFooterView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    SessionAdvSearchTableViewCell *cell = (SessionAdvSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SessionAdvSearchTableViewCell"];
    NSString *txt;
    if (tableView == filterTable) {
        txt = tempSearchArray[indexPath.row];
        cell.sessionLabel.text = ![Utility isEmptyCheck:txt]?txt:@"";
        
        tableCell = cell;
    } else {
        if (indexPath.section == 0) {
            txt = inclArray[indexPath.row];
        } else {
            txt = exclArray[indexPath.row];
        }
        cell.sessionLabel.text = ![Utility isEmptyCheck:txt]?txt:@"";
        
        cell.deleteButton.tag = indexPath.row;
        cell.deleteButton.accessibilityHint = [NSString stringWithFormat:@"%d",(int)indexPath.section];
        tableCell = cell;
    }
    return tableCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == filterTable) {
//        NSString *title = @"";
        if (searchView.tag == 0) {
            if (![inclArray containsObject:tempSearchArray[indexPath.row]]) {
                [inclArray addObject:tempSearchArray[indexPath.row]];
            }
//            if(inclArray.count>0){
//                title = [inclArray componentsJoinedByString:@","];
//            }
//            if (title.length > 0) {
//                [filterDictionary setObject:title forKey:@"IncludeExerciseTags"];
//            }else{
//                [filterDictionary removeObjectForKey:@"IncludeExerciseTags"];
//            }
            if (inclArray.count > 0) {
                [filterDictionary setObject:inclArray forKey:@"IncludeExerciseTags"];
            }else{
                [filterDictionary removeObjectForKey:@"IncludeExerciseTags"];
            }
        } else {
            if (![exclArray containsObject:tempSearchArray[indexPath.row]]) {
                [exclArray addObject:tempSearchArray[indexPath.row]];
            }
//            if(exclArray.count>0){
//                title = [exclArray componentsJoinedByString:@","];
//            }
//            if (title.length > 0) {
//                [filterDictionary setObject:title forKey:@"ExcludeExerciseTags"];
//            }else{
//                [filterDictionary removeObjectForKey:@"ExcludeExerciseTags"];
//            }
            if (exclArray.count > 0) {
                [filterDictionary setObject:exclArray forKey:@"ExcludeExerciseTags"];
            }else{
                [filterDictionary removeObjectForKey:@"ExcludeExerciseTags"];
            }
        }
        //applyView.alpha = 1;
        //applyButton.enabled = true;
        [self.view endEditing:YES];
        searchView.hidden = true;
        [inExTable reloadData];
    }
}
#pragma -mark End
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
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height-120, 0.0);
    filterTable.contentInset = contentInsets;
    filterTable.scrollIndicatorInsets = contentInsets;
    
    if (activeTextField !=nil) {
        CGRect aRect = filterTable.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
//            [filterTable scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    filterTable.contentInset = contentInsets;
    filterTable.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -
#pragma -mark DropDownViewDelegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data{
    if(![Utility isEmptyCheck:data]){
        if ([type isEqualToString:@"duration"]) {
            [durationButton setTitle:[data objectForKey:@"value"] forState:UIControlStateNormal];
            [filterDictionary setObject:[data objectForKey:@"key"] forKey:@"Duration"];
        }else{
            [durationButton setTitle:@"" forState:UIControlStateNormal];
            [filterDictionary removeObjectForKey:@"Duration"];
        }
    }else{
        [filterDictionary removeObjectForKey:@"Duration"];
    }
}
-(void)dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    if(![Utility isEmptyCheck:selectedValue]){
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        if ([sender isEqual:includeTagsButton]) {
            [filterDictionary setObject:[selectedValue componentsSeparatedByString:@", "] forKey:@"IncludeExerciseTags"];
        }else if ([sender isEqual:excludeTagsButton]) {
            [filterDictionary setObject:[selectedValue componentsSeparatedByString:@", "] forKey:@"ExcludeExerciseTags"];
        }
    }else{
        [sender setTitle:@"" forState:UIControlStateNormal];
        if ([sender isEqual:includeTagsButton]) {
            [filterDictionary removeObjectForKey:@"IncludeExerciseTags"];
        }else if ([sender isEqual:excludeTagsButton]) {
            [filterDictionary removeObjectForKey:@"ExcludeExerciseTags"];
        }
    }
    
}
#pragma -mark End
#pragma mark - textField Delegate
-(void)changeText:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempSearchArray = [[tagArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self CONTAINS[c] %@)", textField.text]]mutableCopy];
        NSLog(@"search for %@", tempSearchArray);
    } else {
        tempSearchArray = [tagArray mutableCopy];
    }
    [filterTable reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    /*if (textField == searchBySessionNameTextField) {
     [textField resignFirstResponder];
     NSString *searchString = textField.text;
     textField.text = @"";
     NSLog(@"%@",searchString);
     
     return NO;
     }*/
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    [activeTextField setInputAccessoryView:toolBar];
//    activeTextField.returnKeyType = UIReturnKeyDone;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    activeTextField.layer.borderWidth = 1;
//    activeTextField.layer.borderColor = [UIColor colorWithRed:88/255.0f green:89/255.0f blue:91/255.0f alpha:1.0f].CGColor;
    activeTextField = nil;
//    NSString *searchString = textField.text;
//
//    if (![Utility isEmptyCheck:searchString]) {
//        [filterDictionary setObject:searchString forKey:@"SessionName"];
//    }else{
//        [filterDictionary setObject:@"" forKey:@"SessionName"];
//    }
    
}
#pragma -mark End

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
