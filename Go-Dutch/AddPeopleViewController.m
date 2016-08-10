//
//  AddPeopleViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 4/30/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "AddPeopleViewController.h"
#import "SplitModel.h"
#import "Person.h"

@interface AddPeopleViewController ()

// Scroll view holding people fields
@property (weak, nonatomic) IBOutlet UIScrollView *peopleScrollView;

// Arrays holding people and weight textfields
@property (strong, nonatomic) NSMutableArray *peopleTextFields;
@property (strong, nonatomic) NSMutableArray *weightsTextFields;

// Array holding people
@property (strong, nonatomic) NSMutableArray *people;

// Model
@property (strong, nonatomic) SplitModel *splitModel;
@end

int peopleLabel_YPOS = 70;
bool weightsHaveBeenEdited = NO;

@implementation AddPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.splitModel = [SplitModel sharedModel];

    // Have to reset to 70 when viewDidLoad because global doesn't start at 70 when you return to this view
    peopleLabel_YPOS = 70;
    weightsHaveBeenEdited = NO;
    
    // Add initial person and weight textfields
    UITextField *firstPerson = [[UITextField alloc] initWithFrame:CGRectMake(8, 32, 220, 30)];
    firstPerson.borderStyle = UITextBorderStyleRoundedRect;
    firstPerson.placeholder = @"Name";
    firstPerson.returnKeyType = UIReturnKeyGo;
    firstPerson.tag = 3;
    firstPerson.delegate = self;
    
    UITextField *firstWeight = [[UITextField alloc] initWithFrame:CGRectMake(265, 32, 50, 30)];
    firstWeight.borderStyle = UITextBorderStyleRoundedRect;
    firstWeight.text = @"100";
    firstWeight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    firstWeight.keyboardType = UIKeyboardTypeNumberPad;
    [firstWeight addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
    
    [self.peopleScrollView addSubview:firstPerson];
    [self.peopleScrollView addSubview:firstWeight];

    // Initialize the people and weight textfields arrays with these initial textfields
    self.peopleTextFields = [[NSMutableArray alloc]initWithObjects:firstPerson, nil];
    self.weightsTextFields = [[NSMutableArray alloc]initWithObjects:firstWeight, nil];
    
    // Single tap used to escape keyboard when user clicks on scrollview
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
    
    // Do any additional setup after loading the view.
}

