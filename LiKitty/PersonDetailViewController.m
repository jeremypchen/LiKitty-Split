//
//  PersonDetailViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 6/26/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "SplitModel.h"
#import "Person.h"

@interface PersonDetailViewController ()

@property (weak, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@property (weak, nonatomic) IBOutlet UILabel *taxAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;

// Model
@property (strong, nonatomic) SplitModel *splitModel;

@end

Person* currentPerson;

@implementation PersonDetailViewController

@synthesize itemDetailTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitModel = [SplitModel sharedModel];
    
    self.navBarTitle.title = self.personName;
    
    currentPerson = [self.splitModel returnPersonIfExists:self.personName];
    
    self.taxAmountLabel.text = [NSString stringWithFormat: @"$%.02f", [currentPerson getTaxContribution]];
    
    self.tipAmountLabel.text = [NSString stringWithFormat: @"$%.02f", [currentPerson getTipContribution]];
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"$%.02f", [currentPerson getTotalContribution]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPushed:(id)sender {
    if (self.backHandler){
        self.backHandler();
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark UITableViewDelegate

- (void)        tableView:(UITableView *)tableView
  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger)section {
    return [[currentPerson getFood] count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DetailCellIdentifier = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        NSArray *cellObjects = [[NSBundle mainBundle] loadNibNamed:@"DetailCell" owner:self options:nil];
        cell = (UITableViewCell*) [cellObjects objectAtIndex:0];
    }
    
    NSMutableDictionary* items = [currentPerson getFood];
    
    NSUInteger index = [indexPath row];
   
    NSArray *keys = [items allKeys];
    
    UILabel *label;
    
    label = (UILabel *)[cell viewWithTag:1];
    label.text = [keys objectAtIndex:index];
    [label setFont:[UIFont fontWithName:@"Noteworthy" size:20.0]];
    
    id keyAtIndex = [keys objectAtIndex: index];
    NSMutableDictionary* itemDict = [items objectForKey: keyAtIndex];
    
    NSNumber *itemPrice = [itemDict objectForKey: @"Price"];
    NSNumber *itemWeight = [itemDict objectForKey: @"Weight"];
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat: @"%d%%", (int)([itemWeight doubleValue]*100)];
    
    double finalPrice = [itemPrice doubleValue] * [itemWeight doubleValue];
    
    NSString *detailText = [NSString stringWithFormat: @"$%.02f", finalPrice];
    label = (UILabel *)[cell viewWithTag:3];
    label.text = detailText;
    
    
    return cell;
}





@end
