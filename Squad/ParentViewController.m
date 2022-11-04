 /*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Manages the child view controllers: iOSProductsList and iOSPurchasesList.
         Displays a Restore button that allows you to restore all previously purchased
         non-consumable and auto-renewable subscription products. Request product information
         about a list of product identifiers using StoreManager. Calls StoreObserver to implement
         the restoration of purchases.
 */


#import "MyModel.h"
#import "StoreManager.h"
#import "StoreObserver.h"
#import "ParentViewController.h"
#import "LoginController.h"
#import "PrivacyPolicyAndTermsServiceViewController.h"
#import "ParentLearnMoreViewController.h"
#import "InitialViewController.h"
#define PopularProduct @"SQ_3M1"
#define SquadLite @"Sq_LITE1"
@interface ParentViewController (){
    
    IBOutletCollection(UIButton) NSArray *productButtonArray;
    IBOutletCollection(UILabel) NSArray *priceLabelArray;
    IBOutletCollection(UILabel) NSArray *productNamelabelArray;
    IBOutletCollection(UILabel) NSArray *upfrontPriceLabelArray;
    IBOutletCollection(UIView) NSArray *containerArray;

    IBOutlet UITextView *termsAndConditionTextView;
    IBOutlet UILabel* freeTrialLabel;
    IBOutlet UIButton* backButton;
    

    NSArray *availableProducts;
    UIView *contentView;
    int apiCount;
    int selectedIndex;
    NSString *productId;
    CGFloat productNumberFont;
    CGFloat productTextFont;
    NSString *productMiddleBgImageName;
    NSString *productBgImageName;
    NSString *selectedProductMiddleBgImageName;
    NSString *selectedProductBgImageName;
    NSMutableAttributedString *textRenewableProduct;
    NSMutableAttributedString *textNonRenewableProduct;

    __weak IBOutlet UIButton *mostPopularButton;
    __weak IBOutlet UIButton *signupNowButton;
    __weak IBOutlet UIButton *nextButton;
    __weak IBOutlet UIButton *squadLiteButton;
    
    IBOutletCollection(UILabel) NSArray *workoutQueenLabelArr;
    IBOutletCollection(UILabel) NSArray *nutritionMasterLabelArr;
    IBOutletCollection(UILabel) NSArray *cleanUpLabelArr;
    IBOutletCollection(UIView) NSArray *allViews;
    IBOutletCollection (UIButton) NSArray *selectedtickbtn;
    IBOutletCollection (NSLayoutConstraint) NSArray *selectedtickbtnWidthConstant;
    __weak IBOutlet UILabel *selectedProductLabel;
    __weak IBOutlet UIView *productDetailsView;
    IBOutletCollection(UIButton) NSArray *monthYearButton;
    IBOutletCollection(UIButton) NSArray *learnButton;

    IBOutletCollection(UILabel) NSArray *priceLabelArr;
    IBOutletCollection(UILabel) NSArray *upfrontPriceLabelArrayDetails;
    IBOutletCollection(UILabel) NSArray *productNamelabelArrayDetails;
    IBOutlet UIButton *restoreButton;
    IBOutletCollection(UIView) NSArray *borderView;
    IBOutlet UIImageView *imgView;
    IBOutletCollection(NSLayoutConstraint) NSArray *detailsTickbuttonWidthConstant;
    IBOutletCollection(UIButton) NSArray *detailsTickbutton;
    IBOutlet UIImageView *discountImage;
    int selectedproduct;
    
}
// Indicate that there are restored products
@property BOOL restoreWasCalled;

// Indicate whether a download is in progress
@property (nonatomic)BOOL hasDownloadContent;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;

@end


@implementation ParentViewController
@synthesize userDataDict;

#pragma mark - View Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    imgView.image = [UIImage imageNamed:@"bg_squad.png"];
    productDetailsView.hidden = true;
    signupNowButton.hidden = true;
    signupNowButton.layer.cornerRadius = 15;
    signupNowButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 15;
    nextButton.layer.masksToBounds = YES;
    restoreButton.layer.cornerRadius = 15;
    restoreButton.layer.masksToBounds = YES;
//    if (_isShowBack) {
//        backButton.hidden = false;
//    }else{
//        backButton.hidden = false;
//    }
     backButton.hidden = false;
    for(UIButton *btn in learnButton){
        btn.layer.cornerRadius =  15;
        btn.layer.masksToBounds = YES;
    }
    for(UIView *view in borderView){
        view.layer.borderColor =  squadMainColor.CGColor;
        view.layer.borderWidth = 1;
    }
    
//    for(UIButton *btn in monthYearButton){
//        btn.layer.cornerRadius = 15;
//        btn.layer.masksToBounds = YES;
//        btn.layer.borderColor = [UIColor whiteColor].CGColor;
//        btn.layer.borderWidth = 1;
//    }
    [self prepareQuarterlySubscription:@""];
    [self prepareYearlySubscription:@""];
    [self prepareTesterSubscription:@""];
    [self prepareSelectedView];
    /*if([Utility isSquadLiteUser]){
        [signupNowButton setTitle:@"UPGRADE NOW" forState:UIControlStateNormal];
    }else if(_isShowSquadLite && [Utility isSubscribedUser] && ![defaults boolForKey:@"IsNonSubscribedUser"] ){
        [signupNowButton setTitle:@"DOWNGRADE NOW" forState:UIControlStateNormal];
    }*/
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (screenWidth == 320) {
        freeTrialLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:12];
        productNumberFont = 20.0;
        productTextFont = 12.0;
        productBgImageName = @"plan_onebg_small.png";
        productMiddleBgImageName = @"plan_twobg_small.png";
        selectedProductBgImageName = @"active_plan_bg_small.png";
        selectedProductMiddleBgImageName = @"active_plan_two_small.png";
        
    }else{
        freeTrialLabel.font = [UIFont fontWithName:@"Raleway-Medium" size:16];
        productNumberFont = 27.0;
        productTextFont = 17.0;
        productBgImageName = @"plan_onebg.png";
        productMiddleBgImageName = @"plan_twobg.png";
        selectedProductBgImageName = @"active_plan_bg.png";
        selectedProductMiddleBgImageName = @"active_plan_two.png";
    }
    //active_plan_bg
    textRenewableProduct = [[NSMutableAttributedString alloc] initWithString:@"By continuing you accept our Privacy Policy and Terms of Service.\nThe Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. You will be charged through your iTunes account. Manage your subscription in account settings."];
    [textRenewableProduct addAttribute:NSLinkAttributeName value:@"PrivacyPolicy://" range:NSMakeRange(29, 14)];
    [textRenewableProduct addAttribute:NSLinkAttributeName value:@"TermsofService://" range:NSMakeRange(48, 16)];
    
    [textRenewableProduct addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(29, 14)];
    [textRenewableProduct addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(48, 16)];
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:13.0],
                               NSForegroundColorAttributeName : [Utility colorWithHexString:@"414042"],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [textRenewableProduct addAttributes:attrDict range:NSMakeRange(0,65)];
    
    NSDictionary *attrDict1 = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:11.0],
                               NSForegroundColorAttributeName : [Utility colorWithHexString:@"414042"],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [textRenewableProduct addAttributes:attrDict1 range:NSMakeRange(65, textRenewableProduct.length-65)];
    
    
    textNonRenewableProduct = [[NSMutableAttributedString alloc] initWithString:@"By continuing you accept our Privacy Policy and Terms of Service."];
    [textNonRenewableProduct addAttribute:NSLinkAttributeName value:@"PrivacyPolicy://" range:NSMakeRange(29, 14)];
    [textNonRenewableProduct addAttribute:NSLinkAttributeName value:@"TermsofService://" range:NSMakeRange(48, 16)];
    
    [textNonRenewableProduct addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(29, 14)];
    [textNonRenewableProduct addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(48, 16)];
   
    [textNonRenewableProduct addAttributes:attrDict range:NSMakeRange(0,65)];
    
    
    termsAndConditionTextView.attributedText = textRenewableProduct;
    termsAndConditionTextView.editable = NO;
    termsAndConditionTextView.delaysContentTouches = NO;
    selectedIndex = -1;
    for (UIButton *button in productButtonArray) {
        if (button.tag == 1) {
            button.selected = true;
            [button setBackgroundImage:[UIImage imageNamed:productMiddleBgImageName] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:selectedProductMiddleBgImageName] forState:UIControlStateSelected];

            
        }else{
            button.selected = false;
            [button setBackgroundImage:[UIImage imageNamed:productBgImageName] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:selectedProductBgImageName] forState:UIControlStateSelected];

        }
    }
    apiCount = 0;
    self.hasDownloadContent = NO;
    self.restoreWasCalled = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleProductRequestNotification:)
                                                 name:IAPProductRequestNotification
                                               object:[StoreManager sharedInstance]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyRemoveActivity:) name:@"removeActivity" object:nil];
    
    for(UIView *view in containerArray){
        
        if(_isUpgrade && [view.accessibilityHint isEqualToString:@"UB"]){
            view.hidden = false;
        }else if(_isDowngrade && [view.accessibilityHint isEqualToString:@"WB"]){
            view.hidden = false;
        }else{
            view.hidden = true;
        }
    }
    
    
    // Fetch information about our products from the App Store
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
            [self fetchProductInformation];
        });
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
    //[self checkReceipt:nil isFailedTransaction:NO];
 }
