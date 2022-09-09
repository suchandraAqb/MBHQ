//
//  MealAddViewController.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 13/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealAddViewController.h"
#import "Calorie.h"
#import "MealMatchViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
//chayan 23/10/2017
#import "ProgressBarViewController.h"
#import "foodPrepSearchTableViewCell.h"

@interface MealAddViewController (){
    
    
    IBOutlet UIView *mealTypeView;
    IBOutlet UILabel *mealTypeNameLabel;
    IBOutlet UIButton *mealNameButton;
    
    IBOutletCollection(UIButton) NSArray *mealTypeButton;
    IBOutlet UIView *beforeEatingMealView;
    IBOutlet UIView *afterEatingMealView;
    
    IBOutletCollection(UIButton) NSArray *beforeMealEnergyButtons;
    
    IBOutletCollection(UIButton) NSArray *beforeMealCravingsButtons;
    
    IBOutletCollection(UIButton) NSArray *moodPresentButtons;
    
    IBOutletCollection(UIButton) NSArray *afterMealEnergyButtons;
    
    IBOutletCollection(UIButton) NSArray *afterMealCravingsButtons;
    
    IBOutletCollection(UIButton) NSArray *bloatButtons;
    
    IBOutlet UIButton *mealQuantityButton;
    
    IBOutlet UIView *caloriView;
    IBOutlet UITextField *caloryTextField;
    IBOutlet UIImageView *previewImageView;
    IBOutlet UITextField *furtherNotesTextField;
    
    IBOutlet UIButton *nextButton;
    
    IBOutlet UIScrollView *scroll;
    
    UIView *contentView;
    int apiCount;
    NSArray *mealQuantityArray;
    
    UITextField *activeTextField;
    UIToolbar *toolBar;
    
    
    IBOutletCollection(UIView) NSArray *viewsArray;
    
    IBOutlet UIButton *ingredientButton;
    IBOutlet UIButton *unitsButton;
    IBOutlet UITextField *ingredientTextfield;
    IBOutlet UILabel *caloriLabel;
    NSMutableArray *unitListArray;
    
    //Variables For Save/Update
    
    NSDateFormatter *dailyDateformatter;
    UIImage *selectedImage;
    int BeforeEnergy;
    int BeforeCravings;
    int AfterEnergy;
    int AfterCravings;
    int AfterBloat;
    int MealType;
    NSString *MealName;
    
    int QuantityId;
    float Calories;
    float mealQuantity;
    float ingredientCalori;
    
    //chayan
    bool isNextButtonPressed;
    int savedMealId;
    //chayan 23/10/2017
    BOOL isNextMultiPart;
    
    
    //End
    //03/05/18
    __weak IBOutlet UIView *showHideView;
    __weak IBOutlet UITableView *mealTable;
    __weak IBOutlet UIButton *cancelButton;
//    NSMutableArray *mealListArray;
    int pageNo;
    BOOL isClick;
    BOOL isChanged;
    __weak IBOutlet UITextField *filterTextField;
    NSArray *tempMealArray;
    NSDictionary *searchDict;
    NSArray *ingredientsAllList;
    NSArray *dietaryPreferenceArray;
}

@end

