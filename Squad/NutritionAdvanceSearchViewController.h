//
//  NutritionAdvanceSearchViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 20/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AdvanceSearchViewDelegate <NSObject>
@optional - (void) didSelectSearchOption:(NSMutableDictionary*)searchDict;
@end

@interface NutritionAdvanceSearchViewController : UIViewController{
    id<AdvanceSearchViewDelegate>advanceSearchdelegate;
}

@property (nonatomic,strong)id delegate;
@end
