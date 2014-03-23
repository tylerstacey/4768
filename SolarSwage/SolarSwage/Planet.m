//
//	Planet.m
//	SolarSwage
//
//	Created by Tyler Stacey on 2014-03-23.
//	Copyright (c) 2014 Tyler Stacey. All rights reserved.
//
//	Based on code from Pro OpenGL ES for iOS by Mike Smithwick
//
#import "Planet.h"

GLshort * _textureData = NULL;

@implementation Planet

// I really didn't join this course to do lots of graphics math; so the following
// code comes directly from the previously mentioned book.
// I made sure to write out each line my self and to read the book to understand what each
// line does, I didn't just blindly copy and paste.
-(id)initWithStacks:(GLint)stacks Slices:(GLint)slices Radius:(GLfloat)radius Squash:(GLfloat)squash TextureFile:(NSString *)textureFile {

	unsigned int colorIncrement = 0;
	unsigned int blueValue = 0;
	unsigned int redValue = 255;
	int numberOfVertices;

	// nil is used in place of NULL for the 'id' type and pointers to objects
	if (textureFile != nil){
		planetTextureInfo = [self loadPlanetTexture:textureFile];
	}

	planetScale = radius;
	planetSquash = squash;

	colorIncrement = 255 / stacks;

	if ((self = [super init])){
		planetStacks = stacks;
		planetSlices = slices;
		planetVertexData = nil;
		planetTextureCoordinatesData = nil;

		// In the next few lines we allocate the memory for the vertices and colors

		// Vertices
		GLfloat *vPtr = planetVertexData = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((planetSlices*2+2) * (planetStacks)));	
		
		// Color data
		GLubyte *cPtr = planetColorData = (GLubyte*)malloc(sizeof(GLubyte) * 4 * ((planetSlices*2+2) * (planetStacks)));
		
		// Normal pointers for lighting
		GLfloat *nPtr = planetNormalData = (GLfloat*)malloc(sizeof(GLfloat) * 3 * ((planetSlices*2+2) * (planetStacks)));
		
		GLfloat *tPtr = nil;
		
		if(textureFile != nil)
		{
			tPtr = planetTextureCoordinatesData = (GLfloat *)malloc(sizeof(GLfloat) * 2 * ((planetSlices*2+2) * (planetStacks)));
		}
		
		unsigned int phiIdx;
		unsigned int thetaIdx;

		// Latitude
		// Start from the bottom stack and go to the top stack (-90 to +90 degrees)

		for (phiIdx = 0; phiIdx < planetStacks; phiIdx++){
			// We start at -1.57 radians and go up to +1.57 radians (-90 to +90 deg)

			// Begin the first circle
			float phi0 = M_PI * ((float)(phiIdx) * (1.0 / (float) (planetStacks)) - 0.5);

			// The next Circle
			float phi1 = M_PI * ((float)(phiIdx + 1) * (1.0 / (float) (planetStacks)) - 0.5);

			float cosPhi0 = cos(phi0);
			float sinPhi0 = sin(phi0);
			float cosPhi1 = cos(phi1);
			float sinPhi1 = sin(phi1);

			float cosTheta, sinTheta;

			// Longitude
			for (thetaIdx = 0; thetaIdx < planetSlices; thetaIdx++){

				//Increment along the longitude circle each "slice."
				
				float theta = -2.0 * M_PI * ((float)thetaIdx) * (1.0/(float)(planetSlices - 1));
				cosTheta = cos(theta);
				sinTheta = sin(theta);
				
				//We're generating a vertical pair of points, such
				//as the first point of stack 0 and the first point
				//of stack 1
				//above it. This is how TRIANGLE_STRIPS work,
				//taking a set of 4 vertices and essentially drawing
				//two triangles
				//at a time. The first is v0-v1-v2 and the next is
				//v2-v1-v3. Etc.
				
				//Get x-y-z for the first vertex of stack.
				
				vPtr[0] = planetScale * cosPhi0 * cosTheta;
				vPtr[1] = planetScale * sinPhi0 * planetSquash;
				vPtr[2] = planetScale * cosPhi0 * sinTheta;
				
				//the same but for the vertex immediately above the
				//previous one
				
				vPtr[3] = planetScale * cosPhi1 * cosTheta;
				vPtr[4] = planetScale * sinPhi1 * planetSquash;
				vPtr[5] = planetScale * cosPhi1 * sinTheta;
				
				//normal pointers for lighting
				
				nPtr[0] = cosPhi0 * cosTheta;
				nPtr[2] = cosPhi0 * sinTheta;
				nPtr[1] = sinPhi0;
				
				nPtr[3] = cosPhi1 * cosTheta;
				nPtr[5] = cosPhi1 * sinTheta;
				nPtr[4] = sinPhi1;

				if (tPtr != nil){
					GLfloat texX = (float)thetaIdx * (1.0f/(float)(planetSlices - 1));
					tPtr[0] = texX;
					tPtr[1] = (float)(phiIdx) * (1.0f/(float)(planetStacks));
					tPtr[2] = texX;
					tPtr[3] = (float)(phiIdx + 1) * (1.0f/(float)(planetStacks));
				}

				cPtr[0] = redValue;
				cPtr[1] = 0;
				cPtr[2] = blueValue;
				cPtr[4] = redValue;
				cPtr[5] = 0;
				cPtr[6] = blueValue;
				cPtr[3] = cPtr[7] = 255;
				
				cPtr += 2 * 4;
				vPtr += 2 * 3;
				nPtr += 2 * 3;

				if (tPtr != nil){
					tPtr += 2 * 2;
				}
			}
			blueValue += colorIncrement;
			redValue -= colorIncrement;
			
			// Degenerate triangle to connect stacks and maintain winding order.
			
			vPtr[0] = vPtr[3] = vPtr[-3];
			vPtr[1] = vPtr[4] = vPtr[-2];
			vPtr[2] = vPtr[5] = vPtr[-1];
			
			nPtr[0] = nPtr[3] = nPtr[-3];
			nPtr[1] = nPtr[4] = nPtr[-2];
			nPtr[2] = nPtr[5] = nPtr[-1];
			
			if(tPtr!=nil) {
				tPtr[0] = tPtr[2] = tPtr[-2];
				tPtr[1] = tPtr[3] = tPtr[-1];
			}
		}
		numberOfVertices = (vPtr - planetVertexData) / 6;
	}
	planetAngle = 0.0;
	planetRotationalIncrement = 0.0;
	
	planetPos[0] = 0.0;
	planetPos[1] = 0.0;
	planetPos[2] = 0.0;
	
	return self;
}

