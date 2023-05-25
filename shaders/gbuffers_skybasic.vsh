#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

varying vec3 fragpos;
varying vec3 sunVec;
varying vec3 moonVec;
varying vec3 upVec;


varying vec3 sky1;
varying vec3 sky2;
varying vec3 rawAvg;

varying vec3 nsunlight;
varying vec3 sunlight;

varying float SdotU;
varying float MdotU;
varying float sunVisibility;
varying float moonVisibility;

const vec3 ToD[7] = vec3[7](  vec3(0.58597,0.16,0.005),
								vec3(0.58597,0.31,0.05),
								vec3(0.58597,0.45,0.16),
								vec3(0.58597,0.5,0.35),
								vec3(0.58597,0.5,0.36),
								vec3(0.58597,0.5,0.37),
								vec3(0.58597,0.5,0.38));

uniform vec3 sunPosition;
uniform vec3 upPosition;
uniform int worldTime;
uniform int heldItemId;
uniform int heldBlockLightValue;
uniform float rainStrength;
uniform float wetness;
uniform ivec2 eyeBrightnessSmooth;

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
		float hour = max(mod(worldTime/1000.0+2.0,24.0)-2.0,0.0);  //-0.1
	float cmpH = max(-abs(floor(hour)-6.0)+6.0,0.0); //12
	float cmpH1 = max(-abs(floor(hour)-5.0)+6.0,0.0); //1
	
	
	vec3 temp = ToD[int(cmpH)];
	vec3 temp2 = ToD[int(cmpH1)];
	
	sunlight = mix(temp,temp2,fract(hour));
	
	sunVec = normalize(sunPosition);
	moonVec = normalize(-sunPosition);
	upVec = normalize(upPosition);
	
	SdotU = dot(sunVec,upVec);
	MdotU = dot(moonVec,upVec);
	sunVisibility = pow(clamp(SdotU+0.15,0.0,0.15)/0.15,4.0);
	moonVisibility = pow(clamp(MdotU+0.15,0.0,0.15)/0.15,4.0);
	
	float tr = clamp(min(min(distance(float(worldTime),23250.0),800.0),min(distance(float(worldTime),12700.0),800.0))/800.0-0.5,0.0,1.0)*2.0;
	
	const vec3 moonlight = vec3(0.5, 0.9, 1.4) * 0.0032;
		
float cosS = SdotU;
float mcosS = max(cosS,0.0);

	vec4 bounced = vec4(0.5,0.66,1.3,0.27);



	vec3 sun_ambient = bounced.w * (vec3(0.25,0.62,1.32)-rainStrength*vec3(0.1,0.47,1.17))*(1.0+rainStrength*7.0) + sunlight*(bounced.x + bounced.z)*(1.0-rainStrength*0.95);
	
	rawAvg = (sun_ambient*sunVisibility + 8.0*moonlight*moonVisibility)*(0.05+tr*0.15)*4.7+0.0002;

	const vec3 moonlight2 = pow(normalize(moonlight),vec3(3.0))*length(moonlight)+moonlight;
	

	vec3 sunlight04 = pow(mix(temp,temp2,fract(hour)),vec3(1.0/2.2));
	float skyMult = max(SdotU*0.1+0.1,0.0)/0.2*(1.0-rainStrength*0.6)*0.7;
	nsunlight = normalize(pow(mix(sunlight04,5.*sunlight04*sunVisibility*(1.0-rainStrength*0.95)+vec3(0.3,0.3,0.35),rainStrength),vec3(2.2)))*0.6*skyMult;

	vec3 sky_color = vec3(0.05, 0.32, 1.);
	sky_color = normalize(mix(sky_color,2.*sunlight04*sunVisibility*(1.0-rainStrength*0.95)+vec3(0.3,0.3,0.3)*length(sunlight04),rainStrength)); //normalize colors in order to don't change luminance

	sky1 = sky_color*0.6*skyMult;
	sky2 = mix(sky_color,mix(nsunlight,sky_color,rainStrength*0.9),1.0-max(mcosS-0.2,0.0)*0.5)*0.6*skyMult;



	
	gl_Position = ftransform();
}
