//
//  VenmoViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 5/7/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "VenmoViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import "SplitModel.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface VenmoViewController ()

// Scroll view containing each row of person, charge, phone number textfield, address book, and checkmark
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

// Dictionaries holding data of each row
@property (strong, nonatomic) NSMutableArray* peopleDictionaries;

// Array of textfields, used to resign first responder
@property (strong, nonatomic) NSMutableArray* textfields;

// Model
@property (strong, nonatomic) SplitModel *splitModel;

@end

// Global holding current index so when we return from address book, we know which textfield to fill
int currentIndex;

@implementation VenmoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.splitModel = [SplitModel sharedModel];
    
    // Set transaction method as through Venmo's API and not its app
    [[Venmo sharedInstance] setDefaultTransactionMethod:VENTransactionMethodAPI];

    self.textfields = [[NSMutableArray alloc]init];
    self.peopleDictionaries = [[NSMutableArray alloc]init];
    [self loadUI];
    
    // Single tap gesture to escape keyboard when user clicks on scrollview
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundButtonPushed:(id)sender {
    // Escape keyboard for each keyboard when background touched
    for (UITextField* textfield in self.textfields) {
        [textfield resignFirstResponder];
    }
}

// Method to hide keyboard when user taps on a scrollview
- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

- (IBAction)backButtonPushed:(id)sender {
    if (self.backHandler) {
        self.backHandler();
    }
}

- (void)loadUI {
    int rowHeight = 8;
    int index = 0;
    
    // Set up each row in scrollview
    for (id person in [self.splitModel getPeople]) {
        // First, the name of the person
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(8, rowHeight, 78, 24)];
        name.textColor = [UIColor blackColor];
        name.text = [person getName];
        [name setFont:[UIFont boldSystemFontOfSize:20]];
        
        // Second, how much this person owes
        UILabel *charge = [[UILabel alloc]initWithFrame:CGRectMake(127, rowHeight, 66, 22)];
        charge.textColor = [UIColor blackColor];
        charge.font = [UIFont boldSystemFontOfSize:18];
        charge.textAlignment = NSTextAlignmentRight;
        charge.text = [NSString stringWithFormat:@"$%.02f", [person getTotalContribution]];

        // Third, a textfield for their phone number that Venmo can use
        UIButton *phone = [[UIButton alloc] initWithFrame:CGRectMake(205, rowHeight-5, 111, 30)];
        [phone setTitle: @"Add Number" forState:UIControlStateNormal];
        phone.titleLabel.font = [UIFont systemFontOfSize:14];
        phone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [phone setTitleColor: self.view.tintColor forState:UIControlStateNormal];
        
        [phone setTag: index];
        
        [phone addTarget:self
                  action:@selector(openPhoneBook:)
               forControlEvents:UIControlEventTouchUpInside];
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(8, rowHeight+30, 20, 20);
        
        UILabel *statusMsg = [[UILabel alloc]initWithFrame:CGRectMake(8, rowHeight+30, 300, 24)];
        [statusMsg setFont:[UIFont boldSystemFontOfSize:14]];
        
        statusMsg.hidden = TRUE;
        
        // Update height so next row doesn't intersect
        rowHeight += 72;
        
        [self.scrollview addSubview:name];
        [self.scrollview addSubview:charge];
        [self.scrollview addSubview:phone];
        [self.scrollview addSubview:spinner];
        [self.scrollview addSubview:statusMsg];
        
        // Store the row data in dictionary, then put in array that we can access by currentIndex
        NSMutableDictionary* pDict = [[NSMutableDictionary alloc]init];
        [pDict setObject: [person getName] forKey: @"Name"];
        [pDict setObject: [NSNumber numberWithDouble:[person getTotalContribution]] forKey: @"Charge"];
        [pDict setObject: phone forKey: @"PhoneButton"];
        [pDict setObject: name forKey:@"NameLabel"];
        [pDict setObject: charge forKey:@"ChargeLabel"];
        [pDict setObject: spinner forKey:@"Spinner"];
        [pDict setObject: statusMsg forKey:@"StatusMessage"];
        [pDict setObject: @NO forKey:@"RequestSent"];
        
        [self.peopleDictionaries addObject: pDict];
        
        index++;
    }
}

