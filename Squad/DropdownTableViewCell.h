//
//  DropdownTableViewCell.h
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropdownTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dropdownName;
@property (strong, nonatomic) IBOutlet UILabel *dropdownMoreInfo;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIImageView *devider;
@end
