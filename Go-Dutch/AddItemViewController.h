//
//  AddItemViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 6/25/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AddItemCompletionHandler) (NSString *itemName, double itemPrice);
typedef void(^AddItemBackHandler) ();

@interface AddItemViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) AddItemCompletionHandler completionHandler;
@property (copy, nonatomic) AddItemBackHandler backHandler;


@end
