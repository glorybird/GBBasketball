//
//  ViewController.m
//  GBBasketball
//
//  Created by FanFamily on 16/1/6.
//  Copyright © 2016年 glorybird. All rights reserved.
//

#import "ViewController.h"
#import "Ball.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) Ball* ball;
@property (nonatomic) CMMotionManager * motionManager;
@property (nonatomic) UIPushBehavior* ballPushBehavior;
@property (nonatomic) UIGravityBehavior* gravity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 安装球
    [self setUpBall];
    
    // 初始化加速器
    self.motionManager = [[CMMotionManager alloc] init];
    if (!self.motionManager.accelerometerActive) {
        NSLog(@"此设备不支持加速!");
    }
    self.motionManager.accelerometerUpdateInterval = 1.0f/10.f;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        // NSLog(@"x: %f, y: %f, z: %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
        float c = atanf(fabs(accelerometerData.acceleration.y)/fabs(accelerometerData.acceleration.x));
        if (accelerometerData.acceleration.x < 0) {
            c = M_PI - c;
        }
        self.gravity.angle = c;
    }];
}

- (void)setUpBall
{
    self.ball = [[Ball alloc] initWithPoint:CGPointMake(50, [UIScreen mainScreen].bounds.size.height - [Ball size])];
    [self.ball setBackgroundColor:[UIColor blueColor]];
    self.ball.layer.cornerRadius = [Ball size]/2;
    [self.view addSubview:self.ball];
    
    // 加重力
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    [self.animator addBehavior:self.gravity];
    
    // 加摩擦力
    UIDynamicItemBehavior* item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
    item.elasticity = 0.f;
    item.friction = 1.f;
    item.resistance = 0;
    item.angularResistance = 0;
    [self.animator addBehavior:item];
    
    // 加边界
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[self.ball]];
    [collision setTranslatesReferenceBoundsIntoBoundary:YES];
    [self.animator addBehavior:collision];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
