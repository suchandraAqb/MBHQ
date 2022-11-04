//
//  AdvanceSearchViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 08/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "DropdownViewController.h"
@protocol AdvanceSearchDelegate <NSObject>
@optional - (void) applyFilter:(NSDictionary *)data;
@optional - (void) dismissFromAdvancesearch;
@end
@interface AdvanceSearchViewController : UIViewController<UITextFieldDelegate,DropdownViewDelegate>{
    id<AdvanceSearchDelegate>delegate;
}
@property (nonatomic,strong)id delegate;

@end
