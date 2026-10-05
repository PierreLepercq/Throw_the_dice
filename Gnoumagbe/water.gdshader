shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metalic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.05);

uniform vec4 color_deep : source_color;
uniform vec4 color_swallow : source_color;
uniform float beers_law = 2.0;
uniform float depth_offset = -0.75;

uniform float edge_scale = 0.1;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap; 
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


float fresnel(float amount, vec3 normal, vec3 view){
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

float edge(float depth){
	depth = 1.0 - 2.0 * depth;
	return near * far / (far + depth * (near - far));
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

	vec2 time = (TIME * wave_direction) * time_scale;
	vec2 time2 = (TIME * wave_direction2) * time_scale;
	
	float z_depth = edge(texture(DEPTH_TEXTURE, SCREEN_UV).x);
	
	float fresnel = fresnel(5.0, NORMAL, VIEW);
	vec3 surface_color = mix(albedo, albedo2, fresnel);
	vec3 normal_blend = mix(texture(texture_normal, UV + time).rgb, texture(texture_normal2,UV + time2).rgb, 0.5);
	ALBEDO = surface_color;
	METALLIC = metalic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
