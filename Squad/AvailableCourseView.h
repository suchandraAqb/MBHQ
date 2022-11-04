//
//  AvailableCourseView.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvailableCourseView : UIView
@property (strong, nonatomic) IBOutlet UIButton *courseNameButton;
@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UILabel *courseType;
@property (strong, nonatomic) IBOutlet UIButton *courseAction;
@property (strong, nonatomic) IBOutlet UILabel *courseActionName;

@end
