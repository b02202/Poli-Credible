//
//  RegisterViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/20/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Firebase/Firebase.h>


@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPass;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;

// Actions
- (IBAction)backAction:(id)sender;
- (IBAction)registerAction:(id)sender;
@end
