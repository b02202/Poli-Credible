//
//  FormValidationUtility.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/21/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "FormValidationUtility.h"

@implementation FormValidationUtility

// Using NSPredicate

+(BOOL)isValidEmailAddress:(NSString *)emailAddress {
    //regex string
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" ;
    //predicate
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:
                              @"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:emailAddress];
}
// Password Check
+(BOOL)isValidPassword:(NSString*)pass {
    // Min 6 characters, Max 16 characters, At least 1 alphanumeric, and 1 non-alphanumeric
    NSString *regex = @"^(?=.{6,16}$)(?=.*?[A-Za-z0-9])(?=.*?[\\W_])[\\w\\W]+";
    NSPredicate *passPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([passPredicate evaluateWithObject:pass]) {
        return YES;
    } else {
        return NO;
    }
}
// U.S. Zip Code Check
+(BOOL)zipVal:(NSString *)zip {
    NSString *regex = @"^\\d{5}(-\\d{4})?$";
    NSPredicate *zipPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([zipPredicate evaluateWithObject:zip]) {
        return true;
    } else {
        return false;
    }
}

@end
