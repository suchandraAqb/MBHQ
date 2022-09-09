//
//  PopoverViewController.h
//  The Life
//
//  Created by AQB Mac 4 on 06/09/16.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PopoverViewDelegate <NSObject>
@optional - (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option;
@optional - (void) didCancelOption;

@end
@interface PopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id<PopoverViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic)  NSArray *tableDataArray;
@property (nonatomic)  int selectedIndex;
@property (nonatomic)  int settingIndex;
@property (nonatomic,assign) bool isNutritionDietary;//addon



@end
