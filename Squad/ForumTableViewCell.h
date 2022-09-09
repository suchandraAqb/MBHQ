//
//  ForumTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 15/09/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *forumImage;
@property (strong,nonatomic) IBOutlet UILabel *forumTitle;
@property (strong,nonatomic) IBOutlet UILabel *forumDescrip;
@property (strong,nonatomic) IBOutlet UILabel *forumTag;
@property (strong,nonatomic) IBOutlet UILabel *forumDate;
@property (strong,nonatomic) IBOutlet UILabel *forumPost;
@property (strong,nonatomic) IBOutlet UIButton *joinButton;
@end
