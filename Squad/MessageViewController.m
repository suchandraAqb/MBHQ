//
//  MessageViewController.m
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 15/11/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "MessageViewController.h"
#import "TableViewCell.h"
#import "Utility.h"

@interface MessageViewController (){
    IBOutlet UIScrollView *mainScroll;
    IBOutlet UITextView *messageTextView;
    IBOutlet NSLayoutConstraint *messageTextViewHeightConstraint;
    IBOutlet UITableView *messageTableView;
    IBOutlet UILabel *friendNameLabel;
    NSMutableArray *messageArray;
    UITextView *activeTextView;
    UIView *contentView;
    NSMutableDictionary *sendMessageDict;
    BOOL isScrolling;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    messageTableView.estimatedRowHeight = 48;
    messageTableView.rowHeight = UITableViewAutomaticDimension;
    [messageTableView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];

    [self registerForKeyboardNotifications];
    messageArray = [[NSMutableArray alloc]init];
    sendMessageDict = [[NSMutableDictionary alloc]init];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    messageTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    messageTextView.layer.borderWidth = 1;
    messageTextView.layer.cornerRadius = 5;
}
-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: YES];
    [self getMesageDetailsWebserviceCall];
    friendNameLabel.text = _receiverName;
}
-(void)viewWillDisappear:(BOOL)animated{
    [messageTableView removeObserver:self forKeyPath:@"contentSize"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == messageTableView) {
        if (messageTableView.contentSize.height > messageTableView.frame.size.height && !isScrolling)
        {
            
            CGPoint offset = CGPointMake(0, messageTableView.contentSize.height - messageTableView.frame.size.height);
            [messageTableView setContentOffset:offset animated:NO];
        }
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    [_inboxDelegate reloadInbox];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)sendButtonTapped:(id)sender {    //ah 02
    if (messageTextView.text.length > 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd yyyy hh:mm:ss.SSSa"];
        NSString *currentDateStr = [formatter stringFromDate:currentDate];
        
        [sendMessageDict setObject:[defaults objectForKey:@"UserID"] forKey:@"senderId"];
        [sendMessageDict setObject:[NSString stringWithFormat:@"%d",_receiverId] forKey:@"receiverId"];
        [sendMessageDict setObject:messageTextView.text forKey:@"content"];
        [sendMessageDict setObject:currentDateStr forKey:@"sendTime"];
        [sendMessageDict setObject:AccessKey forKey:@"Key"];
        [sendMessageDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionId"];
        
        
        [self sendMessageWebserviceCall];
    } else {
        [Utility msg:@"Please type a message to send" title:@"Oops!" controller:self haveToPop:NO];
    }
}
- (IBAction)refreshButtonTapped:(id)sender {
    [self getMesageDetailsWebserviceCall];
}
#pragma mark - Private Method
-(void)dismissKeyboard {
    [messageTextView resignFirstResponder];
}
#pragma mark - WebserviceCall
-(void) getMesageDetailsWebserviceCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"userId"];
        [mainDict setObject:[NSString stringWithFormat:@"%d",_receiverId] forKey:@"friendId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMessageDetail" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession
                                          dataTaskWithRequest:request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(),^ {
                                                  if (contentView) {
                                                      [contentView removeFromSuperview];
                                                  }
                                                  if(error == nil)
                                                  {
                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                          if ([[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                              [messageArray removeAllObjects];
                                                              [messageArray addObjectsFromArray:[responseDictionary objectForKey:@"MessageDetail"]];
                                                              [messageTableView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
                                                              [messageTableView reloadData];
                                                              if (messageArray.count > 0) {
                                                                  dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^(void){
                                                                      @try {
//                                                                          int rows = [messageTableView numberOfRowsInSection:0];
//                                                                          if (rows > 0) {
//                                                                              NSIndexPath* ip = [NSIndexPath indexPathForRow:(messageArray.count - 1) inSection:0];
//                                                                              [messageTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
//                                                                          }
                                                                          [messageTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];

                                                                      }
                                                                      @catch ( NSException *e )
                                                                      {
                                                                          NSLog(@"bummer: %@",e);
                                                                      }
                                                                      
                                                                  });
                                                              }

                                                          }
                                                      }else{
                                                          //                                                          [Utility msg:@"" title:@"Error !" controller:self haveToPop:NO];
                                                          return;
                                                      }
                                                      
                                                  }else{
                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                  }
                                              });
                                          }];
        [dataTask resume];
        
    } else {
        [Utility msg:@"Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}

-(void) sendMessageWebserviceCall {
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
        });
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSLog(@"send msg dict %@",sendMessageDict);
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:sendMessageDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"SendMessageToFriend" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession
                                          dataTaskWithRequest:request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(),^ {
                                                  if (contentView) {
                                                      [contentView removeFromSuperview];
                                                  }
                                                  if(error == nil)
                                                  {
                                                      NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                      NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                      if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary]) {
                                                          if ([[responseDictionary objectForKey:@"Success"] boolValue]) {
                                                              messageTextView.textColor = [UIColor lightGrayColor];
                                                              messageTextView.text = @"Type a message";
                                                              [messageTextView resignFirstResponder];
                                                              messageTextViewHeightConstraint.constant =40;
                                                              [self.view setNeedsUpdateConstraints];
                                                              [self getMesageDetailsWebserviceCall];
                                                          } else {
//                                                              [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                              messageTextView.textColor = [UIColor lightGrayColor];
                                                              messageTextView.text = @"Type a message";
                                                              [messageTextView resignFirstResponder];
                                                              messageTextViewHeightConstraint.constant =40;
                                                              [self.view setNeedsUpdateConstraints];
                                                              [self getMesageDetailsWebserviceCall];
                                                          }
                                                      }else{
//                                                        [Utility msg:@"" title:@"Error !" controller:self haveToPop:NO];
                                                          messageTextView.textColor = [UIColor lightGrayColor];
                                                          messageTextView.text = @"Type a message";
                                                          [messageTextView resignFirstResponder];
                                                          messageTextViewHeightConstraint.constant =40;
                                                          [self.view setNeedsUpdateConstraints];
                                                          [self getMesageDetailsWebserviceCall];
//                                                          return;
                                                      }
                                                      
                                                  }else{
                                                      [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                  }
                                              });
                                          }];
        [dataTask resume];
        
    } else {
        [Utility msg:@"Check Your network connection and try again." title:@"Error !" controller:self haveToPop:NO];
    }
}
#pragma mark - UITableViewDataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TableViewCell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.myMessageLabel.delegate = self;
    cell.senderMessageLabel.delegate = self;

    NSDictionary *messageDict = [messageArray objectAtIndex:indexPath.row];
    if ([[messageDict objectForKey:@"SenderId"] intValue] == [[defaults objectForKey:@"UserID"] intValue]) {
        cell.myMessageLabel.hidden = false;
        cell.myTimeLabel.hidden = false;
        cell.senderMessageLabel.hidden = true;
        cell.senderTimeLabel.hidden = true;
        
        //cell.myMessageLabel.preferredMaxLayoutWidth = 221;
        cell.myMessageLabel.layer.cornerRadius = 10;
        cell.myMessageLabel.editable = true;
        cell.myMessageLabel.clipsToBounds = YES;
        //cell.myMessageLabel.numberOfLines = 0;
        if (![Utility isEmptyCheck: [messageDict objectForKey:@"MessageContent"]]) {
            
            NSString *instructionString = [@"" stringByAppendingFormat:@"%@", [messageDict objectForKey:@"MessageContent"] ];
            //****Instruction Level****//
            instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: #fff;\">%@</span>", cell.myMessageLabel.font.fontName, cell.myMessageLabel.font.pointSize, instructionString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strAttributed];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strAttributed length])];
            cell.myMessageLabel.attributedText = attributedString;
            cell.myMessageLabel.editable = false;
            cell.myHeightConstraint.constant =cell.myMessageLabel.contentSize.height;

        }else{
            cell.myMessageLabel.text = @"";
        }

//        [cell.myMessageLabel sizeToFit];
//        
//        CGSize myStringSize = [cell.myMessageLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Raleway-Medium" size:15.0]}];
//        [cell.myMessageLabel drawTextInRect:CGRectMake(0, 0, myStringSize.width, myStringSize.height)];
        
        NSString *timeStr = [messageDict objectForKey:@"SendTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd yyyy hh:mma"];
        NSDate *timeDate = [formatter dateFromString:timeStr];
        [formatter setDateFormat:@"dd MMM HH:mm"];
        cell.myTimeLabel.text = [formatter stringFromDate:timeDate];
        
        friendNameLabel.text = [messageDict objectForKey:@"ReceiverName"];
    }else {
        cell.myMessageLabel.hidden = true;
        cell.myTimeLabel.hidden = true;
        cell.senderMessageLabel.hidden = false;
        cell.senderTimeLabel.hidden = false;
        
        //cell.senderMessageLabel.text = [messageDict objectForKey:@"MessageContent"];    //[NSString stringWithFormat:@"%@%@",[@" " stringByPaddingToLength:5 withString:@" " startingAtIndex:0],[messageDict objectForKey:@"MessageContent"]];
        //cell.senderMessageLabel.preferredMaxLayoutWidth = 221;
        cell.senderMessageLabel.layer.cornerRadius = 10;
        cell.senderMessageLabel.editable = true;
        cell.senderMessageLabel.clipsToBounds = YES;
        //cell.senderMessageLabel.numberOfLines = 0;
        if (![Utility isEmptyCheck: [messageDict objectForKey:@"MessageContent"]]) {
            NSString *instructionString = [messageDict objectForKey:@"MessageContent"];
            //****Instruction Level****//
            instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: #fff;\">%@</span>", cell.senderMessageLabel.font.fontName, cell.senderMessageLabel.font.pointSize, instructionString];
            NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:strAttributed];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strAttributed length])];
            cell.senderMessageLabel.attributedText = attributedString;
            cell.senderMessageLabel.editable = false;
            cell.senderHeightConstraint.constant =cell.senderMessageLabel.contentSize.height;

        }else{
            cell.senderMessageLabel.text = @"";
        }
        
