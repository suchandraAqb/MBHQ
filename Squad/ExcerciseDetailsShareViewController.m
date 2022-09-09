//
//  ExcerciseDetailsShareViewController.m
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 11/11/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import "ExcerciseDetailsShareViewController.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>

@interface ExcerciseDetailsShareViewController ()
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *countLabel;
    IBOutlet UILabel *countTextLabel;
    IBOutlet UILabel *repsLabel;
    IBOutlet UILabel *repsTextLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *timeTextLabel;
    
    IBOutlet UIImageView *excerciseImageView;
    IBOutlet NSLayoutConstraint *shareViewHeightConstant;
    
    IBOutlet UILabel *instructionLabel;
    IBOutlet NSLayoutConstraint *instructionHeaderLabelConstant;
    IBOutlet NSLayoutConstraint *instructionLabelHeightConstant;
    IBOutlet UIView *instructionView;
    
    IBOutlet UIView *scroingView;
    IBOutlet UILabel *scroingLabel;
    IBOutlet NSLayoutConstraint *scrollingLabelHeightconstant;
    IBOutlet NSLayoutConstraint *scrollingHeaderLabelConstant;

    IBOutlet UIScrollView *scroll;
    
    IBOutlet UIView *myscoreView;
    IBOutlet UILabel *myscoreLabel;
    IBOutlet NSLayoutConstraint *myScoreHeightConstant;
    
    IBOutlet UIView *excerciseView;
    IBOutlet UILabel *excerciseNameLabel;
    IBOutlet NSLayoutConstraint *excerciseLabelHeightconstant;
    IBOutlet NSLayoutConstraint *excerciseHeaderLabelConstant;
    
    BOOL willCountHidden;
    BOOL willTimeHidden;
    BOOL willRepsHidden;
    NSString *unitName;
    NSString *repsUnitName;
}
@end

@implementation ExcerciseDetailsShareViewController
@synthesize scoreDict,excerciseDetailsDict,mainFinishSquadWowButtonTag,viewtag;

#pragma mark - IBAction

