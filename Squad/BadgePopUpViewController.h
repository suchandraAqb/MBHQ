//
//  BadgePopUpViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 05/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgePopUpViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,PECropViewControllerDelegate>
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *colourCode;
@property (strong,nonatomic) NSString *pointRange;
@property (strong,nonatomic) NSDictionary *streakDict;
@property (strong,nonatomic) UIViewController *parentcontroller;
@property BOOL isFromGami;
@end
