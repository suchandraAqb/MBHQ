//
//  CoursePodcastTableViewCell.h
//  Squad
//
//  Created by Admin on 22/01/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoursePodcastTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *courseListImage;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *courseActionName;
@property(strong, nonatomic) IBOutlet UILabel *courseModuleLabel;
@property(strong, nonatomic) IBOutlet UIButton *courseLockButton;
@property (strong, nonatomic) IBOutlet UIButton *courseActionButton;
@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

NS_ASSUME_NONNULL_END
