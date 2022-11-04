//
//  PrivacyPolicyAndTermsServiceViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 20/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyPolicyAndTermsServiceViewController : UIViewController<UINavigationControllerDelegate>
@property (nonatomic,strong) NSURL * url;
@property BOOL isFromCourse;
@property BOOL isFromCommunity;
@end
