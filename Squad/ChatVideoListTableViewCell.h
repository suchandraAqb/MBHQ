//
//  ChatVideoListTableViewCell.h
//  TRANSFORM ASHY BINES
//
//  Created by Admin on 22/11/20.
//  Copyright © 2020 Dhiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatVideoListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *videoView;
@property (strong, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoAuthorLabel;
@property (strong, nonatomic) IBOutlet TagListView *tagButtonView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tagButtonViewHeightConstraint;
@property (strong,nonatomic) IBOutlet UIButton *videoButton;
@property (strong, nonatomic) IBOutlet UIImageView *placeholderImage;
@end

NS_ASSUME_NONNULL_END
