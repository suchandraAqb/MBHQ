//
//  FilterViewController.m
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"

@interface FilterViewController (){
    
    IBOutlet UITableView *table;
    IBOutlet UIButton *cancelButton;
}

@end

@implementation FilterViewController
@synthesize filterDataArray,selectedIndex,delegate,mainKey,subKey,apiType;

- (void)viewDidLoad {
    [super viewDidLoad];
    cancelButton.layer.cornerRadius = 4;
    cancelButton.clipsToBounds = YES;
    table.layer.cornerRadius = 4;
    table.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView Datasource & Delegates

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return filterDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier =@"FilterTableViewCell";
    FilterTableViewCell *cell = (FilterTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *dict = [filterDataArray objectAtIndex:indexPath.row];
    if (![Utility isEmptyCheck:mainKey]) {
        id filterName = [dict valueForKey:mainKey];
        if (![Utility isEmptyCheck:filterName]) {
            if ([filterName isKindOfClass:[NSString class]]) {
                cell.filterName.text = filterName;
                
            }else if([filterName isKindOfClass:[NSNumber class]]){
                cell.filterName.text = [filterName stringValue];
            }
        }
    }
    
    if (![Utility isEmptyCheck:subKey]) {
        
        id filterMoreInfo = [dict valueForKey:subKey];
        if (![Utility isEmptyCheck:filterMoreInfo]) {
            if ([filterMoreInfo isKindOfClass:[NSString class]]) {
                cell.filterMoreInfo.text = filterMoreInfo;

            }else if([filterMoreInfo isKindOfClass:[NSNumber class]]){
                cell.filterMoreInfo.text = [filterMoreInfo stringValue];
            }
            
        }
    }
    
    if (selectedIndex > -1 && selectedIndex == indexPath.row) {
        cell.checkButton.selected = YES;
    }else{
        cell.checkButton.selected = false;
    }
    cell.checkButton.tag = (int) indexPath.row;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedIndex = (int) indexPath.row;
        NSDictionary *dict = [filterDataArray objectAtIndex:selectedIndex];
        [tableView reloadData];
        [table reloadData];
        if ([delegate respondsToSelector:@selector(didSelectAnyFilterOption:data:)]) {
            [delegate didSelectAnyFilterOption:apiType data:dict];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
#pragma mark -IBAction
- (IBAction)checkUncheckButtonPressed:(UIButton *)sender1{
    dispatch_async(dispatch_get_main_queue(), ^{
        selectedIndex = (int) sender1.tag;
        NSDictionary *dict = [filterDataArray objectAtIndex:selectedIndex];
        [table reloadData];
        if ([delegate respondsToSelector:@selector(didSelectAnyFilterOption:data:)]) {
            [delegate didSelectAnyFilterOption:apiType data:dict];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
}
- (IBAction)cancelButtonPressed:(UIButton *)sender1 {
    if ([delegate respondsToSelector:@selector(didCancelFilterOption)]) {
        [delegate didCancelFilterOption];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -End

@end
