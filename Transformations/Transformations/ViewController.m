//
//  ViewController.m
//  OpenGL_2_0
//
//  Created by Minglun Gong on 1/29/2014.
//  Copyright (c) 2014 Minglun Gong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
	int _touchObj;
	float _scale, _rotateX, _rotateY, _rotateZ;
	CGPoint _center[4], _touchCoord;
}

@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupPerspectiveView: (CGSize)size withFocal: (float)focal;

@end

@implementation ViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

	if (!self.context) {
		NSLog(@"Failed to create ES context");
	}
	
	GLKView *view = (GLKView *)self.view;
	view.context = self.context;
	view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	
	[self setupGL];
}

- (void)dealloc
{	
	[self tearDownGL];
	
	if ([EAGLContext currentContext] == self.context) {
		[EAGLContext setCurrentContext:nil];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];

	if ([self isViewLoaded] && ([[self view] window] == nil)) {
		self.view = nil;
		
		[self tearDownGL];
		
		if ([EAGLContext currentContext] == self.context) {
			[EAGLContext setCurrentContext:nil];
		}
		self.context = nil;
	}

	// Dispose of any resources that can be recreated.
}

- (void)update
{
	[self setupPerspectiveView: self.view.bounds.size withFocal:5];
	
	if ( _touchObj != 0 )
		_scale += self.timeSinceLastUpdate * 60;
	if ( _touchObj != 1 )
		_rotateX += self.timeSinceLastUpdate * 60;
	if ( _touchObj != 2 )
		_rotateY += self.timeSinceLastUpdate * 60;
	if ( _touchObj != 3 )
		_rotateZ += self.timeSinceLastUpdate * 60;
}

- (void)setupGL
{
	[EAGLContext setCurrentContext:self.context];

	_touchObj = -1;
	_center[0].x = -1, _center[1].x = 1, _center[2].x = -1, _center[3].x = 1;
	_center[0].y = 1, _center[1].y = 1, _center[2].y = -1, _center[3].y = -1;
	
	glClearColor(0, 0, .25, 0);
}

- (void)tearDownGL
{
	[EAGLContext setCurrentContext:self.context];
}

- (void)setupPerspectiveView: (CGSize)size withFocal: (float)focal
{
	float min = MIN(size.width, size.height);
	float width = size.width / min;
	float height = size.height / min;

	// set viewport based on display size
	glViewport(0, 0, size.width, size.height);
    
	// set up perspective projection
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
    glFrustumf(-width, width, -height, height, focal/2, focal*100);
    glTranslatef(0, 0, -focal);
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	const GLfloat triangle[] = {
		0,          1,  
		-sqrt(3)/2, -.5,
		sqrt(3)/2,  -.5,
	};
	const GLfloat square[] = {
		0,  1,
		-1, 0,
		1,  0,
		0,  -1,
		1,  0,
		-1, 0,
	};
	const GLfloat pentagon[] = {
		0,             1,            
		cos(M_PI*.1),  sin(M_PI*.1), 
		-cos(M_PI*.1), sin(M_PI*.1), 
		cos(M_PI*.3),  -sin(M_PI*.3),
		-cos(M_PI*.3), -sin(M_PI*.3),
	};
	const GLfloat hexagon[] = {
		0,   0,         
		1,   0,         
		.5,  sqrt(3)/2, 
		-.5, sqrt(3)/2, 
		-1,  0,         
		-.5, -sqrt(3)/2,
		.5,  -sqrt(3)/2,
		1,   0,
	};
	const GLubyte rainbow[] = {
		255, 255, 255, 255, // white
		255, 0,   0,   255, // red
		180, 180, 0,   255, // orange
		0,   255, 0,   255, // green
		0,   180, 180, 255, // cyan
		0,   0,   255, 255, // blue
		180, 0,   180, 255, // magenta
		255, 0,   0,   255, // red
	};
	
	// clear the rendering buffer
	glClear(GL_COLOR_BUFFER_BIT);
	// enable the vertex array rendering
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, rainbow);
	
	// set up the transformation for models
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// move to the 1st location & display a triangle
	glPushMatrix();
	{
		glTranslatef(_center[0].x, _center[0].y, 0);
		glScalef(abs(fmod(_scale,180)-90)/90.f, abs(fmod(_scale,180)-90)/90.f, 1);
		glVertexPointer(2, GL_FLOAT, 0, triangle);
		glDrawArrays(GL_TRIANGLES, 0, 3);
	}
	glPopMatrix();
	
	// move to the 2nd location & display a square
	glTranslatef(_center[1].x, _center[1].y, 0);
	glPushMatrix();
	{
 		glRotatef(_rotateX, 1, 0, 0);
		glVertexPointer(2, GL_FLOAT, 0, square);
		glDrawArrays(GL_TRIANGLES, 0, 6);
	}
	glPopMatrix();
	glTranslatef(-_center[1].x, -_center[1].y, 0);
	
	// move to the 3rd location & display a pentagon
	glTranslatef(_center[2].x, _center[2].y, 0);
	glPushMatrix();
	{
		glRotatef(_rotateY, 0, 1, 0);
		glVertexPointer(2, GL_FLOAT, 0, pentagon);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 5);
	}
	glPopMatrix();
	
	// move to the last location & display a hexagon
	glTranslatef(_center[3].x-_center[2].x, _center[3].y-_center[2].y, 0);
	glPushMatrix();
	{
		glRotatef(_rotateZ, 0, 0, 1);
		glVertexPointer(2, GL_FLOAT, 0, hexagon);
		glDrawArrays(GL_TRIANGLE_FAN, 0, 8);
	}
	glPopMatrix();
	
	glDisableClientState(GL_COLOR_ARRAY);
}

#pragma mark -  Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// get touch location
	CGPoint pos = [[touches anyObject] locationInView:self.view];
	// get iPhone display size
	CGSize size = self.view.bounds.size;
	float ratio = 4. / MIN(size.width, size.height);
	
	// normalize touch coordinates to match viewport size
	_touchCoord = CGPointMake((pos.x - size.width/2) * ratio,
				- (pos.y - size.height/2) * ratio);
	// find the object being touched
	_touchObj = -1;
	for ( int i=0; i<4; i++ )
		if ( abs(_touchCoord.x-_center[i].x) < .5 && abs(_touchCoord.y-_center[i].y) < .5 )
			_touchObj = i;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	// get touch location & iPhone display size
	CGPoint pos = [[touches anyObject] locationInView:self.view];
	CGSize size = self.view.bounds.size;
	float ratio = 4. / MIN(size.width, size.height);
	
	// normalize the coordinates to [-2, 2]
	CGPoint newCoord = CGPointMake((pos.x - size.width/2) * ratio,
					- (pos.y - size.height/2) * ratio);
	_center[_touchObj].x += newCoord.x - _touchCoord.x;
	_center[_touchObj].y += newCoord.y - _touchCoord.y;
	_touchCoord = newCoord;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_touchObj = -1;
}

@end
