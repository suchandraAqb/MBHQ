//
//  FindMeABuddyListTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 25/10/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindMeABuddyListTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UIImageView *buddiesMemberImage;
@property (strong,nonatomic) IBOutlet UILabel *buddiesMessageLabel;
@property (strong,nonatomic) IBOutlet UILabel *buddiesNameLabel;
@property (strong,nonatomic) IBOutlet UIButton *requestButton;

@property (strong,nonatomic) IBOutlet UILabel *myBuddiesLabel;
@property (strong,nonatomic) IBOutlet UIImageView *buddiesImg;
@property (strong,nonatomic) IBOutlet UIView *buddiesLocationView;
@property (strong,nonatomic) IBOutlet UILabel *buddiesLocationLabel;
@property (strong,nonatomic) IBOutlet UIButton *buddiesChatButton;
@end
