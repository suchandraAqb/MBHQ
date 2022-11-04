//
//  AddShoppingTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 28/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddShoppingTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UITextField *itemName;
@property(strong,nonatomic) IBOutlet UITextField *quantity;
@property(strong,nonatomic) IBOutlet UIButton *selectCategory;

@end
