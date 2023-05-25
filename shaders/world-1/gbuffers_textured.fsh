#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

	const int shadowMapResolution = 1024;		//shadowmap resolution


#define SHADOW_MAP_BIAS 0.8
varying vec4 color;

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

//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {
	vec4 albedo = texture2D(texture,texcoord);

	albedo.rgb = color.rgb*pow(albedo.rgb,vec3(2.2));	//don't export to gamma 1/2.2 due to RGB11F format
	
	vec4 fragpos = gbufferProjectionInverse*(vec4(gl_FragCoord.xy/vec2(viewWidth,viewHeight),gl_FragCoord.z,1.0)*2.0-1.0);
	fragpos.xyz /= fragpos.w*1024.*20.;
	
	float fog = exp(-length(fragpos.xyz));
	albedo.rgb = mix(vec3(1.0,0.08,0.01)*0.8,albedo.rgb,fog)*3.0;
	
/* DRAWBUFFERS:0 */
	gl_FragData[0] = albedo;
	
}