//
//  AddDetailsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 21/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "DropdownViewController.h"

@interface AddDetailsViewController : UIViewController<DatePickerViewControllerDelegate,DropdownViewDelegate>
@property (nonatomic, strong)  NSArray *selectedFields;
@property (nonatomic, strong)  NSString *type;
@property (nonatomic, strong)  NSMutableDictionary *dataDict;

@property (nonatomic) double prevWeight; //add_su_2/8/17


@end
