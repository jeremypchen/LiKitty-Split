//
//  AddItemViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 6/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "AddItemViewController.h"
#import "AddPeopleViewController.h"
#import "SplitModel.h"

@interface AddItemViewController ()

// Item and price text fields
@property (weak, nonatomic) IBOutlet UITextField *itemNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *itemPriceTextField;
@property (weak, nonatomic) IBOutlet UISwitch *taxExemptSwitch;
@property (weak, nonatomic) IBOutlet UILabel *dollarSign;

// Nav bar buttons
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

// Model
@property (strong, nonatomic) SplitModel *splitModel;


@end

@implementation AddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitModel = [SplitModel sharedModel];
    self.itemNameTextField.delegate = self;
    self.itemPriceTextField.delegate = self;
    
    [self.itemNameTextField becomeFirstResponder];
}

- (IBAction)backgroundButtonPushed:(id)sender {
    // Escape keyboard for all existing textfields when background touched
    [self.itemNameTextField resignFirstResponder];
    [self.itemPriceTextField resignFirstResponder];
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.backHandler){
        self.backHandler();
    }
}

- (IBAction)priceTextfieldEdited:(id)sender {
    self.dollarSign.textColor = [UIColor orangeColor];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"ValidatedSuccess"]) {
        // perform your computation to determine whether segue should occur
        if ([[self.itemNameTextField text] isEqualToString: @""]) {
            UIAlertView *warningAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:@"Please provide the name of the item."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [warningAlert show];
            return NO;
            
            // Check if item price textfield is filled, otherwise throw warning alert
        } else if ([[self.itemPriceTextField text] isEqualToString: @""]) {
            UIAlertView *warningAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:@"Please provide the price of the item."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [warningAlert show];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    if(textfield==self.itemNameTextField){
        [self.itemPriceTextField becomeFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass: [AddPeopleViewController class]]) {
        AddPeopleViewController *addPeopleVC = segue.destinationViewController;
        addPeopleVC.itemName = self.itemNameTextField.text;
        addPeopleVC.itemPrice = [self.itemPriceTextField.text doubleValue];
        addPeopleVC.isTaxExempt = self.taxExemptSwitch.on;
        
        addPeopleVC.backHandler = ^() {
            // Do nothing when user goes back
            [self dismissViewControllerAnimated:YES completion:nil];
        };
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
