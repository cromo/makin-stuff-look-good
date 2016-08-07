# [Shaders 101](https://www.youtube.com/watch?v=T-HXmQAMhG0)

An introduction to the mystical effects known as shaders. This section covers basics, such as setting basic colors, basing colors off of UV coordinates, and simple texturing.

## Basic info

### Shader types

There are a number of types of shaders that get run in order to produce a final image. LOVE exposes two of them: vertex shaders and fragment shaders. Vertex shaders can alter the geometry and attach data to individual vertices - such as colors or weights. Fragment shaders, also called pixel shaders (an older name for the same concept), determine the actual colors produced for each pixel covered by the geometry output by the vertex shader. One or the other or both may be used at any time. Only fragment shaders are used in this unit, and are stored in separate `.frag` files.

### Shader language

The shader language in LOVE2D is a slightly modified GLSL. LOVE's shading extensions amount to adding a few aliases for existing types and functions, as seen below:

| GLSL | LOVE |
| --- | --- |
| `float` | `number` |
| `sampler2D` | `Image` |
| `uniform` | `extern` |
| `texture2D(tex, uv)` | `Texel(tex, uv)` |

These are names that make a little more sense to someone unfamiliar to GLSL, but at the expense of portability. This means that anywhere you see one, you can use the other. All the shaders used here use the GLSL names for everything to make it easier to seach for additional documentation online.

### Swizzling

In GLSL, the members of a vector can be accessed with subscripts, and sub-vectors can be accessed by naming multiple attributes at once. E.g., a 4D vector can produce a 2D vector by saying `vec.xy`. This syntax is called *swizzling*.

## Shaders

* `white.frag` simply produces a white square by returning white for every pixel.
* `orange.frag` is the same as `white.frag`, but using a different color.
* `uv_red_green.frag` illustrates how to use the UV coordinates of the fragment to generate colors that vary over the whole fragment.
* `uv_cyan_magenta.frag` is the same as `uv_red_green.frag`, but uses a different value for the blue component.
* `texture.frag` shows how to retrieve tha values from an image for use in a shader.
* `tint.frag` changes the colors of a texture by multiplying the colors in the texture with a fixed color.
* `texture_uv_red_green.frag` performs tinting of the texture with a color based on the UV coordinates.
* `tile.frag` repeats the texture twice in both the x and y directions.
* `andy_warhol_looking_painting.frag` combines UV tinting with texture tiling.
* `grayscale.frag` calculates the luminance of each texel and uses it as the value for the red, green, and blue channels.
* `grayscale_tint.frag` tints the grayscale version of the image.

### Special cases

There are some shader effects covered in the video that are not controlled entirely from within the shader:

* `texture_no_alpha` is done by setting the blend mode outside of the shader.
* `texture_tween` is not implemented because I'm not sure how to send multiple textures to a shader using LOVE.
* `additive_blending` is also done by setting the blend mode outside of the shader.
