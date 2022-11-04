//
//  SessionListTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *sessionName;
@property(strong,nonatomic) IBOutlet UIButton *favButton;
@property(strong,nonatomic) IBOutlet UILabel *doneCount;
@property(strong,nonatomic) IBOutlet UIButton *doneButton;
@property(strong,nonatomic) IBOutlet UIView *shadowView;
@property(strong,nonatomic) IBOutlet UIButton *submitButton;
@property(strong,nonatomic) IBOutlet UIButton *editSessionButton;
@property (strong,nonatomic) IBOutlet UIButton *checkUncheckTickButton;

//29/06/18
@property (weak, nonatomic) IBOutlet UIButton *workoutType;
@property (weak, nonatomic) IBOutlet UIButton *bodyType;
@property (weak, nonatomic) IBOutlet UILabel *sessionTime;

@property (weak, nonatomic) IBOutlet UIImageView *bodyImage;
@end
