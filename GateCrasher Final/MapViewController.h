//
//  MapViewController.h
//  GateCrasher
//
//  Created by Ruan Lopes on 2015-02-11.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property NSData *jsonData;

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end
