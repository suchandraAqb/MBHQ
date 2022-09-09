//
//  CompareResultTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 21/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompareResultTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (strong, nonatomic) IBOutlet UILabel *compareDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *compareEdit;
@property (strong, nonatomic) IBOutlet UIButton *compareDelete;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *compareTitleLable;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *compareValueLable;
@property (strong, nonatomic) IBOutlet UIStackView *compareMainStackView;

@property (strong, nonatomic) IBOutlet UIStackView *compareUpperSubStackView;

@property (strong, nonatomic) IBOutlet UIStackView *compareLowerSubStackView;

@end
