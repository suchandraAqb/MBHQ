//
//  SettingsPickersViewController.h
//  Ashy Bines Super Circuit
//
//  Created by AQB SOLUTIONS on 01/11/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingsCustomPickerDelegate

-(void) updateSettingsCustomPickerValue:(NSString *)key withValue:(NSString *)pickerValue;

@end

@interface SettingsPickersViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) id<SettingsCustomPickerDelegate>settingsCustomPickerDelegate;
@property (strong, nonatomic) NSArray *pickerArray;
@property (weak, nonatomic) NSString *titleName;
@property (assign) NSInteger selectRow;
@property (weak,nonatomic) NSString *key;

@end
