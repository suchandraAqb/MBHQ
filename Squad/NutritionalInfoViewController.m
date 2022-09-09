//
//  NutritionalInfoViewController.m
//  Squad
//
//  Created by AQB Solutions-Mac Mini 2 on 07/04/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//

#import "NutritionalInfoViewController.h"
#import "Calorie.h"
#import "Utility.h"

@interface NutritionalInfoViewController ()
{
    IBOutlet UILabel *energyPerGram;
    IBOutlet UILabel *energySelectedQuantity;
    
    IBOutlet UILabel *proteinGrams;
    IBOutlet UILabel *proteinGramsSQ;
    IBOutlet UILabel *proteinPercentagePerGrams;
    IBOutlet UILabel *proteinPercentageSQ;
    IBOutlet UILabel *proteinCalsPerGrams;
    IBOutlet UILabel *proteinCalsSQ;
    
    IBOutlet UILabel *carbGramsPerGrams;
    IBOutlet UILabel *carbGramsSQ;
    IBOutlet UILabel *carbPercentagePerGrams;
    IBOutlet UILabel *carbPercentageSQ;
    IBOutlet UILabel *carbCalsPerGrams;
    IBOutlet UILabel *carbCalsSQ;
    
    IBOutlet UILabel *fatGrams;
    IBOutlet UILabel *fatGramsSQ;
    IBOutlet UILabel *fatPercentagePerGrams;
    IBOutlet UILabel *fatPercentageSQ;
    IBOutlet UILabel *fatCalsPerGrams;
    IBOutlet UILabel *fatCalsSQ;
    
    IBOutlet UILabel *per100Label;
    IBOutlet UILabel *selectedquantityLabel;
    
    IBOutlet UILabel *alcoholGrams;
    IBOutlet UILabel *alcoholGramsSQ;
    IBOutlet UILabel *alcoholPercentagePerGrams;
    IBOutlet UILabel *alcoholPercentageSQ;
    IBOutlet UILabel *alcoholCalsPerGrams;
    IBOutlet UILabel *alcoholCalsSQ;

    IBOutlet UIStackView *nutritionInfoStackView;
    IBOutlet UIView *proteinView;
    IBOutlet UIView *carbsView;
    IBOutlet UIView *fatView;
    IBOutlet UIView *alcoholView;
    IBOutlet UIView *dietaryinfo;
    
    IBOutlet UIView *containerView;

    
}
@end

@implementation NutritionalInfoViewController
@synthesize ingredientDict;
#pragma mark - IBAction

-(IBAction)closeButtonPressed:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - End

#pragma mark - Private Function