//        [cell.senderMessageLabel sizeToFit];
        
//        CGSize senderStringSize = [cell.myMessageLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Raleway-Medium" size:15.0]}];
//        [cell.myMessageLabel drawTextInRect:CGRectMake(0, 0, senderStringSize.width+50, senderStringSize.height)];
//        [cell.senderMessageLabel drawTextInRect:UIEdgeInsetsInsetRect(cell.senderMessageLabel.bounds,UIEdgeInsetsMake(10,100,10,100))];
        
        NSString *timeStr = [messageDict objectForKey:@"SendTime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM dd yyyy hh:mma"];
        NSDate *timeDate = [formatter dateFromString:timeStr];
        [formatter setDateFormat:@"dd MMM HH:mm"];
        cell.senderTimeLabel.text = [formatter stringFromDate:timeDate];
        
        friendNameLabel.text = [messageDict objectForKey:@"SenderName"];    //ah new2
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeTextView.frame.origin) ) {
        CGRect newRect = activeTextView.frame;
        newRect.size.height = newRect.size.height + 8;
        
        [mainScroll scrollRectToVisible:newRect animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    mainScroll.contentInset = contentInsets;
    mainScroll.scrollIndicatorInsets = contentInsets;
    
}
#pragma mark - End -
#pragma mark - scrollview Delegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    isScrolling = true;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    isScrolling = false;
}
#pragma mark - textView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    activeTextView=textView;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    activeTextView=nil;
}
- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location == NSNotFound ) {
        return YES;
    }
    CGFloat maxHeight = 90;
    if (messageTextViewHeightConstraint.constant < maxHeight) {
        messageTextViewHeightConstraint.constant +=15;
        [self.view setNeedsUpdateConstraints];
    }
    
//    [txtView resignFirstResponder];
    return YES;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if([messageTextView.text caseInsensitiveCompare:@"Type a message"] == NSOrderedSame){
        messageTextView.text = @"";
        messageTextView.textColor = [UIColor colorWithRed:(244/255.0) green:(39/255.0) blue:(171/255.0) alpha:1];
    }
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(messageTextView.text.length == 0){
        messageTextView.textColor = [UIColor lightGrayColor];
        messageTextView.text = @"Type a message";
        [messageTextView resignFirstResponder];
    }
}
#pragma mark - End
@end
