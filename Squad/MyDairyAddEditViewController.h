//
//  MyDairyAddEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "DatePickerViewController.h"
#import "NewMyDiaryAddEdit.h"

@interface MyDairyAddEditViewController : UIViewController<DatePickerViewControllerDelegate,UIWebViewDelegate,UINavigationControllerDelegate,NewMyDiaryAddEditDelegate>
@property (strong, nonatomic) NSDictionary *diaryData;
@property (nonatomic)bool isEdit;
@property (nonatomic, strong) NewMyDiaryAddEdit *editor;


@end
