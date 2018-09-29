//
//  RPBRectangle.m
//  RetroPaddleBall
//
//  Created by Luke Cotton on 11/21/16.
//
//

#import "RPBRectangle.h"

// Shader program id.
static GLuint _shaderprogramid;
static GLuint _vertexLocation;
static GLuint _colorLocation;
static GLuint _projectionMatrixLocation;
static GLuint _positionMatrixLocation;

@implementation RPBRectangle
// Init method
- (instancetype)init {
    self = [super init];
    if (self) {
        // Load in rect data.
        glGenBuffers(1, &_vertexBuffer);
        self.rect = CGRectMake(0, 0, 10, 10);
        // Load in index data.
        GLushort indexData[6] =
        {
            0, 1, 2,
            1, 2, 3
        };
        memcpy(&_indexData, &indexData, 6 * sizeof(GLushort));
        glGenBuffers(1, &_indexBuffer);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6 * sizeof(GLushort), _indexData, GL_STATIC_DRAW);
    }
    return self;
}
// Rect set method.
-(void)setRect:(CGRect)newRect {
    _rect = newRect;
    // Update OpenGL data.
    [self updateOpenGLData];
    
}
// Update rect verticies.
-(void)updateOpenGLData {
    // Load vertex data in.
    GLfloat vertexData[12] = {
        _rect.size.width, _rect.size.height, 0.0f,
        0.0f, _rect.size.height, 0.0f,
        _rect.size.width, 0.0f, 0.0f,
        0.0f, 0.0f, 0.0f
    };
    memcpy(&_vertexData, &vertexData, 12 * sizeof(GLfloat));
    // Make transformation matrix.
    _modelMatrix = GLKMatrix4MakeTranslation(_rect.origin.x, _rect.origin.y, 0.0f);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, 12 * sizeof(GLfloat), _vertexData, GL_STATIC_DRAW);
}
// Render method.
-(void)render {
    // Use our program.
    glUseProgram(_shaderprogramid);
    
    // Put data into various shader locations.
    glEnableVertexAttribArray(_vertexLocation);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glVertexAttribPointer(_vertexLocation, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(GLfloat), 0);
    
    // Get our color and pass it in.
    CGFloat colorDataDouble[4];
    [self.rectColor getRed:&colorDataDouble[0] green:&colorDataDouble[1] blue:&colorDataDouble[2] alpha:&colorDataDouble[3]];
    GLfloat colorData[] = {colorDataDouble[0], colorDataDouble[1], colorDataDouble[2], colorDataDouble[3]};
    glUniform4fv(_colorLocation, 1, colorData);
    
    // Load in the matricies.
    glUniformMatrix4fv(_positionMatrixLocation, 1, GL_FALSE, _modelMatrix.m);
    glUniformMatrix4fv(_projectionMatrixLocation, 1, GL_FALSE, _projectionMatrix.m);
    
    // Draw stuff.
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, 0);
    
    // Disable the vertex attrib location.
    glDisableVertexAttribArray(_vertexLocation);
}
// Class initalization method.
+(void)initialize {
    // Setup shaders.
    [RPBRectangle setupShaders];
}
+(BOOL)setupShaders {
    // Get our two shaders.
    GLuint vertexShader = [RPBRectangle compileVertexShader];
    GLuint fragmentShader = [RPBRectangle compileFragmentShader];
    // Create our program.
    _shaderprogramid = glCreateProgram();
    // Attach the two programs.
    glAttachShader(_shaderprogramid, vertexShader);
    glAttachShader(_shaderprogramid, fragmentShader);
    // Link the two shaders together.
    glLinkProgram(_shaderprogramid);
    // Check for valid linking.
    GLint linkStatus;
    glGetProgramiv(_shaderprogramid, GL_LINK_STATUS, &linkStatus);
    assert(linkStatus == GL_TRUE);
    // Get attribute locations.
    _vertexLocation = glGetAttribLocation(_shaderprogramid, "position");
    _colorLocation = glGetUniformLocation(_shaderprogramid, "uniformColor");
    _projectionMatrixLocation = glGetUniformLocation(_shaderprogramid, "projectMatrix");
    _positionMatrixLocation = glGetUniformLocation(_shaderprogramid, "positionMatrix");
    // Return true.
    return YES;
}
// Compile our vertex shader.
+(GLuint)compileVertexShader {
    // Load our shader data.
    GLsizei count;
    char * shaderData = [RPBRectangle readNamedShader:@"Shader.vsh" size:&count];
    
    // Create our fragment shader.
    GLuint shader = glCreateShader(GL_VERTEX_SHADER);
    // Give OpenGL our fragment shader and compile it.
    glShaderSource(shader, 1, (const GLchar* const*)&shaderData, &count);
    glCompileShader(shader);
    
    // Check for errors.
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    
    // Free shader data.
    free(shaderData);
    
    // Return our shader
    return shader;
}
// Compile our fragment shader.
+(GLuint)compileFragmentShader {
    // Load our shader data.
    GLsizei count;
    char * shaderData = [RPBRectangle readNamedShader:@"Shader.fsh" size:&count];
    
    // Create our fragment shader.
    GLuint shader = glCreateShader(GL_FRAGMENT_SHADER);
    // Give OpenGL our fragment shader and compile it.
    glShaderSource(shader, 1, (const GLchar* const*)&shaderData, &count);
    glCompileShader(shader);
    
    // Check for errors.
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    
    // Free shader data.
    free(shaderData);
    
    // Return our shader
    return shader;
}
+(char *)readNamedShader:(NSString *)shaderName size:(GLsizei *)shaderSize {
    // Read the shader into memory, and then return it.
    NSBundle * mainBundle = [NSBundle mainBundle];
    NSURL * shaderURL = [mainBundle URLForResource:shaderName withExtension:nil];
    NSData * shaderData = [NSData dataWithContentsOfURL:shaderURL];
    NSUInteger dataSize = shaderData.length;
    char * shaderCharArray = malloc(dataSize + 1);
    memset(shaderCharArray, 0, dataSize + 1);
    memcpy(shaderCharArray, [shaderData bytes], dataSize);
    *shaderSize = (GLsizei)dataSize + 1;
    return shaderCharArray;
}

-(void)dealloc {
    // Destroy our old buffers.
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}
@end
