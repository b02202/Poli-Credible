//
//  ViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;

// Active Field
@property (strong, nonatomic) IBOutlet UITextField *activeField;

// Login Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *registerTextBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginTextBtn;

// Button Actions
- (IBAction)registerUser:(id)sender;
- (IBAction)loginUser:(id)sender;
- (IBAction)registerTextAction:(id)sender;
- (IBAction)loginTextButton:(id)sender;


- (IBAction)forgotPassword:(id)sender;
- (IBAction)resetBtn:(id)sender;

@end

