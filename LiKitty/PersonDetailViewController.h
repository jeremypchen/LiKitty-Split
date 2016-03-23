//
//  PersonDetailViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 6/26/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PersonDetailBackHandler) ();

@interface PersonDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *itemDetailTableView;
@property (copy, nonatomic) PersonDetailBackHandler backHandler;

@property (strong, nonatomic) NSString *personName;

@end
