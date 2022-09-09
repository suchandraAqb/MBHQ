//
//  MyPhotosTableViewCell.h
//  Squad
//
//  Created by AQB Mac 4 on 15/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotosTableViewCell : UITableViewCell
@property(strong,nonatomic) IBOutlet UIImageView *bodyImage;
@property(strong,nonatomic) IBOutlet UIView *topView;
@property(strong,nonatomic) IBOutlet UIView *bottomView;
@property(strong,nonatomic) IBOutlet UIButton *expandButton;
@property(strong,nonatomic) IBOutlet UIImageView *arrowImage;
@property(strong,nonatomic) IBOutlet UIButton *addImageButton;
@property(strong,nonatomic) IBOutlet UIButton *galaryImageButton;
@property (strong, nonatomic) IBOutlet UICollectionView *galaryCollectionView;
@property (strong, nonatomic) IBOutlet UIButton *compareButton;
@end
//ah 21.3
