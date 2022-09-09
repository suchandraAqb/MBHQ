//
//  MasterMenuViewController.h
//  The Life
//
//  Created by AQB SOLUTIONS on 28/03/2016.
//  Copyright © 2016 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ECSlidingViewController.h"
#import "Utility.h"

@interface MasterMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
}

@property(nonatomic,strong) id delegateMasterMenu;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end
