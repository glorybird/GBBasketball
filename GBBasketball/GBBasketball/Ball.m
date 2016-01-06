//
//  Ball.m
//  GBBasketball
//
//  Created by FanFamily on 16/1/6.
//  Copyright © 2016年 glorybird. All rights reserved.
//

#import "Ball.h"

@implementation Ball

- (instancetype)initWithPoint:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, [Ball size], [Ball size])];
    if (self) {
        
    }
    return self;
}

+ (CGFloat)size
{
    return 20.f;
}

- (UIDynamicItemCollisionBoundsType)collisionBoundsType
{
    return UIDynamicItemCollisionBoundsTypeEllipse;
}


@end