@implementation MealAddViewController
@synthesize isStatic,isAdd,mealTypeData,mealListArray,mealDetails,isStaticIngredient,currentDate,MealId,mealCategory,delegate;
#pragma mark -View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MealType = -1;
    //chayan
    isNextButtonPressed=NO;
    savedMealId=0;
    ingredientCalori=0.0;
    pageNo = 1;
    showHideView.hidden = true;
    mealTable.estimatedRowHeight = 50;
    mealTable.rowHeight = UITableViewAutomaticDimension;
    mealTable.hidden = false;
    cancelButton.layer.cornerRadius=3.0f;
    cancelButton.layer.masksToBounds=YES;
    mealTable.layer.cornerRadius=3.0f;
    mealTable.layer.masksToBounds=YES;
    if((isStatic && !isStaticIngredient && (mealTypeData == 1 || mealTypeData == 2)) || (![Utility isEmptyCheck:mealDetails] && [mealDetails[@"Quantity"] intValue] == 1)){
        
        mealQuantityArray = @[/*@{
                               @"id" : @-2,
                               @"name" : @"------Portion Size I consumed for this meal------"
                               
                               },*/@{
                                       @"id" : @1,
                                       @"name" : @"As per Recipe"
                                       },
                                   @{
                                       @"id" : @-1,
                                       @"name" : @"As per Meal Plan"
                                       
                                       },
                                   @{
                                       @"id" : @0,
                                       @"name" : @"Enter Exact Calories Consumed"
                                       
                                       }
                                   ];
        
    }else{
        mealQuantityArray = @[/*@{
                               @"id" : @-2,
                               @"name" : @"------Portion Size I consumed for this meal------"
                               
                               },*/
                              @{
                                  @"id" : @-1,
                                  @"name" : @"As per Meal Plan"
                                  
                                  },
                              @{
                                  @"id" : @0,
                                  @"name" : @"Enter Exact Calories Consumed"
                                  
                                  }
                              ];
    }
    
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [caloryTextField setInputAccessoryView:toolBar];
    [ingredientTextfield setInputAccessoryView:toolBar];
    [self registerForKeyboardNotifications];
    
    //currentDate = [NSDate date];
    dailyDateformatter = [[NSDateFormatter alloc]init];
    [dailyDateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
    currentDate = [dailyDateformatter dateFromString:dateString];
    mealNameButton.tag= -1;
    ingredientButton.tag=-1;
    unitsButton.tag=-1;
    [self setup_view];
    if (mealTypeData != 3) {
        if (!isStaticIngredient) {
            [self getSquadMealList:mealTypeData mealName:mealDetails isStatic:isStatic];
        } else {
            [self getIngredientList:mealTypeData mealName:mealDetails isStatic:isStatic];
        }
    }
    
    [filterTextField addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkForChange:) name:@"backButtonPressed" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backButtonPressed" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -End

#pragma mark -Private Method
-(BOOL)formValidation{
    BOOL isValidated =  true;
    
    if (MealId <= 0){
        
        [Utility msg:(!isStaticIngredient)?@"Please choose your meal.":@"Please choose your ingredient." title:@"" controller:self haveToPop:false];
        isValidated = false;
    }
    
    
    if(!isStaticIngredient){
        if (MealType < 0){
            
            [Utility msg:@"Please select meal type" title:@"" controller:self haveToPop:false];
            isValidated = false;
        }
    }
    
    if(isStaticIngredient){
        if ([unitsButton.titleLabel.text isEqualToString:@"--Units--"]){
            [Utility msg:@"Please choose ingredient unit." title:@"" controller:self haveToPop:false];
            isValidated = false;
            
        }else  if ([ingredientTextfield.text floatValue] <= 0.0){
            [Utility msg:@"Please enter ingredient quantity." title:@"" controller:self haveToPop:false];
            isValidated = false;
        }
    }
    
    return isValidated;
}

-(void)setup_view {
    
    
    
    if (!mealListArray){
        mealListArray = [[NSMutableArray alloc]init];
    }
    
    if (!unitListArray){
        unitListArray = [[NSMutableArray alloc]init];
    }
    
    mealTypeView.layer.cornerRadius = 5.0 ;
    mealTypeView.clipsToBounds = YES;
    caloriView.hidden = YES;
    beforeEatingMealView.hidden = YES;
    afterEatingMealView.hidden = YES;
    
    
    if (![Utility isEmptyCheck:mealDetails]){
        
        if(!isStaticIngredient){
            MealId = ![Utility isEmptyCheck:mealDetails[@"MealId"]] ? [mealDetails[@"MealId"] intValue]:0;
            if (MealId == 0){
                MealId = ![Utility isEmptyCheck:mealDetails[@"Id"]] ? [mealDetails[@"Id"] intValue]:0;
            }
            
        }else{
            MealId = ![Utility isEmptyCheck:mealDetails[@"IngredientId"]] ? [mealDetails[@"IngredientId"] intValue]:0;
            [self getIngredientUnit];
        }
        NSPredicate *predicate;
        if (isStaticIngredient){
            predicate = [NSPredicate predicateWithFormat:@"(IngredientId == %d)", MealId];
        }else{
            predicate = [NSPredicate predicateWithFormat:@"(Id == %d)", MealId];
            if (!isStatic && ![Utility isEmptyCheck:mealDetails[@"MealId"]] ) {
                predicate = [NSPredicate predicateWithFormat:@"(MealId == %d)", MealId];
            }
        }
        
        NSArray *filteredMealListArray = [mealListArray filteredArrayUsingPredicate:predicate];
        
        if (filteredMealListArray.count>0){
            NSDictionary *dict = [filteredMealListArray lastObject];
            mealNameButton.tag = [mealListArray indexOfObject:dict];
            int mealType = [dict[@"MealType"] intValue];
            if(mealType == 0){
                [self mealTypeButtonPressed:mealTypeButton[0]];
            }else if(mealType == 4){
                [self mealTypeButtonPressed:mealTypeButton[1]];
            }else{
                MealType = 0;
                [self mealTypeButtonPressed:mealTypeButton[0]];
            }
            
            if(!isStaticIngredient){
                MealName =![Utility isEmptyCheck:dict[@"MealName"]] ? dict[@"MealName"] :@"";
            }else{
                ingredientButton.tag= [mealListArray indexOfObject:dict];
                MealName =![Utility isEmptyCheck:dict[@"IngredientName"]] ? dict[@"IngredientName"] :@"";
                [ingredientButton setTitle:MealName forState:UIControlStateNormal];
                
            }
        }
        
        
    }else{
        if(MealId > 0){
            
            NSPredicate *predicate;
            if (isStaticIngredient){
                predicate = [NSPredicate predicateWithFormat:@"(IngredientId == %d)", MealId];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"(Id == %d)", MealId];
            }
            
            NSArray *filteredMealListArray = [mealListArray filteredArrayUsingPredicate:predicate];
            
            if (filteredMealListArray.count>0){
                NSDictionary *dict = [filteredMealListArray lastObject];
                mealNameButton.tag = [mealListArray indexOfObject:dict];
                int mealType = [dict[@"MealType"] intValue];
                if(mealType == 0){
                    [self mealTypeButtonPressed:mealTypeButton[0]];
                }else if(mealType == 4){
                    [self mealTypeButtonPressed:mealTypeButton[1]];
                }else{
                    MealType = 0;
                    [self mealTypeButtonPressed:mealTypeButton[0]];
                }
                
                if(!isStaticIngredient){
                    MealName =![Utility isEmptyCheck:dict[@"MealName"]] ? dict[@"MealName"] :@"";
                    [mealNameButton setTitle:MealName forState:UIControlStateNormal];
                }else{
                    ingredientButton.tag= [mealListArray indexOfObject:dict];
                    MealName =![Utility isEmptyCheck:dict[@"IngredientName"]] ? dict[@"IngredientName"] :@"";
                    [ingredientButton setTitle:MealName forState:UIControlStateNormal];
                    [self getIngredientUnit];
                }
                
                
            }
            
            
        }else{
            MealName = @"";
            MealId = 0;
        }
       
    }
    
    mealTypeNameLabel.text = MealName;
    
    if (!isStatic && !isStaticIngredient){
        [mealNameButton setTitle:MealName forState:UIControlStateNormal];
        //mealNameButton.enabled = false;
    }else if(isStatic && !isStaticIngredient && mealTypeData == 1){
        mealTypeNameLabel.text = @"Squad Recipe List";
    }else if(isStatic && !isStaticIngredient && mealTypeData == 2){
        mealTypeNameLabel.text = @"My Recipe List";
    }else if(isStaticIngredient && mealTypeData == 1){
        mealTypeNameLabel.text = @"Squad Ingredient List";
    }else if(isStaticIngredient && mealTypeData == 2){
        mealTypeNameLabel.text = @"My Ingredient List";
    }
    
    if (isStaticIngredient){
        
        unitsButton.userInteractionEnabled = false;
        ingredientTextfield.userInteractionEnabled = false;
        caloriLabel.text= @"";
        
        for (UIView *view in viewsArray){
            
            if ([view.accessibilityHint isEqualToString:@"ingredient"]){
                view.hidden = false;
            }else{
                view.hidden = true;
            }
            
            if (!isAdd){
                if ([view.accessibilityHint isEqualToString:@"beforeeating"] || [view.accessibilityHint isEqualToString:@"aftereating"] || [view.accessibilityHint isEqualToString:@"ingredient"]){
                    view.hidden = false;
                }else{
                    view.hidden = true;
                }
            }
        }
    }
    
    mealQuantityButton.tag = 0;
    [mealQuantityButton setTitle:mealQuantityArray[0][@"name"] forState:UIControlStateNormal];
    QuantityId = [mealQuantityArray[0][@"id"] intValue]; // -1
    
    if (![Utility isEmptyCheck:mealDetails] && !isAdd){
        
        mealNameButton.enabled = true;
        nextButton.enabled = false;
        
        if (!isStaticIngredient){
            
            for (UIView *view in viewsArray){
                
                if ([view.accessibilityHint isEqualToString:@"ingredient"] || [view.accessibilityHint isEqualToString:@"caloriview"]){
                    view.hidden = true;
                }else{
                    view.hidden = false;
                }
            }
            
            MealType = [mealDetails[@"MealType"] intValue];
            
            for (UIButton *button in mealTypeButton){
                if (button.tag == MealType){
                    button.selected = true;
                }else{
                    button.selected = false;
                }
            }
            
            
            QuantityId = [mealDetails[@"Quantity"] intValue];
            
            if (QuantityId == 0){
                //mealQuantityButton.tag = 2;
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                caloriView.hidden = false;
                
                caloryTextField.text = [@"" stringByAppendingFormat:@"%.2f",![Utility isEmptyCheck:mealDetails[@"Calories"]] ? [mealDetails[@"Calories"] floatValue] :0.0];
                
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }else if (QuantityId == -1){
                //mealQuantityButton.tag = 1;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }else if (QuantityId == 1){
                //mealQuantityButton.tag = 0;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %d",QuantityId];
                NSArray *arr = [mealQuantityArray filteredArrayUsingPredicate:predicate];
                [mealQuantityButton setTitle:[arr firstObject][@"name"] forState:UIControlStateNormal];
                mealQuantityButton.tag = [mealQuantityArray indexOfObject:[arr firstObject]];
            }
            
        }else{
            
            if(![Utility isEmptyCheck:mealDetails[@"MetricUnit"]]){
                [unitsButton setTitle:mealDetails[@"MetricUnit"] forState:UIControlStateNormal];
            }
            
            if(![Utility isEmptyCheck:mealDetails[@"QtyMetric"]]){
                ingredientTextfield.text = [@"" stringByAppendingFormat:@"%@",mealDetails[@"QtyMetric"]];
            }
            
            
            
            //            [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QtyMetric"];
            //            [dataDict setObject:unitsButton.titleLabel.text forKey:@"MetricUnit"];
            //            [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
            //            [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"IngredientQuantity"];
            //            [dataDict setObject:MealName forKey:@"IngredientName"];
        }
        
        
        
        BeforeEnergy = [mealDetails[@"BeforeEnergy"] intValue];
        
        for (UIButton *button in beforeMealEnergyButtons){
            
            if (BeforeEnergy == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        BeforeCravings = [mealDetails[@"BeforeCravings"] intValue];
        
        for (UIButton *button in beforeMealCravingsButtons){
            
            if (BeforeCravings == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterEnergy = [mealDetails[@"AfterEnergy"] intValue];
        
        for (UIButton *button in afterMealEnergyButtons){
            
            if (AfterEnergy == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterCravings = [mealDetails[@"AfterCravings"] intValue];
        
        for (UIButton *button in afterMealCravingsButtons){
            
            if (AfterCravings == button.tag){
                
                button.selected = YES;
                
            }else{
                
                button.selected = NO;
            }
        }
        
        AfterBloat = [mealDetails[@"AfterBloat"] intValue];
        
        for (UIButton *button in bloatButtons){
            
            if (AfterBloat == button.tag){
                
                button.selected = YES;
                
            }else{
                button.selected = NO;
            }
        }
        
        for (UIButton *button in moodPresentButtons){
            button.selected = [[mealDetails objectForKey:button.accessibilityHint] boolValue];
        }
        
        
        
        if(![Utility isEmptyCheck:mealDetails[@"Description"]]){
            furtherNotesTextField.text = mealDetails[@"Description"];
        }
        
        if(![Utility isEmptyCheck:mealDetails[@"Photo"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                    selectedImage = previewImageView.image;
                                }];
            
        }
    }
    if(![Utility isEmptyCheck:mealDetails[@"PhotoSmallPath"]]){
        
        [previewImageView sd_setImageWithURL:[NSURL URLWithString:mealDetails[@"PhotoSmallPath"]]
                            placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                self->selectedImage = self->previewImageView.image;
                            }];
        
    }
}

- (void)openEditor
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = selectedImage;
    controller.keepingCropAspectRatio = YES;
    controller.cropAspectRatio = 2.0/3.0;
    
//        UIImage *image = selectedImage;
//        CGFloat width = image.size.width;
//        CGFloat height = image.size.height;
//        CGFloat length = MIN(width, height);
//        controller.imageCropRect = CGRectMake((width - length) / 2,
//                                              (height - length) / 2,
//                                              length/2,
//                                              length);
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}
-(void)openPhotoAlbum{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:controller animated:YES completion:NULL];
}
-(void)showCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:controller animated:YES completion:NULL];
    }else{
        [Utility msg:@"Camera Not Available." title:@"Warning !" controller:self haveToPop:NO];
    }
    
}

