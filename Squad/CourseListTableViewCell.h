//
//  CourseListTableViewCell.h
//  Squad
//
//  Created by Rupbani Mukherjee on 01/08/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseListTableViewCell : UITableViewCell

//@property (strong,nonatomic) IBOutlet UIButton *CourseListImage;

@property (strong, nonatomic) IBOutlet UIImageView *courseListImage;

@property(strong, nonatomic) IBOutlet UILabel *memberLabel;
@property(strong, nonatomic) IBOutlet UILabel *courseLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *courseActionName;
@property(strong, nonatomic) IBOutlet UILabel *courseModuleLabel;

@property(strong, nonatomic) IBOutlet UIButton *courseInfoButton;
@property(strong, nonatomic) IBOutlet UIButton *courseLockButton;
@property (strong, nonatomic) IBOutlet UIButton *courseNameButton;
@property (strong, nonatomic) IBOutlet UIButton *courseActionButton;

@property (strong, nonatomic) IBOutlet UIView *memberView;
@property (strong, nonatomic) IBOutlet UIButton *checkButton;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

NS_ASSUME_NONNULL_END
