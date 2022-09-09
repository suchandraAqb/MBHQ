//
//  AllMessageDetailsTableViewCell.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 24/06/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllMessageDetailsTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *dateLabel;
@property (strong,nonatomic) IBOutlet UIButton *readunreadButton;
@property (strong,nonatomic) IBOutlet UITextView *messageTextView;
@property (strong,nonatomic) IBOutlet UIView *readUnreadView;
@property (strong,nonatomic) IBOutlet UIView *messageView;
@end

NS_ASSUME_NONNULL_END
