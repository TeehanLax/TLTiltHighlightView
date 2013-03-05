//
//  TLTiltHighlightView.h
//  TLTiltHighlightView
//
//  Created by Ash Furrow on 2013-03-05.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Provides a view with a horizontal gradient whose position updates to the current
/// positional attitude of the device, much like Music.app in iOS 6.
///
/// The default background colour of this view is 18% opaque white.
@interface TLTiltHighlightView : UIView

/// The highlight colour used in our gradient.
///
/// The gradient will range from clear to the `highlightColor`, back to clear.
/// Default is white at 36% opacity. 
@property (nonatomic, strong) UIColor *highlightColor;

@end
