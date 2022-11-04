//
//  AllMessageDetailsViewController.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 24/06/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "AllMessageDetailsViewController.h"
#import "AllMessageDetailsTableViewCell.h"
@interface AllMessageDetailsViewController ()
{
    IBOutlet UITableView *messageDetailsTable;
    IBOutlet UILabel *nodataLabel;
    IBOutlet UILabel *authorLabel;
    IBOutlet UIButton *authorImg;
    NSArray *messageDetailsArr;
    NSMutableArray *lastArr;
    NSArray *yestarDayArr;
    UIView *contentView;
}
@end

@implementation AllMessageDetailsViewController
@synthesize messageDetailsDict,allmessageDelegate;

#pragma mark - View Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    lastArr = [[NSMutableArray alloc]init];
    messageDetailsTable.estimatedRowHeight = 100;
    messageDetailsTable.rowHeight = UITableViewAutomaticDimension;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    authorImg.layer.cornerRadius = authorImg.layer.frame.size.height/2;
    authorImg.layer.masksToBounds = YES;
    authorImg.layer.borderColor = squadMainColor.CGColor;
    authorImg.layer.borderWidth = 1;
    
    if (![Utility isEmptyCheck:messageDetailsDict]) {
        if (![Utility isEmptyCheck:[messageDetailsDict objectForKey:@"AuthorName"]]) {
            authorLabel.text = [messageDetailsDict objectForKey:@"AuthorName"];
        }
        if (![Utility isEmptyCheck:[messageDetailsDict objectForKey:@"Photo"]]) {
            [authorImg sd_setImageWithURL:[NSURL URLWithString:[messageDetailsDict objectForKey:@"Photo"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"lb_avatar.png"] options:SDWebImageScaleDownLargeImages];
        } else {
            [authorImg setImage:[UIImage imageNamed:@"lb_avatar.png"] forState:UIControlStateNormal];
        }
        
        NSArray *msgArr = [messageDetailsDict objectForKey:@"Messages"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateComponents* comps = [[NSDateComponents alloc]init];
        comps.day = 1;
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* tomorowDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(ReleaseDate < %@)",[formatter stringFromDate:tomorowDate]];
        messageDetailsArr = [msgArr filteredArrayUsingPredicate:predicate1];
        NSLog(@"%@",messageDetailsArr);
        if (![Utility isEmptyCheck:messageDetailsArr] && messageDetailsArr.count>0) {
            NSDictionary *dict = [messageDetailsArr objectAtIndex:messageDetailsArr.count-1];
            if (![Utility isEmptyCheck:[dict objectForKey:@"ReleaseDate"]]) {
                NSString *releaseDateStr = [dict objectForKey:@"ReleaseDate"];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ReleaseDate == %@)",releaseDateStr];
                NSArray *arr = [messageDetailsArr filteredArrayUsingPredicate:predicate];
                lastArr = [arr mutableCopy];
            }
//            if (![Utility isEmptyCheck:lastArr] && lastArr.count>0 && (messageDetailsArr.count != lastArr.count)) {
//                NSDictionary *previousDict = [messageDetailsArr objectAtIndex:messageDetailsArr.count - (lastArr.count+1)];
//                NSString *releaseDateStr1 = [previousDict objectForKey:@"ReleaseDate"];
//                NSDateComponents* comps1 = [[NSDateComponents alloc]init];
//                comps1.day = -1;
//                NSCalendar* calendar1 = [NSCalendar currentCalendar];
//                NSDate* yestarDay = [calendar1 dateByAddingComponents:comps toDate:[NSDate date] options:0];
//                if ([releaseDateStr1 isEqualToString:[formatter stringFromDate:yestarDay]]) {
//                    NSPredicate *yestarDayPredicate = [NSPredicate predicateWithFormat:@"(ReleaseDate == %@)",releaseDateStr1];
//                    yestarDayArr = [messageDetailsArr filteredArrayUsingPredicate:yestarDayPredicate];
//                }
//            }
            
//            if (![Utility isEmptyCheck:yestarDayArr] && yestarDayArr.count>0) {
//                [lastArr addObjectsFromArray:yestarDayArr];
//            }
        }

        if (![Utility isEmptyCheck:messageDetailsArr] && messageDetailsArr.count>0) {
            nodataLabel.hidden = true;
            [messageDetailsTable reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->messageDetailsTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self->messageDetailsArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            });
        }else{
            nodataLabel.hidden = false;
            messageDetailsTable.hidden = true;
        }
        NSArray *messagesArr = [messageDetailsDict objectForKey:@"Messages"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"IsRead == NO"];
        NSArray *messageUnreadCountArr = [messagesArr filteredArrayUsingPredicate:predicate];
        
        if (messageUnreadCountArr.count>0) {
            [self webServiceCall_MarkMessageRead];
        }else{
            if ([self->allmessageDelegate respondsToSelector:@selector(didChangeValueForKey:)]) {
                [self->allmessageDelegate didCheckAnyChange:false];
            }
        }
    }
}
#pragma mark - End

