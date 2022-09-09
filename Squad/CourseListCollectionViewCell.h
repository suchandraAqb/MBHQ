//
//  CourseListCollectionViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 15/5/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//
//////created Ru

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CourseListCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) IBOutlet UIImageView *CouserImage;

@property(strong, nonatomic) IBOutlet UILabel *courseMemberLabel;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *courseActionName;
@property(strong, nonatomic) IBOutlet UILabel *courseModuleLabel;

@property(strong, nonatomic) IBOutlet UIButton *courseInfoButton;
@property(strong, nonatomic) IBOutlet UIButton *courseLockButton;
@property (strong, nonatomic) IBOutlet UIButton *courseNameButton;
@property (strong, nonatomic) IBOutlet UIButton *courseActionButton;

@property (strong, nonatomic) IBOutlet UIView *memberView;

@property (strong, nonatomic) IBOutlet UIButton *lockButton;

@end




NS_ASSUME_NONNULL_END
