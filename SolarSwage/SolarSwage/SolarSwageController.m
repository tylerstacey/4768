//
//  SolarSwageController.m
//  SolarSwage
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import "SolarSwage.h"
#import "SolarSwageController.h"

@implementation SolarSwageController

-(id)init {
	[self initGeometry];

	return self;
}

-(void)initGeometry {
	eyePosition[X_VALUE] = 0.0;
	eyePosition[Y_VALUE] = 0.0;
	eyePosition[Z_VALUE] = 10.0;

	planetSun = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:1.0] Squash:1.0 TextureFile:@"Earth.png"];
	[planetEarth setPlanetPositionX:0.0 Y:0.0 Z:-2.0];

	planetEarth = [[Planet alloc] initWithStacks:50 Slices:50 Radius:[self earthWidths:3.0] Squash:1.0 TextureFile:@"Sun.png"];
	[planetEarth setPlanetPositionX:0.0 Y:0.0 Z:0.0];
}

-(void)executeSolarSwage {
	GLfloat paleYellow[] = {1.0,1.0,0.3,1.0};
	GLfloat white[] = {1.0,1.0,1.0,1.0};			
	GLfloat cyan[] = {0.0,1.0,1.0,1.0};	
	GLfloat black[] = {0.0,0.0,0.0,0.0};
	static GLfloat angle = 0.0;
	GLfloat orbitalIncrement = 1.25;
	GLfloat sunPos[3] = {0.0,0.0,0.0};					

	glPushMatrix();
    
	glTranslatef(-eyePosition[X_VALUE],-eyePosition[Y_VALUE],
                 -eyePosition[Z_VALUE]);
    
	glLightfv(SS_SUNLIGHT,GL_POSITION,sunPos);
	glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, cyan);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, white);
    
	glPushMatrix();
	
	angle += orbitalIncrement;
	
	glRotatef(angle,0.0,1.0,0.0);
	
	[self executeSystemPlanet:planetEarth];
	
	glPopMatrix();
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, paleYellow);
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, black);
    
	[self executeSystemPlanet:planetSun];
	
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, black);
	
	glPopMatrix();
}

-(void)executeSystemPlanet:(Planet *)planet
{
	GLfloat posX, posY, posZ;
		
	glPushMatrix();
    
	[planet getPlanetPositionX:&posX Y:&posY Z:&posZ];			//17
	
	glTranslatef(posX,posY,posZ);				//18
    
	[planet executePlanet];						//19
	
	glPopMatrix();
}

-(GLfloat)earthWidths:(GLfloat)width {
	return width * 0.5;
}
@end
