//
//  SplitModel.m
//  LiKitty
//
//  Created by Jeremy Chen on 4/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "SplitModel.h"
#import "Person.h"

@interface SplitModel ()
// private properties
@property (strong, nonatomic) NSMutableArray *people;
@property (strong, nonatomic) NSMutableDictionary *items;

//@property (strong, nonatomic) Item *currentItem;
@property (nonatomic) double taxRate;
@property (nonatomic) double tipRate;

@end

@implementation SplitModel

// Singleton model
+ (instancetype) sharedModel {
    static SplitModel *_sharedModel = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    
    return _sharedModel;
}

// Initialize, with default tax rate of 9% and tip rate of 15%
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.items = [[NSMutableDictionary alloc] init];
        self.people = [[NSMutableArray alloc]init];

        self.taxRate = .08;
        self.tipRate = .15;
    }
    
    return self;
}

// Add item to model with its price and the people involved
- (void) addItemWithName: (NSString*) itemName
               withPrice: (double) itemPrice
              withPeople: (NSMutableArray*) people
             isTaxExempt: (bool) isTaxExempt
{
    
    NSMutableDictionary* itemDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSNumber numberWithDouble:itemPrice], @"Price",
                                    @(isTaxExempt), @"TaxExempt",
                                     people, @"People",
                                     nil];
    
    // Add item to items dictionary with its name as key
    [self.items setObject: itemDict forKey: itemName];
}

- (BOOL) checkIfItemExists: (NSString*) itemName {
    if ([self.items objectForKey: itemName]) {
        return TRUE;
    }
    return FALSE;
}

- (NSMutableDictionary*) getItems {
    return self.items;
}

// Delete item based on index in dictionary
- (void) deleteItemAtIndex: (NSUInteger) index {
    NSArray *keys = [self.items allKeys];
    [self.items removeObjectForKey: [keys objectAtIndex: index]];
}

// Get item based on index in dictionary
- (NSString*) getItemNameAtIndex: (NSUInteger) index {
    NSArray *keys = [self.items allKeys];
    return[keys objectAtIndex: index];
}

// Get item's price at index of dictionary
- (NSNumber*) getItemPriceAtIndex: (NSUInteger) index {
    NSArray *keys = [self.items allKeys];
    id keyAtIndex = [keys objectAtIndex: index];
    NSMutableDictionary* itemDict = [self.items objectForKey: keyAtIndex];
    
    return [itemDict objectForKey: @"Price"];
}

// Return number of items in model
- (NSInteger) count {
    return [self.items count];
}

// Add person to the model
- (void) addPerson: (Person*) person {
    [self.people addObject:person];
}

// Return person via name if he/she exists in model. Otherwise return nothing
- (Person*) returnPersonIfExists: (NSString*) name {
    for (id person in self.people) {
        if ([[person getName] isEqualToString: name]) {
            return person;
        }
    }
    return nil;
}

- (NSMutableArray*) getPeople {
    return self.people;
}

// Get subtotal of items (doesn't include tax and tip)
- (double) getSubtotal {
    double subtotal = 0;
    
    // Iterate through each item, totaling its price
    for(id key in self.items) {
        NSMutableDictionary* itemDict = [self.items objectForKey:key];
        subtotal += [[itemDict objectForKey: @"Price"] doubleValue];
    }
    
    return subtotal;
}

- (double) getSubtotalWithoutTaxExempt {
    double subtotal = 0;
    
    // Iterate through each item, totaling its price
    for(id key in self.items) {
        NSMutableDictionary* itemDict = [self.items objectForKey:key];
        if ([[itemDict objectForKey:@"TaxExempt"] isEqualToNumber:[NSNumber numberWithBool:NO]]) {
            subtotal += [[itemDict objectForKey: @"Price"] doubleValue];
        }
    }
    
    return subtotal;
}

- (double) getTaxAmount {
    return self.taxRate * [self getSubtotalWithoutTaxExempt];
}

- (double) getTipAmount {
    return self.tipRate * [self getSubtotal];
}

- (double) getTaxR {
    return self.taxRate;
}

- (double) getTipR {
    return self.tipRate;
}

- (void) setTaxR: (double) taxRate {
    self.taxRate = taxRate;
}

- (void) setTipR: (double) tipRate {
    self.tipRate = tipRate;
}

// Add subtotal with tax and tip
- (double) getTotal {
    return [self getSubtotal] + self.getTaxAmount + self.getTipAmount;
}

// Clear everything, and reset tax and tip rate to default
- (void) resetEverything {
    [self.items removeAllObjects];
    [self.people removeAllObjects];

    self.taxRate = .09;
    self.tipRate = .15;
}

@end
