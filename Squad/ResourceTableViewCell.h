//
//  ResourceTableViewCell.h
//  Squad
//
//  Created by aqb-mac-mini3 on 05/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResourceTableViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *resourceImage;
@property (weak, nonatomic) IBOutlet UILabel *resourceName;

@end
