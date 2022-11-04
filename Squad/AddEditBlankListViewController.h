//
//  AddEditBlankListViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "Utility.h"
@protocol AddEditBlankListViewControllerDelegate <NSObject>
    @optional - (void) didDismiss;
@end

@interface AddEditBlankListViewController : UIViewController<UITextViewDelegate,DatePickerViewControllerDelegate>{
    id<AddEditBlankListViewControllerDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong, nonatomic)  NSDictionary *blankData;

@end

