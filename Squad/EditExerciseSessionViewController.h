//
//  EditExerciseSessionViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 11/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "DropdownViewController.h" //ah se(change storyboard too)
#import "EditCircuitViewController.h"

@protocol PersonalizedSessionDelegate <NSObject>
@optional - (void) getSelectedSessionName:(NSString *)name Id:(NSString *)sessionIDStr;
@end

@interface EditExerciseSessionViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, DropdownViewDelegate, EditCktDelegate>
//ah edit
@property (weak, nonatomic) id<PersonalizedSessionDelegate>personalizedSessionDelegate;

@property int exSessionId;
@property (strong, nonatomic) NSString *dt;
@property (strong, nonatomic) NSString *fromController;     //ah 4.5
@property (strong, nonatomic) UIViewController *presentingVC;
-(void)getExerciseDetailsFor:(NSString *)purpose WithSequence:(NSInteger)sequence;
@end
