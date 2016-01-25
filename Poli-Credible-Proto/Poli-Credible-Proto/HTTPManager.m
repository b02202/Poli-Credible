//
//  HTTPManager.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/25/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "HTTPManager.h"

@interface HTTPManager() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURLConnection *requestConnection;
@end



@implementation HTTPManager

-(NSMutableData*)receivedData
{
    if (!_receivedData) {
        _receivedData = [[NSMutableData alloc] init];
    }
    return _receivedData;
}

-(NSURLConnection*)requestConnection
{
    if (!_requestConnection) {
        _requestConnection = [[NSURLConnection alloc] init];
    }
    return _requestConnection;
}

-(void)httpRequest:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            [self.delegate getReceivedData:data sender:self];
            self.delegate = nil;
        }
        else {
            // Handle Errors
            NSLog(@"%@", error.description);
        }
    }] resume];
    
    //self.requestConnection = [NSURLConnection connectionWithRequest:request delegate:self];

    
    
}


// Delagate Methods
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append Data
    [self.receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Get Data Notify calling class
    [self.delegate getReceivedData:self.receivedData sender:self];
    // Set to nil when done
    self.delegate = nil;
    self.requestConnection = nil;
    self.receivedData = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // Handle Errors
    NSLog(@"%@", error.description);
}

@end
