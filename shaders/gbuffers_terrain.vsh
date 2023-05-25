#version 120

/*
!! DO NOT REMOVE !!
This code is from Chocapic13' shaders
Read the terms of modification and sharing before changing something below please !
!! DO NOT REMOVE !!
*/

//#define WAVY_STUFF		//disable and gain some more fps

#define ENTITY_LEAVES        18.0
#define ENTITY_VINES        106.0
#define ENTITY_TALLGRASS     31.0
#define ENTITY_DANDELION     37.0
#define ENTITY_ROSE          38.0
#define ENTITY_WHEAT         59.0
#define ENTITY_LILYPAD      111.0
#define ENTITY_FIRE          51.0
#define ENTITY_LAVAFLOWING   10.0
#define ENTITY_LAVASTILL     11.0

varying vec4 color;
varying vec2 texcoord;


attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

uniform vec3 cameraPosition;
uniform vec3 sunPosition;
uniform vec3 upPosition;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform int worldTime;
uniform float frameTimeCounter;
uniform float rainStrength;
const float PI48 = 150.796447372;
float pi2wt = PI48*frameTimeCounter;
uniform int heldBlockLightValue;

vec3 calcWave(in vec3 pos, in float fm, in float mm, in float ma, in float f0, in float f1, in float f2, in float f3, in float f4, in float f5) {

    float magnitude = sin(dot(vec4(pi2wt*fm, pos.x, pos.z, pos.y),vec4(0.5))) * mm + ma;
	vec3 d012 = sin(pi2wt*vec3(f0,f1,f2));
	vec3 ret = sin(pi2wt*vec3(f3,f4,f5) + vec3(d012.x + d012.y,d012.y + d012.z,d012.z + d012.x) - pos) * magnitude;
	
    return ret;
}

vec3 calcMove(in vec3 pos, in float f0, in float f1, in float f2, in float f3, in float f4, in float f5, in vec3 amp1, in vec3 amp2) {
    vec3 move1 = calcWave(pos      , 0.0054, 0.0400, 0.0400, 0.0127, 0.0089, 0.0114, 0.0063, 0.0224, 0.0015) * amp1;
	vec3 move2 = calcWave(pos+move1, 0.07, 0.0400, 0.0400, f0, f1, f2, f3, f4, f5) * amp2;
    return move1+move2;
}


const vec3 ToD[7] = vec3[7](  vec3(0.58597,0.16,0.005),
								vec3(0.58597,0.31,0.08),
								vec3(0.58597,0.45,0.16),
								vec3(0.58597,0.5,0.35),
								vec3(0.58597,0.5,0.36),
								vec3(0.58597,0.5,0.37),
								vec3(0.58597,0.5,0.38));
								
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////
//////////////////////////////VOID MAIN//////////////////////////////

