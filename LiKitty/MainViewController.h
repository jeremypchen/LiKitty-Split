//
//  MainViewController.h
//  LiKitty
//
//  Created by Jeremy Chen on 4/23/15.
//  Copyright (c) 2015 Jeremy Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;

@end
