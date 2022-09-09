//
//  NonSubscribedAlertViewController.h
//  Squad
//
//  Created by Admin on 12/10/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NonSubscribedAlertTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NonSubscribedAlertViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UIViewController *parent;
@property (strong,nonatomic) NSString *sectionName;


@end

NS_ASSUME_NONNULL_END
