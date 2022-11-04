//
//  MessageListViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 05/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "MessageListViewController.h"

@interface MessageListViewController (){
    IBOutlet UITableView *fafTableView;
    NSMutableArray *messageArray;
    UIView *contentView;
    float currentHeight;
}

@end

@implementation MessageListViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentHeight = 0;
    messageArray = [[NSMutableArray alloc]init];
    fafTableView.estimatedRowHeight = 40;
    fafTableView.rowHeight = UITableViewAutomaticDimension;
    fafTableView.hidden = true;
    
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getMessageDetailsWebserviceCall];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    //    annCount = 0;
}
#pragma mark - End


#pragma mark - Webservicecall
-(void) getMessageDetailsWebserviceCall {
    
    if (Utility.reachable) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (contentView) {
                [contentView removeFromSuperview];
            }
            contentView = [Utility activityIndicatorView:self];
            contentView.backgroundColor = [UIColor clearColor];
            
        });
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
        NSURLSession *loginSession = [NSURLSession sharedSession];
        
        NSError *error;
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"userId"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetMessageList" append:@"" forAction:@"POST"];
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
                                                              [messageArray addObjectsFromArray:[responseDictionary objectForKey:@"MessageList"]];
                                                              
                                                              if(messageArray.count>0){
                                                                  fafTableView.hidden = false;
                                                              }
                                                             
                                                              [CATransaction flush];
                                                              
                                                              [CATransaction begin];
                                                              
                                                              //foo
                                                               [fafTableView reloadData];
                                                              [CATransaction commit];

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
#pragma mark - End

#pragma mark - Inbox Delegate
-(void) reloadInbox {
    [self getMessageDetailsWebserviceCall];
}
#pragma mark - End
#pragma mark - TableView Datasource & Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"TableViewCell";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.FaFImageView.image = [UIImage imageNamed:@"user_default.png"];
    if ([[defaults objectForKey:@"UserID"] intValue] == [[[messageArray objectAtIndex:indexPath.row] objectForKey:@"ReceiverId"] intValue]) {
        cell.FaFSenderNameLabel.text = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"SenderName"];
    } else {
        cell.FaFSenderNameLabel.text = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"ReceiverName"];
    }
    cell.FaFMessageLabel.numberOfLines = 0;
    if (![Utility isEmptyCheck: [[messageArray objectAtIndex:indexPath.row] objectForKey:@"LastMessage"]]) {
        
        NSString *instructionString = [@"" stringByAppendingFormat:@"%@", [[messageArray objectAtIndex:indexPath.row] objectForKey:@"LastMessage"] ];
        //****Instruction Level****//
        instructionString=[NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %f; color: %@;\">&nbsp%@&nbsp</span>", cell.FaFMessageLabel.font.fontName, cell.FaFMessageLabel.font.pointSize,[Utility hexStringFromColor:cell.FaFMessageLabel.textColor], instructionString];
        NSAttributedString *strAttributed = [[NSAttributedString alloc] initWithData:[instructionString dataUsingEncoding:NSUTF8StringEncoding]
                                                                             options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                       NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                       }
                                                                  documentAttributes:nil error:nil];
        cell.FaFMessageLabel.attributedText = strAttributed;
    }else{
        cell.FaFMessageLabel.text = @"";
    }
    
    
    
    //    cell.FaFTimeLabel.text = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"time"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Message"];
    if ([[defaults objectForKey:@"UserID"] intValue] == [[[messageArray objectAtIndex:indexPath.row] objectForKey:@"ReceiverId"] intValue]) {
        controller.receiverId = [[[messageArray objectAtIndex:indexPath.row] objectForKey:@"SenderId"] intValue];
        controller.receiverName = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"SenderName"];
    } else {
        controller.receiverId = [[[messageArray objectAtIndex:indexPath.row] objectForKey:@"ReceiverId"] intValue];
        controller.receiverName = [[messageArray objectAtIndex:indexPath.row] objectForKey:@"ReceiverName"];
    }
    controller.inboxDelegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - End


@end
