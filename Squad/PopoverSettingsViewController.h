//
//  PopoverSettingsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 22/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverSettingsViewDelegate <NSObject>
@optional - (void) didSelectAnyOptionWithSender:(UIButton *)sender index:(int)index;
@optional - (void) didSelectAnyOption:(int)settingIndex option:(NSString *)option;
@optional - (void) didCancelOption;

@end
@interface PopoverSettingsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    id<PopoverSettingsViewDelegate>settingsdelegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic,strong)UIButton* sender;

@property (strong, nonatomic)  NSArray *tableDataArray;
@property (nonatomic)  int selectedIndex;
@property (nonatomic)  int settingIndex;


@end
