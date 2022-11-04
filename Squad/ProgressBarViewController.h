//
//  ProgressBarViewController.h
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 13/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@protocol progressViewDelegate <NSObject>
@optional - (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict;
@optional - (void) completedWithResponse:(NSString *)responseString responseDict:(NSDictionary *)responseDict from:(NSString*)fromApi;

@optional - (void) completedWithError:(NSError *)error;
@end


@interface ProgressBarViewController : UIViewController<NSURLSessionDelegate,NSURLSessionTaskDelegate>{
    id<progressViewDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (nonatomic,strong) NSString* apiName;
@property (nonatomic,strong) NSString* appendString;
@property (nonatomic,strong) NSString* jsonString;
@property (nonatomic,strong) UIImage* chosenImage;
@property  BOOL isvideo;
@property (nonatomic,strong) NSDictionary *videoDataDict;
//multiple image vision
@property  BOOL isMultiImage;
@property (nonatomic,strong) NSDictionary *imageDataDict;
@property BOOL isFromHeaderForOffline;
@property BOOL isFromtodayGetApiName;
-(void) uploadImage;
@end