-(void)viewWillDisappear:(BOOL)animated{
    // Unregister for StoreManager's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPProductRequestNotification
                                                  object:[StoreManager sharedInstance]];
    
    // Unregister for StoreObserver's notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IAPPurchaseNotification
                                                  object:[StoreObserver sharedInstance]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeActivity" object:nil];

}

- (void)viewDidLayoutSubviews
{
    CGRect contentFrame = self.containerView.frame;
    CGRect messageFrame = self.statusMessage.frame;
    
    // Add the status message to the UI if a download is in progress.
    // Remove it when the download is done
    if (self.hasDownloadContent)
    {
        messageFrame = CGRectMake(contentFrame.origin.x, contentFrame.origin.y, contentFrame.size.width, 44);
        contentFrame.size.height -= messageFrame.size.height;
        contentFrame.origin.y += messageFrame.size.height;
    }
    else
    {
        contentFrame = self.view.frame;
        // We need to account for the navigation bar
        contentFrame.origin.y = 64;
        contentFrame.size.height -=contentFrame.origin.y;
        messageFrame.origin.y = self.view.frame.size.height;
    }
    
    self.containerView.frame = contentFrame;
    self.statusMessage.frame = messageFrame;
}

#pragma mark - End

// Called when the status message was removed. Force the view to update its layout.
-(void)hideStatusMessage
{
    [self.view setNeedsLayout];
}

#pragma mark - IBAction

- (IBAction)getStartedButtonPressed:(UIButton *)sender {
    selectedIndex =(int) sender.tag;
    productDetailsView.hidden = true;
    signupNowButton.hidden = false;
    NSString *productStr;
    if (selectedIndex == 0) {
//        NSString *detailsStr = @"\u2022 1500+ Workouts with a new workout released daily\n\n\u2022 HIIT,weights, yoga,pilates,cardio\n\n\u2022 Customised Training Program to get results fast";
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Choose your MbHQ Achieve subscription type"]];
        NSRange foundRange1 = [text1.mutableString rangeOfString:@"MbHQ Achieve"];
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:12],
                                    NSForegroundColorAttributeName :[Utility colorWithHexString:@"414042"]
                                    };
        [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
        [text1 addAttributes:@{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:12]
                               }
                       range:foundRange1];
        selectedProductLabel.attributedText = text1;
        
        productStr = @"MbHQ Achieve";
       
        
    }else if(selectedIndex == 1){
//        NSString *nutritionMaster = @"\u2022 Personalised Nutrition Plan designed for your goals \n\n\u2022 Powerful meal tracker and diet diary to keep you accountable";

        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Choose your MbHQ Total Mastery subscription type"]];
        NSRange foundRange1 = [text1.mutableString rangeOfString:@"MbHQ Total Mastery"];
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:12],
                                    NSForegroundColorAttributeName :[Utility colorWithHexString:@"414042"]
                                    };
        [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
        [text1 addAttributes:@{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:12]
                               }
                       range:foundRange1];
        selectedProductLabel.attributedText = text1;
        
        productStr = @"MbHQ Total Mastery";
    }else{
//        NSString *cleanUpStr = @"\u2022 My ultimate solution to look and feel your best\n\n\u2022 2 Step system that guarantee's results\n\n\u2022 Includes all workouts,meals,tracking and education plus support the whole way through";
        
        NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"Choose your MbHQ Mini subscription type"]];
        NSRange foundRange1 = [text1.mutableString rangeOfString:@"MbHQ Mini"];
        NSDictionary *attrDict1 = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"Raleway" size:12],
                                    NSForegroundColorAttributeName :[Utility colorWithHexString:@"414042"]
                                    };
        [text1 addAttributes:attrDict1 range:NSMakeRange(0, text1.length)];
        [text1 addAttributes:@{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Bold" size:12]
                               }
                       range:foundRange1];
        selectedProductLabel.attributedText = text1;
        productStr = @"MbHQ Mini";
    }
