//
//  HomeTableViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (strong,nonatomic) IBOutlet UILabel *programsLabel;
@property (strong,nonatomic) IBOutlet UIView *programBorderView;
@property (strong,nonatomic) IBOutlet UIView *overlayView;

//helpTable
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
