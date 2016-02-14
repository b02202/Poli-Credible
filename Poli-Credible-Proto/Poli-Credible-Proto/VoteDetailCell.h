//
//  VoteDetailCell.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/14/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIProgressView *yeaProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *nayProgress;
@property (strong, nonatomic) IBOutlet UIProgressView *noVoteProgress;
@property (strong, nonatomic) IBOutlet UILabel *yeaVotes;
@property (strong, nonatomic) IBOutlet UILabel *nayVotes;
@property (strong, nonatomic) IBOutlet UILabel *notVoting;
@property (strong, nonatomic) IBOutlet UILabel *yeaLabel;
@property (strong, nonatomic) IBOutlet UILabel *nayLabel;
@property (strong, nonatomic) IBOutlet UILabel *noVoteLabel;
@property (strong, nonatomic) IBOutlet UILabel *noILabel;

@end
