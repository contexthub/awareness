//
//  AWNContextObjectTableViewController.m
//  Awareness
//
//  Created by Jeff Kibuule on 8/25/14.
//  Copyright (c) 2014 ChaiOne. All rights reserved.
//

#import "AWNContextObjectTableViewController.h"
#import <ContextHub/ContextHub.h>

#import "AWNConstants.h"

/**
 HTTP event types
 */
typedef NS_ENUM(NSInteger, AWNHTTPEventType) {
    AWNHTTPEventTypeGet = 0,
    AWNHTTPEventTypePost,
};

@interface AWNContextObjectTableViewController ()

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation AWNContextObjectTableViewController

- (void)viewDidLoad {
#ifdef TARGET_IPHONE_SIMULATOR
     // Pop a notification that some features of this sample app only work on actual devices
     [[[UIAlertView alloc] initWithTitle:@"Important!" message:@"Some features of this sample app (receiving push notifications) will only work using a real iOS device." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
#endif
}

#pragma mark - Actions

- (IBAction)eventRowTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Trigger custom event?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = 2;
    [alert show];
}

- (IBAction)consoleRowTapped:(id)sender {
    self.alertView = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Enter the message you want to log:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    self.alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.alertView.tag = 1;
    [self.alertView show];
}

- (IBAction)httpRowTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Trigger what kind of http event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"GET", @"POST", nil];
    alert.tag = 3;
    [alert show];
}

#pragma mark - Event Methods

- (void)triggerConsoleEvent {
    // Trigger the "console_event" event in ContextHub
    // Note: This is just an example of how triggering an event in ContextHub will cause a context rule to be evaluated
    // You can log messages directly from the SDK with [[CCHLog sharedInstance] log:message userInfo:nil completionHandler:nil]
    NSDictionary *consoleEvent = @{@"name": @"console_event", @"data": @{@"message": [self.alertView textFieldAtIndex:0].text } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:consoleEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'console_event' event with message: %@", [self.alertView textFieldAtIndex:0].text);
        } else {
            NSLog(@"Failed to trigger 'console_event' event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'console_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
}

- (void)triggerCustomEvent {
    // Trigger a custom event in ContextHub with no data
    // Fill the data dictionary with the data you want in the event
    NSDictionary *data = @{ };
    NSDictionary *customEvent = @{@"name": @"custom_event", @"data": data };
    [[CCHSensorPipeline sharedInstance] triggerEvent:customEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'custom_event' event");
        } else {
            NSLog(@"Failed to trigger 'custom_event' event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'custom_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
}

- (void)triggerHTTPEventWithType:(AWNHTTPEventType)httpEventType {
    // Trigger the "http_event" event in ContextHub, which in turn will trigger the "console_event" with our custom message
    NSString *eventType = [NSString stringWithFormat:@"%d", (int)httpEventType];
    NSDictionary *httpEvent = @{@"name": @"http_event", @"data": @{ @"event_type": eventType } };
    [[CCHSensorPipeline sharedInstance] triggerEvent:httpEvent completionHandler:^(NSError *error) {
        
        if(!error) {
            NSLog(@"Successfully triggered 'http_event' event type: %@", [self stringFromEventType:httpEventType]);
        } else {
            NSLog(@"Failed to trigger 'http_event' event");
            [[[UIAlertView alloc] initWithTitle:@"ContextHub" message:@"Error triggering 'http_event' event" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
}

#pragma mark - Helper Methods

- (NSString *)stringFromEventType:(AWNHTTPEventType)eventType {
    switch (eventType) {
        case AWNHTTPEventTypeGet:
            
            return @"GET";
        case AWNHTTPEventTypePost:
            
            return @"POST";
        default:
            break;
    }
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            [self triggerConsoleEvent];
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            [self triggerCustomEvent];
        }
    } else if (alertView.tag == 3) {
        if (buttonIndex == 1) {
            // Tapped on the GET button
            [self triggerHTTPEventWithType:AWNHTTPEventTypeGet];
        } else if (buttonIndex == 2) {
            // Tapped on the POST button
            [self triggerHTTPEventWithType:AWNHTTPEventTypePost];
        }
    }
}

@end