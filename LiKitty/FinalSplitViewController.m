//
//  FinalSplitViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 5/6/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "FinalSplitViewController.h"
#import "SplitModel.h"
#import "VenmoViewController.h"
#import "PersonDetailViewController.h"
#import "Venmo.h"

@interface FinalSplitViewController ()

// Label for total
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

// Model
@property (strong, nonatomic) SplitModel *splitModel;

@end

NSString* clickedPersonName;
bool shouldSegue = NO;

@implementation FinalSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitModel = [SplitModel sharedModel];
    
    // Set total label
    self.totalLabel.text = [NSString stringWithFormat:@"Total: $%.02f", [self.splitModel getTotal]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPushed:(id)sender {
    if (self.backHandler) {
        self.backHandler();
    }
}

- (IBAction)doneButtonPushed:(id)sender {
    if (self.completionHandler) {
        self.completionHandler();
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[VenmoViewController class]]) {
        VenmoViewController *venmoVC = segue.destinationViewController;
        
        venmoVC.backHandler = ^() {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    } else if ([[segue identifier] isEqualToString:@"ClickedPersonSegue"]) {
        PersonDetailViewController *personDetailVC = segue.destinationViewController;
        
        personDetailVC.personName = clickedPersonName;
        
        personDetailVC.backHandler = ^() {
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}

- (bool) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString: @"VenmoSegue"]) {
        if (![[Venmo sharedInstance] isSessionValid] ||
            ![[NSUserDefaults standardUserDefaults] boolForKey:@"hasVenmoPermissions"]) {
            
            // If user doesn't have Venmo
            if (![Venmo isVenmoAppInstalled]) {
                
                [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments, VENPermissionAccessProfile]
                                     withCompletionHandler:^(BOOL success, NSError *error) {
                                         if (success) {
                                             NSLog(@"Permission granted");
                                             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasVenmoPermissions"];
                                         } else {
                                             NSLog(@"Permission denied");
                                             
                                             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasVenmoPermissions"];
                                         }
                                     }];
                
            } else {
                
                UIAlertController * alert =   [UIAlertController
                                              alertControllerWithTitle:@"Hold up!"
                                              message:@"When requesting that LiKitty access your Venmo account for the first time, it may freeze if you use a passcode to unlock your Venmo app. To avoid this, please ensure Venmo is running in the background, then come back here and click Venmo again. We hope Venmo will fix this issue in the near future!"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* venmoRunning = [UIAlertAction
                                     actionWithTitle:@"We're good, Venmo is running!"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                         // Request permissions when we hit this VC
                                         [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments, VENPermissionAccessProfile]
                                                  withCompletionHandler:^(BOOL success, NSError *error) {
                                                      if (success) {
                                                          NSLog(@"Permission granted");
                                                          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasVenmoPermissions"];
                                                      } else {
                                                          NSLog(@"Permission denied");
                                                          
                                                          [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasVenmoPermissions"];
                                                      }
                                                  }];
                                         
                                     }];
                
                UIAlertAction* venmoNotRunning = [UIAlertAction
                                     actionWithTitle:@"OK, open Venmo for me."
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"venmo://"]];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                UIAlertAction* venmoCancel = [UIAlertAction
                                                  actionWithTitle:@"Never mind."
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action)
                                                  {
                                                      [alert dismissViewControllerAnimated:YES completion:nil];
                                                  }];
                
                [alert addAction:venmoRunning];
                [alert addAction:venmoNotRunning];
                [alert addAction:venmoCancel];
                [self presentViewController:alert animated:YES completion: nil];
     
                return NO;
            }
        } else {
            return YES;
        }
            
    }
    return YES;
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get name based on indexPath
    NSMutableArray *people = [self.splitModel getPeople];
    NSInteger index = [indexPath row];
    
    clickedPersonName = [people[index] getName];
    
    [self performSegueWithIdentifier:@"ClickedPersonSegue" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Number of rows in table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.splitModel getPeople] count];
}

// Populating data in tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
    }
    
    // Get all people in model
    NSMutableArray* people = [self.splitModel getPeople];
    
    NSUInteger index = [indexPath row];
    
    // Set main text label as person's name
    cell.textLabel.text = [people[index] getName];
    [cell.textLabel setFont:[UIFont fontWithName:@"Noteworthy" size:20.0]];
    
    // Set detail text as person's total contribution to the bill
    double totalContribution = [people[index] getTotalContribution];
    NSString *totalContributionString;
    if (totalContribution != totalContribution){
        totalContributionString = @"0.00";
    } else {
        totalContributionString = [NSString stringWithFormat:@"%.02f", totalContribution];
    }
    NSString *dollar = @"$";
    NSString *detailText = [dollar stringByAppendingString: totalContributionString];
    cell.detailTextLabel.text = detailText;
    
    return cell;
}


@end
