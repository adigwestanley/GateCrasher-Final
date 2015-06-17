//
//  LoginViewController.m
//  GateCrasher Final
//
//  Created by Ruan Lopes on 2015-02-13.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController () {

}

@end

@implementation LoginViewController


-(void)toggleHiddenState:(BOOL)shouldHide{
    self.lblUsername.hidden = shouldHide;
    self.lblEmail.hidden = shouldHide;
    self.profilePicture.hidden = shouldHide;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self toggleHiddenState:YES];
 
    self.lblLoginStatus.text = @"";
    self.loginButton.readPermissions = @[@"public_profile", @"email",@"user_friends"];
    self.loginButton.delegate = self;
    
    // Round corner
    self.view.layer.cornerRadius = 8.f; // round pop up

    
    //Background
    UIImageView *background =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,275,390)];
    background.image=[UIImage imageNamed:@"login.png"];
    [self.view addSubview:background];

 
    // Create Facebook Button
    FBLoginView *loginView = [[FBLoginView alloc] init];
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x / 6), 250);
    [self.view addSubview:loginView];
    
    
    //Button Cancel
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(didClickOnCancel:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-regular" size:20.0]];
    button.frame = CGRectMake(85.0, 352.0, 100.0, 20.0);
    [self.view addSubview:button];
    
}

- (IBAction)didClickOnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged in.";
    
    [self toggleHiddenState:NO];
    
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    self.lblLoginStatus.text = @"You are logged out";
    
    [self toggleHiddenState:YES];
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}



// END FACEBOODK


@end
