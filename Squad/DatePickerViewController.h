//
//  DatePickerViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DatePickerViewControllerDelegate <NSObject>
@optional - (void) didSelectDate:(NSDate *)date;
@optional - (void) didSelectSeconds:(int)seconds with:(NSDate *)date;
@optional - (void) didSelectDate:(NSDate *)date withSenderObject:(id)sender;
@optional - (void) didSelectDate:(NSDate *)date dateType:(NSString *)dateType;
@optional - (void) didSelectDate:(NSDate *)date withSenderButton:(UIButton *)senderButton;
@end

@interface DatePickerViewController : UIViewController{
    id<DatePickerViewControllerDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSDate *maxDate;
@property (nonatomic) NSDate *minDate;
@property (nonatomic) id sender;
@property (nonatomic,strong) NSString *dateType;
@property BOOL isfromhabit;
@property (nonatomic,strong)UIButton* senderButton;

@end
