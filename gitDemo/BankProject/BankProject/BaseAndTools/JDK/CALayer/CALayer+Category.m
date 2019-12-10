//
//  CALayer+Category.m
//  Bicycle
//
//  Created by mc on 2019/5/13.
//  Copyright © 2019 mc. All rights reserved.
//

#import "CALayer+Category.h"

@implementation CALayer (Category)

- (void)setBorderUIColor:(UIColor*)color
{
    self.borderColor= color.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}
@end
