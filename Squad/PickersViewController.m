//
//  PickersViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 09/07/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "PickersViewController.h"

@interface PickersViewController (){
    IBOutlet UIPickerView *timePicker;
    IBOutlet UILabel *titleLabel;
    int min;
    int sec;
    NSMutableArray *timerArray;
    NSString *selectedValue;
    
    NSInteger numberOfRows;
    
    NSMutableArray *selExNameArray;
    
    int selectRow;
}

@end

@implementation PickersViewController
#pragma mark - ViewLifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    timerArray = [[NSMutableArray alloc]init];
    selExNameArray = [[NSMutableArray alloc]init];
    selectRow = 0;
    
    min = 0;
    sec = 5;
    if (_buttonTag == 6) {
        sec = 0;
    }
    
    switch (_buttonTag) {
        case 1:
            titleLabel.text = @"STATIONS";
            break;
            
        case 2:
            titleLabel.text = @"ROUNDS";
            break;
            
        case 3:
            titleLabel.text = @"ROUND PREP TIME";
            break;
            
        case 4:
            titleLabel.text = @"ROUND OPTIONS";
            break;
            
        case 5:
            titleLabel.text = @"WORKOUT TIME";
            break;
            
        case 6:
            titleLabel.text = @"REST TIME";
            break;
            
        default:
            break;
    }
    
    if (_buttonTag == 3 || _buttonTag == 6) {
        numberOfRows = 12;
        
        for (int i = 0; i < 12; i++) {
            [timerArray addObject:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
            
            NSString *val = [NSString stringWithFormat:@"%02d:%02d", min, sec];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i;
            }
            
            sec += 5;
            if (sec >= 60) {
                sec = 0;
                min++;
            }
        }
    } else if (_buttonTag == 5) {
        numberOfRows = 70;
        
        //        for (int i = 0; i < 360; i++) {
        //            [timerArray addObject:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
        //
        //            sec += 5;
        //            if (sec >= 60) {
        //                sec = 0;
        //                min++;
        //            }
        //        }
        int i = 0;
        while (i < 70) {
            [timerArray addObject:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
            
            NSString *val = [NSString stringWithFormat:@"%02d:%02d", min, sec];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i;
            }
            
            if (min < 1) {
                sec += 5;
            } else {
                sec += 30;
            }
            if (sec >= 60) {
                sec = 0;
                min++;
            }
            
            i++;
        }
    } else if (_buttonTag == 1 || _buttonTag == 2) {
        numberOfRows = 10;
        
        for (int i = 1; i <= 10; i++) {
            [timerArray addObject:[NSString stringWithFormat:@"%d",i]];
            
            NSString *val = [NSString stringWithFormat:@"%d",i];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i-1;
            }
        }
    } else if (_buttonTag == 4) {
        if (_circuitArray.count > 0) {
            titleLabel.text = @"SELECTED CIRCUIT";
            numberOfRows = _circuitArray.count;
            for (int i = 1; i <= _circuitArray.count; i++) {
                [timerArray addObject:[[_circuitArray objectAtIndex:i-1] objectForKey:@"circuitName"]];
                NSString *val = [[_circuitArray objectAtIndex:i-1] objectForKey:@"circuitName"];
                if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                    selectRow = i-1;
                }
            }
        } else {
            numberOfRows = 3;
            [timerArray addObject:@"DEFAULT"];
            [timerArray addObject:@"ROUND EDIT"];
            [timerArray addObject:@"STATION EDIT"];
            
            if ([_prevVal caseInsensitiveCompare:@"DEFAULT"] == NSOrderedSame) {
                selectRow = 0;
            } else if ([_prevVal caseInsensitiveCompare:@"ROUND EDIT"] == NSOrderedSame) {
                selectRow = 1;
            } else if ([_prevVal caseInsensitiveCompare:@"STATION EDIT"] == NSOrderedSame) {
                selectRow = 2;
            }
        }
    } else if (_buttonTag > 100 && _buttonTag < 1000) {
        //on
        titleLabel.text = @"ON TIME";
        numberOfRows = 70;
        
        int i = 0;
        while (i < 70) {
            [timerArray addObject:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
            
            NSString *val = [NSString stringWithFormat:@"%02d:%02d", min, sec];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i;
            }
            
            if (min < 1) {
                sec += 5;
            } else {
                sec += 30;
            }
            if (sec >= 60) {
                sec = 0;
                min++;
            }
            i++;
        }
    } else if (_buttonTag > 1000 && _buttonTag < 3000) {
        titleLabel.text = @"OFF TIME";
        numberOfRows = 12;
        sec = 0;
        
        for (int i = 0; i < 12; i++) {
            [timerArray addObject:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
            
            NSString *val = [NSString stringWithFormat:@"%02d:%02d", min, sec];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i;
            }
            
            sec += 5;
            if (sec >= 60) {
                sec = 0;
                min++;
            }
        }
    } else if (_buttonTag > 3000 && _buttonTag < 4000) {
        titleLabel.text = @"REPS";
        numberOfRows = 60;
        
        for (int i = 1; i <= 61; i++) {
            [timerArray addObject:[NSString stringWithFormat:@"%d",i]];
            NSString *val = [NSString stringWithFormat:@"%d",i];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i-1;
            }
        }
    } else if (_buttonTag > 6000 && _buttonTag < 7000) {
        titleLabel.text = @"EXERCISE";
        numberOfRows = _exerciseNameArray.count;
        [selExNameArray addObjectsFromArray:_exerciseNameArray];
        
        for (int i = 0; i < _exerciseNameArray.count; i++) {
            [timerArray addObject:[[_exerciseNameArray objectAtIndex:i] objectForKey:@"exerciseName"]];
            NSString *val = [[_exerciseNameArray objectAtIndex:i] objectForKey:@"exerciseName"];
            if ([_prevVal caseInsensitiveCompare:val] == NSOrderedSame) {
                selectRow = i;
            }
        }
    }
    
    
    //    [timePicker selectRow:4 inComponent:0 animated:YES];
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [timePicker selectRow:selectRow inComponent:0 animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
-(IBAction)backTapped:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)doneTapped:(id)sender {
    NSInteger selectedRow = [timePicker selectedRowInComponent:0];
    selectedValue = [timerArray objectAtIndex:selectedRow];
    if (selExNameArray.count > 0) {
        selectedValue = [[selExNameArray objectAtIndex:selectedRow] objectForKey:@"exerciseID"];
    }
    [_customPickerDelegate updateCustomPickerValue:selectedValue ofButton:(NSInteger)_buttonTag withAccessibilityHint:_btnAccessibilityHint];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIPicker Delegate & DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return numberOfRows;
}

