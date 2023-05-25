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
varying vec4 lcolor;
varying vec2 texcoord;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;



uniform sampler2D texture;

uniform vec4 entityColor;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform int fogMode;
uniform int worldTime;
uniform float wetness;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;

uniform int heldBlockLightValue;

float getAirDensity (float h) {
return h;
}
float FogF(vec3 fposition) {
	float density = 120.;

	vec4 worldpos = (gbufferModelViewInverse*vec4(fposition,0.0));
	//worldpos.y = getAirDensity(worldpos.y+cameraPosition.y)-getAirDensity(cameraPosition.y);
	float height = normalize(worldpos.xyz).y;
	float d = length(worldpos.xyz);

	return exp(-cameraPosition.y/density) * (1.0-exp( -d*height/density))/height;
}
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {
	vec4 albedo = texture2D(texture,texcoord);
	albedo.a *= color.a;
	albedo.rgb = mix(albedo.rgb,entityColor.rgb,entityColor.a);
	albedo.rgb = color.rgb*pow(albedo.rgb,vec3(2.2));	//don't export to gamma 1/2.2 due to RGB11F format
	
	vec4 fragpos = gbufferProjectionInverse*(vec4(gl_FragCoord.xy/vec2(viewWidth,viewHeight),gl_FragCoord.z,1.0)*2.0-1.0);
	fragpos.xyz /= fragpos.w;
	
	float fog = FogF(fragpos.xyz);
	albedo.rgb = mix(albedo.rgb, vec3(0.002,0.002,0.004),fog);
/* DRAWBUFFERS:0 */
	gl_FragData[0] = albedo;
}