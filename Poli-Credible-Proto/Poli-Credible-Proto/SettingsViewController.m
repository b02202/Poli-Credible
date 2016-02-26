//
//  SettingsViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "FormValidationUtility.h"
#import <Firebase/Firebase.h>
@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // set background color
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // TextFields
    self.usernameField.delegate = self;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon.png"]];
    
    self.passField.delegate = self;
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    self.passField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    // Cancel Button
    self.cancelBtn.hidden = YES;
    // Set field text
    [self setPlaceholders];
}
// set auto rotate to no
-(BOOL)shouldAutorotate {
    return NO;
}
// Update Email Action
- (IBAction)updateAction:(id)sender {
    self.resetBtn.hidden = NO;
    self.updateBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    // Set UsernameField
    self.usernameField.enabled = YES;
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.textColor = [UIColor blackColor];
    self.passField.enabled = NO;
    // updatePassBtn
    self.updatePassBtn.hidden = YES;
    // Set Bool
    self.emailIsUpdating = YES;
}

// Change Defaults
-(void)changeDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // set defaults
    [defaults setObject:self.usernameField.text forKey:@"username"];
    [defaults setObject:self.passField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    [defaults synchronize];
    // set placeholder text
    [self setPlaceholders];
}


// Reset Button
- (IBAction)resetAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (self.emailIsUpdating) {
        // valid email check
        if (![FormValidationUtility isValidEmailAddress:self.usernameField.text]) {
            self.updateSuccess = NO;
            self.usernameField.text = [defaults valueForKey:@"username"];
            // Show Alert
            [self showAlert:@"Oops" message:@"Please enter a valid email address."];
        }
        else {
            // update email
            Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
            [ref changeEmailForUser:[defaults valueForKey:@"username"] password:[defaults valueForKey:@"password"]
                         toNewEmail:self.usernameField.text withCompletionBlock:^(NSError *error) {
                             if (error) {
                                 self.usernameField.text = [defaults valueForKey:@"username"];
                                 self.updateSuccess = NO;
                                 // There was an error processing the request
                                 NSLog(@"ERROR = %@", error.description);
                                 // Show Alert
                                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [errorAlert show];
                             } else {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                 self.updateSuccess = YES;
                                 // Email changed successfully
                                 // set defaults
                                     [self changeDefaults];
                                 });
                                  UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your email address has been successfully changed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [successAlert show];
                             }
                         }];
        }
    }
    else {
        if (![FormValidationUtility isValidPassword:self.passField.text]) {
            self.updateSuccess = NO;
            self.passField.text = [defaults valueForKey:@"password"];
            // Show Alert
            [self showAlert:@"Oops" message:@"Sorry, that password does not meet our security guidelines. Please choose a password that is 6-16 characters in length, with a mix of at least 1 number or letter, and 1 symbol."];
        }
        else {
            // update pass
            Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
            [ref changePasswordForUser:[defaults valueForKey:@"username"] fromOld:[defaults valueForKey:@"password"]
                         toNew:self.passField.text withCompletionBlock:^(NSError *error) {
                             if (error) {
                                 self.passField.text = [defaults valueForKey:@"password"];
                                 self.updateSuccess = NO;
                                 // There was an error processing the request
                                 NSLog(@"ERROR = %@", error.description);
                                 // Show Alert
                                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [errorAlert show];
                             } else {
                                 // Password changed successfully
                                 self.updateSuccess = YES;
                                 [self changeDefaults];
                                 // Show Alert
                                 UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been successfully changed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [successAlert show];
                             }
                         }];
        }
    }
    // set visibility
    self.resetBtn.hidden = YES;
    self.updateBtn.hidden = NO;
    self.updatePassBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    // usernameField
    self.usernameField.enabled = NO;
    self.usernameField.textColor = [UIColor whiteColor];
    self.usernameField.backgroundColor = [UIColor clearColor];
    // passField
    self.passField.enabled = NO;
    self.passField.textColor = [UIColor whiteColor];
    self.passField.backgroundColor = [UIColor clearColor];
}

// set field text
-(void)setPlaceholders {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usernameField.text = [defaults objectForKey:@"username"];
    self.passField.text = [defaults objectForKey:@"password"];
}
// Cancel Button
- (IBAction)cancelAction:(id)sender {
    self.resetBtn.hidden = YES;
    self.updateBtn.hidden = NO;
    self.updatePassBtn.hidden= NO;
    self.cancelBtn.hidden = YES;
    // usernamefield
    self.usernameField.enabled = NO;
    self.usernameField.backgroundColor = [UIColor clearColor];
    self.usernameField.textColor = [UIColor whiteColor];
    // passfield
    self.passField.enabled = NO;
    self.passField.backgroundColor = [UIColor clearColor];
    self.passField.textColor = [UIColor whiteColor];
    self.passField.enabled = NO;
    [self setPlaceholders];
}
// Change Password Button
- (IBAction)changePassAction:(id)sender {
    self.cancelBtn.hidden = NO;
    self.updatePassBtn.hidden = YES;
    self.updateBtn.hidden = YES;
    self.passField.enabled = YES;
    self.passField.backgroundColor = [UIColor whiteColor];
    self.passField.textColor = [UIColor blackColor];
    // reset btn
    self.resetBtn.hidden = NO;
    //set EmailEditing Bool
    self.emailIsUpdating = NO;
}

// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passField resignFirstResponder];
}
@end
