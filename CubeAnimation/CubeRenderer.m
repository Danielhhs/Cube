//
//  CubeRenderer.m
//  CubeAnimation
//
//  Created by Huang Hongsen on 2/14/16.
//  Copyright © 2016 cn.daniel. All rights reserved.
//

#import "CubeRenderer.h"
#import "OpenGLHelper.h"
#import "CubeSourceMesh.h"
#import "CubeDestinationMesh.h"
@interface CubeRenderer ()<GLKViewDelegate> {
    GLuint srcFaceProgram, srcFacePercentLoc, srcMvpLoc, srcFaceSamplerLoc, srcFaceEdgeWidthLoc, srcDirectionLoc;
    GLuint dstFaceProgram, dstFacePercentLoc, dstMvpLoc, dstFaceSamplerLoc, dstFaceEdgeWidthLoc, dstDirectionLoc;
    GLuint srcTexture;
    GLuint dstTexture;
    GLfloat percent;
    GLKMatrix4 mvpMatrix;
}
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic, strong) void (^completion)(void);
@property (nonatomic) NSBKeyframeAnimationFunction timingFunction;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) GLKView *animationView;
@property (nonatomic, strong) CubeSourceMesh *sourceMesh;
@property (nonatomic, strong) CubeDestinationMesh *destinationMesh;
@property (nonatomic) CubeTransitionDirection direction;
@property (nonatomic) GLfloat edgeWidth;
@end

@implementation CubeRenderer

- (void) startCubeTransitionFromView:(UIView *)fromView toView:(UIView *)toView columnCount:(NSInteger)columnCount inContainerView:(UIView *)containerView direction:(CubeTransitionDirection)direction duration:(NSTimeInterval)duration screenScale:(CGFloat)screenScale timingFunction:(NSBKeyframeAnimationFunction)timingFunction completion:(void (^)(void))completion
{
    self.duration = duration;
    self.completion = completion;
    self.timingFunction = timingFunction;
    self.elapsedTime = 0;
    self.direction = direction;
    
    percent = 0;
    [self generateEdgeWidthForView:fromView columnCount:columnCount];
    [self setupOpenGL];
    [self setupTexturesWithSource:fromView destination:toView screenScale:screenScale];
    self.animationView = [[GLKView alloc] initWithFrame:fromView.frame context:self.context];
    self.animationView.delegate = self;
    self.sourceMesh = [[CubeSourceMesh alloc] initWithView:fromView columnCount:columnCount transitionDirection:direction];
    self.destinationMesh = [[CubeDestinationMesh alloc] initWithView:toView columnCount:columnCount transitionDirection:direction];
    [containerView addSubview:self.animationView];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void) generateEdgeWidthForView:(UIView *)view columnCount:(NSInteger)columnCount
{
    switch (self.direction) {
        case CubeTransitionDirectionTopToBottom:
        case CubeTransitionDirectionBottomToTop:
            self.edgeWidth = view.frame.size.height / columnCount;
            break;
        case CubeTransitionDirectionRightToLeft:
        case CubeTransitionDirectionLeftToRight:
            self.edgeWidth = view.frame.size.width / columnCount;
            break;
        default:
            break;
    }
}

#pragma mark - Drawing
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    GLfloat aspect = (GLfloat)view.bounds.size.width / view.bounds.size.height;
    GLKMatrix4 modelView = GLKMatrix4Translate(GLKMatrix4Identity, -view.bounds.size.width / 2, -view.bounds.size.height / 2, -view.bounds.size.height / 2 / tan(M_PI / 24) - 100);
        GLKMatrix4 perspective = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(15), aspect, 1, 10000);
    mvpMatrix = GLKMatrix4Multiply(perspective, modelView);
    
    if (percent <= 0.5) {
        [self drawDestinationFaceInView:view];
        [self drawSourceFaceInView:view];
    } else {
        [self drawSourceFaceInView:view];
        [self drawDestinationFaceInView:view];
    }
}

