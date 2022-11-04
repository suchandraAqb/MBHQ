//
//  DietaryTableViewCell.h
//  Squad
//
//  Created by aqbsol iPhone on 02/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ingredientName;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end
