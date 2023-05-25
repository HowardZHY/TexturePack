#version 400 compatibility
/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

in vec4 color;
in vec3 fragpos;
in vec3 sunVec;
in vec3 moonVec;
in vec3 upVec;


in vec3 sky1;
in vec3 sky2;

in vec3 nsunlight;

in float SdotU;
in float MdotU;
in float sunVisibility;
in float moonVisibility;
in float skyMult;

in vec4 texcoord;
in vec4 lmcoord;

uniform sampler2D texture;
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

//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {

/* DRAWBUFFERS:3 */
	vec4 tex = texture2D(texture, texcoord.xy)*color;
	tex.a = tex.a;
	
	gl_FragData[0] = vec4(vec3(1.0,lmcoord.s,1.0),tex.a*length(tex.rgb)/sqrt(3.0));
}