- (void) drawDestinationFaceInView:(GLKView *)view;
{
    glUseProgram(dstFaceProgram);
    glUniformMatrix4fv(dstMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(dstFacePercentLoc, percent);
    glUniform1f(dstFaceEdgeWidthLoc, self.edgeWidth);
    glUniform1i(dstDirectionLoc, self.direction);
    [self.destinationMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, dstTexture);
    glUniform1i(dstFaceSamplerLoc, 0);
    [self.destinationMesh drawEntireMesh];
}

- (void) drawSourceFaceInView:(GLKView *)view {
    glUseProgram(srcFaceProgram);
    glUniformMatrix4fv(srcMvpLoc, 1, GL_FALSE, mvpMatrix.m);
    glUniform1f(srcFacePercentLoc, percent);
    glUniform1f(srcFaceEdgeWidthLoc, self.edgeWidth);
    glUniform1i(srcDirectionLoc, self.direction);
    [self.sourceMesh prepareToDraw];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, srcTexture);
    glUniform1i(srcFaceSamplerLoc, 0);
    [self.sourceMesh drawEntireMesh];
}

- (void) update:(CADisplayLink *)displayLink
{
    self.elapsedTime += displayLink.duration;
    if (self.elapsedTime < self.duration) {
        GLfloat populatedTime = self.timingFunction(self.elapsedTime * 1000, 0, 1, self.duration * 1000);
        percent = populatedTime / self.duration;
        [self.animationView display];
    } else {
        percent = 1;
        [self.animationView display];
        [self.animationView removeFromSuperview];
        [self tearDownGL];
        if (self.completion) {
            self.completion();
        }
    }
}

#pragma mark - OpenGL
- (void) setupOpenGL
{
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:self.context];
    srcFaceProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"CubeSourceVertex.glsl" fragmentShaderSrc:@"CubeSourceFragment.glsl"];
    dstFaceProgram = [OpenGLHelper loadProgramWithVertexShaderSrc:@"CubeDestinationVertex.glsl" fragmentShaderSrc:@"CubeDestinationFragment.glsl"];
    glUseProgram(srcFaceProgram);
    srcMvpLoc = glGetUniformLocation(srcFaceProgram, "u_mvpMatrix");
    srcFacePercentLoc = glGetUniformLocation(srcFaceProgram, "u_percent");
    srcFaceEdgeWidthLoc = glGetUniformLocation(srcFaceProgram, "u_edgeWidth");
    srcFaceSamplerLoc = glGetUniformLocation(srcFaceSamplerLoc, "s_tex");
    srcDirectionLoc = glGetUniformLocation(srcFaceProgram, "u_direction");
    glUseProgram(dstFaceProgram);
    dstMvpLoc = glGetUniformLocation(dstFaceProgram, "u_mvpMatrix");
    dstFacePercentLoc = glGetUniformLocation(dstFaceProgram, "u_percent");
    dstFaceSamplerLoc = glGetUniformLocation(dstFaceProgram, "s_tex");
    dstFaceEdgeWidthLoc = glGetUniformLocation(dstFaceProgram, "u_edgeWidth");
    dstDirectionLoc = glGetUniformLocation(dstFaceProgram, "u_direction");
    glClearColor(0, 0, 0, 1);
}

- (void) tearDownGL
{
    
}

- (void) setupTexturesWithSource:(UIView *)source destination:(UIView *)destination screenScale:(CGFloat)screenScale
{
    srcTexture = [OpenGLHelper setupTextureWithView:source textureWidth:source.frame.size.width * screenScale textureHeight:source.frame.size.height * screenScale screenScale:screenScale];
    dstTexture = [OpenGLHelper setupTextureWithView:destination textureWidth:destination.frame.size.width * screenScale textureHeight:destination.frame.size.height * screenScale screenScale:screenScale];
}

@end
