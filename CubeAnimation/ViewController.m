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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"image.jpg"];
    [self.view addSubview:imageView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 50)];
    [button setTitle:@"Notification" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleNotification
{
    
    self.renderer = [[CubeRenderer alloc] init];
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    fromImageView.image = [self imageFromImage:[UIImage imageNamed:@"image.jpg"] inRect:fromImageView.frame];
    UIImageView *toImageView = [[UIImageView alloc] initWithFrame:fromImageView.frame];
    toImageView.image = [self imageFromImage:[UIImage imageNamed:@"toImage.jpg"] inRect:fromImageView.frame];
    [self.renderer startCubeTransitionFromView:fromImageView toView:toImageView inContainerView:self.view direction:CubeTransitionDirectionTopToBottom duration:1 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInBack completion:nil];
}

- (UIImage *) imageFromImage:(UIImage *)srcImage inRect:(CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(srcImage.size, YES, 0.F);
    [srcImage drawInRect:CGRectMake(0, 0, srcImage.size.width, srcImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef croppedImage = CGImageCreateWithImageInRect(image.CGImage, rect);
    image = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    UIGraphicsEndImageContext();
    return image;
}

@end
