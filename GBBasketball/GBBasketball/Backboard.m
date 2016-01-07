//
//  Backboard.m
//  GBBasketball
//
//  Created by FanFamily on 16/1/7.
//  Copyright © 2016年 glorybird. All rights reserved.
//

#import "Backboard.h"

@implementation Backboard

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10);
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0);
    CGContextStrokeRect(context, rect);
    
    CGRect inRect = CGRectInset(rect, 50, 50);
    inRect = CGRectOffset(inRect, inRect.size.width/2 - inRect.size.height/2, 30);
    if (inRect.size.width > inRect.size.height) {
        inRect.size.width = inRect.size.height;
    }
    CGContextStrokeRect(context, inRect);
}

@end
