//
//  AWNAppDelegate.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/18/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNAppDelegate.h"
#import <ContextHub/ContextHub.h>

#import "AWNConstants.h"

@implementation AWNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Register with ContextHub
#ifdef DEBUG
    // The debug flag is automatically set by the compiler, indicating which push gateway server your device will use
    // Xcode deployed builds use the sandbox/development server
    // TestFlight/App Store builds use the production server
    // ContextHub records which environment a device is using so push works properly
    // This must be called BEFORE [ContextHub registerWithAppId:]
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
    
    //Register the app id of the application you created on https://app.contexthub.com
    [ContextHub registerWithAppId:@"YOUR-AWARENESS-APP-ID-HERE"];
    
    // Register for remote notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound ];
    
    return YES;
}

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Set up the alias, tags, and register for push notifications on the server
    NSString *alias = [[UIDevice currentDevice] name];
    NSArray *tags = @[AWNDeviceTag];
    
    [[CCHPush sharedInstance] registerDeviceToken:deviceToken alias:alias tags:tags completionHandler:^(NSError *error) {
        
        if (!error) {
            // Build tag string
            __block NSString *tagString = tags[0];
            [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                // Skip over the first time
                if (idx != 0) {
                    tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@", %@", obj]];
                }
            }];
            
            NSLog(@"Successfully registered device with alias %@ and tags %@", [[UIDevice currentDevice] name], tagString);
        }
        else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Did fail to register %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Define our fetch completion handler which is called by ContextHub if the push wasn't a push for ContextHub
    void (^fetchCompletionHandler)(UIBackgroundFetchResult) = ^(UIBackgroundFetchResult result){
        // Log pushes we get
        NSLog(@"Push received: %@", userInfo);
        
        BOOL background = ([userInfo valueForKeyPath:@"aps.content-available"] != nil) ? YES : NO;
        
        // Pop an alert about our message only if our app is in the foreground
        if (application.applicationState == UIApplicationStateActive) {
            if (!background) {
                // Foreground has a message
                NSString *message = [userInfo valueForKeyPath:@"aps.alert"];
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            } else {
                // Background has payload data
                NSDictionary *customPayload = [userInfo valueForKey:@"payload"];
                NSString *customPayloadString = [NSString stringWithFormat:@"Custom payload: %@", customPayload];
                [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:customPayloadString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            }
        }
        
        // Call the completionhandler with a result based on whether your push had new data or not
        completionHandler(UIBackgroundFetchResultNewData);
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}

@end