-(NSMutableDictionary *)createAddUpdateData{
    
    NSMutableDictionary *dataDict = [[NSMutableDictionary alloc]init];
    
    //chayan 23/10/2017 selected image part not needed as multipart
//    if (![Utility isEmptyCheck:selectedImage]) {
//        NSString *imgBase64Str = [UIImagePNGRepresentation(selectedImage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//        [dataDict setObject:imgBase64Str forKey:@"Photo"];
//    }else{
//        [dataDict setObject:@"" forKey:@"Photo"];
//    }
    [dataDict setObject:@"" forKey:@"Photo"];
    
    
    if(!isStaticIngredient){
        
        [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"MealId"];
        [dataDict setObject:[NSNumber numberWithInt:QuantityId] forKey:@"Quantity"];
        
        if (QuantityId == 0){
            NSString *calori = caloryTextField.text;
            [dataDict setObject:[NSNumber numberWithFloat:[calori floatValue]] forKey:@"Calories"];
        }
        
        [dataDict setObject:[NSNumber numberWithInt:MealType] forKey:@"MealType"];
        [dataDict setObject:MealName forKey:@"MealName"];
        
    }else{
        
        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"QtyMetric"];
        [dataDict setObject:unitsButton.titleLabel.text forKey:@"MetricUnit"];
        [dataDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
//        [dataDict setObject:[NSNumber numberWithDouble:[ingredientTextfield.text floatValue]] forKey:@"IngredientQuantity"];
        [dataDict setObject:MealName forKey:@"IngredientName"];
    }
    
    
//    [dataDict setObject:[NSNumber numberWithInt:mealCategory] forKey:@"MealCatagory"];
    [dataDict setObject:[NSNumber numberWithInt:BeforeEnergy] forKey:@"BeforeEnergy"];
    [dataDict setObject:[NSNumber numberWithInt:BeforeCravings] forKey:@"BeforeCravings"];
    [dataDict setObject:[NSNumber numberWithInt:AfterEnergy] forKey:@"AfterEnergy"];
    [dataDict setObject:[NSNumber numberWithInt:AfterCravings] forKey:@"AfterCravings"];
    [dataDict setObject:[NSNumber numberWithInt:AfterBloat] forKey:@"AfterBloat"];
    [dataDict setObject:furtherNotesTextField.text forKey:@"Description"];
    
    if (isAdd){
        
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [dataDict setObject:dateString forKey:@"DateTime"];
        }
        
    }else{
        //chayan
        if (isNextButtonPressed) {
            
            [dataDict setObject:[NSNumber numberWithInt:savedMealId] forKey:@"Id"];
            
        }
        else if (![Utility isEmptyCheck:mealDetails]){
            [dataDict setObject:[NSNumber numberWithInt:[mealDetails[@"Id"] intValue]] forKey:@"Id"];
            
            NSString *dateAdded = mealDetails[@"DateAdded"];
            [dataDict setObject:dateAdded forKey:@"DateTime"];
            
            
        }
        
        
    }
    
    
    for (UIButton *button in moodPresentButtons){
        [dataDict setObject:[NSNumber numberWithBool:button.isSelected] forKey:button.accessibilityHint];
    }
    
    return dataDict;
    
}
-(void)backToMealMatch{
    NSArray *controllers = [self.navigationController viewControllers];
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
        [delegate didCheckAnyChangeForMealAdd:isChanged with:YES];
    }
    if(controllers.count > 3 && [[controllers objectAtIndex:controllers.count-3] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-3] animated:true];
    }else if(controllers.count > 4 &&[[controllers objectAtIndex:controllers.count-4] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-4] animated:true];
    }
    else if(controllers.count > 5 && [[controllers objectAtIndex:controllers.count-5] isKindOfClass:[MealMatchViewController class]]){
        [self.navigationController popToViewController:[controllers objectAtIndex:controllers.count-5] animated:true];
    }
    else {
        [self.navigationController popViewControllerAnimated:true];
    }
    
}

