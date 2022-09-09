//
//  CustomAlertViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 22/2/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "CustomAlertViewController.h"

@interface CustomAlertViewController (){
    
    __weak IBOutlet UIView *middleAlertView;
    __weak IBOutlet UIView *bottomAlertView;
    
}

@end

@implementation CustomAlertViewController
@synthesize delegate,actionButton,crossButton,cancelButton,alertMsg,alertTitle,alertMsgString,alertTitleString,fromContoller,isSubscribed,actionButtonTitleString,ofType,haveToShowCross,trialUserAlert;

#pragma mark-View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark-End
#pragma mark-Private Method
-(void)setupView{
    alertTitle.text = alertTitleString;
    _bottomAlertTitleLabel.text = alertTitleString;
    alertMsg.text = alertMsgString;
    _bottomAlertMsg.text = alertMsgString;
    [actionButton setTitle:actionButtonTitleString forState:UIControlStateNormal];
    [_bottomAlertActionButton setTitle:actionButtonTitleString forState:UIControlStateNormal];
    
    _bottomAlertActionButton.layer.cornerRadius = 25.0;
    _bottomAlertActionButton.clipsToBounds = YES;
    
    if(_isAppstoreAlert){
        [cancelButton setTitle:@"NEXT TIME" forState:UIControlStateNormal];
        cancelButton.hidden = true;
    }
    
    if (haveToShowCross) {
        crossButton.hidden = false;
        cancelButton.hidden = true;
    }else{
        crossButton.hidden = true;
        cancelButton.hidden = false;
    }
    
    
    if(_isShowBottomAlert){
        crossButton.hidden = true;
        middleAlertView.hidden = true;
        bottomAlertView.hidden = false;
    }else{
        middleAlertView.hidden = false;
        bottomAlertView.hidden = true;
    }
    
    if(_isInAppPromo){
//        _loginButton.hidden = true;
        bottomAlertView.backgroundColor = [Utility colorWithHexString:@"92CFE1"];
        [_bottomAlertActionButton setBackgroundColor:[Utility colorWithHexString:@"E427A0"]];
        [_bottomAlertActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
//        _loginButton.hidden = false;
        bottomAlertView.backgroundColor = [Utility colorWithHexString:mbhqBaseColor];
        [_bottomAlertActionButton setBackgroundColor:[UIColor whiteColor]];
        [_bottomAlertActionButton setTitleColor:[Utility colorWithHexString:mbhqBaseColor] forState:UIControlStateNormal];
    }
    
    
    NSString *txtStr = @"NO THANKS";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:txtStr];
    
    
    [text addAttribute:NSUnderlineStyleAttributeName
                 value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                 range:NSMakeRange(0, text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentCenter;
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:17.0],
                               NSForegroundColorAttributeName : [UIColor whiteColor],
                               NSParagraphStyleAttributeName:paragraphStyle
                               };
    [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
    
    _noThanksLabel.attributedText = text;
    
    if(_isCancelSubsAlert){
        _bottomAlertTitleLabel.hidden = true;
        _bottomAlertActionButton.hidden = true;
//        _loginButton.hidden = true;
        _noThanksLabel.hidden = true;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:alertMsgString];
        
        
        NSRange range = [alertMsgString rangeOfString:@"customercare@mindbodyhq.com"];
        
        if(range.location != NSNotFound){
            [text addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                         range:range];
        }
        
        
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentCenter;
        
        NSDictionary *attrDict = @{
                                   NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:17.0],
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSParagraphStyleAttributeName:paragraphStyle
                                   };
        [text addAttributes:attrDict range:NSMakeRange(0,text.length)];
        
        _bottomAlertMsg.attributedText = text;
        
    }else if(_isWelcomeTrialAlert){
        _noThanksLabel.hidden = true;
    }
    
    
}
#pragma mark-End
#pragma mark-IBAction
-(IBAction)actionButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        //if ([delegate respondsToSelector:@selector(sendActionsForControlEvents: isSubscribed:)]) {
        if(self->_isAppstoreAlert){
            [self->delegate redirectToAppstore];
        }else if(self->trialUserAlert){
            [self->delegate sendActionToControllerForTrialUser:self->fromContoller ofType:self->ofType];
        }else if(self->_isInAppPromo){
            [self->delegate redirectionForInappPromo:self->fromContoller withData:self->_inAppPromoData];
        }else if(self->_isWelcomeTrialAlert){
            [self->delegate welcomeAlertAction:self->fromContoller];
        }else if(self->_isSetProgramSubsAlert){
            [self->delegate redirectionForSetProgram:self->fromContoller withData:self->_setProgramData];
        }
        else{
           [self->delegate sendActionToController:self->fromContoller isSubscribed:self->isSubscribed ofType:self->ofType isDowngrade:self->_isDowngrade isUpgrade:self->_isUpgrade];
        }
        
        //}
    }];
}
-(IBAction)cancelButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)loginButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [self->delegate redirectionToLogin:self->fromContoller];
    }];
}
#pragma mark-End

@end
