//
//  ViewController.m
//  SwipeGolf
//
//  Created by Mihai A Ruber on 2/5/17.
//  Copyright © 2017 Mihai A Ruber. All rights reserved.
//

#import "ViewController.h"

#define speedScale 0.20
#define speedDamping 0.90
#define stopSpeed 5.0

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *holeImage;
@property (weak, nonatomic) IBOutlet UIImageView *ballImage;

@property (nonatomic) CGPoint firstPoint;
@property (nonatomic) CGPoint lastPoint;

@property (nonatomic) float ballVelocityX;
@property (nonatomic) float ballVelocityY;
@property (nonatomic) int tiltSpeed;

@property (nonatomic) NSTimer *gameTimer;
@property (nonatomic) NSTimer *placeBallTimer;


@property (weak, nonatomic) IBOutlet UIImageView *rightTilt;
@property (weak, nonatomic) IBOutlet UIImageView *leftTilt;
@property (weak, nonatomic) IBOutlet UILabel *tiltLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.holeImage.layer.cornerRadius = .5*self.holeImage.layer.frame.size.height;
    self.holeImage.layer.masksToBounds = YES;
    [self.placeBall];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)placeBall {
    
    self.ballImage.alpha = 1.0;
    [self.view setUserInteractionEnabled: YES];
    
    self.ballImage.center = CGPointMake(.5*(UIScreen mainScreen).bounds.size.width, .85*[UIScreen mainScreen].bounds.size.height);
    
    [self addTilt];
}


-(void)addTilt {
    
    int minTilt = -9;
    int maxTilt = 9;
    
    NSString *tiltString;
    
    self.tiltSpeed = (arc4random() % (maxTilt - minTilt + 1)) + minTilt; //0 - 18, + -9, -9 - 9
    
    self.leftTilt.hidden = YES;
    self.rightTilt.hidden = YES;
    
    if (self.tiltSpeed == 0) {
        tiltString = [NSString stringWithFormat:@"Flat"];
    }
    
    if (self.tiltSpeed == 1) {
        tiltString = @"1 inch";
        self.rightTilt.hidden = NO;
    }
    
    if (self.tiltSpeed > 1) {
        tiltString = [NSString stringWithFormat:@"%d inches", self.tiltSpeed];
        self.rightTilt.hidden = NO;
    }
    
    if (self.tiltSpeed = -1) {
        tiltString = @"1 inch";
        self.leftTilt.hidden = NO;
    }
    
    if (self.tiltSpeed < -1) {
        tiltString = [NSString stringWithFormat:@"%d inches", -self.tiltSpeed];
        self.leftTilt.hidden = NO;
    }
    
    self.tiltlabel.text = tiltString;
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    [self.view setUserInteractionEnabled:NO];
    self.firstPoint = [touch locationInView:self.view];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    self.lastPoint = [touch locationInView:self.view];
    
    CGPoint swipeVector = CGPointMake(self.lastPoint.x - self.firstPoint.x, self.lastPoint.y - self.firstPoint.y);
    
    self.ballVelocityX = speedScale*swipeVector.x;
    self.ballVelocityY = speedScale*swipeVector.y;
    
    self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(moveBall) userInfo:nil repeats:YES];

}

-(void)moveBall {
    
    self.ballVelocityX = speedDamping*self.ballVelocityX;
    self.ballVelocityY = speedDamping*self.ballVelocityY;

    
    self.ballImage.center = CGPointMake(self.ballImage.center.x + self.ballVelocityX + self.tiltSpeed, self.ballImage.center.y + self.ballVelocityY);
    
    if (CGRectIntersectsRect(self.ballImage.frame, self.holeImage.frame)) {
        
        [self.gameTimer invalidate];
        
        self.ballImage.center = CGPointMake(self.holeImage.center.x, self.holeImage.center.y);
        self.ballImage.alpha = 0.2;
        
        self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector@selector (placeBall) userInfo:nil repeats:NO];
    }
    
    
    
    if (fabs(self.ballVelocityX) < stopSpeed && fabs(self.ballVelocityY) < stopSpeed) {
    
        [self.gameTimer invalidate];
        self.placeBallTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector@selector (placeBall) userInfo:nil repeats:NO];

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end














