//
//  Shader.vsh
//  SpaceRace
//
//  Created by Nate Parrott on 12/23/13.
//  Copyright (c) 2013 Nate Parrott. All rights reserved.
//

uniform highp float time;
uniform mediump float secondsPerCycle;

uniform mat4 modelViewProjectionMatrix;

uniform float particleRadius;

uniform vec4 startPos, endPos;
uniform float startPosVariance, endPosVariance;

attribute float vertexPart;
/*
 vertex part—what part of the particle is this vertex?
 0: upper left
 1: lower left
 2: lower right
 3: upper right
 */
attribute float particleID;
/*
 particle ID
 */

varying lowp vec2 faceCoord; // [0..1]
varying lowp float kAlpha;

const float brightnessRampUpTime = 0.1;
const float brightnessFadingTime = 0.4;

// from http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl :
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
float nrand(vec2 co){ // like rand(), but returns results in [-1..1]
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453)*2.0 - 1.0;
}

vec3 randVec(float cycle, float particleID, float seed) {
    return vec3(
                nrand(vec2(particleID+seed, cycle)),
                nrand(vec2(particleID, cycle-seed)),
                nrand(vec2(cycle+seed, particleID))
                );
}

vec4 projectVec(vec4 v) {
    vec4 projected = modelViewProjectionMatrix * v;
    projected.xyz /= projected.w;
    projected.w = 1.0;
    return projected;
}

void main()
{
    float adjustedTime = time - secondsPerCycle*particleID;
    float t = mod(adjustedTime, secondsPerCycle) / secondsPerCycle;
    float cycle = floor(adjustedTime / secondsPerCycle);
    if (adjustedTime < 0.0) {
        kAlpha = 0.0;
    } else {
        kAlpha = min(1.0, min(t/brightnessRampUpTime, (1.0-t)/brightnessFadingTime));
    }
    vec4 start = startPos;
    start.xyz += randVec(cycle, particleID, 1.0)*startPosVariance;
    vec4 end = endPos;
    end.xyz += randVec(cycle, particleID, 2.0)*endPosVariance;
    vec4 worldSpacePos = start*(1.0-t) + end*t;
    
    vec4 eyePos = projectVec(worldSpacePos);
    float eyeRadius = distance(eyePos, projectVec(worldSpacePos + vec4(particleRadius, 0.0, 0.0, 0.0)));
    
    int part = int(vertexPart);
    float x = (part==0 || part==1)? 0.0 : 1.0;
    float y = (part==0 || part==2)? 0.0 : 1.0;
    
    gl_Position = vec4(
                       eyePos.x + (x-0.5)*eyeRadius*2.0,
                       eyePos.y + (y-0.5)*eyeRadius*2.0,
                       eyePos.z,
                       1.0
                       );
    //gl_Position = vec4(0.0+x*0.1, 0.0+y*0.1, 0.0, 1.0);
    faceCoord = vec2(x, y);
}
