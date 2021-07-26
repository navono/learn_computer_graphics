#version 330 core
// 位置变量的属性位置值为0
layout (location = 0) in vec3 aPos;

void main()
{
    gl_Position = vec4(aPos, 1.0);
}