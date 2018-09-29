//
//  RPBRectangle.h
//  RetroPaddleBall
//
//  Created by Luke Cotton on 11/21/16.
//
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface RPBRectangle : NSObject {
    // Internal variables.
    GLKMatrix4 _modelMatrix;
    GLfloat _vertexData[12];
    GLushort _indexData[6];
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
}
// Properties.
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, copy) UIColor *rectColor;
@property (nonatomic, assign) GLKMatrix4 projectionMatrix;
// Class methods.
+(void)initialize;
+(BOOL)setupShaders;
+(GLuint)compileVertexShader;
+(GLuint)compileFragmentShader;
+(char *)readNamedShader:(NSString *)shaderName size:(GLsizei *)shaderSize;
// Instance methods.
-(void)render;
-(void)updateOpenGLData;
@end
