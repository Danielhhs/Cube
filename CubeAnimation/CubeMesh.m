//
//  CubeMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeMesh.h"

@implementation CubeMesh
- (instancetype) initWithView:(UIView *)view transitionDirection:(CubeTransitionDirection)direction
{
    return nil;
}

- (void) drawEntireMesh
{
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_SHORT, NULL);
}
@end
