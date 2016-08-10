//
//  Person.m
//  LiKitty
//
//  Created by Jeremy Chen on 4/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import "Person.h"
#import "SplitModel.h"

@interface Person ()

// Name of person
@property (strong, nonatomic) NSString* name;

// Dictionary of food that person has eaten
@property (strong, nonatomic) NSMutableDictionary* food;

// Model, which person needs access to in order to calculate proper tax+tip contribution
@property (strong, nonatomic) SplitModel *splitModel;

@end

@implementation Person

// Initialize with name only
- (instancetype) initWithName: (NSString*) name {
    self.name = name;
    self.food = [[NSMutableDictionary alloc]init];
    
    self.splitModel = [SplitModel sharedModel];

    return self;
}

// Method to add an item to this person
- (void) addFood: (NSString*) foodName
       withPrice: (double) price
withContribution: (double) weight {
    // Dictionary holding price and weight of person
    NSMutableDictionary* itemDict = [[NSMutableDictionary alloc]init];
    [itemDict setObject: [NSNumber numberWithDouble:price] forKey: @"Price"];
    [itemDict setObject: [NSNumber numberWithDouble:weight] forKey: @"Weight"];

    // Put this dictionary in food dictionary, with key as the item's name
    [self.food setObject: itemDict forKey: foodName];
}

- (double) getTotalContribution {
    double totalContribution = [self getSubtotal];
    
//    // For each item in food dictionary, add up each price multiplied by the weight
//    NSArray *keys = [self.food allKeys];
//    for (id key in keys){
//        NSMutableDictionary* itemDict = [self.food objectForKey:key];
//        
//        totalContribution += ([[itemDict objectForKey:@"Price"] doubleValue] * [[itemDict objectForKey:@"Weight"]doubleValue]);
//    }
    
    // Also get the tax and tip contribution and add it to the total contribution
    totalContribution += [self getTaxAndTipContribution:totalContribution];
    
    return totalContribution;
}

- (double) getSubtotal {
    double subtotal = 0;
    
    // For each item in food dictionary, add up each price multiplied by the weight
    NSArray *keys = [self.food allKeys];
    
    for (id key in keys){
        NSMutableDictionary* itemDict = [self.food objectForKey:key];
        
        subtotal += ([[itemDict objectForKey:@"Price"] doubleValue] * [[itemDict objectForKey:@"Weight"]doubleValue]);
    }
    
    return subtotal;
}

- (double) getWeight {
    return [self getSubtotal]/[self.splitModel getSubtotal];
}

- (double) getTaxAndTipContribution: (double) subtotal {
    // Get the total amount of tax and tip from the model
    double totalTaxAndTip = [self.splitModel getTaxAmount] + [self.splitModel getTipAmount];
    
//    // Divide subtotalContribution by totalContribution to get the person's weight for paying tax and tip
//    double totalWeight = subtotal/[self.splitModel getSubtotal];

    // Multiply this weight with total tax and total tip to get the tax+tip contribution
    return [self getWeight]*totalTaxAndTip;
}

- (double) getTaxContribution {
    return [self getWeight] * [self.splitModel getTaxAmount];
}

- (double) getTipContribution {
    return [self getWeight] * [self.splitModel getTipAmount];
}

- (NSMutableDictionary*) getFood {
    return self.food;
}

- (void) changeName: (NSString*) name {
    self.name = name;
}

- (NSString*) getName {
    return self.name;
}

- (void) deleteItem: (NSString*) itemName {
    // If person's food dictionary has this item, delete it
    if ([self.food objectForKey: itemName]) {
        [self.food removeObjectForKey: itemName];
    }
}


@end
