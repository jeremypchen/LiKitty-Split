//
//  TaxAndTipViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 5/6/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TaxAndTipCompletionHandler) (double newTaxRate, double newTipRate);
typedef void(^TaxAndTipBackHandler) ();

@interface TaxAndTipViewController : UIViewController <UITextFieldDelegate>

@property (copy, nonatomic) TaxAndTipCompletionHandler completionHandler;
@property (copy, nonatomic) TaxAndTipBackHandler backHandler;

@end
