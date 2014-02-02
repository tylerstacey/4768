//
//  ViewController.h
//  SuperCalc
//
//  Created by Tyler Stacey on 2/1/2014.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    IBOutlet UILabel *calculatorScreen;
    
    NSNumberFormatter *formatString;
    NSNumber *parsedNumber;
    
    int operationId;
    float numberOnScreen;
    float runningTotal;
    
}
-(IBAction)digitPressed:(id)sender;
-(IBAction)positiveNegativeButton:(id)sender;
-(IBAction)dotPressed:(id)sender;
-(IBAction)operationPressed:(id)sender;
-(IBAction)equalsButton:(id)sender;
-(IBAction)allClear:(id)sender;
-(IBAction)backSpace:(id)sender;

//Bonus Features
-(IBAction)squareRoot:(id)sender;
-(IBAction)squareNumber:(id)sender;
-(IBAction)cubeNumber:(id)sender;
-(IBAction)inverseNumber:(id)sender;
@end
