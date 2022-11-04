//
//  AddVitaminViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 15/03/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol AddVitaminViewDelegate <NSObject>
-(void)addDataReload;
@end

@interface AddVitaminViewController : UIViewController<DropdownViewDelegate>{
    id<AddVitaminViewDelegate>addVitaminDelegate;
}
@property (strong,nonatomic) id addVitaminDelegate;
@property BOOL isFromEdit;
@property int userVitaminId;
@property BOOL isFromNotification;
@end

NS_ASSUME_NONNULL_END
