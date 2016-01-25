//
//  ResultsViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 1/25/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()
@property (nonatomic, strong) NSMutableArray *memberArray;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.senateTableView.delegate = self;
    self.senateTableView.dataSource = self;
    
    for (int i = 0; i < _memberArray.count; i++) {
        NSString *memFirst = [[_memberArray objectAtIndex:i] valueForKey:@"repFirstName"];
        NSLog(@"%@", memFirst);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// set Array
-(void)setMemberArray:(NSMutableArray*)array {
    _memberArray = [[NSMutableArray alloc] initWithArray:array];
}

// TableView Number of Rows
// Specify number of rows displayed
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return self.addressArray.count;
   // return self.stateArray.count;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultsCell" forIndexPath:(NSIndexPath *)indexPath];
    //NSString *stateString = [[self.stateArray objectAtIndex:indexPath.row] objectForKey:@""];
    
   // cell.textLabel.text = [self.stateArray[indexPath.row]uppercaseString];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