-(void)setupview{
    
    NSDictionary *ingredientDetails = ingredientDict[@"IngredientDetails"];
    float quantity = 0;
    NSString *unitString = @"";
    quantity = [ingredientDict[@"QuantityImperial"] floatValue];
    if (([[defaults objectForKey:@"UnitPreference"] intValue] == 0) || ([[defaults objectForKey:@"UnitPreference"] intValue] == 1))
    {
        quantity = [ingredientDict[@"QuantityMetric"] floatValue];
        // unitString = ingredientDict[@"UnitMetric"];
        unitString = ingredientDetails[@"UnitMetric"];
        
    }else
    {
        //quantity = [ingredientDict[@"QuantityMetric"] floatValue];
        //unitString = ingredientDict[@"UnitMetric"];
        unitString = ingredientDetails[@"UnitMetric"];
    }
    
    if ([unitString isEqualToString:@"as needed"] || [unitString isEqualToString:@"to taste"])
    {
        quantity = 0;
    }
    
    per100Label.text =[@"" stringByAppendingFormat:@"Per 100 (%@)",ingredientDetails[@"UnitMetric"]];
    selectedquantityLabel.text=[@"" stringByAppendingFormat:@"Selected Quantity (%@)",ingredientDetails[@"UnitMetric"]];
    
    Calorie *calPerHundred =[Utility ingredientCalorieCalculationDetails:100 proteinPer100:[ingredientDetails[@"ProteinPer100"] floatValue] fatPer100:[ingredientDetails[@"FatPer100"] floatValue] carbPer100:[ingredientDetails[@"CarbsPer100"] floatValue] alcoholPer100:[ingredientDetails[@"AlcoholPer100"] floatValue] unit:ingredientDetails[@"UnitMetric"] conversionUnit:ingredientDetails[@"ConversionUnit"] conversionFactor:[ingredientDetails[@"ConversionNum"] floatValue]];
    
    if (![Utility isEmptyCheck:calPerHundred]) {
        NSString *totalQuantity = [Utility totalCalories:calPerHundred];
        
        NSString *totalCaloriesPerHundredString =[Utility totalCalories:calPerHundred];
        float totalCaloriesPerHundred = [totalCaloriesPerHundredString floatValue];
        
        NSString *detailString =@"";
        if (totalCaloriesPerHundred > 0) {
            detailString =totalCaloriesPerHundredString;
        }else{
            detailString =@"0";
        }
        detailString = [detailString stringByAppendingFormat:@"cal"];
        NSString *calValueString=@"";
        if (totalCaloriesPerHundred > 0) {
            int calValue=roundf(totalCaloriesPerHundred * 4.184);
            calValueString = [@"" stringByAppendingFormat:@"%d",calValue];
        }
        detailString = [detailString stringByAppendingFormat:@"(%@kJ)",calValueString];
        energyPerGram.text = detailString;
        
        //Protein
        float proteinGramsPerhundred = [calPerHundred.proteinGrams floatValue];
        if (proteinGramsPerhundred>0) {
            [nutritionInfoStackView addArrangedSubview:proteinView];
            
            proteinGrams.text=[@"" stringByAppendingFormat:@"%.2fg",[calPerHundred.proteinGrams floatValue]];///proteinGrams
            proteinCalsPerGrams.text =[@"" stringByAppendingFormat:@"%.2f",[calPerHundred.proteinCalories floatValue]]; //proteinCalories
            NSLog(@"gram-%@ cal-%@",proteinGrams.text,proteinCalsPerGrams.text);
            
            NSString *proteincalpercentage =@"";
            if (totalCaloriesPerHundred>0) {
                proteincalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerHundred.proteinCalories];
            }else{
                proteincalpercentage=@"0";
            }
            proteinPercentagePerGrams.text =[@"" stringByAppendingFormat:@"%.2f%%",[proteincalpercentage floatValue]]; //proteinpercentage
        }else{
            [nutritionInfoStackView removeArrangedSubview:proteinView];
            [proteinView removeFromSuperview];
        }
        //End
        
        //carb
        float carbGramsPerhundred = [calPerHundred.carbGrams floatValue];
        if (carbGramsPerhundred>0) {///stackchecking
            [nutritionInfoStackView addArrangedSubview:carbsView];
            
            carbGramsPerGrams.text=[@"" stringByAppendingFormat:@"%.2fg",[calPerHundred.carbGrams floatValue]];///carbGrams
            carbCalsPerGrams.text =[@"" stringByAppendingFormat:@"%.2f",[calPerHundred.carbCalories floatValue]]; //carbCalories
            NSLog(@"crabgram-%@ crabcal-%@",carbGramsPerGrams.text,carbCalsPerGrams.text);
            
            
            NSString *carbcalpercentage =@"";
            if (totalCaloriesPerHundred>0) {
                carbcalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerHundred.carbCalories];
            }else{
                carbcalpercentage=@"0";
            }
            carbPercentagePerGrams.text =[@"" stringByAppendingFormat:@"%.2f%%",[carbcalpercentage floatValue]]; //carbpercentage
        }else{
            [nutritionInfoStackView removeArrangedSubview:carbsView];
            [carbsView removeFromSuperview];
        }
        
        //End
        
        //Fat
        float fatGramsPerhundred = [calPerHundred.fatGrams floatValue];
        
        if (fatGramsPerhundred>0) {///stackchecking
            [nutritionInfoStackView addArrangedSubview:fatView];
            fatGrams.text=[@"" stringByAppendingFormat:@"%.2fg",[calPerHundred.fatGrams floatValue]];///fatGrams
            fatCalsPerGrams.text =[@"" stringByAppendingFormat:@"%.2f",[calPerHundred.fatCalories floatValue]]; //fatCalories
            NSLog(@"fatgram-%@ fatcal-%@",fatGrams.text,fatCalsPerGrams.text);
            
            
            NSString *fatcalpercentage =@"";
            if (totalCaloriesPerHundred>0) {
                fatcalpercentage= [Utility calPercentage:[totalQuantity floatValue] with:calPerHundred.fatCalories];
            }else{
                fatcalpercentage =@"0";
            }
            fatPercentagePerGrams.text =[@"" stringByAppendingFormat:@"%.2f%%",[fatcalpercentage floatValue]]; //percentage
        }else{
            [nutritionInfoStackView removeArrangedSubview:fatView];
            [fatView removeFromSuperview];
        }
        //End
        
        //Alcohol
        float alcoholGramsPerhundred = [calPerHundred.alcoholGrams floatValue];
        if (alcoholGramsPerhundred>0) {///stackchecking
            [nutritionInfoStackView addArrangedSubview:alcoholView];
            
            alcoholGrams.text=[@"" stringByAppendingFormat:@"%.2f",[calPerHundred.alcoholGrams floatValue]];//alcoholGrams
            alcoholCalsPerGrams.text =[@"" stringByAppendingFormat:@"%.2f",[calPerHundred.alcoholCalories floatValue]]; //fatCalories
            NSLog(@"Algram-%@ Alcal-%@",alcoholGrams.text,alcoholCalsPerGrams.text);
            
            NSString *alcoholcalpercentage =@"";
            if (totalCaloriesPerHundred>0) {
                alcoholcalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerHundred.alcoholCalories];
            }else{
                alcoholcalpercentage =@"0";
            }
            alcoholPercentagePerGrams.text =[@"" stringByAppendingFormat:@"%.2f%%",[alcoholcalpercentage floatValue]]; //alcoholpercentage
        }else{
            [nutritionInfoStackView removeArrangedSubview:alcoholView];
            [alcoholView removeFromSuperview];
        }
        //End
    }
    
    //if (quantity > 0 && quantity != 0 && ![unitString isEqualToString:@""])
    if (quantity >= 0 && ![unitString isEqualToString:@""])
    {
        Calorie *calPerQuantity =[Utility ingredientCalorieCalculationDetails:quantity proteinPer100:[ingredientDetails[@"ProteinPer100"] floatValue] fatPer100:[ingredientDetails[@"FatPer100"] floatValue] carbPer100:[ingredientDetails[@"CarbsPer100"] floatValue] alcoholPer100:[ingredientDetails[@"AlcoholPer100"] floatValue] unit:ingredientDetails[@"UnitMetric"] conversionUnit:ingredientDetails[@"ConversionUnit"] conversionFactor:[ingredientDetails[@"ConversionNum"] floatValue]];
        
        NSString *totalQuantity = [Utility totalCalories:calPerQuantity];
        NSLog(@"totalCalories-%@",[Utility totalCalories:calPerQuantity]);
        
        if (![Utility isEmptyCheck:calPerQuantity]) {
            NSString *totalCaloriesPerQuantityString =[Utility totalCalories:calPerQuantity];
            float totalCaloriesPerQuantity = [totalCaloriesPerQuantityString floatValue];
            
            NSString *detailString =@"";
            if (totalCaloriesPerQuantity > 0) {
                detailString =totalCaloriesPerQuantityString;
            }else{
                detailString =@"0";
            }
            detailString = [detailString stringByAppendingFormat:@"cal"];
            NSString *calValueString=@"";
            if (totalCaloriesPerQuantity > 0) {
                int calValue=roundf(totalCaloriesPerQuantity *4.184);
                calValueString = [@"" stringByAppendingFormat:@"%d",calValue];
            }
            detailString = [detailString stringByAppendingFormat:@"(%@kJ)",calValueString];
            NSLog(@"detailString-%@",detailString);
            energySelectedQuantity.text = detailString;
            
            ///Protein
            float proteinGramsPerQuantity = [calPerQuantity.proteinGrams floatValue];
            
            if (proteinGramsPerQuantity>0) {//stackchecking
                proteinGramsSQ.text=[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.proteinGrams floatValue]];///proteinGrams
                proteinCalsSQ.text =[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.proteinCalories floatValue]]; //Calories
                NSLog(@"SQPgram-%@ AQPcal-%@",proteinGramsSQ.text,proteinCalsSQ.text);
                
                NSString *calpercentage =@"";
                if (totalCaloriesPerQuantity>0) {
                    calpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerQuantity.proteinCalories];
                    NSLog(@"proteinCalPercentage-%@",calpercentage);
                    
                }else{
                    calpercentage=@"0";
                }
                proteinPercentageSQ.text =[@"" stringByAppendingFormat:@"%.2f%%",[calpercentage floatValue]]; //percentage
            }else{
                proteinGramsSQ.text=@"0";
                proteinCalsSQ.text=@"0";
                proteinPercentageSQ.text =[@"" stringByAppendingFormat:@"%@%%",@"0"]; //percentage
            }
            // End
            
            //carb
            float carbGramsPerQuantity = [calPerQuantity.carbGrams floatValue];
            if (carbGramsPerQuantity>0) {///stackchecking
                carbGramsSQ.text=[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.carbGrams floatValue]];///carbGrams
                carbCalsSQ.text =[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.carbCalories floatValue]]; //carbCalories
                NSLog(@"SQcrabgram-%@ AQcrabcal-%@",carbGramsSQ.text,carbCalsSQ.text);
                
                NSString *carbcalpercentage =@"";
                if (totalCaloriesPerQuantity>0) {
                    carbcalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerQuantity.carbCalories];
                    NSLog(@"carbCaloriesPercentage-%@",carbcalpercentage);
                }else{
                    carbcalpercentage=@"0";
                }
                carbPercentageSQ.text =[@"" stringByAppendingFormat:@"%.2f%%",[carbcalpercentage floatValue]]; //percentage
            }else{
                carbGramsSQ.text=@"0";
                carbCalsSQ.text =@"0";
                carbPercentageSQ.text =[@"" stringByAppendingFormat:@"%@%%",@"0"];
            }
            //End
            
            //Fat
            float fatGramsPerQuantity = [calPerQuantity.fatGrams floatValue];
            if (fatGramsPerQuantity>0) {///stackchecking
                
                fatGramsSQ.text=[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.fatGrams floatValue]];///carbGrams
                fatCalsSQ.text =[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.fatCalories floatValue]]; //carbCalories
                NSLog(@"SQfatgram-%@ AQfatcal-%@",fatGramsSQ.text,fatCalsSQ.text);
                
                NSString *fatcalpercentage =@"";
                if (totalCaloriesPerQuantity>0) {
                    fatcalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerQuantity.fatCalories];
                }else{
                    fatcalpercentage=@"0";
                }
                fatPercentageSQ.text =[@"" stringByAppendingFormat:@"%.2f%%",[fatcalpercentage floatValue]]; //percentage
            }else{
                fatGramsSQ.text=@"0";
                fatCalsSQ.text=@"0";
                fatPercentageSQ.text =[@"" stringByAppendingFormat:@"%@%%",@"0"];
            }
            //End
            
            //Alcohol
            float alcoholGramsPerQuantity = [calPerHundred.alcoholGrams floatValue];
            
            if (alcoholGramsPerQuantity>0) {///stackchecking
                
                alcoholGramsSQ.text=[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.alcoholGrams floatValue]];//alcoholGrams
                alcoholCalsSQ.text =[@"" stringByAppendingFormat:@"%.2f",[calPerQuantity.alcoholCalories floatValue]]; //fatCalories
                NSLog(@"SQAlgram-%@ AQAlcal-%@",alcoholGramsSQ.text,alcoholCalsSQ.text);
                NSString *alcoholcalpercentage =@"";
                if (totalCaloriesPerQuantity>0) {
                    alcoholcalpercentage = [Utility calPercentage:[totalQuantity floatValue] with:calPerQuantity.alcoholCalories];
                    NSLog(@"alcoholcalpercentage-%@",alcoholcalpercentage);
                }else{
                    alcoholcalpercentage =@"0";
                }
                alcoholPercentageSQ.text =[@"" stringByAppendingFormat:@"%.2f%%",[alcoholcalpercentage floatValue]]; //alcoholpercentage
            }else{
                alcoholGramsSQ.text=@"0";
                alcoholCalsSQ.text=@"0";
                alcoholPercentageSQ.text =[@"" stringByAppendingFormat:@"%@%%",@"0"];
            }
            //End
        }
    }
    [nutritionInfoStackView addArrangedSubview:dietaryinfo];
    
}
#pragma mark - End

#pragma mark -  View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    containerView.layer.cornerRadius = 5;
    containerView.layer.masksToBounds = YES;
    [self setupview];
}

#pragma mark - End

#pragma mark - Memory Warning

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - End

@end
