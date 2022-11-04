//
//  EditCircuitViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 24/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownViewController.h"

@protocol EditCktDelegate <NSObject>

@optional - (void) doneEditingWithSessionID:(int)exSessionId;
@optional - (void) didCheckAnyChange:(BOOL)ischanged; //Local_Catch
@end

@interface EditCircuitViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate, DropdownViewDelegate>
//ah se

@property int cktID;
@property int oldCktID;    //ah 2.5
@property int exSessionId;
@property BOOL isNewCkt;
@property int sequence;    //ah 2.5
@property (strong, nonatomic) NSString *fromController;     //ah 4.5

@property (strong, nonatomic) NSString* dt;    //ah 2.5

@property (weak, nonatomic) id <EditCktDelegate>editCktDelegate;
@end
