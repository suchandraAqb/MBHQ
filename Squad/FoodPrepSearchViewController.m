//
//  FoodPrepSearchViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 13/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FoodPrepSearchViewController.h"
#import "RecipeListTableViewCell.h"
#import "foodPrepSearchTableViewCell.h"
#import "Utility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DailyGoodnessDetailViewController.h"
#import "FoodPrepAddEditViewController.h"
#import "CustomNutritionPlanListViewController.h"


@interface FoodPrepSearchViewController ()
{
    IBOutlet UIButton *glutenFreeButton;
    IBOutlet UIButton *dairyFreeButton;
    IBOutlet UIButton *noRedMeatButton;
    IBOutlet UIButton *lectoOvoButton;
    IBOutlet UIButton *pescatarinButton;
    IBOutlet UIButton *vegetarianVeganButton;
    IBOutlet UIButton *noSeafoodButton;
    IBOutlet UIButton *fodmapFriendlyButton;
    IBOutlet UIButton *paleoFriendlyButton;
    IBOutlet UIButton *noEggsButton;
    IBOutlet UIButton *noNutsButton;
    IBOutlet UIButton *noLegumesButton;
    
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UITableView *recipeTable;
//    NSArray *allMealArray;
    
    IBOutlet UITextField *searchTextField;
    __weak IBOutlet UIView *searchView;
    __weak IBOutlet UIView *recipeStackView;
    
    IBOutlet UIButton *IngredientsButton;
    IBOutlet UIButton *clearAllButton;
    IBOutlet UIButton *searchButton;
    IBOutlet UITextView *IngredientsTextView;
    
    __weak IBOutlet UITextField *keywordSearchTextField;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    
    NSMutableDictionary *searchDict;
//    NSArray *ingredientsAllList;
    NSMutableArray *likeArray;
    NSMutableArray *dontLikeArray;
    NSMutableArray *proteinArray;
    NSMutableArray *carbArray;
    NSArray *searchArray;
    NSArray *tempSearchArray;
    UIView *contentView;
    int apiCount;
    int vegeterian;
    
    __weak IBOutlet UIStackView *rangeStackView;
    IBOutletCollection(UIButton) NSArray *rangeContentTypeButton;

    IBOutletCollection(UIButton) NSArray *selectedRangeValueButton;
    
    IBOutletCollection(UIButton) NSArray *mealTypeButtons;
    IBOutletCollection(UIButton) NSArray *viewButtons;
    IBOutletCollection(UIButton) NSArray *optionalSearchButtons;
    
    IBOutlet UIButton *favButton;
    
    __weak IBOutlet UITableView *foodLikeTable;
    __weak IBOutlet NSLayoutConstraint *foodLikeTableHeight;
    __weak IBOutlet UITableView *dontLikeTable;
    __weak IBOutlet NSLayoutConstraint *dontLikeTableHeight;
    __weak IBOutlet UITableView *favProteinTable;
    __weak IBOutlet NSLayoutConstraint *favProteinTableHeight;
    __weak IBOutlet UITableView *favCarbTable;
    __weak IBOutlet NSLayoutConstraint *favCarbTableHeight;
    __weak IBOutlet NSLayoutConstraint *recipeTableHeight;
    __weak IBOutlet UITableView *searchTable;
    __weak IBOutlet NSLayoutConstraint *searchTableHeight;
    IBOutletCollection(UIButton) NSArray *startTypingButtons;
    
    BOOL isEditing;
    BOOL isMyPref;
//    NSArray *dietaryPreferenceArray;
    
    //Carbs Range Section
    __weak IBOutlet UIStackView *carbsRangeSectionView;
    IBOutletCollection(UIButton) NSArray *carbSubsections;
    __weak IBOutlet UIStackView *carbsCustomRangeView;
    __weak IBOutlet UITextField *carbsMinTextfield;
    __weak IBOutlet UITextField *carbsMaxTextfield;
    //
    
    //Carbs Range Section
    __weak IBOutlet UIStackView *proteinRangeSectionView;
    IBOutletCollection(UIButton) NSArray *proteinSubsections;
    __weak IBOutlet UIStackView *proteinCustomRangeView;
    __weak IBOutlet UITextField *proteinMinTextfield;
    __weak IBOutlet UITextField *proteinMaxTextfield;
    //
    
    //Carbs Range Section
    __weak IBOutlet UIStackView *fatRangeSectionView;
    IBOutletCollection(UIButton) NSArray *fatSubsections;
    __weak IBOutlet UIStackView *fatCustomRangeView;
    __weak IBOutlet UITextField *fatMinTextfield;
    __weak IBOutlet UITextField *fatMaxTextfield;
    //
    
    IBOutletCollection(UIButton) NSArray *measurementButtons;
    
    __weak IBOutlet UIStackView *applySwapView;
    NSMutableArray *selectedMealArray;
    
    __weak IBOutlet UILabel *searchRecipeListLabel;
    BOOL isChanged;
}
@end

@implementation FoodPrepSearchViewController
@synthesize allMealArray,delegate,sender,mealSessionIdToReplace,defaultSearchDict, ingredientsAllList,dietaryPreferenceArray,isMyRecipe;

