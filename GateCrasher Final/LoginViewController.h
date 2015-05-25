//
//  LoginViewController.h
//  FbLoginIntegrationSample
//
//  Created by Carlos Eduardo Arantes Ferreira on 2/19/14.
//  Copyright (c) 2014 Carlos Eduardo Arantes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;





@end
