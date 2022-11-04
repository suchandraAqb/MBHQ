//
//  BlankListViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 03/05/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterMenuViewController.h"
#import "Utility.h"
#import "DropdownViewController.h"
#import "AddEditBlankListViewController.h"

@interface BlankListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,DropdownViewDelegate,AddEditBlankListViewControllerDelegate>

@end
