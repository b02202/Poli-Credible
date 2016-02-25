//
//  RegisterViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/20/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "RegisterViewController.h"
#import "FormValidationUtility.h"

@implementation RegisterViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Textfield Setup
    self.usernameField.delegate = self;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon.png"]];
    
    // password field
    self.passField.delegate = self;
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    self.passField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    
    // rightView Touch
    self.passField.rightViewMode = UITextFieldViewModeAlways;
    self.passField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
    [self.passField.rightView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
    passVisible.numberOfTapsRequired = 1;
    [self.passField.rightView addGestureRecognizer:passVisible];
    
    // Re-Enter password field
    self.reEnterPass.delegate = self;
    self.reEnterPass.leftViewMode = UITextFieldViewModeAlways;
    self.reEnterPass.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    
    // rightView Touch
    self.reEnterPass.rightViewMode = UITextFieldViewModeAlways;
    self.reEnterPass.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
    [self.reEnterPass.rightView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
    rePassVisible.numberOfTapsRequired = 1;
    [self.reEnterPass.rightView addGestureRecognizer:rePassVisible];
}
// Set AutoRotate
-(BOOL)shouldAutorotate {
    return NO;
}

// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.reEnterPass resignFirstResponder];
}

// Set password SecureText
-(void)passwordVisibility:(id)sender {
    if (self.passField.secureTextEntry) {
        self.passField.secureTextEntry = NO;
        self.passField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visable-icon.png"]];
        
        [self.passField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passField.rightView addGestureRecognizer:passVisible];
        
    } else if (!self.passField.secureTextEntry){
        
        self.passField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
        self.passField.secureTextEntry = YES;
        [self.passField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passField.rightView addGestureRecognizer:passVisible];
    }
}

// Set Re-EnterPassword SecureText
-(void)rePassVisibility:(id)sender {
    if (self.reEnterPass.secureTextEntry) {
        self.reEnterPass.secureTextEntry = NO;
        self.reEnterPass.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visable-icon.png"]];
        
        [self.reEnterPass.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
        rePassVisible.numberOfTapsRequired = 1;
        [self.reEnterPass.rightView addGestureRecognizer:rePassVisible];
        
    } else if (!self.reEnterPass.secureTextEntry){
        self.reEnterPass.secureTextEntry = YES;
        self.reEnterPass.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
        
        [self.reEnterPass.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
        rePassVisible.numberOfTapsRequired = 1;
        [self.reEnterPass.rightView addGestureRecognizer:rePassVisible];
    }
}

// Back
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Register
- (IBAction)registerAction:(id)sender {
    // Field Validation
    if ([self fieldsAreValid:self.usernameField.text password:self.passField.text rePassword:self.reEnterPass.text]) {
        
        [self checkPasswordMatch];
    }
}
// Field Validation
-(BOOL)fieldsAreValid:(NSString*)email password:(NSString*)pass rePassword:(NSString*)rePass {
    
    if (![FormValidationUtility isValidEmailAddress:email]) {
        // Show Alert
        [self showAlert:@"Oops" message:@"Please enter a valid email address."];
        return NO;
    }
    else if ([self.passField.text isEqualToString:@""] || [self.reEnterPass.text isEqualToString:@""]) {
        
        // Show Alert
        [self showAlert:@"Oops" message:@"You must enter all fields"];
        return NO;
    }
    else if (![FormValidationUtility isValidPassword:pass]) {
        // Show Alert
        [self showAlert:@"Oops" message:@"Sorry, that password does not meet our security guidelines. Please choose a password that is 6-16 characters in length, with a mix of at least 1 number or letter, and 1 symbol."];
        
        return NO;
    }
    else {
        return YES;
    }
}

// Register New User
- (void)registerNewUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.usernameField.text forKey:@"username"];
    [defaults setObject:self.passField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    [defaults synchronize];
    
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
    [myRootRef createUser:self.usernameField.text password:self.passField.text
        withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
     
        if (error) {
                // There was an error creating the account
                NSLog(@"ERROR = %@", error.description);
            // Show Alert
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [errorAlert show];
           // [self fireBaseLogin];
        } else {
            NSString *uid = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", uid);
            // Update User Defaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.usernameField.text forKey:@"username"];
            [defaults setObject:self.passField.text forKey:@"password"];
            [defaults setBool:YES forKey:@"registered"];
            // Show Alert
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have successfully registered a new Poli-Credible user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [successAlert show];
            [self fireBaseLogin];
        }
    }];
}
// Firebase Login Authentication
-(void)fireBaseLogin {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blistering-inferno-8811.firebaseio.com/"];
    [ref authUser:self.usernameField.text password:self.passField.text
        withCompletionBlock:^(NSError *error, FAuthData *authData) {
    
    if (error) {
        // There was an error logging in to this account
        NSLog(@"ERROR = %@", error.description);
        // Show Alert
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.userInfo[@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [errorAlert show];
    } else {
        // Log user in
        [self performSegueWithIdentifier:@"toHome" sender:self];
    }
}];
}
// Check Password Match
-(void) checkPasswordMatch
{
    if ([self.passField.text isEqualToString:self.reEnterPass.text]) {
        NSLog(@"passwords match");
        [self registerNewUser];
    }
    else
    {
        // Show Alert
        [self showAlert:@"Oops" message:@"Your entered passwords do not match"];
    }
}
// Alert Controller
-(void)showAlert:(NSString*)title message:(NSString*)messageString {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:messageString preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}
// Return Text Field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_usernameField resignFirstResponder];
    [_passField resignFirstResponder];
    [_reEnterPass resignFirstResponder];
    return NO;
}

@end
