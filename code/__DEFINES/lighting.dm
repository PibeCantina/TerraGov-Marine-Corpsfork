///Object doesn't use any of the light systems. Should be changed to add a light source to the object.
#define NO_LIGHT_SUPPORT 0
///Light made with the lighting datums, applying a matrix.
#define STATIC_LIGHT 1
///Light made by masking the lighting darkness plane.
#define MOVABLE_LIGHT 2
///A mix of the above, cheaper on moving items than dynamic, but heavier on rendering than movable
#define HYBRID_LIGHT 3

#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

#define LIGHTING_ICON 'icons/effects/lighting_object.dmi' // icon used for lighting shading effects
#define LIGHTING_ICON_BIG 'icons/effects/lighting_object_big.dmi' //! icon used for lighting shading effects

#define ALPHA_TO_INTENSITY(alpha) (-(((clamp(alpha, 0, 22) - 22) / 6) ** 4) + 255)


#define LIGHT_RANGE_FIRE 3 //How many tiles standard fires glow.

// Lighting cutoff defines
// These are a percentage of how much darkness to cut off (in rgb)
#define LIGHTING_CUTOFF_VISIBLE 0
#define LIGHTING_CUTOFF_REAL_LOW 5
#define LIGHTING_CUTOFF_LOW 15
#define LIGHTING_CUTOFF_MEDIUM 30
#define LIGHTING_CUTOFF_HIGH 50
#define LIGHTING_CUTOFF_FULLBRIGHT 100


#define FLASH_LIGHT_DURATION 2
#define FLASH_LIGHT_POWER 3
#define FLASH_LIGHT_RANGE 3.8

// Emissive blocking.
/// Uses vis_overlays to leverage caching so that very few new items need to be made for the overlay. For anything that doesn't change outline or opaque area much or at all.
#define EMISSIVE_BLOCK_GENERIC 0
/// Uses a dedicated render_target object to copy the entire appearance in real time to the blocking layer. For things that can change in appearance a lot from the base state, like humans.
#define EMISSIVE_BLOCK_UNIQUE 1
/// Don't block any emissives. Useful for things like, pieces of paper?
#define EMISSIVE_BLOCK_NONE 2

#define _EMISSIVE_COLOR(val) list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, val,val,val,0)

/// The color matrix applied to all emissive overlays. Should be solely dependent on alpha and not have RGB overlap with [EM_BLOCK_COLOR].
#define EMISSIVE_COLOR _EMISSIVE_COLOR(1)
/// A globaly cached version of [EMISSIVE_COLOR] for quick access.
GLOBAL_LIST_INIT(emissive_color, EMISSIVE_COLOR)
#define _EM_BLOCK_COLOR(val) list(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,val, 0,0,0,0)
/// The color matrix applied to all emissive blockers. Should be solely dependent on alpha and not have RGB overlap with [EMISSIVE_COLOR].
#define EM_BLOCK_COLOR _EM_BLOCK_COLOR(1)
/// A globaly cached version of [EM_BLOCK_COLOR] for quick access.
GLOBAL_LIST_INIT(em_block_color, EM_BLOCK_COLOR)
/// A set of appearance flags applied to all emissive and emissive blocker overlays.
#define EMISSIVE_APPEARANCE_FLAGS (KEEP_APART|KEEP_TOGETHER|RESET_COLOR|RESET_TRANSFORM)
/// A set of appearance flags applied to all emissive and emissive blocker overlays that transform with the atom its attached to.
#define EMISSIVE_APPEARANCE_TRANSFORM_FLAGS (KEEP_APART|KEEP_TOGETHER|RESET_COLOR)
/// The color matrix used to mask out emissive blockers on the emissive plane. Alpha should default to zero, be solely dependent on the RGB value of [EMISSIVE_COLOR], and be independant of the RGB value of [EM_BLOCK_COLOR].
#define EM_MASK_MATRIX list(0,0,0,1/3, 0,0,0,1/3, 0,0,0,1/3, 0,0,0,0, 1,1,1,0)
/// A globaly cached version of [EM_MASK_MATRIX] for quick access.
GLOBAL_LIST_INIT(em_mask_matrix, EM_MASK_MATRIX)

/// Returns the red part of a #RRGGBB hex sequence as number
#define GETREDPART(hexa) hex2num(copytext(hexa, 2, 4))

/// Returns the green part of a #RRGGBB hex sequence as number
#define GETGREENPART(hexa) hex2num(copytext(hexa, 4, 6))

/// Returns the blue part of a #RRGGBB hex sequence as number
#define GETBLUEPART(hexa) hex2num(copytext(hexa, 6, 8))

/// Parse the hexadecimal color into lumcounts of each perspective.
#define PARSE_LIGHT_COLOR(source) \
do { \
	if (source.light_color != COLOR_WHITE) { \
		var/__light_color = source.light_color; \
		source.lum_r = GETREDPART(__light_color) / 255; \
		source.lum_g = GETGREENPART(__light_color) / 255; \
		source.lum_b = GETBLUEPART(__light_color) / 255; \
	} else { \
		source.lum_r = 1; \
		source.lum_g = 1; \
		source.lum_b = 1; \
	}; \
} while (FALSE)


//Bay lighting engine shit, not in /code/modules/lighting because BYOND is being shit about it	//thats how defines work, hello?
#define LIGHTING_INTERVAL 5 // frequency, in 1/10ths of a second, of the lighting process

#define MOVABLE_MAX_RANGE 7

#define LIGHTING_FALLOFF 1 // type of falloff to use for lighting; 1 for circular, 2 for square
#define LIGHTING_LAMBERTIAN 0 // use lambertian shading for light sources
#define LIGHTING_HEIGHT 1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone
#define LIGHTING_ROUND_VALUE (1 / 64) //Value used to round lumcounts, values smaller than 1/129 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

/// If the max of the lighting lumcounts of each spectrum drops below this, disable luminosity on the lighting objects. Set to zero to disable soft lighting. Luminosity changes then work if it's lit at all.
#define LIGHTING_SOFT_THRESHOLD 0

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list                     \
	(                        \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		0, 0, 0, 1           \
	)                        \

#define LIGHTING_NO_UPDATE 0
#define LIGHTING_VIS_UPDATE 1
#define LIGHTING_CHECK_UPDATE 2
#define LIGHTING_FORCE_UPDATE 3
