//
//  MainMenuTableViewController.m
//  GateCrasher Final
//
//  Created by Ruan Lopes on 2015-02-13.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "LoginViewController.h"
#import "MapViewController.h"


// Animation
#import "PresentingAnimationController.h"
#import "DismissingAnimationController.h"

@interface MainMenuTableViewController ()

@end

@implementation MainMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.menu =[NSArray arrayWithObjects:@"featured",@"events",@"nearBy", nil];
    self.backgroungCells = [NSArray arrayWithObjects:@"featured.png", @"list.png", @"nearBy.png", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Login Button ------------------------------------------------------------------------------------

- (IBAction)didClickOnPresent:(id)sender {
    
    LoginViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginModal"];
    
    modalVC.transitioningDelegate = self;
    
    modalVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self.navigationController presentViewController:modalVC animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitionDelegate -------------------------------------------------------

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[PresentingAnimationController alloc] init];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[DismissingAnimationController alloc] init];
}


#pragma mark - Table view data source -------------------------------------------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.menu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu" forIndexPath:indexPath];
    
// Create Background obj    
    UIImageView *imgBack = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    imgBack.backgroundColor = [UIColor clearColor];
    imgBack.opaque = NO;
    imgBack.image = [UIImage imageNamed:[self.backgroungCells objectAtIndex:indexPath.row]];
// Set Background img
    cell.backgroundView = imgBack;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"nearBy"]) {
        
        NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=bars+in+toronto&sensor=false&key=AIzaSyDdRW16cd37nCnmDpIDrjZJ3ZV85Iccd54"];
        NSURL *url = [NSURL URLWithString:urlString];
        
        // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
        NSData *jsonData = [NSData dataWithContentsOfURL:url];
        
        
        MapViewController *lc = [segue destinationViewController];
        lc.jsonData =  jsonData;
        
        NSLog(@"%@", jsonData);
        
    }
}

@end
