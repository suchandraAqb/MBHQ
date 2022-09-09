//
//  AdvanceSearchForSessionViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownViewController.h"
@protocol AdvanceSearchForSessionDelegate <NSObject>
@optional - (void) applyForSesionFilter:(NSDictionary *)data ischange:(BOOL)ischanged;
@optional -(void)dismissFromAdvanceSearch:(BOOL)ischanged;
@optional -(void)isGotoHome:(BOOL)isBack;
@end

@interface AdvanceSearchForSessionViewController : UIViewController<UITextFieldDelegate,DropdownViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    id<AdvanceSearchForSessionDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (atomic,strong)NSMutableDictionary *savedFilter;
@property() BOOL isFromSessionList;
@property BOOL isMySession;
@end


