//
//  ViewController.m
//  GBBasketball
//
//  Created by FanFamily on 16/1/6.
//  Copyright © 2016年 glorybird. All rights reserved.
//

#import "ViewController.h"
#import "Ball.h"

@interface ViewController ()

@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) Ball* ball;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 安装球
    [self setUpBall];
}

- (void)setUpBall
{
    self.ball = [[Ball alloc] initWithPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height - [Ball size])];
    [self.ball setBackgroundColor:[UIColor blueColor]];
    self.ball.layer.cornerRadius = [Ball size]/2;
    [self.view addSubview:self.ball];
    
    // 加重力
    UIGravityBehavior* gravity = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    [self.animator addBehavior:gravity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
