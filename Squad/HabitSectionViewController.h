//
//  HabitSectionViewController.h
//  
//
//  Created by Suchandra Bhattacharya on 02/01/2020.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitSectionViewController : UITableViewHeaderFooterView
@property (strong,nonatomic) IBOutlet UILabel *habitname;
@property (strong,nonatomic) IBOutlet UIButton *habitSectionName;
@property (strong,nonatomic) IBOutlet UIView *seperatorView;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

NS_ASSUME_NONNULL_END
