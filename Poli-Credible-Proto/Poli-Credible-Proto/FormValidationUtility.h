//
//  FormValidationUtility.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormValidationUtility : NSObject

// Email Validation
+(BOOL)isValidEmailAddress:(NSString *)emailAddress ;

// Zip Code Validation
+(BOOL)zipVal:(NSString *)zip;

// Password Validation
+(BOOL)isValidPassword:(NSString*)pass;

@end
