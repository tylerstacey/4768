//
//  ViewController.h
//  SolarSwage
//
//  Created by Tyler Stacey on 2014-03-23.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "SolarSwage.h" 
#import "SolarSwageController.h"

@interface SolarSwageViewController : GLKViewController {
	SolarSwageController *solarSwage;
};


-(void)viewDidLoad;
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect;
-(void)setClipping;
-(void)initLighting;

@end
