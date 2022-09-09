//
//  AddIngredientsTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 05/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddIngredientsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *ingredientSave;
@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (strong, nonatomic) IBOutlet UIButton *ingredientNameButton;
@property (strong, nonatomic) IBOutlet UITextField *ingredientQuantity;
@property (strong, nonatomic) IBOutlet UIButton *ingredientQuantityInfo;
@property (strong, nonatomic) IBOutlet UIButton *ingredientUnit;
@property (strong, nonatomic) IBOutlet UIButton *ingredientCalorieInfoButton;
@property (strong, nonatomic) IBOutlet UILabel *ingredientCalorie;
@property (strong, nonatomic) IBOutlet UIButton *deleteIngredient;
@property (strong, nonatomic) IBOutlet UIView *unitView;

@property (strong, nonatomic) IBOutlet UIView *quantityView;
@property (strong, nonatomic) IBOutlet UIStackView *mainStackView;

@property (weak, nonatomic) IBOutlet UIView *ingredientDetailsView;
@property (weak, nonatomic) IBOutlet UIView *ingredientSaveView;
@property (weak, nonatomic) IBOutlet UIButton *editIngredientButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingrSaveHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ingrDetailsHeight;
@property (strong, nonatomic) IBOutlet UIButton *popUpButton;


@end
