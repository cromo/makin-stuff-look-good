# [Shaders 102](https://www.youtube.com/watch?v=kpBnIAPtsj8)

Picking up where Shaders 101 left off, this unit covers the basics of image effects, including use of multiple textures for distorting images, blurring, using shaders iteratively, and exploiting downsampling for slightly less correct but significantly less expensive effects.

## Basic info

### `OnRenderImage`

First and foremost, LOVE does not appear to have an equivalent to Unity's `OnRenderImage`, so it is simulated by rendering everything to a `Canvas`, then the effects are performed on that. This isn't strictly equivalent, but it also shows that image effects can be done to only part of a scene by rendering only what needs the effect to a separate canvas and performing the effect only on it.

## Effects

There are a number of effects that can be switched between using the left and right arrow keys. Some of the effects have an adjustable parameter that can be changed by pressing the up and down arrow keys.

* Demonstration of using the whole screen as a texture using the red-green UV example from Shaders 101.
* Blend the red-green UV color with the full screen color.
* Distortion using a displacement texture. Use up and down to change the magnitude of the effect.
* Animated distortion. Use up and down to change the magnitude.
* Box blur by averaging the nine pixels around the target pixel.
* Iterative application of the box blur. Use up and down to change the number of iterations.
* Downsampling with iterative box blur. Use up and down to change the number of iterations.
