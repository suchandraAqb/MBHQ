//
//  HabitHackerDetailsViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 03/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HackerDetailsDelegate <NSObject>
-(void)reloadData;

@end
@interface HabitHackerDetailsViewController : UIViewController<DatePickerViewControllerDelegate>{
    id<HackerDetailsDelegate>hackerdelegate;
}
@property (strong,nonatomic)id hackerdelegate;

@property (strong, nonatomic) IBOutlet UIPageControl *createpageControl;
@property (strong, nonatomic) IBOutlet UIPageControl *breakPageControl;


@end

NS_ASSUME_NONNULL_END
