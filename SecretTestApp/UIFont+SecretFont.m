//
//  UIFont+secretFont.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/29/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "UIFont+secretFont.h"

@implementation UIFont (secretFont)

+ (UIFont *)secretFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:size];
}

+ (UIFont *)secretFontLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:size];
}
@end
