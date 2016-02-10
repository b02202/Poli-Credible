//
//  SearchByZipViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchByZipViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;


@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

- (IBAction)searchBtn:(id)sender;


@end
