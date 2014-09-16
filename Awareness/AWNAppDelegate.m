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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#ifdef DEBUG
    // The debug flag is automatically set by the compiler, indicating which push gateway server your device will use
    // Xcode deployed builds use the sandbox/development server
    // TestFlight/App Store builds use the production server
    // ContextHub records which environment a device is using so push works properly
    // This must be called BEFORE [ContextHub registerWithAppId:]
    [[ContextHub sharedInstance] setDebug:TRUE];
#endif
    
    // Register the app id of the application you created on https://app.contexthub.com
    [ContextHub registerWithAppId:@"YOUR-AWARENESS-APP-ID-HERE"];
    
    // Register for remote notifications
    if ([UIUserNotificationSettings class]) {
        // iOS 8 and above
        UIUserNotificationType notificationTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 7 and below
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
    
    // Setup ContextHub subscriptions
    [self setupSubscriptions];
    
    return YES;
}

#pragma mark - Events

- (void)beaconCreateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Beacon: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A beacon '%@' was created", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)beaconUpdateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Beacon: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A beacon '%@' was updated", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)beaconDeleteEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Beacon: %@", object);
    
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"A beacon was deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

#pragma mark -

- (void)geofenceCreateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Geofence: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A geofence '%@' was created", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)geofenceUpdateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Geofence: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A geofence '%@' was updated", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)geofenceDeleteEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Geofence: %@", object);
    
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"A geofence was deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

#pragma mark -

- (void)vaultCreateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Vault item: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A vault item '%@' was created", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)vaultUpdateEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Vault item: %@", object);
    
    NSString *message = [NSString stringWithFormat:@"A vault item '%@' was updated", object[@"name"]];
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

- (void)vaultDeleteEvent:(NSNotification *)notification {
    NSDictionary *object = notification.object;
    NSLog(@"Vault item: %@", object);
    
    [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"A vault item was deleted" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

#pragma mark - Helper Methods

- (void)setupSubscriptions {
    // Start getting background push notifications about beacons with the tag 'beacon-tag' beacon created, updated, or deleted
    [[CCHSubscriptionService sharedInstance] addSubscriptionsForTags:@[@"beacon-tag"] options:@[CCHOptionBeacon] completionHandler:^(NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully subscribed to 'beacon-tag' tag");
            
            // Observe notifications about beacons with the tag 'beacon-tag' beacon created, updated, and deleted so our method gets called when that happens
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconCreateEvent:) name:CCHBeaconCreatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconUpdateEvent:) name:CCHBeaconUpdatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconDeleteEvent:) name:CCHBeaconDeletedNotification object:nil];
        } else {
            NSLog(@"Failed to subscribe to 'beacon-tag' tag");
        }
    }];
    
    // Start getting background push notifications about geofences with the tag 'geofence-tag' beacon created, updated, or deleted
    [[CCHSubscriptionService sharedInstance] addSubscriptionsForTags:@[@"geofence-tag"] options:@[CCHOptionGeofence] completionHandler:^(NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully subscribed to 'geofence-tag' tag");
            
            // Observe notifications about geofences with the tag 'geofence-tag' beacon created, updated, and deleted so our method gets called when that happens
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geofenceCreateEvent:) name:CCHGeofenceCreatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geofenceUpdateEvent:) name:CCHGeofenceUpdatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geofenceDeleteEvent:) name:CCHGeofenceDeletedNotification object:nil];
        } else {
            NSLog(@"Failed to subscribe to 'geofence-tag' tag");
        }
    }];
    
    // Start getting background push notifications about vault items with the tag 'vault-tag' beacon created, updated, or deleted
    [[CCHSubscriptionService sharedInstance] addSubscriptionsForTags:@[@"vault-tag"] options:@[CCHOptionVault] completionHandler:^(NSError *error) {
        
        if (!error) {
            NSLog(@"Successfully subscribed to 'vault-tag' tag");
            
            // Observe notifications about vault items with the tag 'vault-tag' beacon created, updated, and deleted so our method gets called when that happens
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vaultCreateEvent:) name:CCHVaultItemCreatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vaultUpdateEvent:) name:CCHVaultItemUpdatedNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vaultDeleteEvent:) name:CCHVaultItemDeletedNotification object:nil];
        } else {
            NSLog(@"Failed to subscribe to 'vault-tag' tag");
        }
    }];
}

#pragma mark - Remote Notifications

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // Register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    // Handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    } else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

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
    
    // Define our fetchCompletionHandler which is called after ContextHub processes our push
    void (^fetchCompletionHandler)(UIBackgroundFetchResult, BOOL) = ^(UIBackgroundFetchResult result, BOOL CCHContextHubPush){
        
        if (CCHContextHubPush) {
            // ContextHub processed this push, just call the Apple completionHandler
            completionHandler (result);
        } else {
            // This push was for our app to process
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
        }
    };
    
    // Let ContextHub process the push
    [[CCHPush sharedInstance] application:application didReceiveRemoteNotification:userInfo completionHandler:fetchCompletionHandler];
}

@end