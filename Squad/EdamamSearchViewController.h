//
//  EdamamSearchViewController.h
//  Squad
//
//  Created by aqb-mac-mini3 on 25/01/19.
//  Copyright © 2019 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EdamamSearchDelegate<NSObject>
@optional -(void)getSearchedMeal:(NSDictionary *)searchDict requestDict:(NSMutableDictionary *)requestDict;
@end

@interface EdamamSearchViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    id<EdamamSearchDelegate>delegate;
}

@property(nonatomic,strong) id delegate;
@property(nonatomic,strong) NSMutableDictionary *requestDict;

@end
