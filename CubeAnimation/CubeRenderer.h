//
//  CubeRenderer.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "NSBKeyframeAnimationFunctions.h"
typedef NS_ENUM(NSInteger, CubeTransitionDirection) {
    CubeTransitionDirectionLeftToRight = 0,
    CubeTransitionDirectionRightToLeft = 1,
};

@interface CubeRenderer : NSObject
- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView inContainerView:(UIView *)containerView direction:(CubeTransitionDirection)direction duration:(NSTimeInterval)duration screenScale:(CGFloat)screenScale timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion;
@end
