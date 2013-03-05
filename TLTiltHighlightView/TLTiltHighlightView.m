//
//  TLTiltHighlightView.m
//  TLTiltHighlightView
//
//  Created by Ash Furrow on 2013-03-05.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>

#import "TLTiltHighlightView.h"

@interface TLTiltHighlightView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation TLTiltHighlightView

#pragma mark - Public Initializers

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self setup];
    
    return self;
}

-(void)dealloc
{
    [self.motionManager stopAccelerometerUpdates];
}

#pragma mark - Private methods

-(void)setup
{
    [self setupGradient];
    [self setupMotionDetection];
}

-(void)setupGradient
{
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.18f];
    self.highlightColor = [UIColor whiteColor];
    
    // Set up our gradient views
    if (!self.gradientLayer)
    {
        self.gradientLayer = [CAGradientLayer layer];        
        [self.layer addSublayer:self.gradientLayer];
        self.gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    }
    
    [self updateGradientColours];
    [self updateGradientLayerPosition];
}

-(void)setupMotionDetection
{
    if (!self.motionManager)
    {
        self.motionManager = [[CMMotionManager alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            if (error)
            {
                [weakSelf.motionManager stopDeviceMotionUpdates];
                return;
            }
            
            [weakSelf deviceMotionDidUpdate:motion];
        }];
    }
}

-(void)updateGradientLayerPosition
{
    self.gradientLayer.frame = self.bounds;
}

-(void)updateGradientColours
{
    self.gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor], (id)[self.highlightColor CGColor], (id)[[UIColor clearColor] CGColor]];
}

#pragma mark CoreMotion Methods

-(void)deviceMotionDidUpdate:(CMDeviceMotion *)deviceMotion
{
    const CGFloat maxDistanceRatioFromCenter = 3.0f;
    
    CGFloat roll = deviceMotion.attitude.roll;
    CGFloat interpolatedValue = sinf(roll) / maxDistanceRatioFromCenter;
    
    CGFloat maxDistanceDecimalFromCenter = maxDistanceRatioFromCenter / 10.0f;
    
    CGFloat gradientMiddlePosition = (interpolatedValue + maxDistanceDecimalFromCenter) / (maxDistanceDecimalFromCenter * 2.0f);
    
    self.gradientLayer.locations = @[@(0), @(gradientMiddlePosition), @(1)];
}

#pragma mark Overridden Methods

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self updateGradientLayerPosition];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    [self updateGradientLayerPosition];
}

#pragma mark - Overridden Properties

-(void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    
    [self updateGradientColours];
}

@end
