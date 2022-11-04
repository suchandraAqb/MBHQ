//
//  FoodScanViewController.m
//  Squad
//
//  Created by AQB Solutions Private Limited on 08/11/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "FoodScanViewController.h"

@interface FoodScanViewController (){
    IBOutlet UIView *previewView;
    IBOutlet UIButton *cancelButton;
    MTBBarcodeScanner *scanner;
    UIView *contentView;
    int apiCount;
}

@end

@implementation FoodScanViewController
@synthesize delegate,currentDate;
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = 15.0;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [scanner stopScanning];
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-End
#pragma mark-Private Method
- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Scanning Unavailable" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)foodNotFoundAlert:(NSDictionary *)dict {
    NSString *message = @"Food item not found.";
    if (![Utility isEmptyCheck:dict[@"message"]]) {
        message = dict[@"message"];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"ADD NEW"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
//                                   [self->scanner unfreezeCapture];
//                                   AddRecipeViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AddRecipeView"];
//                                   controller.currentDate = self->currentDate;
//                                   controller.isFromMealMatch = true;
//                                   [self.navigationController pushViewController:controller animated:YES];
                                   [self.navigationController popViewControllerAnimated:NO];
                                   if ([self->delegate respondsToSelector:@selector(foodScanData:)]) {
                                       [self->delegate foodScanData:@{@"QuickAddOpen":@true}];
                                   }
                               }];
    UIAlertAction *againAction = [UIAlertAction
                               actionWithTitle:@"SCAN AGAIN"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self->scanner unfreezeCapture];
                                   [self startScanning];
                               }];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"CANCEL"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self cancelButtonPressed:0];
                                   }];
    [alertController addAction:okAction];
    [alertController addAction:againAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark-End
#pragma mark-Web Service Call
-(void)getFoodDetailsFromUPC:(NSString *)upc{
    if (Utility.reachable) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self->apiCount++;
            if (self->contentView) {
                [self->contentView removeFromSuperview];
            }
            
            self->contentView = [Utility activityIndicatorView:self];
            
            
        });
        
        
        NSMutableURLRequest *request = [Utility getRequestForNutritionix:@"" api:@"NutritionixMealSearchByUpc" append:upc forAction:@"GET"];
        
        NSURLSession *loginSession = [NSURLSession sharedSession];
        NSURLSessionDataTask * dataTask =[loginSession dataTaskWithRequest:request
                                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 self->apiCount--;
                                                                 if (self->contentView && self->apiCount == 0){
                                                                     [self->contentView removeFromSuperview];
                                                                 }
                                                                 if(error == nil)
                                                                 {
                                                                     NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                                     NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                                     if (![Utility isEmptyCheck:responseString] && ![Utility isEmptyCheck:responseDict]) {
                                                                         
                                                                         if(![Utility isEmptyCheck:responseDict[@"message"]] && [Utility isEmptyCheck:responseDict[@"foods"]]){
                                                                             //error
                                                                             [self foodNotFoundAlert:responseDict];
                                                                         }else{
                                                                            //successful
                                                                             NSMutableDictionary *myMeal = [NSMutableDictionary new];
                                                                             NSArray *meal = [responseDict objectForKey:@"foods"];
                                                                             if(![Utility isEmptyCheck:meal]){
                                                                                 if(![Utility isEmptyCheck:[meal objectAtIndex:0]]){
                                                                                     myMeal = [[meal objectAtIndex:0]mutableCopy];
                                                                                 }
                                                                             }
                                                                             if (![Utility isEmptyCheck:myMeal]) {
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"food_name"]]?[myMeal objectForKey:@"food_name"]:@"" forKey:@"MealName"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"food_name"]]?[myMeal objectForKey:@"food_name"]:@"" forKey:@"EdamamFoodName"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nix_item_id"]]?[myMeal objectForKey:@"nix_item_id"]:@"" forKey:@"EdamamdFoodId"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nix_item_id"]]?[myMeal objectForKey:@"nix_item_id"]:@"" forKey:@"MealId"];
                                                                                 [myMeal setObject:[NSNumber numberWithBool:true] forKey:@"IsEdamam"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"brand_name"]]?[myMeal objectForKey:@"brand_name"]:@"" forKey:@"Brand"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_carbohydrate"]]?[myMeal objectForKey:@"nf_total_carbohydrate"]:@"0" forKey:@"Carbohydrates"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_carbohydrate"]]?[myMeal objectForKey:@"nf_total_carbohydrate"]:@"0" forKey:@"CarbohydratesPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"EdamamCalories"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"EdamamCaloriesPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"serving_weight_grams"]]?[myMeal objectForKey:@"serving_weight_grams"]:@"" forKey:@"EdamamServeGrams"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_fat"]]?[myMeal objectForKey:@"nf_total_fat"]:@"" forKey:@"Fat"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_total_fat"]]?[myMeal objectForKey:@"nf_total_fat"]:@"" forKey:@"FatPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_protein"]]?[myMeal objectForKey:@"nf_protein"]:@"" forKey:@"Protein"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_protein"]]?[myMeal objectForKey:@"nf_protein"]:@"" forKey:@"ProteinPer100"];
                                                                                 [myMeal setObject:![Utility isEmptyCheck:[myMeal objectForKey:@"nf_calories"]]?[myMeal objectForKey:@"nf_calories"]:@"" forKey:@"TotalCalories"];
                                                                                 
                                                                                 if(![Utility isEmptyCheck:myMeal[@"Photo"]]){
                                                                                     
                                                                                     if(![Utility isEmptyCheck:myMeal[@"Photo"][@"thumb"]]){
                                                                                         
                                                                                         [myMeal setObject:myMeal[@"Photo"][@"thumb"] forKey:@"PhotoPath"];
                                                                                         
                                                                                     }
                                                                                     
                                                                                 }
                                                                                 
                                                                                 
                                                                                 [self.navigationController popViewControllerAnimated:NO];
                                                                                 if ([self->delegate respondsToSelector:@selector(foodScanData:)]) {
                                                                                     [self->delegate foodScanData:myMeal];
                                                                                 }
                                                                                 
                                                                             }
                                                                         }
                                                                         
                                                                     }
                                                                     else{
                                                                         //[Utility msg:@"" title:@"Error !" controller:self haveToPop:NO];
                                                                         [self foodNotFoundAlert:nil];
                                                                         return;
                                                                     }
                                                                     
                                                                 }else{
                                                                     [Utility msg:error.localizedDescription title:@"Error !" controller:self haveToPop:YES];
                                                                 }
                                                             });
                                                             
                                                         }];
        [dataTask resume];
        
    }else{
        [Utility msg:@"Check Your network connection and try again." title:@"Oops! " controller:self haveToPop:YES];
    }
    
}
#pragma mark-End
#pragma mark-IBAction

- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-End



#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!scanner) {
        scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:previewView];
    }
    return scanner;
}
#pragma mark-End
#pragma mark - Scanning

- (void)startScanning {
    
    NSError *error = nil;
    [[self scanner] startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue) {
                NSLog(@"Found unique code: %@", code.stringValue);
                [self->scanner freezeCapture];
                [self getFoodDetailsFromUPC:code.stringValue];
            }
        }
    } error:&error];
    
    if (error) {
        NSLog(@"An error occurred: %@", error.localizedDescription);
    }
    
    
}

- (void)stopScanning {
    [scanner stopScanning];
}
#pragma mark-End

@end
