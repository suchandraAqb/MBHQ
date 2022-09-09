//
//  LeaderSectionView.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 09/11/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderSectionView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet UIImageView *finisherImageView;
@property (strong, nonatomic) IBOutlet UIButton *detailsFinisherName;
@property (strong, nonatomic) IBOutlet UILabel *detailsFinisherLabel;

@property (strong, nonatomic) IBOutlet UIButton *detailsFavouriteButton;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;

@property (strong, nonatomic) IBOutlet UIView *leaderSectionView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leaderSectionViewHeightConstant;
@property (strong,nonatomic) IBOutlet UILabel *detailsFinisherNameLabel;
@end
