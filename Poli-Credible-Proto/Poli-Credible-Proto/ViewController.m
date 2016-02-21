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

@interface ViewController ()
@property (nonatomic, assign) BOOL isVisible;
@end

@implementation ViewController

- (void)viewDidLoad {
    // set background color
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // NSUser Defaults Implementation
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    if (![defaults boolForKey:@"registered"]) {
//        NSLog(@"No user registered");
//        //_loginBtn.hidden = YES;
//    }
//    else {
//        NSLog(@"user is registered");
//        _reEnterPasswordField.hidden = YES;
//       // self.resetButton.hidden = YES;
//    }
    
    // Hide ReEnterPassField initially
    self.reEnterPasswordField.hidden = YES;
    self.resetButton.hidden = YES;
    
    // TextField Setup
    // username field
    self.usernameField.delegate = self;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon.png"]];
    
    // password field
    self.passwordField.delegate = self;
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
    
    // Re-Enter Pass Field
    self.reEnterPasswordField.delegate = self;
    // left view
    self.reEnterPasswordField.leftViewMode = UITextFieldViewModeAlways;
    self.reEnterPasswordField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    // right view
    self.reEnterPasswordField.rightViewMode = UITextFieldViewModeAlways;
    self.reEnterPasswordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
    [self.reEnterPasswordField.rightView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
    rePassVisible.numberOfTapsRequired = 1;
    [self.reEnterPasswordField.rightView addGestureRecognizer:rePassVisible];
    
    //self.isVisible =
    
    
    // Register for Keyboard Notifications
    //[self registerForKeyboardNotifications];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Set password SecureText
-(void)passwordVisibility:(id)sender {
    
    if (self.passwordField.secureTextEntry) {
        self.passwordField.secureTextEntry = NO;
        self.passwordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visable-icon.png"]];
        
        [self.passwordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passwordField.rightView addGestureRecognizer:passVisible];
        
    } else if (!self.passwordField.secureTextEntry){
        
        self.passwordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
        self.passwordField.secureTextEntry = YES;
        [self.passwordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *passVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordVisibility:)];
        passVisible.numberOfTapsRequired = 1;
        [self.passwordField.rightView addGestureRecognizer:passVisible];
    }
}

// Set Re-EnterPassword SecureText
-(void)rePassVisibility:(id)sender {
    
    if (self.reEnterPasswordField.secureTextEntry) {
        self.reEnterPasswordField.secureTextEntry = NO;
        self.reEnterPasswordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"visable-icon.png"]];
        
        [self.reEnterPasswordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
        rePassVisible.numberOfTapsRequired = 1;
        [self.reEnterPasswordField.rightView addGestureRecognizer:rePassVisible];
        
    } else if (!self.reEnterPasswordField.secureTextEntry){
        self.reEnterPasswordField.secureTextEntry = YES;
        self.reEnterPasswordField.rightView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hidden-icon.png"]];
        
        [self.reEnterPasswordField.rightView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *rePassVisible = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rePassVisibility:)];
        rePassVisible.numberOfTapsRequired = 1;
        [self.reEnterPasswordField.rightView addGestureRecognizer:rePassVisible];
    }
}


// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.reEnterPasswordField resignFirstResponder];
}



- (IBAction)loginUser:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([_usernameField.text isEqualToString:[defaults objectForKey:@"username"]] && [_passwordField.text isEqualToString:[defaults objectForKey:@"password"]]) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    else
    {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your username and password are not valid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

- (IBAction)cancelAction:(id)sender {
    self.loginBtn.hidden = NO;
    self.forgotPassBtn.hidden = NO;
    self.reEnterPasswordField.hidden = YES;
    self.resetButton.hidden = YES;
    self.cancelBtn.hidden = YES;
}

- (IBAction)forgotPassword:(id)sender {
    self.reEnterPasswordField.hidden = NO;
    self.resetButton.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.loginBtn.hidden = YES;
    self.forgotPassBtn.hidden = YES;
}

- (IBAction)resetBtn:(id)sender {
    [self resetPassword];
}

-(void)resetPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([_usernameField.text isEqualToString:[defaults objectForKey:@"username"]] && [self passValid:self.passwordField.text]) {
        if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
            [defaults setObject:_passwordField.text forKey:@"password"];
            self.loginBtn.hidden = NO;
            self.forgotPassBtn.hidden = NO;
            self.reEnterPasswordField.hidden = YES;
            self.resetButton.hidden = YES;
            self.cancelBtn.hidden = YES;
        }
        else {
            NSLog(@"password does not match");
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            self.reEnterPasswordField.hidden = NO;
            self.resetButton.hidden = NO;
            self.cancelBtn.hidden = NO;
            self.loginBtn.hidden = YES;
            self.forgotPassBtn.hidden = YES;
            [error show];
        }
    }
    else {
        UIAlertView *usernameError = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your username does not match our records." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [usernameError show];
    }
}

// Password Valid
-(BOOL)passValid:(NSString*)pass {
    if (![FormValidationUtility isValidPassword:pass]) {
        UIAlertView *PassError = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Sorry, that password does not meet our security guidelines. Please choose a password that is 6-16 characters in length, with a mix of at least 1 number or letter, and 1 symbol." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [PassError show];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    return NO;
}

@end
