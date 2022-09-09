//
//  SharePicDataViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 03/08/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"

@protocol PicDataDelegate <NSObject>
@optional - (void) getPicDataLeftWeight:(NSString *)leftWeight RightWeight:(NSString *)rightWeight LeftDate:(NSString *)leftDate RightDate:(NSString *)rightDate;
@end

@interface SharePicDataViewController : UIViewController<DatePickerViewControllerDelegate>
//ah ph (main storyboard & storyboard)

@property (weak, nonatomic) id<PicDataDelegate>picDataDelegate;
@property (strong, nonatomic) NSString *prevLeftWeight;
@property (strong, nonatomic) NSString *prevRightWeight;
@property (strong, nonatomic) NSString *prevLeftDate;
@property (strong, nonatomic) NSString *prevRightDate;
@end
