//
//  CubeDestinationMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeDestinationMesh.h"
@interface CubeDestinationMesh() {
    SceneMeshVertex *vertices;
}
@property (nonatomic) NSInteger vertexCount;
@end

@implementation CubeDestinationMesh

- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(CubeTransitionDirection)direction
{
    _vertexCount = 4;
    self.indexCount = 6;
    vertices = malloc(_vertexCount * sizeof(SceneMeshVertex));
    
    [self setupVerticesForView:view direction:direction];
    vertices[0].texCoords = GLKVector2Make(0, 1);
    vertices[1].texCoords = GLKVector2Make(1, 1);
    vertices[2].texCoords = GLKVector2Make(0, 0);
    vertices[3].texCoords = GLKVector2Make(1, 0);
    
    GLushort indices[6] = {0, 1, 2, 2, 1, 3};
    NSData *vertexData = [NSData dataWithBytes:vertices length:_vertexCount * sizeof(SceneMeshVertex)];
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(indices)];
    return [self initWithVerticesData:vertexData indicesData:indexData];
}

- (void) setupVerticesForView:(UIView *)view direction:(CubeTransitionDirection)direction
{
    switch (direction) {
        case CubeTransitionDirectionRightToLeft:
        {
            vertices[0].position = GLKVector3Make(view.frame.size.width, 0, 0);
            vertices[1].position = GLKVector3Make(view.frame.size.width, 0, -view.frame.size.width);
            vertices[2].position = GLKVector3Make(view.frame.size.width, view.frame.size.height, 0);
            vertices[3].position = GLKVector3Make(view.frame.size.width, view.frame.size.height, -view.frame.size.width);
        }
            break;
        case CubeTransitionDirectionLeftToRight:
        {
            vertices[0].position = GLKVector3Make(0, 0, -view.frame.size.width);
            vertices[1].position = GLKVector3Make(0, 0, 0);
            vertices[2].position = GLKVector3Make(0, view.frame.size.height, -view.frame.size.width);
            vertices[3].position = GLKVector3Make(0, view.frame.size.height, 0);
        }
            break;
        case CubeTransitionDirectionTopToBottom:
        {
            vertices[0].position = GLKVector3Make(0, view.bounds.size.height, 0);
            vertices[1].position = GLKVector3Make(view.bounds.size.width, view.bounds.size.height, 0);
            vertices[2].position = GLKVector3Make(0, view.frame.size.height, -view.bounds.size.height);
            vertices[3].position = GLKVector3Make(view.bounds.size.width, view.frame.size.height, -view.bounds.size.height);
        }
            break;
        case CubeTransitionDirectionBottomToTop:
        {
            vertices[0].position = GLKVector3Make(0, 0, -view.bounds.size.height);
            vertices[1].position = GLKVector3Make(view.bounds.size.width, 0, -view.bounds.size.height);
            vertices[2].position = GLKVector3Make(0, 0, 0);
            vertices[3].position = GLKVector3Make(view.bounds.size.width, 0, 0);
        }
            break;
        default:
            break;
    }
}
@end
