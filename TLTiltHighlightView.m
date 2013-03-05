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

// Private properties.
@interface TLTiltHighlightView ()

// Our gradient layer.
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
// Our motion manager.
@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation TLTiltHighlightView

#pragma mark - Public Initializers

// Allows support for using instances loaded from nibs or storyboards.
-(id)initWithCoder:(NSCoder *)aCoder
{
    if (!(self = [super initWithCoder:aCoder])) return nil;
    
    [self setup];
    
    return self;
}

// Allows support for using instances instantiated programatically.
- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self setup];
    
    return self;
}

// We need to stop our motionManager from continuing to update once our instance is deallocated.
-(void)dealloc
{
    [self.motionManager stopAccelerometerUpdates];
}

#pragma mark - Private methods

// Sets up the initial state of the view.
-(void)setup
{
    // Set up the gradient
    [self setupGradient];
    // Set up our motion updates
    [self setupMotionDetection];
}

// Creates the gradient and sets up some default properties
-(void)setupGradient
{
    NSAssert(self.gradientLayer == nil, @"Gradient layer being set up more than once.");
    
    self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.18f];
    self.highlightColor = [UIColor colorWithWhite:1.0f alpha:0.36f];
    
    // Create a new, clear gradient layer and add it to our layer hierarchy.
    self.gradientLayer = [CAGradientLayer layer];
    [self.layer addSublayer:self.gradientLayer];
    self.gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
    // Make the layer gradient horizontal
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    // Set up the colours and position
    [self updateGradientColours];
    [self updateGradientLayerPosition];
}

// Starts the 
-(void)setupMotionDetection
{
    NSAssert(self.motionManager == nil, @"Motion manager being set up more than once.");
    
    // Set up a motion manager and start motion updates, calling deviceMotionDidUpdate: when updated.
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

// Updates the gradient layer to fill our bounds.
-(void)updateGradientLayerPosition
{
    if ([[UIScreen mainScreen] scale] > 1)
    {
        // Running on a retina device
        self.gradientLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 1.5f, CGRectGetWidth(self.bounds), 1.5f);
    }
    else
    {
        // Running on a non-Retina device
        self.gradientLayer.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 1, CGRectGetWidth(self.bounds), 1);
    }
}

// Updates the gradient's colours.
-(void)updateGradientColours
{
    self.gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                                  (id)[self.highlightColor CGColor],
                                  (id)[[UIColor clearColor] CGColor]];
}

#pragma mark CoreMotion Methods

-(void)deviceMotionDidUpdate:(CMDeviceMotion *)deviceMotion
{
    // Called when the deviceMotion property of our CMMotionManger updates.
    // Recalculates the gradient locations.
    
    // Ration from the center which the centre of the gradient is permitted to move.
    // (ie: the centre of the gradient may be 1/4 the distance of the view from the centre.)
    const CGFloat maxDistanceRatioFromCenter = 4.0f;
    
    // We need to account for the interface's orientation when calculating the relative roll. 
    CGFloat roll = 0.0f;
    switch ([[UIApplication sharedApplication] statusBarOrientation]) {
        case UIInterfaceOrientationPortrait:
            roll = deviceMotion.attitude.roll;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            roll = -deviceMotion.attitude.roll;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            roll = -deviceMotion.attitude.pitch;
            break;
        case UIInterfaceOrientationLandscapeRight:
            roll = deviceMotion.attitude.pitch;
            break;
    }
    
    // This will give us an interpolated value [-0.4 ... 0.4].
    CGFloat interpolatedValue = sinf(roll) / maxDistanceRatioFromCenter;
    
    // We need to convert our ration to a decimal (0.4, in this case).
    CGFloat maxDistanceDecimalFromCenter = maxDistanceRatioFromCenter / 10.0f;
    
    // Find the middle position for our gradient. This needs to be in the range of [0 ... 1].
    CGFloat gradientMiddlePosition = (interpolatedValue + maxDistanceDecimalFromCenter) / (maxDistanceDecimalFromCenter * 2.0f);
    
    // Finally, update our gradient layer. 
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
