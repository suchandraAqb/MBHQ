//
//  ShoppingList.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingList : UITableViewHeaderFooterView
@property(strong,nonatomic) IBOutlet UILabel *headerLabel;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *headerLabelLeadingConstraint;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint *bottomLineViewLeadingConstraint;
@property(strong,nonatomic) IBOutlet UIView *bottomLineView;
@property(strong,nonatomic) IBOutlet UIView *headerBg;
@end
