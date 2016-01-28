//
//  DetailViewController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/27/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet UIView *contributionView;
@property (strong, nonatomic) IBOutlet UIView *memberDataContainer;

@property (strong, nonatomic) IBOutlet UIView *contributionsViewContainer;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmantValueChanged:(id)sender;
- (IBAction)launchShare:(id)sender;

@end