#pragma mark - view Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    apiCount = 0;
    searchDict = [NSMutableDictionary new];
    likeArray = [NSMutableArray new];
    dontLikeArray = [NSMutableArray new];
    carbArray = [NSMutableArray new];
    proteinArray = [NSMutableArray new];
    selectedMealArray = [NSMutableArray new];
    
    mainScroll.layer.cornerRadius = 7;
    mainScroll.layer.masksToBounds = YES;
    
    foodLikeTable.estimatedRowHeight = 40;
    foodLikeTable.rowHeight = UITableViewAutomaticDimension;
    dontLikeTable.estimatedRowHeight = 40;
    dontLikeTable.rowHeight = UITableViewAutomaticDimension;
    favProteinTable.estimatedRowHeight = 40;
    favProteinTable.rowHeight = UITableViewAutomaticDimension;
    favCarbTable.estimatedRowHeight = 40;
    favCarbTable.rowHeight = UITableViewAutomaticDimension;
    searchTable.estimatedRowHeight = 35;
    searchTable.rowHeight = UITableViewAutomaticDimension;
    recipeTable.estimatedRowHeight = 148;
    recipeTable.rowHeight = 200;
    
    clearAllButton.layer.masksToBounds = YES;
    clearAllButton.layer.cornerRadius = 15;
    clearAllButton.layer.borderColor = [[Utility colorWithHexString:@"e425a0"]CGColor];
    clearAllButton.layer.borderWidth= 1.0f;
    searchButton.layer.masksToBounds = YES;
    searchButton.layer.cornerRadius = 15;
    searchTextField.layer.cornerRadius = 10.0f;
    searchTextField.layer.masksToBounds = YES;
    searchTextField.layer.borderColor = [[Utility colorWithHexString:@"333333"]CGColor];
    searchTextField.layer.borderWidth= 1.0f;
    
    UIView *paddingViewMinCal = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    searchTextField.leftView = paddingViewMinCal;
    searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    keywordSearchTextField.layer.cornerRadius = 10.0f;
    keywordSearchTextField.layer.masksToBounds = YES;
    keywordSearchTextField.layer.borderColor = [[Utility colorWithHexString:@"333333"]CGColor];
    keywordSearchTextField.layer.borderWidth= 1.0f;
    
    for (UIButton *btn in startTypingButtons) {
        btn.layer.cornerRadius = 10.0f;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = [[Utility colorWithHexString:@"333333"]CGColor];
        btn.layer.borderWidth= 1.0f;
    }
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    
    [searchTextField addTarget:self
                  action:@selector(changeText:)
        forControlEvents:UIControlEventEditingChanged];
    
    [self registerForKeyboardNotifications];
    
    if ([Utility isEmptyCheck:ingredientsAllList]) {
        [self GetFoodPrepIngredientsApiCall];
    }
    if ([Utility isEmptyCheck:defaultSearchDict]) {
        [self getUserFlags];
    }else{
        searchDict = [defaultSearchDict mutableCopy];
    }
    
    [self setUpView:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [recipeTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [foodLikeTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [dontLikeTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [favProteinTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [favCarbTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
    
    if (isChanged) {
        [self GetFoodPrepMealsWithUserFlags];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for(UIButton *button in rangeContentTypeButton){
        [button setImage:[UIImage imageNamed:@"right_arr_setprogram.png"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, button.frame.size.width - 20, 0, 0)];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [recipeTable removeObserver:self forKeyPath:@"contentSize"];
    [foodLikeTable removeObserver:self forKeyPath:@"contentSize"];
    [dontLikeTable removeObserver:self forKeyPath:@"contentSize"];
    [favProteinTable removeObserver:self forKeyPath:@"contentSize"];
    [favCarbTable removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if (object == recipeTable) {
//        recipeTableHeight.constant=recipeTable.contentSize.height;
//    }else
        if (object == foodLikeTable){
        foodLikeTableHeight.constant=foodLikeTable.contentSize.height;
    }else if (object == dontLikeTable){
        dontLikeTableHeight.constant=dontLikeTable.contentSize.height;
    }else if (object == favProteinTable){
        favProteinTableHeight.constant=favProteinTable.contentSize.height;
    }else if (object == favCarbTable){
        favCarbTableHeight.constant=favCarbTable.contentSize.height;
    }
    
}
#pragma mark - End
#pragma mark - IBAction

-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
-(IBAction)searchButtonPressed:(id)sender{
    if([Utility isSquadFreeUser]){
        [Utility showAlertAfterSevenDayTrail:self];
        return;
    }
    
    if(!isMyPref){
        if (vegetarianVeganButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithInt:3] forKey:@"Vegetarian"];
        }else if (lectoOvoButton.isSelected){
            [searchDict setObject:[NSNumber numberWithInt:2] forKey:@"Vegetarian"];
        }else if (pescatarinButton.isSelected){
            vegeterian =4;
            [searchDict setObject:[NSNumber numberWithInt:4] forKey:@"Vegetarian"];
        }else{
            [searchDict removeObjectForKey:@"Vegetarian"];
        }
    }
    
    
    if(keywordSearchTextField.text.length>0){
        [searchDict setObject:[@"" stringByAppendingFormat:@"%@",keywordSearchTextField.text] forKey:@"SearchText"];
    }else{
        [searchDict removeObjectForKey:@"SearchText"];
    }
    
    if([self checkCustomRangesValue]){
        if(_isFromRecipe){
            if ([delegate respondsToSelector:@selector(mealSerachWithFilterData: ingredientsAllList: dietaryPreferenceArray:)]) {
                [delegate mealSerachWithFilterData:searchDict ingredientsAllList:ingredientsAllList dietaryPreferenceArray:dietaryPreferenceArray];
            }
            
            //            if ([delegate respondsToSelector:@selector(didCheckAnyChangeForFoodPrepSearch:)]) {
            //                isChanged = YES;
            //                [delegate didCheckAnyChangeForFoodPrepSearch:isChanged];
            //            }
//            [self.navigationController popViewControllerAnimated:NO];
            NSArray *controllers = self.navigationController.viewControllers;
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
                if ([controller isKindOfClass:[RecipeListViewController class]]) {
                    NSArray *poppedViewController = [self.navigationController popToViewController:controller animated:NO];
                    NSMutableArray *customNav = [controller.navigationController.viewControllers mutableCopy];
                    //            [customNav addObjectsFromArray:poppedViewController];
                    for (UIViewController *view in poppedViewController) {
                        [customNav insertObject:view atIndex:(customNav.count - 1)];
                    }
                    controller.navigationController.viewControllers = customNav;
                    NSLog(@"\n\n%@\n\n",controller.navigationController.viewControllers);
                    break;
                }
            }
        }else{
            [self GetFoodPrepMealsWithUserFlags];
        }
    }
    
    
}

- (IBAction)ingredientNameButtonPressed:(UIButton *)sender {
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = ingredientsAllList;
    controller.mainKey = @"IngredientName";
    controller.apiType = @"IngredientName";
    controller.selectedIndex = -1;
    NSLog(@"%d",controller.selectedIndex);
    controller.delegate = self;
    controller.sender = sender;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if ([IngredientsTextView.text caseInsensitiveCompare:@""] != NSOrderedSame) {
        NSArray *titleArray = [IngredientsTextView.text componentsSeparatedByString:@", "];
        for (int i =0;i<titleArray.count;i++) {
            NSString *title = [titleArray objectAtIndex:i];
            for (int j = 0; j < ingredientsAllList.count; j++) {
                NSDictionary *dict = [ingredientsAllList objectAtIndex:j];
                if ([[dict objectForKey:@"IngredientName"] caseInsensitiveCompare:title] == NSOrderedSame) {
                    [array addObject:[NSNumber numberWithInteger:j]];
                }
            }
        }
        controller.selectedIndexes=array;
    }
    controller.multiSelect = true;
    [self presentViewController:controller animated:YES completion:nil];
}

-(IBAction)checkUncheckButtonPressed:(UIButton*)sender{
    isEditing = true;
    searchButton.titleLabel.alpha = 1.0;
    searchButton.enabled = true;
    UIButton *viewAllButton = viewButtons[0];
    if(!viewAllButton.isSelected)[self viewTypesButtonPressed:viewAllButton];
    
    if([sender isEqual:glutenFreeButton] ){
        glutenFreeButton.selected = !glutenFreeButton.isSelected;
        if (glutenFreeButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:glutenFreeButton.isSelected] forKey:@"GlutenFree"];
        }else{
            [searchDict removeObjectForKey:@"GlutenFree"];
        }
    }else if([sender isEqual:dairyFreeButton]){
        dairyFreeButton.selected = !dairyFreeButton.isSelected;
        if (dairyFreeButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:dairyFreeButton.isSelected] forKey:@"DairyFree"];
        }else{
            [searchDict removeObjectForKey:@"DairyFree"];
        }
    }else if([sender isEqual:noRedMeatButton]){
        noRedMeatButton.selected = !noRedMeatButton.isSelected;
        if (noRedMeatButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noRedMeatButton.isSelected] forKey:@"NoRedMeat"];
        }else{
            [searchDict removeObjectForKey:@"NoRedMeat"];
        }
    }else if([sender isEqual:lectoOvoButton]){
        lectoOvoButton.selected = !lectoOvoButton.isSelected;
    }else if([sender isEqual:pescatarinButton]){
        pescatarinButton.selected = !pescatarinButton.isSelected;
    }
    else if([sender isEqual:vegetarianVeganButton]){
        vegetarianVeganButton.selected = !vegetarianVeganButton.isSelected;
    }
    else if([sender isEqual:noSeafoodButton]){
        noSeafoodButton.selected = !noSeafoodButton.isSelected;
        if (noSeafoodButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noSeafoodButton.isSelected] forKey:@"NoSeaFood"];
        }else{
            [searchDict removeObjectForKey:@"NoSeaFood"];
        }
    }
    else if([sender isEqual:fodmapFriendlyButton]){
        fodmapFriendlyButton.selected = !fodmapFriendlyButton.isSelected;
        if (fodmapFriendlyButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:fodmapFriendlyButton.isSelected] forKey:@"FodmapFriendly"];
        }else{
            [searchDict removeObjectForKey:@"FodmapFriendly"];
        }
    }
    else if([sender isEqual:paleoFriendlyButton]){
        paleoFriendlyButton.selected = !paleoFriendlyButton.isSelected;
        if (paleoFriendlyButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:paleoFriendlyButton.isSelected] forKey:@"PaleoFriendly"];
        }else{
            [searchDict removeObjectForKey:@"PaleoFriendly"];
        }
        
    }
    else if([sender isEqual:noEggsButton]){
        noEggsButton.selected = !noEggsButton.isSelected;
        if (noEggsButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noEggsButton.isSelected] forKey:@"NoEggs"];
        }else{
            [searchDict removeObjectForKey:@"NoEggs"];
        }
    }
    else if([sender isEqual:noNutsButton]){
        noNutsButton.selected = !noNutsButton.isSelected;
        if (noNutsButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noNutsButton.isSelected] forKey:@"NoNuts"];
        }else{
            [searchDict removeObjectForKey:@"NoNuts"];
        }
    }
    else if([sender isEqual:noLegumesButton]){
        noLegumesButton.selected = !noLegumesButton.isSelected;
        if (noLegumesButton.isSelected) {
            [searchDict setObject:[NSNumber numberWithBool:noLegumesButton.isSelected] forKey:@"NoLegumes"];
        }else{
            [searchDict removeObjectForKey:@"NoLegumes"];
        }
    }
    if (sender.isSelected) {
//        [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
//        [sender setBackgroundColor:[UIColor whiteColor]];
//        [sender setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
}
- (IBAction)measurementButtonPressed:(UIButton *)sender {
    isEditing = true;
    searchButton.titleLabel.alpha = 1.0;
    searchButton.enabled = true;
    
    for (UIButton *btn in measurementButtons) {
        if (sender == btn) {
            sender.selected = true;//!sender.isSelected;
        }else{
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            btn.selected = false;
        }
    }
    
    if (sender.tag == 1 || sender.tag == 2) {
        [searchDict setObject:[NSNumber numberWithInteger:sender.tag] forKey:@"MeasurementType"];
    }else {
        [searchDict removeObjectForKey:@"MeasurementType"];
    }
    
//    if (sender.isSelected) {
//        [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    } else {
//        [sender setBackgroundColor:[UIColor whiteColor]];
//        [sender setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
//    }
}
-(IBAction)crossButtonPressed:(id)sender{
    [self.view endEditing:YES];
    searchView.hidden = true;
    activeTextField = nil;
    recipeStackView.hidden = true;
//    searchArray = [[NSArray alloc]init];
//    tempSearchArray = [[NSArray alloc]init];
}
-(IBAction)selectRange:(UIButton *)sender{
    isEditing = true;
    searchButton.titleLabel.alpha = 1.0;
    searchButton.enabled = true;
    
    
    for (UIButton *button in rangeContentTypeButton) {
        if ([button isEqual:sender]) {
            button.selected = !button.isSelected;
            if (button.isSelected) {
                
                if(button.tag == 0){
                    carbsRangeSectionView.hidden = false;
                }else if(button.tag == 1){
                    proteinRangeSectionView.hidden = false;
                }else{
                    fatRangeSectionView.hidden = false;
                }
                
                [button setImage:[UIImage imageNamed:@"down_arr_search.png"] forState:UIControlStateNormal];
                
            } else {
                if(button.tag == 0){
                    carbsRangeSectionView.hidden = true;
                }else if(button.tag == 1){
                    proteinRangeSectionView.hidden = true;
                }else{
                    fatRangeSectionView.hidden = true;
                }
                [button setImage:[UIImage imageNamed:@"right_arr_setprogram.png"] forState:UIControlStateNormal];
                
            }
        }
    }
    

}

