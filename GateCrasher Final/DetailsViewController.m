//
//  DetailsViewController.m
//  GateCrasher
//
//  Created by Ruan Lopes on 2015-02-12.
//  Copyright (c) 2015 Ruan Lopes. All rights reserved.
//

#import "DetailsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *restuarantNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restuarantImageView;
@property (weak, nonatomic) IBOutlet UILabel *restuarantAddressLabel;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
- (IBAction)share:(id)sender;
- (IBAction)pickFriendsClick:(id)sender;




@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.eventDetail);
    
    self.restuarantNameLabel.text = [self.eventDetail objectForKey:@"name"];
    [self.restuarantImageView setImageWithURL:[NSURL URLWithString:[self.eventDetail objectForKey:@"icon"]]];
    self.restuarantAddressLabel.text = [self.eventDetail objectForKey:@"formatted_address"];
    
        
        
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

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void)performPublishAction:(void(^)(void))action {
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                    
                                                } else if (error.fberrorCategory != FBErrorCategoryUserCancelled) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission denied"
                                                                                                        message:@"Unable to get permission to post"
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"OK"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }
                                            }];
    } else {
        action();
    }
    
}


- (IBAction)share:(id)sender {
    // Post a status update to the user's feed via the Graph API, and display an alert view
    // with the results or an error.
    
    NSURL *urlToShare = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
    
    // This code demonstrates 3 different ways of sharing using the Facebook SDK.
    // The first method tries to share via the Facebook app. This allows sharing without
    // the user having to authorize your app, and is available as long as the user has the
    // correct Facebook app installed. This publish will result in a fast-app-switch to the
    // Facebook app.
    // The second method tries to share via Facebook's iOS6 integration, which also
    // allows sharing without the user having to authorize your app, and is available as
    // long as the user has linked their Facebook account with iOS6. This publish will
    // result in a popup iOS6 dialog.
    // The third method tries to share via a Graph API request. This does require the user
    // to authorize your app. They must also grant your app publish permissions. This
    // allows the app to publish without any user interaction.
    
    // If it is available, we will first try to post using the share dialog in the Facebook app
    FBLinkShareParams *params = [[FBLinkShareParams alloc] initWithLink:urlToShare
                                                                   name:@"Hello Facebook"
                                                                caption:nil
                                                            description:@"The 'Hello Facebook' sample application showcases simple Facebook integration."
                                                                picture:nil];
    
    BOOL isSuccessful = NO;
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        FBAppCall *appCall = [FBDialogs presentShareDialogWithParams:params
                                                         clientState:nil
                                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                                 if (error) {
                                                                     NSLog(@"Error: %@", error.description);
                                                                 } else {
                                                                     NSLog(@"Success!");
                                                                 }
                                                             }];
        isSuccessful = (appCall  != nil);
    }
    if (!isSuccessful && [FBDialogs canPresentOSIntegratedShareDialogWithSession:[FBSession activeSession]]){
        // Next try to post using Facebook's iOS6 integration
        isSuccessful = [FBDialogs presentOSIntegratedShareDialogModallyFrom:self
                                                                initialText:nil
                                                                      image:nil
                                                                        url:urlToShare
                                                                    handler:nil];
    }
    if (!isSuccessful) {
        [self performPublishAction:^{
            NSString *message = [NSString stringWithFormat:@"Updating status for %@ at %@", self.loggedInUser.first_name, [NSDate date]];
            
            FBRequestConnection *connection = [[FBRequestConnection alloc] init];
            
            connection.errorBehavior = FBRequestConnectionErrorBehaviorReconnectSession
            | FBRequestConnectionErrorBehaviorAlertUser
            | FBRequestConnectionErrorBehaviorRetry;
            
            [connection addRequest:[FBRequest requestForPostStatusUpdate:message]
                 completionHandler:^(FBRequestConnection *innerConnection, id result, NSError *error) {
                     [self showAlert:message result:result error:error];
                     //self.share.enabled = YES;
                 }];
            [connection start];
            
           // self.share.enabled = NO;
        }];
    }
    
}



// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        // Since we use FBRequestConnectionErrorBehaviorAlertUser,
        // we do not need to surface our own alert view if there is an
        // an fberrorUserMessage unless the session is closed.
        if (error.fberrorUserMessage && FBSession.activeSession.isOpen) {
            alertTitle = nil;
            
        } else {
            // Otherwise, use a general "connection problem" message.
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    if (alertTitle) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                            message:alertMsg
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}



- (IBAction)pickFriendsClick:(id)sender {
    
    FBFriendPickerViewController *friendPickerController = [[FBFriendPickerViewController alloc] init];
    friendPickerController.title = @"Pick Friends";
    [friendPickerController loadData];
    
    // Use the modal wrapper method to display the picker.
    [friendPickerController presentModallyFromViewController:self animated:YES handler:
     ^(FBViewController *innerSender, BOOL donePressed) {
         if (!donePressed) {
             return;
         }
         
         NSString *message;
         
         if (friendPickerController.selection.count == 0) {
             message = @"<No Friends Selected>";
         } else {
             
             NSMutableString *text = [[NSMutableString alloc] init];
             
             // we pick up the users from the selection, and create a string that we use to update the text view
             // at the bottom of the display; note that self.selection is a property inherited from our base class
             for (id<FBGraphUser> user in friendPickerController.selection) {
                 if ([text length]) {
                     [text appendString:@", "];
                 }
                 [text appendString:user.name];
             }
             message = text;
         }
         
         [[[UIAlertView alloc] initWithTitle:@"You Picked:"
                                     message:message
                                    delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil]
          show];
     }];

}

@end
