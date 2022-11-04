//
//  SelectCountyCityViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 02/06/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface SelectCountyCityViewController : UIViewController<DropdownViewDelegate>
@property (strong, nonatomic) NSString *fromController;     //ah ux
@end
