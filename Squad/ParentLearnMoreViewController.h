//
//  ParentLearnMoreViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 15/10/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+animatedGIF.h"
NS_ASSUME_NONNULL_BEGIN

@interface ParentLearnMoreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property int pageCount;
@property int selectIndex;
@end

NS_ASSUME_NONNULL_END
