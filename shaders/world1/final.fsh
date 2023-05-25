#version 400 compatibility

/*
const int gcolorFormat = RGBA16;		//backward optifine compatibility
const int gcolorFormat = R11F_G11F_B10F;
const int compositeFormat = RGBA16;		//backward optifine compatibility
const int compositeFormat = R11F_G11F_B10F;
const int gdepthFormat = RGBA8;
const int gnormalFormat = RGBA16;
*/


	
/*






!! DO NOT REMOVE !! !! DO NOT REMOVE !!

This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !! !! DO NOT REMOVE !!


Sharing and modification rule

Sharing a modified version of my shaders:
-You are not allowed to claim any of the code included varying "Chocapic13' shaders" as your own
-You can share a modified version of my shaders if you respect the following title scheme : " -Name of the shaderpack- (Chocapic13' Shaders edit) "
-You cannot use any monetizing links
-The rules of modification and sharing have to be same as the one here (copy paste all these rules varying your post), you cannot make your own rules
-I have to be clearly credited
-You cannot use any version older than "Chocapic13' Shaders V4" as a base, however you can modify older versions for personal use
-Common sense : if you want a feature from another shaderpack or want to use a piece of code found on the web, make sure the code is open source. varying doubt ask the creator.
-Common sense #2 : share your modification only if you think it adds something really useful to the shaderpack(not only 2-3 constants changed)


Special level of permission; with written permission from Chocapic13, if you think your shaderpack is an huge modification from the original (code wise, the look/performance is not taken varying account):
-Allows to use monetizing links
-Allows to create your own sharing rules
-Shaderpack name can be chosen
-Listed on Chocapic13' shaders official thread
-Chocapic13 still have to be clearly credited


Using this shaderpack varying a video or a picture:
-You are allowed to use this shaderpack for screenshots and videos if you give the shaderpack name varying the description/message
-You are allowed to use this shaderpack varying monetized videos if you respect the rule above.


Minecraft website:
-The download link must redirect to the link given varying the shaderpack's official thread
-You are not allowed to add any monetizing link to the shaderpack download

If you are not sure about what you are allowed to do or not, PM Chocapic13 on http://www.minecraftforum.net/
Not respecting these rules can and will result varying a request of thread/download shutdown to the host/administrator, with or without warning. Intellectual property stealing is punished by law.







0.07^6=x^4
6*ln(0.07) = 4*ln(x)
6/4*ln(0.07) = ln(x)


*/


#define VIGNETTE
#define VIGNETTE_STRENGTH 1. 
#define VIGNETTE_START 0.1	//distance from the center of the screen where the vignette effect start (0-1)
#define VIGNETTE_END 1.2		//distance from the center of the screen where the vignette effect end (0-1), bigger than VIGNETTE_START
	//#define GODRAYS			//varying this step previous godrays result is blurred
		const float exposure = 1.05;			//godrays intensity
		const float density = 1.0;			
		const float grnoise = 0.0;		//amount of noise 


//////////////////////////////END OF ADJUSTABLE VARIABLES
//////////////////////////////END OF ADJUSTABLE VARIABLES
//////////////////////////////END OF ADJUSTABLE VARIABLES
const bool gdepthMipmapEnabled = true;
const int maxf = 4;				//number of refinements
const float stp = 2.0;			//size of one step for raytracing algorithm
const float ref = 0.02;			//refinement multiplier
const float inc = 2.2;			//increasement factor at each step
/*--------------------------------*/
varying vec2 texcoord;

varying vec3 avgAmbient;
varying vec3 sunVec;
varying vec3 moonVec;
varying vec3 upVec;
varying vec3 lightColor;

varying vec3 sky1;
varying vec3 sky2;
varying float skyMult;
varying vec3 nsunlight;

varying float fading;

varying vec2 lightPos;

varying vec3 sunlight;
const vec3 moonlight = vec3(0.5, 0.9, 1.4) * 0.005;
const vec3 moonlightS = vec3(0.5, 0.9, 1.4) * 0.001;
varying vec3 ambient_c;
varying float tr;

varying vec3 rawAvg;

varying float handItemLight;
varying float eyeAdapt;
varying float SdotU;
varying float MdotU;
varying float sunVisibility;
varying float moonVisibility;
varying vec3 avgAmbient2;
varying vec3 cloudColor;
varying vec2 rainPos1;
varying vec2 rainPos2;
varying vec2 rainPos3;
varying vec2 rainPos4;
varying vec4 weights;
varying vec3 cloudc;

uniform sampler2D gnormal;
uniform sampler2D gdepth;
uniform sampler2D composite;
uniform sampler2D gcolor;
uniform sampler2D depthtex0;

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

	float comp = 1.0-near/far/far;			//distances above that are considered as sky