-(void)getSquadMealList:(int)mealTypeData mealName:(NSDictionary *)mealdetails isStatic:(BOOL)isStatic{
    if (Utility.reachable) {
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:pageNo] forKey:@"PageNo"];
        [mainDict setObject:[NSNumber numberWithInt:15] forKey:@"ItemsPerPage"];

        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        if (!isClick) {
            dispatch_async(dispatch_get_main_queue(), ^{
                apiCount++;
                if (contentView) {
                    [contentView removeFromSuperview];
                }
                
                contentView = [Utility activityIndicatorView:self];
                //contentView.backgroundColor = [UIColor clearColor];
                
            });
        }
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
                                                                         if(![Utility isEmptyCheck:responseDict[@"SquadUserActualMealList"]]){
                                                                             
//                                                                             MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
//
//                                                                             controller.currentDate = currentDate;
//                                                                             controller.isAdd = true;
//                                                                             controller.isStatic = isStatic;
//                                                                             controller.mealTypeData = mealTypeData;
//                                                                             controller.mealDetails = mealdetails;
//                                                                             controller.mealListArray = responseDict[@"SquadUserActualMealList"];
//                                                                             //                                                                             controller.mealCategory = mealCategory;
//                                                                             [self.navigationController pushViewController:controller animated:true];
                                                                             if (!self->mealListArray) {
                                                                                 self->mealListArray = [[NSMutableArray alloc]init];
                                                                             }
                                                                             NSArray *tempArray = [responseDict objectForKey:@"SquadUserActualMealList"];
                                                                             if(![Utility isEmptyCheck:tempArray])[self->mealListArray addObjectsFromArray: tempArray];
                                                                             self->mealTable.hidden = false;
                                                                             [self->mealTable reloadData];
                                                                             [self setup_view];
                                                                         }
                                                                         
                                                                     }
                                                                     else{
                                                                         self->pageNo--;
                                                                         [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     self->pageNo--;
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
                                                                         
                                                                         
//                                                                         MealAddViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MealAddView"];
//                                                                         controller.currentDate = currentDate;
//                                                                         controller.isAdd = true;
//                                                                         controller.isStatic = isStatic;
//                                                                         controller.isStaticIngredient = true;
//                                                                         controller.mealTypeData = mealTypeData;
//                                                                         controller.mealDetails = mealdetails;
//                                                                         controller.mealListArray = [responseDict objectForKey:@"Ingredients"];
//                                                                         [self.navigationController pushViewController:controller animated:true];
                                                                         if (!self->mealListArray) {
                                                                             self->mealListArray = [[NSMutableArray alloc]init];
                                                                         }
                                                                         NSArray *tempArray = [responseDict objectForKey:@"Ingredients"];
                                                                         if(![Utility isEmptyCheck:tempArray])[self->mealListArray addObjectsFromArray: tempArray];
                                                                         [self setup_view];
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

-(void)checkForChange:(NSNotification*)notification{
    if ([notification.name isEqualToString:@"backButtonPressed"]) {
        if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
            [delegate didCheckAnyChangeForMealAdd:isChanged with:NO];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -End

#pragma mark -Webservice Call
-(void)addUpdateActualMealMatch:(bool)isNext{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate] && isAdd) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
        
        
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"AddSquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         //chayan
                                                                         if (isNext) {
                                                                             savedMealId=[responseDict[@"Id"] intValue];
                                                                             isAdd=NO;
                                                                             isNextButtonPressed=YES;
                                                                             beforeEatingMealView.hidden = NO;
                                                                             afterEatingMealView.hidden = NO;
                                                                             nextButton.enabled = NO;
                                                                             mealNameButton.enabled = true;
                                                                         }
                                                                         else{
                                                                             [self backToMealMatch];
                                                                             
                                                                         }
                                                                         
                                                                         
                                                                         
                                                                         
                                                                         //                                                                         [Utility msg:@"Meal added successfully" title:@"Success" controller:self haveToPop:NO];
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


//chayan 23/10/2017
-(void)addUpdateActualMealMatchMultiPart:(bool)isNext{
    
    if (Utility.reachable) {
        
        isNextMultiPart=isNext;
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate] && isAdd) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        ProgressBarViewController *controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProgressBar"];
        controller.delegate=self;
        controller.apiName=@"AddSquadUserActualMealWithPhoto";
        controller.appendString=@"";
        controller.jsonString=jsonString;
        controller.chosenImage=selectedImage;
        controller.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}





-(void)getActualMealMatchData{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        if (![Utility isEmptyCheck:currentDate]) {
            NSString *dateString = [dailyDateformatter stringFromDate:currentDate];
            [mainDict setObject:dateString forKey:@"Datetime"];
        }
        
        [mainDict setObject:[NSNumber numberWithInt:mealTypeData] forKey:@"RecipeMealTracker"];
        [mainDict setObject:[NSNumber numberWithInt:0] forKey:@"MealOrder"];
        
        [mainDict setObject:[self createAddUpdateData] forKey:@"SquadUserActualMealModel"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMyDaySquadUserActualMeal" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         [self backToMealMatch];
                                                                         
                                                                         //                                                                         [Utility msg:@"Meal added successfully" title:@"Success" controller:self haveToPop:NO];
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

-(void)getIngredientUnit{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientById" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         
                                                                         if (![Utility isEmptyCheck:responseDict[@"IngredientDetail"]]){
                                                                             
                                                                             NSDictionary *dict = responseDict[@"IngredientDetail"];
                                                                             int unitPrefererence = [[defaults objectForKey:@"UnitPreference"] intValue];
                                                                             
                                                                             [unitListArray removeAllObjects];
                                                                             unitsButton.userInteractionEnabled = true;
                                                                             
                                                                             if (unitPrefererence == 0 || unitPrefererence == 1){
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"UnitMetric"]]){
                                                                                     [unitListArray addObject:dict[@"UnitMetric"]] ;                                                                }
                                                                                 
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"ConversionUnit"]]){
                                                                                     [unitListArray addObject:dict[@"ConversionUnit"]] ;                                                                }
                                                                                 
                                                                                 
                                                                             }else{
                                                                                 if (![Utility isEmptyCheck:dict[@"UnitImperial"]]){
                                                                                     [unitListArray addObject:dict[@"UnitImperial"]] ;                                                                }
                                                                                 
                                                                                 
                                                                                 if (![Utility isEmptyCheck:dict[@"ConversionUnit"]]){
                                                                                     [unitListArray addObject:dict[@"ConversionUnit"]] ;                                                                }
                                                                                 
                                                                             }
                                                                             
                                                                             if (unitListArray.count == 1){
                                                                                 [unitsButton setTitle:unitListArray[0] forState:UIControlStateNormal];
                                                                                 unitsButton.tag = 0;
                                                                                 ingredientTextfield.userInteractionEnabled = true;
                                                                             }
                                                                             
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