#pragma mark - Private Function
-(void)videoUrlTapped:(NSString*)videoStr{
    HelpVideoPlayerViewController *helpVideoPlayerViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpVideoPlayerView"];
    helpVideoPlayerViewController.modalPresentationStyle = UIModalPresentationCustom;
    helpVideoPlayerViewController.videoURLString = videoStr;
    helpVideoPlayerViewController.isFromMessage = YES;
    helpVideoPlayerViewController.delegate = self;
    [self presentViewController:helpVideoPlayerViewController animated:YES completion:nil];
}
-(void)webServiceCall_MarkMessageRead{
    if (Utility.reachable) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self->contentView) {
//                [self->contentView removeFromSuperview];
//            }
//            self->contentView = [Utility activityIndicatorView:self];
//        });
        
        NSURLSession *customSession = [NSURLSession sharedSession];
        
        NSError *error;
        
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[messageDetailsDict objectForKey:@"AuthorId"] forKey:@"AuthorId"];
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentdate = [format stringFromDate:[NSDate date]];
        [mainDict setObject:currentdate forKey:@"CurrentUserDate"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"MarkMessageRead" append:@""forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[customSession dataTaskWithRequest:request
                                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
//                                                                  if (self->contentView) {
//                                                                      [self->contentView removeFromSuperview];
//                                                                  }
                                                                  if(error == nil)
                                                                  {
                                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                      NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict] && [[responseDict objectForKey:@"SuccessFlag"]boolValue]) {
                                                                          if ([self->allmessageDelegate respondsToSelector:@selector(didChangeValueForKey:)]) {
                                                                              [self->allmessageDelegate didCheckAnyChange:true];
                                                                          }
                                                                      }
                                                                      else{
                                                                          [Utility msg:[responseDict objectForKey:@"ErrorMessage"] title:@"Error !" controller:self haveToPop:NO];
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
#pragma mark - IBAction

-(IBAction)backButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - End

#pragma mark - Tableview DataSource & Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageDetailsArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AllMessageDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllMessageDetailsTableViewCell"];
    cell.readunreadButton.layer.cornerRadius = cell.readunreadButton.frame.size.height/2;
    cell.readunreadButton.layer.masksToBounds = YES;
    
    cell.messageView.layer.cornerRadius = 15;
    cell.messageView.layer.masksToBounds = YES;
    
    NSDictionary *messageDict = [messageDetailsArr objectAtIndex:indexPath.row];
    
    if (![Utility isEmptyCheck:messageDict]) {
        NSString *detailsStr=@"";
        
        if (![Utility isEmptyCheck:[messageDict objectForKey:@"ArticleTitle"]]) {
            detailsStr = [messageDict objectForKey:@"ArticleTitle"];
            if (![Utility isEmptyCheck:detailsStr] && [detailsStr containsString:@"[name]"]) {
                detailsStr = [detailsStr stringByReplacingOccurrencesOfString:@"[name]" withString:[defaults objectForKey:@"FirstName"]];
            }else{
                detailsStr = [messageDict objectForKey:@"ArticleTitle"];
            }
        }
//        NSLog(@"%@",messageDict);
        if (![Utility isEmptyCheck:[messageDict objectForKey:@"PublicUrl"]]) {
            if (![detailsStr isEqualToString:@""]) {
                detailsStr = [detailsStr stringByAppendingString:@"\n\nClick here"];
            }else{
                detailsStr = @"Click here";
            }
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:detailsStr];
            NSRange foundRange = [text.mutableString rangeOfString:@"Click here"];
            [text addAttribute:NSLinkAttributeName value:[@"" stringByAppendingFormat:@"%@-video://",[messageDict objectForKey:@"ArticleId"]] range:foundRange];
            
            [text addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                         range:foundRange];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment                = NSTextAlignmentLeft;
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:19.0],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSParagraphStyleAttributeName:paragraphStyle
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            cell.messageTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

            cell.messageTextView.text=@"";
            cell.messageTextView.attributedText = text;
          
        }else if(![Utility isEmptyCheck:[messageDict objectForKey:@"DeepLink"]]){
            if (![detailsStr isEqualToString:@""]) {
                detailsStr = [detailsStr stringByAppendingString:@"\n\nClick Here"];
            }else{
                detailsStr = @"Click here";
            }
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:detailsStr];
            NSRange foundRange = [text.mutableString rangeOfString:@"Click Here"];
            [text addAttribute:NSLinkAttributeName value:[@"" stringByAppendingFormat:@"%@-deepLink://",[messageDict objectForKey:@"ArticleId"]] range:foundRange];
            
            [text addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                         range:foundRange];
            
            NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
            paragraphStyle.alignment                = NSTextAlignmentLeft;
            
            NSDictionary *attrDict = @{
                                       NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:19.0],
                                       NSForegroundColorAttributeName : [UIColor whiteColor],
                                       NSParagraphStyleAttributeName:paragraphStyle
                                       };
            [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
            cell.messageTextView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

            cell.messageTextView.text=@"";
            cell.messageTextView.attributedText = text;
        }
        else{
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@""];
            cell.messageTextView.attributedText = text;
            cell.messageTextView.text = detailsStr;
        }
        cell.messageTextView.editable = NO;
        cell.messageTextView.selectable = YES;
        cell.messageTextView.delaysContentTouches = NO;
        
        
        if (![Utility isEmptyCheck:[messageDict objectForKey:@"ReleaseDate"]]) {
            NSDateFormatter *formatter= [NSDateFormatter new];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:[messageDict objectForKey:@"ReleaseDate"]];
            NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
            [formatter1 setAMSymbol:@"am"];
            [formatter1 setPMSymbol:@"pm"];
            
            NSString *dayDateLabel=@"";
