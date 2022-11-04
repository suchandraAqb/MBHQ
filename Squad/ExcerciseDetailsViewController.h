//
//  ExcerciseDetailsViewController.h
//  ABS Finisher
//
//  Created by AQB Solutions-Mac Mini 2 on 17/05/16.
//  Copyright © 2016 AQB Solutions-Mac Mini 2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "NSString+HTML.h"
#import "DatePickerViewController.h"


@interface ExcerciseDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AVPlayerViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DatePickerViewControllerDelegate>
@property(strong,nonatomic)NSDictionary *excerciseDetailsDict;
@property(strong,nonatomic)NSString *buttontag;
@property(nonatomic, assign) int indexValue;
@property(strong,nonatomic) NSString *mainFinishSquadWowButtonTag;

@end
