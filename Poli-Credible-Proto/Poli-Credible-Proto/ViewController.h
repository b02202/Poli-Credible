//
//  ViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

// Text Fields
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

// Buttons
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgotPassBtn;
@property (strong, nonatomic) IBOutlet UIButton *touchIDBtn;

// Button Actions
- (IBAction)loginUser:(id)sender;
- (IBAction)touchIDAction:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end