//            NSString *timestr = @"";
          
            if ([lastArr containsObject:messageDict]){
              
                NSString *releaseDateStr = [messageDict objectForKey:@"ReleaseDate"];
                NSArray *dateArr = [releaseDateStr componentsSeparatedByString:@" "];
                NSString *todayStr = [dateArr objectAtIndex:0];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"yyyy-MM-dd"];
                
                [formatter1 setDateFormat:@"EEEE"];//EEEE,hh:mm a
//                NSString *dateStr = [formatter1 stringFromDate:date];
//                NSArray *splitDateArr = [dateStr componentsSeparatedByString:@","];
//                if (![Utility isEmptyCheck:splitDateArr] && splitDateArr.count>0) {
//                    dayDateLabel = [@"" stringByAppendingFormat:@"%@",[splitDateArr objectAtIndex:0]];
//                    timestr =[@"" stringByAppendingFormat:@" %@",[splitDateArr objectAtIndex:1]];
//                }
                
                if ([todayStr isEqualToString:[formatter stringFromDate:[NSDate date]]]) {
                    dayDateLabel = @"Today";
//                    NSString *dateStr = [formatter1 stringFromDate:date];
//                    NSArray *splitDateArr = [dateStr componentsSeparatedByString:@","];
//                    if (![Utility isEmptyCheck:splitDateArr] && splitDateArr.count>0) {
//                        timestr =[@"" stringByAppendingFormat:@" %@",[splitDateArr objectAtIndex:1]];
//                    }
                }else{
                    [formatter1 setDateFormat:@"EEEE,dd MMM"];//EEEE,dd MMM,hh:mm a
                    
                    NSString *dateStr = [formatter1 stringFromDate:date];
                    NSArray *splitDateArr = [dateStr componentsSeparatedByString:@","];
                    if (![Utility isEmptyCheck:splitDateArr] && splitDateArr.count>0) {
                        dayDateLabel = [@"" stringByAppendingFormat:@"%@,%@",[splitDateArr objectAtIndex:0],[splitDateArr objectAtIndex:1]];
//                        timestr =[@"" stringByAppendingFormat:@", %@",[splitDateArr objectAtIndex:2]];
                    }
                }
            }else{
                [formatter1 setDateFormat:@"EEEE,dd MMM"];//EEEE,dd MMM,hh:mm a
            
                NSString *dateStr = [formatter1 stringFromDate:date];
                NSArray *splitDateArr = [dateStr componentsSeparatedByString:@","];
                if (![Utility isEmptyCheck:splitDateArr] && splitDateArr.count>0) {
                    dayDateLabel = [@"" stringByAppendingFormat:@"%@,%@",[splitDateArr objectAtIndex:0],[splitDateArr objectAtIndex:1]];
//                    timestr =[@"" stringByAppendingFormat:@", %@",[splitDateArr objectAtIndex:2]];
                }
            }
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:dayDateLabel];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Bold" size:12] range:NSMakeRange(0, [attributedString length])];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"333333"] range:NSMakeRange(0, [attributedString length])];
                