- (IBAction)deleteMealPressed:(UIButton *)sender {
    if([sender.accessibilityHint  isEqual: @"like"]){
        [likeArray removeObjectAtIndex:sender.tag];
        [foodLikeTable reloadData];
        [self updateFilterList:likeArray key:@"IngredientIlike"];
    }else if([sender.accessibilityHint  isEqual: @"dontLike"]){
        [dontLikeArray removeObjectAtIndex:sender.tag];
        [dontLikeTable reloadData];
        [self updateFilterList:dontLikeArray key:@"IngredientIDonotlike"];
    }else if([sender.accessibilityHint  isEqual: @"protein"]){
        [proteinArray removeObjectAtIndex:sender.tag];
        [favProteinTable reloadData];
        [self updateFilterList:proteinArray key:@"ProteinSearchIngredients"];
    }else if([sender.accessibilityHint  isEqual: @"carb"]){
        [carbArray removeObjectAtIndex:sender.tag];
        [favCarbTable reloadData];
        [self updateFilterList:carbArray key:@"CarbSearchIngredients"];
    }
}
-(void)updateFilterList:(NSMutableArray *)filterArray key:(NSString *)key{
    NSString *title = @"";
    /*if (myArray.count > 0) {
        for (NSDictionary *temp in myArray) {
            if ([title isEqualToString:@""]) {
                title = temp[@"IngredientName"];
            } else {
                if ([title rangeOfString:temp[@"IngredientName"]].location == NSNotFound) {
                    NSLog(@"string does not contain this text");
                    title = [NSString stringWithFormat:@"%@, %@",title,temp[@"IngredientName"]];
                } else {
                    NSLog(@"string contains this text");
                }
            }
        }
    }*/
    if(filterArray.count>0){
        title = [filterArray componentsJoinedByString:@","];
    }
    
    
    if (title.length > 0) {
        [searchDict setObject:title forKey:key];
    }else{
        [searchDict removeObjectForKey:key];
    }
}
- (IBAction)startTypingButtonPressed:(UIButton *)sender {
//    isEditing = true;
    searchButton.titleLabel.alpha = 1.0;
    searchButton.enabled = true;
    searchView.hidden = false;
    searchTextField.tag = sender.tag;
    [searchTextField becomeFirstResponder];
    searchTextField.text = @"";
    searchArray = [self makeArray:sender];
    tempSearchArray = searchArray;
    if (tempSearchArray.count > 0) {
        [searchTable reloadData];
    }
//    [searchTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [searchTable setContentOffset:CGPointZero];
}
-(NSArray *)makeArray:(UIButton *)sender{
    NSArray *mArray;
    if (sender.tag == 0) {
        mArray = [ingredientsAllList mutableCopy];
    } else if (sender.tag == 1) {
        mArray = [ingredientsAllList mutableCopy];
    } else if (sender.tag == 2) {
        mArray = [ingredientsAllList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(ProteinPer100.intValue >= CarbsPer100.intValue && ProteinPer100.intValue >= FatPer100.intValue)"]];
        //carbArray = [[NSMutableArray alloc]init];
//        [searchDict removeObjectForKey:@"SearchIngredients"];
       /* NSString *title = @"";
        if (proteinArray.count > 0) {
            for (NSDictionary *temp in proteinArray) {
                if ([title isEqualToString:@""]) {
                    title = temp[@"IngredientName"];
                } else {
                    if ([title rangeOfString:temp[@"IngredientName"]].location == NSNotFound) {
                        NSLog(@"string does not contain this text");
                        title = [NSString stringWithFormat:@"%@, %@",title,temp[@"IngredientName"]];
                    } else {
                        NSLog(@"string contains this text");
                    }
                }
            }
        }
        
        if (title.length > 0) {
            [searchDict setObject:title forKey:@"SearchIngredients"];
        }else{
            [searchDict removeObjectForKey:@"SearchIngredients"];
        }
        [favCarbTable reloadData];*/
        
    } else if (sender.tag == 3) {
        mArray = [ingredientsAllList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(CarbsPer100.intValue >= ProteinPer100.intValue && CarbsPer100.intValue >= FatPer100.intValue)"]];
       // proteinArray = [[NSMutableArray alloc]init];
//        [searchDict removeObjectForKey:@"SearchIngredients"];
        //
        
       /* NSString *title = @"";
        if (carbArray.count > 0) {
            for (NSDictionary *temp in carbArray) {
                if ([title isEqualToString:@""]) {
                    title = temp[@"IngredientName"];
                } else {
                    if ([title rangeOfString:temp[@"IngredientName"]].location == NSNotFound) {
                        NSLog(@"string does not contain this text");
                        title = [NSString stringWithFormat:@"%@, %@",title,temp[@"IngredientName"]];
                    } else {
                        NSLog(@"string contains this text");
                    }
                }
            }
        }
        
        if (title.length > 0) {
            [searchDict setObject:title forKey:@"SearchIngredients"];
        }else{
            [searchDict removeObjectForKey:@"SearchIngredients"];
        }
        
        //
        [favProteinTable reloadData];*/
    }
    /////////////////
    
    if(!mArray.count){
        return mArray;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    [tempArray addObjectsFromArray:[mArray valueForKeyPath:@"@distinctUnionOfObjects.Group1"]];
    [tempArray addObjectsFromArray:[mArray valueForKeyPath:@"@distinctUnionOfObjects.Group2"]];
    tempArray = [tempArray valueForKeyPath:@"@distinctUnionOfObjects.self"];
    tempArray = [[tempArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self != %@ and self != %@)",@"",@"<null>"]]mutableCopy];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    tempArray = [[tempArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByName]]mutableCopy];
    
    [tempArray removeObjectIdenticalTo:[NSNull null]];

    /*NSMutableArray *t = [NSMutableArray new];
    for (NSString *temp in tempArray) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if (![temp isKindOfClass:[NSNull class]]) {
            [dict setValue:temp forKey:@"IngredientName"];
            [t addObject:dict];
        }
    }*/
    mArray = tempArray;
    /////////////////
    return mArray;
}
//show group of ingredient

- (IBAction)submitButtonPressed:(UIButton *)sender {
    
    if(!selectedMealArray){
        selectedMealArray = [NSMutableArray new];
    }else{
        [selectedMealArray removeAllObjects];
    }
    
    [selectedMealArray addObject:allMealArray[sender.tag]];
    
    if(_isFromFoodPrep){
        if ([delegate respondsToSelector:@selector(didSelectSearchOption:sender:)]) {
            [delegate didSelectSearchOption:allMealArray[sender.tag][@"mealdetail"] sender:self.sender];
        }
        NSArray *controllers = [self.navigationController viewControllers];
        
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass: [FoodPrepAddEditViewController class]]){
                [self.navigationController popToViewController:controller animated:true];
                break;
            }
        }
    }else if(_isFromMealMatch){
        
        NSArray *controllers = [self.navigationController viewControllers];
        
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass: [NewMealAddViewController class]]){//[MealAddViewController class]]){
                [self.navigationController popToViewController:controller animated:NO];
                break;
            }
        }
        if ([delegate respondsToSelector:@selector(mealSerachWithFilterData: ingredientsAllList: dietaryPreferenceArray:)]) {
            [delegate mealSerachWithFilterData:searchDict ingredientsAllList:ingredientsAllList dietaryPreferenceArray:dietaryPreferenceArray];
        }
        if ([delegate respondsToSelector:@selector(didSelectSearchOption:sender:)]) {
            [delegate didSelectSearchOption:allMealArray[sender.tag][@"mealdetail"] sender:self.sender];
        }
        if ([delegate respondsToSelector:@selector(getAllMealArray:)]) {
            [delegate getAllMealArray:allMealArray];
        }
        
        
    }else if(!_isFromRecipe){
        [recipeTable reloadData];
    }
    
}
- (IBAction)editmealPressed:(UIButton *)sender {
    NSDictionary *mealDetails = allMealArray[sender.tag][@"mealdetail"];
    if (![Utility isEmptyCheck:mealDetails]) {
        if (![Utility isEmptyCheck:mealDetails]) {
            AddEditCustomNutritionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddEditCustomNutrition"];
            controller.mealId = mealDetails[@"Id"];
            controller.fromController = @"Food Prep";
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

- (IBAction)mealTypeButtonPressed:(UIButton *)sender {
    
    for(UIButton *button in mealTypeButtons){
        
        if(button == sender){
            button.selected = !button.isSelected;
            
//            if (button.isSelected) {
//                [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            } else {
//                [button setBackgroundColor:[UIColor whiteColor]];
//                [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
//            }
        }else{
            button.selected = false;
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
        
        if(button.tag == 0) continue;
        if(button.isSelected){
            [searchDict setObject:[NSNumber numberWithBool:button.isSelected] forKey:button.accessibilityHint];
        }else{
            [searchDict removeObjectForKey:button.accessibilityHint];
        }
    }
    
}

- (IBAction)myFavButtonPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [searchDict setObject:[NSNumber numberWithBool:sender.isSelected] forKey:sender.accessibilityHint];
//        [sender setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [searchDict removeObjectForKey:sender.accessibilityHint];
//        [sender setBackgroundColor:[UIColor whiteColor]];
//        [sender setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
}

- (IBAction)viewTypesButtonPressed:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    for(UIButton *button in viewButtons){
        if(button == sender){
            //            button.selected = !button.isSelected;
            button.selected = true;
            //            if (button.isSelected) {
//            [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (button.tag == 0) {//for all button
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"ViewType"];
            }else{
                [searchDict removeObjectForKey:@"ViewType"];
            }
            //            } else {
            //                [button setBackgroundColor:[UIColor whiteColor]];
            //                [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            //                [searchDict removeObjectForKey:@"ViewType"];
            //            }
            
            if(button.isSelected && button.tag == 1){
                [self uncheckAdditionalItems];
                isMyPref = true;
                [self setDefaultSearchParameter:YES];
            }else{
                isMyPref = false;
                [self setDefaultSearchParameter:NO];
            }
        }else{
            button.selected = false;
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            if(button.tag == 1){
                isMyPref = false;
               [self setDefaultSearchParameter:NO];
            }
        }
    }
    
}

