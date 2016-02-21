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

/*
 @property (strong, nonatomic) IBOutlet UITextField *usernameField;
 @property (strong, nonatomic) IBOutlet UITextField *passField;
 @property (strong, nonatomic) IBOutlet UITextField *reEnterPass;
 @property (strong, nonatomic) IBOutlet UIButton *registerBtn;
 */

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self fieldsAreValid:self.usernameField.text password:self.passField.text rePassword:self.reEnterPass.text]) {
        
        if ([self.usernameField.text isEqualToString:[defaults objectForKey:@"username"]]) {
            NSString *errorString = [NSString stringWithFormat:@"%@ is already a registered user", self.usernameField.text];
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [error show];
        }
        else {
            [self checkPasswordMatch];
        }
    }
    
    
//    if ([self.usernameField.text isEqualToString:@""] || [self.passField.text isEqualToString:@""] || [self.reEnterPass.text isEqualToString:@""]) {
//        
//        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must enter all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        
//        [error show];
//    }
//    else
//    {
//        [self checkPasswordMatch];
//        
//    }
    
}

-(BOOL)fieldsAreValid:(NSString*)email password:(NSString*)pass rePassword:(NSString*)rePass {
    
    if (![FormValidationUtility isValidEmailAddress:email]) {
        UIAlertView *emailError = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please enter a valid email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [emailError show];
        return NO;
    }
    else if ([self.passField.text isEqualToString:@""] || [self.reEnterPass.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must enter all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
        return NO;
    }
    else if (![FormValidationUtility isValidPassword:pass]) {
        UIAlertView *PassError = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Sorry, that password does not meet our security guidelines. Please choose a password that is 6-16 characters in length, with a mix of at least 1 number or letter, and 1 symbol." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [PassError show];
        return NO;
    }
    else {
        return YES;
    }
    
}

// Register New User
- (void) registerNewUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.usernameField.text forKey:@"username"];
    [defaults setObject:self.passField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new Poli-Credible user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"toHome" sender:self];
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
        NSLog(@"password don't match");
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

// Return Text Field
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_usernameField resignFirstResponder];
    [_passField resignFirstResponder];
    [_reEnterPass resignFirstResponder];
    return NO;
}

@end
