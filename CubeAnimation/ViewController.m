//
//  ViewController.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "ViewController.h"
#import "CubeRenderer.h"
@interface ViewController ()
@property (nonatomic, strong) CubeRenderer *renderer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.renderer = [[CubeRenderer alloc] init];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, self.view.bounds.size.height)];
    imageView.image = [UIImage imageNamed:@"image.jpg"];
    UIImageView *toImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, self.view.bounds.size.height)];
    toImageView.image = [UIImage imageNamed:@"toImage.jpg"];
    [self.renderer startCubeTransitionFromView:imageView toView:toImageView inContainerView:self.view direction:CubeTransitionDirectionLeftToRight duration:1 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInBack completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
