//
//  MyPhotosCompareViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 11/07/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImageViewController.h"
#import "PECropViewController.h"

@interface MyPhotosCompareViewController : UIViewController <AddPhotoDelegate, UIGestureRecognizerDelegate, PECropViewControllerDelegate>
//ah ph(storyboard)
@property (strong, nonatomic) NSDictionary *responseDictionary;
@end
