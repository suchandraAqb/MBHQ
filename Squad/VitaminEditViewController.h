//
//  VitaminEditViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol vitaminEditViewDelegate <NSObject>
-(void)dataReload;
@end

@interface VitaminEditViewController : UIViewController{
    id<vitaminEditViewDelegate>vitaminEditDelegate;
}
@property (strong,nonatomic)id vitaminEditDelegate;
@property (strong,nonatomic) NSDictionary *editDict;
@end

NS_ASSUME_NONNULL_END
