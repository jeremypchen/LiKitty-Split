//
//  FinalSplitViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 5/6/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinalSplitCompletionHandler) ();
typedef void(^FinalSplitBackHandler) ();

@interface FinalSplitViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *finalContributionsTableView;
@property (copy, nonatomic) FinalSplitCompletionHandler completionHandler;
@property (copy, nonatomic) FinalSplitBackHandler backHandler;


@end
