//
//  Ball.h
//  TemplateOpenGL
//
// Tyler Stacey, 201033446
//
// Ball.h provides the interface describing a ball.

#import <Foundation/Foundation.h>

@interface Ball : NSObject {
    // The public properties and behavior are defined inside
    // the @interface declaration.
}
// Properties of an object are intended for public access.
@property float xPosition;
@property float yPosition;
@property float xVelocity;
@property float yVelocity;
@property double ballSize;
@property float ballMass;

@property float redValue;
@property float greenValue;
@property float blueValue;

- (id) initWithSize: (double)ballSize
          xPosition: (float)xPosition
          yPosition: (float)yPosition;
- (void) drawBall;
- (void) updateBall;
- (BOOL) colliding: (Ball*) ball;
@end