float getAirDensity (float h) {
return max(h/10.,6.0);
}
float invRain07 = 1.0-rainStrength*0.4;
vec3 getSkyColor(vec3 fposition) {
/*--------------------------------*/
vec3 sVector = normalize(fposition+vec3(0.0,cameraPosition.y-50,0.0));
/*--------------------------------*/

float cosT = dot(sVector,upVec);
float mCosT = max(cosT,0.0);
float absCosT = 1.0-max(cosT*0.82+0.26,0.2);
float cosS = SdotU;
float cosY = dot(sunVec,sVector);
float Y = acos(cosY);
/*--------------------------------*/
const float a = -1.;
const float b = -0.22;
const float c = 8.0;
const float d = -3.5;
const float e = 0.3;
/*--------------------------------*/
//luminance
float L =  (1.0+a*exp(b/(mCosT)));
float A = 1.0+e*cosY*cosY;

//gradient
vec3 grad1 = mix(sky1,sky2,absCosT*absCosT);
float sunscat = max(cosY,0.0);
vec3 grad3 = mix(grad1,nsunlight,sunscat*sunscat*(1.0-mCosT)*(0.9-rainStrength*0.5*0.9)*(clamp(-(cosS)*4.0+3.0,0.0,1.0)*0.65+0.35)+0.1);
//if (clamp(-(cosS)*4.0+3.0,0.0,1.0) > 0.2) return vec3(1.0);
//return vec3(sunscat*sunscat*(1.0-sqrt(mCosT*0.9+0.1))*(1.0-rainStrength*0.5)*(clamp(-(cosS)*4.0+3.0,0.0,1.0)*0.8+0.2)*0.9+0.1)*0.1;

float Y2 = 3.1416-Y;
float L2 = L * (8.0*exp(d*Y2)+A);
const vec3 moonlight = vec3(0.5, 0.9, 1.4) * 0.016;
const vec3 moonlight2 = pow(normalize(moonlight),vec3(3.0))*length(moonlight);
const vec3 moonlightRain = normalize(vec3(0.25,0.3,0.4))*length(moonlight);


vec3 gradN = mix(moonlight,moonlight2,1.-L2/2.0);
gradN = mix(gradN,moonlightRain,rainStrength);
return pow(L*(c*exp(d*Y)+A),invRain07)*sunVisibility *length(rawAvg) * (0.85+rainStrength*0.425)*grad3+ 0.2*pow(L2*1.2+1.2,invRain07)*moonVisibility*gradN;

}
float FogF(vec3 fposition) {
	float tmult = mix(min(abs(worldTime-6000.0)/6000.0,1.0),1.0,rainStrength);
	float density = 600./1.6*(1.0-rainStrength*0.5);

	vec3 worldpos = (gbufferModelViewInverse*vec4(fposition,1.0)).rgb+cameraPosition;
	float height = mix(getAirDensity (worldpos.y),6.,rainStrength);
	float d = length(fposition);

	return pow(clamp((2.625+rainStrength*3.4)/exp(-60/10./density)*exp(-getAirDensity (cameraPosition.y)/density) * (1.0-exp( -pow(d,2.712)*height/density/(6000.-tmult*tmult*2000.)/13))/height,0.0,1.),1.0-rainStrength*0.63)*clamp((eyeBrightnessSmooth.y/255.-2/16.)*4.,0.0,1.0);
}

	float distratio(vec2 pos, vec2 pos2) {
	
		return distance(pos*vec2(aspectRatio,1.0),pos2*vec2(aspectRatio,1.0));
	}
									

	
	float yDistAxis (in float degrees) {
		vec4 dVector = vec4(lightPos,texcoord);
		float ydistAxis = dot(dVector,vec4(-degrees,1.0,degrees,-1.0));
		return abs(ydistAxis);
		
	}
	
	float smoothCircleDist (in float lensDist) {

	vec2 lP = (lightPos*lensDist)-0.5*lensDist+0.5;
			 
	return distratio(lP, texcoord);
		
	}
	
	float cirlceDist (float lensDist, float size) {
	vec2 lP = (lightPos*lensDist)-(0.5*lensDist-0.5);
		return pow(min(distratio(lP, texcoord),size)/size,10.);
	}
	

	
	
float A = 0.25;		
float B = 0.3;		
float C = 0.08;			
	float D = 0.2;		
	float E = 0.03;
	float F = 0.4;
