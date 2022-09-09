//
//  AdvanceSearchForCircuitListViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 13/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DropdownViewController.h"
@protocol AdvanceSearchForCircuitDelegate <NSObject>
@optional - (void) applyForCircuitFilter:(NSDictionary *)data;
@end

@interface AdvanceSearchForCircuitListViewController : UIViewController<UITextFieldDelegate,DropdownViewDelegate>{
    id<AdvanceSearchForCircuitDelegate>delegate;
}
@property (nonatomic,strong)id delegate;

@end

