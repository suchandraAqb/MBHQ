//
//  VisionCollectionViewCell.h
//  Squad
//
//  Created by aqb-mac-mini3 on 02/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VisionCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *visionImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end
