//
//  GratitudePopUpViewController.h
//  Squad
//
//  Created by Dhiman on 29/01/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GratitudePopUpViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate,SettingsCustomPickerDelegate,UIGestureRecognizerDelegate>
@property (strong,nonatomic) NSDictionary *dict;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) UIViewController *controller;
@property (strong,nonatomic) NSString *fromWhere;
@end

NS_ASSUME_NONNULL_END
