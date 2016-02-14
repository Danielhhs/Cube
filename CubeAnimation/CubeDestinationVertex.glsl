#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_edgeWidth;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

vec4 updatedPositionForRightToLeft() {
    vec4 position = a_position;
    float rotation = u_percent * 3.14 / 2.f;
    if (position.z == 0.f) {
        position.x = u_edgeWidth * (1.f - u_percent);
        position.z = 0.;
    } else {
        position.x = u_edgeWidth + u_edgeWidth * sin(rotation) - u_edgeWidth * u_percent;
        position.z = -1.f * u_edgeWidth * cos(rotation);
    }
    return position;
}

vec4 updatedPositionForLeftToRight() {
    vec4 position = a_position;
    float rotation = u_percent * 3.14 / 2.f;
    if (position.z == 0.f) {
        position.x = u_edgeWidth * u_percent;
        position.z = 0.f;
    } else {
        position.x = u_edgeWidth * sin(rotation) - u_edgeWidth * u_percent;
        position.z = -1.f * u_edgeWidth * cos(rotation);
    }
    return position;
}

vec4 updatedPosition() {
    if (u_direction == 0) {
        return updatedPositionForLeftToRight();
    } else if (u_direction == 1) {
        return updatedPositionForRightToLeft();
    }
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}