//    [self monthDetailsPopulate];
   
  
    for (UIView *view in allViews) {
        view.layer.borderColor = squadMainColor.CGColor;
        view.layer.borderWidth = 1;
        //UIView *container = containerArray [button.tag];
        if (sender.tag == view.tag) {
//            button.selected = true;
//            if(button.tag != 1){
//                [button setBackgroundColor:[Utility colorWithHexString:@"58595b"]];
//            }
            view.backgroundColor = [Utility colorWithHexString:@"58595b"];
            UILabel *lbl = productNamelabelArray[sender.tag];
            lbl.textColor = [UIColor whiteColor];
            UIButton *button = selectedtickbtn[sender.tag];
            button.hidden = false;
//            NSLayoutConstraint *layoutConst = selectedtickbtnWidthConstant[sender.tag];
//            layoutConst.constant = 50;
            
            if (selectedIndex == 0) {
                
                for (UILabel *lbl in workoutQueenLabelArr) {
                    lbl.textColor = [UIColor whiteColor];
                }
            }else if(selectedIndex == 1){
                for (UILabel *lbl in nutritionMasterLabelArr) {
                    lbl.textColor = [UIColor whiteColor];
                }
            }else{
                for (UILabel *lbl in cleanUpLabelArr) {
                    lbl.textColor = [UIColor whiteColor];
                }
            }
            
            
        }else{
//            button.selected = false;
//            [button setBackgroundColor:[UIColor clearColor]];
            
            view.backgroundColor = [UIColor whiteColor];
            
            [mostPopularButton setSelected:NO];
            if (selectedIndex == 0) {
                for (UILabel *lbl in nutritionMasterLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                for (UILabel *lbl in cleanUpLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                UILabel *lbl = productNamelabelArray[1];
                lbl.textColor = squadMainColor;
                
                UILabel *lbl1 = productNamelabelArray[2];
                lbl1.textColor = squadMainColor;
                
                UIButton *button = selectedtickbtn[1];
                button.hidden = true;
                UIButton *button1 = selectedtickbtn[2];
                button1.hidden = true;
                
//                NSLayoutConstraint *layoutConst = selectedtickbtnWidthConstant[1];
//                layoutConst.constant = 0;
//
//                NSLayoutConstraint *layoutConst1 = selectedtickbtnWidthConstant[2];
//                layoutConst1.constant = 0;
                
            }else if(selectedIndex == 1){
                for (UILabel *lbl in workoutQueenLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                for (UILabel *lbl in cleanUpLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                UILabel *lbl = productNamelabelArray[0];
                lbl.textColor = squadMainColor;
                
                UILabel *lbl1 = productNamelabelArray[2];
                lbl1.textColor = squadMainColor;
                
                UIButton *button = selectedtickbtn[0];
                button.hidden = true;
                UIButton *button1 = selectedtickbtn[2];
                button1.hidden = true;
                
//                NSLayoutConstraint *layoutConst = selectedtickbtnWidthConstant[0];
//                layoutConst.constant = 0;
//
//                NSLayoutConstraint *layoutConst1 = selectedtickbtnWidthConstant[2];
//                layoutConst1.constant = 0;
            }else{
                for (UILabel *lbl in workoutQueenLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                for (UILabel *lbl in nutritionMasterLabelArr) {
                    lbl.textColor = [Utility colorWithHexString:@"191919"];
                }
                UILabel *lbl = productNamelabelArray[0];
                lbl.textColor = squadMainColor;
                
                UILabel *lbl1 = productNamelabelArray[1];
                lbl1.textColor = squadMainColor;
                
                UIButton *button = selectedtickbtn[0];
                button.hidden = true;
                UIButton *button1 = selectedtickbtn[1];
                button1.hidden = true;
                
//                NSLayoutConstraint *layoutConst = selectedtickbtnWidthConstant[0];
//                layoutConst.constant = 0;

//                NSLayoutConstraint *layoutConst1 = selectedtickbtnWidthConstant[1];
//                layoutConst1.constant = 0;
            }
        }
    }
    if(sender.tag == mostPopularButton.tag){
        [mostPopularButton setSelected:YES];
    }else{
        [mostPopularButton setSelected:NO];
    }
   
}

- (IBAction)oneMonthButtonPressed:(UIButton *)sender {
    selectedIndex =(int) sender.tag;
    for (UIButton *button in productButtonArray) {
        if (sender.tag == button.tag) {
            button.selected = true;
        }else{
            button.selected = false;
        }
    }
    [self getStartedButtonPressed:nil];
}
-(IBAction)nextButtonPressed:(id)sender{
    imgView.image = [UIImage imageNamed:@""];
    productDetailsView.hidden = false;
    [self monthDetailsPopulate];
    UIButton *button = monthYearButton[0];
    [self selectedMonthYearpressed:button];
}
- (IBAction)signUpNowButtonPressed:(UIButton *)sender {
    if (!(selectedproduct>0)) {
        [Utility msg:@"Please select the product type" title:@"" controller:self haveToPop:NO];
        return;
    }
    if (selectedIndex >-1) {
        //        NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds" withExtension:@"plist"];
        //        NSArray *productIds = [NSArray arrayWithContentsOfURL:plistURL];
        //        productId = productIds[selectedIndex+(selectedproduct-1)];
        
        NSArray *inappArr = [Utility getInAppPurchaseFromJSON];
        if(![Utility isEmptyCheck:inappArr] && inappArr.count>0){
            NSArray *productArr = [[inappArr objectAtIndex:selectedIndex]objectForKey:@"product"];
            productId = [[productArr objectAtIndex:(selectedproduct-1)]objectForKey:@"productName"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(productIdentifier == %@)",productId];
            NSArray *filteredAvailableProductsArray = [availableProducts filteredArrayUsingPredicate:predicate];
            if (filteredAvailableProductsArray.count > 0) {
                if (Utility.reachable) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (self->contentView) {
                            [self->contentView removeFromSuperview];
                        }
                        self->contentView = [Utility activityIndicatorView:self];
                        SKProduct *product = filteredAvailableProductsArray[0];
                        [[StoreObserver sharedInstance] buy:product];
                    });
                }else{
                    [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
                }
                
            }else{
                [self alertWithTitle:@"Warning" message:@"Product is not valid."];
            }
        }
        

       
    }else{
        [self alertWithTitle:@"Warning" message:@"Please select your plan."];
    }
}
-(IBAction)learnMoreButtonPressed:(UIButton*)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ParentLearnMoreViewController *controller = [storyBoard instantiateViewControllerWithIdentifier:@"ParentLearnMoreView"];
        if (sender.tag == 9) { // Workout Queen
            controller.pageCount = 6;
            controller.selectIndex = 0;
        }else if (sender.tag == 10){ // Nutrition Master
            controller.pageCount = 7;
            controller.selectIndex = 1;
        }else{
            controller.pageCount = 7;
            controller.selectIndex = 2;
        }
        [self.navigationController pushViewController:controller animated:YES];
    });
}
-(IBAction)selectedMonthYearpressed:(UIButton*)sender{
    for(UIButton *btn in monthYearButton){
        if (btn == sender) {
            btn.selected = true;
//            btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];//colorWithAlphaComponent:0.5];
            selectedproduct = (int)btn.tag;
            
            UIView *sView = borderView[btn.tag-1];
            sView.backgroundColor = [Utility colorWithHexString:@"58595b"];
            sView.layer.borderColor = [UIColor whiteColor].CGColor;
            
            UILabel *productnameLabel = productNamelabelArrayDetails[btn.tag-1];
            productnameLabel.textColor = [UIColor whiteColor];
            
            UILabel *priceLabel = priceLabelArr[btn.tag-1];
            priceLabel.textColor = [Utility colorWithHexString:@"94e3de"];
            
            UIButton *tickbutton = detailsTickbutton[btn.tag-1];
            tickbutton.hidden = false;
            
            NSLayoutConstraint *layoutConst = detailsTickbuttonWidthConstant[btn.tag-1];
            layoutConst.constant = 50;
            
            
        }else{
            btn.selected = false;
//            btn.backgroundColor = [UIColor clearColor];
            
            UIView *sView= borderView [btn.tag-1];
            sView.backgroundColor = [UIColor whiteColor];
            sView.layer.borderColor = squadMainColor.CGColor;
            
            UILabel *productnameLabel = productNamelabelArrayDetails[btn.tag-1];
            productnameLabel.textColor = [Utility colorWithHexString:@"58595b"];
            
            UILabel *priceLabel = priceLabelArr[btn.tag-1];
            priceLabel.textColor = squadMainColor;
  
            UIButton *tickbutton = detailsTickbutton[btn.tag-1];
            tickbutton.hidden = true;
            
            NSLayoutConstraint *layoutConst = detailsTickbuttonWidthConstant[btn.tag-1];
            layoutConst.constant = 0;
        }
    }
}
#pragma mark - End

#pragma mark  - Private function

-(void)prepareQuarterlySubscription:(NSString *)priceStr{
    NSString *txtStr;
    
    if(![Utility isEmptyCheck:priceStr]){
        txtStr = [@"" stringByAppendingFormat:@"3 MONTHS SUBSCRIPTION - %@ \n\n Full Access: Gratitude, Habits, Meditations",priceStr];
        
    }else{
        txtStr = @"3 MONTHS SUBSCRIPTION \n\n Full Access: Gratitude, Habits, Meditations";
    }
    
    
    UILabel *textLabel =  workoutQueenLabelArr[0];
    textLabel.text = txtStr;
    
}
-(void)prepareYearlySubscription:(NSString *)priceStr{
    NSString *txtStr;
    
    if(![Utility isEmptyCheck:priceStr]){
        txtStr = [@"" stringByAppendingFormat:@"12 MONTHS SUBSCRIPTION - %@ \n\n Full Access: Gratitude, Habits, Meditations",priceStr];
        
    }else{
        txtStr = @"12 MONTHS SUBSCRIPTION \n\n Full Access: Gratitude, Habits, Meditations";
    }
    
    UILabel *textLabel =  nutritionMasterLabelArr[0];
    textLabel.text = txtStr;
    
    
}
-(void)prepareTesterSubscription:(NSString *)priceStr{
   
    NSString *txtStr;
    
    if(![Utility isEmptyCheck:priceStr]){
        
        txtStr = [@"" stringByAppendingFormat:@"1 MONTH ACCESS - %@ \n\n1 Month access with no subscription",priceStr];;
    }else{
        txtStr = @"1 MONTH ACCESS \n\n1 Month access with no subscription";
    }
    
    UILabel *textLabel =  cleanUpLabelArr[0];
    textLabel.text = txtStr;
    
    
}

