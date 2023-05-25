#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

flat varying vec4 color;

varying vec2 texcoord;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;



uniform sampler2D texture;

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform int fogMode;
uniform int worldTime;
uniform float wetness;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;

uniform int heldBlockLightValue;
uniform vec4 entityColor;

//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////


void main(){


	vec4 albedo = vec4(color.rgb*0.5,1.);	//don't export to gamma 1/2.2 due to RGB11F format

/* DRAWBUFFERS:0 */
	gl_FragData[0] = albedo;
}