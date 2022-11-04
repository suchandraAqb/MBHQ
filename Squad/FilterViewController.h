//
//  FilterViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 21/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
@protocol FilterViewDelegate <NSObject>
@optional - (void) didSelectAnyFilterOption:(NSString *)type data:(NSDictionary *)data;
@optional - (void) didCancelFilterOption;

@end
@interface FilterViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id<FilterViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic,strong)UIButton* sender;
@property (strong, nonatomic)  NSArray *filterDataArray;
@property (nonatomic)  int selectedIndex;
@property (nonatomic,strong)NSString * mainKey;
@property (nonatomic,strong)NSString * subKey;
@property (nonatomic,strong)NSString * apiType;



@end
