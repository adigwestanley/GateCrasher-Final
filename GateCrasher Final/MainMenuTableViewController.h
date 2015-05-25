//
//  MainMenuTableViewController.h
//  GateCrasher Final
//
//  Created by Ruan Lopes on 2015-02-13.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuTableViewController : UITableViewController <UIViewControllerTransitioningDelegate >

@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSArray *backgroungCells;



@end
