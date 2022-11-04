//
//  QuoteViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 12/12/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuoteViewController : UIViewController
@property (strong,nonatomic) NSDictionary *quoteDict;
@property BOOL fromAppDelegate;
@end

NS_ASSUME_NONNULL_END
