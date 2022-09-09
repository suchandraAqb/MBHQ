//
//  HelpViewController.m
//  Squad
//
//  Created by aqb-mac-mini3 on 20/08/18.
//  Copyright © 2018 AQB Solutions. All rights reserved.
//

#import "HelpViewController.h"
#import "HomeTableViewCell.h"

@interface HelpViewController (){
    
    __weak IBOutlet UILabel *helpLabel;
    __weak IBOutlet UITableView *helpTable;
    NSArray *helpArray;
    __weak IBOutlet NSLayoutConstraint *helpTableHeightConstraint;
}

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Welcome to mbHQ HELP \nTo learn about the incredible features available within the mbHQ program look for the [i] screens in the top right hand corner of your app."]];
    NSRange foundRange = [text.mutableString rangeOfString:[NSString stringWithFormat:@"look for the [i] screens in the top right hand corner of your app."]];
    
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont fontWithName:@"Raleway-SemiBold" size:18.0],
                               NSForegroundColorAttributeName : squadMainColor
                               };
    [text addAttributes:attrDict range:NSMakeRange(0, text.length)];
    [text addAttributes:@{
                          NSFontAttributeName : [UIFont fontWithName:@"Raleway-Medium" size:18.0],
                          NSForegroundColorAttributeName : squadMainColor
                          }
                  range:foundRange];
    
    helpLabel.attributedText = text;
    helpArray = @[@{
                      @"Header":@"Main Menu",
                      @"Data":@[@{
                                    @"Name":@"Home/Welcome",
                                    @"VideoLink":@"https://player.vimeo.com/external/220933773.m3u8?s=04d41e4e04fa8ce700db0f52f247acce968b72e5"
                                    },@{
                                    @"Name":@"Today",
                                    @"VideoLink":@"https://player.vimeo.com/external/290408368.m3u8?s=b6c812928713281f6cab2e4528d5890e97814c62"
                                    },@{
                                    @"Name":@"Menu",
                                    @"VideoLink":@"https://player.vimeo.com/external/290408257.m3u8?s=eb4b9b3ed9aff17c0a6b8297ad209d7c8d6ed8d6"
                                    },@{
                                    @"Name":@"Features",
                                    @"VideoLink":@"https://player.vimeo.com/external/290408179.m3u8?s=3832f0ae5a00782c688dcc68188d6d9adce10f1c"
                                    },@{
                                    @"Name":@"Message Centre",
                                    @"VideoLink":@"https://player.vimeo.com/external/290408275.m3u8?s=af06f7cca4abcf647837546ba1bbea3c2fb523d6"
                                    }]
                      },@{
                      @"Header":@"Learn",
                      @"Data":@[@{
                                    @"Name":@"Learn Home Screen",
                                    @"VideoLink":@"https://player.vimeo.com/external/220933065.m3u8?s=387a479d1133aee78893c610a7ef9654b82ac4b4"
                                    },@{
                                    @"Name":@"Learn Course",
                                    @"VideoLink":@"https://player.vimeo.com/external/290408217.m3u8?s=f0b76fab6bfec350339727655d99961f15132eca"
                                    }]
                      },@{
                      @"Header":@"Connect",
                      @"Data":@[@{
                                    @"Name":@"Connect Home Screen",
                                    @"VideoLink":@"https://player.vimeo.com/external/220932517.m3u8?s=dd3882bb52f88673c33ff600b24bfc55684011de"
                                    }]
                      },@{
                      @"Header":@"Achieve",
                      @"Data":@[@{
                                    @"Name":@"Achieve Home Screen",
                                    @"VideoLink":@"https://player.vimeo.com/external/220937662.m3u8?s=38a17694e14093b93c516efe24d9c6592677ba25"
                                    }]
                      },@{
                      @"Header":@"Appreciate",
                      @"Data":@[@{
                                    @"Name":@"Appreciate Home Screen",
                                    @"VideoLink":@"https://player.vimeo.com/external/220933321.m3u8?s=dbe73990b8d048743040db27d4e8e29e78144aa3"
                                    }]
                      }
                  ];
    helpTable.estimatedRowHeight = 60;
    helpTable.rowHeight = UITableViewAutomaticDimension;
    [helpTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [helpTable addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [helpTable removeObserver:self forKeyPath:@"contentSize"];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == helpTable) {
        helpTableHeightConstraint.constant = helpTable.contentSize.height;
    }
}
#pragma mark - IBAction

- (IBAction)playButtonPressed:(UIButton *)sender {
    NSDictionary *dict = helpArray[[sender.accessibilityHint intValue]];
    NSArray *videoArray = dict[@"Data"];
    NSString *urlString = [[videoArray objectAtIndex:sender.tag] objectForKey:@"VideoLink"];
    [Utility showHelpAlertWithURL:urlString controller:self haveToPop:NO];
}
#pragma mark - End
#pragma mark - TableView DataSource & Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return helpArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = helpArray[section];
    NSArray *videoArray = dict[@"Data"];
    return videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier =@"HomeTableViewCell";
    HomeTableViewCell *cell = (HomeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (![Utility isEmptyCheck:helpArray]){
        NSDictionary *dict = helpArray[indexPath.section];
        NSArray *videoArray = dict[@"Data"];
        if (![Utility isEmptyCheck:videoArray]){
            cell.nameLabel.text = [[videoArray objectAtIndex:indexPath.row] objectForKey:@"Name"];
            cell.playButton.tag = indexPath.row;
            cell.playButton.accessibilityHint = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        }
    }
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, helpTable.frame.size.width, 30)];
    [myView setBackgroundColor:squadMainColor];
    UILabel *HeaderLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, myView.frame.size.width-20, myView.frame.size.height)];
    HeaderLabel.center = myView.center;
    [HeaderLabel setBackgroundColor:[UIColor clearColor]];
    [HeaderLabel setFont:[UIFont fontWithName:@"Raleway-SemiBold" size:17.0]];
    [HeaderLabel setTextColor:[UIColor whiteColor]];
    HeaderLabel.text = helpArray[section][@"Header"];
    
    [myView addSubview:HeaderLabel];
    return myView;
}
#pragma mark - End
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
