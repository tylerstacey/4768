//
//  ViewController.m
//  OpenGL_2_0
//
//  Created by Minglun Gong on 1/29/2014.
//  Copyright (c) 2014 Minglun Gong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
}
@property (strong, nonatomic) EAGLContext *context;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView;

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
	[self setupOrthographicView];
}

- (void)setupGL
{
	[EAGLContext setCurrentContext:self.context];
}

- (void)tearDownGL
{
	[EAGLContext setCurrentContext:self.context];
}

- (void)setupOrthographicView
{
	// get iPhone display size & aspect ratio
	CGSize size = self.view.bounds.size;

	// set viewport based on display size
	glViewport(0, 0, size.width, size.height);

	// set up orthographic projection
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0, size.width, 0, size.height, -1, 1);
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	// clear the rendering buffer
	glClear(GL_COLOR_BUFFER_BIT);
	// enable the vertex array rendering
	glEnableClientState(GL_VERTEX_ARRAY);

	// demo : display two red points;
	const GLfloat points[] = {
		0,  0,  
		100,  200,
	};
	glVertexPointer(2, GL_FLOAT, 0, points);
	glPointSize(32);
	glEnable(GL_POINT_SMOOTH);
	glColor4f(1, 0, 0, 1);
	glDrawArrays(GL_POINTS, 0, 2);
}

@end
