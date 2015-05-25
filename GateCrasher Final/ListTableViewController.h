//
//  ListTableViewController.h
//  GateCrasher
//
//  Created by Ruan Lopes on 2015-02-10.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@interface ListTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *googlePlacesArrayFromAFNetworking;
@property (strong, nonatomic) NSArray *finishedGooglePlacesArray;

@end
