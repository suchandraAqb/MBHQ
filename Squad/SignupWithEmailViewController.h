//
//  SignupWithEmailViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 02/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@interface SignupWithEmailViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic) BOOL isFromFb;
@property (nonatomic) BOOL isFromNonSubscribedUser;
@property (strong, nonatomic)  NSString *fName;
@property (strong, nonatomic)  NSString *lName;
@property (strong, nonatomic)  NSString *email;
@property (strong, nonatomic)  NSString *password;
@property ()  BOOL isShowSquadLite;






@end
