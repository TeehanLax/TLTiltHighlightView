//
//  TLViewController.m
//  TLTiltHighlightView
//
//  Created by Ash Furrow on 2013-03-05.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//

#import "TLViewController.h"

#import "TLTiltHighlightView.h"

@interface TLViewController ()

@end

@implementation TLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    TLTiltHighlightView *highlightView = [[TLTiltHighlightView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.bounds), 2)];
    highlightView.highlightColor = [UIColor redColor];
    highlightView.backgroundColor = [UIColor clearColor];
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:highlightView];
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