- (IBAction)carbsRangeButtonPressed:(UIButton *)sender {
    
    carbsMinTextfield.text = @"";
    carbsMaxTextfield.text = @"";
    
    for(UIButton *button in carbSubsections){
        
        if(button == sender){
            button.selected = !button.isSelected;
            NSString *str = button.accessibilityHint;
            if (button.isSelected) {
                
                if(button.tag == 7){
                    carbsCustomRangeView.hidden = false;
                }else{
                    if(str.length > 0){
                        NSArray *arr = [str componentsSeparatedByString:@"-"];
                        if(arr.count>0){
                            if(!searchDict){
                                searchDict =[NSMutableDictionary new];
                            }
                            [searchDict setObject:[NSNumber numberWithInt:[arr[0] intValue]] forKey:@"MinCarb"];
                            [searchDict setObject:[NSNumber numberWithInt:[arr[1] intValue]] forKey:@"MaxCarb"];
                        }
                    }
                    carbsCustomRangeView.hidden = true;
                }
//                [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [searchDict removeObjectForKey:@"MinCarb"];
                [searchDict removeObjectForKey:@"MaxCarb"];
                carbsCustomRangeView.hidden = true;
//                [button setBackgroundColor:[UIColor whiteColor]];
//                [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            }
            
            
        }else{
            carbsCustomRangeView.hidden = true;
            button.selected = false;
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
        
        
    }
}

- (IBAction)proteinRangeButtonPressed:(UIButton *)sender {
    proteinMinTextfield.text = @"";
    proteinMaxTextfield.text = @"";
    
    for(UIButton *button in proteinSubsections){
        
        if(button == sender){
            button.selected = !button.isSelected;
            NSString *str = button.accessibilityHint;
            if (button.isSelected) {
                
                if(button.tag == 7){
                    proteinCustomRangeView.hidden = false;
                }else{
                    if(str.length > 0){
                        NSArray *arr = [str componentsSeparatedByString:@"-"];
                        if(arr.count>0){
                            if(!searchDict){
                                searchDict =[NSMutableDictionary new];
                            }
                            [searchDict setObject:[NSNumber numberWithInt:[arr[0] intValue]] forKey:@"MinProtein"];
                            [searchDict setObject:[NSNumber numberWithInt:[arr[1] intValue]] forKey:@"MaxProtein"];
                        }
                    }
                    proteinCustomRangeView.hidden = true;
                }
//                [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [searchDict removeObjectForKey:@"MinProtein"];
                [searchDict removeObjectForKey:@"MaxProtein"];
                proteinCustomRangeView.hidden = true;
//                [button setBackgroundColor:[UIColor whiteColor]];
//                [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            }
            
            
        }else{
            proteinCustomRangeView.hidden = true;
            button.selected = false;
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)fatRangeButtonPressed:(UIButton *)sender {
    
    fatMinTextfield.text = @"";
    fatMaxTextfield.text = @"";
    
    for(UIButton *button in fatSubsections){
        if(button == sender){
            button.selected = !button.isSelected;
            NSString *str = button.accessibilityHint;
            if (button.isSelected) {
                
                if(button.tag == 7){
                    fatCustomRangeView.hidden = false;
                }else{
                    if(str.length > 0){
                        NSArray *arr = [str componentsSeparatedByString:@"-"];
                        if(arr.count>0){
                            if(!searchDict){
                                searchDict =[NSMutableDictionary new];
                            }
                            [searchDict setObject:[NSNumber numberWithInt:[arr[0] intValue]] forKey:@"MinFat"];
                            [searchDict setObject:[NSNumber numberWithInt:[arr[1] intValue]] forKey:@"MaxFat"];
                        }
                    }
                    fatCustomRangeView.hidden = true;
                }
//                [button setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [searchDict removeObjectForKey:@"MinFat"];
                [searchDict removeObjectForKey:@"MaxFat"];
                fatCustomRangeView.hidden = true;
//                [button setBackgroundColor:[UIColor whiteColor]];
//                [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            }
            
            
        }else{
            fatCustomRangeView.hidden = true;
            button.selected = false;
//            [button setBackgroundColor:[UIColor whiteColor]];
//            [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)applySwapButtonPressed:(UIButton *)sender {
    
    if(!selectedMealArray.count){
        [Utility msg:@"Please select a meal to swap" title:@"" controller:self haveToPop:NO];
        return;
    }
    NSDictionary *mealDict = [selectedMealArray firstObject][@"mealdetail"];
    if(![Utility isEmptyCheck:mealDict]){
        [self squadUpdateMealForSessionApiCall:mealDict];
    }
}
- (IBAction)applyMultipleSwapButtonPressed:(UIButton *)sender {
    
    if(!selectedMealArray.count){
        [Utility msg:@"Please select a meal to swap" title:@"" controller:self haveToPop:NO];
        return;
    }
    NSDictionary *mealDict = [selectedMealArray firstObject][@"mealdetail"];
    if(![Utility isEmptyCheck:mealDict]){
        if([delegate respondsToSelector:@selector(didMultipleSwap:)]){
            [delegate didMultipleSwap:mealDict];
        }
        
        NSArray *controllers = [self.navigationController viewControllers];
        for(UIViewController *controller in controllers){
            if([controller isKindOfClass: [CustomNutritionPlanListViewController class]]){
                [self.navigationController popToViewController:controller animated:true];
                break;
            }
        }
    }
}

- (IBAction)resetFilterButtonPressed:(UIButton *)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Warning"
                                  message:@"This action will reset all your filters.Do you want to continue?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self->searchDict removeAllObjects];
                             [self setUpView:YES];
                             
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

#pragma mark - End

#pragma mark - Private function

-(void)GetFoodPrepMealsWithUserFlags{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:searchDict];
        
        [mainDict setObject:[NSNumber numberWithBool:YES] forKey:@"OnlySquad"];
        [mainDict setObject:[NSNumber numberWithBool:NO] forKey:@"OnlyAbbbcOnline"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepMealsWithUserFlags" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else{
                                                                             if (![Utility isEmptyCheck:responseDictionary[@"Meals"]]) {
                                                                                 self->allMealArray = responseDictionary[@"Meals"];
                                                                                 NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"mealdetail.MealName"  ascending:YES selector:@selector(caseInsensitiveCompare:)];
                                                                                 
                                                                                 self->allMealArray=[[self->allMealArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
                                                                                 if (self->allMealArray.count > 0) {
                                                                                     self->recipeStackView.hidden = false;
                                                                                     [self->recipeTable reloadData];
                                                                                     [self->recipeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                                                                 }
                                                                             } else {
                                                                                 self->recipeStackView.hidden = true;
                                                                                 [Utility msg:@"There are no meals available with the filters you have chosen. Please change your search criteria and try again. \n( Tip: Reduce the filter options to just one or two )" title:@" " controller:self haveToPop:NO];
                                                                             }
                                                                         }
                                                                     }else{
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
-(void)GetFoodPrepIngredientsApiCall{
    if (Utility.reachable) {
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
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetFoodPrepIngredients" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else{
                                                                             self->ingredientsAllList = [responseDictionary objectForKey:@"Ingredients"];
                                                                         }
                                                                     }else{
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

-(void)squadUpdateMealForSessionApiCall:(NSDictionary *)selectedMealDict{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealSessionIdToReplace] forKey:@"MealSessionId"];
        [mainDict setObject:selectedMealDict[@"Id"] forKey:@"NewMealId"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(),^ {
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SquadUpdateMealForSessionApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             [self swapCompleteAction];
                                                                             
                                                                         }
                                                                     }else{
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
-(void)setSelected:(UIButton *)btn isSelected:(BOOL)isSelected{
    if (isSelected) {
        btn.selected = true;
//        [btn setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
//        [btn setBackgroundColor:[UIColor whiteColor]];
//        [btn setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        btn.selected = false;
    }
}
-(void)setUpView:(BOOL)isReset{
    
    isEditing = false;
    searchView.hidden = true;
    recipeStackView.hidden = true;
    rangeStackView.hidden = true;
    carbsRangeSectionView.hidden = true;
    carbsCustomRangeView.hidden = true;
    proteinRangeSectionView.hidden = true;
    proteinCustomRangeView.hidden = true;
    fatRangeSectionView.hidden = true;
    fatCustomRangeView.hidden = true;
    
    [self updateApplySwapView];
    [self uncheckAdditionalItems];
    [self resetRangeButtons];
    
    if (!isReset && ![Utility isEmptyCheck:searchDict]) {//after search
        
        if (![Utility isEmptyCheck:searchDict[@"SearchText"]]){
            keywordSearchTextField.text = searchDict[@"SearchText"];
        }else{
            keywordSearchTextField.text = @"";
        }
        
        for(UIButton *btn in mealTypeButtons){
            [self setSelected:btn isSelected:NO];
        }
        UIButton *btn;
        if (![Utility isEmptyCheck:searchDict[@"Breakfast"]] && [searchDict[@"Breakfast"]boolValue]) {
            btn = mealTypeButtons[1];
        }else if (![Utility isEmptyCheck:searchDict[@"Lunch"]] && [searchDict[@"Lunch"]boolValue]) {
            btn = mealTypeButtons[2];
        }else if (![Utility isEmptyCheck:searchDict[@"Dinner"]] && [searchDict[@"Dinner"]boolValue]) {
            btn = mealTypeButtons[3];
        }else if (![Utility isEmptyCheck:searchDict[@"Snack"]] && [searchDict[@"Snack"]boolValue]) {
            btn = mealTypeButtons[4];
        }else if (![Utility isEmptyCheck:searchDict[@"MyRecipes"]] && [searchDict[@"MyRecipes"]boolValue]) {
            btn = mealTypeButtons[5];
        }else{
            btn = mealTypeButtons[0];
        }
        [self setSelected:btn isSelected:YES];
        
        if (![Utility isEmptyCheck:searchDict[@"ViewType"]] && [searchDict[@"ViewType"]boolValue]) {
            UIButton *btn = viewButtons[0];
            [self setSelected:btn isSelected:YES];
            
            [self setSelected:glutenFreeButton isSelected:![Utility isEmptyCheck:searchDict[@"GlutenFree"]]?[searchDict[@"GlutenFree"]boolValue]:false];
            [self setSelected:dairyFreeButton isSelected:![Utility isEmptyCheck:searchDict[@"DairyFree"]]?[searchDict[@"DairyFree"]boolValue]:false];
            [self setSelected:noRedMeatButton isSelected:![Utility isEmptyCheck:searchDict[@"NoRedMeat"]]?[searchDict[@"NoRedMeat"]boolValue]:false];
            [self setSelected:noSeafoodButton isSelected:![Utility isEmptyCheck:searchDict[@"NoSeaFood"]]?[searchDict[@"NoSeaFood"]boolValue]:false];
            [self setSelected:fodmapFriendlyButton isSelected:![Utility isEmptyCheck:searchDict[@"FodmapFriendly"]]?[searchDict[@"FodmapFriendly"]boolValue]:false];
            [self setSelected:paleoFriendlyButton isSelected:![Utility isEmptyCheck:searchDict[@"PaleoFriendly"]]?[searchDict[@"PaleoFriendly"]boolValue]:false];
            [self setSelected:noEggsButton isSelected:![Utility isEmptyCheck:searchDict[@"NoEggs"]]?[searchDict[@"NoEggs"]boolValue]:false];
            [self setSelected:noNutsButton isSelected:![Utility isEmptyCheck:searchDict[@"NoNuts"]]?[searchDict[@"NoNuts"]boolValue]:false];
            [self setSelected:noLegumesButton isSelected:![Utility isEmptyCheck:searchDict[@"NoLegumes"]]?[searchDict[@"NoLegumes"]boolValue]:false];
            
            [self setSelected:vegetarianVeganButton isSelected:NO];
            [self setSelected:lectoOvoButton isSelected:NO];
            [self setSelected:pescatarinButton isSelected:NO];
            if (![Utility isEmptyCheck:searchDict[@"Vegetarian"]]) {
                if([searchDict[@"Vegetarian"]intValue] == 3){
                    [self setSelected:vegetarianVeganButton isSelected:YES];
                }else if([searchDict[@"Vegetarian"]intValue] == 2){
                    [self setSelected:lectoOvoButton isSelected:YES];
                }else if([searchDict[@"Vegetarian"]intValue] == 4){
                    [self setSelected:pescatarinButton isSelected:YES];
                }
            }
            
        } else {
            [self viewTypesButtonPressed:self->viewButtons[1]];
        }
        
        for (UIButton *btn in measurementButtons) {
            [self setSelected:btn isSelected:NO];
        }
        if (![Utility isEmptyCheck:searchDict[@"MeasurementType"]]) {
            UIButton *btn;
            if ([searchDict[@"MeasurementType"]intValue] == 1) {
                btn = measurementButtons[1];
            }else if ([searchDict[@"MeasurementType"]intValue] == 2) {
                btn = measurementButtons[2];
            }
            [self setSelected:btn isSelected:YES];
        }else{
            UIButton *btn;
            btn = measurementButtons[0];
            [self setSelected:btn isSelected:YES];
        }
        
        //Carb Section
        UIButton *carbButton;
        BOOL showCustom = false;
        if ([searchDict[@"MinCarb"]intValue] == 0 && [searchDict[@"MaxCarb"]intValue] == 0) {
            carbButton = carbSubsections[0];
        }else if ([searchDict[@"MinCarb"]intValue] == 1 && [searchDict[@"MaxCarb"]intValue] == 19) {
            carbButton = carbSubsections[1];
        }else if ([searchDict[@"MinCarb"]intValue] == 20 && [searchDict[@"MaxCarb"]intValue] == 45) {
            carbButton = carbSubsections[2];
        }else if ([searchDict[@"MinCarb"]intValue] == 1 && [searchDict[@"MaxCarb"]intValue] == 44) {
            carbButton = carbSubsections[3];
        }else if ([searchDict[@"MinCarb"]intValue] == 22 && [searchDict[@"MaxCarb"]intValue] == 45) {
            carbButton = carbSubsections[4];
        }else if ([searchDict[@"MinCarb"]intValue] == 46 && [searchDict[@"MaxCarb"]intValue] == 60) {
            carbButton = carbSubsections[5];
        }else if ([searchDict[@"MinCarb"]intValue] == 61 && [searchDict[@"MaxCarb"]intValue] == 100) {
            carbButton = carbSubsections[6];
        }else if ([searchDict[@"MinCarb"]intValue] >= 0 && [searchDict[@"MaxCarb"]intValue] <= 100) {
            carbButton = carbSubsections[7];
            showCustom = true;
        }
        [self carbsRangeButtonPressed:carbButton];
        if (showCustom) {
            carbsMinTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MinCarb"]];
            carbsMaxTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MaxCarb"]];
        }
        
        //Protein Section
        UIButton *proteinButton;
        showCustom = false;
        if ([searchDict[@"MinProtein"]intValue] == 0 && [searchDict[@"MaxProtein"]intValue] == 0) {
            proteinButton = proteinSubsections[0];
        }else if ([searchDict[@"MinProtein"]intValue] == 1 && [searchDict[@"MaxProtein"]intValue] == 19) {
            proteinButton = proteinSubsections[1];
        }else if ([searchDict[@"MinProtein"]intValue] == 21 && [searchDict[@"MaxProtein"]intValue] == 40) {
            proteinButton = proteinSubsections[2];
        }else if ([searchDict[@"MinProtein"]intValue] == 1 && [searchDict[@"MaxProtein"]intValue] == 39) {
            proteinButton = proteinSubsections[3];
        }else if ([searchDict[@"MinProtein"]intValue] == 22 && [searchDict[@"MaxProtein"]intValue] == 40) {
            proteinButton = proteinSubsections[4];
        }else if ([searchDict[@"MinProtein"]intValue] == 41 && [searchDict[@"MaxProtein"]intValue] == 60) {
            proteinButton = proteinSubsections[5];
        }else if ([searchDict[@"MinProtein"]intValue] == 61 && [searchDict[@"MaxProtein"]intValue] == 100) {
            proteinButton = proteinSubsections[6];
        }else if ([searchDict[@"MinProtein"]intValue] >= 0 && [searchDict[@"MaxProtein"]intValue] <= 100) {
            proteinButton = proteinSubsections[7];
            showCustom = true;
        }
        [self proteinRangeButtonPressed:proteinButton];
        if (showCustom) {
            proteinMinTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MinProtein"]];
            proteinMaxTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MaxProtein"]];
        }
        
        //Fat Section
        UIButton *fatButton;
        showCustom = false;
        if ([searchDict[@"MinFat"]intValue] == 0 && [searchDict[@"MaxFat"]intValue] == 0) {
            fatButton = fatSubsections[0];
        }else if ([searchDict[@"MinFat"]intValue] == 1 && [searchDict[@"MaxFat"]intValue] == 19) {
            fatButton = fatSubsections[1];
        }else if ([searchDict[@"MinFat"]intValue] == 20 && [searchDict[@"MaxFat"]intValue] == 40) {
            fatButton = fatSubsections[2];
        }else if ([searchDict[@"MinFat"]intValue] == 1 && [searchDict[@"MaxFat"]intValue] == 39) {
            fatButton = fatSubsections[3];
        }else if ([searchDict[@"MinFat"]intValue] == 21 && [searchDict[@"MaxFat"]intValue] == 40) {
            fatButton = fatSubsections[4];
        }else if ([searchDict[@"MinFat"]intValue] == 41 && [searchDict[@"MaxFat"]intValue] == 60) {
            fatButton = fatSubsections[5];
        }else if ([searchDict[@"MinFat"]intValue] == 61 && [searchDict[@"MaxFat"]intValue] == 100) {
            fatButton = fatSubsections[6];
        }else if ([searchDict[@"MinFat"]intValue] >= 0 && [searchDict[@"MaxFat"]intValue] <= 100) {
            fatButton = fatSubsections[7];
            showCustom = true;
        }
        [self fatRangeButtonPressed:fatButton];
        if (showCustom) {
            fatMinTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MinFat"]];
            fatMaxTextfield.text = [NSString stringWithFormat:@"%@",searchDict[@"MaxFat"]];
        }
        
//        likeArray @"IngredientIlike"
//        dontLikeArray @"IngredientIDonotlike"
//        proteinArray @"ProteinSearchIngredients"
//        carbArray @"CarbSearchIngredients"
//        @","
        if (![Utility isEmptyCheck:searchDict[@"IngredientIlike"]]) {
            likeArray = [[searchDict[@"IngredientIlike"] componentsSeparatedByString:@","]mutableCopy];
        }
        if (![Utility isEmptyCheck:searchDict[@"IngredientIDonotlike"]]) {
            dontLikeArray = [[searchDict[@"IngredientIDonotlike"] componentsSeparatedByString:@","]mutableCopy];
        }
        if (![Utility isEmptyCheck:searchDict[@"ProteinSearchIngredients"]]) {
            proteinArray = [[searchDict[@"ProteinSearchIngredients"] componentsSeparatedByString:@","]mutableCopy];
        }
        if (![Utility isEmptyCheck:searchDict[@"CarbSearchIngredients"]]) {
            carbArray = [[searchDict[@"CarbSearchIngredients"] componentsSeparatedByString:@","]mutableCopy];
        }
        [foodLikeTable reloadData];
        [dontLikeTable reloadData];
        [favCarbTable reloadData];
        [favProteinTable reloadData];
        
        if ([searchDict[favButton.accessibilityHint]boolValue]) {
//            [favButton setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//            [favButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            favButton.selected = true;
        } else {
//            [favButton setBackgroundColor:[UIColor whiteColor]];
//            [favButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
            favButton.selected = false;
        }
        if (![Utility isEmptyCheck:self->allMealArray]) {
            self->recipeStackView.hidden = false;
            [self->recipeTable reloadData];
        }
    } else {//reset or default First Time
        
        [likeArray removeAllObjects];
        [dontLikeArray removeAllObjects];
        [carbArray removeAllObjects];
        [proteinArray removeAllObjects];
        
        [foodLikeTable reloadData];
        [dontLikeTable reloadData];
        [favCarbTable reloadData];
        [favProteinTable reloadData];
        
        [selectedMealArray removeAllObjects];
        
        [searchDict removeObjectForKey:@"ViewType"];
        
        [searchDict setObject:[NSNumber numberWithInteger:1] forKey:@"MeasurementType"];
        for (UIButton *btn in measurementButtons) {
            if (btn.tag == 1) {
                btn.selected = true;
//                [btn setBackgroundColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0]];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
//                [btn setBackgroundColor:[UIColor whiteColor]];
//                [btn setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
                btn.selected = false;
            }
        }
        
        UIButton *mealTypeButton;
        if(isMyRecipe){
            mealTypeButton = mealTypeButtons[5];
        }else{
            mealTypeButton = mealTypeButtons[0];
        }
        if(!mealTypeButton.isSelected){
            [self mealTypeButtonPressed:mealTypeButton];
        }
        
        UIButton *carbButton = carbSubsections[0];
        if(!carbButton.isSelected){
            [self carbsRangeButtonPressed:carbButton];
        }else{
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MinCarb"];
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MaxCarb"];
        }
        
        UIButton *proteinButton = proteinSubsections[0];
        if(!proteinButton.isSelected){
            [self proteinRangeButtonPressed:proteinButton];
        }else{
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MinProtein"];
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MaxProtein"];
        }
        
        UIButton *fatButton = fatSubsections[0];
        if(!fatButton.isSelected){
            [self fatRangeButtonPressed:fatButton];
        }else{
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MinFat"];
            [searchDict setObject:[NSNumber numberWithInt:0] forKey:@"MaxFat"];
        }
        
        if(dietaryPreferenceArray.count){
            
            UIButton *viewButton = viewButtons[1];
            if(!viewButton.isSelected){
                [self viewTypesButtonPressed:viewButton];
            }else{
                isMyPref = true;
                [self setDefaultSearchParameter:YES];
            }
            
        }
        keywordSearchTextField.text = @"";
        [searchDict removeObjectForKey:@"SearchText"];
        
        [searchDict removeObjectForKey:favButton.accessibilityHint];
//        [favButton setBackgroundColor:[UIColor whiteColor]];
//        [favButton setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
        favButton.selected = false;
        if ([Utility isSquadFreeUser]) {
            UIButton *viewButton = viewButtons[0];
            [self viewTypesButtonPressed:viewButton];
        }
    }
    
    [mainScroll setContentOffset:CGPointZero];
}

-(void)getUserFlags{
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(),^ {
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *dailySession = [NSURLSession sharedSession];
        NSString *userId =[@"" stringByAppendingFormat:@"%@",[defaults objectForKey:@"ABBBCOnlineUserId"]];
        
        NSMutableURLRequest *request = [Utility getRequest:@"" api:@"GetUserFlags" append:userId forAction:@"GET"];
        NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(),^ {
                                                                 self->apiCount--;
                                                                 if (self->apiCount == 0 && self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     //NSLog(@"data by chayan: \n\n %@",responseString);
                                                                     
                                                                     
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                         if (![[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                                             [Utility msg:[responseDictionary objectForKey:@"ErrorMessage"] title:@"Error!" controller:self haveToPop:NO];
                                                                         } else {
                                                                             NSArray *preferenceAll = [responseDictionary objectForKey:@"obj"];
                                                                             self->dietaryPreferenceArray = [preferenceAll filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagCategory == %@)", @"Dietary_Preference"]];
                                                                             if (![Utility isSquadFreeUser]) {
                                                                                 [self viewTypesButtonPressed:self->viewButtons[1]];
                                                                             }
                                                                             
                                                                         }
                                                                     }else{
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

-(void)swapCompleteAction{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Success"
                                  message:@"Meal swapped successfully."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             if([self->delegate respondsToSelector:@selector(didSwapCompleteWithSearchedMeal:)]){
                                 [self->delegate didSwapCompleteWithSearchedMeal:YES];
                             }
                             
                             NSArray *controllers = [self.navigationController viewControllers];
                             for(UIViewController *controller in controllers){
                                 if([controller isKindOfClass: [CustomNutritionPlanListViewController class]]){
                                     [self.navigationController popToViewController:controller animated:true];
                                     break;
                                 }
                             }
                         }];
    
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
   
}

-(void)uncheckAdditionalItems{
    for(UIButton *button in optionalSearchButtons){
        button.selected = false;
//        [button setBackgroundColor:[UIColor whiteColor]];
//        [button setTitleColor:[UIColor colorWithRed:228/255.0f green:39/255.0f blue:160/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
}

-(void)setDefaultSearchParameter:(BOOL)myPref{
    
    if(myPref)
    {
        
        NSArray *filterArray =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Gluten Free"]];
        if (filterArray.count > 0) {
            NSDictionary *dict = filterArray[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"GlutenFree"];
                [self setSelected:glutenFreeButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"GlutenFree"];
                [self setSelected:glutenFreeButton isSelected:NO];
            }
        }
        NSArray *filterArray1 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Dairy Free"]];
        if (filterArray1.count > 0) {
            NSDictionary *dict = filterArray1[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"DairyFree"];
                [self setSelected:dairyFreeButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"DairyFree"];
                [self setSelected:dairyFreeButton isSelected:NO];
            }
        }
        NSArray *filterArray2 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Red Meat"]];
        if (filterArray2.count > 0) {
            NSDictionary *dict = filterArray2[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoRedMeat"];
                [self setSelected:noRedMeatButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoRedMeat"];
                [self setSelected:noRedMeatButton isSelected:NO];
            }
        }
        NSArray *filterArray3 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Seafood"]];
        if (filterArray3.count > 0) {
            NSDictionary *dict = filterArray3[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoSeaFood"];
                [self setSelected:noSeafoodButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoSeaFood"];
                [self setSelected:noSeafoodButton isSelected:NO];
            }
        }
        NSArray *filterArray10 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Sea Food"]];
        if (filterArray10.count > 0) {
            NSDictionary *dict = filterArray10[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoSeaFood"];
                [self setSelected:noSeafoodButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoSeaFood"];
                [self setSelected:noSeafoodButton isSelected:NO];
            }
        }
        NSArray *filterArray4 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"FODMAP Friendly"]];
        if (filterArray4.count > 0) {
            NSDictionary *dict = filterArray4[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"FodmapFriendly"];
                [self setSelected:fodmapFriendlyButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"FodmapFriendly"];
                [self setSelected:fodmapFriendlyButton isSelected:NO];
            }
        }
        NSArray *filterArray5 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Paleo Friendly"]];
        if (filterArray5.count > 0) {
            NSDictionary *dict = filterArray5[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"PaleoFriendly"];
                [self setSelected:paleoFriendlyButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"PaleoFriendly"];
                [self setSelected:paleoFriendlyButton isSelected:NO];
            }
        }
        NSArray *filterArray6 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Eggs"]];
        if (filterArray6.count > 0) {
            NSDictionary *dict = filterArray6[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoEggs"];
                [self setSelected:noEggsButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoEggs"];
                [self setSelected:noEggsButton isSelected:NO];
            }
        }
        NSArray *filterArray7 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Nuts"]];
        if (filterArray7.count > 0) {
            NSDictionary *dict = filterArray7[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoNuts"];
                [self setSelected:noNutsButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoNuts"];
                [self setSelected:noNutsButton isSelected:NO];
            }
        }
        NSArray *filterArray8 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"No Legumes"]];
        if (filterArray8.count > 0) {
            NSDictionary *dict = filterArray8[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithBool:true] forKey:@"NoLegumes"];
                [self setSelected:noLegumesButton isSelected:YES];
            }else{
                [searchDict removeObjectForKey:@"NoLegumes"];
                [self setSelected:noLegumesButton isSelected:NO];
            }
        }
        
        [self setSelected:vegetarianVeganButton isSelected:NO];
        [self setSelected:lectoOvoButton isSelected:NO];
        [self setSelected:pescatarinButton isSelected:NO];
        NSArray *filterArray9 =[dietaryPreferenceArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(FlagTitle == %@)", @"Vegetarian"]];
        if (filterArray9.count > 0) {
            NSDictionary *dict = filterArray9[0];
            if (![Utility isEmptyCheck:dict] && ![Utility isEmptyCheck:dict[@"Value"]] && [dict[@"Value"] intValue] > 0) {
                [searchDict setObject:[NSNumber numberWithInt:[dict[@"Value"] intValue]] forKey:@"Vegetarian"];
                if([searchDict[@"Vegetarian"]intValue] == 3){
                    [self setSelected:vegetarianVeganButton isSelected:YES];
                }else if([searchDict[@"Vegetarian"]intValue] == 2){
                    [self setSelected:lectoOvoButton isSelected:YES];
                }else if([searchDict[@"Vegetarian"]intValue] == 4){
                    [self setSelected:pescatarinButton isSelected:YES];
                }
            }else{
                [searchDict removeObjectForKey:@"Vegetarian"];
                [self setSelected:vegetarianVeganButton isSelected:NO];
                [self setSelected:lectoOvoButton isSelected:NO];
                [self setSelected:pescatarinButton isSelected:NO];
            }
        }
        
    }else{
        
        [searchDict removeObjectForKey:@"GlutenFree"];
        [searchDict removeObjectForKey:@"DairyFree"];
        [searchDict removeObjectForKey:@"NoRedMeat"];
        [searchDict removeObjectForKey:@"NoSeaFood"];
        [searchDict removeObjectForKey:@"FodmapFriendly"];
        [searchDict removeObjectForKey:@"NoEggs"];
        [searchDict removeObjectForKey:@"NoNuts"];
        [searchDict removeObjectForKey:@"NoLegumes"];
        [searchDict removeObjectForKey:@"Vegetarian"];
        [searchDict removeObjectForKey:@"PaleoFriendly"];
        
        [self setSelected:glutenFreeButton isSelected:NO];
        [self setSelected:dairyFreeButton isSelected:NO];
        [self setSelected:noRedMeatButton isSelected:NO];
        [self setSelected:noSeafoodButton isSelected:NO];
        [self setSelected:fodmapFriendlyButton isSelected:NO];
        [self setSelected:noEggsButton isSelected:NO];
        [self setSelected:noNutsButton isSelected:NO];
        [self setSelected:noLegumesButton isSelected:NO];
        [self setSelected:vegetarianVeganButton isSelected:NO];
        [self setSelected:paleoFriendlyButton isSelected:NO];
        [self setSelected:lectoOvoButton isSelected:NO];
        [self setSelected:pescatarinButton isSelected:NO];
        
    }
}

-(BOOL)checkCustomRangesValue{
    BOOL isValidated = true;
    UIButton *carbs = [carbSubsections lastObject];
    if(carbs.selected){
        int carbMin = [carbsMinTextfield.text intValue];
        int carbMax = [carbsMaxTextfield.text intValue];
        
        if(carbMin <1 && carbMax<1){
            /*isValidated = false;
            [Utility msg:@"Please enter minimum and maximum carb range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            carbMin = 0;
            carbMax = 100;
            
        }else if(carbMin <1){
            /*isValidated = false;
            [Utility msg:@"Please enter minimum carb range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            carbMin = 0;
            
        }else if(carbMax <1){
            /*isValidated = false;
            [Utility msg:@"Please enter maximum carb range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            carbMax = 100;
        }else if(carbMin > carbMax){
            isValidated = false;
            [Utility msg:@"Minimum carb range cannot be greater than maximum range" title:@"Warning" controller:self haveToPop:NO];
            return isValidated;
        }
        
        [searchDict setObject:[NSNumber numberWithInt:carbMin] forKey:@"MinCarb"];
        [searchDict setObject:[NSNumber numberWithInt:carbMax] forKey:@"MaxCarb"];
    }
    
    UIButton *protein = [proteinSubsections lastObject];
    if(protein.selected){
        
        int proteinMin = [proteinMinTextfield.text intValue];
        int proteinMax = [proteinMaxTextfield.text intValue];
        
        if(proteinMin <1 && proteinMax<1){
            /*isValidated = false;
            [Utility msg:@"Please enter minimum and maximum protein range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            proteinMin = 0;
            proteinMax = 100;
            
        }else if(proteinMin <1){
            /*isValidated = false;
            [Utility msg:@"Please enter minimum protein range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            proteinMin = 0;
        }else if(proteinMax <1){
            /*isValidated = false;
            [Utility msg:@"Please enter maximum protein range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            proteinMax = 100;
        }else if(proteinMin > proteinMax){
            isValidated = false;
            [Utility msg:@"Minimum protein range cannot be greater than maximum range" title:@"Warning" controller:self haveToPop:NO];
            return isValidated;
        }
        
        [searchDict setObject:[NSNumber numberWithInt:proteinMin] forKey:@"MinProtein"];
        [searchDict setObject:[NSNumber numberWithInt:proteinMax] forKey:@"MaxProtein"];
    }
    
    UIButton *fat = [fatSubsections lastObject];
    if(fat.selected){
        
        int fatMin = [fatMinTextfield.text intValue];
        int fatMax = [fatMaxTextfield.text intValue];
        
        if(fatMin <1 && fatMax<1){
           /* isValidated = false;
            [Utility msg:@"Please enter minimum and maximum fat range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            fatMin = 0;
            fatMax = 100;
            
        }else if(fatMin <1){
            /*isValidated = false;
            [Utility msg:@"Please enter minimum fat range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            fatMin = 0;
        }else if(fatMax <1){
            /*isValidated = false;
            [Utility msg:@"Please enter maximum fat range." title:@"Warning" controller:self haveToPop:NO];
            return isValidated;*/
            fatMax = 100;
        }else if(fatMin > fatMax){
            isValidated = false;
            [Utility msg:@"Minimum fat range cannot be greater than maximum range" title:@"Warning" controller:self haveToPop:NO];
            return isValidated;
        }
        
        [searchDict setObject:[NSNumber numberWithInt:fatMin] forKey:@"MinFat"];
        [searchDict setObject:[NSNumber numberWithInt:fatMax] forKey:@"MaxFat"];
    }
    
    return isValidated;
}
-(void)updateApplySwapView{
    if(_isFromMealMatch){
        searchRecipeListLabel.text = @"Select Meal for Meal Match";
        applySwapView.hidden = true;
    }else if(!_isFromRecipe && !_isFromFoodPrep){
        applySwapView.hidden = false;
        searchRecipeListLabel.text = @"Select Meal for Replace.";
    }else if(_isFromFoodPrep){
        searchRecipeListLabel.text = @"Select Meal to Prep";
        applySwapView.hidden = true;
    }else if(_isFromRecipe){
        searchRecipeListLabel.text = @"Searched Recipe List";
        applySwapView.hidden = true;
    }
}

-(void)resetRangeButtons{
    for (UIButton *button in rangeContentTypeButton) {
        
            button.selected = true;//feedback change
            if (button.isSelected) {
                
                if(button.tag == 0){
                    carbsRangeSectionView.hidden = false;
                }else if(button.tag == 1){
                    proteinRangeSectionView.hidden = false;
                }else{
                    fatRangeSectionView.hidden = false;
                }
                
                [button setImage:[UIImage imageNamed:@"down_arr_search.png"] forState:UIControlStateNormal];
                
            } else {
                if(button.tag == 0){
                    carbsRangeSectionView.hidden = true;
                }else if(button.tag == 1){
                    proteinRangeSectionView.hidden = true;
                }else{
                    fatRangeSectionView.hidden = true;
                }
                [button setImage:[UIImage imageNamed:@"right_arr_setprogram.png"] forState:UIControlStateNormal];
                
            }
        
    }
}

-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        
        if(_isFromRecipe){
            if([delegate respondsToSelector:@selector(isBackToNourish:)]){
                [self.navigationController popViewControllerAnimated:NO];
                [delegate isBackToNourish:YES];
                return;
            }
        }
        
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForFoodPrepSearch:)]) {
            [delegate didCheckAnyChangeForFoodPrepSearch:isChanged];
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark - End
#pragma mark - TableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:searchTable]) {
        return tempSearchArray.count;
    }else if ([tableView isEqual:foodLikeTable]){
        return likeArray.count;
    }else if ([tableView isEqual:dontLikeTable]){
        return dontLikeArray.count;
    }else if ([tableView isEqual:favProteinTable]){
        return proteinArray.count;
    }else if ([tableView isEqual:favCarbTable]){
        return carbArray.count;
    }else if ([tableView isEqual:recipeTable]){
        return allMealArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableCell;
    if ([tableView isEqual:recipeTable ]) {
        RecipeListTableViewCell *cell = (RecipeListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"RecipeListTableViewCell"];
        NSDictionary *mealdetail = allMealArray[indexPath.row][@"mealdetail"];
        
        cell.recipeName.text =![Utility isEmptyCheck:mealdetail[@"MealName"]] ? mealdetail[@"MealName"] :@"";
        NSString *imageString = mealdetail[@"PhotoSmallPath"];
        if (![Utility isEmptyCheck:imageString]) {
            [cell.recipeImage sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"new_image_loading.png"] options:SDWebImageScaleDownLargeImages];
        } else {
            cell.recipeImage.image = [UIImage imageNamed:@"image_loading.png"];
        }
        if (![Utility isEmptyCheck:mealdetail[@"MealClassifiedID"]] && [mealdetail[@"MealClassifiedID"] intValue] == 2) {
            cell.noMeasureMeal.hidden = false;
            [cell.caloriesButton setTitle:[NSString stringWithFormat:@"Unmeasured"] forState:UIControlStateNormal];
        }else{
            cell.noMeasureMeal.hidden = true;
            [cell.caloriesButton setTitle:[NSString stringWithFormat:@"%@ Calories",![Utility isEmptyCheck:mealdetail[@"CalsTotal"]] ? mealdetail[@"CalsTotal"] : @"0.00"] forState:UIControlStateNormal];
        }
        
        int prepMins = [mealdetail[@"PreparationMinutes"] intValue]*60;
        
        [cell.prepTimeButton setTitle:[NSString stringWithFormat:@"%@",prepMins>0 ? [Utility formatTimeFromSeconds:prepMins] : @"0 MIN"] forState:UIControlStateNormal];
        
        //[cell.prepTimeButton setTitle:[NSString stringWithFormat:@"%@ MIN",![Utility isEmptyCheck:mealdetail[@"PreparationMinutes"]] ? mealdetail[@"PreparationMinutes"] : @"0.00"] forState:UIControlStateNormal];
        
        if(_isFromRecipe){
            cell.submittedButton.hidden = true;
        }else{
            cell.submittedButton.hidden = false;
        }
        
        if([selectedMealArray containsObject:allMealArray[indexPath.row]]){
            [cell.submittedButton setTitle:@"SELECTED" forState:UIControlStateNormal];
            [cell.submittedButton setBackgroundColor:[Utility colorWithHexString:@"87d2e4"]];
        }else{
            [cell.submittedButton setTitle:@"SELECT MEAL" forState:UIControlStateNormal];
            [cell.submittedButton setBackgroundColor:[Utility colorWithHexString:@"E427A0"]];
        }
        
        
        cell.submittedButton.tag = indexPath.row;
        cell.editRecipe.tag = indexPath.row;
        tableCell = cell;
    } else if ([tableView isEqual:searchTable ]) {
        foodPrepSearchTableViewCell *cell = (foodPrepSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSString *mealName = tempSearchArray[indexPath.row]; //tempSearchArray[indexPath.row][@"IngredientName"]
        cell.mealNameLabel.text =mealName;
        cell.mealNameLabel.tag = indexPath.row;
        cell.deleteButton.hidden = true;
        tableCell = cell;
    } else if ([tableView isEqual:foodLikeTable ]) {
        foodPrepSearchTableViewCell *cell = (foodPrepSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSString *mealName = likeArray[indexPath.row];//likeArray[indexPath.row][@"IngredientName"];
        cell.mealNameLabel.text =mealName;
        cell.mealNameLabel.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.deleteButton.accessibilityHint = @"like";
        cell.deleteButton.hidden = false;
        tableCell = cell;
    } else if ([tableView isEqual:dontLikeTable ]) {
        foodPrepSearchTableViewCell *cell = (foodPrepSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSString *mealName = dontLikeArray[indexPath.row];//dontLikeArray[indexPath.row][@"IngredientName"];
        cell.mealNameLabel.text =mealName;
        cell.mealNameLabel.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.deleteButton.accessibilityHint = @"dontLike";
        cell.deleteButton.hidden = false;
        tableCell = cell;
    } else if ([tableView isEqual:favProteinTable ]) {
        foodPrepSearchTableViewCell *cell = (foodPrepSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSString *mealName = proteinArray[indexPath.row];//proteinArray[indexPath.row][@"IngredientName"];
        cell.mealNameLabel.text =mealName;
        cell.mealNameLabel.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.deleteButton.accessibilityHint = @"protein";
        cell.deleteButton.hidden = false;
        tableCell = cell;
    } else if ([tableView isEqual:favCarbTable ]) {
        foodPrepSearchTableViewCell *cell = (foodPrepSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
        NSString *mealName = carbArray[indexPath.row];//carbArray[indexPath.row][@"IngredientName"];
        cell.mealNameLabel.text =mealName;
        cell.mealNameLabel.tag = indexPath.row;
        cell.deleteButton.tag = indexPath.row;
        cell.deleteButton.accessibilityHint = @"carb";
        cell.deleteButton.hidden = false;
        tableCell = cell;
    }
    
    return tableCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:searchTable ]) {
        isEditing = true;
        if (activeTextField.tag == 0) {
            
            [self storeElements:likeArray groupName:tempSearchArray[indexPath.row] key:@"IngredientIlike" activeTable:foodLikeTable];
            
        } else if (activeTextField.tag == 1) {
          
            [self storeElements:dontLikeArray groupName:tempSearchArray[indexPath.row] key:@"IngredientIDonotlike" activeTable:dontLikeTable];
            
        } else if (activeTextField.tag == 2) {
            
            [self storeElements:proteinArray groupName:tempSearchArray[indexPath.row] key:@"ProteinSearchIngredients" activeTable:favProteinTable];
            
        } else if (activeTextField.tag == 3) {
            
            [self storeElements:carbArray groupName:tempSearchArray[indexPath.row] key:@"CarbSearchIngredients" activeTable:favCarbTable];
            
        }
        searchView.hidden = true;
        [activeTextField resignFirstResponder];
    }else if ([tableView isEqual:recipeTable]){
        NSDictionary *mealDetails = allMealArray[indexPath.row][@"mealdetail"];
        if (![Utility isEmptyCheck:mealDetails]) {
            if (![Utility isEmptyCheck:mealDetails]) {
                DailyGoodnessDetailViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyGoodnessDetail"];
                controller.mealId = mealDetails[@"Id"];
                controller.mealSessionId = @0;
                controller.Calorie = mealDetails[@"CalsTotal"];
                controller.fromController = @"Food Prep";
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    }
}
-(void)storeElements:(NSMutableArray *)filterArray groupName:(NSString *)groupName key:(NSString *)key activeTable:(UITableView *)activeTable{
    if (![filterArray containsObject:groupName]) {
        [filterArray addObject:groupName];
    }
    
    NSString *title = @"";
    /*if (myArray.count > 0) {
        for (NSDictionary *temp in myArray) {
            if ([title isEqualToString:@""]) {
                title = temp[@"IngredientName"];
            } else {
                if ([title rangeOfString:temp[@"IngredientName"]].location == NSNotFound) {
                    NSLog(@"string does not contain this text");
                    title = [NSString stringWithFormat:@"%@, %@",title,temp[@"IngredientName"]];
                } else {
                    NSLog(@"string contains this text");
                }
            }
        }
    }*/
    
    if(filterArray.count>0){
        title = [filterArray componentsJoinedByString:@","];
    }
    
    
    if (title.length > 0) {
        [searchDict setObject:title forKey:key];
    }else{
        [searchDict removeObjectForKey:key];
    }
    [activeTable reloadData];
}
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
    
    if (activeTextField != nil) {
        CGRect aRect = mainScroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
//          [mainScroll scrollRectToVisible:activeTextField.frame animated:YES];
          
        }
    }
//    else if (activeTextView !=nil) {
//        CGRect aRect = mainScroll.frame;
//        CGRect frame = [mainScroll convertRect:activeTextView.frame fromView:activeTextView.superview];
//        aRect.size.height -= kbSize.height;
//        if (!CGRectContainsPoint(aRect,frame.origin) ) {
//            [mainScroll scrollRectToVisible:frame animated:YES];
//        }
//    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End

#pragma mark - textField Delegate

-(void)changeText:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempSearchArray = [searchArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(self CONTAINS[c] %@)", textField.text]];
        NSLog(@"search for %@", tempSearchArray);
    } else {
        tempSearchArray = searchArray;
    }
    [searchTable reloadData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:keywordSearchTextField]) {
        [self searchButtonPressed:0];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:toolBar];
    
    if ([textField isEqual:searchTextField]) {
        activeTextField = textField;
        //activeTextView = nil;
        textField.layer.cornerRadius=3.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[Utility colorWithHexString:@"e427a0"]CGColor];
        textField.layer.borderWidth= 1.0f;
        
    }
  
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    activeTextField = nil;
    
    if ([textField isEqual:searchTextField]) {
        textField.layer.cornerRadius=3.0f;
        textField.layer.masksToBounds=YES;
        textField.layer.borderColor=[[Utility colorWithHexString:@"333333"]CGColor];
        textField.layer.borderWidth= 1.0f;
    }
    
}
#pragma mark - End
#pragma mark - DropDown Delegate
- (void) didSelectAnyDropdownOptionMultiSelect:(NSString *)type data:(NSDictionary *)selectedData isAdd:(BOOL)isAdd {
    if ([type caseInsensitiveCompare:@"IngredientName"] == NSOrderedSame) {
        NSString *title = IngredientsTextView.text;
        if (![Utility isEmptyCheck:selectedData] && selectedData.count > 0) {
            if (isAdd) {
                if ([IngredientsTextView.text isEqualToString:@""]) {
                    IngredientsTextView.text =[selectedData objectForKey:@"IngredientName"];
                }else{
                    IngredientsTextView.text =[NSString stringWithFormat:@"%@, %@",title,[selectedData objectForKey:@"IngredientName"]];
                }
            } else {
                NSArray *titleArr = [title componentsSeparatedByString:@", "];
                NSMutableArray *titleMutableArr = [titleArr mutableCopy];
                for (int i = 0; i < titleMutableArr.count; i++) {
                    if ([titleMutableArr containsObject:[selectedData objectForKey:@"IngredientName"]]) {
                        [titleMutableArr removeObject:[selectedData objectForKey:@"IngredientName"]];
                    }
                }
                if (titleMutableArr.count > 0)
                    IngredientsTextView.text =[titleMutableArr componentsJoinedByString:@", "];
                else
                    IngredientsTextView.text =@"";
            }
        }
        if (IngredientsTextView.text.length > 0) {
            [searchDict setObject:IngredientsTextView.text forKey:@"SearchIngredients"];
        }
    }
}
#pragma mark - Memory warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - End

#pragma mark - AddEditCustomNutritionViewDelegate

-(void)didCheckAnyChange:(BOOL)ischanged{
    isChanged = ischanged;
}
#pragma mark - End
@end
