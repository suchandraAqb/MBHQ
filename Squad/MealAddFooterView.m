//
//  MealAddFooterView.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 12/09/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "MealAddFooterView.h"
#import "MealTypeCollectionViewCell.h"

@implementation MealAddFooterView
    @synthesize typeArray,chooseFromLabel;
    
    - (void)awakeFromNib {
        [super awakeFromNib];
        // Initialization code
        
        UINib *cellNib = [UINib nibWithNibName:@"MealTypeCollectionViewCell" bundle:nil];
        [_mealTypeCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"MealTypeCollectionViewCell"];
//        typeArray = [[NSArray alloc]initWithObjects:@"Squad Recipe List",@"My Recipe List",@"Create a New Recipe",@"Squad Ingredient List",@"My Ingredient List",@"Add New Ingredient", nil ];
        typeArray = [[NSArray alloc]initWithObjects:@"Squad Recipe List",@"Squad Ingredient List",@"My Recipe List",@"My Ingredient List",@"Create a New Recipe",@"Add New Ingredient", nil ];
       
    }

   
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
    
    
#pragma -mark CollectionView Delegate & DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return typeArray.count;
    
}
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MealTypeCollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MealTypeCollectionViewCell" forIndexPath:indexPath];
    
    cell.mealTypeLabel.text = typeArray[indexPath.row];
    
    cell.layer.cornerRadius = 5.0 ;
    cell.clipsToBounds =  YES;
    
    return cell;
}

    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Grid Selected");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"staticMealTypeSelected" object:typeArray[indexPath.row]];
}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat w1 = (CGRectGetWidth(collectionView.frame)-10)/(float)2;
    return CGSizeMake(w1, w1/2);
    
}
@end
