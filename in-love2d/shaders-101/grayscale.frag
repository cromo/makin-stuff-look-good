vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen) {
  vec4 texel = texture2D(texture, uv);
  float luminance = 0.3 * texel.r + 0.59 * texel.g + 0.11 * texel.b;
  return vec4(luminance, luminance, luminance, texel.a);
}