-(bool)executePlanet {

	// Initializes the matrix to an unrotated state
	glMatrixMode(GL_MODELVIEW);
	// Remove the 'triangles' that are not facing the viewer.
	// The faces that are removed is determined by the 'winding', the order of the vertices for the faces
	glEnable(GL_CULL_FACE);
	glCullFace(GL_BACK);
	glFrontFace(GL_CW);

	//  Tells the system to make use of our data.
	glEnableClientState(GL_NORMAL_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);

	if(planetTextureInfo != nil){
		glEnable(GL_TEXTURE_2D);                                     //1
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		if(planetTextureInfo != 0) {
			glBindTexture(GL_TEXTURE_2D, planetTextureInfo.name);
		}
		
		glTexCoordPointer(2, GL_FLOAT, 0, planetTextureCoordinatesData);
	}

	// Initializes the matrix to an unrotated state
	glMatrixMode(GL_MODELVIEW);
	
	// Hands off a pointer to the vertex array and says that it has only three float values
	glVertexPointer(3, GL_FLOAT, 0, planetVertexData);
	glNormalPointer(GL_FLOAT, 0, planetNormalData);
	
	glColorPointer(4, GL_UNSIGNED_BYTE, 0, planetColorData);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, (planetSlices + 1) * 2 * (planetStacks - 1) + 2);
	
	glDisable(GL_BLEND);
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	return true;
}

-(void)getPlanetPositionX:(GLfloat *)x Y:(GLfloat *)y Z:(GLfloat *)z {
	*x = planetPos[0];
	*y = planetPos[1];
	*z = planetPos[2];
}

-(void)setPlanetPositionX:(GLfloat)x Y:(GLfloat)y Z:(GLfloat)z {
	planetPos[0] = x;
	planetPos[1] = y;
	planetPos[2] = z;
}

-(GLfloat)getPlanetRotation {
	return planetAngle;
}

-(void)setPlanetRotation:(GLfloat)angle {
	planetAngle = angle;
}

-(GLfloat)getPlanetRotationalIncrement {
	return planetRotationalIncrement;
}

-(void)setPlanetRotationalIncrement:(GLfloat)incrementAmount {
	planetRotationalIncrement = incrementAmount;
}

-(void)incrementPlanetRotation {
	planetAngle += planetRotationalIncrement;
}

-(GLKTextureInfo *)loadPlanetTexture:(NSString *)textureFile {
	NSError *error;
	GLKTextureInfo *info;
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
						    [NSNumber numberWithBool:YES], GLKTextureLoaderOriginBottomLeft,
						    [NSNumber numberWithBool:TRUE], GLKTextureLoaderGenerateMipmaps, nil];

	
	NSString *path = [[NSBundle mainBundle]pathForResource:textureFile ofType:NULL];
	
	info = [GLKTextureLoader textureWithContentsOfFile:path options:options error:&error];
	
	glBindTexture(GL_TEXTURE_2D, info.name);
	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT); 	
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);	
	
	return info;
}
@end
