//
//  CustomAlertViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 22/2/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomAlertViewDelegate <NSObject>
@optional + (void) sendActionToController:(UIViewController *)sender isSubscribed:(BOOL)isSubscribed ofType:(UIViewController *)ofType isDowngrade:(BOOL)isDowngrade isUpgrade:(BOOL)isUpgrade;
@optional + (void)redirectToAppstore;
@optional + (void) sendActionToControllerForTrialUser:(UIViewController *)sender ofType:(UIViewController *)ofType;
@optional + (void) redirectionForInappPromo:(UIViewController *)sender withData:(NSDictionary *)data;
@optional + (void) welcomeAlertAction:(UIViewController *)sender;
@optional + (void) redirectionForSetProgram:(UIViewController *)sender withData:(NSDictionary *)data;
@optional + (void) redirectionToLogin:(UIViewController *)sender;

@end
@interface CustomAlertViewController : UIViewController{
    id<CustomAlertViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UILabel *alertTitle;
@property (strong, nonatomic) IBOutlet UILabel *alertMsg;
@property (weak, nonatomic) IBOutlet UILabel *bottomAlertMsg;
@property (weak, nonatomic) IBOutlet UIButton *bottomAlertActionButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *noThanksLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomAlertTitleLabel;




@property (strong, nonatomic)  NSString *alertMsgString;
@property (strong, nonatomic)  NSString *alertTitleString;
@property (strong, nonatomic)  NSString *actionButtonTitleString;
@property (strong, nonatomic)  NSDictionary *inAppPromoData;
@property (strong, nonatomic)  NSDictionary *setProgramData;

@property (strong, nonatomic)  UIViewController *fromContoller;
@property (strong, nonatomic)  UIViewController *ofType;
@property (assign)  BOOL isSubscribed;
@property (assign)  BOOL haveToShowCross;
@property (assign)  BOOL isDowngrade;
@property (assign)  BOOL isUpgrade;
@property (assign)  BOOL isAppstoreAlert;
@property (assign)  BOOL trialUserAlert;
@property (assign)  BOOL isShowBottomAlert;
@property (assign)  BOOL isUpsaleAlert;
@property (assign)  BOOL isInAppPromo;
@property (assign)  BOOL isCancelSubsAlert;
@property (assign)  BOOL isWelcomeTrialAlert;
@property (assign)  BOOL isSetProgramSubsAlert;





@end