-(void)prepareSelectedView{
    UIButton *button = productButtonArray [0];
    [self getStartedButtonPressed:button];
}
-(void)monthDetailsPopulate{
    if (selectedIndex<0) {
        selectedIndex = 0;
    }
    NSArray *inappArr = [Utility getInAppPurchaseFromJSON];
    if(![Utility isEmptyCheck:inappArr] && inappArr.count>0){
        NSArray *productArr = [[inappArr objectAtIndex:selectedIndex]objectForKey:@"product"];
        
       
        UIButton *button = [[UIButton alloc]init];
        for (int i =0; i<1;i++) {
            
        productId = [[productArr objectAtIndex:i]objectForKey:@"productName"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(productIdentifier == %@)",productId];
        NSArray *filteredAvailableProductsArray = [availableProducts filteredArrayUsingPredicate:predicate];
        UILabel *priceLabel = priceLabelArr[i];
        UILabel *productNameLabel = productNamelabelArrayDetails [i];
            
        if (filteredAvailableProductsArray.count > 0) {
            
            SKProduct *product = filteredAvailableProductsArray[0];
            if (@available(iOS 11.2, *)) {
                if(product.subscriptionPeriod.unit == SKProductPeriodUnitMonth){
                    button.accessibilityHint = [NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits];
                }else if(product.subscriptionPeriod.unit == SKProductPeriodUnitYear){
                    button.accessibilityHint =[NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits*12];
                }else{
                    button.accessibilityHint = [NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits+1];
                }
            }else {
                // Fallback on earlier versions
                
                if([productId isEqualToString:@"mbhqquarterly"]){
                    button.accessibilityHint = @"3";
                }else if([productId isEqualToString:@"mbhqannual"]){
                    button.accessibilityHint = @"12";
                }else{
                    button.accessibilityHint = @"1";
                }
            }
            
            int fontSize = 27;
            if (button.accessibilityHint.intValue > 1) {
                fontSize = 15;
            }
            
            NSDecimalNumber *amountToSendNumber1 = [product.price decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:button.accessibilityHint]];
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            formatter.maximumFractionDigits = 2;
          
            
            NSString *detailsStr1 = @"";
            if([button.accessibilityHint intValue]==1){
                detailsStr1 = [@"" stringByAppendingFormat:@"%@%@ (No Subscription)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                termsAndConditionTextView.attributedText = textNonRenewableProduct;
            }else{
                detailsStr1 = [@"" stringByAppendingFormat:@"%@%@ (%@%@/month)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price,[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                termsAndConditionTextView.attributedText = textRenewableProduct;
            }
            
            NSString *deatilsStr;
            if ([productId isEqualToString:@"mbhqquarterly"]) {
                deatilsStr = @"3 MONTHS SUBSCRIPTION";
            }else if ([productId isEqualToString:@"mbhqannual"]){
                deatilsStr = @"12 MONTHS SUBSCRIPTION";
            }else{
                deatilsStr = @"1 MONTH ACCESS";
            }
            productNameLabel.text =  deatilsStr;
            priceLabel.text = detailsStr1;
            
//            if ([button.accessibilityHint isEqualToString:@"1"]) {
//                    productNameLabel.text = [NSString stringWithFormat:@"%@ \n1 MONTH SUBSCRIPTION",deatilsStr];
////                    upfrontProductLabel.text = @" ";
//                    priceLabel.text = detailsStr1;
//
//
//            }else{
//                productNameLabel.text = [NSString stringWithFormat:@"%@ \n1 YEAR SUBSCRIPTION",deatilsStr];
//                //upfrontProductLabel.text = [NSString stringWithFormat:@"(%@%@ UPFRONT)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price];
//                upfrontProductLabel.text = @"";
//                priceLabel.text = [NSString stringWithFormat:@"%@%@/year",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price];
                
//                NSString *imageStr =@"";
//                if ([deatilsStr isEqualToString:@"NUTRITION BOSS"]||[deatilsStr isEqualToString:@"WORKOUT QUEEN"]) {
//                    imageStr = @"save_20%.png";
//                }else{
//                    imageStr = @"save_50%.png";
//                }
//                    discountImage.image = [UIImage imageNamed:imageStr];
//                }
            
            }
        }
    }
}
#pragma mark Display message

-(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark Fetch product information

// Retrieve product information from the App Store
-(void)fetchProductInformation
{
    // Query the App Store for product information if the user is is allowed to make purchases.
    // Display an alert, otherwise.
    if([SKPaymentQueue canMakePayments])
    {
        // Load the product identifiers fron ProductIds.plist
        NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds" withExtension:@"plist"];
        NSMutableArray *productIds = [[NSArray arrayWithContentsOfURL:plistURL] mutableCopy];
//        NSCalendar *calendar = [NSCalendar currentCalendar];
//        NSDate *installationDate = [defaults objectForKey:@"InstallationDate"];
//        //Day 4 Notification
//        NSDate *day4 =  [calendar dateByAddingUnit:NSCalendarUnitDay
//                                             value:3
//                                            toDate:installationDate
//                                           options:0];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyy-MM-dd";
//        if([[formatter stringFromDate:[NSDate date]] isEqualToString:[formatter stringFromDate:day4]]){
//            [[StoreManager sharedInstance] fetchProductInformationForIds:[NSArray arrayWithObject:productIds.lastObject]];
//        }else{
//            [productIds removeLastObject];
//            [[StoreManager sharedInstance] fetchProductInformationForIds:productIds];
//        }
//        if(([Utility isSquadLiteUser] || [Utility isSubscribedUser]) && !_isShowSquadLite){
//           [productIds removeLastObject];
//        }
//        [productIds removeLastObject];
        
        [[StoreManager sharedInstance] fetchProductInformationForIds:productIds];
    }
    else
    {
        // Warn the user that they are not allowed to make purchases.
        [self alertWithTitle:@"Warning" message:@"Purchases are disabled on this device."];
    }
}


#pragma mark Handle product request notification

// Update the UI according to the product request notification result
-(void)handleProductRequestNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
   
    StoreManager *productRequestNotification = (StoreManager*)notification.object;
    IAPProductRequestStatus result = (IAPProductRequestStatus)productRequestNotification.status;
    
    if (result == IAPProductRequestResponse)
    {
        self->availableProducts = productRequestNotification.availableProducts;
        NSURL *plistURL;
        plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds" withExtension:@"plist"];
        
        NSArray *productIds = [NSArray arrayWithContentsOfURL:plistURL];
        
        
        for (int i =0; i<productIds.count;i++) {
            
            NSString *productId1 = productIds[i];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(productIdentifier == %@)",productId1 ];//productId1
            NSArray *filteredAvailableProductsArray = [self->availableProducts filteredArrayUsingPredicate:predicate];
            UIView *container = self->containerArray [i];
            UIButton *button = self->productButtonArray [i];
            UILabel *priceLabel = self->priceLabelArray [i];
            UILabel *productNameLabel = self->productNamelabelArray [i];
            UILabel *upfrontProductLabel = self->upfrontPriceLabelArray [i];
            
//            if([UIScreen mainScreen].bounds.size.width <= 320){
//                priceLabel.textAlignment =  NSTextAlignmentLeft;
//                productNameLabel.textAlignment =  NSTextAlignmentLeft;
//                upfrontProductLabel.textAlignment =  NSTextAlignmentLeft;
//                squadLiteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            }
            
//            if([productId1 isEqualToString:PopularProduct]){
//                //container.backgroundColor = [Utility colorWithHexString:@"87d2e4"];
//                //[button setBackgroundColor:[[Utility colorWithHexString:@"87d2e4"] colorWithAlphaComponent:0.8]];
//
//            }//AY 12042018
            
            
            if (filteredAvailableProductsArray.count > 0) {
                SKProduct *product = filteredAvailableProductsArray[0];
                NSString *detailsStr = @"";
                if (@available(iOS 11.2, *)) {
                    if(product.subscriptionPeriod.unit == SKProductPeriodUnitMonth){
                        detailsStr = @"MbHQ Achieve";
                        button.accessibilityHint = [NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits];
                        
                        
                    }else if(product.subscriptionPeriod.unit == SKProductPeriodUnitYear){
                        detailsStr = @"MbHQ Total Mastery";
                        button.accessibilityHint =[NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits*12];
                    }else{
                        detailsStr = @"MbHQ Mini";
                        button.accessibilityHint = [NSString stringWithFormat:@"%lu",product.subscriptionPeriod.numberOfUnits+1];
                    }
                }else {
                    // Fallback on earlier versions
                  
                    if([productId1 isEqualToString:@"mbhqquarterly"]){
                        button.accessibilityHint = @"3";
                        detailsStr = @"MbHQ Achieve";
                        
                    }else if([productId1 isEqualToString:@"mbhqannual"]){
                        button.accessibilityHint = @"12";
                        detailsStr = @"MbHQ Total Mastery";
                    }else{
                        detailsStr = @"MbHQ Mini";
                        button.accessibilityHint = @"1";
                    }
                }
                
                int fontSize = 27;
                if (button.accessibilityHint.intValue > 1) {
                    fontSize = 15;
                }
                
                NSDecimalNumber *amountToSendNumber1 = [product.price decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:button.accessibilityHint]];
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                formatter.maximumFractionDigits = 2;
                NSString *detailsStr1 = @"";
                if([button.accessibilityHint intValue]==1){
                    detailsStr1 = [@"" stringByAppendingFormat:@"%@%@(No Subscription)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                }else{
                    detailsStr1 = [@"" stringByAppendingFormat:@"%@%@(%@%@/month)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price,[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                }
                
                upfrontProductLabel.text = detailsStr1;
            
                if([productId1 isEqualToString:@"mbhqquarterly"]){
                    
                    NSString *quater = [@"" stringByAppendingFormat:@"%@%@ (%@%@/month)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price,[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                    [self prepareQuarterlySubscription:quater];
                    
                }else if([productId1 isEqualToString:@"mbhqannual"]){
                    NSString *annual = [@"" stringByAppendingFormat:@"%@%@ (%@%@/month)",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],product.price,[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                    [self prepareYearlySubscription:annual];
                    
                }else{
                   NSString *annual = [@"" stringByAppendingFormat:@"%@%@ for 1 Month",[product.priceLocale objectForKey:NSLocaleCurrencySymbol],[formatter stringFromNumber:amountToSendNumber1]];
                   [self prepareTesterSubscription:annual];
                }
                
               
                productNameLabel.text = [NSString stringWithFormat:@"%@ ",detailsStr];
                priceLabel.text = detailsStr1; //(%@%@ UPFRONT)


                
                container.hidden = false;
            }else{
                container.hidden = true;

            }
        }
        
        
        if(self->_isUpgrade || _isDowngrade){
            for(UIView *view in self->containerArray){
                
                if(self->_isUpgrade && [view.accessibilityHint isEqualToString:@"UB"]){
                    view.hidden = false;
                }else if(self->_isDowngrade && [view.accessibilityHint isEqualToString:@"WB"]){
                    view.hidden = false;
                }else{
                    view.hidden = true;
                }
            }
        }
        
        if(self->_isUpgrade){
            UIButton *btn = [UIButton new];
            btn.tag = 2;
            [self getStartedButtonPressed:btn];
            [self nextButtonPressed:0];
        }else if(self->_isDowngrade){
            UIButton *btn = [UIButton new];
            btn.tag = 0;
            [self getStartedButtonPressed:btn];
            [self nextButtonPressed:0];
        }
    }else{
        [Utility msg:@"Cannot connect to iTunes Store" title:@"Alert!" controller:self haveToPop:YES];
    }
        
    });
}


#pragma mark Handle purchase request notification

// Update the UI according to the purchase request notification result
-(void)handlePurchasesNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
    });
    
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    
    switch (status)
    {
        case IAPPurchaseFailed:
        {
            NSString *title = [[StoreManager sharedInstance] titleMatchingProductIdentifier:purchasesNotification.purchasedID];
            NSString *displayedTitle = (title.length > 0) ? title : purchasesNotification.purchasedID;
            NSString *msg = [NSString stringWithFormat:@"Purchase of %@ failed.",displayedTitle];
            [self alertWithTitle:@"Purchase Status" message:msg];
        }
            break;
            // Switch to the iOSPurchasesList view controller when receiving a successful restore notification
        case IAPPurchaseSucceeded:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self sendReceiptData];
                
                //AppsFlyer Purchase Event Tracking -- AmitY 23-06-2017
                //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(productIdentifier == %@)",self->productId ];
                //NSArray *filteredAvailableProductsArray = [self->availableProducts filteredArrayUsingPredicate:predicate];
                //SKProduct *product = filteredAvailableProductsArray[0];
                
                //Added For Apps Flyer Registration Tracking AmitY 24-Jul-2017
                
                if([self->userDataDict[@"IsFbUser"] boolValue]){
                }else{
                }
            });
        }
            break;
        case IAPRestoredSucceeded:
        {
            productId = purchasesNotification.purchasedID;
            dispatch_async(dispatch_get_main_queue(), ^{
                if(!self.restoreWasCalled){
                    self.restoreWasCalled = YES;
                    [self sendReceiptData];
                }
            });
            
        }
            break;
        case IAPRestoredFailed:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                [self alertWithTitle:@"Purchase Status" message:purchasesNotification.message];
            });
        }
            
            break;
            // Notify the user that downloading is about to start when receiving a download started notification
        case IAPDownloadStarted:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
            });
            self.hasDownloadContent = YES;
            [self.view addSubview:self.statusMessage];
        }
            break;
            // Display a status message showing the download progress
        case IAPDownloadInProgress:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
            });
            self.hasDownloadContent = YES;
            NSString *title = [[StoreManager sharedInstance] titleMatchingProductIdentifier:purchasesNotification.purchasedID];
            NSString *displayedTitle = (title.length > 0) ? title : purchasesNotification.purchasedID;
            self.statusMessage.text = [NSString stringWithFormat:@" Downloading %@   %.2f%%",displayedTitle, purchasesNotification.downloadProgress];
        }
            break;
            // Downloading is done, remove the status message
        case IAPDownloadSucceeded:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
            });
            self.hasDownloadContent = NO;
            self.statusMessage.text = @"Download complete: 100%";
            
            // Remove the message after 2 seconds
            [self performSelector:@selector(hideStatusMessage) withObject:nil afterDelay:2];
        }
            break;
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
            });
        }
            break;
    }
 }