//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    //    int minutes = (offTime % 3600) / 60;
//    //    int seconds = (offTime %3600) % 60;
//
//    //    timerCountLabel.text = [NSString stringWithFormat:@"%02d:%02d", min, sec];
//    //        [label setText:[NSString stringWithFormat:@"%02d:%02d", min, sec]];
//
//
//    return [timerArray objectAtIndex:row];
//}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 50.0, 20.0)] ;
    //    [label setBackgroundColor:[UIColor clearColor]];
    //    [label setTextColor:[UIColor blueColor]];
    //    [label setFont:[UIFont boldSystemFontOfSize:20.0]];
    //    [label setText:[timerArray objectAtIndex:row]];
    //    return label;
    
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, timePicker.frame.size.width, 50.0)];
        [tView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:50]];
        if (_buttonTag == 4) {
            [tView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:30]];
        } else if (_buttonTag > 6000 && _buttonTag < 7000) {
            [tView setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:30]];
        }
        [tView setTextColor:[UIColor whiteColor]];
        [tView setTextAlignment:NSTextAlignmentCenter];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    tView.text=[timerArray objectAtIndex:row];
    if ([_prevVal caseInsensitiveCompare:[timerArray objectAtIndex:row]] == NSOrderedSame) {
        selectRow = (int)row;
        //        [timePicker selectRow:selectRow inComponent:0 animated:YES];
    }
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 50.0;
}
@end
