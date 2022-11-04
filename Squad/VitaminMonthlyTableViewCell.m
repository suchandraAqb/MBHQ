//
//  VitaminMonthlyTableViewCell.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 19/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import "VitaminMonthlyTableViewCell.h"
#import "VitaminMonthlyCollectionViewCell.h"
@implementation VitaminMonthlyTableViewCell{
    IBOutlet UICollectionView *collectinView;
    NSArray *monthArr;
    NSArray *weekDayarr;
    NSArray *vitaminDetailsArr;
    NSInteger count;
    NSInteger index;
    int indexValue;
    BOOL isTrue;
    NSDate *date1;
    NSString *dayStr1;

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
    [collectinView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld context:NULL];

}
-(void)setUpView:(NSArray*)arr vitaminArr:(NSArray*)vitaminArr indexValue:(int)index{
    monthArr = [arr mutableCopy];
    indexValue = index;
    vitaminDetailsArr = [vitaminArr mutableCopy];
    if (![Utility isEmptyCheck:monthArr] && monthArr.count>0) {
         [collectinView reloadData];
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(NSString *)strFromDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];//yyyy-MM-dd'T'HH:mm:ss
    NSString *str =[formatter stringFromDate:date];
    NSString *dateStr = [@"" stringByAppendingFormat:@"%@T00:00:00",str];
    return dateStr;
}
-(int)getPercerntageOfDone:(int)doneCount total:(int)totalCount{
    if (doneCount == 0 && totalCount == 0) {
        return 0;
    }else{
        return (100 * doneCount)/totalCount;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary  *)change context:(void *)context
{
    //Whatever you do here when the reloadData finished
    float newHeight = collectinView.contentSize.height;
    self.collectionHeightConstant.constant=newHeight;
}
#pragma mark - CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (monthArr.count+index);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VitaminMonthlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VitaminMonthlyCollectionViewCell" forIndexPath:indexPath];
    cell.dateButton.layer.cornerRadius = cell.dateButton.frame.size.height/2;
    cell.dateButton.layer.masksToBounds = YES;
    cell.dateButton.clipsToBounds = YES;
    
    cell.dateButton.accessibilityHint = [@"" stringByAppendingFormat:@"%d",indexValue];
    NSDateFormatter *dateFormatter1 = [NSDateFormatter new];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd EEE"];

    if (index == indexPath.row) {
        isTrue = true;
        date1=[dateFormatter1 dateFromString:[monthArr objectAtIndex:0]];
        NSDateFormatter *dt1 = [NSDateFormatter new];
        [dt1 setDateFormat:@"dd"];
        dayStr1 = [dt1 stringFromDate:date1];
        
        NSDateFormatter *dt2 = [NSDateFormatter new];
        [dt2 setDateFormat:@"yyyy-MM-dd"];
        NSString *dayStr2 = [ dt2 stringFromDate:date1];
        
        if ([dayStr2 isEqualToString:[dt2 stringFromDate:[NSDate date]]]) {
            if (![Utility isEmptyCheck:vitaminDetailsArr] && vitaminDetailsArr.count>0) {
                NSArray *filteredTodayArr = [vitaminDetailsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)", [self strFromDate:[NSDate date]]]];
                if (filteredTodayArr.count>0) {
                    [cell.dateButton setUserInteractionEnabled:YES];

                    NSDictionary *individualVitaminDetailsDict = [filteredTodayArr objectAtIndex:0];
                    if ([[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue]==0) {
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_pink_circle.png"] forState:UIControlStateNormal];//sL_uncheck.png

                    }else if ([[individualVitaminDetailsDict objectForKey:@"PendingCount"]intValue]==0){
                        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                    }else{
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                        
                        if ([[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]==2) {
                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                            if (totalComplete>=10 && totalComplete<100) {
                                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                            }
                        }else{
                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                            if (totalComplete>=10 && totalComplete<=50) {
                                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                            }else if ((totalComplete>=50 && totalComplete<100)){
                                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                            }
                        }
                    }
                }else{
                    [cell.dateButton setUserInteractionEnabled:NO];
                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                    [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                }
            }else{
                [cell.dateButton setUserInteractionEnabled:NO];
                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
            }
        }else{
            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];

            NSArray *filterMonthArr = [vitaminDetailsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)",[@"" stringByAppendingFormat:@"%@T00:00:00",dayStr2]]];
            if (![Utility isEmptyCheck:vitaminDetailsArr] && vitaminDetailsArr.count>0) {
                if (filterMonthArr.count>0) {
                    [cell.dateButton setUserInteractionEnabled:YES];

                    NSDictionary *individualVitaminDetailsDict = [filterMonthArr objectAtIndex:0];
    
                    if ([[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue]==0) {
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];

    
                    }else if ([[individualVitaminDetailsDict objectForKey:@"PendingCount"]intValue]==0){
                        [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                    }else{
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                        
                        if ([[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]==2) {
                            int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                            if (totalComplete>=10 && totalComplete<100) {
                                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                            }
                        }else{
                                int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                                if (totalComplete>=10 && totalComplete<=50) {
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                                }else if ((totalComplete>=50 && totalComplete<100)){
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                                }
                            }
                    }
                }else{
                    [cell.dateButton setUserInteractionEnabled:NO];
                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                    [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                }
            
            }else{
                [cell.dateButton setUserInteractionEnabled:NO];
                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
            }
        }
        
    }else{
        if (isTrue) {
//            NSLog(@"COUNT+++++++++++++++++++++++++%ld",(long)indexPath.row);

                date1=[dateFormatter1 dateFromString:[monthArr objectAtIndex:count++]];
                NSDateFormatter *dt1 = [NSDateFormatter new];
                [dt1 setDateFormat:@"dd"];
                dayStr1 = [ dt1 stringFromDate:date1];
            
                NSDateFormatter *dt2 = [NSDateFormatter new];
                [dt2 setDateFormat:@"yyyy-MM-dd"];
                NSString *dayStr2 = [ dt2 stringFromDate:date1];
            
            if ([dayStr2 isEqualToString:[dt2 stringFromDate:[NSDate date]]]) {
                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_pink_circle.png"] forState:UIControlStateNormal];//sL_uncheck.png

                if (![Utility isEmptyCheck:vitaminDetailsArr] && vitaminDetailsArr.count>0) {
                    NSArray *filteredTodayArr = [vitaminDetailsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)", [self strFromDate:[NSDate date]]]];
                    if (filteredTodayArr.count>0) {
                        [cell.dateButton setUserInteractionEnabled:YES];

                        NSDictionary *individualVitaminDetailsDict = [filteredTodayArr objectAtIndex:0];
                        if ([[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue]==0) {
                            [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_pink_circle.png"] forState:UIControlStateNormal];//sL_uncheck.png
                            
                        }else if ([[individualVitaminDetailsDict objectForKey:@"PendingCount"]intValue]==0){
                            [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                            if ([[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]==2) {
                                int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                                if (totalComplete>=10 && totalComplete<100) {
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                                }
                            }else{
                                    int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                                    if (totalComplete>=10 && totalComplete<=50) {
                                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                                    }else if ((totalComplete>=50 && totalComplete<100)){
                                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                                    }
                                }
                        }
                    }else{
                        [cell.dateButton setUserInteractionEnabled:NO];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                    }
                }else{
                    [cell.dateButton setUserInteractionEnabled:NO];
                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                    [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                }
            }else{
                [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                
                NSArray *filterMonthArr = [vitaminDetailsArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(TaskDate == %@)",[@"" stringByAppendingFormat:@"%@T00:00:00",dayStr2]]];
                
                if (![Utility isEmptyCheck:vitaminDetailsArr] && vitaminDetailsArr.count>0) {
                    if (filterMonthArr.count>0) {
                        [cell.dateButton setUserInteractionEnabled:YES];

                        NSDictionary *individualVitaminDetailsDict = [filterMonthArr objectAtIndex:0];
                        
                        if ([[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue]==0) {
                            [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];
                            
                            
                        }else if ([[individualVitaminDetailsDict objectForKey:@"PendingCount"]intValue]==0){
                            [cell.dateButton setTitle:@"" forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"vitamin_tick_big.png"] forState:UIControlStateNormal];
                        }else{
                            [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_darkcircle.png"] forState:UIControlStateNormal];

                            if ([[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]==2) {
                                int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                                if (totalComplete>=10 && totalComplete<100) {
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"half_circle.png"] forState:UIControlStateNormal];
                                }
                            }else{
                                int totalComplete = [self getPercerntageOfDone:[[individualVitaminDetailsDict objectForKey:@"DoneCount"]intValue] total:[[individualVitaminDetailsDict objectForKey:@"TotalCount"]intValue]];
                                if (totalComplete>=10 && totalComplete<=50) {
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"1of3rd.png"] forState:UIControlStateNormal];
                                }else if ((totalComplete>=50 && totalComplete<100)){
                                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"2of3rd.png"] forState:UIControlStateNormal];
                                }
                            }
                        }
                    }else{
                        [cell.dateButton setUserInteractionEnabled:NO];
                        [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                        [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                    }
                    
                }else{
                    [cell.dateButton setUserInteractionEnabled:NO];
                    [cell.dateButton setBackgroundImage:[UIImage imageNamed:@"Vitamin_lightcircle.png"] forState:UIControlStateNormal];
                    [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
                }
            }
        }
        else{
            dayStr1=@"";
            isTrue=false;
            count=1;
            [cell.dateButton setUserInteractionEnabled:NO];
            [cell.dateButton setTitle:dayStr1 forState:UIControlStateNormal];
            [cell.dateButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

        }
        
    }
    cell.dateButton.tag =count ;
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat divisor = 9.0;
    float cellWidth = screenWidth / divisor; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(cellWidth,50);
    
    return size;
}

@end
