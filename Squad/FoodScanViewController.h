//
//  FoodScanViewController.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 08/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTBBarcodeScanner.h"
@protocol foodScanDelegate<NSObject>
@optional -(void)foodScanData:(NSDictionary *)foodDict;
@end

@interface FoodScanViewController : UIViewController{
    id<foodScanDelegate>delegate;
}

@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) NSDate *currentDate;
@end
