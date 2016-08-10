//
//  SplitModel.h
//  LiKitty
//
//  Created by Jeremy Chen on 4/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface SplitModel : NSObject

+ (instancetype) sharedModel;

- (void) addItemWithName: (NSString*) itemName
               withPrice: (double) itemPrice
              withPeople: (NSMutableArray*) people
             isTaxExempt: (bool) isTaxExempt;

- (BOOL) checkIfItemExists: (NSString*) itemName;

- (NSMutableDictionary*) getItems;

- (void) deleteItemAtIndex: (NSUInteger) index;

- (NSInteger) count;

- (NSString*) getItemNameAtIndex: (NSUInteger) index;

- (NSNumber*) getItemPriceAtIndex: (NSUInteger) index;

- (double) getTaxAmount;

- (double) getTipAmount;

- (double) getTaxR;

- (void) setTaxR: (double) taxRate;

- (double) getTipR;

- (void) setTipR: (double) tipRate;

- (double) getSubtotal;

- (double) getSubtotalWithoutTaxExempt;

- (double) getTotal;

- (Person*) returnPersonIfExists: (NSString*) name;

- (void) addPerson: (Person*) person;

- (NSMutableArray*) getPeople;

- (void) resetEverything;

@end
