//
//  Ball.m
//  TemplateOpenGL
//
// Tyler Stacey, 201033446
//
// Ball.m is the implementation of the Ball interface

#import "Ball.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@implementation Ball

- (id) initWithSize: (double)ballSize
          xPosition: (float)xPosition
          yPosition: (float)yPosition {
    if (self = [super init]){
        self.ballSize = ballSize;
        self.xPosition = xPosition;
        self.yPosition = yPosition;
        
        self.redValue = (arc4random()%255/255.0f);
        self.greenValue = (arc4random()%255/255.0f);
        self.blueValue = (arc4random()%255/255.0f);
    }
    return self;
}
- (void) drawBall {
    const GLfloat points[] = {
		(CGFloat)self.xPosition, (CGFloat)self.yPosition,
	};
    glVertexPointer(2, GL_FLOAT, 0, points);
	glPointSize(self.ballSize);
	glEnable(GL_POINT_SMOOTH);
	glColor4f(self.redValue, self.greenValue, self.blueValue, 1);
	glDrawArrays(GL_POINTS, 0, 1);
}
- (void) updateBall {
    self.xPosition = (self.xPosition - self.xVelocity / 10);
    self.yPosition = (self.yPosition - self.yVelocity / 10);
}

- (BOOL) colliding:(Ball *)ball {
    float xd = self.xPosition - [ball xPosition];
    float yd = self.yPosition - [ball yPosition];
    
    float sumRadius = self.ballSize/2 + [ball ballSize]/2;
    float sqrRadius = sumRadius * sumRadius;
    
    float distSqr = (xd * xd) + (yd * yd);
    
    if (distSqr <= sqrRadius) {
        return YES;
    }
    
    return NO;
}
@end
