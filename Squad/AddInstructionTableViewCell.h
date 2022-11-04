//
//  AddInstructionTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 05/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInstructionTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *saveInstructionButton;
@property (strong, nonatomic) IBOutlet UITextView *instruction;
@property (strong, nonatomic) IBOutlet UILabel *instructionNumber;

@property (strong, nonatomic) IBOutlet UIButton *deleteInstruction;

@property (weak, nonatomic) IBOutlet UIButton *editInstructionButton;
@property (weak, nonatomic) IBOutlet UIStackView *ingredientSaveView;

@end
