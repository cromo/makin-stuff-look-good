# [Particles 102](https://www.youtube.com/watch?v=rR_bm8f8rVE)

This is a better intro to particles than Particles 101 ever was, so this is the place to get started.

## Basic info

LOVE's particle systems aren't nearly as powerful as Unity's. For one, they only have two dimensions to work with. In addition, properties, such as birth time dependent colors or distance based emission, are completely absent. The systems present in this demo try to mimic what is going on in the original video where possible.

## Particle systems

The original video showcases eight particle systems. The six that are implemented here are:

* A basic particle system using a white disk with radial alpha falloff as the texture. This shows how to set up a simple particle system without any crazy effects.
* A white, glowy version of what would have been the second system. Since LOVE can't do birth time dependent color, this simply uses the plain white texture. The main difference is additive blending is used when drawing the system, which is not an attribute of the system itself. Even with the plain white disks, it does look "glowy-er".
* The third system uses a solid disk as the particle image and varies the particle color over its lifetime. It also demonstrates changing the Z-order in which particles age by using `setInsertMode`.
* The fourth system uses an outlined disk.
* The fifth system demonstrates rotating particles.
* The sixth shows how to produce particle bursts.

Of note, the two following systems are absent:

* The system demonstrating color determined by birth time is absent because LOVE does not expose this feature.
* The system demonstrating particle emission based on distance travelled is absent becaus LOVE only supports time based emission.
