//
//  UILabel+ActionSheet.m
//  Testplus
//
//  Created by Muhammad Ali Yousaf on 16/12/2014.
//  Copyright (c) 2014 Muhammad Ali Yousaf. All rights reserved.
//

#import "UILabel+ActionSheet.h"

@implementation UILabel (FontAppearance)

-(void)setAppearanceFont:(UIFont *)font {
    if (font)
        [self setFont:font];
}

-(UIFont *)appearanceFont {
    return self.font;
}

-(void)setAppearanceColor:(UIColor *)appearanceColor {
    if (appearanceColor)
        [self setTextColor:appearanceColor];
}

-(UIColor *)appearanceColor {
    return self.textColor;
}
-(void)setAppearanceTextAlignment:(NSTextAlignment)appearanceTextAlignment {
    if (appearanceTextAlignment)
        [self setTextAlignment:appearanceTextAlignment];
}

-(NSTextAlignment)appearanceTextAlignment {
    return self.textAlignment;
}

@end
