//
//  AllMessageTableViewCell.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 21/06/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllMessageTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIButton *authorImageButton;
@property (strong,nonatomic) IBOutlet UILabel *authorName;
@property (strong,nonatomic) IBOutlet UILabel *releaseDate;
@property (strong,nonatomic) IBOutlet UIButton *readUnreadStatus;
@end

NS_ASSUME_NONNULL_END
