uniform sampler2D displacements;
uniform float magnitude;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  vec2 displacement = texture2D(displacements, uv).xy;
  displacement = (2 * displacement - 1) * magnitude;
  return texture2D(texture, uv + displacement);
}