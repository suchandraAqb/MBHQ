//
//  IngredientListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IngredientListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *ingredientEditButton;
@property (strong, nonatomic) IBOutlet UILabel *ingredientName;
@property (strong, nonatomic) IBOutlet UIButton *submittedButton;
@property (strong, nonatomic) IBOutlet UILabel *calsPer100;
@property (strong, nonatomic) IBOutlet UILabel *protinePer100;
@property (strong, nonatomic) IBOutlet UILabel *fatPer100;
@property (strong, nonatomic) IBOutlet UILabel *carbsPer100;
@property (strong, nonatomic) IBOutlet UIStackView *ingredientNameContainer;

@property (strong, nonatomic) IBOutlet UILabel *calsPer100Label;
@property (strong, nonatomic) IBOutlet UILabel *protinePer100Label;
@property (strong, nonatomic) IBOutlet UILabel *fatPer100Label;
@property (strong, nonatomic) IBOutlet UILabel *carbsPer100Label;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *submittedButtonWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ingredientEditButtonWidthConstraint;



@end
