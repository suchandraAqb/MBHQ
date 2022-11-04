//
//  AddVisionEntryViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 20/03/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddVisionEntryDelegate
-(void) addVisionEntryFromString:(NSString *)text;
@end
@interface AddVisionEntryViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *visionBoardDict;     //aha
@property (weak, nonatomic) id<AddVisionEntryDelegate>addVisionEntryDelegate;
@end