- (void)textFieldDidChange {
    weightsHaveBeenEdited = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundButtonPushed:(id)sender {
    // Escape keyboard for all existing textfields when background touched
    for (UITextField* peopleTextField in self.peopleTextFields) {
        [peopleTextField resignFirstResponder];
    }
    for (UITextField* weightTextField in self.weightsTextFields) {
        [weightTextField resignFirstResponder];
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    // Escape keyboard when scrollview is touched
    [self.view endEditing:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    if (self.backHandler){
        self.backHandler();
    }
}

- (IBAction)addPersonButtonPressed:(id)sender {
    // Add two textfields to scroll view at proper height
    UITextField *newPerson = [[UITextField alloc] initWithFrame:CGRectMake(8, peopleLabel_YPOS, 220, 30)];
    newPerson.borderStyle = UITextBorderStyleRoundedRect;
    newPerson.placeholder = @"Name";
    newPerson.returnKeyType = UIReturnKeyGo;
    newPerson.delegate = self;
    newPerson.tag = 3;

    UITextField *newWeight = [[UITextField alloc] initWithFrame:CGRectMake(265, peopleLabel_YPOS, 50, 30)];
    newWeight.borderStyle = UITextBorderStyleRoundedRect;
    newWeight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    newWeight.keyboardType = UIKeyboardTypeDecimalPad;
    [newWeight addTarget:self
                  action:@selector(textFieldDidChange)
        forControlEvents:UIControlEventEditingChanged];
        
    // Increment so next couple won't intersect
    peopleLabel_YPOS += 38;
    
    [newPerson setTag: peopleLabel_YPOS];
    
    // Add to textfield arrays and to the scrollview
    [self.peopleTextFields addObject: newPerson];
    [self.weightsTextFields addObject: newWeight];
    [self.peopleScrollView addSubview:newPerson];
    [self.peopleScrollView addSubview:newWeight];
    
    if (weightsHaveBeenEdited) {
        int totalSoFar = 0;
        for (UITextField* weightTextField in self.weightsTextFields) {
            totalSoFar += [weightTextField.text intValue];
        }
        if (100 - totalSoFar > 0) {
            newWeight.text = [NSString stringWithFormat:@"%d", 100 - totalSoFar];
        } else {
            newWeight.text = @"0";
        }
        
    } else {
        
        int recalculatedWeight = floor(100/self.weightsTextFields.count);
        int remainder = 100%self.weightsTextFields.count;
        
        for (UITextField* weightTextField in self.weightsTextFields) {
            if (remainder > 0) {
                weightTextField.text = [NSString stringWithFormat:@"%d", recalculatedWeight+1];
                remainder--;
            } else {
                weightTextField.text = [NSString stringWithFormat:@"%d", recalculatedWeight];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    if(textfield.tag == 3){
        // perform segue
        if ([self shouldPerformSegueWithIdentifier:@"PeopleValidated" sender:textfield]) {
            [self performSegueWithIdentifier: @"PeopleValidated" sender: self];
        }
    }
    return YES;
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // Boolean to determine if at least one person and weight was filled in correctly
    // We cannot run the completion handler unless this is the case
    bool atLeastOneNameSuccessful = FALSE;
    
    NSMutableArray* people = [[NSMutableArray alloc]init];
    
    // Check if weights add up to 100
    double totalWeight = 0;
    for (int i = 0; i < [self.weightsTextFields count]; i++){
        totalWeight += [[self.weightsTextFields[i] text] doubleValue];
    }
    if (totalWeight != 100) {
        // Error message if it doesn't add up to 100
        UIAlertView *warningAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Error"
                                     message:@"Weights don't add up to 100."
                                     delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [warningAlert show];
        return NO;
    } else {
        // For each textfield with name filled
        for (int i = 0; i < [self.peopleTextFields count]; i++)
        {
            if (![[self.peopleTextFields[i] text] isEqualToString: @""] &&
                ![[self.weightsTextFields[i] text] isEqualToString: @""]){
                
                // We have at least one filled people/weight textfield
                atLeastOneNameSuccessful = TRUE;
                
                // Get data from textfields
                NSString* name = [self.peopleTextFields[i] text];
                double weight = [[self.weightsTextFields[i] text] doubleValue]/100;
                
                Person* person = [self.splitModel returnPersonIfExists:name];
                
                // If person doesn't exist, we create a new one and add it to the model
                if (person == nil){
                    Person* newPerson = [[Person alloc]initWithName: name];
                    [newPerson addFood: self.itemName
                             withPrice: self.itemPrice
                      withContribution: weight];
                    
                    // add to array
                    [people addObject:newPerson];
                    [self.splitModel addPerson: newPerson];
                    
                } else {
                    // If person already exists, we don't need to add it to the model
                    NSLog(@"Person named %@ already exists. Adding with weight %f", name, weight);
                    [people addObject:person];
                    
                    // add food and weight
                    [person addFood: self.itemName
                          withPrice: self.itemPrice
                   withContribution: weight];
                }
            } else if ([[self.peopleTextFields[i] text] isEqualToString: @""] &&
                          ![[self.weightsTextFields[i] text] isEqualToString: @""]) {
                UIAlertView *warningAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Error"
                                             message:@"A corresponding name field is empty."
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                [warningAlert show];
                return NO;
            } else if (![[self.peopleTextFields[i] text] isEqualToString: @""] &&
                          [[self.weightsTextFields[i] text] isEqualToString: @""]) {
                UIAlertView *warningAlert = [[UIAlertView alloc]
                                             initWithTitle:@"Error"
                                             message:@"A corresponding weight field is empty."
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
                [warningAlert show];
                return NO;
            }
        }
        if (atLeastOneNameSuccessful) {
            if (![self.splitModel checkIfItemExists: self.itemName]) {
                // Add new entry to model
                [self.splitModel addItemWithName: self.itemName
                                       withPrice: self.itemPrice
                                      withPeople: people
                                     isTaxExempt: self.isTaxExempt];
            }
            return YES;
        } else {
            // Throw warning alert
            UIAlertView *warningAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error"
                                         message:@"You need to include at least one person's name and his/her corresponding weight."
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            [warningAlert show];
            return NO;
        }
    }
    return YES;

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
