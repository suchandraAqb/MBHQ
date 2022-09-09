//
//  WebinarDetailsEntryViewController.m
//  Squad
//
//  Created by Admin on 24/02/21.
//  Copyright © 2021 AQB Solutions. All rights reserved.
//

#import "WebinarDetailsEntryViewController.h"

@interface WebinarDetailsEntryViewController (){
    
    IBOutlet UIView *mainView;
    IBOutlet UIImageView *webinarImage;
    IBOutlet UILabel *webinarNameLabel;
    IBOutlet UILabel *durationLabel;
    IBOutlet UILabel *webinarTypeLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet UIButton *startButton;
    
}

@end

@implementation WebinarDetailsEntryViewController
@synthesize webinar,isShowFavAlert;
#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![Utility isEmptyCheck:webinar]) {
        NSString *eventString = [webinar valueForKey:@"EventName"];
        if (![Utility isEmptyCheck:eventString]) {
            webinarNameLabel.text = eventString;
        }
        
        NSString *presenterString =[webinar valueForKey:@"PresenterName"];
        NSDictionary *presenterDict = [defaults valueForKey:@"presenterDict"];
        NSString *imageString =[webinar valueForKey:@"ImageUrl"];
        webinarImage.layer.cornerRadius = webinarImage.frame.size.width/2;
        webinarImage.clipsToBounds = YES;
        if (![Utility isEmptyCheck:imageString]) {
            [webinarImage sd_setImageWithURL:[NSURL URLWithString:[imageString stringByAddingPercentEncodingWithAllowedCharacters:
                                                                         [NSCharacterSet URLQueryAllowedCharacterSet]]]
                                  placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
        }else{
            if (![Utility isEmptyCheck:presenterString] && ![Utility isEmptyCheck:[presenterDict valueForKey:presenterString]]) {
                NSString *s=[[@"" stringByAppendingFormat:@"%@/Images/Presenters/%@",BASEURL,[presenterDict valueForKey:presenterString]] stringByAddingPercentEncodingWithAllowedCharacters:
                             [NSCharacterSet URLQueryAllowedCharacterSet]];
                [webinarImage sd_setImageWithURL:[NSURL URLWithString:s]
                                      placeholderImage:[UIImage imageNamed:@"place_holder1.png"] options:SDWebImageScaleDownLargeImages];
            }else{
                webinarImage.image = [UIImage imageNamed:@"place_holder1.png"];
            }
        }
        
        
        if (![Utility isEmptyCheck:[webinar objectForKey:@"Duration"]]) {
            durationLabel.text=[NSString stringWithFormat:@"%@ min",[webinar objectForKey:@"Duration"]];
        }else{
            durationLabel.text=@"00 min";
        }
        
        webinarTypeLabel.text=[[webinar objectForKey:@"Tags"] objectAtIndex:0];
        
        NSString *msg= [webinar valueForKey:@"Content"];
        NSMutableAttributedString *strAttributed = [[NSMutableAttributedString alloc] initWithData:[msg dataUsingEncoding:NSUTF8StringEncoding]
                                                                                           options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}
                                                                                 documentAttributes:nil error:nil];
        [strAttributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Raleway-SemiBold" size:16] range:NSMakeRange(0, [strAttributed length])];
        descriptionLabel.attributedText=strAttributed;
        
        startButton.layer.borderColor = [UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0].CGColor;
        startButton.clipsToBounds = YES;
        startButton.layer.borderWidth = 1.2;
        startButton.layer.cornerRadius = startButton.frame.size.height/2.0;
        [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [startButton setTitle:@"START" forState:UIControlStateNormal];
        [startButton setBackgroundColor:[UIColor colorWithRed:148.0 / 255.0 green:227.0 / 255.0 blue:223.0 / 255.0 alpha:1.0]];
        
        mainView.layer.borderColor = [Utility colorWithHexString:@"F5F5F5"].CGColor;
        mainView.layer.borderWidth=1;
        mainView.layer.cornerRadius=10;
        mainView.clipsToBounds=YES;
        mainView.backgroundColor=[Utility colorWithHexString:@"F5F5F5"];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}

#pragma mark - End

#pragma mark - IBActions
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)startButtonPressed:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
         WebinarSelectedViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebinarSelectedView"];
        controller.webinar = [self->webinar mutableCopy];
        controller.isShowFavAlert=self->isShowFavAlert;
         [self.navigationController pushViewController:controller animated:YES];
    });
}


#pragma mark - End

#pragma mark - Private method
#pragma mark - End




@end
