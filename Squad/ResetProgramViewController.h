//
//  ResetProgramViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 03/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ResetProgramViewDelegate <NSObject>
@optional - (void) didPerformRevertOption;
//@optional - (void) didCancelRevertOption;

@end
@interface ResetProgramViewController : UIViewController{
    id<ResetProgramViewDelegate>delegate;
}

@property (strong,nonatomic) NSString *programIdStr;
@property (strong,nonatomic) NSString *userprogramIdStr;
@property (strong,nonatomic) NSString *weekStartDayStr;
@property (strong,nonatomic) NSString *option;
@property (nonatomic,strong)id delegate;

@end
