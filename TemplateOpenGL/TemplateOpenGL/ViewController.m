//
//  ViewController.m
//  OpenGL_2_0
//
//  Created by Minglun Gong on 1/29/2014.
//  Copyright (c) 2014 Minglun Gong. All rights reserved.
//
// Tyler Stacey, 201033446
//
// The view controller handles telling the balls when to update and facilitates
// checking for collisions and some other calculations.

#import "ViewController.h"
#import "Ball.h"

@interface ViewController () {
    
}
@property NSMutableArray *addedBalls;
@property (strong, nonatomic) EAGLContext *context;
@property BOOL ballHeld;
@property NSTimeInterval timeBetweenTouches;
@property NSDate *startDate;
@property Ball *tempBall;
@property float initialXPos;
@property float initialYPos;

- (void)setupGL;
- (void)tearDownGL;
- (void)setupOrthographicView;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

	if (!self.context) {
		NSLog(@"Failed to create ES context");
	}
	
	GLKView *view = (GLKView *)self.view;
	view.context = self.context;
	view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	_addedBalls = [[NSMutableArray alloc] init];
	[self setupGL];
}

- (void)dealloc {
	[self tearDownGL];
	
	if ([EAGLContext currentContext] == self.context) {
		[EAGLContext setCurrentContext:nil];
	}
}

- (void)didReceiveMemoryWarning {
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

- (void)update {
	[self setupOrthographicView];
    if ( self.ballHeld && [self.tempBall ballSize] < 175.0f ){
        self.timeBetweenTouches = [[NSDate date] timeIntervalSinceDate:self.startDate];
        [self.tempBall setBallSize:self.timeBetweenTouches*99.99f];
        [self.tempBall setBallMass:[self.tempBall ballSize]/20];
        NSLog(@"Ball Mass: %f, Ball Size: %f",[self.tempBall ballSize], [self.tempBall ballMass]);
    }
    for (Ball *b in _addedBalls) {
        [b updateBall];
    }
    [self checkBallCollisions];
}

- (void)checkBallCollisions {
    CGSize size = self.view.bounds.size;
    for (int i = 0; i < [_addedBalls count]; i++){
        // Ensure the balls stay withis the bounds of the screen
        if ([_addedBalls[i] xPosition] + [_addedBalls[i] ballSize]/2  >= size.width ){
            [_addedBalls[i] setXPosition: size.width - [_addedBalls[i] ballSize]/2];
            [_addedBalls[i] setXVelocity:[_addedBalls[i] xVelocity]*-1*0.9];
            [_addedBalls[i] setYVelocity:[_addedBalls[i] yVelocity]*0.9];

        }
        if ([_addedBalls[i] xPosition] - [_addedBalls[i] ballSize]/2 <= 0 ){
            [_addedBalls[i] setXPosition: [_addedBalls[i] ballSize]/2];
            [_addedBalls[i] setXVelocity:[_addedBalls[i] xVelocity]*-1*0.9];
            [_addedBalls[i] setYVelocity:[_addedBalls[i] yVelocity]*0.9];
        }
        if ([_addedBalls[i] yPosition] + [_addedBalls[i] ballSize]/2 >= size.height ){
            [_addedBalls[i] setYPosition: size.height - [_addedBalls[i] ballSize]/2];
            [_addedBalls[i] setYVelocity:[_addedBalls[i] yVelocity]*-1*0.9];
            [_addedBalls[i] setXVelocity:[_addedBalls[i] xVelocity]*0.9];
        }
        if ([_addedBalls[i] yPosition] - [_addedBalls[i] ballSize]/2<= 0 ){
            [_addedBalls[i] setYPosition: [_addedBalls[i] ballSize]/2];
            [_addedBalls[i] setYVelocity:[_addedBalls[i] yVelocity]*-1*0.9];
            [_addedBalls[i] setXVelocity:[_addedBalls[i] xVelocity]*0.9];
        }
        for (int j = i + 1; j < [_addedBalls count]; j++){
            if ([_addedBalls[i] colliding:_addedBalls[j]]) {
                // Logic to handle ball-ball collisions
            }
        }
    }
}
- (void)setupGL {
	[EAGLContext setCurrentContext:self.context];
}

- (void)tearDownGL {
	[EAGLContext setCurrentContext:self.context];
}

- (void)setupOrthographicView {
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

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    // clear the rendering buffer
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    // enable the vertex array rendering
    glEnableClientState(GL_VERTEX_ARRAY);
    
    for (Ball *b in _addedBalls) {
        [b drawBall];
    }
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisable(GL_TEXTURE_2D);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.ballHeld = YES;
    self.startDate = [NSDate date];
    // get touch location
	CGPoint pos = [[touches anyObject] locationInView:self.view];
	// get iPhone display size
	CGSize size = self.view.bounds.size;
    Ball *newBall = [[Ball alloc] initWithSize:0 xPosition: pos.x yPosition:size.height - pos.y];
    
    self.initialXPos = pos.x;
    self.initialYPos = size.height - pos.y;
    
    self.tempBall = newBall;
    
    [_addedBalls addObject:newBall];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGSize size = self.view.bounds.size;
    CGPoint pos = [[touches anyObject] locationInView:self.view];
    if (pos.x != self.initialXPos || pos.y != self.initialYPos){
        [self.tempBall setXPosition:pos.x];
        [self.tempBall setYPosition:size.height - pos.y];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.ballHeld = NO;
    CGSize size = self.view.bounds.size;
    
    [self.tempBall setXVelocity:(self.initialXPos - [self.tempBall xPosition])/self.timeBetweenTouches];
    [self.tempBall setYVelocity:(self.initialYPos - [self.tempBall yPosition])/self.timeBetweenTouches];
    NSLog(@"X-Velocity %f", [self.tempBall xVelocity]);
}
@end
