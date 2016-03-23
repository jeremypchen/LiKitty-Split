//
//  Person.h
//  LiKitty
//
//  Created by Jeremy Chen on 4/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

- (instancetype) initWithName: (NSString*) name;

- (void) addFood: (NSString*) foodName
       withPrice: (double) price
withContribution: (double) weight;

- (void) changeName: (NSString*) name;

- (NSString*) getName;

- (double) getTotalContribution;

- (double) getTaxContribution;

- (double) getTipContribution;

- (NSMutableDictionary*) getFood;

- (void) deleteItem: (NSString*) itemName;

@end