-(void)getCaloriUnit{
    
    if (Utility.reachable) {
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserSessionId"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"ABBBCOnlineUserId"] forKey:@"UserId"];
        [mainDict setObject:AccessKey_ABBBC forKey:@"Key"];
        [mainDict setObject:[NSNumber numberWithInt:MealId] forKey:@"IngredientId"];
        
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
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetIngredientDetailsApiCall" append:@""forAction:@"POST"];
        
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
                                                                     
                                                                     NSLog(@"%@",responseDict);
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"]boolValue]) {
                                                                         NSDictionary *dict = responseDict[@"IngredientDetail"];
                                                                         
                                                                         float quantity = [ingredientTextfield.text floatValue];
                                                                         float CalsPer100 = [dict[@"CalsPer100"] floatValue];
                                                                         
                                                                         NSString *calories = @"Calories: ";
                                                                         NSString *unit = unitsButton.titleLabel.text;
                                                                         
                                                                         if (quantity > 0){
                                                                             if(CalsPer100 > 0){
                                                                                 ingredientCalori = CalsPer100*quantity/100;
                                                                                 calories = [calories stringByAppendingFormat:@"%.2f",ingredientCalori];
                                                                             }else{
                                                                                 Calorie *cal =[Utility ingredientCalorieCalculation:quantity proteinPer100:[dict[@"ProteinPer100"] floatValue] fatPer100:[dict[@"FatPer100"] floatValue] carbPer100:[dict[@"CarbsPer100"] floatValue] alcoholPer100:[dict[@"AlcoholPer100"] floatValue] unit:unit conversionUnit:dict[@"ConversionUnit"] conversionFactor:[dict[@"ConversionNum"] floatValue]];
                                                                                 ingredientCalori = [[Utility totalCalories:cal] floatValue];
                                                                                 calories  = [calories stringByAppendingFormat:@"%.2f",ingredientCalori];
                                                                                 
                                                                             }
                                                                             
                                                                             caloriLabel.text = calories;
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

#pragma mark -End

#pragma mark -IBAction
- (IBAction)backButtonPressed:(UIButton *)sender {
    if ([delegate respondsToSelector:@selector(didCheckAnyChangeForMealAdd:with:)]) {
        [delegate didCheckAnyChangeForMealAdd:isChanged with:NO];
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
- (IBAction)saveButtonPressed:(UIButton *)sender {
    
    if ([self formValidation]){
        [self addUpdateActualMealMatchMultiPart:NO];
    }
}

- (IBAction)nextButtonPressed:(UIButton *)sender {
    [self.view endEditing:true];
    
    
    // chayan
    if ([self formValidation]){
        [self addUpdateActualMealMatchMultiPart:YES];
    }
    
}

- (IBAction)cameraButtonPressed:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil      //  Must be "nil", otherwise a blank title area will appear above our two buttons
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  //  UIAlertController will automatically dismiss the view
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Take photo"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self showCamera];
                              }];
    
    UIAlertAction* button2 = [UIAlertAction
                              actionWithTitle:@"Open Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self openPhotoAlbum];
                              }];
    
    [alert addAction:button0];
    [alert addAction:button1];
    [alert addAction:button2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)mealQuantityButtonPressed:(UIButton *)sender {
    
    mealQuantityButton.accessibilityHint = @"quantity";
    DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.dropdownDataArray = mealQuantityArray;
    controller.mainKey = @"name";
    controller.delegate = self;
    controller.sender = sender;
    controller.selectedIndex = (int)sender.tag;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)bloatButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in bloatButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterBloat = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)afterMealCravingsButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in afterMealCravingsButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterCravings = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)afterMealEnergyButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in afterMealEnergyButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            AfterEnergy = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)moodPresentButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in moodPresentButtons){
        
        if (sender.tag == button.tag){
            
            if (button.isSelected){
                button.selected = NO;
            }else{
                button.selected = YES;
            }
            
        }
    }
}

