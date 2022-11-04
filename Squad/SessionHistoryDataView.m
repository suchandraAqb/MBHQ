//
//  SessionHistoryDataView.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 27/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "SessionHistoryDataView.h"

@implementation SessionHistoryDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(SessionHistoryDataView *)instantiateView{
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"SessionHistoryDataView" owner:self options:nil];
    return (SessionHistoryDataView *)[nibs firstObject];
}

-(void)updateData:(NSDictionary*)dataDict{
    float weight = [[dataDict objectForKey:@"Weight"]floatValue];
    int repGoal = [[dataDict objectForKey:@"RepGoal"]intValue];
    
    NSString *defaultReps = @"";
    NSString *weightStr = @"";
    if (![Utility isEmptyCheck:dataDict[@"DefaultReps"]]) {
        defaultReps = dataDict[@"DefaultReps"];
    }
    
    if(weight>0.0){
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            weightStr = [@"" stringByAppendingFormat:@"%@ kg",[formatter stringFromNumber:[NSNumber numberWithFloat:weight]]];
            
        }else{
            CGFloat lb = weight * 2.2046;
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterDecimalStyle;
            formatter.maximumFractionDigits = 2;
            weightStr = [@"" stringByAppendingFormat:@"%@ lb",[formatter stringFromNumber:[NSNumber numberWithFloat:lb]]];
        }
        
    }else if(repGoal > 0 && weight == 0.0){
        weightStr = @"N/A";
    }
    
    
    
    NSString *concatStr = [@"" stringByAppendingFormat:@"%@ | %d %@",weightStr,repGoal,defaultReps];
    _sessionNameLabel.text = [@"" stringByAppendingFormat:@"\u2022 %@", concatStr];
    
}
@end
