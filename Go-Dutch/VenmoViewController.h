//
//  VenmoViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 5/7/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

typedef void(^VenmoBackHandler) ();

@interface VenmoViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (copy, nonatomic) VenmoBackHandler backHandler;

@end
