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

@property (strong, nonatomic) IBOutlet UIButton *resetButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPassBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;


@property (strong, nonatomic) IBOutlet UIButton *touchIDBtn;

// Button Actions

- (IBAction)loginUser:(id)sender;

- (IBAction)cancelAction:(id)sender;

- (IBAction)touchIDAction:(id)sender;


- (IBAction)forgotPassword:(id)sender;
- (IBAction)resetBtn:(id)sender;

@end

