//
//  HTTPManager.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/25/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

// Define delegate protocal and delegate
@class HTTPManager;
@protocol HTTPManagerDelegate
-(void)getReceivedData:(NSData*)data sender:(HTTPManager*)sender;
@end

@interface HTTPManager : NSObject
// Public Method
-(void)httpRequest:(NSURL*)url;

@property  (nonatomic, weak) id <HTTPManagerDelegate> delegate;

@end
// Set Constant Variables
#define POST @"POST"
#define GET @"GET"

