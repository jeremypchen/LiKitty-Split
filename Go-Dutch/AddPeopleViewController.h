//
//  AddPeopleViewController.m
//  LiKitty
//
//  Created by Jeremy Chen on 4/30/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddPeopleCompletionHandler) (NSString* itemName, double itemPrice, NSMutableArray *people);
typedef void(^AddPeopleBackHandler) ();

@interface AddPeopleViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) AddPeopleCompletionHandler completionHandler;
@property (copy, nonatomic) AddPeopleBackHandler backHandler;
@property (strong, nonatomic) NSString* itemName;
@property (nonatomic) double itemPrice;
@property (nonatomic) bool isTaxExempt;

@end
