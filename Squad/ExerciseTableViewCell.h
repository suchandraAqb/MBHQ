//
//  ExerciseTableViewCell.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 21/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *exerciseTitle;
@property (strong, nonatomic) IBOutlet UIButton *checkUncheckButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@end
