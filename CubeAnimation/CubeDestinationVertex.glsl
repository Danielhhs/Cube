#version 300 es

uniform mat4 u_mvpMatrix;
uniform float u_percent;
uniform float u_edgeWidth;
uniform int u_direction;

layout(location = 0) in vec4 a_position;
layout(location = 2) in vec2 a_texCoords;

out vec2 v_texCoords;

const float pi = 3.1415926;
const float pi_2 = pi / 2.f;
const float pi_4 = pi / 4.f;
const float sqrt_2 = sqrt(2.f);

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

vec4 updatedPositionForTopToBottom() {
    vec4 position = a_position;
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    vec2 center = vec2(u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    if (position.z == 0.f) {
        position.y = center.x - radius * sin(rotation);
        position.z = radius * cos(rotation) + center.y;
    } else {
        position.z = center.y + radius * sin(rotation);
        position.y = center.x + radius * cos(rotation);
    }
    return position;
}

vec4 updatedPositionForBottomToTop() {
    vec4 position = a_position;
    float rotation = u_percent * pi_2 - pi_4;
    float radius = u_edgeWidth * sqrt_2 / 2.f;
    vec2 center = vec2(u_edgeWidth /  2.f, -u_edgeWidth / 2.f);
    if (position.z == 0.f) {
        position.y = center.x + radius * sin(rotation);
        position.z = radius * cos(rotation) + center.y;
    } else {
        position.z = center.y + radius * sin(rotation);
        position.y = center.x - radius * cos(rotation);
    }
    return position;
}

vec4 updatedPosition() {
    if (u_direction == 0) {
        return updatedPositionForLeftToRight();
    } else if (u_direction == 1) {
        return updatedPositionForRightToLeft();
    } else if (u_direction == 2) {
        return updatedPositionForTopToBottom();
    } else if (u_direction == 3) {
        return updatedPositionForBottomToTop();
    }
}

void main() {
    vec4 position = updatedPosition();
    gl_Position = u_mvpMatrix * position;
    v_texCoords = a_texCoords;
}