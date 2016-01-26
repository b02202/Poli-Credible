//
//  ZipCodeViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/26/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZipCodeViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;

- (IBAction)searchBtn:(id)sender;

@end
