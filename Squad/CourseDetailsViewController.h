//
//  CourseDetailsViewController.h
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 23/02/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "MasterMenuViewController.h"
#import "CourseArticleDetailsViewController.h"

@protocol CourseDetailsViewDelegate <NSObject>
@optional - (void)didCheckAnyChangeForCourseList:(BOOL)isreload;
@end
@interface CourseDetailsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,CourseArticleDetailsViewDelegate>{
    id<CourseDetailsViewDelegate>courseDetailsDelegate;
}
@property (nonatomic,strong)id courseDetailsDelegate;
@property (strong, nonatomic)  NSDictionary *courseData;
@property (nonatomic)  BOOL isfirstTime;
@property (nonatomic) BOOL isFromMenu;

@end
