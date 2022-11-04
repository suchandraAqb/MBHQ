//
//  MealAddFooterView.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 12/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealAddFooterView : UIView

@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) IBOutlet UICollectionView *mealTypeCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *chooseFromLabel;
@end
