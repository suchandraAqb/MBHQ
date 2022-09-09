//
//  PopularHabitListViewController.m
//  Squad
//
//  Created by Dhiman on 13/10/20.
//  Copyright © 2020 AQB Solutions. All rights reserved.
//

#import "PopularHabitListViewController.h"
#import "TableViewCell.h"
#import "PopularHabitSectionViewController.h"
@interface PopularHabitListViewController ()
{
    UIView *contentView;
    IBOutlet UITableView *popularHabitTable;
    IBOutlet UIView *filterView;
    IBOutletCollection(UIButton) NSArray *checkUncheckButton;
    IBOutlet UIButton *filterButton;
    IBOutlet UITextField *searchText;
    NSArray *habitTemplatesArray;
    NSArray *mainHabitTemplateArray;
    UIToolbar *toolBar;
}
@end

@implementation PopularHabitListViewController

#pragma Mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"PopularHabitSectionViewController" bundle:nil];
    [popularHabitTable registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:@"PopularHabitSectionViewController"];
    popularHabitTable.estimatedSectionHeaderHeight = 60;
    popularHabitTable.sectionHeaderHeight = UITableViewAutomaticDimension;
    popularHabitTable.estimatedRowHeight = 100;
    popularHabitTable.rowHeight = UITableViewAutomaticDimension;
    filterView.hidden = true;
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    searchText.inputAccessoryView = toolBar;
    searchText.layer.borderWidth = 1;
    searchText.layer.borderColor = squadSubColor.CGColor;
    searchText.layer.cornerRadius = 10.0;
    searchText.layer.masksToBounds = YES;
//    [searchText addTarget:self action:@selector(textValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self getHabitTemplates_WebServiceCall];
}

#pragma mark - End

#pragma mark - IBActions
-(IBAction)checkUncheckButtonPreesed:(UIButton*)sender{
    if (sender.selected) {
        return;
    }
    [defaults setObject:[NSNumber numberWithInt:(int)sender.tag] forKey:@"defaultPopularHabitFrequency"];
    [self filterFrequencyArray:(int)sender.tag];
}
-(IBAction)backPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)filterButtonPressed:(id)sender{
    filterView.hidden = false;
}
-(IBAction)filterCrossPressed:(id)sender{
    filterView.hidden = true;
}
-(IBAction)btnClickedDone:(id)sender{
    [self.view endEditing:YES];
}
#pragma mark - End