- (IBAction)beforeMealCravingsButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in beforeMealCravingsButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            BeforeCravings = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)beforeMealEnergyButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in beforeMealEnergyButtons){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            BeforeEnergy = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)mealTypeButtonPressed:(UIButton *)sender {
    
    for (UIButton *button in mealTypeButton){
        
        if (sender.tag == button.tag){
            
            button.selected = YES;
            MealType = (int)sender.tag;
            
        }else{
            
            button.selected = NO;
        }
    }
}

- (IBAction)mealNameButtonPressed:(UIButton *)sender {
    if (mealListArray.count == 0) {
        
        if(mealTypeData == 2){
            [Utility msg:@"No Meal found.Please create one." title:@"Oops! " controller:self haveToPop:NO];
        }
        return;
    }
    if(mealTypeData == 3){
        return;
    }
    if (mealListArray.count > 0){
//        isClick = true;
//        mealNameButton.accessibilityHint = @"mealname";
//        showHideView.hidden = false;
//        [mealTable reloadData];
        
//        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.dropdownDataArray = mealListArray;
//        controller.mainKey = @"MealName";
//        controller.delegate = self;
//        controller.sender = sender;
//        controller.selectedIndex = (int)sender.tag;
//        [self presentViewController:controller animated:YES completion:nil];
        
        FoodPrepSearchViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FoodPrepSearch"];
        controller.delegate=self;
        controller.sender = sender;
        controller.isFromMealMatch = YES;
        if(mealTypeData == 2){
            controller.isMyRecipe = YES;
        }else{
            controller.isMyRecipe = NO;
        }
        if (![Utility isEmptyCheck:searchDict]) {
            controller.defaultSearchDict = [searchDict mutableCopy];
        }
        if (![Utility isEmptyCheck:ingredientsAllList]) {
            controller.ingredientsAllList = ingredientsAllList;
        }
        if (![Utility isEmptyCheck:dietaryPreferenceArray]) {
            controller.dietaryPreferenceArray = dietaryPreferenceArray;
        }
        controller.delegate = self;
        //controller.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        [Utility msg:@"No Meal name found" title:@"Oops! " controller:self haveToPop:NO];
    }
    
}

