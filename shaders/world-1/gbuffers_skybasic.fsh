#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

/* DRAWBUFFERS:0 */


uniform vec3 sunPosition;
uniform vec3 upPosition;
uniform int worldTime;
uniform int heldItemId;
uniform int heldBlockLightValue;
uniform float rainStrength;
uniform float wetness;
uniform ivec2 eyeBrightnessSmooth;
uniform float viewWidth;
uniform float viewHeight;

uniform vec3 cameraPosition;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;

const int FOGMODE_LINEAR = 9729;
const int FOGMODE_EXP = 2048;
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

const vec3 moonlight = vec3(0.575, 1.05, 1.4) * 0.01;
float invRain07 = 1.0-rainStrength*0.4;


void main() {
	vec4 fragpos = gbufferProjectionInverse*(vec4(gl_FragCoord.xy/vec2(viewWidth,viewHeight),1.0,1.0)*2.0-1.0);
	float fog = exp(-dot(fragpos.xyz,fragpos.xyz));
	vec3 fColor = mix(vec3(1.0,0.08,0.01)*0.1,vec3(0.0),fog)*0.;
	gl_FragData[0] = vec4(fColor,1.0);

}