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

@implementation SettingsViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // set background color
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-2.png"]];
    
    _menuButton.target = self.revealViewController;
    _menuButton.action = @selector(revealToggle:);
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // textFields
    self.usernameField.delegate = self;
    self.usernameField.leftViewMode = UITextFieldViewModeAlways;
    self.usernameField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user-icon.png"]];
    
    self.passField.delegate = self;
    self.passField.leftViewMode = UITextFieldViewModeAlways;
    self.passField.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    
    self.reEnterPass.delegate = self;
    self.reEnterPass.leftViewMode = UITextFieldViewModeAlways;
    self.reEnterPass.leftView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password-icon.png"]];
    
    self.cancelBtn.hidden = YES;
    
    [self setPlaceholders];
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)updateAction:(id)sender {
    self.resetBtn.hidden = NO;
    self.reEnterPass.hidden = NO;
    self.updateBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.usernameField.enabled = YES;
    self.passField.enabled = YES;
    self.reEnterPass.enabled = YES;
}

- (IBAction)resetAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([self  fieldsAreValid:self.usernameField.text password:self.passField.text rePassword:self.reEnterPass.text]) {
        [defaults setObject:self.usernameField.text forKey:@"username"];
        [defaults setObject:self.passField.text forKey:@"password"];
        
        // set placeholder text
        [self setPlaceholders];
        
        // set visibility
        self.resetBtn.hidden = YES;
        self.reEnterPass.hidden = YES;
        self.updateBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.usernameField.enabled = NO;
        self.passField.enabled = NO;
        self.reEnterPass.enabled = NO;
        
        UIAlertView *resetAlert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Your profile has been updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [resetAlert show];
    }
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

-(void)setPlaceholders {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.usernameField.text = [defaults objectForKey:@"username"];
    self.passField.text = [defaults objectForKey:@"password"];
}

- (IBAction)cancelAction:(id)sender {
    self.resetBtn.hidden = YES;
    self.reEnterPass.hidden = YES;
    self.updateBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    self.usernameField.enabled = NO;
    self.passField.enabled = NO;
    self.reEnterPass.enabled = NO;
}



// Dismiss keyboard from text fields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.reEnterPass resignFirstResponder];
}
@end
