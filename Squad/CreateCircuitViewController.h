//
//  CreateCircuitViewController.h
//  Squad
//
//  Created by AQB SOLUTIONS on 02/05/2017.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditCircuitViewController.h" // Local_catch

// Local_catch
@protocol CreateCircuitDelegate <NSObject>
@optional - (void) didCheckAnyChangeForCreateCircuit:(BOOL)ischanged;
@end

@interface CreateCircuitViewController : UIViewController<EditCktDelegate>{
    id<CreateCircuitDelegate>createCircuitDelegate;
    }

//ah 2.5(cannot create main storyboard ref)

@property (nonatomic,strong)id createCircuitDelegate;
//Local_catch

@property int exSessionId;
@property (strong, nonatomic) NSString* dt;    //ah 2.5
@property (strong, nonatomic) NSString *fromController;     //ah 4.5
@end

