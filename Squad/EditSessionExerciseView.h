//
//  EditSessionExerciseView.h
//  Squad
//
//  Created by AQB SOLUTIONS on 13/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSessionExerciseView : UIView
//ah edit
@property (strong, nonatomic) IBOutlet UIView *exerciseNumberView;
@property (strong, nonatomic) IBOutlet UILabel *exerciseNumberLabel;
@property (strong, nonatomic) IBOutlet UIButton *exerciseUpArrow;
@property (strong, nonatomic) IBOutlet UIButton *exerciseDownArrow;
@property (strong, nonatomic) IBOutlet UIButton *exerciseNameButton;
@property (strong, nonatomic) IBOutlet UIButton *exerciseViewButton;
@property (strong, nonatomic) IBOutlet UITextField *repGoalTextField;
@property (strong, nonatomic) IBOutlet UITextField *setTextField;
@property (strong, nonatomic) IBOutlet UITextField *restTextField;
@property (strong, nonatomic) IBOutlet UIButton *repUnitButton;
@property (strong, nonatomic) IBOutlet UIButton *restUnitButton;
@property (strong, nonatomic) IBOutlet UITextView *exerciseTipsTextView;
@property (strong, nonatomic) IBOutlet UIButton *exerciseRemoveButton;
@property (strong, nonatomic) IBOutlet UIButton *exerciseAddButton;
@property (strong, nonatomic) IBOutlet UIButton *supersetUndoButton;
@property (strong, nonatomic) IBOutlet UIButton *supersetUpButton;
@property (strong, nonatomic) IBOutlet UIButton *supersetDownButton;
@property (strong, nonatomic) IBOutlet UIButton *supersetDeleteButton;
@property (strong, nonatomic) IBOutlet UIView *exerciseAddRemoveView;
@property (strong, nonatomic) IBOutlet UIView *exerciseSupersetView;
@property (strong, nonatomic) IBOutlet UIButton *exerciseAddSupersetButton;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editExerciseSuperviewTopConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *editExerciseSuperviewBottomConstraint;
@end
