//
//  WebinarListDurationTableViewCell.h
//  Squad
//
//  Created by Admin on 19/02/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebinarListDurationTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *checkUncheckButton;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;

@end

NS_ASSUME_NONNULL_END
