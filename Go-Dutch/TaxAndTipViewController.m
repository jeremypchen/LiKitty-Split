//
//  TaxAndTipViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 5/6/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "TaxAndTipViewController.h"
#import "SplitModel.h"

@interface TaxAndTipViewController ()

// Tip
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;

// Tax
@property (weak, nonatomic) IBOutlet UISegmentedControl *taxSegmentedControl;
@property (weak, nonatomic) IBOutlet UITextField *taxCustomField;

// Label
@property (weak, nonatomic) IBOutlet UILabel *tipRateLabel;
@property (weak, nonatomic) IBOutlet UITextField *taxAmtField;
@property (weak, nonatomic) IBOutlet UITextField *tipAmtField;
@property (weak, nonatomic) IBOutlet UILabel *subtotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

// Model
@property (strong, nonatomic) SplitModel *splitModel;

@end

// Global variables to be used in completion handler when Done button is pushed
double newTaxRate;
double newTipRate;

@implementation TaxAndTipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Singleton model
    self.splitModel = [SplitModel sharedModel];
    
    // Set subtotal and total labels with proper format: $12.50
    self.subtotalLabel.text = [NSString stringWithFormat:@"%.02f", [self.splitModel getSubtotal]];
    self.totalLabel.text = [NSString stringWithFormat:@"%.02f", [self.splitModel getTotal]];
    
    // Set tip slider and tip rate label
    self.tipSlider.value = (int)([self.splitModel getTipR]*100);
    self.tipRateLabel.text = [NSString stringWithFormat:@"%.01f%%", ([self.splitModel getTipR]*100)];
    
//    self.tipRateLabel.frame = CGRectMake([self xPositionFromSliderValue: self.tipSlider], self.tipRateLabel.frame.origin.y, self.tipRateLabel.frame.size.width, self.tipRateLabel.frame.size.width);
    
    // Set global variables as current value in case Done is pushed and one or neither were updated
    newTipRate = [self.splitModel getTipR];
    newTaxRate = [self.splitModel getTaxR];
    
    // Set tax and tip amount label
    self.taxAmtField.text = [NSString stringWithFormat:@"%.02f",[self.splitModel getTaxAmount]];
    self.tipAmtField.text = [NSString stringWithFormat:@"%.02f",[self.splitModel getTipAmount]];
    
    if (newTaxRate == .08) {
        self.taxSegmentedControl.selectedSegmentIndex = 0;
    } else if (newTaxRate == .09) {
        self.taxSegmentedControl.selectedSegmentIndex = 1;
    } else if (newTaxRate == .1) {
        self.taxSegmentedControl.selectedSegmentIndex = 2;
    } else {
        self.taxSegmentedControl.selectedSegmentIndex = 3;
        self.taxCustomField.hidden = NO;
        self.taxCustomField.text = [NSString stringWithFormat:@"%.01f", newTaxRate*100];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)taxSegmentedControlChanged:(id)sender {
    // Set new tax rate in global variable. This will be used in completion handler.
    if (self.taxSegmentedControl.selectedSegmentIndex == 0) {
        newTaxRate = .08;
        self.taxCustomField.hidden = YES;
    } else if (self.taxSegmentedControl.selectedSegmentIndex == 1) {
        newTaxRate = .09;
        self.taxCustomField.hidden = YES;
    } else if (self.taxSegmentedControl.selectedSegmentIndex == 2) {
        newTaxRate = .1;
        self.taxCustomField.hidden = YES;
    } else if (self.taxSegmentedControl.selectedSegmentIndex == 3) {
        newTaxRate = [self.taxCustomField.text doubleValue]/100;
        self.taxCustomField.hidden = NO;
    }
    
    // Update tax amount label based on new tax rate
    self.taxAmtField.text = [NSString stringWithFormat:@"%.02f", newTaxRate*[self.splitModel getSubtotalWithoutTaxExempt]];
    
    // Update the total label
    [self reloadTotal];
}

- (IBAction)tipSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    // Using int because people rarely tip at a decimal percentage
    int numberAsInt = (int)(slider.value);

    // Update tip rate label
    self.tipRateLabel.text = [NSString stringWithFormat:@"%.01d%%", (numberAsInt)];
    
    // Set new tip rate in global variable. This will be used in completion handler.
    newTipRate = (double)numberAsInt/100;
    
    // Update tip amount label based on new tip rate
    self.tipAmtField.text = [NSString stringWithFormat:@"%.02f", newTipRate*[self.splitModel getSubtotal]];
    
