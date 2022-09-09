//
//  ShoppingCartPopUpViewController.h
//  Squad
//
//  Created by aqbsol iPhone on 08/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShoppingCartPopUpViewControllerDelegate <NSObject>

@optional -(void)collectionCartSelected:(int)numberOfMeal index:(NSIndexPath *)indexPath;
@optional - (void)saveCartPressed:(int)numberOfMeal index:(NSIndexPath *)indexPath;
@optional -(void)cancelPressed:(int)oldNoOfMeal index:(NSIndexPath *)indexPath;

@end
@interface ShoppingCartPopUpViewController : UIViewController{
    id<ShoppingCartPopUpViewControllerDelegate>delegate;
}

@property (nonatomic,strong)id delegate;
@property (nonatomic) int top;
@property (nonatomic) int noOfServe;
@property (nonatomic) NSIndexPath *indexPath;
@property (nonatomic) NSString *from;

@end
