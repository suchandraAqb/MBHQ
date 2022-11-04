//
//  BlankListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlankListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UILabel *todoDate;
@property (strong, nonatomic) IBOutlet UILabel *todoDescription;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

@end
