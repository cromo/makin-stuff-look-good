vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  return texture2D(texture, uv.xy);
}