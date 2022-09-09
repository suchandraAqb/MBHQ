//
//  AddWeightDataView.h
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 24/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//
#import "WeightRecordTableViewCell.h"
#import <UIKit/UIKit.h>

@protocol AddWeightDataViewDelegate
-(void)textFieldBeginEditing:(WeightRecordTableViewCell *)cell keyboardSize:(CGSize)size;
-(void)deleteSet:(NSDictionary *)dict cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow ofIndex:(NSInteger)index;
-(void)updateWeightData:(NSDictionary *)dict ofIndex:(NSInteger)index cellSection:(NSInteger)cellSection cellRow:(NSInteger)cellRow;
@end

@interface AddWeightDataView : UIView<UITextFieldDelegate>{
    id<AddWeightDataViewDelegate>AddWeightDataDelegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic) IBOutlet UILabel *setCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *setDeleteButton;
@property (strong, nonatomic) IBOutlet UITextField *weightTextField;
@property (strong, nonatomic) IBOutlet UITextField *repsTextField;
@property (strong, nonatomic) IBOutlet UILabel *repsGoalLabel;
@property (strong, nonatomic)UITableView *weightTable;
@property (strong, nonatomic)WeightRecordTableViewCell *cell;
@property (nonatomic)NSInteger cellSection;
@property (nonatomic)NSInteger cellRow;
@property (strong, nonatomic)IBOutlet UIScrollView *mainScroll;
+(AddWeightDataView *)instantiateView;
-(void)updateView:(NSArray *)dataArray withIndex:(NSInteger)index;
@end


