//
//  AddCustomSessionViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 06/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditExerciseSessionViewController.h"
#import "DropdownViewController.h"

@protocol AddCustomSessionViewProtocol <NSObject>
-(void)getUpdateSessionId:(int)sessionId;//Feedback - 28032018
@optional - (void) didCheckAnyChange:(BOOL)ischanged;

@end
@interface AddCustomSessionViewController : UIViewController <PersonalizedSessionDelegate, DropdownViewDelegate>{
    id<AddCustomSessionViewProtocol>AddCustomSessionViewDelegate; //Feedback - 28032018
}
@property (nonatomic,strong)id AddCustomSessionViewDelegate; //Feedback - 28032018

//ah aec
@property (nonatomic, strong) NSDate *sessionDate;
@property (nonatomic, strong) NSString *sessionDate1;   //ah se
@property (nonatomic, strong) NSString *weekDate; //AY 07112017

@property NSInteger sessionID;
@property NSInteger exerciseSessionId;
@property() BOOL isFromExerciseDetails;
@end