void main() {


	bool istopv = gl_MultiTexCoord0.t < mc_midTexCoord.t;
	
	
	//optimisation to get only one comparison to do per waving move
	vec4 idtest = vec4(ENTITY_TALLGRASS,ENTITY_DANDELION,ENTITY_ROSE,ENTITY_WHEAT)-mc_Entity.x;
	bool wavy1 = idtest.x*idtest.y*idtest.z*idtest.w == 0.0;
	
	vec2 id2 = vec2(161.0,ENTITY_LEAVES)-mc_Entity.x;
	bool wavy2 = id2.x*id2.y == 0.0;
	
	
	idtest = vec4(50.0,62.0,76.0,89.0)-mc_Entity.x;
	bool emissive = idtest.x*idtest.y*idtest.z*idtest.w == 0.0;
	
	idtest = vec4(141.0,142.0,175.0,106.0)-mc_Entity.x;
	
	bool mat = idtest.x*idtest.y*idtest.z*idtest.w == 0.0;
	color = pow(emissive? vec4(1.0) : gl_Color,vec4(2.2,2.2,2.2,1.));
	




		
	gl_Position = ftransform();

	/*--------------------------------*/
	
	//reduced the sun color to a 7 array
	float hour = max(mod(worldTime/1000.0+2.0,24.0)-2.0,0.0);  //-0.1
	float cmpH = max(-abs(floor(hour)-6.0)+6.0,0.0); //12
	float cmpH1 = max(-abs(floor(hour)-5.0)+6.0,0.0); //1
	
	
	vec3 temp = ToD[int(cmpH)];
	vec3 temp2 = ToD[int(cmpH1)];
	
	vec3 sunlight = mix(temp,temp2,fract(hour));
	const vec3 rainC = vec3(0.01,0.01,0.01);
	sunlight = mix(sunlight,rainC*sunlight,rainStrength);
	
	texcoord = (gl_MultiTexCoord0).xy;

	vec2 lmcoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	vec3 normal = normalize(gl_NormalMatrix * gl_Normal);
	

	

	float skyL = lmcoord.t*1.03225806452-0.5/16.0*1.03225806452;
	
	float torch_lightmap = 16.0-min(15.,(lmcoord.s-0.5/16.)*16.*16./15);


	float fallof1 = clamp(1.0 - pow(torch_lightmap/16.0,4.0),0.0,1.0);
	torch_lightmap = fallof1*fallof1/(torch_lightmap*torch_lightmap+1.0);


	const vec3 moonlight = vec3(0.5, 0.9, 1.4) * 0.006;

	vec3 sunVec = normalize(sunPosition);
	vec3 upVec = normalize(upPosition);


	vec2 visibility = vec2(dot(sunVec,upVec),dot(-sunVec,upVec));

	float NdotL = dot(normal,normalize(sunPosition));
	float NdotU = dot(normal,upVec);

	vec2 trCalc = min(abs(worldTime-vec2(23250.0,12700.0)),800.0);
	float tr = max(min(trCalc.x,trCalc.y)/400.0-1.0,0.0);
	visibility = pow(clamp(visibility+0.15,0.0,0.15)/0.15,vec2(3.0));





	



	

	
	if (mat || wavy1 || wavy2) {
		mat = true;
		color *= vec4(1.17,1.17,1.17,1.0);	
		#ifdef WAVY_STUFF
		if ((istopv && wavy1) || wavy2){

			vec4 position = gl_ModelViewMatrix * gl_Vertex;
			position = gbufferModelViewInverse * position;
			vec3 worldpos = position.xyz + cameraPosition;
			position.xyz += calcMove(worldpos.xyz, 0.0040, 0.0064, 0.0043, 0.0035, 0.0037, 0.0041, vec3(1.0,0.2,1.0), vec3(0.5,0.1,0.5))*1.4;
			position = gbufferModelView * position;	
			gl_Position = gl_ProjectionMatrix * position;
		}
		#endif
		
	}

		vec3 sunlightC = mix(sunlight,moonlight*(1.0-rainStrength*0.7),visibility.y)*tr;

	float diffuse = (worldTime > 12700 && worldTime < 23250)? -NdotL : NdotL;
	
	float skyL2 = skyL*skyL;
	float coef = (diffuse*0.5+0.5)*(diffuse*0.5+0.5)+sqrt(NdotU*0.1+0.101)*0.7;
	coef = (mat? abs(dot(sunVec,upVec))*0.2+NdotL*0.2+0.6 : coef);
	float skyL4coef = max(skyL*4.5-3.5,0.0);
	
	vec3 sunlightLight = sunlightC * skyL2*skyL2*skyL2*skyL2  + (1.0-tr)*(NdotL*0.2+0.5)*sunlight*visibility.x*skyL2*skyL2*skyL2*skyL2*skyL2*0.2;
	vec3 skyLight = mix(moonlight,mix(vec3(0.05,0.32,1.),vec3(0.3),rainStrength)*0.55+sunlightC*1.2*tr,visibility.x)*pow(skyL,3.)*0.3;
	color.rgb *= sunlightLight * mix(1.,coef,tr)*3.2+skyLight *0.6+ vec3(1.1,0.42,0.045)*torch_lightmap*0.66 + 0.002*min(skyL+6/16.,9/16.)*normalize(skyLight+0.0001);
	color.rgb *= 1.0;


}