- (IBAction)shareButtonPressed:(id)sender {
    UIImage* image = nil;
    
     UIGraphicsBeginImageContextWithOptions(scroll.contentSize, scroll.opaque, 0.0);
    
//    UIGraphicsBeginImageContext(scroll.contentSize);
    {
        CGPoint savedContentOffset = scroll.contentOffset;
        CGRect savedFrame = scroll.frame;
        
        scroll.contentOffset = CGPointZero;
        scroll.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height);
        
        [scroll.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scroll.contentOffset = savedContentOffset;
        scroll.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
//        [UIImagePNGRepresentation(image) writeToFile: @"/tmp/test.png" atomically: YES];
//        system("open /tmp/test.png");
    }
       
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - End
#pragma mark- View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark - End

-(void)setupView{
    if (![Utility isEmptyCheck:scoreDict] && ![Utility isEmptyCheck:excerciseDetailsDict]) {
        
        NSMutableAttributedString *attributedString;
        NSMutableAttributedString *attributedString2;
        
        if ([mainFinishSquadWowButtonTag isEqualToString:@"squad"]) {
            excerciseImageView.image = [UIImage imageNamed:@"LBsquad_iconleader.png"];
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"SQUAD FINISHER"];
        }else if ([mainFinishSquadWowButtonTag isEqualToString:@"wow"]){
            excerciseImageView.image = [UIImage imageNamed:@"LBwow_iconleader.png"];
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"SQUAD WOW"];
        }else if ([mainFinishSquadWowButtonTag isEqualToString:@"battle"]){
            excerciseImageView.image = [UIImage imageNamed:@"LBsquad_battle.png"];
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"SQUAD BATTLE"];
        }else if ([mainFinishSquadWowButtonTag isEqualToString:@"collective"]){
            excerciseImageView.image = [UIImage imageNamed:@"LBsquad_collective.png"];
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"SQUAD COLLECTIVE"];
        }
        else{
            excerciseImageView.image = [UIImage imageNamed:@"LBfinisher_iconleader.png"];
            attributedString = [[NSMutableAttributedString alloc]initWithString:@"FULL BODY FINISHER"];
        }
        
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:17] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
        
        attributedString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"\n%@",[excerciseDetailsDict objectForKey:@"FinisherName"]]];
        [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:13] range:NSMakeRange(0, [attributedString2 length])];
        [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
        
        [attributedString appendAttributedString:attributedString2];
        titleLabel.attributedText = attributedString;

            NSString *numberOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"NumberOrder"]];
            willCountHidden = ([numberOrder isEqualToString:@"(null)"] || [numberOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *timeOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"TimeOrder"]];
            willTimeHidden = ([timeOrder isEqualToString:@"(null)"] || [timeOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *repsNumber=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsNumber"]];
            willRepsHidden = ([repsNumber isEqualToString:@"(null)"] || [repsNumber isEqualToString:@"<null>"]) ? YES : NO;
            
            unitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"UnitName"]];
            unitName = (![unitName isEqualToString:@"(null)"] && ![unitName isEqualToString:@"<null>"]) ? unitName : @"";
            
            repsUnitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsUnitName"]];
            repsUnitName = (![repsUnitName isEqualToString:@"(null)"] && ![repsUnitName isEqualToString:@"<null>"]) ? repsUnitName : @"";
            
            if(!willCountHidden){
                countLabel.text=unitName;
            }
            
            if(!willRepsHidden){
                repsLabel.text=repsUnitName;
            }

        if (![viewtag isEqualToString:@"LeaderBoard"]) {
            
            NSString *numberOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"NumberOrder"]];
            willCountHidden = ([numberOrder isEqualToString:@"(null)"] || [numberOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *timeOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"TimeOrder"]];
            willTimeHidden = ([timeOrder isEqualToString:@"(null)"] || [timeOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *repsNumber=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsNumber"]];
            willRepsHidden = ([repsNumber isEqualToString:@"(null)"] || [repsNumber isEqualToString:@"<null>"]) ? YES : NO;
            
            unitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"UnitName"]];
            unitName = (![unitName isEqualToString:@"(null)"] && ![unitName isEqualToString:@"<null>"]) ? unitName : @"";
            
            repsUnitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsUnitName"]];
            repsUnitName = (![repsUnitName isEqualToString:@"(null)"] && ![repsUnitName isEqualToString:@"<null>"]) ? repsUnitName : @"";
            
            NSString *detailString=@"My Score";
            NSString *detailString1=@"";

            if(!willCountHidden){
                NSString *countString=[@"" stringByAppendingFormat:@"%@",[scoreDict objectForKey:@"Count"]];
                countString = (![countString isEqualToString:@"(null)"] && ![countString isEqualToString:@"<null>"]) ? countString : @"";
                
                if (![Utility isEmptyCheck:unitName] && ![Utility isEmptyCheck:countString]) {
                    detailString = [detailString stringByAppendingFormat:@"\n%@ : %@",unitName,countString];
                }
            }
            if(!willRepsHidden){
                NSString *respCountString=[NSString stringWithFormat:@"%@",[scoreDict objectForKey:@"RepsCount"]];
                respCountString = (![respCountString isEqualToString:@"(null)"] && ![respCountString isEqualToString:@"<null>"]) ? respCountString : @"";
                if (![Utility isEmptyCheck:repsUnitName] && ![Utility isEmptyCheck:respCountString]) {
                    detailString = [detailString stringByAppendingFormat:@" \n%@ : %@",repsUnitName,respCountString];
                }
            }
            if(!willTimeHidden){
                NSString *taskTimeString=[NSString stringWithFormat:@"%@",[scoreDict objectForKey:@"TaskTime"]];
                taskTimeString = (![taskTimeString isEqualToString:@"(null)"] && ![taskTimeString isEqualToString:@"<null>"]) ? taskTimeString : @"";
                
                if (![Utility isEmptyCheck:taskTimeString]) {
                    NSArray* timeTakenArray = [taskTimeString componentsSeparatedByString: @":"];
                    NSString* hourString = [timeTakenArray objectAtIndex: 0];//hour
                    NSString *minString = [timeTakenArray objectAtIndex:1];//min
                    NSString *secString = [timeTakenArray objectAtIndex:2];//sec
                    
                    if (![Utility isEmptyCheck:hourString] && ![hourString isEqualToString:@"00"]) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ hour ",hourString];
                    }if (![Utility isEmptyCheck:minString] && ![minString isEqualToString:@"00"]) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ min ",minString];
                    }if (![Utility isEmptyCheck:secString] && ![secString isEqualToString:@"00"] ) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ sec ",secString];
                    }
                    detailString = [detailString stringByAppendingFormat:@"\nTime : %@",detailString1];
                }
            }
            NSLog(@"%@",detailString);
            myscoreLabel.text = detailString;
            
            if ([Utility isEmptyCheck:[scoreDict objectForKey:@"RepsCount"]] && [Utility isEmptyCheck:[scoreDict objectForKey:@"Count"]] && [Utility isEmptyCheck:[scoreDict objectForKey:@"TaskTime"]]) {
                myScoreHeightConstant.constant = 0.0f;
            }

        }else{
            NSString *numberOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"NumberOrder"]];
            willCountHidden = ([numberOrder isEqualToString:@"(null)"] || [numberOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *timeOrder=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"TimeOrder"]];
            willTimeHidden = ([timeOrder isEqualToString:@"(null)"] || [timeOrder isEqualToString:@"<null>"]) ? YES : NO;
            
            NSString *repsNumber=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsNumber"]];
            willRepsHidden = ([repsNumber isEqualToString:@"(null)"] || [repsNumber isEqualToString:@"<null>"]) ? YES : NO;
            
            unitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"UnitName"]];
            unitName = (![unitName isEqualToString:@"(null)"] && ![unitName isEqualToString:@"<null>"]) ? unitName : @"";
            
            repsUnitName=[NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"RepsUnitName"]];
            repsUnitName = (![repsUnitName isEqualToString:@"(null)"] && ![repsUnitName isEqualToString:@"<null>"]) ? repsUnitName : @"";
            
            NSString *detailString=@"My Score";
            NSString *detailString1=@"";
            
            if(!willCountHidden){
                NSString *countString=[@"" stringByAppendingFormat:@"%@",[scoreDict objectForKey:@"Score"]];
                countString = (![countString isEqualToString:@"(null)"] && ![countString isEqualToString:@"<null>"]) ? countString : @"";
                
                if (![Utility isEmptyCheck:unitName] && ![Utility isEmptyCheck:countString]) {
                    detailString = [detailString stringByAppendingFormat:@"\n%@ : %@",unitName,countString];
                }
            }
            if(!willRepsHidden){
                NSString *respCountString=[NSString stringWithFormat:@"%@",[scoreDict objectForKey:@"RepsCount"]];
                respCountString = (![respCountString isEqualToString:@"(null)"] && ![respCountString isEqualToString:@"<null>"]) ? respCountString : @"";
                if (![Utility isEmptyCheck:repsUnitName] && ![Utility isEmptyCheck:respCountString]) {
                    detailString = [detailString stringByAppendingFormat:@" \n%@ : %@",repsUnitName,respCountString];
                }
            }
            if(!willTimeHidden){
                NSString *taskTimeString=[NSString stringWithFormat:@"%@",[scoreDict objectForKey:@"Timetaken"]];
                taskTimeString = (![taskTimeString isEqualToString:@"(null)"] && ![taskTimeString isEqualToString:@"<null>"]) ? taskTimeString : @"";
                
                if (![Utility isEmptyCheck:taskTimeString]) {
                    NSArray* timeTakenArray = [taskTimeString componentsSeparatedByString: @":"];
                    NSString* hourString = [timeTakenArray objectAtIndex: 0];//hour
                    NSString *minString = [timeTakenArray objectAtIndex:1];//min
                    NSString *secString = [timeTakenArray objectAtIndex:2];//sec
                    
                    if (![Utility isEmptyCheck:hourString] && ![hourString isEqualToString:@"00"]) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ hour ",hourString];
                    }if (![Utility isEmptyCheck:minString] && ![minString isEqualToString:@"00"]) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ min ",minString];
                    }if (![Utility isEmptyCheck:secString] && ![secString isEqualToString:@"00"] ) {
                        detailString1 = [detailString1 stringByAppendingFormat:@"%@ sec ",secString];
                    }
                    detailString = [detailString stringByAppendingFormat:@"\nTime : %@",detailString1];
                }
                
            }
            NSLog(@"%@",detailString);
            myscoreLabel.text = detailString;
            
            if ([Utility isEmptyCheck:[scoreDict objectForKey:@"RepsCount"]] && [Utility isEmptyCheck:[scoreDict objectForKey:@"Score"]] && [Utility isEmptyCheck:[scoreDict objectForKey:@"Timetaken"]]) {
                myScoreHeightConstant.constant = 0.0f;
            }
        }
            NSString *detailString =@"";
            NSArray *exceriseListDetailArray= [excerciseDetailsDict objectForKey:@"ExerciseListDetail"];
        if (![mainFinishSquadWowButtonTag isEqualToString:@"wow"]) {
            if (![Utility isEmptyCheck:exceriseListDetailArray] &&exceriseListDetailArray.count>0) {
                for (int i=0; i<exceriseListDetailArray.count; i++) {
                    NSDictionary *dict = [exceriseListDetailArray objectAtIndex:i];
                    if ([detailString isEqualToString:@""]) {
                        detailString =[@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"ExerciseName"]];
                    }else{
                        detailString =[detailString stringByAppendingFormat:@"\n\n%@",[dict objectForKey:@"ExerciseName"]];
                    }
                }
                excerciseNameLabel.text = detailString;
                excerciseView.hidden=false;
            }
            else{
                excerciseHeaderLabelConstant.constant=0.f;
                excerciseLabelHeightconstant.constant=0.f;
                excerciseView.hidden=true;
            }
        }else{
            excerciseHeaderLabelConstant.constant=0.f;
            excerciseLabelHeightconstant.constant=0.f;
            excerciseView.hidden=true;
        }
        
            if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Instruction"]]) {
                instructionView.hidden=false;
                
                NSString *instructionString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Instruction"]];
                //****Instruction Level****//
                instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", instructionLabel.font.fontName, instructionLabel.font.pointSize,[Utility hexStringFromColor:instructionLabel.textColor], instructionString];
                NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                               }
                                                                          documentAttributes:nil error:nil];
                instructionLabel.attributedText = strAttributed;
            }
            else{
                instructionHeaderLabelConstant.constant=0.f;
                instructionLabelHeightConstant.constant=0.f;
                instructionView.hidden=true;
            }
            if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Scoring"]]) {
                
                scroingView.hidden=false;
                
                NSString *scroingString = [@"" stringByAppendingFormat:@"%@",[excerciseDetailsDict objectForKey:@"Scoring"]];
                //****Scroing Level****//
                
                scroingString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@\";>%@</span>", scroingLabel.font.fontName, scroingLabel.font.pointSize,[Utility hexStringFromColor:scroingLabel.textColor], scroingString];
                NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[scroingString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                               }
                                                                          documentAttributes:nil error:nil];
                scroingLabel.attributedText = strAttributed;
            }
            else{
                scrollingHeaderLabelConstant.constant=0.f;
                scrollingLabelHeightconstant.constant = 0.f;
                scroingView.hidden=true;
                }
            }
    }

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - End



@end
