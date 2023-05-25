#version 400 compatibility

/*






!! DO NOT REMOVE !! !! DO NOT REMOVE !!

This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !! !! DO NOT REMOVE !!


Sharing and modification rules

Sharing a modified version of my shaders:
-You are not allowed to claim any of the code included in "Chocapic13' shaders" as your own
-You can share a modified version of my shaders if you respect the following title scheme : " -Name of the shaderpack- (Chocapic13' Shaders edit) "
-You cannot use any monetizing links
-The rules of modification and sharing have to be same as the one here (copy paste all these rules in your post), you cannot make your own rules
-I have to be clearly credited
-You cannot use any version older than "Chocapic13' Shaders V4" as a base, however you can modify older versions for personal use
-Common sense : if you want a feature from another shaderpack or want to use a piece of code found on the web, make sure the code is open source. In doubt ask the creator.
-Common sense #2 : share your modification only if you think it adds something really useful to the shaderpack(not only 2-3 constants changed)


Special level of permission; with written permission from Chocapic13, if you think your shaderpack is an huge modification from the original (code wise, the look/performance is not taken in account):
-Allows to use monetizing links
-Allows to create your own sharing rules
-Shaderpack name can be chosen
-Listed on Chocapic13' shaders official thread
-Chocapic13 still have to be clearly credited


Using this shaderpack in a video or a picture:
-You are allowed to use this shaderpack for screenshots and videos if you give the shaderpack name in the description/message
-You are allowed to use this shaderpack in monetized videos if you respect the rule above.


Minecraft website:
-The download link must redirect to the link given in the shaderpack's official thread
-You are not allowed to add any monetizing link to the shaderpack download

If you are not sure about what you are allowed to do or not, PM Chocapic13 on http://www.minecraftforum.net/
Not respecting these rules can and will result in a request of thread/download shutdown to the host/administrator, with or without warning. Intellectual property stealing is punished by law.











*/

varying vec2 texcoord;
varying vec3 lightColor;
varying vec3 avgAmbient;
varying vec3 lightVector;
varying vec3 sunVec;
varying vec3 moonVec;
varying vec3 upVec;
varying vec3 avgAmbient2;
varying vec3 sky1;
varying vec3 sky2;
varying vec3 cloudColor;


varying vec4 lightS;
varying vec2 lightPos;
varying float tr;

varying vec3 sunlight;
varying vec3 ambient_color;
varying vec3 nsunlight;

varying float handItemLight;
varying float eyeAdapt;

varying float SdotU;
varying float MdotU;
varying float sunVisibility;
varying float moonVisibility;

uniform sampler2D gdepthtex;
uniform sampler2D composite;
uniform sampler2D gdepth;

uniform vec3 skyColor;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferPreviousModelView;
uniform ivec2 eyeBrightnessSmooth;
uniform int isEyeInWater;
uniform int worldTime;
uniform float aspectRatio;
uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float frameTimeCounter;
uniform int fogMode;

const vec3 moonlight = vec3(0.5, 0.9, 1.4) * 0.005;
const vec3 moonlightS = vec3(0.5, 0.9, 1.4) * 0.001;
float comp = 1.0-near/far/far;			//distance above that are considered as sky
float invRain06 = 1.0-rainStrength*0.6;
float pw = 1.0/ viewWidth;
float ph = 1.0/ viewHeight;


//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
void main() {
if(texcoord.x<0.25 && texcoord.y<0.25){
//Bloom



const int nSteps = 51;
int center = (nSteps-1)/2;
float sigma = 0.14;

/*--------------------------------*/
//huge gaussian blur for glare
vec3 blur = vec3(0.0);
float tw = 0.0;
for (int i = 0; i < nSteps; i++) {

	float dist = abs(i-float(center))/center;
	
	float weight = (exp(-(dist*dist)/(2.0*sigma)));
	
	//c^2.2/100
	vec3 bsample= texture2D(composite,texcoord.xy + vec2(pw,ph)*vec2(0.0,i-center)).rgb/3.0;
	blur += bsample*weight;
	tw += weight;

}
blur /= tw;

	
	

vec3 glow = blur;
vec3 overglow = glow*pow(length(glow)*3.,4.)*2.35*10.;


	
/* DRAWBUFFERS:3 */
	gl_FragData[0] = vec4((overglow+glow*1.15)*(1+pow(rainStrength,3.)*4.)*3.*0.04,1.0);
	}
}