//
//  ViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;

// Login Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

// Button Actions
- (IBAction)registerUser:(id)sender;
- (IBAction)loginUser:(id)sender;


@end

