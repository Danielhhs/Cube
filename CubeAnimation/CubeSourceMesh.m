//
//  CubeMesh.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeSourceMesh.h"
@interface CubeSourceMesh() {
    SceneMeshVertex *vertices;
}
@property (nonatomic) NSInteger vertexCount;
@property (nonatomic) NSInteger indexCount;
@end

@implementation CubeSourceMesh

- (instancetype) initWithView:(UIView *)view
{
    _vertexCount = 4;
    _indexCount = 6;
    vertices = malloc(_vertexCount * sizeof(SceneMeshVertex));
    
    vertices[0].position = GLKVector3Make(0, 0, 0);
    vertices[0].texCoords = GLKVector2Make(0, 1);
    vertices[1].position = GLKVector3Make(view.frame.size.width, 0, 0);
    vertices[1].texCoords = GLKVector2Make(1, 1);
    vertices[2].position = GLKVector3Make(0, view.frame.size.height, 0);
    vertices[2].texCoords = GLKVector2Make(0, 0);
    vertices[3].position = GLKVector3Make(view.frame.size.width, view.frame.size.height, 0);
    vertices[3].texCoords = GLKVector2Make(1, 0);
    GLushort indices[6] = {0, 1, 2, 2, 1, 3};
    NSData *vertexData = [NSData dataWithBytes:vertices length:_vertexCount * sizeof(SceneMeshVertex)];
    NSData *indexData = [NSData dataWithBytes:indices length:sizeof(indices)];
    return [self initWithVerticesData:vertexData indicesData:indexData];
}

- (void) drawEntireMesh
{
    glDrawElements(GL_TRIANGLES, (GLsizei)self.indexCount, GL_UNSIGNED_SHORT, NULL);
}
@end
