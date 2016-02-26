//
//  VoteDetailController.h
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/14/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *voteDetailTable;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UINavigationItem *navTitle;
@property (strong, nonatomic) IBOutlet UIButton *viewBillBtn;

// Recieved
// VC
@property (nonatomic, strong) NSString *recievedQuestion;
@property (nonatomic, strong) NSString *recievedResult;
@property (nonatomic, strong) NSString *recievedDate;
@property (nonatomic, strong) NSString *recievedNavTitle;
// Vote Detail Cell
@property (nonatomic, strong) NSString *recievedTotalYea;
@property (nonatomic, strong) NSString *recievedTotalNay;
@property (nonatomic, strong) NSString *recievedTotalNoVote;
// Party Cell
@property (nonatomic, strong) NSString *recievedDemYea;
@property (nonatomic, strong) NSString *recievedDemNay;
@property (nonatomic, strong) NSString *recievedDemNo;
@property (nonatomic, strong) NSString *recievedRYea;
@property (nonatomic, strong) NSString *recievedRNay;
@property (nonatomic, strong) NSString *recievedRNo;
@property (nonatomic, strong) NSString *recievedIYea;
@property (nonatomic, strong) NSString *recievedINay;
@property (nonatomic, strong) NSString *recievedINo;
@property (nonatomic, strong) NSString *recievedPdf;
@property (nonatomic, assign) BOOL isBill;

// Actions
- (IBAction)viewBill:(id)sender;
- (IBAction)backDismiss:(id)sender;

@end
