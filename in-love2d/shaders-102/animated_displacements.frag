uniform sampler2D displacements;
uniform float magnitude;
uniform float time;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  float t = time / 8;
  vec2 displacement_offset = mod(vec2(uv.x + t, uv.y + t), 1);
  vec2 displacement = texture2D(displacements, displacement_offset).xy;
  displacement = (2 * displacement - 1) * magnitude;
  return texture2D(texture, uv + displacement);
}