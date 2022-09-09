//
//  InitialViewController.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 04/06/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InitialViewController : UIViewController
@property()BOOL isShowTrialInfoView;
@property()BOOL isPresented;
@property(nonatomic,weak)UINavigationController *presentingNav;
@property()BOOL openLoginView;
@end
