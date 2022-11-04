//
//  AccountabilityBuddiesListTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 9/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountabilityBuddiesListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cityLabel;

@property (strong, nonatomic) IBOutlet UIButton *mailButton;
@property (strong, nonatomic) IBOutlet UIButton *sortButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *bellButton;
@property (strong, nonatomic) IBOutlet UILabel *unreadMessage;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;


@end