// Return an array that will be used to populate the Purchases view
-(NSMutableArray *)dataSourceForPurchasesUI
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (self.restoreWasCalled && [[StoreObserver sharedInstance] hasRestoredProducts] && [[StoreObserver sharedInstance] hasPurchasedProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[MyModel alloc] initWithName:@"PURCHASED" elements:[StoreObserver sharedInstance].productsPurchased],
                                                             [[MyModel alloc] initWithName:@"RESTORED" elements:[StoreObserver sharedInstance].productsRestored],nil];
    }
    else if (self.restoreWasCalled && [[StoreObserver sharedInstance] hasRestoredProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[MyModel alloc] initWithName:@"RESTORED" elements:[StoreObserver sharedInstance].productsRestored], nil];
    }
    else if ([[StoreObserver sharedInstance] hasPurchasedProducts])
    {
        dataSource = [[NSMutableArray alloc] initWithObjects:[[MyModel alloc] initWithName:@"PURCHASED" elements:[StoreObserver sharedInstance].productsPurchased], nil];
    }
    
    // Only want to display restored products when the Restore button was tapped and there are restored products
    self.restoreWasCalled = NO;
    return dataSource;
}

#pragma mark Restore all appropriate transactions
- (IBAction)backButtonPressed:(UIButton*)sender
{
    if(sender.tag == 999 && !_isUpgrade && !_isDowngrade){
        productDetailsView.hidden = true;
        imgView.image = [UIImage imageNamed:@"bg_squad.png"];
        selectedproduct = 0;
        
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = -1;
        [self selectedMonthYearpressed:btn];

    }else{
        
        if(_isUpgrade || _isDowngrade){
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        
        NSArray *arr = self.navigationController.viewControllers;
        for(UIViewController *controller in arr){
            if ([controller isKindOfClass:[InitialViewController class]]) {
                [self.navigationController popToViewController:controller animated:NO];
            }
        }
    }
}
- (IBAction)restore:(id)sender
{
    dispatch_async(dispatch_get_main_queue(),^ {
        if (self->contentView) {
            [self->contentView removeFromSuperview];
        }
        self->contentView = [Utility activityIndicatorView:self];
    });
    // Call StoreObserver to restore all restorable purchases
    [[StoreObserver sharedInstance] restore];
}
-(void)saveContact{
    if (Utility.reachable) {
        NSError *error;
        NSMutableArray *profileArr = [[NSMutableArray alloc]init];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        NSMutableDictionary *mainHeaderDict = [[NSMutableDictionary alloc]init];
        
        if (![Utility isEmptyCheck:[defaults objectForKey:@"FirstName"]]) {  //Change_26032018
            [mainDict setObject:[defaults objectForKey:@"FirstName"] forKey:@"first_name"];
        }else{
            [mainDict setObject:[userDataDict objectForKey:@"FirstName"] forKey:@"first_name"];

        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"Email"]]) {  //Change_26032018
            [mainDict setObject:[defaults objectForKey:@"Email"] forKey:@"email"];
        }else{
            [mainDict setObject:[userDataDict objectForKey:@"Email"] forKey:@"email"];
        }
        if (![Utility isEmptyCheck:[defaults objectForKey:@"LastName"]]) {  //Change_26032018
            [mainDict setObject:[defaults objectForKey:@"LastName"] forKey:@"last_name"];
        }else{
            [mainDict setObject:[userDataDict objectForKey:@"LastName"] forKey:@"last_name"];
        }
        [profileArr addObject:mainDict];
        [mainHeaderDict setObject:profileArr forKey:@"profiles"];
//        [mainDict setObject:[NSDictionary dictionaryWithObjectsAndKeys:CHALLENGE_ID_REGISTERED,@"campaignId", nil] forKey:@"campaign"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainHeaderDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            self->contentView = [Utility activityIndicatorView:self];
        });
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SaveContact" append:@"" forAction:@"POST"];
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (self->contentView){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                 
                                                                 NSLog(@"%@",responseString);
                                                                 NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                                                 NSLog(@"-------------%ld",(long)httpResponse.statusCode);
                                                                 
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
    
}
-(void)sendReceiptData{
    // Load the receipt from the app bundle.
    // dispatch_async(dispatch_get_main_queue(), ^{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    //[self checkReceipt:receipt isFailedTransaction:NO];
    if (!receipt) {
        [Utility msg:@"Please choose your plan first." title:@"Error!" controller:self haveToPop:NO];
        return;
    }
    else{
        NSString *receiptString = [receipt base64EncodedStringWithOptions:0];
        NSLog(@"%@",receiptString);
       //[self checkReceipt:receipt isFailedTransaction:NO];
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(),^ {
                self->apiCount++;
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            NSURLSession *dailySession = [NSURLSession sharedSession];
            NSError *error;
            
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:userDataDict];
            
            [mainDict setObject:@"" forKey:@"Country"];
            [mainDict setObject:[NSNumber numberWithInteger:1] forKey:@"SubscriptionType"]; //1 For IOS 2 for Android
            [mainDict setObject:[NSNumber numberWithInteger:-1] forKey:@"CountryId"];
            [mainDict setObject:[NSNumber numberWithInteger:-1] forKey:@"CityId"];
            [mainDict setObject:[NSNumber numberWithInteger:-1] forKey:@"SuburbId"];
            [mainDict setObject:@"" forKey:@"City"];
            [mainDict setObject:@"" forKey:@"Suburb"];
            [mainDict setObject:receiptString forKey:@"SubscriptionRef1"];
            [mainDict setObject:productId forKey:@"SubscriptionRef2"];
            [mainDict setObject:[NSNull null] forKey:@"SubscriptionRef3"];
            [mainDict setObject:@"iphone" forKey:@"Mobile"];
            NSTimeZone *myTimeZone = [NSTimeZone systemTimeZone];
            NSString *timezoneName = myTimeZone.name;
            NSString *offset = myTimeZone.abbreviation;
            [mainDict setObject:timezoneName forKey:@"TimezoneName"];
            [mainDict setObject:offset forKey:@"GMTOffset"];
            NSDate *currentDate = [NSDate date];
            [mainDict setObject:[NSString stringWithFormat:@"%@",[currentDate dateByAddingDays:7]] forKey:@"SubscribedUpto"];
            
            NSMutableDictionary *postDict = [NSMutableDictionary new];
            [postDict setObject:mainDict forKey:@"Model"];
            [postDict setObject:AccessKey forKey:@"Key"];
            [postDict setObject:@-1 forKey:@"UserSessionID"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:postDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"InAppPurchaseApiCall" append:@"" forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     self->apiCount--;
                                                                     if (self->apiCount == 0 && self->contentView) {
                                                                         [self->contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         NSLog(@"Response Data:%@",responseString);
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                                             if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                                 [self saveContact];
                                                                                 
                                                                                if ([defaults boolForKey:@"isInitialNotiSet"]) {
                                                                                     [defaults setBool:NO forKey:@"isInitialNotiSet"];
                                                                                 }
                                                                                 
                                                                                 [defaults setObject:self->userDataDict[@"Email"] forKey:@"Email"];
                                                                                 [defaults setBool:[self->userDataDict[@"IsFbUser"] boolValue] forKey:@"IsFbUser"];

                                                                                 [defaults setObject:self->userDataDict[@"Password"] forKey:@"Password"];
                                                                                
                                                                                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                 LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                                                                 controller.isFromSignUp = YES;
                                                                                 [self.navigationController pushViewController:controller animated:YES];
                                                                                 
                                                                             }else{
                                                                                /* UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                                 LoginController *controller=[storyboard instantiateViewControllerWithIdentifier:@"Login"];
                                                                                 controller.isFromSignUp = NO;
                                                                                 [Utility msgWithPush:responseDictionary[@"ErrorMessage"] title:@"Oops!" controller:self haveToAnimate:YES toController:controller];*/
                                                                                 [Utility msg:responseDictionary[@"ErrorMessage"] title:@"Oops!" controller:self haveToPop:NO];
                                                                                 [defaults setObject:jsonString forKey:@"InappPurchaseRequestString"];
                                                                                 [self sendMailToSupportForInappFailureWithError:responseString];
                                                                                 return;
                                                                             }
                                                                         }else{
                                                                             [Utility msg:@"Somthing went wrong.Please try again later." title:@"Oops! " controller:self haveToPop:NO];
                                                                             [defaults setObject:jsonString forKey:@"InappPurchaseRequestString"];
                                                                             [self sendMailToSupportForInappFailureWithError:responseString];
                                                                             return;
                                                                             
                                                                         }
                                                                     }else{
                                                                         [defaults setObject:jsonString forKey:@"InappPurchaseRequestString"];
                                                                         [self sendMailToSupportForInappFailureWithError:error.localizedDescription];
                                                                     }
                                                                     
                                                                 });
                                                             }];
            [dataTask resume];
            
        }else{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
        }
    }
}

