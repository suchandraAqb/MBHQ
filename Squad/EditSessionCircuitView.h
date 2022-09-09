//
//  EditSessionCircuitView.h
//  Squad
//
//  Created by AQB SOLUTIONS on 13/04/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSessionCircuitView : UIView
//ah edit
@property (strong, nonatomic) IBOutlet UIView *circuitNumberView;
@property (strong, nonatomic) IBOutlet UILabel *circuitNumber;
@property (strong, nonatomic) IBOutlet UIButton *circuitUpArrow;
@property (strong, nonatomic) IBOutlet UIButton *circuitDownArrow;
@property (strong, nonatomic) IBOutlet UIButton *circuitNameButton;
@property (strong, nonatomic) IBOutlet UIButton *circuitEditButton;
@property (strong, nonatomic) IBOutlet UIButton *circuitViewButton;
@property (strong, nonatomic) IBOutlet UILabel *circuitTipsLabel;
@property (strong, nonatomic) IBOutlet UIButton *circuitRemoveButton;
@property (strong, nonatomic) IBOutlet UIButton *circuitAddButton;

@end
