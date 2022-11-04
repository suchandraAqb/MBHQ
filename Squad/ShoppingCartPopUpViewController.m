//
//  ShoppingCartPopUpViewController.m
//  Squad
//
//  Created by aqbsol iPhone on 08/02/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "ShoppingCartPopUpViewController.h"
#import "CustomNutritionPlanListCollectionViewController.h"
#import "CustomNutritionPlanListViewController.h"

@interface ShoppingCartPopUpViewController ()
{
    IBOutlet UILabel *shoppingQuantityLabel;
    IBOutlet UIButton *plusButton;
    IBOutlet UIButton *minusButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIView *shopPopUpView;
    IBOutlet NSLayoutConstraint *shopPopupViewTop;
    int temp;
}
@end

@implementation ShoppingCartPopUpViewController
@synthesize delegate,top,noOfServe,indexPath,from;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    shoppingQuantityLabel.text=[NSString stringWithFormat:@"%d",noOfServe];
    //shopPopUpView.frame.origin.y = 800;
//    shopPopUpView.center = CGPointMake(10.0, 0.0);
//    shopPopUpView.frame = CGRectMake(10.0, 0.0, shopPopUpView.frame.size.width, shopPopUpView.frame.size.height);
    shopPopupViewTop.constant = top;
    temp = noOfServe;
    if ([from isEqualToString:@"table"]) {
        [self.view setBackgroundColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.5]];
    }else{
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
//    if (noOfServe>0) {
//        saveButton.enabled = true;
//    }else{
//        saveButton.enabled = false;
//    }
}

#pragma mark -IBAction
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    [self shouldPopOnBackButtonWithResponse:^(BOOL shouldPop) {
        if (shouldPop) {
            [self dismissViewControllerAnimated:YES completion:^{
//                if (temp == 0) {
//                    [delegate cancelPressed:0 index:indexPath];
//                } else {
//                    [delegate cancelPressed:temp index:indexPath];
//                }
                [delegate cancelPressed:temp index:indexPath];
            }];
        }else{      //this calls on save popUp alert
            [self dismissViewControllerAnimated:YES completion:^{
                [delegate saveCartPressed:noOfServe index:indexPath];
            }];
        }
        
    }];
    
}

- (IBAction)plusMinusButtonPressed:(UIButton *)sender {
    if (sender == plusButton) {
        noOfServe++;
    }else{
        if (noOfServe>0) {
            noOfServe--;
        }
    }
//    if (noOfServe>0) {
//        saveButton.enabled = true;
//    }else{
//        saveButton.enabled = false;
//    }
    shoppingQuantityLabel.text=[NSString stringWithFormat:@"%d",noOfServe];
    [delegate collectionCartSelected:noOfServe index:indexPath];
}
- (IBAction)saveToCustomButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [delegate saveCartPressed:noOfServe index:indexPath];
    }];
}
- (void) shouldPopOnBackButtonWithResponse:(void (^)(BOOL shouldPop))response {
    if (noOfServe != temp) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Save Changes"
                                              message:@"Your changes will be lost if you don’t save them."
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Save"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       //                                       [saveCustomShoppingList sendActionsForControlEvents:UIControlEventTouchUpInside];
                                       response(NO);
                                   }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Don't Save"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
//                                           squadCustomMealSessionList = [[NSMutableArray alloc]init];
//                                           tempShoppingList = [[NSArray alloc]init];
                                           response(YES);
                                       }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
//        squadCustomMealSessionList = [[NSMutableArray alloc]init];
//        tempShoppingList = [[NSArray alloc]init];
        response(YES);
    }
}
#pragma mark -End
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
