//
//  ResultsTableViewCell.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 09/01/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ResultsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end

NS_ASSUME_NONNULL_END
