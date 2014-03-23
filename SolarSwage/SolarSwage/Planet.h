//
//  Planet.h
//  SolarSwage
//	
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//
//	Based on code from Pro OpenGL ES for iOS by Mike Smithwick
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>
#import <GLKit/GLKit.h>

@interface Planet : NSObject {
@private
	GLfloat *planetVertexData;
	GLubyte *planetColorData;
	GLfloat *planetNormalData;
	GLfloat *planetTextureCoordinatesData;
	GLint planetStacks;
	GLint planetSlices;
	GLfloat planetScale;
    GLfloat planetSquash;
	GLfloat planetAngle;
	GLfloat planetPos[3];
	GLfloat planetRotationalIncrement;

	GLKTextureInfo *planetTextureInfo;
}
// Generate the 3D Sphere
-(id)initWithStacks:(GLint)stacks Slices:(GLint)slices Radius:(GLfloat)radius Squash:(GLfloat)squash TextureFile:(NSString *)textureFile;
// Render the planet
-(bool)executePlanet;
-(void)getPlanetPositionX:(GLfloat *)x Y:(GLfloat *)y Z:(GLfloat *)z;
-(void)setPlanetPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z;
-(GLfloat)getPlanetRotation;
-(void)setPlanetRotation:(GLfloat)angle;
-(GLfloat)getPlanetRotationalIncrement;
-(void)setPlanetRotationalIncrement:(GLfloat)incrementAmount;
-(void)incrementPlanetRotation;
-(GLKTextureInfo *)loadPlanetTexture:(NSString *)textureFile;

@end