//    CGRect trackRect = [slider trackRectForBounds:slider.bounds];
//    CGRect thumbRect = [slider thumbRectForBounds:slider.bounds
//                                             trackRect:trackRect
//                                                 value:slider.value];
//    
//    self.tipRateLabel.center = CGPointMake(thumbRect.origin.x + slider.frame.origin.x,  slider.frame.origin.y - 20);
//    
//    NSLog(@"%f", thumbRect.origin.x + slider.frame.origin.x);
//    
    // Update the total label
    [self reloadTotal];
}

- (IBAction)taxCustomFieldChanged:(id)sender {
    newTaxRate = [self.taxCustomField.text doubleValue]/100;
    
    // Update tax amount label based on new tax rate
    self.taxAmtField.text = [NSString stringWithFormat:@"%.02f", newTaxRate*[self.splitModel getSubtotalWithoutTaxExempt]];
    
    // Update the total label
    [self reloadTotal];
}

- (IBAction)taxAmtFieldChanged:(id)sender {
    newTaxRate = [self.taxAmtField.text doubleValue]/[self.splitModel getSubtotalWithoutTaxExempt];
    
    self.taxSegmentedControl.selectedSegmentIndex = 3;
    self.taxCustomField.hidden = FALSE;
    self.taxCustomField.text = [NSString stringWithFormat:@"%.01f", newTaxRate*100];
    
    [self reloadTotal];
}

- (IBAction)tipAmtFieldChanged:(id)sender {
    newTipRate = [self.tipAmtField.text doubleValue]/[self.splitModel getSubtotal];
    // adjust position of slider
    self.tipRateLabel.text = [NSString stringWithFormat:@"%.01f%%", (newTipRate*100)];
    [self.tipSlider setValue:newTipRate*100 animated:YES];
    
//    CGRect trackRect = [self.tipSlider trackRectForBounds:self.tipSlider.bounds];
//    CGRect thumbRect = [self.tipSlider thumbRectForBounds:self.tipSlider.bounds
//                                             trackRect:trackRect
//                                                 value:self.tipSlider.value];
//    
//    self.tipRateLabel.center = CGPointMake(thumbRect.origin.x + self.tipSlider.frame.origin.x,  self.tipSlider.frame.origin.y - 20);
//    
//    
    [self reloadTotal];
}

- (void)reloadTotal {
    // Update the total label at the bottom of the UI based on new tax and tip rates
    double subtotal = [self.splitModel getSubtotal];
    double newTotal = subtotal + (newTaxRate * subtotal) + (newTipRate * subtotal);
    self.totalLabel.text = [NSString stringWithFormat:@"%.02f", newTotal];
}

- (IBAction)saveButtonPressed:(id)sender {
    if (self.completionHandler){
        self.completionHandler(newTaxRate, newTipRate);
    }
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.backHandler){
        self.backHandler();
    }
}

- (IBAction)backgroundButtonPushed:(id)sender {
    [self.taxCustomField resignFirstResponder];
    [self.taxAmtField resignFirstResponder];
    [self.tipAmtField resignFirstResponder];
}

- (float) xPositionFromSliderValue:(UISlider *)aSlider;
{
    float sliderRange = aSlider.frame.size.width - aSlider.currentThumbImage.size.width;
    float sliderOrigin = aSlider.frame.origin.x + (aSlider.currentThumbImage.size.width / 2.0);
    
    float sliderValueToPixels = (((aSlider.value-aSlider.minimumValue)/(aSlider.maximumValue-aSlider.minimumValue)) * sliderRange) + sliderOrigin;
    
    return sliderValueToPixels;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


// Set tax slider and tax rate label
/*self.taxSlider.value = (int)([self.splitModel getTaxR]*100);
 self.taxRateLabel.text = [NSString stringWithFormat:@"%d%%", (int)([self.splitModel getTaxR]*100)];

 - (IBAction)taxSliderChanged:(id)sender {
 UISlider *slider = (UISlider *)sender;
 
 // Update tax rate label
 self.taxRateLabel.text = [NSString stringWithFormat:@"%.01f%%", slider.value];
 
 // Set new tax rate in global variable. This will be used in completion handler.
 newTaxRate = slider.value/100;
 
 // Update tax amount label based on new tax rate
 self.taxAmtLabel.text = [NSString stringWithFormat:@"$%.02f", newTaxRate*[self.splitModel getSubtotal]];
 
 // Update the total label
 [self reloadTotal];
 }*/

@end
