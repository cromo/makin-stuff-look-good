uniform vec2 pixel_size;

vec4 effect(vec4 color, sampler2D texture, vec2 uv, vec2 screen_coords) {
  vec4 top_row = texture2D(texture, uv + -pixel_size) + texture2D(texture, uv + vec2(0, -pixel_size.y)) + texture2D(texture, uv + vec2(pixel_size.x, -pixel_size.y));
  vec4 center_row = texture2D(texture, uv + vec2(-pixel_size.x, 0)) + texture2D(texture, uv) + texture2D(texture, uv + vec2(pixel_size.x, 0));
  vec4 bottom_row = texture2D(texture, uv + vec2(-pixel_size.x, pixel_size.y)) + texture2D(texture, uv + vec2(0, pixel_size.y)) + texture2D(texture, uv + pixel_size);
  return (top_row + center_row + bottom_row) / 9;
}