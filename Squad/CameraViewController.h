//
//  CameraViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 11/07/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"

@protocol CameraDelegate
-(void) didFinishedTakingPhoto:(UIImage *)capturedImage;
@end

@interface CameraViewController : UIViewController
@property (weak, nonatomic) id<CameraDelegate>cameraDelegate;
@end
//ah newt
