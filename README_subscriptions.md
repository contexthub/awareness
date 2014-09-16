# Awareness (Context Rule) Sample app

The Awareness sample app also introduces you to the subscription features of the ContextHub iOS SDK.

### Table of Contents

1. **[Purpose](#purpose)**
2. **[ContextHub Use Case](#contexthub-use-case)**
3. **[Background](#background)**
4. **[Getting Started](#getting-started)**
6. **[Triggering Background Updates](#triggering-background-updates)**
9. **[Sample Code](#sample-code)**
10. **[Usage](#usage)**
11. **[Final Words](#final-words)**

## Purpose
This sample application will show you how to use the subscription features of ContextHub so your application can receive real-time updates of changes made to beacon, geofence, and vault items.

## ContextHub Use Case
In this sample application, we use ContextHub to provide the back-end services needed to send background push notifications whenever a beacon, geofence, of vault item a device is subscribed to changes on the server. This allows us to maintain state with the latest information for element services which generate events, as well as vault items which be data crucial to our application.

## Background
Subscriptions in ContextHub
The heart and true purpose of ContextHub involves creating contextual experiences which can be changed without redeploying your application to the app store, allowing far greater developer flexibility during development. In ContextHub, this power is best expressed in context rules, little snippets of JavaScript which are evaluated when every event is fired and allows for the creation of new contextual elements, send push notification to devices, store data in the vault, log a message to the console or fire a webhook to your own or other web services. You will be shown examples of how to use each of these objects in your own context rules to speed up development when using ContextHub.

## Getting Started
1. Get started by either forking or cloning the Awareness repo. Visit [GitHub Help](https://help.github.com/articles/fork-a-repo) if you need help.
2. Go to [ContextHub](http://app.contexthub.com) and create a new Awareness application.
3. Find the app id associated with the application you just created. Its format looks something like this: `13e7e6b4-9f33-4e97-b11c-79ed1470fc1d`.
4. Open up your Xcode project and put the app id into the `[ContextHub registerWithAppId:]` method call.
5. Set up your push certificates (see [NotifyMe](https://github.com/contexthub/notify-me) sample app on how to setup push notifications).
6. Build and run the project on your iOS device.

## Triggering background updates
1. Set up all of the context rules as described in the first README (specifically beacon, geofence, and vault)
2. On your device, tap on the "Beacon", "Geofence", or "Vault" row to see the list of different options. Each option corresponds to a different part of a context rule executing which will also trigger a background notification.
3. Go ahead and tap "create". After a few seconds, you should receive a push notification saying an object was created.
4. Try the same thing with "update". You should get another notification.
5. Try again with "delete". You should get yet another notification. Now, depending on if there are any remaining objects left on ContextHub, if you tap "delete" again, you may not get a notification (meaning there was nothing to delete).
6. Back in the developer portal, you should be able to go to the logs and see what activity was just generated.


## Sample Code
In this sample, the key code is contained in `AWNAppDelegate.m`. A device subscribes to each tag with its corresponding option (beacon, geofence, or vault), then observers are added to either creation, updated, or deletion notifications so your code is called after ContextHub receives a background push about a particular element.

## Usage

##### Subscribing to a tag
```objc
// Subscribing to a tag 
// We want to subscribe to tag "beacon-tag" to be notified when a beacon with that tag is created, updated, or deleted
NSString *tag = @"beacon-tag";
[[CCHSubscriptionService sharedInstance] addSubscriptionForTags:@[tag] options:@[CCHOptionBeacon] completionHandler:^(NSError *error) {

    if (!error) {
        NSLog(@"Subscribed to tag %@ in ContextHub, tag");
    } else {
        NSLog(@"Could not subscribe to tag %@ ContextHub", tag);
    }
}];
```

##### Observing notifications
```objc
// Observe beacon creation
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconCreateEvent:) name:CCHBeaconCreatedNotification object:nil];

// Observe beacon updated
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconUpdateEvent:) name:CCHBeaconUpdatedNotification object:nil];

// Observe beacon deleted
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconDeleteEvent:) name:CCHBeaconDeletedNotification object:nil];

// Handle a notification
- (void)beaconCreateEvent:(NSNotification *)notification {
    // Object contains the object that was just created
    NSDictionary *object = notification.object;
}

- (void)beaconUpdateEvent:(NSNotification *)notification {
    // Object contains the object that was just updated
    NSDictionary *object = notification.object;
}

- (void)beaconDeleteEvent:(NSNotification *)notification {
    // Object contains the id of the object that was just deleted
    NSDictionary *object = notification.object;
}
```

##### Unobserving notifications
```objc
// Unobserve a specific notification
[[NSNotificationCenter defaultCenter] removeObserver:self name:name:CCHBeaconCreatedNotification object:nil]; 

// Unobserve all notifications
[[NSNotificationCenter defaultCenter] removeObserver:self];
```

##### Retrieving subscriptions
```objc
// Getting tag subscriptions
[[CCHSubscriptionService sharedInstance] getSubscriptionsWithCompletion:^(NSDictionary *subscriptions, NSError *error) {

    if (!error) {
        NSArray *beaconSubscriptions = subscriptions[@"BeaconSubscription"];
        NSArray *geofenceSubscriptions = subscriptions[@"GeofenceSubscription"];
        NSArray *vaultSubscriptions subscriptions[@"VaultSubscription"];
    } else {
        NSLog(@"Could not get subscriptions");
    }
}];
```

##### Unsubscribing from a tag
```objc
// Unsubscribing to a tag
NSString *tag = @"beacon-tag";
[[CCHSubscriptionService sharedInstance] removeSubscriptionForTags:@[tag] options:@[CCHOptionBeacon] completionHandler:^(NSError *error) {

    if (!error) {
        NSLog(@"Unsubscribed from tag %@ in ContextHub, tag");
    } else {
        NSLog(@"Could not unsubscribe from tag %@ ContextHub", tag);
    }
}];
```

## Final Words

That's it! Hopefully this sample application showed you that working with subscriptions allows your application to receive real-time updates of elements stored in ContextHub.