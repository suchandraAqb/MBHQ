//
//  MyPhotosViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 15/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddImageViewController.h"

typedef enum : NSInteger {
    Front = 1,
    Side,
    Back,
    Final = 5
} BodyCategoryID;


@interface MyPhotosViewController : UIViewController <AddPhotoDelegate> //ah 22.3

@end
