//
//  CustomFundraisingCell.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/12/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomFundraisingCell : UITableViewCell

// Labels
@property (strong, nonatomic) IBOutlet UILabel *raisedLabel;
@property (strong, nonatomic) IBOutlet UILabel *spentLabel;
@property (strong, nonatomic) IBOutlet UILabel *cashLabel;
@property (strong, nonatomic) IBOutlet UILabel *debtsLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastReportedLabel;

// Progress Bars
@property (strong, nonatomic) IBOutlet UIProgressView *raisedBar;
@property (strong, nonatomic) IBOutlet UIProgressView *spentBar;
@property (strong, nonatomic) IBOutlet UIProgressView *cashBar;
@property (strong, nonatomic) IBOutlet UIProgressView *debtsBar;





@end
