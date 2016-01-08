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
@property (nonatomic) UIPushBehavior* ballUpPushBehavior;
@property (nonatomic) UIGravityBehavior* gravity;
@property (weak, nonatomic) IBOutlet UIView *leftCube;
@property (weak, nonatomic) IBOutlet UIView *rightCube;
@property (weak, nonatomic) IBOutlet UIImageView *topCover;

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
        
        // 根据偏移调整重力
        float c = atanf(fabs(accelerometerData.acceleration.y)/fabs(accelerometerData.acceleration.x));
        if (accelerometerData.acceleration.x < 0) {
            c = M_PI - c;
        }
        self.gravity.angle = c;
        
        // 摇一摇
        if (fabs(accelerometerData.acceleration.x)>2.0 || fabs(accelerometerData.acceleration.y)>2.0 || fabs(accelerometerData.acceleration.z) >2.0 ) {
            [self pushUp:nil];
        }
    }];
    
    [self.view bringSubviewToFront:self.topCover];
}

- (void)setUpBall
{
    self.ball = [[Ball alloc] initWithPoint:CGPointMake(50, [UIScreen mainScreen].bounds.size.height - [Ball size])];
    [self.ball setBackgroundColor:[UIColor blueColor]];
    self.ball.layer.cornerRadius = [Ball size]/2;
    [self.view addSubview:self.ball];
    
    // 加重力
    self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.ball]];
    self.gravity.magnitude = 1.f;
    [self.animator addBehavior:self.gravity];
    
    // 加摩擦力
    UIDynamicItemBehavior* item = [[UIDynamicItemBehavior alloc] initWithItems:@[self.ball]];
    item.elasticity = 1.f;
    item.friction = .1f;
    item.allowsRotation = YES;
    [self.animator addBehavior:item];
    
    // 加边界
    UICollisionBehavior* collision = [[UICollisionBehavior alloc] initWithItems:@[self.ball]];
    [collision addBoundaryWithIdentifier:@"left" fromPoint:CGPointMake(0, -2000) toPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height)];
    [collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, [UIScreen mainScreen].bounds.size.height) toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [collision addBoundaryWithIdentifier:@"right" fromPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, -2000)];
    [collision addBoundaryWithIdentifier:@"top" fromPoint:CGPointMake(0, -2000) toPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, -2000)];
    [self.animator addBehavior:collision];
    
    // 加碰撞
    /*UIAttachmentBehavior* leftFixed = [UIAttachmentBehavior fixedAttachmentWithItem:self.leftCube attachedToItem:self.view attachmentAnchor:self.leftCube.center];
    UIAttachmentBehavior* rightFixed = [UIAttachmentBehavior fixedAttachmentWithItem:self.leftCube attachedToItem:self.view attachmentAnchor:self.rightCube.center];
    [self.animator addBehavior:leftFixed];
    [self.animator addBehavior:rightFixed];*/
    UIAttachmentBehavior* leftFixed = [[UIAttachmentBehavior alloc] initWithItem:self.leftCube attachedToAnchor:self.leftCube.center];
    UIAttachmentBehavior* rightFixed = [[UIAttachmentBehavior alloc] initWithItem:self.rightCube attachedToAnchor:self.rightCube.center];
    [self.animator addBehavior:leftFixed];
    [self.animator addBehavior:rightFixed];
    
    UICollisionBehavior* collisions = [[UICollisionBehavior alloc] initWithItems:@[self.ball, self.leftCube, self.rightCube]];
    [self.animator addBehavior:collisions];
}

- (IBAction)pushUp:(id)sender {
    // 加上升力
    self.ballUpPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
    [self.ballUpPushBehavior setAngle:-M_PI/2 magnitude:.8f];
    [self.animator addBehavior:self.ballUpPushBehavior];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