-(void)sendMailToSupportForInappFailureWithError:(NSString *)errorStr{
    
    NSString *email = userDataDict[@"Email"];
    
    if([Utility isEmptyCheck:email] || ![Utility validateEmail:email]){
        [Utility msg:@"Please enter a valid email." title:@"Oops" controller:self haveToPop:NO];
        return;
    }
    
    if (Utility.reachable) {
        
        
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        
        if (!receipt) {
            [Utility msg:@"Please check your subscription" title:@"" controller:self haveToPop:NO];
            return;
        }
        
        NSString *receiptString = [receipt base64EncodedStringWithOptions:0];
        
        NSString *bodyText = @"";
        if(![Utility isEmptyCheck:errorStr]){
            bodyText = [@"" stringByAppendingFormat:@"Please note user with following details failed to be registered via InAppPurchase API on MbHQ.\n\nEmail: %@\n\n Receipt Data:%@\n\n API Error:%@",email,receiptString,errorStr];
        }else{
           bodyText = [@"" stringByAppendingFormat:@"Please note user with following details failed to be registered via InAppPurchase API on MbHQ.\n\nEmail:%@\n\nReceipt Data:%@",email,receiptString];
        }
        
        
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:@-1 forKey:@"UserSessionID"];
        [mainDict setObject:@"Urgent: InAppPurchase API call failed during registration" forKey:@"Subject"];
        [mainDict setObject:bodyText forKey:@"Body"];
        if (![Utility isEmptyCheck:[defaults objectForKey:@"InappPurchaseRequestString"]]) {
            NSString *inappPurchaseStr = [defaults objectForKey:@"InappPurchaseRequestString"];
            NSData *inAppData = [inappPurchaseStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *inAppDictionary = [NSJSONSerialization JSONObjectWithData:inAppData options:0 error:nil];
            [mainDict setObject:inAppDictionary forKey:@"MbhqRegistrationDetails"];
        }
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
        });
        
        
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"InAppPurchaseErrorReport" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 if (self->contentView) {
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                         
                                                                         [Utility msg:@"Request has been sent to support." title:@"" controller:self haveToPop:NO];
                                                                         
                                                                     }else{
                                                                         NSLog(@"Something is wrong.Please try later.");
                                                                         [Utility msg:@"Something is wrong.Please try later." title:@"Error !" controller:self haveToPop:NO];
                                                                         return;
                                                                     }
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:NO];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    PrivacyPolicyAndTermsServiceViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PrivacyPolicyAndTermsService"];
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    if ([[URL scheme] isEqualToString:@"PrivacyPolicy"])
    {
        controller.url=[NSURL URLWithString:PRIVACY_POLICY_URL];
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }else if([[URL scheme] isEqualToString:@"TermsofService"]){
        /*controller.url=[NSURL fileURLWithPath:[[NSBundle mainBundle]
         pathForResource:@"squad_terms" ofType:@"pdf"]isDirectory:NO];*/
        controller.url=[NSURL URLWithString:PRIVACY_POLICY_URL];
        
        
        [self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}
#pragma mark Memory management
-(void)checkReceipt:(NSData *)receipt isFailedTransaction:(BOOL)isFailedTransaction{
        // Create the JSON object that describes the request
    
    
        //
    
        NSError *error;
        NSDictionary *requestContents = @{
                                          
                                          @"receipt-data":@"MIIVhAYJKoZIhvcNAQcCoIIVdTCCFXECAQExCzAJBgUrDgMCGgUAMIIFJQYJKoZIhvcNAQcBoIIFFgSCBRIxggUOMAoCARQCAQEEAgwAMAsCAQMCAQEEAwwBNjALAgEOAgEBBAMCAWowCwIBEwIBAQQDDAEzMAsCARkCAQEEAwIBAzAMAgEKAgEBBAQWAjQrMA0CAQ0CAQEEBQIDAdUmMA4CAQECAQEEBgIER6zqXTAOAgEJAgEBBAYCBFAyNTEwDgIBCwIBAQQGAgQCRO35MA4CARACAQEEBgIEMXTyHzAQAgEPAgEBBAgCBiDE1TWTlzAUAgEAAgEBBAwMClByb2R1Y3Rpb24wGAIBBAIBAgQQRYPrsutUoOl9Osgu4OIMIDAZAgECAgEBBBEMD2NvbS5hYmJiYy5zcXVhZDAcAgEFAgEBBBTC5D1PI/34qS+Sg2YxeplL0EdQtjAeAgEIAgEBBBYWFDIwMTktMDItMDZUMjI6MDM6NDNaMB4CAQwCAQEEFhYUMjAxOS0wMi0wNlQyMjowMzo0M1owHgIBEgIBAQQWFhQyMDE3LTA0LTExVDIwOjE3OjE1WjBLAgEHAgEBBEPtQO9f8og1jb4iaWpGkgQEOmB9NbSljkVja1UOy9tK9iO6uNKtj1MCHip1IT3jn+P6Q0VVLcTUizzg6gPBvSMjhWrYMFcCAQYCAQEET8s8NnRCy1cnL+iVidLgzBYXb2gmimhgEsG3vaF9k+z7WlsQMqdbcTHCYlzM0FMU9s0iwK1Sz4T8l1GR6Q2D4aykKNScnC21N8jCfTnMrR4wggF0AgERAgEBBIIBajGCAWYwCwICBq0CAQEEAgwAMAsCAgawAgEBBAIWADALAgIGsgIBAQQCDAAwCwICBrMCAQEEAgwAMAsCAga0AgEBBAIMADALAgIGtQIBAQQCDAAwCwICBrYCAQEEAgwAMAwCAgalAgEBBAMCAQEwDAICBqsCAQEEAwIBAzAMAgIGsQIBAQQDAgEAMAwCAga3AgEBBAMCAQAwDwICBq4CAQEEBgIESq6ijDARAgIGpgIBAQQIDAZTUV8xTTEwEgICBq8CAQEECQIHAJGE7LiaSzAaAgIGpwIBAQQRDA8xNjAwMDA1NDg5MDAwMzMwGgICBqkCAQEEEQwPMTYwMDAwNDEzODc5MDIwMB8CAgaoAgEBBBYWFDIwMTktMDItMDZUMjI6MDM6MzlaMB8CAgaqAgEBBBYWFDIwMTgtMDEtMDZUMTk6MzM6NDBaMB8CAgasAgEBBBYWFDIwMTktMDMtMDZUMjI6MDM6MzlaMIIBdAIBEQIBAQSCAWoxggFmMAsCAgatAgEBBAIMADALAgIGsAIBAQQCFgAwCwICBrICAQEEAgwAMAsCAgazAgEBBAIMADALAgIGtAIBAQQCDAAwCwICBrUCAQEEAgwAMAsCAga2AgEBBAIMADAMAgIGpQIBAQQDAgEBMAwCAgarAgEBBAMCAQMwDAICBrECAQEEAwIBATAMAgIGtwIBAQQDAgEAMA8CAgauAgEBBAYCBEquoowwEQICBqYCAQEECAwGU1FfMU0xMBICAgavAgEBBAkCBwCRhOy4mkowGgICBqcCAQEEEQwPMTYwMDAwNDEzODc5MDIwMBoCAgapAgEBBBEMDzE2MDAwMDQxMzg3OTAyMDAfAgIGqAIBAQQWFhQyMDE4LTAxLTA2VDE5OjMzOjQwWjAfAgIGqgIBAQQWFhQyMDE4LTAxLTA2VDE5OjMzOjQwWjAfAgIGrAIBAQQWFhQyMDE4LTAxLTEzVDE5OjMzOjQwWqCCDmUwggV8MIIEZKADAgECAggO61eH554JjTANBgkqhkiG9w0BAQUFADCBljELMAkGA1UEBhMCVVMxEzARBgNVBAoMCkFwcGxlIEluYy4xLDAqBgNVBAsMI0FwcGxlIFdvcmxkd2lkZSBEZXZlbG9wZXIgUmVsYXRpb25zMUQwQgYDVQQDDDtBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9ucyBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xNTExMTMwMjE1MDlaFw0yMzAyMDcyMTQ4NDdaMIGJMTcwNQYDVQQDDC5NYWMgQXBwIFN0b3JlIGFuZCBpVHVuZXMgU3RvcmUgUmVjZWlwdCBTaWduaW5nMSwwKgYDVQQLDCNBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczETMBEGA1UECgwKQXBwbGUgSW5jLjELMAkGA1UEBhMCVVMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQClz4H9JaKBW9aH7SPaMxyO4iPApcQmyz3Gn+xKDVWG/6QC15fKOVRtfX+yVBidxCxScY5ke4LOibpJ1gjltIhxzz9bRi7GxB24A6lYogQ+IXjV27fQjhKNg0xbKmg3k8LyvR7E0qEMSlhSqxLj7d0fmBWQNS3CzBLKjUiB91h4VGvojDE2H0oGDEdU8zeQuLKSiX1fpIVK4cCc4Lqku4KXY/Qrk8H9Pm/KwfU8qY9SGsAlCnYO3v6Z/v/Ca/VbXqxzUUkIVonMQ5DMjoEC0KCXtlyxoWlph5AQaCYmObgdEHOwCl3Fc9DfdjvYLdmIHuPsB8/ijtDT+iZVge/iA0kjAgMBAAGjggHXMIIB0zA/BggrBgEFBQcBAQQzMDEwLwYIKwYBBQUHMAGGI2h0dHA6Ly9vY3NwLmFwcGxlLmNvbS9vY3NwMDMtd3dkcjA0MB0GA1UdDgQWBBSRpJz8xHa3n6CK9E31jzZd7SsEhTAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFIgnFwmpthhgi+zruvZHWcVSVKO3MIIBHgYDVR0gBIIBFTCCAREwggENBgoqhkiG92NkBQYBMIH+MIHDBggrBgEFBQcCAjCBtgyBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMDYGCCsGAQUFBwIBFipodHRwOi8vd3d3LmFwcGxlLmNvbS9jZXJ0aWZpY2F0ZWF1dGhvcml0eS8wDgYDVR0PAQH/BAQDAgeAMBAGCiqGSIb3Y2QGCwEEAgUAMA0GCSqGSIb3DQEBBQUAA4IBAQANphvTLj3jWysHbkKWbNPojEMwgl/gXNGNvr0PvRr8JZLbjIXDgFnf4+LXLgUUrA3btrj+/DUufMutF2uOfx/kd7mxZ5W0E16mGYZ2+FogledjjA9z/Ojtxh+umfhlSFyg4Cg6wBA3LbmgBDkfc7nIBf3y3n8aKipuKwH8oCBc2et9J6Yz+PWY4L5E27FMZ/xuCk/J4gao0pfzp45rUaJahHVl0RYEYuPBX/UIqc9o2ZIAycGMs/iNAGS6WGDAfK+PdcppuVsq1h1obphC9UynNxmbzDscehlD86Ntv0hgBgw2kivs3hi1EdotI9CO/KBpnBcbnoB7OUdFMGEvxxOoMIIEIjCCAwqgAwIBAgIIAd68xDltoBAwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCVVMxEzARBgNVBAoTCkFwcGxlIEluYy4xJjAkBgNVBAsTHUFwcGxlIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MRYwFAYDVQQDEw1BcHBsZSBSb290IENBMB4XDTEzMDIwNzIxNDg0N1oXDTIzMDIwNzIxNDg0N1owgZYxCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDKOFSmy1aqyCQ5SOmM7uxfuH8mkbw0U3rOfGOAYXdkXqUHI7Y5/lAtFVZYcC1+xG7BSoU+L/DehBqhV8mvexj/avoVEkkVCBmsqtsqMu2WY2hSFT2Miuy/axiV4AOsAX2XBWfODoWVN2rtCbauZ81RZJ/GXNG8V25nNYB2NqSHgW44j9grFU57Jdhav06DwY3Sk9UacbVgnJ0zTlX5ElgMhrgWDcHld0WNUEi6Ky3klIXh6MSdxmilsKP8Z35wugJZS3dCkTm59c3hTO/AO0iMpuUhXf1qarunFjVg0uat80YpyejDi+l5wGphZxWy8P3laLxiX27Pmd3vG2P+kmWrAgMBAAGjgaYwgaMwHQYDVR0OBBYEFIgnFwmpthhgi+zruvZHWcVSVKO3MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wLgYDVR0fBCcwJTAjoCGgH4YdaHR0cDovL2NybC5hcHBsZS5jb20vcm9vdC5jcmwwDgYDVR0PAQH/BAQDAgGGMBAGCiqGSIb3Y2QGAgEEAgUAMA0GCSqGSIb3DQEBBQUAA4IBAQBPz+9Zviz1smwvj+4ThzLoBTWobot9yWkMudkXvHcs1Gfi/ZptOllc34MBvbKuKmFysa/Nw0Uwj6ODDc4dR7Txk4qjdJukw5hyhzs+r0ULklS5MruQGFNrCk4QttkdUGwhgAqJTleMa1s8Pab93vcNIx0LSiaHP7qRkkykGRIZbVf1eliHe2iK5IaMSuviSRSqpd1VAKmuu0swruGgsbwpgOYJd+W+NKIByn/c4grmO7i77LpilfMFY0GCzQ87HUyVpNur+cmV6U/kTecmmYHpvPm0KdIBembhLoz2IYrF+Hjhga6/05Cdqa3zr/04GpZnMBxRpVzscYqCtGwPDBUfMIIEuzCCA6OgAwIBAgIBAjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwHhcNMDYwNDI1MjE0MDM2WhcNMzUwMjA5MjE0MDM2WjBiMQswCQYDVQQGEwJVUzETMBEGA1UEChMKQXBwbGUgSW5jLjEmMCQGA1UECxMdQXBwbGUgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxFjAUBgNVBAMTDUFwcGxlIFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDkkakJH5HbHkdQ6wXtXnmELes2oldMVeyLGYne+Uts9QerIjAC6Bg++FAJ039BqJj50cpmnCRrEdCju+QbKsMflZ56DKRHi1vUFjczy8QPTc4UadHJGXL1XQ7Vf1+b8iUDulWPTV0N8WQ1IxVLFVkds5T39pyez1C6wVhQZ48ItCD3y6wsIG9wtj8BMIy3Q88PnT3zK0koGsj+zrW5DtleHNbLPbU6rfQPDgCSC7EhFi501TwN22IWq6NxkkdTVcGvL0Gz+PvjcM3mo0xFfh9Ma1CWQYnEdGILEINBhzOKgbEwWOxaBDKMaLOPHd5lc/9nXmW8Sdh2nzMUZaF3lMktAgMBAAGjggF6MIIBdjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUK9BpR5R2Cf70a40uQKb3R01/CF4wHwYDVR0jBBgwFoAUK9BpR5R2Cf70a40uQKb3R01/CF4wggERBgNVHSAEggEIMIIBBDCCAQAGCSqGSIb3Y2QFATCB8jAqBggrBgEFBQcCARYeaHR0cHM6Ly93d3cuYXBwbGUuY29tL2FwcGxlY2EvMIHDBggrBgEFBQcCAjCBthqBs1JlbGlhbmNlIG9uIHRoaXMgY2VydGlmaWNhdGUgYnkgYW55IHBhcnR5IGFzc3VtZXMgYWNjZXB0YW5jZSBvZiB0aGUgdGhlbiBhcHBsaWNhYmxlIHN0YW5kYXJkIHRlcm1zIGFuZCBjb25kaXRpb25zIG9mIHVzZSwgY2VydGlmaWNhdGUgcG9saWN5IGFuZCBjZXJ0aWZpY2F0aW9uIHByYWN0aWNlIHN0YXRlbWVudHMuMA0GCSqGSIb3DQEBBQUAA4IBAQBcNplMLXi37Yyb3PN3m/J20ncwT8EfhYOFG5k9RzfyqZtAjizUsZAS2L70c5vu0mQPy3lPNNiiPvl4/2vIB+x9OYOLUyDTOMSxv5pPCmv/K/xZpwUJfBdAVhEedNO3iyM7R6PVbyTi69G3cN8PReEnyvFteO3ntRcXqNx+IjXKJdXZD9Zr1KIkIxH3oayPc4FgxhtbCS+SsvhESPBgOJ4V9T0mZyCKM2r3DYLP3uujL/lTaltkwGMzd/c6ByxW69oPIQ7aunMZT7XZNn/Bh1XZp5m5MkL72NVxnn6hUrcbvZNCJBIqxw8dtk2cXmPIS4AXUKqK1drk/NAJBzewdXUhMYIByzCCAccCAQEwgaMwgZYxCzAJBgNVBAYTAlVTMRMwEQYDVQQKDApBcHBsZSBJbmMuMSwwKgYDVQQLDCNBcHBsZSBXb3JsZHdpZGUgRGV2ZWxvcGVyIFJlbGF0aW9uczFEMEIGA1UEAww7QXBwbGUgV29ybGR3aWRlIERldmVsb3BlciBSZWxhdGlvbnMgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkCCA7rV4fnngmNMAkGBSsOAwIaBQAwDQYJKoZIhvcNAQEBBQAEggEAXyYKgx7UrQohMvls4QIbgc5Z6v8sBy7nVMZNSbLvnwu1w/jPgxpm8u0uHViOSgnVOvSd03WqDdIovRwGhiUohxVymjCq7HgjRwkuAQd4f1BWJBxHknJyCFyRnZOeiSSt37ma1fLXhjmN9XHITggfhae5+b7HzEI11Nhjmg3nb+eqHygityxNwbcZbz0ckzG6qwgTE+Y+Cm2YyWWZCRCDsK9FeAxS7Dxb5ed52OlMmxGqAXbHxTzB0vsa97Y7NIckN4Pxmt2eoHQmKBZp211F4AF5IkqUT9mWxQT2kkPE/V1QkpuY/0xcNbByCXq33nTkuaOVOi3I8UylIh8wmkTm2g==", //[receipt base64EncodedStringWithOptions:0]
                                          @"password" : @"f16bc519a4bd4ee3836427d5b85c422a"
                                          
                                          };
        
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                               
                                                              options:0
                               
                                                                error:&error];
        
        
        
        if (!requestData) { /* ... Handle error ... */ }
        
        
        
        // Create a POST request with the receipt data.
        
        NSURL *storeURL = [NSURL URLWithString:APPSTORE_RECEIPT_URL];
        
        NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
        
        [storeRequest setHTTPMethod:@"POST"];
        
        [storeRequest setHTTPBody:requestData];
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:storeRequest
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              if (error) {
                                                                  
                                                                  /* ... Handle error ... */
                                                                  
                                                              } else {
                                                                  
                                                                  NSError *error;
                                                                  
                                                                  NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                  NSLog(@"Response Data:%@",responseString);
                                                                  
                                                                  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                                  
                                                                  //NSLog(@"jsonResponse-%@",jsonResponse);
                                                                  
                                                                  if(![Utility isEmptyCheck:jsonResponse]){
                                                                      int status = [jsonResponse[@"status"] intValue];
                                                                      if(status == 0){
                                                                          //[self sendReceiptData];
                                                                      }
                                                                  }
                                                                  
                                                                  /* ... Send a response back to the device ... */
                                                                  
                                                              }
                                                          }];
        [dataTask resume];
        
        
    }
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark-Remove Activity Indicator
-(void)notifyRemoveActivity:(NSNotification *)notification{
    
    dispatch_async(dispatch_get_main_queue(),^ {
        
        if (contentView) {
            [contentView removeFromSuperview];
        }
        
    });
    
    if([notification.object isKindOfClass:[NSString class]]){
        NSString *type=notification.object;
        
        if([type isEqualToString:@"restore"]){
            if(![[StoreObserver sharedInstance] hasRestoredProducts]){
                [self alertWithTitle:@"Restore Purchase" message:@"No products found"];
            }
        }
        
        
    }
}
#pragma mark-End

