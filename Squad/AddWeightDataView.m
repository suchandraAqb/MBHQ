//
//  AddWeightDataView.m
//  Squad
//
//  Created by AQB-Mac-Mini 3 on 24/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "AddWeightDataView.h"


@interface AddWeightDataView(){
    NSMutableArray *circuiSetArray;
    NSMutableDictionary *circuitDict;
    UITextField *activeTextField;
    UIToolbar *toolBar;
    NSInteger dataIndex;
    CGSize kbSize;
}

@end

@implementation AddWeightDataView
@synthesize setCountLabel,setDeleteButton,weightTextField,repsTextField,repsGoalLabel,weightTable,cell,delegate,cellSection,cellRow;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
 #pragma mark - Custom Method
+(AddWeightDataView *)instantiateView{
   NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"AddWeightDataView" owner:self options:nil];
    return (AddWeightDataView *)[nibs firstObject];
}
-(void)updateView:(NSArray *)dataArray withIndex:(NSInteger)index{
    [self registerForKeyboardNotifications];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)]; //toolbar is uitoolbar object
    toolBar.barStyle = UIBarStyleBlackOpaque;
    toolBar.translucent = YES;
    UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnClickedDone:)];
    [toolBar setItems:[NSArray arrayWithObject:btnDone]];
    [weightTextField setInputAccessoryView:toolBar];
    [repsTextField setInputAccessoryView:toolBar];
    
    if(!circuiSetArray){
        circuiSetArray = [[NSMutableArray alloc]initWithArray:dataArray];
    }
    
    dataIndex = index;
    
    if(!circuitDict && circuiSetArray.count>0){
        circuitDict = [[NSMutableDictionary alloc]initWithDictionary:circuiSetArray[dataIndex]];
    }
    
    if(![Utility isEmptyCheck:circuitDict]){
        NSString *dataStr =@"";
        
        if(![Utility isEmptyCheck:circuitDict[@"Rep"]]){
            dataStr = circuitDict[@"Rep"];
        }
        repsGoalLabel.text = dataStr;
        setCountLabel.text = [@"" stringByAppendingFormat:@"%d", (int)dataIndex+1]; //[circuitDict[@"SetNo"] intValue]
        
        float weight = 0.0;
        if(![Utility isEmptyCheck:circuitDict[@"Weight"]]){
         weight = [circuitDict[@"Weight"] floatValue];
        }
        
        int rep=0;
        if(![Utility isEmptyCheck:circuitDict[@"RepGoal"]]){
            rep = [circuitDict[@"RepGoal"] intValue];
        }
        
        if(rep > 0){
            repsTextField.text = [@"" stringByAppendingFormat:@"%d",rep];
        }
        
        if(weight>0.0){
            
            if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.maximumFractionDigits = 2;
                weightTextField.text = [formatter stringFromNumber:[NSNumber numberWithFloat:weight]];
                
            }else{
                CGFloat lb = weight * 2.2046;
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                formatter.maximumFractionDigits = 2;
                weightTextField.text = [formatter stringFromNumber:[NSNumber numberWithFloat:lb]];
            }
        }else{
            if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
                weightTextField.placeholder = @"kg";
            }else{
                weightTextField.placeholder = @"lb";            
            }
        }
        
    }
    
    
}
 #pragma mark - End

 #pragma mark - IBAction
- (IBAction)setDeleteButtonPressed:(UIButton *)sender {
    if([delegate respondsToSelector:@selector(deleteSet:cellSection:cellRow:ofIndex:)]){
        [delegate deleteSet:circuitDict cellSection:cellSection cellRow:cellRow ofIndex:dataIndex];
    }
        
}
 #pragma mark - End

#pragma mark - KeyboardNotifications -
// Call this method somewhere in your view controller setup code.

#pragma mark - Keyboard Notification
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(kbSize.width >0 && kbSize.height>0) return;
    
    NSDictionary* info = [aNotification userInfo];
    kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    
}

-(void)btnClickedDone:(id)sender{
    
    [self endEditing:YES];
}

#pragma mark - End -

#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    activeTextField = textField;
    
    if ([delegate respondsToSelector:@selector(textFieldBeginEditing:keyboardSize:)]) {
        [delegate textFieldBeginEditing:cell keyboardSize:kbSize];
    }
    
//     CGRect rect = [self convertRect:self.frame toView:self.superview.superview];
//
//    NSLog(@"Origin -- x: %f y: %f", rect.origin.x,rect.origin.y);
//    NSLog(@"Size -- x:%f y:%f",rect.size.width,rect.size.height);
    
    
    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        // Load resources for iOS 6.1 or earlier
//        cell = (WeightRecordTableViewCell *) textField.superview.superview;
//
//    } else {
//        // Load resources for iOS 7 or later
//        cell = (WeightRecordTableViewCell *) textField.superview.superview.superview;
//        // TextField -> UITableVieCellContentView -> (in iOS 7!)ScrollView -> Cell!
//    }
    //[weightTable scrollToRowAtIndexPath:[weightTable indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (activeTextField == weightTextField){
        float weight =  [weightTextField.text floatValue];
        if ([[defaults objectForKey:@"UnitPreference"] intValue] == 0 || [[defaults objectForKey:@"UnitPreference"] intValue] == 1) {
            
        }else{
            weight = weight/2.2046;
        }
        
        [circuitDict setObject:[NSNumber numberWithDouble:weight] forKey:@"Weight"];
        
    }else if (activeTextField == repsTextField){
        int rep =  [repsTextField.text intValue];
        [circuitDict setObject:[NSNumber numberWithInt:rep] forKey:@"RepGoal"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([delegate respondsToSelector:@selector(updateWeightData: ofIndex: cellSection:cellRow:)]){
            [delegate updateWeightData:circuitDict ofIndex:dataIndex cellSection:cellSection cellRow:cellRow];
        }
    });
    
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:1];
       
        // update UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if([delegate respondsToSelector:@selector(updateWeightData: ofIndex: cellSection:cellRow:)]){
                [delegate updateWeightData:circuitDict ofIndex:dataIndex cellSection:cellSection cellRow:cellRow];
            }
        });
        
    });*/

   
    activeTextField = nil;

}
#pragma mark - End

    
@end
