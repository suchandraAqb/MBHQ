//
//  MyDiaryListViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 06/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MyDiaryListViewController.h"
#import "MyDiaryListTableViewCell.h"
#import "MyDairyAddEditViewController.h"
#import "NewMyDiaryAddEdit.h"



@interface MyDiaryListViewController (){
    IBOutlet UITableView *table;
    
    IBOutlet UILabel *financeHeaderText;
    IBOutlet UILabel *familyHeaderText;
    IBOutlet UILabel *healthHeaderText;
    
    IBOutlet UILabel *financeText;
    IBOutlet UILabel *familyText;
    IBOutlet UILabel *healthText;

    
    
    NSArray *myDiaryListArray;
    UIView *contentView;
}

@end

@implementation MyDiaryListViewController
@synthesize goalValueArray;
#pragma  -mark IBAction
- (IBAction)addDiaryPressed:(UIButton *)sender {
    MyDairyAddEditViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDairyAddEdit"];
    controller.isEdit = true;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (IBAction)logoButtonPressed:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)showMenu:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma  -mark End
#pragma mark - Private Function -
-(void)getDiaryList{
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
        [mainDict setObject:[defaults valueForKey:@"UserID"] forKey:@"UserID"];
        [mainDict setObject:AccessKey forKey:@"Key"];
        [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
        if (error) {
            [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
            return;
        }
        NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
        NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetDairyListApiCall" append:@"" forAction:@"POST"];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 if (contentView) {
                                                                     [contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"] boolValue]) {
                                                                         myDiaryListArray = [responseDictionary objectForKey:@"Details"];
                                                                         [table reloadData];
                                                                     }else{
                                                                         [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                                                                         return;
                                                                         
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:NO];
                                                                 }
                                                             });
                                                             
                                                             
                                                         }];
        [dataTask resume];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
            return;
        });
        
    }
}
#pragma  -mark End

#pragma  -mark ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    table.estimatedRowHeight = 44;
    table.rowHeight = UITableViewAutomaticDimension;
    for (int i=0; i<goalValueArray.count;i++ ) {
        NSDictionary *dict = [goalValueArray objectAtIndex:i];
        if (i == 0) {
            financeHeaderText.text = [[dict objectForKey:@"value"] uppercaseString];
            financeText.text = [@"" stringByAppendingFormat:@"%@",@"1"];
        }if (i == 1) {
            familyHeaderText.text = [[dict objectForKey:@"value"] uppercaseString];
            familyText.text = [@"" stringByAppendingFormat:@"%@",@"2"];
        }if (i == 2) {
            healthHeaderText.text = [[dict objectForKey:@"value"] uppercaseString];
            healthText.text = [@"" stringByAppendingFormat:@"%@",@"3"];
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getDiaryList];
}
#pragma  -mark End
#pragma mark - TableView Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myDiaryListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier =@"MyDiaryListTableViewCell";
    MyDiaryListTableViewCell *cell = (MyDiaryListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[MyDiaryListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dict =[myDiaryListArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:dict]) {
        NSString *createdDate = [dict objectForKey:@"DueDate"];
        if (createdDate.length >=19) {
            createdDate = [createdDate substringToIndex:19];
        }
        static NSDateFormatter *dateFormatter;
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:createdDate];
        NSLog(@"%@",date);
        if (date) {
            [dateFormatter setDateFormat:@"MMM d yyyy"];
            NSString *dateString = [dateFormatter stringFromDate:date];
            cell.diaryDate.text = dateString;
            cell.diaryDate.layer.cornerRadius = cell.diaryDate.frame.size.height/2;
            cell.diaryDate.clipsToBounds = YES;
        }else{
            cell.diaryDate.hidden = TRUE;
        }

        NSString *detailsString = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"Details"]];
        if (![Utility isEmptyCheck:detailsString]) {

            detailsString = [detailsString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            detailsString = [detailsString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            detailsString= [detailsString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            detailsString=[NSString stringWithFormat:@"<span style=\"font-size: %f;\";>%@</span>", cell.diaryText.font.pointSize, detailsString];
            NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[detailsString dataUsingEncoding:NSUTF8StringEncoding]
                                                                                 options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                           NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)
                                                                                           }
                                                                      documentAttributes:nil error:nil];
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineBreakMode = NSLineBreakByTruncatingTail;
            [strAttributed addAttribute:NSParagraphStyleAttributeName
                         value:style
                         range:NSMakeRange(0, strAttributed.length)];
            cell.diaryText.attributedText = strAttributed;
        }else{
            cell.diaryText.text = @"";
        }
        

    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict =[myDiaryListArray objectAtIndex:indexPath.row];
    MyDairyAddEditViewController *controller =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyDairyAddEdit"];
    controller.diaryData = dict;
    controller.isEdit = false;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma  -mark End



@end
