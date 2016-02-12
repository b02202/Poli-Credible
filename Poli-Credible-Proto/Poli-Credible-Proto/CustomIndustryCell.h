//
//  CustomIndustryCell.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/11/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomIndustryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *moneyProgress;

@end
