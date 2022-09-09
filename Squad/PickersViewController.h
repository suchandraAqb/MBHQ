//
//  PickersViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 09/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomPickerDelegate

-(void) updateCustomPickerValue:(NSString *)customPickerValue ofButton:(NSInteger)buttonTag withAccessibilityHint:(NSString *)accessibilityHint;

@end

@interface PickersViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) id<CustomPickerDelegate>customPickerDelegate;
@property () NSInteger buttonTag;
@property (weak, nonatomic) NSString *btnAccessibilityHint;
@property (weak, nonatomic) NSMutableArray *exerciseNameArray;
@property (weak, nonatomic) NSArray *circuitArray;
@property (weak, nonatomic) NSString *prevVal;
@end
