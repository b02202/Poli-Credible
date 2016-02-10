//
//  SearchByNameViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByNameViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;

- (IBAction)searchBtn:(id)sender;

@end
