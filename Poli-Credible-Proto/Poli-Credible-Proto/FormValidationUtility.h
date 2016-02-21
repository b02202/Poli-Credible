//
//  FormValidationUtility.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormValidationUtility : NSObject

// Email - NSPredicate
+(BOOL)isValidEmailAddress:(NSString *)emailAddress ;

// Email - REGEX
+(BOOL)validateEmail:(NSString*) emailAddress ;

// Zip Code Validation
+(BOOL)zipVal:(NSString *)zip;

+(BOOL)isValidPassword:(NSString*)pass;

@end
