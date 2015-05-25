//
//  ListTableViewController.m
//  GateCrasher
//
//  Created by Ruan Lopes on 2015-02-10.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import "ListTableViewController.h"
#import "DetailsViewController.h"



@interface ListTableViewController ()

@property (nonatomic, strong) NSArray *listEvents;
@property (nonatomic, strong) NSArray *thumbnails2;



@end

@implementation ListTableViewController {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.finishedGooglePlacesArray = [[NSArray alloc] init];
    
    //self.listEvents =[NSArray arrayWithObjects:@"featured",@"events",@"nearBy", nil];
    
    // Initialize thumbnails
    self.thumbnails2 = [NSArray arrayWithObjects:@"featured.png", @"list.png", @"nearBy.png", nil];
    
    [self makeRestuarantRequests];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)makeRestuarantRequests {
    
    NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=cafe+in+toronto&sensor=false&key=AIzaSyALPtr6lZ6G91EPevjfvpJSF1Ul2n9lLo"];
    
   // AIzaSyDdRW16cd37nCnmDpIDrjZJ3ZV85Iccd54
    //AIzaSyALPt-r6lZ6G91EPevjfvpJSF1Ul2n9lLo
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //AFNetworking asynchronous url request
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];  // to store in a array on afnetwork 2.0
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.googlePlacesArrayFromAFNetworking = [responseObject objectForKey:@"results"];
        
        NSLog(@"The Array: %@",self.googlePlacesArrayFromAFNetworking);
        
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
    
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.googlePlacesArrayFromAFNetworking count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellList" forIndexPath:indexPath];
    NSDictionary *tempDictionary= [self.googlePlacesArrayFromAFNetworking objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [tempDictionary objectForKey:@"name"];
    
    if([tempDictionary objectForKey:@"rating"] != NULL)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Rating: %@ of 5",[tempDictionary   objectForKey:@"rating"]];
    }
    else
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Not Rated"];
    }
    
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

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DetailsViewController *details = (DetailsViewController *) segue.destinationViewController;
    details.eventDetail = [self.googlePlacesArrayFromAFNetworking objectAtIndex: indexPath.row];

}


@end
