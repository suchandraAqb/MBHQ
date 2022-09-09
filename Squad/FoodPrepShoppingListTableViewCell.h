//
//  FoodPrepShoppingListTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 06/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPrepShoppingListTableViewCell : UITableViewCell

@property(strong,nonatomic) IBOutlet UILabel *ingredientName;
@property(strong,nonatomic) IBOutlet UIButton *purchasedButton;
@property(strong,nonatomic) IBOutlet UILabel *quantityLabel; 
@property(strong,nonatomic) IBOutlet UIButton *showCompletedButton;
@property(strong,nonatomic) IBOutlet UIButton *showIngredientButton;

@property(strong,nonatomic) IBOutlet UIButton *ingredientButton;
@end