// When Request by Venmo button is pushed
- (IBAction)payButtonPushed:(id)sender {

    for (id pDict in self.peopleDictionaries) {
        
        // If phone number in textfield is not empty
        if (![[[pDict objectForKey:@"PhoneButton"] currentTitle] isEqualToString:@"Add Number"]
            && [[pDict objectForKey:@"RequestSent"] isEqual:@NO])
             {
            UIActivityIndicatorView* spinner = [pDict objectForKey:@"Spinner"];

            UILabel* statusMsg = [pDict objectForKey:@"StatusMessage"];
            statusMsg.text = @"";
            statusMsg.hidden = FALSE;
            
            [spinner startAnimating];
            
            // Get phone number from textfield and charge amount
            UIButton* phoneBtn = [pDict objectForKey:@"PhoneButton"];
            NSString* phoneNumber = phoneBtn.titleLabel.text;
            double chargeAmt = [[pDict objectForKey:@"Charge"] doubleValue];
            NSString* chargeNote = @"Sent via LiKitty Split";
            
            NSLog(@"Attempting to charge %f for %@", chargeAmt*100, [pDict objectForKey:@"Name"]);
            
            // Charge
            [[Venmo sharedInstance] sendRequestTo: phoneNumber
                                           amount: chargeAmt*100
                                             note: chargeNote
                                completionHandler:^(VENTransaction *transaction, BOOL success, NSError *error) {
                                    [spinner stopAnimating];
                                    if (success) {
                                        NSLog(@"Transaction succeeded!");
                                        
                                        [[pDict objectForKey:@"NameLabel"] setColor: UIColorFromRGB(0x11a522)];
                                       [[pDict objectForKey:@"ChargeLabel"] setColor: UIColorFromRGB(0x11a522)];
                                        
                                        statusMsg.text = @"Request Sent";
                                        statusMsg.textColor = UIColorFromRGB(0x11a522);
                                        [pDict setObject:@YES forKey: @"RequestSent"];
                                    }
                                    else {
                
                                        [[pDict objectForKey:@"NameLabel"] setColor: [UIColor redColor]];
                                        [[pDict objectForKey:@"ChargeLabel"] setColor: [UIColor redColor]];
                                        
                                        UILabel* statusMsg = [pDict objectForKey:@"StatusMessage"];
                                        
                                        statusMsg.text = [error localizedDescription]; //@"Request Failed";
                                        statusMsg.textColor = [UIColor redColor];
                                        
                                    }

                                }
             ];
        }
        
    }
}

- (void) goToAddressBook:(id)sender {
    UIButton* clicked = (UIButton*)sender;
    
    // Set global currentIndex with row index of person selected so we can update the proper phone textfield
    currentIndex = (int)clicked.tag;
    
    ABPeoplePickerNavigationController *peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerController.peoplePickerDelegate = self;
    // In address book, we only want to see phone numbers
    peoplePickerController.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];

    [self presentViewController:peoplePickerController animated:YES completion:nil];
}

- (BOOL)personViewController:(ABPersonViewController *)personViewController
shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property
                  identifier:(ABMultiValueIdentifier)identifier {
    // Don't perform the default action of clicking on properties (sending SMS, calling, etc)
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    // Ensure user picked a phone property
    if (property == kABPersonPhoneProperty) {
        ABMultiValueRef phone = ABRecordCopyValue(person, property);
        // Store phone number
        CFStringRef phoneNumber = ABMultiValueCopyValueAtIndex(phone, identifier);
        
        // Access correct person based on global currentindex, set phone textfield with phone number
        NSDictionary* pDict = [self.peopleDictionaries objectAtIndex:currentIndex];
        UIButton* phoneButton = [pDict objectForKey:@"PhoneButton"];
        [phoneButton setTitle: (__bridge NSString*)phoneNumber forState:UIControlStateNormal];
        
    [self dismissViewControllerAnimated:YES completion:nil];    }
}

- (void) openPhoneBook: (UIButton*) sender {
    currentIndex = (int)sender.tag;
    
    ABPeoplePickerNavigationController *peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
    peoplePickerController.peoplePickerDelegate = self;
    // In address book, we only want to see phone numbers
    peoplePickerController.displayedProperties = [NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]];
    
    [self presentViewController:peoplePickerController animated:YES completion:nil];
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
