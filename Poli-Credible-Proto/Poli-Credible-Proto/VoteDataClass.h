//
//  VoteDataClass.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/8/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteDataClass : NSObject

@property (nonatomic, strong)NSString *billTitle;
@property (nonatomic, strong)NSString *billDesc;
@property (nonatomic, strong)NSString *billDate;
@property (nonatomic, strong)NSString *memberPos;
@property (nonatomic, strong)NSString *billID;
@property (nonatomic, strong)NSString *result;
@property (nonatomic, strong)NSString *totalYea;
@property (nonatomic, strong)NSString *totalNay;
@property (nonatomic, strong)NSString *demYea;
@property (nonatomic, strong)NSString *demNay;
@property (nonatomic, strong)NSString *demNoVote;
@property (nonatomic, strong)NSString *rYea;
@property (nonatomic, strong)NSString *rNay;
@property (nonatomic, strong)NSString *rNoVote;
@property (nonatomic, strong)NSString *iYea;
@property (nonatomic, strong)NSString *iNay;
@property (nonatomic, strong)NSString *iNoVote;
@property (nonatomic, strong)NSString *noVote;
@property (nonatomic, strong)NSString *nominationID;
@property (nonatomic, strong)NSString *question;
@property (nonatomic, strong)NSString *billPdfUrl;
@property (nonatomic, strong)NSString *voteDate;

@end