vec3 Uncharted2Tonemap(vec3 x) {

	/*--------------------------------*/
	return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

float gen_circular_lens(vec2 center, float size) {
	float dist=distratio(center,texcoord.xy)/size;
	return exp(-dist*dist);
}
vec3 nvec3(vec4 pos) {
    return pos.xyz/pos.w;
}
vec2 nvec2(vec4 pos) {
    return pos.xy/pos.w;
}
float nvec1(vec4 pos) {
    return pos.z/pos.w;
}
vec4 nvec4(vec3 pos) {
    return vec4(pos.xyz, 1.0);
}

float cdist(vec2 coord) {
	return max(abs(coord.s-0.5),abs(coord.t-0.5))*2.0;
}

	vec3 drawSun(vec3 fposition,vec3 color,float vis) {
vec3 sVector = normalize(fposition);

float angle = (1.0-max(dot(sVector,sunVec),0.0))*300;
float sun = exp(-angle*angle*angle);
sun *= (1.0-rainStrength*0.9925)*sunVisibility;
vec3 sunlightB = mix(pow(sunlight,vec3(1.0))*2.2*20.,vec3(0.25,0.3,0.4),rainStrength*0.8)*(1.0+SdotU*2.0);

return mix(color,sunlightB,sun*vis);

}
 float ld(float depth) {
    return (2.0 * near) / (far + near - depth * (far - near));		// (-depth * (far - near)) = (2.0 * near)/ld - far - near
}

vec4 raytrace(vec3 fragpos, vec3 normal,vec3 fogclr,vec3 rvector,float sky) {
    vec4 color = vec4(0.0);
    vec3 start = fragpos;
	float tmult = mix(min(abs(worldTime-6000.0)/6000.0,1.0),1.0,rainStrength);

    vec3 vector = stp * rvector;
    vec3 oldpos = fragpos;
    fragpos += vector;
	float minZ = start.z;
	float maxZ = fragpos.z;
    int sr = 0;
	/*--------------------------------*/
    for(int i=0;i<25;i++){
        vec2 pos = nvec2(gbufferProjection * nvec4(fragpos)) * 0.5 + 0.5;
        if(pos.x < 0 || pos.x > 1 || pos.y < 0 || pos.y > 1 || -minZ <  0 || min(-minZ,-maxZ) > far*1.412) break;
        vec3 spos = vec3(pos, texture2D(depthtex0, pos).r);
        spos.z = nvec1(gbufferProjectionInverse * nvec4(spos * 2.0 - 1.0));

		if(spos.z < minZ + 10.  && spos.z > maxZ){
                sr++;
                if(sr >= maxf){
					bool land = texture2D(depthtex0, pos.st).r < comp;
                    float border = clamp(1.0 - pow(cdist(pos.st), 20.0), 0.0, 1.0);
                    if (isEyeInWater == 0) color = texture2D(gcolor, pos.st);
					color.rgb = land? mix(color.rgb,fogclr*(0.7+0.3*tmult)*(2.0-rainStrength*1.0),FogF(fragpos)) : drawSun(rvector,fogclr,1.0)*sky;
					color.a = border;
					break;
                }
				fragpos -=vector;
                vector *=ref;


}

	minZ = fragpos.z;
    vector *= inc;
    fragpos += vector;
	maxZ = fragpos.z;

    }
    return color;
}

float smStep (float edge0,float edge1,float x) {
float t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
return t * t * (3.0 - 2.0 * t); }
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
vec3 decode (vec2 enc)
{
    vec2 fenc = enc*4-2;
    float f = dot(fenc,fenc);
    float g = sqrt(1-f/4.0);
    vec3 n;
    n.xy = fenc*g;
    n.z = 1-f/2;
    return n;
}

void main() {

float Depth = texture2D(depthtex0, texcoord).x;
bool land = Depth < comp;
vec4 fragpos = gbufferProjectionInverse * (vec4(texcoord,Depth,1.0) * 2.0 - 1.0);
fragpos.xyz /= fragpos.w;

vec4 albedo = texture2D(gcolor,texcoord);
vec3 color = albedo.xyz;

	

	vec3 blur = texture2D(composite,texcoord.xy/4.0).rgb;
	color += blur*10.;
	#ifdef VIGNETTE
	float len = distance(texcoord,vec2(.5));
	float len2 = distratio(texcoord,vec2(.5));

	float dc = mix(len,len2,0.1);
    float vignette = smStep(VIGNETTE_END, VIGNETTE_START,  dc);

	
	color = color*pow(vignette,4.0)*1.05;
	#endif	

	vec3 curr = Uncharted2Tonemap(color*15.5);

	color = pow(curr/Uncharted2Tonemap(vec3(15.)),vec3(1.0/2.2));
	//if (color.r > 1.0 || color.g > 1.0 || color.b > 1.0) color.rgb = vec3(1.0,0.0,1.0);


	gl_FragColor = vec4(color,1.0);
}