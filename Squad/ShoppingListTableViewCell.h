//
//  ShoppingListTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *ingredientName;
@property(strong,nonatomic) IBOutlet UIButton *purchasedButton;
@property(strong,nonatomic) IBOutlet UIButton *alreadyhaveItButton;
@property(strong,nonatomic) IBOutlet UILabel *quantityLabel; //AY 120302018
@property(strong,nonatomic) IBOutlet UIButton *showCompletedButton; //AY 120302018
@property(strong,nonatomic) IBOutlet UIButton *showIngredientButton; //AY 120302018
@property(strong,nonatomic) IBOutlet UIView *separatorView; //AY 120302018
@end