#pragma mark-Set Local Notification
-(void)paidUserNotification{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *subscriptionDate = [NSDate date];
    
    //Day 1 Notification
    NSDate *day1 =  [calendar dateByAddingUnit:NSCalendarUnitMinute
                                         value:180
                                        toDate:subscriptionDate
                                       options:0];
    
    
    if(day1){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"paidUser", @"notificationType",@"WorldForum",@"pushTo",nil];
        
        NSDictionary *userData = [defaults objectForKey:@"NonSubscribedUserData"];
        
        NSString *name = @"";
        if (![Utility isEmptyCheck:userData] && ![Utility isEmptyCheck:userData[@"Email"]]) {
            
            name = ![Utility isEmptyCheck:userData[@"FirstName"]]?userData[@"FirstName"] : @"";
        }
        
        
        NSString *msg = [@"" stringByAppendingFormat:@"Hey %@, welcome to the most amazing health and fitness community of positive, proactive women on the planet! We are so excited to have you on board!  If you haven’t already, please join our worldwide forum",name];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day1;
        localNotification.alertTitle = @"Welcome";
        localNotification.alertBody = msg;
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    //End
    
    
    
    //Day 2 Notification
    NSDate *day2 =  [calendar dateByAddingUnit:NSCalendarUnitDay
                                         value:2
                                        toDate:subscriptionDate
                                       options:0];
    
    day2 = [calendar dateBySettingHour:12 minute:00 second:00 ofDate:day2 options:NSCalendarMatchStrictly];
    
    
    if(day2){
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"initialReminder", @"remType", @"paidUser", @"notificationType",@"CoursesList",@"pushTo",nil];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = day2;
        localNotification.alertTitle = @"";
        localNotification.alertBody = @"The difference between Squad and every other training, weight loss or nutrition program on earth is the EDUCATION. Take your knowledge to next level, start a super quick course today";
        //localNotification.alertAction = @"Check Now";
        [localNotification setTimeZone: [NSTimeZone defaultTimeZone]];
        //    [localNotification setRepeatInterval:];
        localNotification.soundName = @"Notification.caf";
        [localNotification setUserInfo:userInfo];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
}
#pragma mark-End


@end
