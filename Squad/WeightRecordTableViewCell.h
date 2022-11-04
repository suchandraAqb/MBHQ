//
//  WeightRecordTableViewCell.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 23/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *circuitNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *addSetButton;
@property (strong, nonatomic) IBOutlet UILabel *recommendedSetLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewHistoryButton;
@property (strong, nonatomic) IBOutlet UIStackView *weightSheetStackView;
@property (strong, nonatomic) IBOutlet UILabel *superSetLabel;
@property (strong, nonatomic) IBOutlet UIView *separatorView;
@property (strong, nonatomic) IBOutlet UIButton *exerciseNameButton; //AY 21112017

@end
