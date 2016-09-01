//
//  SRParticleSystem.m
//  SpaceRace
//
//  Created by Nate Parrott on 12/26/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

#import "SRParticleSystem.h"

NSString* SRParticleSystemOverrideVertexShaderString = @"kSRParticleSystemOverrideVertexShaderString";
NSString* SRParticleSystemOverrideFragmentShaderString = @"kSRParticleSystemOverrideFragmentShaderString";

typedef struct {
    unsigned char part;
    float particleID;
} SRParticleVertexData;

@implementation SRParticleSystem

-(id)initWithParticleCount:(int)particleCount options:(NSDictionary*)options {
    self = [super init];
    
    _particleCount = particleCount;
    
    // set defaults:
    _endPos = GLKVector3Make(1, 0, 0);
    _endPosVariance = GLKVector3Make(0.3, 0.3, 0.3);
    _secondsPerCycle = 1;
    _particleRadius = 0.05;
    _modelviewProjectionMatrix = GLKMatrix4MakePerspective(65*M_PI/180, 1, 0.1, 1);
    _particleColor = GLKVector4Make(1, 1, 1, 1);
    
    // init. the shader:
    NSString* fragmentShader = options[SRParticleSystemOverrideFragmentShaderString]? options[SRParticleSystemOverrideFragmentShaderString] : [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SRParticleSystem" ofType:@"fsh"] encoding:NSUTF8StringEncoding error:nil];
    NSString* vertexShader = options[SRParticleSystemOverrideVertexShaderString]? options[SRParticleSystemOverrideVertexShaderString] : [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SRParticleSystem" ofType:@"vsh"] encoding:NSUTF8StringEncoding error:nil];
    _program = [[GLProgram alloc] initWithVertexShaderString:vertexShader fragmentShaderString:fragmentShader];
    [_program addAttribute:@"part"];
    [_program addAttribute:@"particleID"];
    if (![_program link]) {
        NSLog(@"Link failed");
        NSString *progLog = [_program programLog];
        NSLog(@"Program Log: %@", progLog);
        NSString *fragLog = [_program fragmentShaderLog];
        NSLog(@"Frag Log: %@", fragLog);
        NSString *vertLog = [_program vertexShaderLog];
        NSLog(@"Vert Log: %@", vertLog);
        _program = nil;
    }
    _partAttr = [_program attributeIndex:@"part"];
    _particleIDAttr = [_program attributeIndex:@"particleID"];
    
    // get uniform indices:
    _matrixU = [_program uniformIndex:@"modelViewProjectionMatrix"];
    _radiusU = [_program uniformIndex:@"particleRadius"];
    _startPosU = [_program uniformIndex:@"startPos"];
    _endPosU = [_program uniformIndex:@"endPos"];
    _startPosVarianceU = [_program uniformIndex:@"startPosVariance"];
    _endPosVarianceU = [_program uniformIndex:@"endPosVariance"];
    _secondsPerCycleU = [_program uniformIndex:@"secondsPerCycle"];
    _timeU = [_program uniformIndex:@"time"];
    _colorU = [_program uniformIndex:@"particleColor"];
    
    // generate particle attribute data:
    glGenVertexArraysOES(1, &_vao);
    glBindVertexArrayOES(_vao);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    SRParticleVertexData* vertices = malloc(sizeof(SRParticleVertexData)*_particleCount*4);
    for (int particle=0; particle<_particleCount; particle++) {
        for (int part=0; part<4; part++) {
            SRParticleVertexData* v = vertices + particle*4 + part;
            v->part = part;
            v->particleID = particle*1.0/particleCount;
        }
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(SRParticleVertexData)*_particleCount*4, vertices, GL_STATIC_DRAW);
    free(vertices);
    
    // generate vertex indices:
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    unsigned int* indices = malloc(sizeof(unsigned int)*_particleCount*6);
    for (int particle=0; particle<particleCount; particle++) {
        indices[particle*6] = particle*4;
        indices[particle*6 + 1] = particle*4 + 1;
        indices[particle*6 + 2] = particle*4 + 2;
        
        indices[particle*6 + 3] = particle*4 + 1;
        indices[particle*6 + 4] = particle*4 + 3;
        indices[particle*6 + 5] = particle*4 + 2;
    }
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(unsigned int)*_particleCount*6, indices, GL_STATIC_DRAW);
    free(indices);
    
    // enable attributes:
    glVertexAttribPointer(_partAttr, 1, GL_UNSIGNED_BYTE, GL_FALSE, sizeof(SRParticleVertexData), (void*)0);
    glVertexAttribPointer(_particleIDAttr, 1, GL_FLOAT, 0, sizeof(SRParticleVertexData), (void*)offsetof(SRParticleVertexData, particleID));
    
    glBindVertexArrayOES(0);
    
    [self restart];
    return self;
}
-(void)restart {
    _startTime = [NSDate timeIntervalSinceReferenceDate];
}
-(void)dealloc {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vao);
}

#pragma mark Drawing
-(void)draw {
    glDepthMask(GL_FALSE); // todo: save the prev. value of glDepthMask for restoration later, instead of assuming it's always true
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    [_program use];
    
    // upload normals:
    //GLuint _matrixU, _radiusU, _startPosU, _endPosU, _startPosVarianceU, _endPosVarianceU, _secondsPerCycleU, _timeU;
    glUniformMatrix4fv(_matrixU, 1, 0, _modelviewProjectionMatrix.m);
    glUniform1f(_radiusU, _particleRadius);
    glUniform4f(_startPosU, _startPos.x, _startPos.y, _startPos.z, 1);
    glUniform4f(_endPosU, _endPos.x, _endPos.y, _endPos.z, 1);
    glUniform1f(_startPosVarianceU, _startPosVariance.x);
    glUniform1f(_endPosVarianceU, _endPosVariance.x);
    glUniform1f(_secondsPerCycleU, _secondsPerCycle);
    glUniform1f(_timeU, [NSDate timeIntervalSinceReferenceDate]-_startTime);
    glUniform4f(_colorU, _particleColor.x, _particleColor.y, _particleColor.z, _particleColor.a);
    
    glBindVertexArrayOES(_vao);
    // it takes 6 vertices to make a particle quad:
    glEnableVertexAttribArray(_partAttr);
    glEnableVertexAttribArray(_particleIDAttr);
    glDrawElements(GL_TRIANGLES, _particleCount*6, GL_UNSIGNED_INT, 0);
    glDisableVertexAttribArray(_partAttr);
    glDisableVertexAttribArray(_particleIDAttr);
    glBindVertexArrayOES(0);
    
    glDepthMask(GL_TRUE);
}

@end
