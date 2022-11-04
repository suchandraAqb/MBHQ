//
//  QuoteTableViewCell.h
//  HorizentalVerticalScroll
//
//  Created by Suchandra Bhattacharya on 15/12/18.
//  Copyright © 2018 Suchandra Bhattacharya. All rights reserved.
//

@protocol QuoteSelectDelegate <NSObject>
@optional - (void)didSelectQuote:(NSDictionary *)quoteDict;

@end

#import <UIKit/UIKit.h>

@interface QuoteTableViewCell : UITableViewCell{
    id<QuoteSelectDelegate>delegate;
}
@property (nonatomic,strong)id delegate;
@property (strong,nonatomic) NSArray *quoteArr;
@end
