//
//  ChallengePreviousActivityViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 16/04/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ChallengePreviousActivityViewController.h"
#import "ChallengePreviousActivityTableViewCell.h"
@interface ChallengePreviousActivityViewController ()
{
    IBOutlet UITableView *previousActivityTable;
    IBOutlet UILabel *titlelabel;
    IBOutlet UILabel *noDataLabel;
    NSArray *scoreArray;
    UIView *contentView;
    BOOL willCountHidden;
    BOOL willTimeHidden;
    BOOL willRepsHidden;
    NSString *unitName;
    NSString *repsUnitName;
    int lastOne;
    int firstOne;
}
@end

@implementation ChallengePreviousActivityViewController
@synthesize excerciseDetailsDict;
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    previousActivityTable.estimatedRowHeight = 218;
    previousActivityTable.rowHeight = UITableViewAutomaticDimension;
    noDataLabel.hidden = true;
    scoreArray = [[NSArray alloc]init];
    if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"FinisherName"]]) {
        titlelabel.text = [excerciseDetailsDict objectForKey:@"FinisherName"];
    }
    [self webserviceCallForGetScoreBoard];
    // Do any additional setup after loading the view.
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

#pragma mark - IBAction
-(IBAction)videoButtonPressed:(UIButton*)sender{
    NSDictionary *dict = [scoreArray objectAtIndex:sender.tag];
    if (![Utility isEmptyCheck:[dict objectForKey:@"VideoFileName"]]) {
        NSString *videoUrl = [BASEVIDEOURL stringByAppendingString:[dict objectForKey:@"VideoFileName"]];
        NSURL *videoURL = [NSURL URLWithString:videoUrl];
        AVPlayerViewController *controller = [[AVPlayerViewController alloc]init];
        controller.player = [[AVPlayer alloc]initWithURL:videoURL];
        [self presentViewController:controller animated:YES completion:nil];
        controller.view.frame = self.view.frame;
        [controller.player play];
    }

}

- (IBAction)backButtonPressed:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)logoButtonPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - End

#pragma mark - WebServiceCall
-(void)webserviceCallForGetScoreBoard{
    if (Utility.reachable) {
        //dispatch_async(dispatch_get_main_queue(), ^{
        if (contentView) {
            [contentView removeFromSuperview];
        }
        contentView = [Utility activityIndicatorView:self];
        //});
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSError *error;
        
        NSString *finisherID = [NSString stringWithFormat:@"%@",[excerciseDetailsDict objectForKey:@"FinisherID"]];
        NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
        [mainDict setObject:[defaults objectForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:[defaults objectForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:finisherID forKey:@"FinisherId"];
        
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        
        //http://192.168.3.131:61430//api/GetScoreBoard
        
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetScoreBoard" append:@""forAction:@"POST"];
        
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSLog(@"%@",responseString);
                                                                     NSArray *finisherArray= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     //                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:finisherArray]) {
                                                                     
                                                                     if (![Utility isEmptyCheck:responseString]) {
                                                                         
                                                                         scoreArray = [finisherArray mutableCopy];
                                                                         
                                                                         if (![Utility isEmptyCheck:scoreArray]) {
                                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                                 noDataLabel.hidden = true;
                                                                                 [previousActivityTable reloadData];
                                                                             });
                                                                         }else{
                                                                             noDataLabel.hidden = false;
                                                                         }
                                                                     }
                                                                     else{
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
#pragma mark - End

#pragma mark - Private Function

#pragma mark - End

#pragma mark - TableiewDataSource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return scoreArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        NSString *CellIdentifier = @"ChallengePreviousActivityTableViewCell";
        ChallengePreviousActivityTableViewCell *cell;
        cell=[previousActivityTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ChallengePreviousActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:0];
    [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:1];
    [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:2];
    
    cell.playButton.tag =indexPath.row;
    
    cell.cellView.layer.borderColor = [Utility colorWithHexString:@"E425A0"].CGColor;
    cell.cellView.layer.borderWidth=1.14;
    
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

    if(willCountHidden){
        cell.countLabel.hidden=true;
        [cell.activityStack removeArrangedSubview:cell.countLabel];
    }else{
        [cell.activityStack addArrangedSubview:cell.countLabel];
        cell.countLabel.text=unitName;
    }

    if(willRepsHidden){
        cell.repsLabel.hidden=true;
        [cell.activityStack removeArrangedSubview:cell.repsLabel];
    }else{
        [cell.activityStack addArrangedSubview:cell.repsLabel];
        cell.repsLabel.text=repsUnitName;

    }

    if(willTimeHidden){
        cell.timeLabel.hidden=true;
        [cell.activityStack removeArrangedSubview:cell.timeLabel];
   }else{
        [cell.activityStack addArrangedSubview:cell.timeLabel];
        cell.timeLabel.hidden=false;
    }
    
    //End
    
    if (![Utility isEmptyCheck:[excerciseDetailsDict objectForKey:@"Priority"]]) {
        int prirityValue = [[excerciseDetailsDict objectForKey:@"Priority"]intValue];
        lastOne = prirityValue % 10; //is 3
        firstOne= (prirityValue - lastOne)/10; //is 53-3=50 /10 =5
        NSLog(@"Last-%d",lastOne);
        NSLog(@"First-%d",firstOne);
    
        if (firstOne >0) {
            if (firstOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:0];
                }
            }else if (firstOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:0];
                }
    
            }else if (firstOne == 3){//RespUnitname
                if (!willRepsHidden) {
                    [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:0];
                }
            }
            }
        if (lastOne>0 && firstOne>0){
            if (lastOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:1];
    
                }
            }else if (lastOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:1];
                }
    
            }else if (lastOne == 3){//RespUnitname
                if (!willRepsHidden) {
                   [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:1];
                }
            }
        }else{
            if (lastOne == 1) {//NumberOrder
                if (!willCountHidden) {
                    [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:0];
    
                }
            }else if (lastOne == 2){//TimeOrder
                if (!willTimeHidden) {
                    [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:0];
                }
    
            }else if (lastOne == 3){//RespUnitname
                if (!willRepsHidden) {
                    [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:0];
                }
            }
        }
    }
    if (firstOne !=2 && lastOne !=2 && !willTimeHidden) {
        if (firstOne >0 && lastOne>0) {
           [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:1];
        }else if((firstOne<0 && lastOne>0)){
            [cell.activityStack insertArrangedSubview:cell.timeLabel atIndex:0];
        }
    }
    if (firstOne !=1 && lastOne !=1 && !willCountHidden) {
       if (firstOne >0 && lastOne>0) {
            [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:1];
        }else if((firstOne<0 && lastOne>0)){
            [cell.activityStack insertArrangedSubview:cell.countLabel atIndex:0];
        }
    }
    
    if (firstOne !=3 && lastOne !=3 && !willRepsHidden) {
        if (firstOne >0 && lastOne>0) {
            [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:2];
        }else if(firstOne>0 && lastOne<0){
            [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:1];
       }else if((firstOne<0 && lastOne>0)){
           [cell.activityStack insertArrangedSubview:cell.repsLabel atIndex:0];
        }
   }
   
    NSDictionary *dict=[[scoreArray objectAtIndex:indexPath.row]mutableCopy];

