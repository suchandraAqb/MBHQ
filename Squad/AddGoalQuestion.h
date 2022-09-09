//
//  AddGoalQuestion.h
//  Squad
//
//  Created by AQB SOLUTIONS on 09/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddGoalQuestion : UIView

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *answerTextViewHeight;
@end