- (IBAction)ingredientButtonPressed:(UIButton *)sender {
    if(mealTypeData == 3){
        return;
    }
    if (mealListArray.count > 0){
        
        ingredientButton.accessibilityHint = @"ingredient";
        filterTextField.text = @"";
        tempMealArray = [NSArray arrayWithArray:mealListArray];
        showHideView.hidden = false;
        [mealTable reloadData];
//        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
//        controller.modalPresentationStyle = UIModalPresentationCustom;
//        controller.dropdownDataArray = mealListArray;
//        controller.mainKey = @"IngredientName";
//        controller.delegate = self;
//        controller.sender = sender;
//        controller.selectedIndex = (int)sender.tag;
//        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"No Ingredient data found" title:@"Oops! " controller:self haveToPop:NO];
    }
}

- (IBAction)unitButtonPressed:(UIButton *)sender {
    
    if (unitListArray.count > 0){
        
        unitsButton.accessibilityHint = @"unit";
        DropdownViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Dropdown"];
        controller.modalPresentationStyle = UIModalPresentationCustom;
        controller.dropdownDataArray = unitListArray;
        controller.delegate = self;
        controller.sender = sender;
        controller.selectedIndex = (int)sender.tag;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        [Utility msg:@"No Unit data found" title:@"Oops! " controller:self haveToPop:NO];
    }
}
- (IBAction)donePressed:(UIButton *)sender {
    if(activeTextField){
        [self.view endEditing:YES];
    }else{
        showHideView.hidden = true;
    }
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    showHideView.hidden = true;
}
#pragma mark -End

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
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    if (!showHideView.isHidden) {
        mealTable.contentInset = contentInsets;
        mealTable.scrollIndicatorInsets = contentInsets;
    }
    
    if (activeTextField !=nil) {
        CGRect aRect = scroll.frame;
        aRect.size.height -= kbSize.height;
        if (!CGRectContainsPoint(aRect, activeTextField.frame.origin) ) {
            [scroll scrollRectToVisible:activeTextField.frame animated:YES];
        }
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scroll.contentInset = contentInsets;
    scroll.scrollIndicatorInsets = contentInsets;
    if (!showHideView.isHidden) {
        mealTable.contentInset = contentInsets;
        mealTable.scrollIndicatorInsets = contentInsets;
    }
}

-(void)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}

#pragma mark - End -
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if (textField.text.length > 0) {
        tempMealArray = [mealListArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(IngredientName CONTAINS[c] %@)", textField.text]];
    } else {
        tempMealArray = mealListArray;
    }
    [mealTable reloadData];
}
#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField = textField;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == ingredientTextfield){
        if ([ingredientTextfield.text floatValue]>0){
            [self getCaloriUnit];
        }
    }
    
    activeTextField = nil;
}
#pragma mark - End
#pragma mark -TableView Datasource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tempMealArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    foodPrepSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodPrepSearchTableViewCell"];
    
//    cell.mealNameLabel.text = ![Utility isEmptyCheck:mealListArray[indexPath.row][@"MealName"]]?mealListArray[indexPath.row][@"MealName"]:@"";
    NSString *ingredientName = ![Utility isEmptyCheck:tempMealArray[indexPath.row][@"IngredientName"]]?tempMealArray[indexPath.row][@"IngredientName"]:@"";
    cell.mealNameLabel.text = ingredientName;
