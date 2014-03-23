//
//  SolarSwageController.h
//  SolarSwage
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Planet.h"

#define X_VALUE 0
#define Y_VALUE 1
#define Z_VALUE 2
@interface SolarSwageController : NSObject {

	Planet *planetSun;
	Planet *planetMercury;
	Planet *planetVenus;
	Planet *planetEarth;
	Planet *planetMoon;
	Planet *planetMars;

	GLfloat	eyePosition[3];
}

-(id)init;
-(void)initGeometry;
-(void)executeSolarSwage;
-(void)executeSystemPlanet:(Planet *)planet;
-(GLfloat)earthWidths;

@end