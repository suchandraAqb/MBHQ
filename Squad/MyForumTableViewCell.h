//
//  MyForumTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 18/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyForumTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *forumImage;
@property (strong,nonatomic) IBOutlet UILabel * forumDetails;
@property (strong,nonatomic) IBOutlet UILabel *forumRules;
@property (strong,nonatomic) IBOutlet UILabel *forumTitle;
@property (strong,nonatomic) IBOutlet UILabel *forumDescrip;
@property (strong,nonatomic) IBOutlet UILabel *forumTag;
@property (strong,nonatomic) IBOutlet UILabel *forumDate;
@property (strong,nonatomic) IBOutlet UILabel *forumPost;
@property (strong,nonatomic) IBOutlet UIButton *removeButton;
@property (strong,nonatomic) IBOutlet UIButton *chatButton;

@end
