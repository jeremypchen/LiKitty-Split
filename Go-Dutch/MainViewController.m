//
//  MainViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 4/23/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "MainViewController.h"
#import "AddPeopleViewController.h"
#import "AddItemViewController.h"
#import "TaxAndTipViewController.h"
#import "FinalSplitViewController.h"
#import "SplitModel.h"

@interface MainViewController ()
// Buttons
@property (weak, nonatomic) IBOutlet UIButton *taxtipButton;
@property (weak, nonatomic) IBOutlet UIButton *splitButton;

// Labels
@property (weak, nonatomic) IBOutlet UILabel *taxLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipRateLabel;

// Tutorial Labels and Images

// Model
@property (strong, nonatomic) SplitModel *splitModel;
@end

@implementation MainViewController

@synthesize itemsTableView;
//bool inTutorialMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self setUpTutorial];
//    [self displayFirstTutorialOverlay];
    
//    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
//        inTutorialMode = TRUE;
//        [self setUpTutorial];
//        [self displayFirstTutorialOverlay];
//    } else {
//        NSLog(@"Already seen tutorial");
//        inTutorialMode = FALSE;
//    }
    
    // Singleton model
    self.splitModel = [SplitModel sharedModel];
  
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setUpTutorial {
    UILabel *firstTutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 350, 24)];
    firstTutorialLabel.text = @"Click here to add an item";
    
    UILabel *secondTutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 350, 24)];
    secondTutorialLabel.text = @"Click here to adjust tax and tip";
    
    UILabel *thirdTutorialLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, 350, 24)];
    thirdTutorialLabel.text = @"Click here when finished";
}

- (void) displayFirstTutorialOverlay {
//    NSLog(@"Viewing first tutorial now");
//    [[self.thirdTutorialOverlay superview] bringSubviewToFront: self.firstTutorialOverlay];
//    [[self.secondTutorialOverlay superview] bringSubviewToFront: self.firstTutorialOverlay];
//    [[self.firstTutorialOverlay superview] bringSubviewToFront: self.firstTutorialOverlay];
//
//    [self firstTutorialOverlay].hidden = FALSE;
}

- (IBAction)displaySecondTutorialOverlay:(id)sender {
//    NSLog(@"Viewing second tutorial now");
//    [self firstTutorialOverlay].hidden = TRUE;
//    [self secondTutorialOverlay].hidden = FALSE;

}

- (IBAction)displayThirdTutorialOverlay:(id)sender {
//    NSLog(@"Viewing third tutorial now");
//    [self secondTutorialOverlay].hidden = TRUE;
//    [self thirdTutorialOverlay].hidden = FALSE;
}

- (IBAction)endTutorialOverlay:(id)sender {
//    NSLog(@"Tutorial ended");
//    [self thirdTutorialOverlay].hidden = TRUE;
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass: [AddItemViewController class]]) {
         AddItemViewController *addItemVC = segue.destinationViewController;
        addItemVC.backHandler = ^() {
            // Do nothing when user goes back
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    } else if ([segue.destinationViewController isKindOfClass: [TaxAndTipViewController class]]) {
        TaxAndTipViewController *taxAndTipVC = segue.destinationViewController;
        taxAndTipVC.completionHandler = ^(double newTaxRate, double newTipRate) {
            // Set tax and tip rates in model and in UI
            [self.splitModel setTaxR: newTaxRate];
            [self.splitModel setTipR: newTipRate];
            [self reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        taxAndTipVC.backHandler = ^() {
            // Do nothing when user goes back
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
    } else if ([segue.destinationViewController isKindOfClass:[FinalSplitViewController class]]) {
        FinalSplitViewController *finalSplitVC = segue.destinationViewController;
        finalSplitVC.completionHandler = ^() {
            // User is done with current session, so reset everything
            [self.splitModel resetEverything];
            [self reloadData];
            [self.itemsTableView reloadData];
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        finalSplitVC.backHandler = ^() {
            // Do nothing when user goes back
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
}

- (void)reloadData {
    // Set updated tax and tip amounts in proper format: $12.50
    self.taxLabel.text = [NSString stringWithFormat:@"$%.02f", [self.splitModel getTaxAmount]];
    self.tipLabel.text = [NSString stringWithFormat:@"$%.02f", [self.splitModel getTipAmount]];
    
    // Set updated tax and tip rates in proper format: 8.0% and 15.0%
    self.taxRateLabel.text = [NSString stringWithFormat:@"%.01f%%", [self.splitModel getTaxR]*100];
    self.tipRateLabel.text = [NSString stringWithFormat:@"%.01f%%", [self.splitModel getTipR]*100];
    
    // Set updated total label in proper format: $12.50
    self.totalLabel.text = [NSString stringWithFormat:@"$%.02f", [self.splitModel getTotal]];
}

#pragma mark UITableViewDelegate

// Allows user to delete an item from the table by swiping left
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

// Number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.splitModel count];
}

// Populating tableview with data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        // Cellstyle value1 has a right detail text
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifer];
    }

    // Set main label as the name of the item
    cell.textLabel.text = [self.splitModel getItemNameAtIndex:[indexPath row]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Noteworthy" size:20.0]];

    // Set detail label as price of the item
    NSString *priceString = [NSString stringWithFormat: @"$%.02f", [[self.splitModel getItemPriceAtIndex: [indexPath row]] doubleValue]];
    cell.detailTextLabel.text = priceString;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // When an item is deleted, we have to go through each person in the model and delete that item from them
        for (Person* person in [self.splitModel getPeople]){
            [person deleteItem: [self.splitModel getItemNameAtIndex:indexPath.row]];
        }
        
        // Delete item from model and table
        [self.splitModel deleteItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self reloadData];
    }
    
}


@end
