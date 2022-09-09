//
//  HabitStateDetailsViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 31/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HackerStateDelegate <NSObject>
-(void)reloadData;

@end
@interface HabitStateDetailsViewController : UIViewController{
    id<HackerStateDelegate>statesdelegate;
}
@property (strong,nonatomic) id statesDelegate;
@property (strong,nonatomic) NSString *habitName;
@property (strong,nonatomic) NSString *breakHabitName;
@property (strong,nonatomic) NSArray *habitArray;
@property (strong,nonatomic) NSArray *habitBreakArray;
@property int frequencyId;
@end

NS_ASSUME_NONNULL_END
