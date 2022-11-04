//
//  AddImageViewController.h
//  Squad
//
//  Created by AQB Mac 4 on 15/03/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "PECropViewController.h"
#import "CameraViewController.h"

@protocol AddPhotoDelegate <NSObject>

-(void) didPhotoAdded:(BOOL)isAdded;

@end
//ah newt
@interface AddImageViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate, PECropViewControllerDelegate, DatePickerViewControllerDelegate, CameraDelegate>{
    id<AddPhotoDelegate> addPhotoDelegate;
}
@property(strong,nonatomic) NSString *bodyCatagorystring;
@property (strong, nonatomic) id addPhotoDelegate;
@property (weak, nonatomic) NSArray *existingPhotosArray;
//@property (strong, nonatomic) id delegate;

@end
