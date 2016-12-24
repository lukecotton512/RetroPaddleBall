// Shader.vsh
// Luke Cotton
// Basic vertex shader.

// Vertex shader attributes.
attribute vec4 position;
uniform mat4 projectMatrix;
uniform mat4 positionMatrix;
uniform vec4 uniformColor;
varying vec4 squareColor;

void main(void) {
    gl_Position = projectMatrix * positionMatrix * position;
    squareColor = uniformColor;
}
