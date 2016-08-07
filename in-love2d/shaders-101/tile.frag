vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen) {
  return texture2D(texture, 2 * mod(uv, 0.5));
}