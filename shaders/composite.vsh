#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

/*
Disable an effect by putting "//" before "#define" when there is no number after
You can tweak the numbers, the impact on the shaders is self-explained in the variable's name or in a comment
*/

//go to line 46 for changing sunlight color and ambient color line 89 for moon light color

varying vec4 texcoord;

varying vec3 lightVector;
varying vec3 sunVec;
varying vec3 moonVec;
varying vec3 upVec;

varying vec4 lightS;


varying vec3 sunlight;
varying vec3 moonlight;
varying vec3 ambient_color;

varying float handItemLight;
varying float eyeAdapt;

varying float SdotU;
varying float MdotU;
varying float sunVisibility;
varying float moonVisibility;

uniform vec3 skyColor;
uniform vec3 sunPosition;
uniform vec3 upPosition;
uniform int worldTime;
uniform int heldItemId;
uniform int heldBlockLightValue;
uniform float rainStrength;
uniform float wetness;
uniform ivec2 eyeBrightnessSmooth;

////////////////////sunlight color////////////////////
////////////////////sunlight color////////////////////
////////////////////sunlight color////////////////////
const ivec4 ToD[25] = ivec4[25](ivec4(0,1,1,1), //hour,r,g,b
								ivec4(1,1,1,1),
								ivec4(2,1,1,1),
								ivec4(3,1,1,1),
								ivec4(4,1,1,1),
								ivec4(5,1,1,1),
								ivec4(6,230,110,40),
								ivec4(7,315,160,40),
								ivec4(8,325,170,87),
								ivec4(9,325,170,110),
								ivec4(10,315,170,10),
								ivec4(11,265,170,90),
								ivec4(12,279,175,100),
								ivec4(13,265,170,100),
								ivec4(14,270,170,90),
								ivec4(15,315,170,99),
								ivec4(16,320,150,100),
								ivec4(17,320,150,85),
								ivec4(18,250,140,95),
								ivec4(19,2,2,3),
								ivec4(20,1,1,1),
								ivec4(21,1,1,1),
								ivec4(22,1,1,1),
								ivec4(23,1,1,1),
								ivec4(24,1,1,1));
vec3 sky_color = ivec3(60,170,255)/255.0;								
								
float fx(float x) {
return (2 *(-sin(x)*sin(x)*sin(x) + 3*sin(x) + 3*x)) / 3;

}
float fx2(float x) {
return (-cos(x) * sin(x) + 6*x) / 2;

}
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {
	moonlight = ivec3(3,4,16)/255.0/2.2;
	gl_Position = ftransform();
	texcoord = gl_MultiTexCoord0;

	if (worldTime < 12700 || worldTime > 23250) {
		lightVector = normalize(sunPosition);
	}
	else {
		lightVector = normalize(-sunPosition);
	}
	
	sunVec = normalize(sunPosition);
	moonVec = normalize(-sunPosition);
	upVec = normalize(upPosition);
	
	SdotU = dot(sunVec,upVec);
	MdotU = dot(moonVec,upVec);
	sunVisibility = pow(clamp(SdotU+0.1,0.0,0.1)/0.1,2.0);
	moonVisibility = pow(clamp(MdotU+0.1,0.0,0.1)/0.1,2.0);
	
	
	float hour = mod(worldTime/1000.0+6.0,24);
	//if (hour > 24.0) hour = hour - 24.0;
	
	ivec4 temp = ToD[int(floor(hour))];
	ivec4 temp2 = ToD[int(floor(hour)) + 1];
	
	sunlight = mix(vec3(temp.yzw),vec3(temp2.yzw),(hour-float(temp.x))/float(temp2.x-temp.x))/255.0f;
	

sky_color = pow(sky_color,vec3(2.2));
vec3 nsunlight = normalize(mix(pow(sunlight,vec3(2.2)),vec3(0.25,0.3,0.4),rainStrength));
sky_color = normalize(mix(sky_color,vec3(0.25,0.3,0.4),rainStrength)); //normalize colors in order to don't change luminance
vec3 sVector = normalize(upVec);
const float PI = 3.14159265359;
float cosT = 1.; 
float T = acos(cosT);
float absCosT = abs(cosT);
float cosS = SdotU;
float S = acos(cosS);				
float cosY = cosS;
float Y = acos(cosY);	
		
lightS.x = (fx(Y+PI/2.0)-fx(Y-PI/2.0))*2.0;
lightS.y = (fx2(T+PI/2.0)-fx2(T-PI/2.0))*1.2;
float tL = (lightS.x+ lightS.y)/6.28;

//moon sky color
float McosS = MdotU;
float MS = acos(McosS);
float McosY = MdotU;
float MY = acos(McosY);

lightS.z = (fx(MY+PI/2.0)-fx(MY-PI/2.0))*3.0;
lightS.w = (fx2(T+PI/2.0)-fx2(T-PI/2.0));
float tLMoon = (lightS.z + lightS.w)/6.28;

ambient_color = mix(sky_color, nsunlight,1-exp(-0.16*tL*(1-rainStrength*0.8)))*tL*sunVisibility*(1-rainStrength*0.8) + tLMoon*moonVisibility*moonlight;
eyeAdapt = (2.0-min(length(ambient_color),eyeBrightnessSmooth.y/240.0*1.7));


	handItemLight = 0.0;
	if (heldItemId == 50) {
		// torch
		handItemLight = 2.8;
	}
	
	else if (heldItemId == 76 || heldItemId == 94) {
		// active redstone torch / redstone repeater
		handItemLight = 0.1;
	}
	
	else if (heldItemId == 89) {
		// lightstone
		handItemLight = 0.6;
	}
	
	else if (heldItemId == 10 || heldItemId == 11 || heldItemId == 51) {
		// lava / lava / fire
		handItemLight = 0.5;
	}
	
	else if (heldItemId == 91) {
		// jack-o-lantern
		handItemLight = 0.6;
	}
	
	
	else if (heldItemId == 327) {
		handItemLight = 0.2;
	}
}
