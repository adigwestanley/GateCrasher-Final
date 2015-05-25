//
//  MapViewController.m
//  GateCrasher
//
//  Created by Ruan Lopes on 2015-02-11.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController {
    
    CLLocationManager *locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    _latitudeValue = @"43.7000";
    //    _longitudeValue = @"-79.4000";
    self.map.delegate = self;
    
    //add these in first
    locationManager = [[CLLocationManager alloc] init];
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion]         floatValue] >= 8.0)
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelectorOnMainThread:@selector(respondToJSON:) withObject:self.jsonData waitUntilDone:YES];
    });
    
    }

-(void) respondToJSON: (NSData *) jsonData
{
    
    
    NSError * error;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSMutableArray *main = [responseJSON objectForKey:@"listings"];
    
    for(int i = 0; i < main.count - 2; i++){
        
        NSString *eventname = [[main objectAtIndex:i] objectForKey:@"name"];
        
        NSDictionary *address = [[main objectAtIndex:i] objectForKey:@"address"];
        NSString *streetAddress = [address objectForKey:@"street"];
        
        
        //geolocation
        NSDictionary *geo = [[main objectAtIndex:i] objectForKey:@"geoCode"];
        double latitudeValue = [[geo objectForKey:@"latitude"] doubleValue];
        double longitudeValue = [[geo objectForKey:@"longitude"] doubleValue];
        
        
        MKCoordinateRegion FindBusinessRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(latitudeValue, longitudeValue), 10000, 10000);
        [self.map setRegion:FindBusinessRegion animated:YES];
        
        MKPointAnnotation *myAnnotation =[[MKPointAnnotation alloc]init];
        myAnnotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue);
        myAnnotation.title = eventname;
        myAnnotation.subtitle = streetAddress;
        NSLog(@"hello");
        [self.map addAnnotation:myAnnotation];
        
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
