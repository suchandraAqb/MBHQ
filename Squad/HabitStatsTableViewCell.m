//
//  HabitStatsTableViewCell.m
//  Squad
//
//  Created by Suchandra Bhattacharya on 24/12/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "HabitStatsTableViewCell.h"
#import "HabitMonthlyCollectionViewCell.h"
#import "HabitStateDetailsViewController.h"
@implementation HabitStatsTableViewCell{
     IBOutlet UICollectionView *collectinView;
     IBOutlet UIView *calenderView;
     NSArray *monthArr;
     NSInteger count;
     NSInteger index;
     int indexValue;
     BOOL isTrue;
     NSArray *weekDayarr;
     NSArray *habitArr;
     int rowNumber;
     int currentmonth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    count=1;
    isTrue = false;
    weekDayarr = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd EEE"];
    NSDate *date=[dateFormatter dateFromString:monthArr[0]];
    NSDateFormatter *dt = [[NSDateFormatter alloc]init];
    [dt setDateFormat:@"EEE"];
    NSString *dayStr = [ dt stringFromDate:date];
    if ([weekDayarr containsObject:dayStr]) {
        index = (int)[weekDayarr indexOfObject:dayStr];
    }
    [collectinView addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];

}
-(void)setUpView:(NSArray*)arr indexValue:(int)index with:(nonnull NSArray *)habitArray with:(int)currentMonth{
    monthArr = [arr mutableCopy];
    habitArr = [habitArray mutableCopy];
    rowNumber = index;
    indexValue = index;
    currentmonth = currentMonth;
    if (![Utility isEmptyCheck:monthArr] && monthArr.count>0) {
             [collectinView reloadData];
        }
    }

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    //Whatever you do here when the reloadData finished
    float newHeight = collectinView.contentSize.height;
    _collectionHeightConstant.constant=newHeight;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return monthArr.count+index;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HabitMonthlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HabitMonthlyCollectionViewCell" forIndexPath:indexPath];
    cell.dateButton.layer.cornerRadius = cell.dateButton.frame.size.height/2;
    cell.dateButton.layer.masksToBounds = YES;
    cell.dateButton.clipsToBounds = YES;
    cell.dateButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",indexValue];

    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd EEE"];
    NSDateFormatter *dt1 = [NSDateFormatter new];
    [dt1 setDateFormat:@"dd"];
    
   NSDateFormatter *dt2 = [NSDateFormatter new];
   [dt2 setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateTaken;
    
    if (index == indexPath.row) {
        isTrue = true;
        NSDate *date1=[dateFormatter1 dateFromString:[monthArr objectAtIndex:0]];
        dateTaken = date1;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TaskDateString = %@)",[@"" stringByAppendingFormat:@"%@",[dt2 stringFromDate:date1]]];
        NSArray *filterArr = [habitArr filteredArrayUsingPredicate:predicate];
        if (filterArr.count>0) {
            if ([date1 isLaterThan:[NSDate date]]) {
                 cell.dateButton.userInteractionEnabled = false;
                 cell.dateButton.layer.opacity = 0.5;
             }else{
                 cell.dateButton.userInteractionEnabled = true;
                 cell.dateButton.layer.opacity = 1;
             }
            if(filterArr.count == 2){
                 NSDictionary *filterDict1 = [filterArr objectAtIndex:0];
                 NSDictionary *filterDict2 = [filterArr objectAtIndex:1];
                if (![Utility isEmptyCheck:filterDict1] && ![Utility isEmptyCheck:filterDict2]) {
                    if ([[filterDict1 objectForKey:@"IsDone"]boolValue] && [[filterDict2 objectForKey:@"IsDone"]boolValue]) {
                        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];

                        if (rowNumber == 0) {
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_check_hacker.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];

                        }
                    }else if (([[filterDict1 objectForKey:@"IsDone"]boolValue] || [[filterDict2 objectForKey:@"IsDone"]boolValue])){
                        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];

                        if (rowNumber == 0) {
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle_state.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle_grey_state.png"] forState:UIControlStateNormal];

                        }
                    }else{
                        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                        if (rowNumber == 0) {
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_hacker.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_grey.png"] forState:UIControlStateNormal];

                        }
                    }
                }
            }else{
                NSDictionary *filterDict = [filterArr objectAtIndex:0];
                       
                         if (![Utility isEmptyCheck:filterDict] && [[filterDict objectForKey:@"IsDone"]boolValue]) {
                             [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                             if (rowNumber == 0) {
                                 [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_check_hacker.png"] forState:UIControlStateNormal];
                             }else{
                                 [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];

                             }
                         }else{
                             [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                             if (rowNumber == 0) {
                                 [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_hacker.png"] forState:UIControlStateNormal];
                             }else{
                                 [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_grey.png"] forState:UIControlStateNormal];

                             }
                         }
                }
        }else{
            cell.dateButton.layer.opacity = 1;
            cell.dateButton.userInteractionEnabled = false;
            [cell.dateButton setBackgroundImage:nil forState:UIControlStateNormal];
            [cell.dateButton setTitle:[dt1 stringFromDate:date1] forState:UIControlStateNormal];
        }
    }else{
        if (isTrue) {
            NSDate *date1=[dateFormatter1 dateFromString:[monthArr objectAtIndex:count++]];
            dateTaken = date1;
            if ([date1 isLaterThan:[NSDate date]]) {
                cell.dateButton.userInteractionEnabled = false;
                cell.dateButton.layer.opacity = 0.5;
            }else{
                cell.dateButton.userInteractionEnabled = true;
                cell.dateButton.layer.opacity = 1;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(TaskDateString = %@)",[@"" stringByAppendingFormat:@"%@",[dt2 stringFromDate:date1]]];
            NSArray *filterArr = [habitArr filteredArrayUsingPredicate:predicate];
            if (filterArr.count>0) {
                if ([date1 isLaterThan:[NSDate date]]) {
                    cell.dateButton.userInteractionEnabled = false;
                    cell.dateButton.layer.opacity = 0.5;
                }else{
                    cell.dateButton.userInteractionEnabled = true;
                    cell.dateButton.layer.opacity = 1;
                }
                if(filterArr.count == 2){
                    NSDictionary *filterDict1 = [filterArr objectAtIndex:0];
                    NSDictionary *filterDict2 = [filterArr objectAtIndex:1];
                   if (![Utility isEmptyCheck:filterDict1] && ![Utility isEmptyCheck:filterDict2]) {
                       if ([[filterDict1 objectForKey:@"IsDone"]boolValue] && [[filterDict2 objectForKey:@"IsDone"]boolValue]) {
                           [cell.dateButton setTitle:@"" forState:UIControlStateNormal];

                           if (rowNumber == 0) {
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_check_hacker.png"] forState:UIControlStateNormal];
                           }else{
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];

                           }
                       }else if (([[filterDict1 objectForKey:@"IsDone"]boolValue] || [[filterDict2 objectForKey:@"IsDone"]boolValue])){
                           [cell.dateButton setTitle:@"" forState:UIControlStateNormal];

                           if (rowNumber == 0) {
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle_state.png"] forState:UIControlStateNormal];
                           }else{
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle_grey_state.png"] forState:UIControlStateNormal];

                           }
                       }else{
                           [cell.dateButton setTitle:@"" forState:UIControlStateNormal];

                           if (rowNumber == 0) {
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_hacker.png"] forState:UIControlStateNormal];
                           }else{
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_grey.png"] forState:UIControlStateNormal];

                           }
                       }
                   }
                }else{
                      NSDictionary *filterDict = [filterArr objectAtIndex:0];
                      if (![Utility isEmptyCheck:filterDict] && [[filterDict objectForKey:@"IsDone"]boolValue]) {
                            [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                             if (rowNumber == 0) {
                                 [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_check_hacker.png"] forState:UIControlStateNormal];
                                }else{
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"greycross.png"] forState:UIControlStateNormal];
                                 }
                        }else{
                            [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                            if (rowNumber == 0) {
                             [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_hacker.png"] forState:UIControlStateNormal];
                             }else{
                               [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"ok_uncheck_grey.png"] forState:UIControlStateNormal];
                             }
                        }
                }
            } else{
                cell.dateButton.userInteractionEnabled = false;
                cell.dateButton.layer.opacity = 1;
                [cell.dateButton setBackgroundImage:nil forState:UIControlStateNormal];
                [cell.dateButton setTitle:[dt1 stringFromDate:date1] forState:UIControlStateNormal];
            }
           
        }else{
            count = 1;
           
            cell.dateButton.layer.opacity = 1;
            cell.dateButton.userInteractionEnabled = false;
            [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
            [cell.dateButton setBackgroundImage:nil forState:UIControlStateNormal];

        }
    }
    if (!([dateTaken month] == currentmonth)){
            cell.dateButton.layer.opacity = 0.5;
        }else{
            cell.dateButton.layer.opacity = 1;
        }
    cell.dateButton.tag = count;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGRect screenRect = [calenderView bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat divisor;
    if ([UIScreen mainScreen].bounds.size.width>=414) {
        divisor = 10.0;
    }else{
        divisor = 9.0;
    }
    float cellWidth = screenWidth / divisor; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth,50);

    return size;
}


@end
