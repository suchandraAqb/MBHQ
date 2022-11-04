//
//  MyPhotosCollectionViewCell.h
//  Squad
//
//  Created by AQB SOLUTIONS on 21/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPhotosCollectionViewCell : UICollectionViewCell
//ah ph

@property (strong, nonatomic) IBOutlet UIImageView *galaryImageView;

@property (strong, nonatomic) IBOutlet UIImageView *galaryImageViewCompare;
@property (strong, nonatomic) IBOutlet UIView *bgViewCompare;
@property (strong, nonatomic) IBOutlet UIButton *leftButtonCompare;
@property (strong, nonatomic) IBOutlet UIButton *rightButtonCompare;

@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIView *buttonBottomView;
@end
