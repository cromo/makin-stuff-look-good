uniform sampler2D secondary_texture;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  float weight = 0.2;
  return weight * texture2D(texture, uv) + (1 - weight) * texture2D(secondary_texture, uv);
}