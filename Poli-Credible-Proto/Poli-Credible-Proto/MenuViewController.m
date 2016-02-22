//
//  MenuViewController.m
//  Poli-Credible-Proto
//
//  Created by Robert Brooks on 2/9/16.
//  Copyright © 2016 Robert Brooks. All rights reserved.
//

#import "MenuViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"

@implementation MenuViewController {
    NSArray *menuItems;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[@"first", @"second", @"third", @"fourth"];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    self.menuTableView.estimatedRowHeight = 60.0f;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    
}

// Table
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell layoutIfNeeded];
    
    return cell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]]) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*)segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            UINavigationController *navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers:@[dvc] animated:NO];
            [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        };
    }
}
- (IBAction)logoutBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *viewController = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"loginScreen"];
    
    [self presentViewController:viewController animated:YES completion:nil];
}
@end
