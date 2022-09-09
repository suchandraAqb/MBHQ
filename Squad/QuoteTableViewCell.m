//
//  QuoteTableViewCell.m
//  HorizentalVerticalScroll
//
//  Created by Suchandra Bhattacharya on 15/12/18.
//  Copyright © 2018 Suchandra Bhattacharya. All rights reserved.
//

#import "QuoteTableViewCell.h"
#import "QuiteCollectionViewCell.h"

@implementation QuoteTableViewCell
{
    IBOutlet UICollectionView *quoteCollectionView;
    
}
@synthesize delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _quoteArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"QuiteCollectionViewCell";
    
    QuiteCollectionViewCell *cell = (QuiteCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.quoteStrLabel.text = [@"" stringByAppendingFormat:@"%ld",(long)indexPath.row];
    if (![Utility isEmptyCheck:_quoteArr]) {
        if (![Utility isEmptyCheck:_quoteArr[indexPath.row]]) {
            NSDictionary *dict = _quoteArr[indexPath.row];
            
            NSString *quote = !([Utility isEmptyCheck:dict[@"QUOTE"]])?[dict[@"QUOTE"] uppercaseString]:@"";
            NSString *credit = !([Utility isEmptyCheck:dict[@"Credit"]])?[dict[@"Credit"] uppercaseString]:@"-UNKNOWN-";
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@"%@",quote]];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Regular" size:9] range:NSMakeRange(0, [attributedString length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString length])];
            
            NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:[@"" stringByAppendingFormat:@"\n\n%@",credit]];
            [attributedString1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-RegularItalic" size:7] range:NSMakeRange(0, [attributedString1 length])];
            [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString1 length])];
            
            [attributedString appendAttributedString:attributedString1];
            
            NSMutableAttributedString *attributedString2 =[[NSMutableAttributedString alloc]initWithString:@"\n\n\nASHYBINES"];
            [attributedString2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Oswald-Bold" size:7] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributedString2 length])];
            [attributedString appendAttributedString:attributedString2];
            cell.quoteStrLabel.attributedText = attributedString;
            
            if (![Utility isEmptyCheck:[dict objectForKey:@"favStatus"]]) {
                NSString *favStatusStr =[dict objectForKey:@"favStatus"];
                if ([favStatusStr isEqualToString:@"0"]) {
                    cell.quoteCellHeartButton.selected = false;
                }else{
                    cell.quoteCellHeartButton.selected = true;
                }
               
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![Utility isEmptyCheck:_quoteArr]) {
        if (![Utility isEmptyCheck:_quoteArr[indexPath.row]]) {
            NSDictionary *dict = _quoteArr[indexPath.row];
            
            if([delegate respondsToSelector:@selector(didSelectQuote:)]){
                [delegate didSelectQuote:dict];
            }
        }
    }
    
}
@end