#pragma mark - Private Function
-(void)filterFrequencyArray:(int)index{
    if (![Utility isEmptyCheck:[defaults objectForKey:@"defaultPopularHabitFrequency"]]) {
        filterButton.selected = true;
        for (UIButton *buttn in checkUncheckButton) {
            buttn.selected = false;
        }
        UIButton *btn;
        if (index >= 3) {
            btn = checkUncheckButton[index-2];
        }else{
            btn = checkUncheckButton[index-1];
        }
        btn.selected = true;
    }else{
        filterButton.selected = false;
    }
    habitTemplatesArray = [mainHabitTemplateArray mutableCopy];
    if (![Utility isEmptyCheck:habitTemplatesArray]) {
        filterView.hidden = true;
        NSMutableArray *mainArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<habitTemplatesArray.count; i++) {
            NSArray *arr = [habitTemplatesArray[i]objectForKey:@"TemplateDetails"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(HabitFrequencyId == %d)",index];
            NSArray *filterArray = [arr filteredArrayUsingPredicate:predicate];
            if (filterArray.count>0) {
                NSMutableArray *filterfrequencyArr = [[NSMutableArray alloc]init];
                [filterfrequencyArr addObjectsFromArray:filterArray];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                dict = [[habitTemplatesArray objectAtIndex:i]mutableCopy];
                if (![Utility isEmptyCheck:[dict objectForKey:@"TemplateDetails"]]) {
                    NSMutableArray *tempArr = [[dict objectForKey:@"TemplateDetails"]mutableCopy];
                    [tempArr removeAllObjects];
                    [tempArr addObjectsFromArray:filterfrequencyArr];
                    [dict setObject:tempArr forKey:@"TemplateDetails"];
                    [mainArr addObject:dict];
                }
            }
        }
        if (!(index == 0)) {
            habitTemplatesArray = [mainArr mutableCopy];
        }
        [popularHabitTable reloadData];
    }
}
-(void)filetHabitName:(NSString*)str{
    habitTemplatesArray = [mainHabitTemplateArray mutableCopy];
    if (![Utility isEmptyCheck:habitTemplatesArray]) {
        filterView.hidden = true;
        NSMutableArray *mainArr = [[NSMutableArray alloc]init];
        for (int i = 0; i<habitTemplatesArray.count; i++) {
            NSArray *arr = [habitTemplatesArray[i]objectForKey:@"TemplateDetails"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(HabitToCreate CONTAINS[c] %@)",str];
            NSArray *filterArray = [arr filteredArrayUsingPredicate:predicate];
            if (filterArray.count>0) {
                NSMutableArray *filterfrequencyArr = [[NSMutableArray alloc]init];
                [filterfrequencyArr addObjectsFromArray:filterArray];
                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                dict = [[habitTemplatesArray objectAtIndex:i]mutableCopy];
                if (![Utility isEmptyCheck:[dict objectForKey:@"TemplateDetails"]]) {
                    NSMutableArray *tempArr = [[dict objectForKey:@"TemplateDetails"]mutableCopy];
                    [tempArr removeAllObjects];
                    [tempArr addObjectsFromArray:filterfrequencyArr];
                    [dict setObject:tempArr forKey:@"TemplateDetails"];
                    [mainArr addObject:dict];
                }
            }
        }
            habitTemplatesArray = [mainArr mutableCopy];
           [popularHabitTable reloadData];
    }

}
#pragma mark - End

-(void)getHabitTemplates_WebServiceCall{
        if (Utility.reachable) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self->contentView) {
                    [self->contentView removeFromSuperview];
                }
                self->contentView = [Utility activityIndicatorView:self];
            });
            NSURLSession *dailySession = [NSURLSession sharedSession];
            NSError *error;
            NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]init];
            
            [mainDict setObject:AccessKey forKey:@"Key"];
            [mainDict setObject:[defaults valueForKey:@"UserSessionID"] forKey:@"UserSessionID"];
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
            if (error) {
                [Utility msg:@"Something went wrong. Please try again later." title:@"Oops" controller:self haveToPop:NO];
                return;
            }
            NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
            NSMutableURLRequest *request = [Utility getRequest:jsonString api:@"GetHabitTemplates" append:@"" forAction:@"POST"];
            NSURLSessionDataTask * dataTask =[dailySession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                 dispatch_async(dispatch_get_main_queue(),^ {
                                                                     if (self->contentView) {
                                                                         [self->contentView removeFromSuperview];
                                                                     }
                                                                     if(error == nil)
                                                                     {
                                                                         NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                         
                                                                         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                             
                                                                         if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDictionary] && [[responseDictionary objectForKey:@"SuccessFlag"]boolValue]) {
                                                                             if (![Utility isEmptyCheck:[responseDictionary objectForKey:@"HabitTemplates"]]) {
                                                                                 
                                                                                 NSArray *tempArr = [responseDictionary objectForKey:@"HabitTemplates"];
                                                                                 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Section == %@)",@"MOST POPULAR"];
                                                                                 NSArray *filterArr = [tempArr filteredArrayUsingPredicate:predicate];
                                                                                 NSMutableArray *arr = [[NSMutableArray alloc]init];
                                                                                 NSMutableArray *arr1 = [[NSMutableArray alloc]init];
                                                                                 arr1 = [tempArr mutableCopy];
                                                                                 int index = 0;
                                                                                 if (filterArr.count>0) {
                                                                                     [arr addObjectsFromArray:filterArr];
                                                                                     index = (int)[tempArr indexOfObject:[filterArr objectAtIndex:0]];
                                                                                 }
                                                                                 [arr1 removeObjectAtIndex:index];
                                                                                 
                                                                                 NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"Section" ascending:YES];
                                                                                 NSArray *sortedArr=[arr1 sortedArrayUsingDescriptors:@[sort]];
                                                                                 [arr addObjectsFromArray:sortedArr];
                                                                                 if (arr.count>0) {
                                                                                     self->habitTemplatesArray = [arr mutableCopy];
                                                                                     self->mainHabitTemplateArray = [self->habitTemplatesArray mutableCopy];

                                                                                 }
                                                                                 if (![Utility isEmptyCheck:[defaults objectForKey:@"defaultPopularHabitFrequency"]]) {
                                                                                    int value =[[defaults objectForKey:@"defaultPopularHabitFrequency"]intValue];
                                                                                    [self filterFrequencyArray:value];
                                                                                 }else{
                                                                                     [self filterFrequencyArray:0];
                                                                                 }
                                                                                 [self->popularHabitTable reloadData];
                                                                             }
                                                                         }else{
                                                                                 [Utility msg:@"Something Went Wrong.Please Try Later." title:@"Error !" controller:self haveToPop:NO];
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

#pragma mark - textField Delegate
-(void)textValueChange:(UITextField *)textField{
    NSLog(@"search for %@", textField.text);
    if(textField.text.length>0){
        [self filetHabitName:textField.text];
    }else{
        habitTemplatesArray=mainHabitTemplateArray;
    }
//    if (![Utility isEmptyCheck:gratitudeListArray]) {
//        noDataLabel.hidden = true;
//    }else{
//        noDataLabel.hidden = false;
//    }
    [popularHabitTable reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)textFieldDidEndEditing:(UITextField *)textField
{
    filterView.hidden = true;
    if(textField.text.length>0){
        [self filetHabitName:textField.text];
    }else{
        habitTemplatesArray=mainHabitTemplateArray;
    }
//    if (![Utility isEmptyCheck:habitTemplatesArray]) {
//        noDataLabel.hidden = true;
//    }else{
//        noDataLabel.hidden = false;
//    }
    [popularHabitTable reloadData];
    [textField resignFirstResponder];
}
#pragma mark - End
#pragma mark - Table View Delegate & DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return habitTemplatesArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (![Utility isEmptyCheck:[habitTemplatesArray objectAtIndex:section]]) {
        NSArray *templateArr = [[habitTemplatesArray objectAtIndex:section]objectForKey:@"TemplateDetails"];
        return templateArr.count;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PopularHabitSectionViewController *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"PopularHabitSectionViewController"];
    if (![Utility isEmptyCheck:[habitTemplatesArray objectAtIndex:section]]) {
        NSDictionary *habitTemplateDict = [habitTemplatesArray objectAtIndex:section];
        NSLog(@"%@",[habitTemplateDict objectForKey:@"Section"]);
        sectionHeaderView.templateHabitSectionName.text = [habitTemplateDict objectForKey:@"Section"];
    }
    return sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TableViewCell"];
    if (cell==nil) {
        cell = [[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCell"];
    }
    cell.checkUncheckPopularButton.layer.cornerRadius = 15;
    cell.checkUncheckPopularButton.layer.masksToBounds = YES;
    
    if (![Utility isEmptyCheck:[habitTemplatesArray objectAtIndex:indexPath.section]]) {
        NSArray *templateArr = [[habitTemplatesArray objectAtIndex:indexPath.section]objectForKey:@"TemplateDetails"];
        if (![Utility isEmptyCheck:templateArr]) {
            NSDictionary *dict = [templateArr objectAtIndex:indexPath.row];
            cell.popularHabitLabel.text = [@"" stringByAppendingFormat:@"%@",[dict objectForKey:@"HabitToCreate"]];//[dict objectForKey:@"HabitToBreak"]
            if (![Utility isEmptyCheck:[dict objectForKey:@"ImageUrl"]]) {
                [cell.checkUncheckPopularButton sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"ImageUrl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"gallery_image_loading.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                [cell.checkUncheckPopularButton setImage:[UIImage imageNamed:@"gallery_noimage.png"] forState:UIControlStateNormal];

            }
            cell.checkUncheckPopularButton.tag = indexPath.row;//[[dict objectForKey:@"HabitTemplateId"]intValue];

        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PopularHabitLDetailsViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"PopularHabitLDetails"];
    if (![Utility isEmptyCheck:[habitTemplatesArray objectAtIndex:indexPath.section]]) {
        NSArray *arr = [[habitTemplatesArray objectAtIndex:indexPath.section]objectForKey:@"TemplateDetails"];
        if (![Utility isEmptyCheck:arr]) {
            controller.popularhabitDict = [arr objectAtIndex:indexPath.row];
        }
    }
    controller.parent = self;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:controller animated:YES completion:nil];
}
@end
