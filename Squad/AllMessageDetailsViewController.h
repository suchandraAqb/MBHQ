//
//  AllMessageDetailsViewController.h
//  Squad
//
//  Created by Suchandra Bhattacharya on 24/06/2019.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AllMessageDetailsViewDelegate <NSObject>
@optional - (void) didCheckAnyChange:(BOOL)ischanged;
@end
NS_ASSUME_NONNULL_BEGIN

@interface AllMessageDetailsViewController : UIViewController{
    id<AllMessageDetailsViewDelegate>allmessageDelegate;
}
@property (strong,nonatomic)id allmessageDelegate;
@property (strong,nonatomic) NSDictionary *messageDetailsDict;
@end

NS_ASSUME_NONNULL_END
