//
//  ViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "ViewController.h"
#import "RegisterViewController.h"
#import "FormValidationUtility.h"
#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property (nonatomic, assign) BOOL isVisible;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Touch ID Check
    [self touchIDVislibility];
    
    // TextField Setup
    // username field
    self.usernameField.delegate = self;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon.png"]];
    
    
    // password field
    self.passwordField.delegate = self;
    // font
    //self.passwordField.font = [UIFont systemFontOfSize:14];
    [self.passwordField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // left view
    self.passwordField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    // right view
    self.passwordField.rightViewMode = UITextFieldViewModeAlways;
    self.passwordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
    [self.passwordField.rightView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
    passVisible.numberOfTapsRequired = 1;
    [self.passwordField.rightView addGestureRecognizer:passVisible];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set Autorotate to NO
-(BOOL)shouldAutorotate {
    return NO;
}
// Touch ID Visibility
-(void)touchIDVislibility {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        self.touchIDBtn.hidden = YES;
    }
    else {
        NSLog(@"user is registered");
        // _reEnterPasswordField.hidden = YES;
        self.touchIDBtn.hidden = NO;
    }
}
// Touch ID Implementation
-(void)touchID {
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    NSString *reason = @"Please authenticate using Touch ID";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:reason
                          reply:^(BOOL success, NSError *error) {
                              if (success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self firebaseLogin:[defaults valueForKey:@"username"] password:[defaults valueForKey:@"password"]];
                                  });
                              }
                              else {
                                  //Error Handling
                                  NSLog(@"Error received: %ld", (long)error.code);
                              }
                          }];
    }
    else {  
        NSLog(@"Can not evaluate Touch ID");
    }
}
// User Login (Firebase)
-(void)firebaseLogin:(NSString*)username password:(NSString*)pass {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
    [ref authUser:username password:pass withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
        if (error) {
            // There was an error logging in to this account
            NSLog(@"ERROR = %@", error.userInfo[@"NSLocalizedDescription"]);
            NSString *errorString = error.userInfo[@"NSLocalizedDescription"];
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oops" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlert show];
        }
        else {
            // Logged in - Launch app
            NSLog(@"USER Email = %@", authData.providerData[@"email"]);
            NSLog(@"IS TEMP %@", authData.providerData[@"isTemporaryPassword"]);
            // set User Defaults
            [defaults setObject:username forKey:@"username"];
            [defaults setObject:pass forKey:@"password"];
            [defaults setBool:YES forKey:@"registered"];
            [defaults synchronize];
            // Check if password is Temporary
            NSString *isTemp = authData.providerData[@"isTemporaryPassword"];
            if ([isTemp boolValue] == 1) {
                // Prompt user to change password
                UIAlertView * passAlert =[[UIAlertView alloc ] initWithTitle:@"Change Password" message:@"Please update your password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                passAlert.tag = 1;
                passAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                [passAlert addButtonWithTitle:@"Login"];
                [passAlert show];
            }
            else {
                [self performSegueWithIdentifier:@"login" sender:self];
            }
        }
    }];
}
// Change password from alertview
-(void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            UITextField *newPassword = [alertView textFieldAtIndex:0];
            if ([FormValidationUtility isValidPassword:newPassword.text]) {
                // set defaults
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                //[defaults setObject:self.usernameField.text forKey:@"username"];
                [defaults setObject:newPassword.text forKey:@"password"];
                [defaults synchronize];
                [self updateFirebasePass:newPassword.text];
                
                // launch app
                [self performSegueWithIdentifier:@"login" sender:self];
                
            } else {
                [self showAlert:@"Oops" message:@"Sorry, that password does not meet our security guidelines. Please choose a password that is 6-16 characters in length, with a mix of at least 1 number or letter, and 1 symbol."];
            }
        }
    }
}
// update Password (Firebase)
-(void)updateFirebasePass:(NSString*)newPass {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
    [ref changePasswordForUser:self.usernameField.text fromOld:self.passwordField.text
                         toNew:newPass withCompletionBlock:^(NSError *error) {
                             if (error) {
                                 // There was an error processing the request
                                 NSLog(@"ERROR = %@", error.description);
                                 // Show Alert
                                 UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [errorAlert show];
                             } else {
                                 NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
                                 [userD  setBool:YES forKey:@"registered"];
                                 [userD synchronize];
                                 // Password changed successfully
                                 UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your password has been successfully changed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                 [successAlert show];
                             }
                         }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.passwordField.font = [UIFont systemFontOfSize:14];
   
}
- (void)textFieldDidChange:(id)sender
{
    UITextField *textField = (UITextField *)sender;
    if (textField == self.passwordField) {
        textField.font = [UIFont systemFontOfSize:14];
        self.passwordField.font = [UIFont systemFontOfSize:14];
        
        if (textField.editing || textField.editing ) {
            textField.font = [UIFont systemFontOfSize:14];
            self.passwordField.font = [UIFont systemFontOfSize:14];
        }
    }
    
    else {
        textField.font = [UIFont systemFontOfSize:14];
        self.passwordField.font = [UIFont systemFontOfSize:14];
    }
    
    if (textField.text.length == 0) {
        textField.font = [UIFont systemFontOfSize:14];
        self.passwordField.font = [UIFont systemFontOfSize:14];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    self.passwordField.font = [UIFont systemFontOfSize:14];
   
}


// Set password SecureText
-(void)passwordVisibility:(id)sender {
    
    if (self.passwordField.secureTextEntry) {
        self.passwordField.secureTextEntry = NO;
        self.passwordField.font = [UIFont systemFontOfSize:14];
        self.passwordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visable-icon.png"]];
        if (self.passwordField.editing) {
            self.passwordField.font = [UIFont systemFontOfSize:14];
        }
        [self.passwordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passwordField.rightView addGestureRecognizer:passVisible];
        
    } else if (!self.passwordField.secureTextEntry){
        
        self.passwordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
        self.passwordField.secureTextEntry = YES;
        if (self.passwordField.editing) {
            self.passwordField.font = [UIFont systemFontOfSize:14];
        }
        self.passwordField.font = [UIFont systemFontOfSize:14];
        [self.passwordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passwordField.rightView addGestureRecognizer:passVisible];
    }
}
// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
// Login Button
- (IBAction)loginUser:(id)sender {
    [self firebaseLogin:self.usernameField.text password:self.passwordField.text];
}
// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// Touch ID Button
- (IBAction)touchIDAction:(id)sender {
    
    [self touchID];
}
// Forgot Password Button
- (IBAction)forgotPassword:(id)sender {
    if ([self.usernameField.text isEqualToString:@""]) {
        [self showAlert:@"Oops" message:@"Please enter your email address"];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reset Password" message:@"Are you sure you want to reset your password?"preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                    {
                        Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
                        [ref resetPasswordForUser:self.usernameField.text withCompletionBlock:^(NSError *error) {
                                if (error) {
                                    // There was an error processing the request
                                    NSLog(@"ERROR = %@", error.description);
                                    // Show Alert
                                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [errorAlert show];
                                    
                                } else {
                                    // Password reset sent successfully
                                    NSString *messageString = [NSString stringWithFormat:@"Password recovery instructions have been sent to %@", self.usernameField.text];
                                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:messageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [successAlert show];
                                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                    [defaults setBool:NO forKey:@"registered"];
                                    self.touchIDBtn.hidden = YES;
                                }
                        }];
                    }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    return NO;
}

@end
