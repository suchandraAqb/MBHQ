//
//  FilterTableViewCell.h
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *filterName;
@property (strong, nonatomic) IBOutlet UILabel *filterMoreInfo;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@end
