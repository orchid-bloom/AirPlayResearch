//
//  SRParticleSystem.h
//  SpaceRace
//
//  Created by Nate Parrott on 12/26/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLProgram.h"
#import <GLKit/GLKit.h>

/*
    These can be passed in the options dictionary when constructing the particle system.
 */
NSString* SRParticleSystemOverrideVertexShaderString;
NSString* SRParticleSystemOverrideFragmentShaderString;



@interface SRParticleSystem : NSObject {
    GLProgram* _program;
    NSTimeInterval _startTime;
    
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    // uniforms:
    GLuint _matrixU, _radiusU, _startPosU, _endPosU, _startPosVarianceU, _endPosVarianceU, _secondsPerCycleU, _timeU, _colorU;
    
    // attributes:
    GLuint _particleIDAttr, _partAttr;
}

-(id)initWithParticleCount:(int)particleCount options:(NSDictionary*)options;
-(void)restart;
-(void)draw;

@property float secondsPerCycle;
@property GLKMatrix4 modelviewProjectionMatrix;
@property float particleRadius;
@property GLKVector4 particleColor;
@property GLKVector3 startPos, endPos, startPosVariance, endPosVariance;
/*
 Start pos and end pos variance adjust the amount how much particles will randomly deviate from the start and end positions. A variance of zero means the particles will start/end at a single point, while a wide deviance means they'll be spread out.
 They're vector parameters (to allow for different deviances in x, y and z directions) but at the moment, only the x value is used, and it adjusts the variance in ALL dimensions.
 */

@property(readonly)int particleCount;


@end
