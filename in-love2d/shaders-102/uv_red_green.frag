vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  return vec4(uv.x, 1 - uv.y, 0, 1);
}