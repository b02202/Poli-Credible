//
//  SettingsViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *updatePassBtn;
@property (assign, nonatomic) BOOL emailIsUpdating;
@property (assign, nonatomic) BOOL updateSuccess;
@property (strong, nonatomic) IBOutlet UIButton *updateBtn;

- (IBAction)updateAction:(id)sender;
- (IBAction)resetAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)changePassAction:(id)sender;



@end
