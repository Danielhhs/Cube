#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_edgeWidth;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

void main() {
    vec4 position = a_position;
    float rotation = u_percent * 3.14 / 2.f;
    if (position.x == 0.f) {
        position.x = -1.f * u_edgeWidth * u_percent / tan(rotation);
        position.z = -1.f * u_edgeWidth * sin(rotation);
    } else {
        position.z = 0.f;
        position.x = u_edgeWidth * (1.f - u_percent);
    }
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}