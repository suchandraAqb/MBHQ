//
//  ConnectTableViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 07/12/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *listImageView;
@property (strong, nonatomic) IBOutlet UILabel *listLabel;
@property (strong,nonatomic) IBOutlet UIButton *discoverableButton; //add_discover
@property (strong,nonatomic) IBOutlet UILabel *discoveablelabel;
@end