//                NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:timestr];
//                [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-Medium" size:12] range:NSMakeRange(0, [attributedString2 length])];
//                [attributedString2 addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHexString:@"333333"] range:NSMakeRange(0, [attributedString2 length])];
            
//                [attributedString appendAttributedString:attributedString2];
                cell.dateLabel.attributedText = attributedString;
    
        }else{
            cell.dateLabel.text =@"";
        }
        if ([[messageDict objectForKey:@"IsRead"]boolValue]) {
            cell.readUnreadView.hidden = true;
        }else{
            cell.readUnreadView.hidden = false;
        }
        cell.readUnreadView.hidden = true;
    }
    return cell;
}
#pragma mark - End

#pragma mark - textField Delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    NSString *str = URL.absoluteString;
    if ([str containsString:@"video"]) {
        NSArray *messageIdArr = [str componentsSeparatedByString:@"-"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ArticleId == %d)",[[messageIdArr objectAtIndex:0]intValue]];
        NSArray *arr = [messageDetailsArr filteredArrayUsingPredicate:predicate];
        if (arr.count>0) {
            NSString *videoUrlStr = [[arr objectAtIndex:0]objectForKey:@"PublicUrl"];
            if (![Utility isEmptyCheck:videoUrlStr]) {
                [self videoUrlTapped:videoUrlStr];
            }
        }
    }else{
        NSArray *messageIdArr = [str componentsSeparatedByString:@"-"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ArticleId == %d)",[[messageIdArr objectAtIndex:0]intValue]];
        NSArray *arr = [messageDetailsArr filteredArrayUsingPredicate:predicate];
        if (arr.count>0) {
            NSString *deepLinkStr = [[arr objectAtIndex:0]objectForKey:@"DeepLink"];
          
            if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:deepLinkStr]]){
                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:deepLinkStr] options:@{} completionHandler:^(BOOL success) {
                if(success){
                    NSLog(@"Opened");
                    }
                }];
            }
        }
    }
    return NO;
}
@end
