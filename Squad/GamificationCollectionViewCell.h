//
//  GamificationCollectionViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 19/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GamificationCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic) IBOutlet UIImageView *badgesImage;
@property (strong,nonatomic) IBOutlet UILabel *badgeName;
@property (strong,nonatomic) IBOutlet UIImageView *lockImg;
@property (strong,nonatomic) IBOutlet NSLayoutConstraint *badgeNameYConstraint;
@end
