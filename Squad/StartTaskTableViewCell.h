//
//  StartTaskTableViewCell.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 21/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartTaskTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *taskCountButton;
@property (strong, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) IBOutlet UIButton *taskCheckButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;

@end
