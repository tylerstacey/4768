//
//  ViewController.m
//  SuperCalc
//
//  Created by Tyler Stacey on 2/1/2014.
//  Copyright (c) 2014 Tyler Stacey. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 * digitPressed uses the sender tag of the button to determine the number
 * that should be added on screen. Then the string on screen is parsed to 
 * determine the number that is being displayed.
 */
-(IBAction)digitPressed:(id)sender {
    formatString = [[NSNumberFormatter alloc] init];
    parsedNumber = [formatString numberFromString:calculatorScreen.text];
    if (parsedNumber.floatValue == 0) {
        calculatorScreen.text = @"";
    }
    if (operationId != 0 && numberOnScreen == 0) {
        calculatorScreen.text = @"";
    }
    calculatorScreen.text = [calculatorScreen.text stringByAppendingFormat:@"%ld", (long)[sender tag]];
    parsedNumber = [formatString numberFromString:calculatorScreen.text];
    numberOnScreen = parsedNumber.floatValue;
    
}
/**
 * Negates the number currently on the screen.
 */
-(IBAction)positiveNegativeButton:(id)sender {
    numberOnScreen *= -1;
    [self updateScreen];
}
/**
 * Appends a decimal point to the screen so the user can enter floats.
 */
-(IBAction)dotPressed:(id)sender {
    if ([calculatorScreen.text rangeOfString:@"."].location == NSNotFound) {
        calculatorScreen.text = [calculatorScreen.text stringByAppendingFormat:@"."];
    }
}
/**
 * Uses the operationId to perform the current operation before updating the
 * operationId to be the latest pressed operation.
 */
-(IBAction)operationPressed:(id)sender{
    if (runningTotal == 0) {
        runningTotal = numberOnScreen;
    } else{
        switch (operationId) {
            case 1:
                runningTotal = runningTotal * numberOnScreen;
                break;
            case 2:
                runningTotal = runningTotal / numberOnScreen;
                break;
            case 3:
                runningTotal = runningTotal - numberOnScreen;
                break;
            case 4:
                runningTotal = runningTotal + numberOnScreen;
                break;
            case 5:
                runningTotal = pow(runningTotal, numberOnScreen);
                break;
            default:
                break;
        }
    }
    operationId = [sender tag];
    numberOnScreen = 0;
}
/**
 * Evaluates the pending operation and posts the result to the screen.
 */
-(IBAction)equalsButton:(id)sender {
    if (runningTotal == 0) {
        runningTotal = numberOnScreen;
    } else{
        switch (operationId) {
            case 1:
                runningTotal = runningTotal * numberOnScreen;
                break;
            case 2:
                runningTotal = runningTotal / numberOnScreen;
                break;
            case 3:
                runningTotal = runningTotal - numberOnScreen;
                break;
            case 4:
                runningTotal = runningTotal + numberOnScreen;
                break;
            case 5:
                runningTotal = pow(runningTotal, numberOnScreen);
                break;
            default:
                break;
        }
    }
    operationId = 0;
    numberOnScreen = 0;
    calculatorScreen.text = [NSString stringWithFormat:@"%.2f", runningTotal];
}
/**
 * Deletes the rightmost digit on the screen.
 */
-(IBAction)backSpace:(id)sender {
    calculatorScreen.text = [calculatorScreen.text substringToIndex:calculatorScreen.text.length-(calculatorScreen.text.length>0)];
    formatString = [[NSNumberFormatter alloc] init];
    parsedNumber = [formatString numberFromString:calculatorScreen.text];
    numberOnScreen = parsedNumber.floatValue;
}
/**
 * Resets the calculator to it's start state.
 */
-(IBAction)allClear:(id)sender {
    operationId = 0;
    runningTotal = 0;
    numberOnScreen = 0;
    calculatorScreen.text = [NSString stringWithFormat:@"0"];
}
/**
 * Returns the square root of the number currently on screen.
 */
-(IBAction)squareRoot:(id)sender{
    numberOnScreen = sqrtf(numberOnScreen);
    [self updateScreen];
}
/**
 * Squares the number currently on screen.
 */
-(IBAction)squareNumber:(id)sender{
    numberOnScreen = numberOnScreen * numberOnScreen;
    [self updateScreen];
}
/**
 * Cubes the number currently on screen.
 */
-(IBAction)cubeNumber:(id)sender{
    numberOnScreen = numberOnScreen * numberOnScreen * numberOnScreen;
    [self updateScreen];
}
/**
 * Returns the inverse of the number currently on screen.
 */
-(IBAction)inverseNumber:(id)sender{
    numberOnScreen = 1 / numberOnScreen;
    [self updateScreen];
}
/**
 * Update the value on the screen, moved to method to reduce repeated code.
 */
- (void)updateScreen {
    calculatorScreen.text = [NSString stringWithFormat:@"%.2f", (float)numberOnScreen];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
