//
//  AchieveViewController.m
//  Squad
//
//  Created by AQB Mac 4 on 27/12/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import "AchieveViewController.h"
#import "AchieveListHeaderView.h"
#import "AchieveListFooterView.h"
#import "AchieveTableViewCell.h"
#import "BucketListViewController.h"
#import "GoalActionView.h"
#import "ActionViewController.h"

@interface AchieveViewController (){
    IBOutlet UITableView *table;
    NSArray *achieveDataArray;
    NSMutableDictionary *selectedSectionDict;
}

@end
static NSString *AchieveListHeaderViewIdentifier = @"AchieveListHeaderView";
static NSString *AchieveListFooterViewIdentifier = @"AchieveListFooterView";

@implementation AchieveViewController

-(void)sizeHeaderToFit{
    UIView *headerView = table.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    float height = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    
    table.tableHeaderView = headerView;
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self sizeHeaderToFit];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selectedSectionDict = [[NSMutableDictionary alloc]init];;
    achieveDataArray = @[@{ @"achieveType" : @"0",
                            @"achieveTypeName" : @"My Goals",
                            @"achieveData" : @[@{
                                                   @"achievementName" : @"Run 20 km.",
                                                   @"achievementDate" : @"10/10/2016",
                                                   @"achievementSubData" : @[@{
                                                                                @"achievementName" : @"Drink Water",
                                                                                },
                                                                                @{
                                                                                 @"achievementName" : @"10 Squat",
                                                                                 },
                                                                             @{
                                                                                 @"achievementName" : @"100 Squat2",
                                                                                 }
                                                                             ]
                                    
                                                   },@{
                                                   @"achievementName" : @"ABCD ABCD",
                                                   @"achievementDate" : @"01/11/2016",
                                                   @"achievementSubData" : @""
                                                   
                                                   }
                                               ]
                            },@{ @"achieveType" : @"1",
                                 @"achieveTypeName" : @"My Action",
                                 @"achieveData" : @[@{
                                                        @"achievementName" : @"Drink Water",
                                                        @"achievementDate" : @"10/10/2016",
                                                        @"achievementSubHeader" : @"Run 20 km.",
                                                        @"achievementSubData" : @[]
                                                        },@{
                                                        @"achievementName" : @"10 Squat",
                                                        @"achievementDate" : @"01/11/2016",
                                                        @"achievementSubHeader" : @"Run 20 km.",
                                                        @"achievementSubData" : @[]
                                                        
                                                        }
                                                    ]
                                 },@{ @"achieveType" : @"2",
                                      @"achieveTypeName" : @"My Bucket list",
                                      @"achieveData" : @[]
                                      },
                         
                    ];
    for (int i=0; i <achieveDataArray.count; i++) {
        [selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:i]];
    }
    table.sectionHeaderHeight = CGFLOAT_MIN;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"AchieveListHeaderView" bundle:nil];
    [table registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:AchieveListHeaderViewIdentifier];
    UINib *sectionFooterNib = [UINib nibWithNibName:@"AchieveListFooterView" bundle:nil];
    [table registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:AchieveListFooterViewIdentifier];
    table.estimatedRowHeight = 50;
    table.rowHeight = UITableViewAutomaticDimension;
    
    table.sectionHeaderHeight = UITableViewAutomaticDimension;
    table.estimatedSectionHeaderHeight = 42;
    
    table.sectionFooterHeight = 50 ;
    table.estimatedSectionFooterHeight = 50;

}
#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        return 0;
    }
    return 50;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AchieveListHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AchieveListHeaderViewIdentifier];
    NSDictionary *circuitDict = [achieveDataArray objectAtIndex:section];
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        sectionHeaderView.collapseButton.selected = YES;
    }else{
        sectionHeaderView.collapseButton.selected = NO;
    }
    sectionHeaderView.collapseButton.tag = section;
    NSString *achieveTypeName = [circuitDict objectForKey:@"achieveTypeName"];
    if (![Utility isEmptyCheck:achieveTypeName]) {
        sectionHeaderView.achieveTypeName.text = [circuitDict objectForKey:@"achieveTypeName"];

    }
    [sectionHeaderView.collapseButton addTarget:self
                                               action:@selector(sectionExpandCollapse:)
                                     forControlEvents:UIControlEventTouchUpInside];
    return  sectionHeaderView;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    AchieveListFooterView *sectionFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:AchieveListFooterViewIdentifier];
    sectionFooterView.tag = section;
    [sectionFooterView.addButton addTarget:self
                                         action:@selector(addButtonPressed:)
                               forControlEvents:UIControlEventTouchUpInside];

    return  sectionFooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![Utility isEmptyCheck:achieveDataArray]) {
        return achieveDataArray.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *achieveTypeDict = [achieveDataArray objectAtIndex:section];
    NSArray *achieveTypeData =[achieveTypeDict valueForKey:@"achieveData"];
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:section]]boolValue]) {
        return 0;
    }else{
        if (![Utility isEmptyCheck:achieveTypeData]) {
            return achieveTypeData.count;
        }
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"AchieveTableViewCell";
    AchieveTableViewCell *cell;
    cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AchieveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *achieveTypeDict = [achieveDataArray objectAtIndex:indexPath.section];
    NSArray *achieveTypeData =[achieveTypeDict valueForKey:@"achieveData"];
    if (![Utility isEmptyCheck:achieveTypeData] && achieveTypeData.count > 0){
        NSDictionary *achieveData = [achieveTypeData objectAtIndex:indexPath.row];
        NSLog(@"%@",achieveData);
        if ([[achieveTypeDict objectForKey:@"achieveType"] intValue] == 1) {
            if (indexPath.row == 0) {
                cell.goalImage.image = [UIImage imageNamed:@"ok.png"];
            }else{
                cell.goalImage.image = [UIImage imageNamed:@"cancel.png"];
            }
        }else{
            cell.goalImage.image = [UIImage imageNamed:@"goal_got.png"];
        }
        if (![Utility isEmptyCheck:[achieveData objectForKey:@"achievementName"]]) {
            cell.goalName.text = [achieveData objectForKey:@"achievementName"];
        }else{
            cell.goalName.text = @"";
        }
        NSString *achievementDate = [achieveData objectForKey:@"achievementDate"];
        if (![Utility isEmptyCheck:achievementDate]) {
            cell.dateButton.hidden = false;
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"dd/MM/yyyy";
            NSDate *date = [formatter dateFromString:achievementDate];
            formatter.dateFormat = @"MMM dd";
            
            [cell.dateButton setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
        }else{
            cell.dateButton.hidden = true;
        }
        if (![Utility isEmptyCheck:[achieveData objectForKey:@"achievementSubHeader"]]) {
            cell.goalSubName.text = [achieveData objectForKey:@"achievementSubHeader"];
            [cell.innerStackView addArrangedSubview:cell.goalSubName];
        }else{
            [cell.innerStackView removeArrangedSubview:cell.goalSubName];
            [cell.goalSubName removeFromSuperview];
        }
        for (UIView * subView in cell.outerStackView.arrangedSubviews) {
            if ([subView isKindOfClass:[GoalActionView class]]) {
                [cell.outerStackView removeArrangedSubview:subView];
                [subView removeFromSuperview];
            }
        }
        NSArray *achievementSubData = [achieveData objectForKey:@"achievementSubData"];
        if (![Utility isEmptyCheck:achievementSubData] && achievementSubData.count > 0) {
            for (NSDictionary *dict in achievementSubData) {
                NSArray *goalActionViewObjects = [[NSBundle mainBundle] loadNibNamed:@"GoalActionView" owner:self options:nil];

                GoalActionView *goalActionView = [goalActionViewObjects objectAtIndex:0];
                goalActionView.goalActionName.text = [dict objectForKey:@"achievementName"];
                [cell.outerStackView addArrangedSubview:goalActionView];
                
            }
        }
        

        
    
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        ActionViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Action"];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        BucketListViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BucketList"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark -End

#pragma mark - IBAction
- (IBAction)homeButtonPressed:(id)sender {
    [self.navigationController  popToRootViewControllerAnimated:YES];
}
- (IBAction)menuButtonPressed:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
    [self.slidingViewController resetTopViewAnimated:YES];
}
- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addButtonPressed:(UIButton *)sender {
}

- (IBAction)sectionExpandCollapse:(UIButton *)sender {
    if ([[selectedSectionDict objectForKey:[NSNumber numberWithInteger:sender.tag]]boolValue]) {
        [selectedSectionDict setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:sender.tag]];
    }else{
        [selectedSectionDict setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:sender.tag]];
    }

    [UIView animateWithDuration:0.9f delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        if (sender.isSelected) {
            sender.selected = NO;
        }else{
            sender.selected = YES;
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [table reloadData];
            [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:NSNotFound inSection:sender.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
