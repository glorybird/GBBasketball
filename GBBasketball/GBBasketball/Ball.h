//
//  Ball.h
//  GBBasketball
//
//  Created by FanFamily on 16/1/6.
//  Copyright © 2016年 glorybird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ball : UIImageView <UIDynamicItem>

- (instancetype)initWithPoint:(CGPoint)point;

+ (CGFloat)size;

@end
