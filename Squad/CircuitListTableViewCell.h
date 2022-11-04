//
//  CircuitListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 10/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircuitListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *circuitName;
@property (strong, nonatomic) IBOutlet UIButton *circuitEdit;
@property (strong, nonatomic) IBOutlet UIButton *circuitDetails;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end
