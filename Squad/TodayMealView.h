//
//  TodayMealView.h
//  Squad
//
//  Created by aqb-mac-mini3 on 28/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayMealView : UIView

@property (weak, nonatomic) IBOutlet UILabel *typeOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameTwoLabel;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIButton *mealButton;
@property (weak, nonatomic) IBOutlet UIButton *showMoreButton;
@property (weak, nonatomic) IBOutlet UIView *showMoreButtonView;
@end
