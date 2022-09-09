//
//  OtherShoppingTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 28/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherShoppingTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UILabel *otherItemName;
@property(strong,nonatomic) IBOutlet UIButton *delButton;
@property(strong,nonatomic) IBOutlet UIButton *purchaseButton;
@property(strong,nonatomic) IBOutlet UILabel *quantityLabel; //AY 120302018
@property(strong,nonatomic) IBOutlet UIView *separatorView; //AY 120302018
@property(strong,nonatomic) IBOutlet UIButton *showCompletedButton; //AY 120302018
@property(strong,nonatomic) IBOutlet UIButton *showIngredientButton; //AY 120302018
@end
