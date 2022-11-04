//
//  EditSessionViewController.h
//  ABBBCOnline
//
//  Created by AQB Mac 4 on 25/11/16.
//  Copyright © 2016 Aqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditSessionViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) NSMutableDictionary *sessionData;
@property (nonatomic) int weekNumber;
@property (nonatomic) int day;
@property (nonatomic) bool isEdit;
@property (strong, nonatomic) NSString *startDate;

@end