//    NSString *idString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Id"]];
//    idString = (![idString isEqualToString:@"(null)"] && ![idString isEqualToString:@"<null>"]) ? idString : @"";
    
    NSString *respCountString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"RepsCount"]];
    respCountString = ![Utility isEmptyCheck:respCountString] ? respCountString : @"";
    
    cell.repsLabel.text=[@"" stringByAppendingFormat:@"%@ : %@",repsUnitName,respCountString]; ////Added on 27-Oct-2016 //AmitY
    
//    NSString *statusString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Status"]];
//    statusString = (![statusString isEqualToString:@"(null)"] && ![statusString isEqualToString:@"<null>"]) ? statusString : @"";
    
    NSString *taskDateString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskDate"]] ;
    taskDateString = ![Utility isEmptyCheck:taskDateString] ? taskDateString : @"";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSDate *yourDate = [dateFormatter dateFromString:taskDateString];
    dateFormatter.dateFormat = @"dd/MM/yyyy";
    NSString *dateString=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:yourDate]];
    dateString = ![Utility isEmptyCheck:dateString] ? dateString : @"";
    cell.dateLabel.text = [@"" stringByAppendingFormat:@"Date : %@",dateString];
    
    
    NSString *countString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Count"]];
    countString = ![Utility isEmptyCheck:countString] ? countString : @"";
    cell.countLabel.text = [@"" stringByAppendingFormat:@"%@ : %@",unitName,countString];
    
    NSString *taskTimeString=[NSString stringWithFormat:@"%@",[dict objectForKey:@"TaskTime"]];
    taskTimeString = ![Utility isEmptyCheck:taskTimeString] ? taskTimeString : @"";
    cell.timeLabel.text = [@"" stringByAppendingFormat:@"Time : %@",taskTimeString];
    
    
    NSString *videoLinkName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"VideoLink"]];
    videoLinkName = ![Utility isEmptyCheck:videoLinkName] ? videoLinkName : @"";
    cell.videoLinkTextView.text = [@"" stringByAppendingFormat:@"Video Link : %@",videoLinkName];
    
    NSString *videoFileName=[NSString stringWithFormat:@"%@",[dict objectForKey:@"VideoFileName"]];
    videoFileName = ![Utility isEmptyCheck:videoFileName] ? videoFileName : @"";
    cell.videoLabel.text = [@"" stringByAppendingFormat:@"Video : %@",videoFileName];;
    
    if ([Utility isEmptyCheck:videoFileName]) {
        cell.playButton.hidden=true;
    }
    else{
        cell.playButton.hidden=false;
    }
    
    return cell;
}
@end
