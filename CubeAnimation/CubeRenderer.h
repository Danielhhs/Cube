//
//  CubeRenderer.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "NSBKeyframeAnimationFunctions.h"
#import "CubeMesh.h"
@interface CubeRenderer : NSObject
- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(CubeTransitionDirection)direction duration:(NSTimeInterval)duration screenScale:(CGFloat)screenScale timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion;
@end