//    if ([ingredientButton.currentTitle isEqualToString:ingredientName]) {
//        [cell.mealNameLabel setTextColor:[UIColor whiteColor]];
//        [cell.mealNameLabel setBackgroundColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
//    } else {
//        [cell.mealNameLabel setTextColor:[UIColor colorWithRed:(228/255.0f) green:(39/255.0f) blue:(160/255.0f) alpha:1.0f]];
//        [cell.mealNameLabel setBackgroundColor:[UIColor whiteColor]];
//    }
    tableCell = cell;
    
    return tableCell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(![Utility isEmptyCheck:mealListArray] && mealListArray.count>0){
//        if (!isStaticIngredient && mealTypeData != 3) {
//            if(indexPath.row == mealListArray.count-1){
//                pageNo=pageNo+1;
//                [self getSquadMealList:mealTypeData mealName:mealDetails isStatic:isStatic];
//            }
//        }
//    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if ([tableView isEqual:mealTable]) {
//        NSDictionary *data = mealListArray[indexPath.row];
//        [mealNameButton setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
//        MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
//        MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
//        mealNameButton.tag = [mealListArray indexOfObject:data];
//
//        int mealType = [data[@"MealType"] intValue];
//        if(mealType == 0){
//            MealType = 0;
//            [self mealTypeButtonPressed:mealTypeButton[0]];
//        }else if(mealType == 4){
//            MealType = 4;
//            [self mealTypeButtonPressed:mealTypeButton[1]];
//        }else{
//            MealType = 0;
//            [self mealTypeButtonPressed:mealTypeButton[0]];
//        }
//
//        if (!isStatic && !isStaticIngredient){
//            mealTypeNameLabel.text = MealName;
//        }
//
//        if(![Utility isEmptyCheck:data[@"Photo"]]){
//
//            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"Photo"]]
//                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                    //                                        selectedImage = previewImageView.image;
//                                }];
//
//        }
//    }
    if ([tableView isEqual:mealTable]) {
        showHideView.hidden = true;
        NSDictionary *data = tempMealArray[indexPath.row];
        [ingredientButton setTitle:![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"" forState:UIControlStateNormal];
        MealName = ![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"";
        MealId = ![Utility isEmptyCheck:data[@"IngredientId"]] ? [data[@"IngredientId"] intValue] :0;
        ingredientButton.tag = [mealListArray indexOfObject:data];
        [self getIngredientUnit];
        [self.view endEditing:YES];
    }
}
#pragma mark - End
#pragma mark -Dropdown Delegate
- (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender{
    
    
    if (![Utility isEmptyCheck:data]){
        
        if ([sender.accessibilityHint isEqualToString:@"mealname"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
            MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
            MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
            sender.tag = [mealListArray indexOfObject:data];
            
            int mealType = [data[@"MealType"] intValue];
            if(mealType == 0){
                MealType = 0;
                [self mealTypeButtonPressed:mealTypeButton[0]];
            }else if(mealType == 4){
                 MealType = 4;
                [self mealTypeButtonPressed:mealTypeButton[1]];
            }else{
                MealType = 0;
                [self mealTypeButtonPressed:mealTypeButton[0]];
            }
            
            if (!isStatic && !isStaticIngredient){
                mealTypeNameLabel.text = MealName;
            }
            
            
        }else if ([sender.accessibilityHint isEqualToString:@"quantity"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"name"]] ? data[@"name"] :@"" forState:UIControlStateNormal];
            int quantityId = [data[@"id"] intValue];
            
            QuantityId = quantityId;
            
            if (quantityId == 0){
                caloriView.hidden = false;
            }else{
                caloriView.hidden = true;
            }
            
            sender.tag = [mealQuantityArray indexOfObject:data];
            
        }else if ([sender.accessibilityHint isEqualToString:@"ingredient"]){
            
            [sender setTitle:![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"" forState:UIControlStateNormal];
            MealName = ![Utility isEmptyCheck:data[@"IngredientName"]] ? data[@"IngredientName"] :@"";
            MealId = ![Utility isEmptyCheck:data[@"IngredientId"]] ? [data[@"IngredientId"] intValue] :0;
            sender.tag = [mealListArray indexOfObject:data];
            [self getIngredientUnit];
            
        }
    }
}

- (void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type{
    
    if ([sender.accessibilityHint isEqualToString:@"unit"]){
        
        [sender setTitle:selectedValue forState:UIControlStateNormal];
        sender.tag = [unitListArray indexOfObject:selectedValue];
        ingredientTextfield.userInteractionEnabled = true;
    }
}
#pragma mark -End

#pragma mark - UIImagePickerControllerDelegate methods

/*
 Open PECropViewController automattically when image selected.
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    image =[Utility scaleImage:image width:image.size.width height:image.size.height];
    previewImageView.image = image;
    selectedImage=image;
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor];
    }];
}
#pragma mark - End
#pragma mark - PECropViewControllerDelegate methods

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    //    userImageView.image = croppedImage;
    //    UIImage *image=[self scaleImage:croppedImage];
    previewImageView.image = croppedImage;
    selectedImage = croppedImage;
    
    //    [self writeImageInDocumentsDirectory:chosenImage];
    //    [self webservicecallForUploadImage];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //[self updateEditButtonEnabled];
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}



//chayan 23/10/2017
#pragma mark progressbar delegate

- (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"Success"] boolValue]) {
            if (isNextMultiPart) {
                savedMealId=[responseDict[@"Id"] intValue];
                isAdd=NO;
                isNextButtonPressed=YES;
                beforeEatingMealView.hidden = NO;
                afterEatingMealView.hidden = NO;
                nextButton.enabled = NO;
                mealNameButton.enabled = true;
            }
            else{
                isChanged = true;
                [self backToMealMatch];
                
            }
            
        }
        else{
            [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
            return;
        }
    });
}


- (void) completedWithError:(NSError *)error{
    
    [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
}



#pragma Mark End

#pragma mark - Advance Search Delegate

-(void)didSelectSearchOption:(NSMutableDictionary *)searchDict sender:(UIButton *)sender{
    
    if (![Utility isEmptyCheck:searchDict]) {
        
        NSDictionary *data = searchDict;
        
        [mealNameButton setTitle:![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"" forState:UIControlStateNormal];
        MealName = ![Utility isEmptyCheck:data[@"MealName"]] ? data[@"MealName"] :@"";
        MealId = ![Utility isEmptyCheck:data[@"Id"]] ? [data[@"Id"] intValue] :0;
        mealNameButton.tag = [mealListArray indexOfObject:data];
        
        int mealType = [data[@"MealType"] intValue];
        if(mealType == 0){
            MealType = 0;
            [self mealTypeButtonPressed:mealTypeButton[0]];
        }else if(mealType == 4){
            MealType = 4;
            [self mealTypeButtonPressed:mealTypeButton[1]];
        }else{
            MealType = 0;
            [self mealTypeButtonPressed:mealTypeButton[0]];
        }
        
        if (!isStatic && !isStaticIngredient){
            mealTypeNameLabel.text = MealName;
        }
        
        if(![Utility isEmptyCheck:data[@"Photo"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"Photo"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
            
        }else if(![Utility isEmptyCheck:data[@"PhotoPath"]]){
            
            [previewImageView sd_setImageWithURL:[NSURL URLWithString:data[@"PhotoPath"]]
                                placeholderImage:[UIImage imageNamed:@"meal_no_img.png"] options:SDWebImageScaleDownLargeImages completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                    //                                        selectedImage = previewImageView.image;
                                }];
            
        }
    }
}
-(void)mealSerachWithFilterData:(NSDictionary *)dict ingredientsAllList:(NSArray *)ingredientsAllList dietaryPreferenceArray:(NSArray *)dietaryPreferenceArray{
    self->searchDict = dict;
    self->ingredientsAllList = ingredientsAllList;
    self->dietaryPreferenceArray = dietaryPreferenceArray;
}
#pragma mark - End

@end
