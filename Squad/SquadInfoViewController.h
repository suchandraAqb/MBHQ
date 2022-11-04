//
//  SquadInfoViewController.h
//  Squad
//
//  Created by AQB Solutions Private Limited on 28/05/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExerciseDailyListViewController.h"
#import "NotesViewController.h"
@interface SquadInfoViewController : UIViewController<UIScrollViewDelegate,NotesViewDeleagte>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *pageImages;
@end
