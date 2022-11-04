//
//  DietaryCollectionViewCell.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 29/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietaryCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic) IBOutlet UIButton *checkUncheckButton;
@property(strong,nonatomic) IBOutlet UILabel *dietaryFlagTitle;
@property(strong,nonatomic) IBOutlet UILabel *VegetarianOptionLabel;
@property (strong,nonatomic) IBOutlet UIView *collectionMainView;
@end
