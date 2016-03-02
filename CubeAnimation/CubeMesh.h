//
//  CubeMesh.h
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "SceneMesh.h"


typedef NS_ENUM(NSInteger, CubeTransitionDirection) {
    CubeTransitionDirectionLeftToRight = 0,
    CubeTransitionDirectionRightToLeft = 1,
    CubeTransitionDirectionTopToBottom = 2,
    CubeTransitionDirectionBottomToTop = 3,
};

@interface CubeMesh : SceneMesh

@property (nonatomic) NSInteger indexCount;
- (instancetype) initWithView:(UIView *)view columnCount:(NSInteger)columnCount transitionDirection:(CubeTransitionDirection)direction;
@property (nonatomic) NSInteger columnCount;

- (void) drawColumnAtIndex:(NSInteger)index;
@end
