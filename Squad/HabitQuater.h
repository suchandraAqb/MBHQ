//
//  HabitQuater.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 03/01/2020.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitQuater : UITableViewHeaderFooterView
@property (strong,nonatomic) IBOutlet UILabel *habitQauterName;
@property (strong,nonatomic) IBOutlet UIButton *habitSectionName;
@property (strong,nonatomic) IBOutlet UIView *seperatorView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

NS_ASSUME_NONNULL_END
