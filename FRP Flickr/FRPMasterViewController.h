//
//  FRPMasterViewController.h
//  FRP Flickr
//
//  Created by Don Huff on 7/30/14.
//  Copyright (c) 2014 15 by 10, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRPDetailViewController;


@interface FRPMasterViewController : UITableViewController

@property (strong, nonatomic) FRPDetailViewController *detailViewController;

@end
