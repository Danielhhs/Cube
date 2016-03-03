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
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 100, 40)];
    [button setTitle:@"Notification" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    UIButton *recoverButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 300, 100, 40)];
    [recoverButton setTitle:@"Recover" forState:UIControlStateNormal];
    [recoverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [recoverButton addTarget:self action:@selector(handleRecover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverButton];
    
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 40)];
    [leftButton setTitle:@"Notification" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(handleLeftNotification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    UIButton *leftRecoverButton = [[UIButton alloc] initWithFrame:CGRectMake(230, 400, 100, 40)];
    [leftRecoverButton setTitle:@"Recover" forState:UIControlStateNormal];
    [leftRecoverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftRecoverButton addTarget:self action:@selector(handleLeftRecover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftRecoverButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) handleNotification
{
    self.renderer = [[CubeRenderer alloc] init];
//    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    fromImageView.image = [self imageFromView:self.view inRect:fromImageView.frame];
    UIImageView *toImageView = [[UIImageView alloc] initWithFrame:fromImageView.frame];
    toImageView.image = [self imageFromImage:[UIImage imageNamed:@"toImage.jpg"] inRect:fromImageView.frame];
    [self.renderer startCubeTransitionFromView:fromImageView toView:toImageView columnCount:5 inContainerView:self.view direction:CubeTransitionDirectionTopToBottom duration:3 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInOutBack completion:nil];
}


- (void) handleLeftNotification
{
    self.renderer = [[CubeRenderer alloc] init];
    //    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    fromImageView.image = [self imageFromView:self.view inRect:fromImageView.frame];
    UIImageView *toImageView = [[UIImageView alloc] initWithFrame:fromImageView.frame];
    toImageView.image = [self imageFromImage:[UIImage imageNamed:@"toImage.jpg"] inRect:fromImageView.frame];
    [self.renderer startCubeTransitionFromView:fromImageView toView:toImageView columnCount:5 inContainerView:self.view direction:CubeTransitionDirectionRightToLeft duration:3 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInOutBack completion:nil];
}

- (void) handleLeftRecover
{
    self.renderer = [[CubeRenderer alloc] init];
//    UIImageView * toImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, self.view.bounds.size.height)];
    UIImageView * toImageView= [[UIImageView alloc] initWithFrame:self.view.bounds];
    toImageView.image = [self imageFromView:self.view inRect:toImageView.frame];
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:toImageView.frame];
    fromImageView.image = [self imageFromImage:[UIImage imageNamed:@"toImage.jpg"] inRect:toImageView.frame];
    [self.renderer startCubeTransitionFromView:fromImageView toView:toImageView columnCount:5 inContainerView:self.view direction:CubeTransitionDirectionLeftToRight duration:3 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInOutBack completion:nil];
}

- (void) handleRecover
{
    self.renderer = [[CubeRenderer alloc] init];
    //    UIImageView * toImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, self.view.bounds.size.height)];
    UIImageView * toImageView= [[UIImageView alloc] initWithFrame:self.view.bounds];
    toImageView.image = [self imageFromView:self.view inRect:toImageView.frame];
    UIImageView *fromImageView = [[UIImageView alloc] initWithFrame:toImageView.frame];
    fromImageView.image = [self imageFromImage:[UIImage imageNamed:@"toImage.jpg"] inRect:toImageView.frame];
    [self.renderer startCubeTransitionFromView:fromImageView toView:toImageView columnCount:5 inContainerView:self.view direction:CubeTransitionDirectionBottomToTop duration:3 screenScale:[UIScreen mainScreen].scale timingFunction:NSBKeyframeAnimationFunctionEaseInOutBack completion:nil];
}

- (UIImage *) imageFromImage:(UIImage *)srcImage inRect:(CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 2.);
    CGImageRef croppedImage = CGImageCreateWithImageInRect(srcImage.CGImage, rect);
    UIImage * image = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *) imageFromView:(UIView *)view inRect:(CGRect)rect
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGImageRef croppedImage = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(rect.origin.x * 2, rect.origin.y * 2, rect.size.width * 2, rect.size.height * 2));
    image = [UIImage imageWithCGImage:croppedImage];
    CGImageRelease(croppedImage);
    UIGraphicsEndImageContext();
    return image;
}

@end
