//
//  ShopifyCollectionViewCell.h
//  The Life
//
//  Created by AQB Mac 4 on 17/10/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopifyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *productImage;
@property (strong, nonatomic) IBOutlet UILabel *productTitle;
@end
