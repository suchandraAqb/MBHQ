//
//  SwapSessionViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 04/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SwapSessionViewDelegate <NSObject>
@optional - (void) swapSessionPressed:(NSDictionary *)data swapDate:(NSString *)swapDate;
@end
@interface SwapSessionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    id<SwapSessionViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic,strong) NSArray *sessionArray;
@property (nonatomic,strong) NSString *swapDate;
@end
