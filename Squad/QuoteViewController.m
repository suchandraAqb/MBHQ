//
//  QuoteViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 12/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "QuoteViewController.h"
#import "QuoteGalleryViewController.h"
@interface QuoteViewController ()
{
    IBOutlet UILabel *quoteLabel;
    IBOutlet UILabel *authorLabel;
    IBOutlet UIButton *favButton;
}
@end

@implementation QuoteViewController
@synthesize quoteDict;

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    quoteLabel.adjustsFontSizeToFitWidth=YES;
    quoteLabel.minimumScaleFactor=0.5;
    
    if (![Utility isEmptyCheck:quoteDict]) {
        /*NSString *quoteStr;
        if (_fromAppDelegate) {
            quoteStr =[quoteDict objectForKey:@"quoteText"];
        }else{
            quoteStr =[quoteDict objectForKey:@"quoteList"];
        }
    
        NSArray *brokenByLinesArr=[quoteStr componentsSeparatedByString:@"\n"];
        if (![Utility isEmptyCheck:brokenByLinesArr]) {
            if (![Utility isEmptyCheck:[brokenByLinesArr objectAtIndex:0]]) {
                quoteLabel.text = [brokenByLinesArr objectAtIndex:0];
            }
            if (![Utility isEmptyCheck:[brokenByLinesArr objectAtIndex:1]]) {
                authorLabel.text = [brokenByLinesArr objectAtIndex:1];
            }
        }*/
        
        NSString *quote = !([Utility isEmptyCheck:quoteDict[@"QUOTE"]])?[quoteDict[@"QUOTE"] uppercaseString]:@"";
        quoteLabel.text = quote;
        NSString *credit = !([Utility isEmptyCheck:quoteDict[@"Credit"]])?[quoteDict[@"Credit"] uppercaseString]:@"-UNKNOWN-";
        authorLabel.text = credit;
    
    if (![Utility isEmptyCheck:[quoteDict objectForKey:@"favStatus"]]) {
        NSString *favStatusStr =[quoteDict objectForKey:@"favStatus"];
        if ([favStatusStr isEqualToString:@"0"]) {
            favButton.selected = false;
        }else{
            favButton.selected = true;
            }
        }
    }
}

#pragma mark - End

#pragma mark - IBAction

-(IBAction)favButtonPressed:(id)sender{
    if (favButton.isSelected) {
         favButton.selected = false;
         [self updateFavDB];
    }else{
         favButton.selected = true;
         [self updateDB];
    }
}

-(IBAction)viewQuoteGalleryButtonPressed:(id)sender{
    
    if(_fromAppDelegate){
        QuoteGalleryViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"QuoteGalleryView"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - End

#pragma mark - Private Function

-(void)updateDB{
    if (![Utility isSubscribedUser]){
        return;
    }
//    NSString *detailsString = @"";
    
//    if(responseArray.count>0){
//        NSError *error;
//        NSData *favData = [NSJSONSerialization dataWithJSONObject:responseArray options:NSJSONWritingPrettyPrinted  error:&error];
//
//        if (error) {
//
//            NSLog(@"Error Favorite Array-%@",error.debugDescription);
//        }
//
//        detailsString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
//    }
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
    NSString *personalDateStr = @"";
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"MMM"];//yyyy-MM-dd
    NSString *addedMonthStr = [formatter stringFromDate:[NSDate date]];
    
    if (![Utility isEmptyCheck:quoteDict]) {
            NSString *quoteStr;
            if (_fromAppDelegate) {
                quoteStr =[quoteDict objectForKey:@"quoteText"];
            }else{
                quoteStr =[quoteDict objectForKey:@"quoteList"];
            }
         if (![Utility isEmptyCheck:quoteStr]) {
            
            if([DBQuery isRowExist:@"quoteList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and quoteList = '%@'",userId,quoteStr]]){
                [DBQuery updateQuoteDetails:quoteStr addedDate:addedDateStr addedMonth:addedMonthStr personalAddDate:personalDateStr personalQuote:@"" favStatues:@"0"];
            }else{
                [DBQuery addQuoteDetails:quoteStr addedDate:addedDateStr addedMonth:addedMonthStr personalAddDate:personalDateStr personalQuote:@"" favStatues:@"0"];
            }
        }
    }
    
}

//-(void)deleteDataFromDb{
//    DAOReader *dbObject = [DAOReader sharedInstance];
//    if([dbObject connectionStart]){
//        int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
//        if (![Utility isEmptyCheck:quoteDict]) {
//            NSString *quoteStr;
//            if (_fromAppDelegate) {
//                quoteStr =[quoteDict objectForKey:@"quoteText"];
//            }else{
//                quoteStr =[quoteDict objectForKey:@"quoteList"];
//            }
//            if (![Utility isEmptyCheck:quoteStr]) {
//                [dbObject deleteWhen:@"quoteList" whereCondition:[@"" stringByAppendingFormat:@"UserId ='%d' and quoteList = '%@'",userId,quoteStr]];
//
//                [dbObject connectionEnd];
//            }
//        }
//    }
//}

-(void)updateFavDB{
    if (![Utility isSubscribedUser]){
        return;
    }
    //    NSString *detailsString = @"";
    
    //    if(responseArray.count>0){
    //        NSError *error;
    //        NSData *favData = [NSJSONSerialization dataWithJSONObject:responseArray options:NSJSONWritingPrettyPrinted  error:&error];
    //
    //        if (error) {
    //
    //            NSLog(@"Error Favorite Array-%@",error.debugDescription);
    //        }
    //
    //        detailsString = [[NSString alloc] initWithData:favData encoding:NSUTF8StringEncoding];
    //    }
    int userId = [[defaults objectForKey:@"ABBBCOnlineUserId"] intValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd
    NSString *personalDateStr = @"";
    NSString *addedDateStr = [formatter stringFromDate:[NSDate date]];
    
    [formatter setDateFormat:@"MMM"];//yyyy-MM-dd
    NSString *addedMonthStr = [formatter stringFromDate:[NSDate date]];
    
    if (![Utility isEmptyCheck:quoteDict]) {
        NSString *quoteStr;
        if (_fromAppDelegate) {
            quoteStr =[quoteDict objectForKey:@"quoteText"];
        }else{
            quoteStr =[quoteDict objectForKey:@"quoteList"];
        }
        if (![Utility isEmptyCheck:quoteStr]) {
            
            if([DBQuery isRowExist:@"quoteList" condition:[@"" stringByAppendingFormat:@"UserId ='%d' and quoteList = '%@'",userId,quoteStr]]){
                [DBQuery updateQuoteDetails:quoteStr addedDate:addedDateStr addedMonth:addedMonthStr personalAddDate:personalDateStr personalQuote:@"" favStatues:@"0"];
            }else{
                [DBQuery addQuoteDetails:quoteStr addedDate:addedDateStr addedMonth:addedMonthStr personalAddDate:personalDateStr personalQuote:@"" favStatues:@"0"];
            }
        }
    }
    
}
@end
