//
//  NonSubscribedAlertTableViewCell.h
//  Squad
//
//  Created by Admin on 13/10/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NonSubscribedAlertTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *courseName;
@property (strong, nonatomic) IBOutlet UIButton *btn;
@property (strong, nonatomic) IBOutlet UIView *booletView;


@end

NS_ASSUME_NONNULL_END
