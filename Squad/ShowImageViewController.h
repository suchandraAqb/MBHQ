//
//  ShowImageViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 24/05/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShowImageViewDelegate<NSObject>
@optional -(void)didCheckAnyChangeForShowImage:(BOOL)ischanged;
@end

@interface ShowImageViewController : UIViewController{
    id<ShowImageViewDelegate>delegate;
}
@property (strong,nonatomic) id delegate;
@property (strong, nonatomic) NSString* goodnessName;
@property (strong, nonatomic) NSString* goodnessDate;
@property (strong, nonatomic) UIImage *image;
@end
