// Shader.fsh
// Luke Cotton
// Defines our fragment shader.

varying lowp vec4 squareColor;

void main(void) {
    gl_FragColor = squareColor;
}
