//
//  DropdownViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@protocol DropdownViewDelegate <NSObject>
@optional - (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data;
@optional - (void) didSelectAnyDropdownOption:(NSString *)type data:(NSDictionary *)data sender:(UIButton *)sender;
@optional - (void) dropdownSelected:(NSString *)selectedValue sender:(UIButton *)sender type:(NSString *)type;
@optional - (void) didCancelDropdownOption;
@optional - (void) didSelectAnyDropdownOptionMultiSelect:(NSString *)type data:(NSDictionary *)data isAdd:(BOOL)isAdd;


//chayan 21/9/2017
@optional - (void) tagSelected:(int)index;
@optional - (void) didSelectAnyDropdownOptionMultiSelect:(NSDictionary *)selectedData isAdd:(BOOL)isAdd;

//chayan 30/10/2017
@optional - (void) tagSelected:(int)index type:(NSString *)type;


@end
@interface DropdownViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id<DropdownViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic,strong)UIButton* sender;
@property (strong, nonatomic)  NSArray *dropdownDataArray;
@property (nonatomic)  int selectedIndex;
@property (nonatomic,strong)NSString * mainKey;
@property (nonatomic,strong)NSString * subKey;
@property (nonatomic,strong)NSString * apiType;
@property (nonatomic,strong)NSArray * selectedIndexes;
@property (nonatomic)BOOL  multiSelect;
@property (nonatomic) BOOL shouldScrollToIndexpath;     //ah edit
@property (assign) BOOL haveMaster;     //ah edit
@property (nonatomic,strong)NSString *userPromptRandom;



@end
