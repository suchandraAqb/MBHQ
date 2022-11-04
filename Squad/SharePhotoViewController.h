//
//  SharePhotoViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 02/08/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "SharePicDataViewController.h"

@interface SharePhotoViewController : UIViewController<PicDataDelegate>
//ah ph (main storyboard & storyboard)

@property (strong, nonatomic) UIImage *img;
@end
