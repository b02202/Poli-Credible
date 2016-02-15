//
//  ViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    // set background color
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // NSUser Defaults Implementation
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"registered"]) {
        NSLog(@"No user registered");
        _loginBtn.hidden = YES;
    }
    else {
        NSLog(@"user is registered");
        _reEnterPasswordField.hidden = YES;
        _registerBtn.hidden = YES;
    }
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.reEnterPasswordField.delegate = self;
    
    // Register for Keyboard Notifications
    //[self registerForKeyboardNotifications];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.reEnterPasswordField resignFirstResponder];
}

// Register Button Implementation
- (IBAction)registerUser:(id)sender {
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must enter all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else
    {
        [self checkPasswordMatch];
        
    }
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

- (IBAction)registerTextAction:(id)sender {
    self.resetButton.hidden = YES;
    self.loginBtn.hidden = YES;
    self.reEnterPasswordField.hidden = NO;
    self.registerBtn.hidden = NO;
    self.loginTextBtn.hidden = NO;
}

- (IBAction)loginTextButton:(id)sender {
    self.registerBtn.hidden = YES;
    self.reEnterPasswordField.hidden = YES;
    self.loginBtn.hidden = NO;
    self.loginTextBtn.hidden = YES;
}

- (IBAction)forgotPassword:(id)sender {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.reEnterPasswordField.hidden = NO;
    self.resetButton.hidden = NO;
    self.registerBtn.hidden = YES;
    //self.registerBtn.enabled = NO;
    self.loginBtn.hidden = YES;
    
    //if ([_usernameField.text isEqualToString:[defaults objectForKey:@"username"]]) {
      //  statements
    //}
    
    //[_usernameField.text isEqualToString:[defaults objectForKey:@"username"]]
}

- (IBAction)resetBtn:(id)sender {
    [self resetPassword];
    
    
}

-(void)resetPassword {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([_usernameField.text isEqualToString:[defaults objectForKey:@"username"]]) {
        if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
            [defaults setObject:_passwordField.text forKey:@"password"];
            self.resetButton.hidden = YES;
            self.loginBtn.hidden = NO;
            self.reEnterPasswordField.hidden = YES;
        }
        else {
            NSLog(@"password don't match");
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            self.loginBtn.hidden = YES;
            self.reEnterPasswordField.hidden = NO;
            [error show];
        }
    }
}

// Check Password Match
-(void) checkPasswordMatch
{
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
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

// Register New User
- (void) registerNewUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_usernameField.text forKey:@"username"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new Poli-Credible user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}



// Register Button Show/Hide
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_reEnterPasswordField resignFirstResponder];
    return NO;
}

@end
